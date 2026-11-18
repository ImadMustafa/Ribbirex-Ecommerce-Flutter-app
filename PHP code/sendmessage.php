<?php

include 'dbconnection.php';
$conn = connect();

$infoJson = json_decode(file_get_contents('php://input'), true);

if ($infoJson) {
    $senderId = (int)$infoJson['senderid'];
    $receiverId = (int)$infoJson['receiverid'];
    $message = $infoJson['message'];
    if($senderId == $receiverId){
        echo "Error: Sending message to yourself is invalid";
    }else{
    $sql = "INSERT INTO `messages`(`msgid`, `senderid`, `receiverid`, `msg`) 
            VALUES (NULL, $senderId, $receiverId, '$message')";
    $result = $conn->query($sql);

    if ($result) {
        echo "Message inserted successfully";
    } else {
        echo "Error: " . $conn->error;
    }
    }
} else {
    echo "Error: Invalid JSON data";
}

$conn->close();
?>
