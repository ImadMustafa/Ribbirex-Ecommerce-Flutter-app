<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);


$password = $infojs['password'];
$email = $infojs['email'];
$token = $infojs['usertoken'];






// insert the username nad password
$sql = "INSERT INTO `users`(`email`, `password`) VALUES ('$email','$password')";
                
     
$conn->query($sql);



$conn->close();
?>