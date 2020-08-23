CREATE DATABASE lad6
GO

USE lad6
GO

CREATE TABLE NguoiMua
(
	IDKH VARCHAR(10) PRIMARY KEY,
	TenKH NVARCHAR(50),
	DiaChi NVARCHAR(50),
	SDT CHAR(10),
	--CONSTRAINT fk_sdt CHECK (SDT NOT LIKE '%[^0-9]%')
)
GO

CREATE TABLE SanPham
(
	IDSP VARCHAR(10) PRIMARY KEY,
	TenSP NVARCHAR(20),
	MoTaSP NVARCHAR(50),
	GiaBan MONEY CHECK (GiaBan>0),
)
GO

CREATE TABLE DonDatHang(
	IDDon INT PRIMARY KEY,
	IDKH VARCHAR(10),
	SoLuong INT CHECK (SoLuong >0),
	NgatDat DATETIME,
	TongTien MONEY,
	CONSTRAINT fk_nguoimua FOREIGN KEY (IDKH) REFERENCES NguoiMua(IDKH)
)
GO 

CREATE TABLE DonHangChiTiet(
	IDKH VARCHAR(10),
	IDDon INT PRIMARY KEY,
	IDSP VARCHAR(10),
	GiaBan MONEY CHECK (GiaBan >0 ),
	SoLuong INT,
	CONSTRAINT fk_sanpham FOREIGN KEY ( IDSP) REFERENCES SanPham(IDSP),
	CONSTRAINT fk_khachhang FOREIGN KEY (IDKH) REFERENCES NguoiMua(IDKH)
)

GO 


INSERT INTO NguoiMua VALUES ('1',N'Nguyễn Văn An',N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội','987654321')
INSERT INTO NguoiMua VALUES ('2',N'lê hoàng minh ',N'Long Biên,Hà Nội','123456789')
INSERT INTO NguoiMua VALUES ('3',N'Hoàng Minh Thu',N'Tây Hồ,Hà Nội','123456789')

INSERT INTO SanPham VALUES ('123',N'Máy Tính T450',N'Máy Nhập Mới','1000')
INSERT INTO SanPham VALUES ('456',N'Điện Thoại Nokia5670',N'Điện Thoại Đang Hot','200')
INSERT INTO SanPham VALUES ('789',N'Máy In Samsung450',N'Máy In Đang Ế','100')

INSERT INTO DonDatHang VALUES ('123','112',1,'2011-18-09','1000')
INSERT INTO DonDatHang VALUES ('124','113',2,'2020-02-12','400')
INSERT INTO DonDatHang VALUES ('125','114',1,'2020-04-26','100')

INSERT INTO DonHangChiTiet VALUES ('112','11','123','1000',1)
INSERT INTO DonHangChiTiet VALUES ('112','12','345','400',2)
INSERT INTO DonHangChiTiet VALUES ('112','13','567','100',1)

--Liệt kê danh sách khách hàng theo thứ thự alphabet.
 SELECT * FROM NguoiMua ORDER BY TenKH

 --Liệt kê danh sách sản phẩm của cửa hàng theo thứ thự giá giảm dần.
SELECT * FROM SanPham ORDER BY GiaBan DESC

--Liệt kê các sản phẩm mà khách hàng Nguyễn Văn An đã mua.
SELECT NguoiMua.TenKH, SanPham.TenSP, SanPham.MoTaSP, DonHangChiTiet.IDSP FROM SanPham 
INNER JOIN DonHangChiTiet ON SanPham.IDSP = DonHangChiTiet.IDSP
INNER JOIN NguoiMua ON NguoiMua.IDKH = DonHangChiTiet.IDKH 
WHERE TenKH = N'Nguyễn Văn An' 

--Số khách hàng đã mua ở cửa hàng.
SELECT TenKH,COUNT(*) AS SLKH FROM NguoiMua
GROUP BY TenKH

--Số mặt hàng mà cửa hàng bán.
SELECT TenSP,DonHangChiTiet.IDSP,SoLuong FROM DonHangChiTiet 
INNER JOIN SanPham ON DonHangChiTiet.IDSP = SanPham.IDSP
SELECT  TenSP,DonHangChiTiet.IDSP,SoLuong AS 'SoLuongDaBan' FROM  SanPham 
INNER JOIN DonHangChiTiet ON DonHangChiTiet.IDSP = SanPham.IDSP

--Tổng tiền của từng đơn hàng.
SELECT TenKH,SUM(GiaBan) AS 'Tong Tien' FROM DonHangChiTiet,NguoiMua GROUP BY TenKH 
SELECT * FROM SanPham, DonHangChiTiet

--Viết câu lệnh để thay đổi trường giá tiền của từng mặt hàng là dương(>0).
ALTER TABLE SanPham ADD CONSTRAINT Sk_SanPham CHECK (GiaBan > 0)

--Viết câu lệnh để thay đổi ngày đặt hàng của khách hàng phải nhỏ hơn ngày hiện tại.
ALTER TABLE DonDatHang ADD CONSTRAINT date_DatHang CHECK (NgatDat > GETDATE())

--Viết câu lệnh để thêm trường ngày xuất hiện trên thị trường của sản phẩm.
ALTER TABLE SanPham ADD NgayXuatHien DATETIME CHECK (NgayXuatHien < GETDATE())


