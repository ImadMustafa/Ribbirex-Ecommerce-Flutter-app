<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$usern = $infojs['username'];
$password = $infojs['password'];
$email = $infojs['email'];
$oldu = $infojs['olduser'];
$olde = $infojs['oldemail'];
$oldpas = $infojs['oldpass'];
$uid = $infojs['uid'];

// check if the old username and old password match in the database
$sql2 = "SELECT username FROM users WHERE username = '$oldu' AND password = '$oldpas'";
$result = $conn->query($sql2);

//if the username and password match
if ($result->num_rows > 0) {
   
    //check if the new username is same as old username
    if($usern == $oldu AND $email == $olde){
        $sql4 = "UPDATE `users` SET `password`='$password' WHERE `id`='$uid'";
        $conn->query($sql4);
        
        
        http_response_code(200);
    }
    //if not the same we check if the new username is taken
    else{
        
    //check username if exist
        $sql3 = "SELECT username FROM users WHERE username = '$usern' AND username != '$oldu'";
        $result2 = $conn->query($sql3);
        
        $sql34 = "SELECT username FROM users WHERE email = '$email' AND email != '$olde'";
        $result22 = $conn->query($sql34);

}
    //username or email already taken
    if ($result2->num_rows > 0) {
        http_response_code(409);
    }
    if($result22->num_rows > 0){
        http_response_code(410);
    }

//if not exist update
else {
if($email != $olde){
$sql4 = "UPDATE `users` SET `username`='$usern',`password`='$password',`email`='$email',`verified`= 0 WHERE `id`='$uid'";    
    $conn->query($sql4);
    
     http_response_code(200);
}
else{
    
    $sql4 = "UPDATE `users` SET `username`='$usern',`password`='$password',`email`='$email' WHERE `id`='$uid'";    
    $conn->query($sql4);
     http_response_code(200);
    
}
    

}


}
else {
    http_response_code(400);
}




$conn->close();
?>

