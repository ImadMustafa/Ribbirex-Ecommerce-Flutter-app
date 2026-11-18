<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userne = (int)$infojs['uid'];
$total = (int)$infojs['total'];
$balance = 0;


        $sql2 = "SELECT id FROM `cart` WHERE userid = '$userne'";
    $result2 = $conn->query($sql2);

if ($result2->num_rows > 0 && $row = $result2->fetch_assoc()) {
    $cartId = $row['id'];
    
}
    
    $sql3 = "SELECT balance FROM users WHERE users.id = '$userne'";
    $result3 = $conn->query($sql3);
    
    while($row = $result3->fetch_assoc()){
       $balance = $row['balance'];
      
    }
    
    if($balance >= $total){
      $sql4 = "SELECT * FROM `cartitems` WHERE cart = '$cartId'";
    $result4 = $conn->query($sql4);
    
    while ($row = $result4->fetch_assoc()) {
        $productId = $row['product'];
        
    $sql2 = "SELECT products.*, users.id as creatorid
    FROM productslog
    JOIN products ON productslog.productid = products.id
    JOIN users ON productslog.userid = users.id
    WHERE productslog.status = 'creator' AND productslog.productid = '$productId'";
    $result2 = $conn->query($sql2);
    
    while ($row2 = $result2->fetch_assoc()) {
    $proprice = $row2['price'];
    $creator = $row2['creatorid'];
    
    $sqlpur = "UPDATE users
    SET balance = balance - '$proprice'
    WHERE id = '$userne'";
$resultpur = $conn->query($sqlpur);

$sqlpur2 = "UPDATE users
    SET balance = balance + '$proprice'
    WHERE id = '$creator'";
$resultpur2 = $conn->query($sqlpur2);
    
    
$sqldone = "INSERT INTO `productslog`(`productid`, `userid`, `status`) VALUES ($productId,$userne,'purchaser')";
$resdone = $conn->query($sqldone);

        $sqldel = "DELETE FROM `cartitems` WHERE cart = $cartId AND product = $productId";
            $resuld = $conn->query($sqldel);
            
            http_response_code(200);
    
    
    
    
}
        
        
        
        
        
        
    }
    




}

else{
    
     http_response_code(403);
    
}












?>