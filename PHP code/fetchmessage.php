<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$uidA= (int)$infojs['uidA'];
$uidB = (int)$infojs['uidB'];
$allmessage = [];


$sql = "SELECT `msgid`, `senderid`, `receiverid`, `msg`
        FROM `messages` 
        WHERE `senderid` = $uidA AND `receiverid` = $uidB OR `senderid` = $uidB AND `receiverid` = $uidA";
$result = $conn->query($sql);

$k = 0;
while($result->num_rows > 0 && $row = $result->fetch_assoc()) {
    $senderid = $row['senderid'];
    $receiverid= $row['receiverid'];
    $message = $row['msg'];
    
    $response = array(
        'senderid' => $senderid,
        'receiverid' => $receiverid,
        'message' => $message,
    );
    
    $allmessage[$k] = $response;
    $k++;
    
}  
  header('Content-Type: application/json');
  echo json_encode($allmessage);
    
    http_response_code(200);



?>