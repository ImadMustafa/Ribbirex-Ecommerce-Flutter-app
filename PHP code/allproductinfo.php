<?php

include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);

$prodlist = [];


// we get all products info
$sql2 = "SELECT products.*, users.username, productslog.userid AS crid, category.name AS caname
FROM productslog
JOIN products ON productslog.productid = products.id
JOIN users ON productslog.userid = users.id
JOIN category ON products.categoryid = category.id
WHERE productslog.status = 'creator'";
        $result = $conn->query($sql2);

 $k = 0;
while ($row = $result->fetch_assoc() and $k < mysqli_num_rows($result)){
    $pid = $row['id'];
    $pname = $row['name'];
    $pdesc = $row['desc'];
    $pprice = $row['price'];
    $pimgs = $row['img'];
    $istr = $row['tradeable'];
    $crname = $row['username'];
    $catname = $row['caname'];
    $creaid = $row['crid'];
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr,
        'crname' => $crname,
        'catname' => $catname,
        'creatorid' => $creaid
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    http_response_code(200);





?>