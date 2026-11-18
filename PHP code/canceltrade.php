<?php


include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$tradeid = (int)$infojs['tradeid'];

$sql4 = "SELECT status FROM trades WHERE id = $tradeid";
 $result4 = $conn->query($sql4);
    
    if ($result4->num_rows > 0) {
        $row = $result4->fetch_assoc();
        $status = $row['status'];
        
        if($status == 'Pending'){

$sql = "UPDATE `trades` SET `status`='Cancelled' WHERE id = $tradeid";

$result =  $conn->query($sql);
if($result){
    
    http_response_code(200);
}

}
else{
    
    http_response_code(400);
}


}

















?>