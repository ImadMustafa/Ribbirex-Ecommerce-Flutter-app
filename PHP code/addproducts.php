<?php

include 'dbconnection.php';
$conn = connect();

$infojsx = $_POST['prodata'];
$infojs = json_decode($infojsx, true);

$name = $infojs['name'];
$price = $infojs['price'];
$desc = $infojs['desc'];
$catname = $infojs['categ'];
$trad = $infojs['tradble'] ? 1 : 0;
$userid = $infojs['uid'];

$coverfile = $_FILES['cover'];
$pzip = $_FILES['zipf'];

        // Set the allowed format
        $coverallowed = ['image/jpeg', 'image/png', 'image/gif'];
        $zipAllowed = ['application/zip'];
        $coverav = false;
        $zipAv = false;
        
        //check if cover not empty
        if(!empty($coverfile['name'])){
            $coverav = true;
        }
        
        // Check if zip file is not empty
        if (!empty($pzip['name'])) {
             $zipAv = true;
        }

        
        
        // Check if cover file was uploaded
        if ($coverfile['error'] === UPLOAD_ERR_OK) {
            $coverfile2 = $coverfile['name'];
            $covertmp = $coverfile['tmp_name'];
            $coverdest = "image/prodimg/" . $coverfile2;
            // get the cover type
            $covertype = mime_content_type($covertmp);
            // check the type of the cover if in the allowed files
            if(in_array($covertype,$coverallowed)){
            // move the cover from the temp to the cover folder
            move_uploaded_file($covertmp, $coverdest);
            $coverpath = $coverdest;
    
        }
    }
    $fullurl = 'https://testribbi24.000webhostapp.com/' . $coverpath;

    // check zip 
    if ($zipAv && $pzip['error'] === UPLOAD_ERR_OK) {
    $zipFile2 = $pzip['name'];
    $ziptmp = $pzip['tmp_name'];
    $zipdest = "prozip/" . $zipFile2;
    // get the zip file type
    $zipType = mime_content_type($ziptmp);
    // check if the zip file type is in the allowed files
    if (in_array($zipType, $zipAllowed)) {
        // vove the zip file from the temp folder to the destination folder
        move_uploaded_file($ziptmp, $zipdest);
        $zippath = $zipdest;
        }
    }
    $fullzipurl = 'https://testribbi24.000webhostapp.com/' . $zippath;







//we create random id for the product
$pid = mt_rand(100000, 999999);
$sqlc = "SELECT * FROM `products` WHERE `id` = $pid";
$ceresult = $conn->query($sqlc);

while(mysqli_num_rows($ceresult) > 0) {
    $pid = mt_rand(100000, 999999);
    $sqlc = "SELECT * FROM `products` WHERE `id` = $pid";
    $ceresult = $conn->query($sqlc);
}


 // Check if category exists
    $sql1 = "SELECT id FROM `category` WHERE `name` = '$catname'";
          $result1 = $conn->query($sql1);
    if ($result1) {
        if(mysqli_num_rows($result1) > 0) {
            $row = mysqli_fetch_assoc($result1);
            $catid = $row['id'];
    
        
        $sql2 = "INSERT INTO `products`(`id`,`categoryid`, `name`, `desc`, `price`, `tradeable`,`img`,`file`) VALUES ($pid,$catid,'$name','$desc','$price',$trad,'$fullurl','$fullzipurl')";
        
        $resultup = $conn->query($sql2);
        
        if($resultup){
            $sqlpi = "INSERT INTO `productslog`(`productid`, `userid`, `status`) VALUES ('$pid','$userid','creator')";
            $prores = $conn->query($sqlpi);
            
        }
}
          else {
        http_response_code(400);
         
    }
}

    

?>