-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2025 at 05:42 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sekolah`
--

-- --------------------------------------------------------

--
-- Table structure for table `absensi`
--

CREATE TABLE `absensi` (
  `id` int(11) NOT NULL,
  `kelas_virtual_id` int(11) DEFAULT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `status` enum('hadir','izin','sakit','alpha') DEFAULT 'hadir',
  `waktu_absen` timestamp NOT NULL DEFAULT current_timestamp(),
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `absensi`
--

INSERT INTO `absensi` (`id`, `kelas_virtual_id`, `siswa_id`, `status`, `waktu_absen`, `keterangan`) VALUES
(1, 1, 1, 'hadir', '2025-11-08 04:06:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `guru`
--

CREATE TABLE `guru` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `nip` varchar(30) DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `mata_pelajaran` varchar(50) DEFAULT NULL,
  `pendidikan` varchar(50) DEFAULT NULL,
  `kontak` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tampil_di_beranda` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `guru`
--

INSERT INTO `guru` (`id`, `user_id`, `nip`, `nama`, `foto`, `mata_pelajaran`, `pendidikan`, `kontak`, `email`, `tampil_di_beranda`, `created_at`) VALUES
(1, 2, '197501012000121001', 'Drs. Ahmad Yani, M.Pd', NULL, 'Matematika', 'S2 Pendidikan Matematika', '08123456789', 'ahmad.yani@email.com', 1, '2025-11-08 04:00:49'),
(2, 3, '198002152005012002', 'Sri Wahyuni, S.Pd', NULL, 'Bahasa Indonesia', 'S1 Pendidikan Bahasa Indonesia', '08234567890', 'sri.wahyuni@email.com', 1, '2025-11-08 04:00:49');

-- --------------------------------------------------------

--
-- Table structure for table `kegiatan_sekolah`
--

