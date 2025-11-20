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

--Mencoba pelanggaran unique
INSERT INTO Pelanggan (NamaDepan, Email)
VALUES ('Budi', 'budi.santoso@email.com');
GO
