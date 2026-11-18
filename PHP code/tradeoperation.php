<?php


include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$tradeid = (int)$infojs['tradeid'];
$key = (int)$infojs['key'];

if($key == 1){
    $sql5 = "SELECT status FROM trades WHERE id = $tradeid";
    $result5 = $conn->query($sql5);
    
    if ($result5->num_rows > 0) {
        $row = $result5->fetch_assoc();
        $status = $row['status'];
        
    
     if($status == 'Pending'){ 
    $sql2 = "UPDATE `trades` SET `status` = 'Accepted' WHERE id = $tradeid";
    $result2 = $conn->query($sql2);
    
    if($result2){
        
        $sql3 = "SELECT `initiator`, `initiatorP`, `receiver`, `receiverP` FROM `trades` WHERE id = $tradeid";
        $result3 = $conn->query($sql3);
        
        while ($row = $result3->fetch_assoc()){
            
            $sender = $row['initiator'];
            $senderp = $row['initiatorP'];
            $receiver = $row['receiver'];
            $receiverp = $row['receiverP'];
            
            $sqlswitch = "INSERT INTO `productslog`(`productid`, `userid`, `status`)
                VALUES ($senderp,$receiver,'purchaser'), ($receiverp,$sender,'purchaser')";
                
                $resultsw = $conn->query($sqlswitch);
                
            $sqlgetcartsender = "SELECT id FROM cart WHERE userid = $sender";
            $resucart = $conn->query($sqlgetcartsender);
            while($row = $resucart->fetch_assoc()){
                $sendercartid = $row['id'];
            }
            $sqldel = "DELETE FROM `cartitems` WHERE cart = $sendercartid AND product = $receiverp";
            $resuld = $conn->query($sqldel);
            
             $sqlgetcartreceiver = "SELECT id FROM cart WHERE userid = $receiver";
            $resucarts = $conn->query($sqlgetcartreceiver);
            while($row = $resucarts->fetch_assoc()){
                $receivercartid = $row['id'];
            }
            $sqldel2 = "DELETE FROM `cartitems` WHERE cart = $receivercartid AND product = $senderp";
            $resuld2 = $conn->query($sqldel2);
            
            
            
            
            
            http_response_code(200);
                
        }
        
        
    }
    
    
}
else{
    
    http_response_code(400);
}
}
}


if($key == 2){
    
$sql4 = "SELECT status FROM trades WHERE id = $tradeid";
 $result4 = $conn->query($sql4);
    
    if ($result4->num_rows > 0) {
        $row = $result4->fetch_assoc();
        $status = $row['status'];
    
if($status == 'Pending'){
$sql = "UPDATE `trades` SET `status`='Rejected' WHERE id = $tradeid";

$result =  $conn->query($sql);
if($result){
    
    http_response_code(201);
}

}

else{
    http_response_code(400);
}
    
}

}






?>