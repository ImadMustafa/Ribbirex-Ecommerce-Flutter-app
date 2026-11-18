<?php

include 'dbconnection.php';
$conn = connect();

$infojs = json_decode(file_get_contents('php://input'), true);

$userne = (int)$infojs['uid'];
$prodlist = [];
$total = 0;

 
    $sql1 = "SELECT id FROM `cart` WHERE userid = $userne";
    $result1 = $conn->query($sql1);

if($result1->num_rows > 0 && $row = $result1->fetch_assoc()) {
    $cartId = $row['id'];
    
    
    // we get all products info
            $sql3 = "SELECT products.*, users.username, category.name AS caname
            FROM productslog
            JOIN products ON productslog.productid = products.id
            JOIN users ON productslog.userid = users.id
            JOIN category ON products.categoryid = category.id
            JOIN cartitems ci ON products.id = ci.product
            WHERE productslog.status = 'creator' AND ci.cart = $cartId";
            $result3 = $conn->query($sql3);

    $k = 0;
    while ($row = $result3->fetch_assoc() and $k < mysqli_num_rows($result3)){
    $pid = $row['id'];
    $pname = $row['name'];
    $pdesc = $row['desc'];
    $pprice = $row['price'];
    $pimgs = $row['img'];
    $istr = $row['tradeable'];
    $crname = $row['username'];
    $catname = $row['caname'];
    $total += $pprice;
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr,
        'crname' => $crname,
        'catname' => $catname,
        'total' => $total,
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    http_response_code(200);
    
     
 
}



else{
    
    
    http_response_code(400);
}













?>