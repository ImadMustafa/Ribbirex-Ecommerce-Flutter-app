<?php

include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);

$input = $infojs['searin'];
$input = $conn->real_escape_string($input);
$prodlist = [];


if($input != ""){
// we get all products info
$sql2 = "SELECT products.*, users.username, category.name AS caname
FROM productslog
JOIN products ON productslog.productid = products.id
JOIN users ON productslog.userid = users.id
JOIN category ON products.categoryid = category.id
WHERE productslog.status = 'creator' AND products.name LIKE '$input%'";
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
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr,
        'crname' => $crname,
        'catname' => $catname
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    http_response_code(200);

}

else{
    
    // we get all products info
$sql2 = "SELECT products.*, users.username, category.name AS caname
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
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr,
        'crname' => $crname,
        'catname' => $catname
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    http_response_code(200);

    
    
    
}








?>