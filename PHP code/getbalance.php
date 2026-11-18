<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$uid = $infojs['uid'];


$sql = "SELECT balance FROM `users` WHERE id = '$uid'";
$result = $conn->query($sql);

while($result->num_rows > 0 && $row = $result->fetch_assoc()){

$balance = $row['balance'];


$response = array(
        'balance' => $balance,
   
);

    header('Content-Type: application/json');
    echo json_encode($response);
    http_response_code(200);







}








?>