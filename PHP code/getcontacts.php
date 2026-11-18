<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$uidA= (int)$infojs['uidA'];
$allMessages = [];

$sql = "SELECT m.`msgid`, m.`senderid`, m.`receiverid`, m.`msg`, 
        u.`username` AS sender_username, u.`pimg` AS sender_pimg,
        u2.`username` AS receiver_username, u2.`pimg` AS receiver_pimg
        FROM `messages` m
        JOIN `users` u ON m.`senderid` = u.`id`
        JOIN `users` u2 ON m.`receiverid` = u2.`id`
        WHERE (m.`senderid` = $uidA OR m.`receiverid` = $uidA)
        AND m.`msgid` IN (
            SELECT MAX(`msgid`) AS max_msgid
            FROM `messages`
            WHERE `senderid` = $uidA OR `receiverid` = $uidA
            GROUP BY CASE
                WHEN `senderid` = $uidA THEN `receiverid`
                ELSE `senderid`
            END
        )
        ORDER BY m.`msgid` DESC"; 


$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
    $senderid = $row['senderid'];
    $receiverid = $row['receiverid'];
    $message = $row['msg'];
    $senderUsername = $row['sender_username'];
    $receiverUsername = $row['receiver_username'];
    $senderPimg = $row['sender_pimg'];
    $receiverPimg = $row['receiver_pimg'];

    $response = array(
        'senderid' => $senderid,
        'receiverid' => $receiverid,
        'sender_username' => $senderUsername,
        'receiver_username' => $receiverUsername,
        'sender_pimg' => $senderPimg,
        'receiver_pimg' => $receiverPimg,
        'message' => $message,
    );

    $allMessages[] = $response;
}

}

header('Content-Type: application/json');
echo json_encode($allMessages);

http_response_code(200);
?>
