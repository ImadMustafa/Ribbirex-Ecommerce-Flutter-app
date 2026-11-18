<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userne = (int)$infojs['uid'];
$proid = (int)$infojs['prod'];


$sql = "SELECT * FROM productslog
          WHERE productid = '$proid'
          AND userid = '$userne' 
          AND (status = 'creator' OR status = 'purchaser')";
          
          $result = $conn->query($sql);
          
     if($result->num_rows > 0){
          
            http_response_code(401);
     
}
else{
    
    $sql2 = "SELECT id FROM `cart` WHERE userid = '$userne'";
    $result2 = $conn->query($sql2);

if ($result2->num_rows > 0 && $row = $result2->fetch_assoc()) {
    $cartId = $row['id'];
    
    $sql3 = "SELECT * FROM `cartitems` WHERE cart = $cartId AND product = $proid";
    $result3 = $conn->query($sql3);
    
    if($result3->num_rows > 0){
        
         http_response_code(402);
        
    }
    else{
        
        $sql4 = "INSERT INTO `cartitems`(`cart`, `product`) VALUES ($cartId,$proid)";
        $result4= $conn->query($sql4);
        http_response_code(200);
        
        
    }
    
    
    

    
}




}









?>