<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userne = $infojs['username'];
$userpass = $infojs['password'];

// check username and password match in the data the database
$sql2 = "SELECT `username`, `email`, `password`, `pimg`, `id`,`verified` FROM `users` WHERE `email` = '$userne' AND password = '$userpass'";
        $result = $conn->query($sql2);
//if  in  the database
if ($result->num_rows > 0) {
$row = $result->fetch_assoc();
    $username = $row['username'];
    $email = $row['email'];
    $password = $row['password'];
    $img = $row['pimg'];
    $uid = $row['id'];
    $uverif = $row['verified'];
    
    $response = array(
        'username' => $username,
        'email' => $email,
        'password' => $password,
        'pimg' => $img,
        'uid' => $uid,
        'uverf' => $uverif
    );
    
    header('Content-Type: application/json');
    echo json_encode($response);
    
    http_response_code(200);

    
}
//if not the database    
else{

http_response_code(400);
}

$conn->close();
?>