CREATE TABLE `kegiatan_sekolah` (
  `id` int(11) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `tanggal_kegiatan` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kegiatan_sekolah`
--

INSERT INTO `kegiatan_sekolah` (`id`, `judul`, `deskripsi`, `foto`, `tanggal_kegiatan`, `created_at`, `updated_at`) VALUES
(1, 'Upacara Hari Kemerdekaan', 'Peringatan HUT RI ke-79 dengan upacara bendera yang dihadiri oleh seluruh siswa, guru, dan staff sekolah. Dilanjutkan dengan berbagai lomba tradisional.', NULL, '2024-08-17', '2025-11-08 04:00:49', '2025-11-08 04:00:49'),
(2, 'Pentas Seni Sekolah', 'Pentas seni tahunan yang menampilkan berbagai kreativitas siswa mulai dari tari, musik, drama, hingga fashion show.', NULL, '2024-09-15', '2025-11-08 04:00:49', '2025-11-08 04:00:49'),
(4, 'Seminar Pendidikan Karakter', 'Seminar dengan narasumber dari Kementerian Pendidikan tentang pentingnya pendidikan karakter di era digital.', NULL, '2024-11-12', '2025-11-08 04:00:49', '2025-11-08 04:00:49'),
(5, 'coding', 'aku suka coding', 'Array', '2025-11-07', '2025-11-18 04:04:27', '2025-11-18 04:04:27'),
(6, 'coding', 'wow', 'Array', '2025-11-14', '2025-11-18 04:19:04', '2025-11-18 04:19:04');

-- --------------------------------------------------------

--
-- Table structure for table `kelas_virtual`
--

CREATE TABLE `kelas_virtual` (
  `id` int(11) NOT NULL,
  `mapel_id` int(11) DEFAULT NULL,
  `tanggal` date NOT NULL,
  `topik` varchar(200) DEFAULT NULL,
  `status` enum('aktif','selesai') DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas_virtual`
--

INSERT INTO `kelas_virtual` (`id`, `mapel_id`, `tanggal`, `topik`, `status`, `created_at`) VALUES
(1, 1, '2025-11-08', 'Trigonometri', 'selesai', '2025-11-08 04:06:19'),
(2, 5, '2025-11-08', 'web', 'selesai', '2025-11-08 04:12:44'),
(3, 5, '2025-11-08', 'web dev', 'aktif', '2025-11-08 04:23:57'),
(4, 1, '2025-11-08', 'Modulus', 'aktif', '2025-11-08 08:55:52');

-- --------------------------------------------------------

--
-- Table structure for table `mata_pelajaran`
--

CREATE TABLE `mata_pelajaran` (
  `id` int(11) NOT NULL,
  `kode_mapel` varchar(10) NOT NULL,
  `nama_mapel` varchar(100) NOT NULL,
  `guru_id` int(11) DEFAULT NULL,
  `kelas` varchar(20) NOT NULL,
  `hari` enum('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu') DEFAULT NULL,
  `jam_mulai` time DEFAULT NULL,
  `jam_selesai` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mata_pelajaran`
--

INSERT INTO `mata_pelajaran` (`id`, `kode_mapel`, `nama_mapel`, `guru_id`, `kelas`, `hari`, `jam_mulai`, `jam_selesai`) VALUES
(1, 'MAT-X1', 'Matematika', 1, 'X-1', 'Senin', '07:30:00', '09:00:00'),
(2, 'BIN-X1', 'Bahasa Indonesia', 2, 'X-1', 'Selasa', '07:30:00', '09:00:00'),
(3, 'MAT-X2', 'Matematika', 1, 'X-2', 'Rabu', '09:15:00', '10:45:00'),
(4, 'BIN-X2', 'Bahasa Indonesia', 2, 'X-2', 'Kamis', '09:15:00', '10:45:00'),
(5, 'prog web', 'web data', NULL, 'XI-1', 'Selasa', '12:11:00', '15:11:00'),
(9, 'prog', 'web ', NULL, 'X-1', 'Selasa', '12:13:00', '12:16:00');

-- --------------------------------------------------------

--
-- Table structure for table `nilai`
--

CREATE TABLE `nilai` (
  `id` int(11) NOT NULL,
  `siswa_id` int(11) DEFAULT NULL,
  `mapel_id` int(11) DEFAULT NULL,
  `jenis_nilai` enum('tugas','uts','uas','praktek') NOT NULL,
  `nilai` decimal(5,2) DEFAULT NULL,
  `keterangan` varchar(200) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nilai`
--

INSERT INTO `nilai` (`id`, `siswa_id`, `mapel_id`, `jenis_nilai`, `nilai`, `keterangan`, `tanggal`, `created_at`) VALUES
(1, 1, 1, 'tugas', 90.00, 'bab 1', '2025-11-08', '2025-11-08 08:56:51'),
(2, 1, 1, 'tugas', 20.00, 'bab 1', '2025-11-08', '2025-11-08 08:57:09');

-- --------------------------------------------------------

--
-- Table structure for table `prestasi_sekolah`
--

CREATE TABLE `prestasi_sekolah` (
  `id` int(11) NOT NULL,
  `nama_prestasi` varchar(255) NOT NULL,
  `peringkat` varchar(50) NOT NULL,
  `tingkat` enum('Kecamatan','Kota','Provinsi','Nasional','Internasional') NOT NULL,
  `tahun` year(4) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prestasi_sekolah`
--

INSERT INTO `prestasi_sekolah` (`id`, `nama_prestasi`, `peringkat`, `tingkat`, `tahun`, `keterangan`, `foto`, `created_at`, `updated_at`) VALUES
(5, 'Futsal UCL', 'JUARA 1', 'Internasional', '2025', 'wow', 'Array', '2025-11-08 08:53:14', '2025-11-08 08:53:14');

-- --------------------------------------------------------

--
-- Table structure for table `profil_sekolah`
--

CREATE TABLE `profil_sekolah` (
  `id` int(11) NOT NULL,
  `nama_sekolah` varchar(100) NOT NULL,
  `alamat` text NOT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `visi` text DEFAULT NULL,
  `misi` text DEFAULT NULL,
  `jumlah_siswa_aktif` int(11) DEFAULT 0,
  `jumlah_guru_aktif` int(11) DEFAULT 0,
  `jumlah_ruang_kelas` int(11) DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `profil_sekolah`
--

INSERT INTO `profil_sekolah` (`id`, `nama_sekolah`, `alamat`, `telepon`, `email`, `visi`, `misi`, `jumlah_siswa_aktif`, `jumlah_guru_aktif`, `jumlah_ruang_kelas`, `updated_at`) VALUES
(1, 'SMA N 89 Jakarta', 'Jl. Pendidikan No. 123, Makassar, Sulawesi Selatan 90111', '0411-123456', 'info@sman1makassar.sch.id', 'Menjadi sekolah yang unggul dalam prestasi, berkarakter, dan berwawasan global pada tahun 2030', '1. Menyelenggarakan pendidikan berkualitas tinggi yang berpusat pada siswa\r\n2. Mengembangkan potensi siswa secara optimal melalui pembelajaran inovatif\r\n3. Membentuk karakter siswa yang berakhlak mulia dan bertanggung jawab\r\n4. Meningkatkan kompetensi guru melalui pelatihan berkelanjutan\r\n5. Membangun kerjasama yang harmonis dengan stakeholder pendidikan', 57, 25, 12, '2025-11-08 09:23:36');

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `nis` varchar(30) DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `kelas` varchar(20) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`id`, `user_id`, `nis`, `nama`, `kelas`, `foto`, `created_at`) VALUES
(1, 4, '2024001', 'Andi Pratama', 'X-1', NULL, '2025-11-08 04:00:49'),
(2, 5, '2024002', 'Siti Nurhaliza', 'X-1', NULL, '2025-11-08 04:00:49'),
(3, 6, '2024003', 'Budi Santoso', 'X-1', NULL, '2025-11-08 04:00:49'),
(4, 7, '2024004', 'Dewi Lestari', 'X-1', NULL, '2025-11-08 04:00:49'),
(6, 11, '1231423', 'kirik', 'X-1', 'siswa/690ed624971d3_1762580004.png', '2025-11-08 05:33:24');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','guru','siswa') NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `nama_lengkap`, `created_at`) VALUES
(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Administrator Sistem', '2025-11-08 04:00:49'),
(2, 'guru1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'guru', 'Drs. Ahmad Yani, M.Pd', '2025-11-08 04:00:49'),
(3, 'guru2', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'guru', 'Sri Wahyuni, S.Pd', '2025-11-08 04:00:49'),
(4, 'siswa1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'siswa', 'Andi Pratama', '2025-11-08 04:00:49'),
(5, 'siswa2', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'siswa', 'Siti Nurhaliza', '2025-11-08 04:00:49'),
(6, 'siswa3', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'siswa', 'Budi Santoso', '2025-11-08 04:00:49'),
(7, 'siswa4', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'siswa', 'Dewi Lestari', '2025-11-08 04:00:49'),
(8, 'julian', '$2y$10$8TwylKQk4nYPLBStz11WdeXlunW5JudAO2z6FFs0oKEWUBL8Cvb3O', 'guru', 'julian fadzli', '2025-11-08 04:10:46'),
(9, 'indra', '$2y$10$3huGrJNIa7sRqOlp.vhbKOYeK.Te2m6cMwAUNiXDXx96F2nXF0wEW', 'siswa', 'indra', '2025-11-08 05:04:18'),
(11, 'kontol', '$2y$10$0V7Dl7jdMlhblrz6pxa6ou7zuJTQVEvRbfQci8pN7DZ6t7mHIUsKe', 'siswa', 'kirik', '2025-11-08 05:33:24'),
(12, 'mbut', '$2y$10$9fLuurfQJZ6h2axqZEIV2uG7idM.J9N3EjdIejGfBK.rA0wsr5Aba', 'guru', 'joko', '2025-11-08 05:34:51'),
(14, 'kono', '$2y$10$jOQ6cQgh39jEfW7sZYK7b.HN2rvYoqrieQxwk8BTZq8dotNyv04gC', 'guru', 'amba', '2025-11-08 08:39:45'),
(17, 'ladusing', '$2y$10$NMCrRZx8EArjXfsZqoDFNeOR8Usd/uR0nBmbyWfm3E.OtJkxvUPTa', 'guru', 'naufal', '2025-11-18 03:47:56');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absensi`
--
ALTER TABLE `absensi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_absen` (`kelas_virtual_id`,`siswa_id`),
  ADD KEY `siswa_id` (`siswa_id`);

--
-- Indexes for table `guru`
--
ALTER TABLE `guru`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nip` (`nip`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `kegiatan_sekolah`
--
ALTER TABLE `kegiatan_sekolah`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kelas_virtual`
--
ALTER TABLE `kelas_virtual`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mapel_id` (`mapel_id`);

--
-- Indexes for table `mata_pelajaran`
--
ALTER TABLE `mata_pelajaran`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode_mapel` (`kode_mapel`),
  ADD KEY `guru_id` (`guru_id`);

--
-- Indexes for table `nilai`
--
ALTER TABLE `nilai`
  ADD PRIMARY KEY (`id`),
  ADD KEY `siswa_id` (`siswa_id`),
  ADD KEY `mapel_id` (`mapel_id`);

--
-- Indexes for table `prestasi_sekolah`
--
ALTER TABLE `prestasi_sekolah`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `profil_sekolah`
--
ALTER TABLE `profil_sekolah`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nis` (`nis`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absensi`
--
ALTER TABLE `absensi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `guru`
--
ALTER TABLE `guru`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `kegiatan_sekolah`
--
ALTER TABLE `kegiatan_sekolah`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `kelas_virtual`
--
ALTER TABLE `kelas_virtual`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `mata_pelajaran`
--
ALTER TABLE `mata_pelajaran`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `nilai`
--
ALTER TABLE `nilai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `prestasi_sekolah`
--
ALTER TABLE `prestasi_sekolah`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `profil_sekolah`
--
ALTER TABLE `profil_sekolah`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absensi`
--
ALTER TABLE `absensi`
  ADD CONSTRAINT `absensi_ibfk_1` FOREIGN KEY (`kelas_virtual_id`) REFERENCES `kelas_virtual` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `absensi_ibfk_2` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guru`
--
ALTER TABLE `guru`
  ADD CONSTRAINT `guru_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `kelas_virtual`
--
ALTER TABLE `kelas_virtual`
  ADD CONSTRAINT `kelas_virtual_ibfk_1` FOREIGN KEY (`mapel_id`) REFERENCES `mata_pelajaran` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `mata_pelajaran`
--
ALTER TABLE `mata_pelajaran`
  ADD CONSTRAINT `mata_pelajaran_ibfk_1` FOREIGN KEY (`guru_id`) REFERENCES `guru` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `nilai`
--
ALTER TABLE `nilai`
  ADD CONSTRAINT `nilai_ibfk_1` FOREIGN KEY (`siswa_id`) REFERENCES `siswa` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `nilai_ibfk_2` FOREIGN KEY (`mapel_id`) REFERENCES `mata_pelajaran` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `siswa`
--
ALTER TABLE `siswa`
  ADD CONSTRAINT `siswa_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
