<?php

//create connection with mysql
function connect(){
$servername = "localhost";
$username = "id22099167_trdasd2ads";
$password = "Qazwsx12@";
$db = "id22099167_trddb12";
$conn = new mysqli($servername,$username,$password,$db);
if($conn->connect_error){
    die("Connection failed".$conn->connect_error);
}
return $conn;

}

?>