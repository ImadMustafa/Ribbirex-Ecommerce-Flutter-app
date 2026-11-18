<?php

include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);

$catname = $infojs['cat'];
$min = $infojs['minp'];
$max = $infojs['maxp'];
$trad = $infojs['trad'] ? 1 : 0;
$prodlist = [];


if($catname != null){
    
    
 // Check if category exists
    $sql1 = "SELECT id FROM `category` WHERE `name` = '$catname'";
          $result1 = $conn->query($sql1);
    if ($result1) {
        if(mysqli_num_rows($result1) > 0) {
            $row = mysqli_fetch_assoc($result1);
            $catid = $row['id'];
        }
    }

// we get all products info
$sql2 = "SELECT products.*, users.username, category.name AS catname
FROM productslog
JOIN products ON productslog.productid = products.id
JOIN users ON productslog.userid = users.id
JOIN category ON products.categoryid = category.id
WHERE STATUS = 'creator'
AND categoryid = $catid
AND price BETWEEN $min AND $max
AND tradeable = $trad";
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
    $catname = $row['catname'];
    
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
$sql2 = "SELECT products.*, users.username, category.name AS catname
FROM productslog
JOIN products ON productslog.productid = products.id
JOIN users ON productslog.userid = users.id
JOIN category ON products.categoryid = category.id
WHERE STATUS = 'creator'
AND price BETWEEN $min AND $max
AND tradeable = $trad";
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
    $catname = $row['catname'];
    
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