DROP DATABASE IF EXISTS Hackathon;
CREATE DATABASE Hackathon;
USE Hackathon;

/*1. Tạo bảng Tạo 4 bảng Users, Categories, Books, Borrows với cấu trúc và kiểu dữ liệu hợp lý. 
Đảm bảo có các khóa chính (PK) và khóa ngoại (FK) để liên kết các bảng */
CREATE TABLE Users (
	user_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE
);
 
CREATE TABLE Categories (
	category_id VARCHAR(5) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Books (
	book_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(100) NOT NULL UNIQUE,
    category_id VARCHAR(5) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK(price >= 0),
    stock INT NOT NULL CHECK(stock >= 0),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Borrows (
	borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(5) NOT NULL,
    book_id VARCHAR(5) NOT NULL,
    status VARCHAR(20) NOT NULL,
    borrow_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- 2. Chèn dữ liệu Thêm dữ liệu vào 4 bảng đã tạo
INSERT INTO Users (user_id, full_name, email, phone) 
VALUES 
	('U01', 'Nguyễn Văn An', 'a@m.com', '0912345678'),
    ('U02', 'Trần Thị Bích', 'b@m.com', '0923456789'),
    ('U03', 'Lê Hoàng Minh', 'mi@m.com', '0934567890'),
    ('U04','Phạm Thu Hà', 'h@m.com', '0945678901'),
    ('U05', 'Võ Quốc Huy', 'hu@gmail.com', '0956789012');
    
INSERT INTO Categories (category_id, category_name) 
VALUES 
	('C01', 'IT'),
    ('C02','Literature'),
    ('C03', 'Science'),
    ('C04', 'History');
    
INSERT INTO Books (book_id, title, category_id, price, stock)
VALUES 
	('B01', 'Clean Code', 'C01', 250000.00, 10),
    ('B02', 'Design Pattern', 'C01', 300000.00, 5),
    ('B03', 'Tat Den', 'C02', 50000.00, 20),
    ('B04', 'Universe', 'C03', 150000.00, 8),
    ('B05', 'Sapiens', 'C04', 200000.00, 15);
    
INSERT INTO Borrows (user_id, book_id, borrow_date, status)
VALUES 
	('U01', 'B01', '2025-10-01', 'Borrowing'),
    ('U02', 'B03', '2025-10-02', 'Returned'),
    ('U01', 'B02', '2025-10-03', 'Returned'),
    ('U04', 'B05', '2025-10-04', 'Lost'),
    ('U05', 'B01', '2025-10-05', 'Borrowing');

-- 3. Sách 'Sapiens' vừa được nhập thêm hàng, hãy tăng stock thêm 10 quyển và tăng price lên 5% 
UPDATE Books 
SET 
	stock = stock + 10,       
    price = price * 1.05
WHERE book_id = 'B05';

-- 4. Cập nhật số điện thoại của user có `user_id = 'U03'` thành `"0999999999"`
UPDATE Users 
SET phone = '0999999999'
WHERE user_id = 'U03';

-- 5. Xóa tất cả các bản ghi mượn sách trong bảng Borrow có trạng thái là 'Returned' và mượn trước ngày '2025-10-03'
DELETE FROM Borrows 
WHERE status = 'Returned' AND borrow_date < '2025-10-03';

-- 6. Liệt kê các sách gồm book_id, title, price có giá đền bù từ 100,000 đến 250,000 và đang có stock > 0
SELECT book_id, title, price 
FROM Books
WHERE price BETWEEN 100000 AND 250000
AND stock > 0;

-- 7. Lấy thông tin full_name, email của những người dùng có họ là 'Nguyen'
SELECT full_name, email 
FROM Users
WHERE full_name LIKE 'Nguyễn%';  

-- 8. Hiển thị danh sách mượn sách gồm borrow_id, user_id, borrow_date. Sắp xếp theo borrow_date giảm dần
SELECT borrow_id, user_id, borrow_date
FROM Borrows
ORDER BY borrow_date DESC;

-- 9.  Lấy ra 3 sách có giá đền bù (price) đắt nhất trong thư viện
SELECT * 
FROM Books
ORDER BY price DESC
LIMIT 3;

-- 10. Hiển thị danh sách title, stock từ bảng Book, bỏ qua 2 sách đầu tiên và lấy 2 sách tiếp theo (Phân trang)
SELECT title, stock
FROM Books 
LIMIT 2 OFFSET 2;

/* 11. Hiển thị danh sách gồm: borrow_id, full_name (của user), title (của book) và borrow_date.  
Chỉ lấy những phiếu đang có trạng thái 'Borrowing' */
SELECT b.borrow_id, u.full_name, bk.title, b.borrow_date 
FROM Borrows AS b
JOIN Users AS u ON b.user_id = u.user_id
JOIN Books AS bk ON b.book_id = bk.book_id
WHERE b.status = 'Borrowing';

/* 12. Liệt kê tất cả các Danh mục (Category) và tựa sách (title) thuộc danh mục đó. 
Hiển thị cả những danh mục chưa có cuốn sách nào. */
SELECT category_name, title 
FROM Categories AS c
LEFT JOIN Books AS b
ON c.category_id = b.category_id;

/* 13. Tính tổng số lượt mượn sách theo từng trạng thái (status). Kết quả gồm hai cột: status và Total_Borrows */
SELECT status, COUNT(borrow_id) AS Total_Borrows
FROM Borrows 
GROUP BY status;

/* 14. Thống kê số lượng sách mà mỗi người dùng đã mượn. Chỉ hiển thị tên người dùng (full_name) có từ 2 lượt mượn trở lên.*/
SELECT u.full_name, COUNT(book_id) AS amount
FROM Borrows AS b
INNER JOIN Users AS u
ON u.user_id = b.user_id
GROUP BY full_name
HAVING amount >= 2;

/* 15. Lấy thông tin chi tiết các cuốn sách (book_id, title, price) có giá đền bù 
nhỏ hơn giá đền bù trung bình của tất cả các cuốn sách trong thư viện*/
SELECT book_id, title, price 
FROM Books
WHERE price < (           
	SELECT AVG(price) FROM Books
);

/* 16. Hiển thị full_name và phone của những người dùng đã từng mượn cuốn sách có tên là 'Clean Code */
SELECT full_name, phone 
FROM Users 
WHERE user_id IN (
	SELECT DISTINCT user_id 
    FROM Borrows 
    WHERE book_id = 'B01'
);