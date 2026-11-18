<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$usern = $infojs['username'];
$oldu = $infojs['olduser'];
$email = $infojs['email'];
$olde = $infojs['oldemail'];
$key = $infojs['key'];


//check username if exist
    if($key == 1){
     
    if($oldu !== null){   
    $sql3 = "SELECT username FROM users WHERE username = '$usern' AND username != '$oldu'";
    $result2 = $conn->query($sql3);
    }
    else{
       $sql3 = "SELECT username FROM users WHERE username = '$usern'";
    $result2 = $conn->query($sql3); 
    }
    
    //username or email already taken
    if ($result2->num_rows > 0) {
        http_response_code(411);
}
//if not exist update
else {
http_response_code(200);
}

}

//check email if exist
    if($key == 2){
        
    $sql33 = "SELECT email FROM users WHERE email = '$email' AND email != '$olde'";
    $result22 = $conn->query($sql33);
      
    //username or email already taken
    if ($result22->num_rows > 0) {
        http_response_code(412);
}
//if not exist update
else {
http_response_code(201);
}

}


$conn->close();
?>