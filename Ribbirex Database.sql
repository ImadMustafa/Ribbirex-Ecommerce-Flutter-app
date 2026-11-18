-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 10, 2024 at 05:53 AM
-- Server version: 10.5.20-MariaDB
-- PHP Version: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id22099167_trddb12`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `userid`) VALUES
(3563, 86),
(3643, 99),
(3646, 358034),
(75, 679993);

-- --------------------------------------------------------

--
-- Table structure for table `cartitems`
--

CREATE TABLE `cartitems` (
  `cartitemid` int(11) NOT NULL DEFAULT lpad(floor(rand() * 1000000),6,'0'),
  `cart` int(11) NOT NULL,
  `product` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`) VALUES
(1, 'Fonts'),
(2, 'Images'),
(3, 'Videos'),
(4, 'Code'),
(5, 'Audio'),
(6, '3D'),
(7, 'EBooks'),
(8, 'Templates'),
(9, 'Softwares'),
(10, 'Design');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `msgid` int(11) NOT NULL,
  `senderid` int(11) NOT NULL,
  `receiverid` int(11) NOT NULL,
  `msg` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`msgid`, `senderid`, `receiverid`, `msg`) VALUES
(13, 86, 99, 'yes'),
(14, 86, 99, 'hello'),
(15, 86, 99, 'hello'),
(16, 86, 99, 'hi buddy'),
(17, 86, 99, 'hi'),
(18, 86, 99, 'bye'),
(19, 86, 100, 'hi there'),
(20, 86, 100, 'hi again'),
(27, 86, 100, 'hi'),
(30, 86, 100, 'are you seeing this message?'),
(31, 100, 86, 'hello'),
(32, 99, 86, 'big bang'),
(33, 99, 86, 'big bang'),
(34, 99, 86, 'big bang'),
(35, 99, 86, 'yes'),
(36, 99, 86, 'ye'),
(37, 99, 86, 'yes'),
(38, 99, 86, 'thanks'),
(39, 99, 86, 'yo'),
(40, 99, 86, 'best'),
(41, 99, 86, 'asd'),
(74577, 86, 99, 'hey'),
(74578, 99, 86, 'hi'),
(745765, 86, 99, 'how u doing'),
(745766, 99, 86, 'i am doing good you'),
(7457633, 86, 99, 'fine'),
(7457634, 99, 86, 'hi'),
(7457635, 99, 86, 'yo'),
(7457636, 99, 86, 'yes'),
(7457637, 86, 99, 'bh'),
(7457638, 99, 86, 'hwhw'),
(7457639, 86, 99, 'hi'),
(7457640, 99, 86, 'hi'),
(7457641, 99, 86, 'sdf'),
(7457642, 100, 99, 'hi'),
(7457643, 99, 100, 'hi'),
(7457644, 99, 100, 'hi'),
(7457645, 100, 99, 'imad'),
(7457646, 100, 99, 'ur Rayan'),
(7457647, 99, 100, 'hi'),
(7457648, 99, 86, 'Hi How are you'),
(7457649, 86, 99, 'hello'),
(7457650, 99, 86, 'Good'),
(7457651, 86, 99, 'hahahahah'),
(7457652, 99, 86, 'lmao'),
(7457653, 99, 86, 'gg'),
(7457654, 86, 99, 'XD'),
(7457655, 99, 86, 'Yes Its good everything working'),
(7457656, 86, 99, 'yes yes');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL DEFAULT (floor(rand() * 900000) + 100000),
  `categoryid` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `desc` text NOT NULL,
  `price` int(11) NOT NULL,
  `img` longtext NOT NULL,
  `file` text NOT NULL,
  `tradeable` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `categoryid`, `name`, `desc`, `price`, `img`, `file`, `tradeable`) VALUES
