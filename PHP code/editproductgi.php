<?php

include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);

$pid = $infojs['pid'];


    
    $sqlpin = "SELECT p.*, c.name AS caname
                FROM products p
                JOIN category c ON p.categoryid = c.id
                WHERE p.id = '$pid'";
      $result = $conn->query($sqlpin);


if ($row = $result->fetch_assoc()){
    
    $pname = $row['name'];
    $pdesc = $row['desc'];
    $pprice = $row['price'];
    $pimgs = $row['img'];
    $istr = $row['tradeable'];
    $zipn = $row['file'];
    $caname = $row['caname'];

    
    $response = array(
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr,
        'zipn' => $zipn,
        'catn' => $caname,
    );
  
}
   

 header('Content-Type: application/json');
    echo json_encode($response);
    
    http_response_code(200);
    
    
    
    









?>