<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userne = (int)$infojs['uid'];
$proid = (int)$infojs['prod'];
$proprice;
$creator;
$balance;

$sql = "SELECT * FROM productslog
          WHERE productid = '$proid'
          AND userid = '$userne' 
          AND (status = 'creator' OR status = 'purchaser')";
          
          $result = $conn->query($sql);
          
     if($result->num_rows > 0){
          
            http_response_code(400);
     
}

else{
    
    $sql7 = "SELECT * FROM trades
            WHERE (initiatorP = $proid AND status = 'Pending') OR (receiverP = $proid AND status = 'Pending')";
            
            $result7 = $conn->query($sql7);
            
            if($result7->num_rows > 0){
                
                http_response_code(404);
            }
    
    else{
    
    $sql2 = "SELECT products.*, users.id as creatorid
    FROM productslog
    JOIN products ON productslog.productid = products.id
    JOIN users ON productslog.userid = users.id
    WHERE productslog.status = 'creator' AND productslog.productid = '$proid'";
    
    $result2 = $conn->query($sql2);

    while ($row = $result2->fetch_assoc()) {
        
        $proprice = $row['price'];
        $creator = $row['creatorid'];
        
    
    
    $sql3 = "SELECT balance FROM users WHERE users.id = '$userne'";
    $result3 = $conn->query($sql3);
    
    while($row = $result3->fetch_assoc()){
       $balance = $row['balance'];
      
    }
    
    if($balance >= $proprice){
      
   
        $sqlcr = "UPDATE users
        SET balance = balance + '$proprice'
        WHERE id = '$creator' ";
        
        $resultcr = $conn->query($sqlcr);
        
        if($resultcr){
            
        $sqlpur = "UPDATE users
        SET balance = balance - '$proprice'
        WHERE id = '$userne'";
        $resultpur = $conn->query($sqlpur);
        
        if(!$resultpur){
            $sqlcrd = "UPDATE users
        SET balance = balance - $proprice
        WHERE id = $creator";
        $resultcrd = $conn->query($sqlcrd);
        }
        
        else{
            
    $sqldone = "INSERT INTO `productslog`(`productid`, `userid`, `status`) VALUES ($proid,$userne,'purchaser')";
            
            $resdone = $conn->query($sqldone);
            
            
            $sqlgetcart = "SELECT id FROM cart WHERE userid = $userne";
            $resucart = $conn->query($sqlgetcart);
            while($row = $resucart->fetch_assoc()){
                $cartid = $row['id'];
            }
            $sqldel = "DELETE FROM `cartitems` WHERE cart = $cartid AND product = $proid";
            $resuld = $conn->query($sqldel);
            
            http_response_code(200);
            
        }
    

            
        
        }
    
        
    }
    
    else{
        
        http_response_code(403);
        
        
    }
    
    }
    
}
}








?>