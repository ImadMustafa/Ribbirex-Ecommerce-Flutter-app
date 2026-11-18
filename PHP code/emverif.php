<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$uid = $infojs['uid'];

$sql = "UPDATE `users` SET `verified`= 1 WHERE `id` = '$uid'";
$result = $conn->query($sql);









?>