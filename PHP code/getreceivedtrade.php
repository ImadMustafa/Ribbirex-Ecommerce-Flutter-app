<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userid = (int) $infojs['uid'];

$prodlist = [];


$sql = "SELECT t.id AS tradeid,t.initiator,ip.id AS senderPid,ip.name AS senderPn,ip.desc AS senderPd,ip.price AS senderPp,ip.img AS senderPimg,t.receiver,rp.id AS receiverPid,
    rp.name AS receiverPn,rp.desc AS receiverPd,rp.price AS receiverPp,rp.img AS receiverPimg, 
    u.username as receiverusername
FROM trades AS t
JOIN products AS ip ON t.initiatorP = ip.id
JOIN products AS rp ON t.receiverP = rp.id
JOIN productslog AS pl ON pl.productid = rp.id
JOIN users AS u ON pl.userid = u.id
WHERE t.status = 'Pending' AND t.receiver = $userid AND pl.status = 'Creator'";

   $result = $conn->query($sql);

    $k = 0;
    while ($row = $result->fetch_assoc() and $k < mysqli_num_rows($result)){
        
    $initid = $row['initiator'];
    
    $sql2 = "SELECT username FROM users WHERE id = $initid";
    $result2 = $conn->query($sql2);
    $row2 = $result2->fetch_assoc();

    
    $tradeid = $row['tradeid'];
    $initpid = $row['senderPid'];
    $initpname = $row['senderPn'];
    $initpdesc = $row['senderPd'];
    $initprice = $row['senderPp'];
    $initpimg = $row['senderPimg'];
    
    $recid = $row['receiver'];
    $recpid = $row['receiverPid'];
    $recpname = $row['receiverPn'];
    $recpdesc = $row['receiverPd'];
    $recprice = $row['receiverPp'];
    $recpimg = $row['receiverPimg'];
    $initusername = $row2['username'];
    
    
    $response = array(
        'tradeid' => $tradeid,
        'senderid' => $initid,
        'senderpid' => $initpid,
        'senderpname' => $initpname,
        'senderpdesc' => $initpdesc,
        'senderprice' => $initprice,
        'senderpimg' => $initpimg,
        'receiverid' => $recid,
        'receiverpid' => $recpid,
        'receiverpname' => $recpname,
        'receiverpdesc' => $recpdesc,
        'receiverprice' => $recprice,
        'receiverpimg' => $recpimg,
        'senderuser' => $initusername
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    http_response_code(200);


    
  
    



?>