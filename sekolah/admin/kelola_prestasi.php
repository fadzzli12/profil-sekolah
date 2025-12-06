<?php  
require_once '../config.php'; 
requireRole('admin'); 

/* ===========================
   Handle Tambah Prestasi
=========================== */
if (isset($_POST['tambah_prestasi'])) {
    $nama_prestasi = clean($_POST['nama_prestasi']);
    $peringkat     = clean($_POST['peringkat']);
    $tingkat       = clean($_POST['tingkat']);
    $tahun         = intval($_POST['tahun']);
    $keterangan    = clean($_POST['keterangan']);

    $foto = '';
    if (!empty($_FILES['foto']['name'])) {
        $upload = uploadFile($_FILES['foto'], 'prestasi');
        if (isset($upload['error']) && $upload['error'] === false) {
            $foto = $upload['path'];
        }
    }

    $insert = $conn->query("
        INSERT INTO prestasi_sekolah (nama_prestasi, peringkat, tingkat, tahun, keterangan, foto)
        VALUES ('$nama_prestasi', '$peringkat', '$tingkat', $tahun, '$keterangan', '$foto')
    ");

    if ($insert) {
        echo "<script>alert('✓ Prestasi berhasil ditambahkan!'); window.location='kelola_prestasi.php';</script>";
    } else {
        echo "<script>alert('✕ Gagal menambahkan prestasi: {$conn->error}');</script>";
    }
}

/* ===========================
   Handle Update Prestasi
=========================== */
if (isset($_POST['update_prestasi'])) {
    $id            = intval($_POST['id']);
    $nama_prestasi = clean($_POST['nama_prestasi']);
    $peringkat     = clean($_POST['peringkat']);
    $tingkat       = clean($_POST['tingkat']);
    $tahun         = intval($_POST['tahun']);
    $keterangan    = clean($_POST['keterangan']);

    $fotoQuery = "";
    if (!empty($_FILES['foto']['name'])) {
        $upload = uploadFile($_FILES['foto'], 'prestasi');

        if (isset($upload['error']) && $upload['error'] === false) {
            $old = $conn->query("SELECT foto FROM prestasi_sekolah WHERE id = $id")->fetch_assoc();
            if ($old && !empty($old['foto'])) {
                $oldPath = __DIR__ . '/../' . $old['foto'];
                if (file_exists($oldPath)) unlink($oldPath);
            }
            $fotoQuery = ", foto='{$upload['path']}'";
        }
    }

    $update = $conn->query("
        UPDATE prestasi_sekolah 
        SET nama_prestasi='$nama_prestasi', peringkat='$peringkat', tingkat='$tingkat', 
            tahun=$tahun, keterangan='$keterangan' $fotoQuery 
        WHERE id=$id
    ");

    if ($update) {
        echo "<script>alert('✓ Prestasi diperbarui!'); window.location='kelola_prestasi.php';</script>";
    } else {
        echo "<script>alert('✕ Gagal update: {$conn->error}');</script>";
    }
}

/* ===========================
   Handle Hapus Prestasi
=========================== */
if (isset($_GET['hapus'])) {
    $id = intval($_GET['hapus']);
    $d = $conn->query("SELECT foto FROM prestasi_sekolah WHERE id=$id")->fetch_assoc();

    if ($d && !empty($d['foto'])) {
        $path = __DIR__ . '/../' . $d['foto'];
        if (file_exists($path)) unlink($path);
    }

    $conn->query("DELETE FROM prestasi_sekolah WHERE id=$id");
    echo "<script>alert('✓ Prestasi dihapus!'); window.location='kelola_prestasi.php';</script>";
    exit;
}

/* ===========================
   Ambil Data
=========================== */
$editPrestasi   = isset($_GET['edit']) ? $conn->query("SELECT * FROM prestasi_sekolah WHERE id=" . intval($_GET['edit']))->fetch_assoc() : null;
$prestasiQuery  = $conn->query("SELECT * FROM prestasi_sekolah ORDER BY tahun DESC, tingkat DESC");

?>

<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kelola Prestasi - Admin</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>

<div class="dashboard">

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h3>Admin Panel</h3>
        <p><?= htmlspecialchars($_SESSION['nama_lengkap'] ?? '') ?></p>
    </div>

    <ul class="sidebar-menu">
        <li><a href="dashboard.php">📊 Dashboard</a></li>
        <li><a href="profil_sekolah.php">🏫 Profil Sekolah</a></li>
        <li><a href="kelola_guru.php">👨‍🏫 Kelola Guru</a></li>
        <li><a href="kelola_siswa.php">👨‍🎓 Kelola Siswa</a></li>
        <li><a href="kelola_kegiatan.php">📸 Kelola Kegiatan</a></li>
        <li><a class="active" href="kelola_prestasi.php">🏆 Kelola Prestasi</a></li>
        <li><a href="kelola_mapel.php">📚 Mata Pelajaran</a></li>
        <li><a href="../index.php">🏠 Ke Beranda</a></li>
        <li><a href="../logout.php">🚪 Logout</a></li>
    </ul>
</aside>

<!-- MAIN -->
<main class="main-content">
<div class="dashboard-header"><h1>Kelola Prestasi Sekolah</h1></div>

<div class="card">
    <div class="card-header">
        <h2><?= $editPrestasi ? 'Edit Prestasi' : 'Tambah Prestasi' ?></h2>
    </div>

    <form method="POST" enctype="multipart/form-data">
        <?php if($editPrestasi): ?>
        <input type="hidden" name="id" value="<?= $editPrestasi['id'] ?>">
        <?php endif; ?>

        <div class="form-group">
            <label>Nama Prestasi *</label>
            <input type="text" name="nama_prestasi" value="<?= $editPrestasi['nama_prestasi'] ?? '' ?>" required>
        </div>

        <div class="form-group">
            <label>Peringkat *</label>
            <input type="text" name="peringkat" value="<?= $editPrestasi['peringkat'] ?? '' ?>" required>
        </div>

        <div class="form-group">
            <label>Tingkat *</label>
            <select name="tingkat" required>
                <option value="">-- Pilih Tingkat --</option>
                <?php foreach(['Kecamatan','Kota','Provinsi','Nasional','Internasional'] as $t): ?>
                    <option value="<?= $t ?>" <?= ($editPrestasi['tingkat'] ?? '')==$t?'selected':'' ?>>
                        <?= $t ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="form-group">
            <label>Tahun *</label>
            <input type="number" name="tahun" min="2000" max="<?= date("Y")+1 ?>" value="<?= $editPrestasi['tahun'] ?? date("Y") ?>" required>
        </div>

        <div class="form-group">
            <label>Keterangan</label>
            <textarea name="keterangan" rows="3"><?= $editPrestasi['keterangan'] ?? '' ?></textarea>
        </div>

        <div class="form-group">
            <label>Foto Prestasi</label>
            <?php if($editPrestasi && $editPrestasi['foto']): ?>
                <img src="../<?= $editPrestasi['foto'] ?>" style="width:250px;margin:10px 0;border-radius:8px">
            <?php endif; ?>
            <input type="file" name="foto" accept="image/*">
        </div>

        <?php if($editPrestasi): ?>
            <button name="update_prestasi" class="btn btn-primary">💾 Update</button>
            <a href="kelola_prestasi.php" class="btn btn-secondary">Batal</a>
        <?php else: ?>
            <button name="tambah_prestasi" class="btn btn-primary">➕ Tambah</button>
        <?php endif; ?>
    </form>
</div>

<!-- Table -->
<div class="card">
    <div class="card-header"><h2>Daftar Prestasi</h2></div>

    <div class="table-responsive">
        <table>
            <thead>
                <tr>
                    <th>Foto</th><th>Nama</th><th>Peringkat</th><th>Tingkat</th><th>Tahun</th><th>Aksi</th>
                </tr>
            </thead>

            <tbody>
            <?php if($prestasiQuery->num_rows): while($p=$prestasiQuery->fetch_assoc()): ?>
                <tr>
                    <td>
                        <?php if($p['foto']): ?>
                            <img src="../<?= $p['foto'] ?>" style="width:70px;height:55px;object-fit:cover;border-radius:5px">
                        <?php else: ?>
                            <div style="width:70px;height:55px;background:#ddd;border-radius:5px;display:flex;align-items:center;justify-content:center">🏆</div>
                        <?php endif; ?>
                    </td>
                    <td><?= $p['nama_prestasi'] ?></td>
                    <td><?= $p['peringkat'] ?></td>
                    <td><?= $p['tingkat'] ?></td>
                    <td><?= $p['tahun'] ?></td>
                    <td>
                        <a href="?edit=<?= $p['id'] ?>" class="btn btn-secondary">✏ Edit</a>
                        <a href="?hapus=<?= $p['id'] ?>" onclick="return confirm('Hapus data?')" class="btn btn-danger">🗑 Hapus</a>
                    </td>
                </tr>
            <?php endwhile; else: ?>
                <tr><td colspan="6" style="text-align:center;padding:20px">Belum ada data.</td></tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>

</main>
</div>
</body>
</html>
