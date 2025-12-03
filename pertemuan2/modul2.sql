--Hapus Database TokoRetail
IF DB_ID('TokoRetail1DB') IS NOT NULL
BEGIN
	USE master;
	DROP DATABASE TokoRetail1DB;
END
GO

--Buat Database baru
CREATE DATABASE TokoRetailDB;
GO

--Gunakan database tersebut
USE TokoRetailDB;
GO

--1. Buat tabel Kategori
CREATE TABLE KategoriProduk (
	KategoriID INT IDENTITY(1,1) PRIMARY KEY,
	NamaKategori VARCHAR(100) NOT NULL UNIQUE
);
GO

/* 2. Buat tabel Produk */
CREATE TABLE Produk (
	ProdukID INT IDENTITY(1001, 1) PRIMARY KEY,
	SKU VARCHAR(20) NOT NULL UNIQUE,
	NamaProduk  VARCHAR(150) NOT NULL,
	Harga DECIMAL(10, 2) NOT NULL,
	Stok INT NOT NULL,
	KategoriID INT NULL,

	--cara menulis constraint
	--CONSTRAINT nama_constraint jenis_constraint (nama kolom yang akan ditambah constraint)
	CONSTRAINT CHK_HargaPositif CHECK (Harga >= 0),
	CONSTRAINT CHK_StokPositif CHECK (Stok >= 0),
	CONSTRAINT FK_Produk_Kategori 
	FOREIGN KEY (KategoriID)
	REFERENCES KategoriProduk(KategoriID)
);
GO

-- 3. Membuat Tabel Pelanggan
CREATE TABLE Pelanggan (
	PelangganID INT IDENTITY(1,1) PRIMARY KEY,
	NamaDepan VARCHAR(50) NOT NULL,
	NamaBelakang VARCHAR(50) NULL,
	Email VARCHAR(100) NOT NULL UNIQUE,
	NoTelepon VARCHAR(20) NULL,
	TanggalDaftar DATE DEFAULT GETDATE()
);
GO

--4. Buat tabel Pesanan Header
CREATE TABLE PesananHeader(
	PesananID INT IDENTITY(50001,1) PRIMARY KEY,
	PelangganID INT NOT NULL,
	TanggalPesanan DATETIME2 DEFAULT GETDATE(),
	StatusPesanan VARCHAR(20) NOT NULL,

	CONSTRAINT CHK_StatusPesanan CHECK (StatusPesanan IN ('Baru', 'Proses',
'Selesai', 'Batal')),
	CONSTRAINT FK_Pesanan_Pelanggan
	FOREIGN KEY (PelangganID)
	REFERENCES Pelanggan(PelangganID)
);
GO

--Membuat Tabel Pesanan Detail
CREATE TABLE PesananDetail(
	PesananDetailID INT IDENTITY(1,1) PRIMARY KEY,
	PesananID INT NOT NULL,
	ProdukID INT NOT NULL,
	Jumlah INT NOT NULL,
	HargaSatuan DECIMAL(10, 2) NOT NULL, -- Harga saat barang itu dibeli

	CONSTRAINT CHK_JumlahPositif CHECK (Jumlah > 0),
	--FK PesananDetail & PesananHeader
	CONSTRAINT FK_Detail_Header
		FOREIGN KEY (PesananID)
		REFERENCES PesananHeader(PesananID)
		ON DELETE CASCADE, -- Jika Header dihapus, detail ikut terhapus
		
	CONSTRAINT FK_Detail_Produk
		FOREIGN KEY (ProdukID)
		REFERENCES Produk(ProdukID)
);
GO

--1. Memasukkan data Pelanggan 
-- Sintaks eksplisit (Best Practice)
INSERT INTO Pelanggan (NamaDepan, NamaBelakang, Email, NoTelepon)
VALUES
('Budi', 'Santoso', 'budi.santoso@email.com', '081234567890'),
('Citra', 'Lestari', 'citra.lestari@email.com', NULL);


--Verifikasi Data
PRINT 'Data Pelanggan:';
SELECT * 
FROM Pelanggan;

-- 2. Memasukkan data Kategori (Multi-row) 
INSERT INTO KategoriProduk (NamaKategori)
VALUES
('Elektronik'),
('Pakaian'),
('Buku');

PRINT 'Data Pelanggan:';
SELECT * 
FROM KategoriProduk;

--Menambah Data ke Tabel Produk
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES
('ELEC-001', 'Laptop Pro 14 inch', 15000000.00, 50, 1),
('PAK-001', 'Kaos Polos Putih', 75000.00, 200, 2);

PRINT 'Data Produk:';
SELECT * 
FROM Produk;

/* 1. Pelanggaran UNIQUE Constraint */
-- Error: Mencoba mendaftarkan email yang SAMA dengan Budi Santoso
INSERT INTO Pelanggan (NamaDepan, Email)
VALUES ('Budi', 'budi.santoso@email.com');
GO

/* 2. Pelanggaran FOREIGN KEY Constraint */
-- Error: Mencoba memasukkan produk dengan KategoriID 99 (tidak ada di tabel KategoriProduk)
PRINT 'Uji Coba Error 2 (FOREIGN KEY):';
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES ('XXX-001', 'Produk Aneh', 1000, 10, 99);
GO

