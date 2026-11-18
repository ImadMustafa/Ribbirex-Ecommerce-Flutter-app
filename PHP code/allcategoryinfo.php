<?php


include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);

$categlist = [];

$sql = "SELECT * FROM category";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $categlist[] = $row['name'];
    }
}

   header('Content-Type: application/json');
    echo json_encode($categlist);
    
    http_response_code(200);






?>