<?php

include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);

$userid = $infojs['uid'];
$key = $infojs['key'];
$prid = isset($infojs['pid']) ? (int) $infojs['pid'] : null;

$prodlist = [];


if($key == 1){
    
    
    $sqlcr = "SELECT products.*
            FROM productslog
            JOIN products ON productslog.productid = products.id
            WHERE productslog.userid = '$userid' AND status = 'creator'";
            
    $result = $conn->query($sqlcr);

    $k = 0;
    while ($row = $result->fetch_assoc() and $k < mysqli_num_rows($result)){
    $pid = $row['id'];
    $pname = $row['name'];
    $pdesc = $row['desc'];
    $pprice = $row['price'];
    $pimgs = $row['img'];
    $istr = $row['tradeable'];
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    
    
    
    
    
}



if($key == 2){
    

    $sqlcr = "SELECT products.*
            FROM productslog
            JOIN products ON productslog.productid = products.id
            WHERE productslog.userid = '$userid' AND status = 'purchaser'";
            
    $result = $conn->query($sqlcr);

    $k = 0;
    while ($row = $result->fetch_assoc() and $k < mysqli_num_rows($result)){
    $pid = $row['id'];
    $pname = $row['name'];
    $pdesc = $row['desc'];
    $pprice = $row['price'];
    $pimgs = $row['img'];
    $istr = $row['tradeable'];
    $pzip = $row['file'];
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr,
        'pzip' => $pzip
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    
    
    
    
    
}




if($key == 3){
    
    
    $sqlcr = "SELECT products.*
            FROM productslog
            JOIN products ON productslog.productid = products.id
            WHERE productslog.userid = '$userid'";
            
    $result = $conn->query($sqlcr);

    $k = 0;
    while ($row = $result->fetch_assoc() and $k < mysqli_num_rows($result)){
    $pid = $row['id'];
    $pname = $row['name'];
    $pdesc = $row['desc'];
    $pprice = $row['price'];
    $pimgs = $row['img'];
    $istr = $row['tradeable'];
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    
    
    
    
    
}

if($key == 4){
    
    
    $sqlgetp = "SELECT price FROM products WHERE id = $prid";
    $resultpr = $conn->query($sqlgetp);
    if($row = $resultpr->fetch_assoc()){
        $bprice = $row['price'];
    }

    $sqlcr = "SELECT products.*
            FROM productslog
            JOIN products ON productslog.productid = products.id
            WHERE productslog.userid = '$userid' AND status = 'creator' AND tradeable = 1 AND (price >= ($bprice - 10) AND price <= ($bprice + 10))";
            
    $result = $conn->query($sqlcr);

    $k = 0;
    while ($row = $result->fetch_assoc() and $k < mysqli_num_rows($result)){
    $pid = $row['id'];
    $pname = $row['name'];
    $pdesc = $row['desc'];
    $pprice = $row['price'];
    $pimgs = $row['img'];
    $istr = $row['tradeable'];
    
    $response = array(
        'pid' => $pid,
        'pname' => $pname,
        'pdesc' => $pdesc,
        'pprice' => $pprice,
        'pimgs' => $pimgs,
        'trad' => $istr
    );
    $prodlist[$k] = $response;
    $k++;
}
    header('Content-Type: application/json');
    echo json_encode($prodlist);
    
    
    
    
    
    
    
    
    
    
}




?>