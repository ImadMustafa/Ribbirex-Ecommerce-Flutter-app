<?php

include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);
$pid = $infojs['prid'];


$sql = "SELECT 
    CASE 
        WHEN COUNT(*) = COUNT(CASE WHEN status = 'creator' THEN 1 END) 
        THEN 1 
        ELSE 0 
    END AS candelete
FROM productslog
WHERE productid = '$pid'
GROUP BY productid ";


$result = $conn->query($sql);
$row = $result->fetch_assoc();
if($row['candelete'] == 1){
    
    $sql2 = "DELETE FROM `productslog` WHERE productid = $pid";
    $result2 =  $conn->query($sql2);
    
    if($result2){
        
        $sql3 = "DELETE FROM `products` WHERE id = $pid";
        $result3 = $conn->query($sql3);
        http_response_code(200);
        
    }
    
    
}
else{
    
    http_response_code(400);
    
}















?>