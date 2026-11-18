<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userne = (int)$infojs['uid'];
$proid = (int)$infojs['prid'];

    $sql2 = "SELECT id FROM `cart` WHERE userid = '$userne'";
    $result2 = $conn->query($sql2);

if ($result2->num_rows > 0 && $row = $result2->fetch_assoc()) {
    $cartId = $row['id'];
    
    $sql3 = "DELETE FROM `cartitems` WHERE cart = $cartId AND product = $proid";
    $result3 = $conn->query($sql3);
      http_response_code(200);
    
    
}
else{
    
      http_response_code(400);
}








?>