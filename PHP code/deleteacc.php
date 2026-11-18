<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$uid = $infojs['uid'];

$sql2 = "DELETE FROM cart WHERE userid = '$uid'";
$result2 = $conn->query($sql2);

$sql = "DELETE FROM users WHERE id = '$uid'";
$result = $conn->query($sql);





?>