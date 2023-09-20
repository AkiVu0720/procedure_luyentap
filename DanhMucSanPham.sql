/*
	1. Tạo bảng Danh mục sản phẩm gồm các thông tin sau:
    - Mã danh mục - int - PK - auto increment
    - Tên danh mục - varchar(50) - not null - unique
    - Mô tả - text
    - Trạng thái - bit - default 1
    */
create  table DanhMucSp(
    maDanhMuc int primary key auto_increment,
    tenDanhMuc varchar(50) not null unique,
    moTa text,
    trangThai bit default 1
);

    /*
    2. Tạo bảng sản phẩm gồm các thông tin sau:
    - Mã sản phẩm - varchar(5) - PK
    - Tên sản phẩm - varchar(100) - not null - unique
    - Ngày tạo - date - default currentDate
    - Giá - float - default 0
    - Mô tả sản phẩm - text
    - Tiêu đề - varchar(200)
    - Mã danh mục - int - FK references Danh mục
    - Trạng thái - bit - default 1*/
    create table SanPham(
        maSp varchar(5) primary key,
        tenSp varchar(100) not null  unique,
        ngayTao date default( CURRENT_DATE),
        gia float default 0,
        motaSp text,
        tieuDe varchar(200),
        maDanhMuc int,
        foreign key (maDanhMuc) references DanhMucSp (maDanhMuc),
        trangThai bit default 1
    );
   
    INSERT INTO SanPham value('Sp101','Sữa Bột', 2023-8-9 , 20000,'Nhật Bản','Sữa', 1,1);
    INSERT INTO SanPham value('Sp102','Nước Chanh', '2023-8-11' , 10000,'Nhật Bản','ngọt', 1,1);
    INSERT INTO SanPham value('Sp103','Coca-Cola', '2023-3-4' , 5000,'Nhật Bản','Nước ngọt', 1,1);
    INSERT INTO SanPham value('Sp201','Táo', '2023-5-3' , 4000,'Nhật Bản','Hoa quả', 2,1);
    INSERT INTO SanPham value('Sp202','Lê', '2023-6-9' , 1500,'Nhật Bản','Hoa quả', 2,1);
    INSERT INTO SanPham value('Sp203','Ổi', '2023-7-11' , 2000,'Nhật Bản','Hoa quả', 2,1);
    INSERT INTO SanPham value('Sp301','Áo thun', '2023-5-12' , 90000,'Nhật Bản','Nam', 3,1);
    INSERT INTO SanPham value('Sp302','Quần kaki', '2023-3-5' , 120000,'Nhật Bản','Nữ', 3,1);
    INSERT INTO SanPham value('Sp303','Socola', '2023-2-4' , 2000,'Nhật Bản','Socola', 4,1);
    
    select * from SanPham;
    
    -- 3. Thêm các dữ liệu vào 2 bảng
    
    INSERT INTO DanhMucSp (tenDanhMuc,moTa,trangThai) VALUES ('Do uong', 'Nhap Khau',0);
    INSERT INTO DanhMucSp (tenDanhMuc,moTa,trangThai) VALUES ('Hoa Qua', 'Trong Nuoc',1);
    INSERT INTO DanhMucSp (tenDanhMuc,moTa,trangThai) VALUES ('Quan Ao', 'Nam Nu',1);
    INSERT INTO DanhMucSp (tenDanhMuc,moTa,trangThai) VALUES ('Banh Keo', 'Trung Quoc',0);
	select * from DanhMucSp;

    /*
    4. Tạo view gồm các sản phẩm có giá lớn hơn 20000 gồm các thông tin sau: 
    mã danh mục, tên danh mục, trạng thái danh mục, mã sản phẩm, tên sản phẩm, 
    giá sản phẩm, trạng thái sản phẩm
    */
    Create view productPriceup20k
    as
    select dm.maDanhMuc,
    dm.tenDanhMuc,
    dm.trangThai as 'T.T Danh Mục',
    sp.maSp,
    sp.tenSp,
    sp.gia,
    sp.trangThai as 'T.T Sản Phẩm'
    from DanhMucSp dm join SanPham sp on dm.maDanhMuc = sp.maDanhMuc
    where sp.gia >20000;
    
    
    -- 5. Tạo các procedure sau:
    /* procedure cho phép thêm, sửa, xóa, lấy tất cả dữ liệu, lấy dữ liệu theo mã
     của bảng danh mục và sản phẩm 
     */
     
     /*
     procedure cho phép lấy ra tất cả các phẩm có trạng thái là 1
     bao gồm mã sản phẩm, tên sản phẩm, giá, tên danh mục, trạng thái sản phẩm
     */
     DELIMITER //
     Create procedure get_status_1(
     )
     Begin
     select
     sp.maSP,
     sp.tenSp,
     sp.gia,
     sp.trangThai,
     dm.tenDanhMuc
     From DanhMucSp dm join SanPham sp on dm.maDanhMuc = sp.maDanhMuc
     where dm.trangThai = 1;
     End//
     DELIMITER ;
     
     /* 
     procedure cho phép thống kê số sản phẩm theo từng mã danh mục
     */
     DELIMITER //
     Create procedure statisticGroup (
     )
     Begin 
     select 
     dm.maDanhMuc,
     dm.tenDanhMuc,
     COUNT(*) as 'Tổng sp'
     From DanhMucSp dm left join SanPham sp on dm.maDanhMuc = sp.maDanhMuc
     Group by dm.maDanhMuc ;
     end;
     DELIMITER;

    /* procedure cho phép tìm kiếm sản phẩm theo tên sản phầm: mã sản phẩm, tên
       sản phẩm, giá, trạng thái sản phẩm, tên danh mục, trạng thái danh mục */
       DELIMITER //
     Create procedure timTheoMaSp (
     maSp varchar(5)
     )
     Begin 
     select *
     From SanPham sp
     where sp.maSp =  masp;
     end;
     DELIMITER;
     -- tìm kiếm theo tên
      DELIMITER //
     Create procedure timTheoTenSp (
     tenSptimKiem varchar(100)
     )
     Begin 
     declare ten_tim_kiem varchar(102);
     set ten_tim_kiem = concat('%',tenSptimKiem,'%' );
     select *
     From SanPham sp
     where sp.tenSp like ten_tim_kiem;
     end;
     DELIMITER;
       -- tìm kiếm theo giá
         DELIMITER //
     Create procedure timTheoGiaSp (
     giaSp float
     )
     Begin 
     select *
     From SanPham sp
     where sp.gia = giaSp;
     end;
     DELIMITER;
       -- tìm kiếm theo tên danh mục
         DELIMITER //
     Create procedure timTheoTenDanhMuc (
     tenDanhMuctimKiem varchar(50)
     )
     Begin 
     declare ten_tim_kiem varchar(102);
     set ten_tim_kiem = concat('%',tenDanhMuctimKiem,'%' );
     select *
     From SanPham sp join DanhMucSp dm on dm.maDanhMuc = sp.maDanhMuc
     where dm.tenDanhMuc like ten_tim_kiem;
     end;
     DELIMITER;
       -- tìm kiếm theo trạng thái danh mục
