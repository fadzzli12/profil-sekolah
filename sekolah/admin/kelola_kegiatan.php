<?php
require_once '../config.php';
requireRole('admin');

// Handle Tambah Kegiatan
if (isset($_POST['tambah_kegiatan'])) {
    $judul = $conn->real_escape_string($_POST['judul']);
    $deskripsi = $conn->real_escape_string($_POST['deskripsi']);
    $tanggal = $conn->real_escape_string($_POST['tanggal_kegiatan']);
    
    // Upload foto FIX
    $foto = '';
    if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
        $upload = uploadFile($_FILES['foto'], 'kegiatan');
        if (!$upload['error']) $foto = $upload['path']; // hanya simpan path di DB
    }

    $conn->query("INSERT INTO kegiatan_sekolah (judul, deskripsi, foto, tanggal_kegiatan) 
                  VALUES ('$judul', '$deskripsi', '$foto', '$tanggal')");
    echo "<script>alert('✓ Kegiatan berhasil ditambahkan!'); window.location.href='kelola_kegiatan.php';</script>";
}

// Handle Update Kegiatan
if (isset($_POST['update_kegiatan'])) {
    $id = intval($_POST['id']);
    $judul = $conn->real_escape_string($_POST['judul']);
    $deskripsi = $conn->real_escape_string($_POST['deskripsi']);
    $tanggal = $conn->real_escape_string($_POST['tanggal_kegiatan']);
    
    // Upload foto baru jika ada FIX
    $fotoQuery = "";
    if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
        $upload = uploadFile($_FILES['foto'], 'kegiatan');
        if (!$upload['error']) {
            $foto = $upload['path'];
            $fotoQuery = ", foto = '$foto'";
        }
    }

    $conn->query("UPDATE kegiatan_sekolah SET 
                    judul = '$judul', 
                    deskripsi = '$deskripsi', 
                    tanggal_kegiatan = '$tanggal'
                    $fotoQuery
                  WHERE id = $id");

    echo "<script>alert('✓ Kegiatan berhasil diperbarui!'); window.location.href='kelola_kegiatan.php';</script>";
}

// Handle Hapus
if (isset($_GET['hapus'])) {
    $id = intval($_GET['hapus']);
    $conn->query("DELETE FROM kegiatan_sekolah WHERE id = $id");
    echo "<script>alert('✓ Kegiatan berhasil dihapus!'); window.location.href='kelola_kegiatan.php';</script>";
}

// Ambil data
$editKegiatan = null;
if (isset($_GET['edit'])) {
    $id = intval($_GET['edit']);
    $editKegiatan = $conn->query("SELECT * FROM kegiatan_sekolah WHERE id = $id")->fetch_assoc();
}

$kegiatanQuery = $conn->query("SELECT * FROM kegiatan_sekolah ORDER BY tanggal_kegiatan DESC");
?>
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kelola Kegiatan - Admin</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="dashboard">
    
<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h3>Admin Panel</h3>
        <p style="font-size: 0.9rem; opacity: 0.8;"><?= $_SESSION['nama_lengkap'] ?></p>
    </div>
    
    <ul class="sidebar-menu">
        <li><a href="dashboard.php">📊 Dashboard</a></li>
        <li><a href="profil_sekolah.php">🏫 Profil Sekolah</a></li>
        <li><a href="kelola_guru.php">👨‍🏫 Kelola Guru</a></li>
        <li><a href="kelola_siswa.php">👨‍🎓 Kelola Siswa</a></li>
        <li><a href="kelola_kegiatan.php" class="active">📸 Kelola Kegiatan</a></li>
        <li><a href="kelola_prestasi.php">🏆 Kelola Prestasi</a></li>
        <li><a href="kelola_mapel.php">📚 Mata Pelajaran</a></li>
        <li><a href="../index.php">🏠 Ke Beranda</a></li>
        <li><a href="../logout.php">🚪 Logout</a></li>
    </ul>
</aside>

<!-- Main -->
<main class="main-content">
    <div class="dashboard-header">
        <h1 class="dashboard-title">Kelola Kegiatan Sekolah</h1>
    </div>

    <div class="card">
        <div class="card-header">
            <h2 class="card-title"><?= $editKegiatan ? 'Edit Kegiatan' : 'Tambah Kegiatan Baru' ?></h2>
        </div>
        
        <form method="POST" enctype="multipart/form-data">
            <?php if ($editKegiatan): ?>
                <input type="hidden" name="id" value="<?= $editKegiatan['id'] ?>">
            <?php endif; ?>
            
            <div class="form-group">
                <label>Judul Kegiatan *</label>
                <input type="text" name="judul" value="<?= $editKegiatan['judul'] ?? '' ?>" required>
            </div>
            
            <div class="form-group">
                <label>Tanggal *</label>
                <input type="date" name="tanggal_kegiatan" value="<?= $editKegiatan['tanggal_kegiatan'] ?? '' ?>" required>
            </div>
            
            <div class="form-group">
                <label>Deskripsi *</label>
                <textarea name="deskripsi" rows="5" required><?= $editKegiatan['deskripsi'] ?? '' ?></textarea>
            </div>
            
            <div class="form-group">
                <label>Foto Kegiatan</label>
                <?php if ($editKegiatan && $editKegiatan['foto']): ?>
                    <div style="margin-bottom: 1rem;">
                        <img src="../<?= $editKegiatan['foto'] ?>" style="max-width: 300px;border-radius:8px;">
                    </div>
                <?php endif; ?>
                <input type="file" name="foto" accept="image/*">
                <small style="color:#6b7280;">Format JPG/PNG, maks 5MB</small>
            </div>

            <?php if ($editKegiatan): ?>
                <button type="submit" name="update_kegiatan" class="btn btn-primary">💾 Update</button>
                <a href="kelola_kegiatan.php" class="btn btn-secondary">✕ Batal</a>
            <?php else: ?>
                <button type="submit" name="tambah_kegiatan" class="btn btn-primary">➕ Tambah</button>
            <?php endif; ?>
        </form>
    </div>

    <div class="card">
        <div class="card-header"><h2 class="card-title">Daftar Kegiatan</h2></div>
        <div class="table-responsive">
            <table>
                <thead>
                    <tr><th>Foto</th><th>Judul</th><th>Tanggal</th><th>Deskripsi</th><th>Aksi</th></tr>
                </thead>
                <tbody>
                <?php while($kegiatan = $kegiatanQuery->fetch_assoc()): ?>
                <tr>
                    <td>
                    <?php if($kegiatan['foto']): ?>
                        <img src="../<?= $kegiatan['foto'] ?>" style="width:80px;height:60px;border-radius:5px;object-fit:cover;">
                    <?php else: ?>
                        <div style="width:80px;height:60px;border-radius:5px;background:linear-gradient(135deg,#667eea,#764ba2);display:flex;align-items:center;justify-content:center;color:#fff;">📸</div>
                    <?php endif; ?>
                    </td>

                    <td><b><?= $kegiatan['judul'] ?></b></td>
                    <td><?= formatTanggal($kegiatan['tanggal_kegiatan']) ?></td>
                    <td><?= substr($kegiatan['deskripsi'],0,100) ?>...</td>
                    <td>
                        <a href="?edit=<?= $kegiatan['id'] ?>" class="btn btn-secondary">✏ Edit</a>
                        <a href="?hapus=<?= $kegiatan['id'] ?>" onclick="return confirm('Hapus kegiatan ini?')" class="btn btn-danger">🗑 Hapus</a>
                    </td>
                </tr>
                <?php endwhile; ?>
                </tbody>
            </table>
        </div>
    </div>

</main>
</div>
</body>
</html>
