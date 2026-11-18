<?php
include 'dbconnection.php';
$conn = connect();

// Get the request body
$requestBody = file_get_contents('php://input');
$infojs = json_decode($requestBody, true);

$uidA = (int)$infojs['uidA'];
$uidB = (int)$infojs['uidB'];
$allmessages = [];

// Query to fetch messages
$sql = "SELECT `msg` FROM `messages` WHERE (`senderid` = $uidA AND `receiverid` = $uidB) OR (`senderid` = $uidB AND `receiverid` = $uidA)";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // Fetch and store messages in an array
  while ($row = $result->fetch_assoc()) {
    $allmessages[] = $row['msg'];
  }
}

// Return messages as JSON
echo json_encode($allmessages);

// Set response header
header('Content-Type: application/json');
http_response_code(200);
?>