/* 3. Pelanggaran CHECK Constraint */
-- Error: Mencoba memasukkan harga negatif
PRINT 'Uji Coba Error 3 (CHECK):';
INSERT INTO Produk (SKU, NamaProduk, Harga, Stok, KategoriID)
VALUES ('NGT-001', 'Produk Minus', -50000, 10, 1);
GO

/* Cek data SEBELUM di-update */
PRINT 'Data Citra SEBELUM Update:';
SELECT * FROM Pelanggan WHERE PelangganID = 2;

BEGIN TRANSACTION; -- Mulai zona aman

UPDATE Pelanggan
SET NoTelepon = '085566778899'
WHERE PelangganID = 2; -- Klausa WHERE sangat penting!

/* Cek data SETELAH di-update (masih di dalam transaksi) */
PRINT 'Data Citra SETELAH Update (Belum di-COMMIT):';
SELECT * FROM Pelanggan WHERE PelangganID = 2;

-- Jika sudah yakin, jadikan permanen
COMMIT TRANSACTION;

-- Jika ragu, ganti COMMIT dengan ROLLBACK
PRINT 'Data Citra setelah di-COMMIT:';
SELECT * FROM Pelanggan WHERE PelangganID = 2;

PRINT 'Data Elektronik SEBELUM Update:';
SELECT * FROM Produk WHERE KategoriID = 1;

BEGIN TRANSACTION;

UPDATE Produk
SET Harga = Harga * 1.10 -- Operasi aritmatika pada nilai kolom
WHERE KategoriID = 1;

PRINT 'Data Elektronik SETELAH Update (Belum di-COMMIT):';

SELECT * FROM Produk WHERE KategoriID = 1;

-- Cek apakah ada kesalahan? Jika tidak, commit.
COMMIT TRANSACTION;

PRINT 'Data Produk SEBELUM Delete:';
SELECT * FROM Produk WHERE SKU = 'BUK-001';
BEGIN TRANSACTION;
DELETE FROM Produk
WHERE SKU = 'BUK-001';
PRINT 'Data Produk SETELAH Delete (Belum di-COMMIT):';
SELECT * FROM Produk WHERE SKU = 'BUK-001'; -- Harusnya kosong
COMMIT TRANSACTION;

/* Cek data stok. Harusnya 50 dan 200 */
PRINT 'Data Stok SEBELUM Bencana:';
SELECT SKU, NamaProduk, Stok FROM Produk;
BEGIN TRANSACTION; -- WAJIB! Ini adalah jaring pengaman kita.
-- BENCANA TERJADI: Lupa klausa WHERE!
UPDATE Produk
SET Stok = 0;
/* Cek data setelah bencana. SEMUA STOK JADI 0! */
PRINT 'Data Stok SETELAH Bencana (PANIK!):';
SELECT SKU, NamaProduk, Stok FROM Produk;

-- JANGAN COMMIT! BATALKAN!
PRINT 'Melakukan ROLLBACK...';
ROLLBACK TRANSACTION;
/* Cek data setelah diselamatkan */
PRINT 'Data Stok SETELAH di-ROLLBACK (AMAN):';
SELECT SKU, NamaProduk, Stok FROM Produk;

/* 1. Buat 1 pesanan untuk Budi */
INSERT INTO PesananHeader (PelangganID, StatusPesanan)
VALUES (1, 'Baru');
PRINT 'Data Pesanan Budi:';
SELECT * FROM PesananHeader WHERE PelangganID = 1;
GO
/* 2. Coba hapus Pelanggan Budi (PelangganID 1) */
PRINT 'Mencoba menghapus Budi...';
BEGIN TRANSACTION;
DELETE FROM Pelanggan
WHERE PelangganID = 1;
-- Perintah ini akan GAGAL!
ROLLBACK TRANSACTION; -- Batalkan (walaupun sudah gagal)



/* 1. Buat tabel arsip (DDL) */
CREATE TABLE ProdukArsip (
ProdukID INT PRIMARY KEY, -- Tanpa IDENTITY
SKU VARCHAR(20) NOT NULL,
NamaProduk VARCHAR(150) NOT NULL,
Harga DECIMAL(10, 2) NOT NULL,
TanggalArsip DATE DEFAULT GETDATE()
);
GO
BEGIN TRANSACTION;
/* 2. Habiskan stok Kaos (SKU PAK-001) */
UPDATE Produk SET Stok = 0 WHERE SKU = 'PAK-001';
/* 3. Salin data dari Produk ke ProdukArsip (INSERT ... SELECT) */
INSERT INTO ProdukArsip (ProdukID, SKU, NamaProduk, Harga)
SELECT ProdukID, SKU, NamaProduk, Harga
FROM Produk
WHERE Stok = 0;
/* 4. Hapus data yang sudah diarsip dari tabel Produk */
DELETE FROM Produk
WHERE Stok = 0;
/* Verifikasi */
PRINT 'Cek Produk Aktif (Kaos harus hilang):';
SELECT * FROM Produk;
PRINT 'Cek Produk Arsip (Kaos harus ada):';
SELECT * FROM ProdukArsip;
-- Jika yakin, commit
COMMIT TRANSACTION;
