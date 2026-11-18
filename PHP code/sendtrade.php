<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userne = (int)$infojs['uid'];
$prosend = (int)$infojs['prosend'];
$prorec = (int)$infojs['prore'];

$creator;


$sql = "SELECT * FROM productslog
          WHERE productid = '$prorec'
          AND userid = '$userne' 
          AND (status = 'creator' OR status = 'purchaser')";
          
          $result = $conn->query($sql);
          
     if($result->num_rows > 0){
          
            http_response_code(400);
     
}

else{
    
    $sql2 = "SELECT products.*, users.id as creatorid
    FROM productslog
    JOIN products ON productslog.productid = products.id
    JOIN users ON productslog.userid = users.id
    WHERE productslog.status = 'creator' AND productslog.productid = '$prorec'";
    
    $result2 = $conn->query($sql2);

    while ($row = $result2->fetch_assoc()) {
        
        
        $creator = $row['creatorid'];
}

$sql3 = "SELECT * FROM productslog
          WHERE productid = '$prosend'
          AND userid = '$creator' 
          AND (status = 'creator' OR status = 'purchaser')";
          
          $result3 = $conn->query($sql3);
          
     if($result3->num_rows > 0){
          
            http_response_code(401);
     
}

else{
    
    $sql4 = "SELECT * FROM trades
            WHERE initiator = $userne AND initiatorP = $prosend AND receiver = $creator AND receiverP = $prorec AND (status = 'Accepted' OR status = 'Pending') ";
            
            $result4 = $conn->query($sql4);
            
            if($result4->num_rows > 0){
                
                http_response_code(402);
                
            }
            
    else{
            $sql5 = "SELECT * FROM trades
            WHERE initiator = $creator AND initiatorP = $prorec AND receiver = $userne AND receiverP = $prosend AND 
                (status = 'Accepted' OR status = 'Pending')";
            
            $result5 = $conn->query($sql5);
            
            if($result5->num_rows > 0){
                
                http_response_code(402);
                
            }
            else{
                
               $sql7 = "SELECT * FROM trades WHERE ((initiator = $userne AND receiver = $creator) OR (initiator = $creator AND receiver = $userne)) AND (status = 'Pending')";

                    $result7 = $conn->query($sql7);

                    if ($result7->num_rows > 0) {
                        
                         http_response_code(402);
                        
                    }
                
                else{
                
                     $sql6 = "INSERT INTO `trades`(`initiator`, `initiatorP`, `receiver`, `receiverP`, `status`) VALUES ('$userne','$prosend','$creator','$prorec','Pending')";
                
                $result6 = $conn->query($sql6);
                
                http_response_code(200);
                }
                         
            }
        
    }
            
    
    
    
}




}









?>