(126486, 4, 'testtrasw888', 'ahshsh', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(164924, 5, 'testxx88', 'sbsbsb', 10, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(173788, 2, 'Dragon Ball Super', 'Dragon Ball Super has captivated fans worldwide and continues the thrilling.', 28, 'https://testribbi24.000webhostapp.com/image/prodimg/Culture_DragonBallBroly.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(212636, 6, '3D Head Polygon', 'Introducing the 3D Head Polygon, a cutting-edge marvel merging artistry with technology to redefine your digital expressions. Crafted with precision and innovation, this revolutionary product transforms the mundane into the extraordinary, offering a seamless blend of aesthetics and functionality.', 21, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyvluAPUlCc9ftMFLeMaFX-O3AbojES5scuw&s', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(222112, 10, '1200plus Ps Brush Bundle', 'Introducing the ultimate arsenal for digital artists and graphic designers – the \"1200plus Ps Brush Bundle\". Unleash your creativity and elevate your artwork with this comprehensive collection of premium Photoshop brushes, meticulously curated to cater to every creative whim and professional need.', 12, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNkzBfKz1ouXHr6dYn4EqqvkUhvSS0DZVqeg&s', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(222113, 5, 'VocalChop Soundpack', 'Introducing the \"VocalChop Soundpack\" – your ultimate companion for crafting dynamic and captivating music productions. Dive into a world of sonic innovation with this meticulously curated collection of vocal chops, designed to add depth, emotion, and intrigue to your tracks.', 34, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAebp1IzZz1GNCvoMMi8qAkIRvViPegh1JuQ&s', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 0),
(259668, 2, 'Testxx8', 'haahsh', 10, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(265385, 2, 'snsb', 'bzsb', 33, 'https://testribbi24.000webhostapp.com/image/prodimg/Culture_DragonBallBroly.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(304833, 6, 'testcart2', 'sbshsh', 33, 'https://testribbi24.000webhostapp.com/image/prodimg/download.jpeg.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(342688, 6, '3d head', '3d head', 43, 'https://testribbi24.000webhostapp.com/image/prodimg/1000100472.png', 'https://testribbi24.000webhostapp.com/prozip/product.zip', 0),
(349939, 4, 'testtradecar', 'sbsb', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/download.jpeg.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(379173, 6, 'testxx3', 'ahsh', 10, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(417762, 10, 'Treepack PS brushes', 'tree pack for photoshop', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/1000100477.png', 'https://testribbi24.000webhostapp.com/prozip/product-1.zip', 1),
(452620, 3, 'Test8000', 'sbsbsbs', 33, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(461476, 4, 'testxx1', 'sjshsb', 10, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(504659, 4, 'testcart1', 'sbsbsb', 79, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(515201, 3, 'Ultra888', 'hedhdhxh', 33, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(515203, 3, 'testfade9999', 'shshs', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/download.jpeg.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(527919, 3, 'Testzzz', 'sbsh', 10, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(546985, 5, 'tesr888888', 'zbsbs', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(593351, 5, 'Testxx9', 'sbshs', 10, 'https://testribbi24.000webhostapp.com/image/prodimg/eatgok.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(595132, 3, 'Test99', 'hshs', 33, 'https://testribbi24.000webhostapp.com/image/prodimg/download.jpeg.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(628633, 6, 'Low Polygon Head', 'Low Polygon Head', 15, 'https://testribbi24.000webhostapp.com/image/prodimg/1000100473.jpg', 'https://testribbi24.000webhostapp.com/prozip/product.zip', 1),
(670089, 2, 'One Piece Characters', 'One Piece Image 4K', 12, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(678505, 3, 'cinematic video ads', 'cinematic videos ads', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/1000100478.jpg', 'https://testribbi24.000webhostapp.com/prozip/product-1.zip', 1),
(682827, 7, 'shsh', 'ahahs', 33, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(693524, 5, 'shsh', 'yssgsgsh', 31, 'https://testribbi24.000webhostapp.com/image/prodimg/Culture_DragonBallBroly.jpg', 'https://testribbi24.000webhostapp.com/prozip/product.zip', 1),
(727208, 5, 'Testxx', 'sbsbs', 10, 'https://testribbi24.000webhostapp.com/image/prodimg/one-piece-4k-luffy-and-trafalgar-d2uvmkicl7mliu72.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(840869, 6, 'test82828', 'shshshs', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/download.jpeg.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(852460, 2, 'tes9999999', 'sbsbs', 30, 'https://testribbi24.000webhostapp.com/image/prodimg/eatgok.jpg', 'https://testribbi24.000webhostapp.com/prozip/Talkyou.zip', 1),
(946582, 10, 'BrushPack Procreate', 'brush pack for procreate. use it for creativity.', 18, 'https://testribbi24.000webhostapp.com/image/prodimg/1000100470.jpg', 'https://testribbi24.000webhostapp.com/prozip/CSCI335_Online Baker Project_ Mohamad Awik & Imad AlDeen Mustapha.zip', 1),
(965603, 2, 'SocialMedia Illustration Pack', 'SocialMedia Illustration Pack', 6, 'https://testribbi24.000webhostapp.com/image/prodimg/1000100469.png', 'https://testribbi24.000webhostapp.com/prozip/product.zip', 1);

-- --------------------------------------------------------

--
-- Table structure for table `productslog`
--

CREATE TABLE `productslog` (
  `logid` int(11) NOT NULL DEFAULT (floor(rand() * 900000) + 100000),
  `productid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `status` enum('creator','purchaser') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `productslog`
--

INSERT INTO `productslog` (`logid`, `productid`, `userid`, `status`) VALUES
(212106, 852460, 99, 'purchaser'),
(253256, 342688, 86, 'creator'),
(425626, 693524, 99, 'creator'),
(523626, 852460, 358034, 'creator'),
(525546, 628633, 99, 'purchaser'),
(568286, 595132, 99, 'creator'),
(789284, 546985, 358034, 'creator'),
(836660, 670089, 99, 'purchaser'),
(885918, 546985, 99, 'purchaser'),
(917748, 342688, 99, 'purchaser'),
(3252525, 670089, 679993, 'creator'),
(6363535, 628633, 86, 'creator');

-- --------------------------------------------------------

--
-- Table structure for table `trades`
--

CREATE TABLE `trades` (
  `id` int(11) NOT NULL DEFAULT (floor(rand() * 900000) + 100000),
  `initiator` int(11) NOT NULL,
  `initiatorP` int(11) NOT NULL,
  `receiver` int(11) NOT NULL,
  `receiverP` int(11) NOT NULL,
  `status` enum('Pending','Accepted','Cancelled','Rejected') NOT NULL,
  `creationD` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL DEFAULT (floor(rand() * 900000) + 100000),
  `username` varchar(255) NOT NULL DEFAULT concat('user',lpad(floor(rand() * 100000),6,'0')),
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `pimg` text NOT NULL DEFAULT 'https://testribbi24.000webhostapp.com/image/usersimg/ribbirexdefault.png',
  `balance` float NOT NULL DEFAULT 0,
  `verified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `pimg`, `balance`, `verified`) VALUES
(86, 'Exile', 'exiledeen24@gmail.com', 'exileexile', 'https://testribbi24.000webhostapp.com/image/usersimg/1000100289.jpg', 58, 1),
(99, 'UserBetaX', 'fecice8201@acname.com', '12345678', 'https://testribbi24.000webhostapp.com/image/usersimg/dragon-ball-z-4k-pc-axpvihiowkabrq42.jpg', 570, 1),
(100, 'ImadMustafa', 'imadmustafa24@gmail.com', 'imadimad', 'https://testribbi24.000webhostapp.com/image/usersimg/1000097658.jpg', 10, 1),
(358034, 'user081603', 'nahari9085@godsigma.com', '12345678', 'https://testribbi24.000webhostapp.com/image/usersimg/ribbirexdefault.png', 60, 1),
(679993, 'ArtistM', 'artistmuslim24@gmail.com', 'artistmuslim12', 'https://testribbi24.000webhostapp.com/image/usersimg/1000100553.jpg', 12, 1);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `createcart` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO cart (userid)
    VALUES (NEW.id);
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `cartitems`
--
ALTER TABLE `cartitems`
  ADD PRIMARY KEY (`cartitemid`),
  ADD KEY `cart` (`cart`),
  ADD KEY `product` (`product`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`msgid`),
  ADD KEY `receiverid` (`receiverid`),
  ADD KEY `senderid` (`senderid`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryid` (`categoryid`);

--
-- Indexes for table `productslog`
--
ALTER TABLE `productslog`
  ADD PRIMARY KEY (`logid`),
  ADD KEY `productid` (`productid`),
  ADD KEY `userid` (`userid`);

--
-- Indexes for table `trades`
--
ALTER TABLE `trades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `initiator` (`initiator`),
  ADD KEY `initiatorP` (`initiatorP`),
  ADD KEY `receiver` (`receiver`),
  ADD KEY `receiverP` (`receiverP`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3647;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `msgid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7457657;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`id`);

--
-- Constraints for table `cartitems`
--
ALTER TABLE `cartitems`
  ADD CONSTRAINT `cartitems_ibfk_1` FOREIGN KEY (`cart`) REFERENCES `cart` (`id`),
  ADD CONSTRAINT `cartitems_ibfk_2` FOREIGN KEY (`product`) REFERENCES `products` (`id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`receiverid`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`senderid`) REFERENCES `users` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`categoryid`) REFERENCES `category` (`id`);

--
-- Constraints for table `productslog`
--
ALTER TABLE `productslog`
  ADD CONSTRAINT `productslog_ibfk_1` FOREIGN KEY (`productid`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `productslog_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `users` (`id`);

--
-- Constraints for table `trades`
--
ALTER TABLE `trades`
  ADD CONSTRAINT `trades_ibfk_1` FOREIGN KEY (`initiator`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `trades_ibfk_2` FOREIGN KEY (`receiver`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `trades_ibfk_3` FOREIGN KEY (`initiatorP`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `trades_ibfk_4` FOREIGN KEY (`receiverP`) REFERENCES `products` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
