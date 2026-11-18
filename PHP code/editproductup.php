<?php

include 'dbconnection.php';
$conn = connect();

$infojsx = $_POST['prodata'];
$infojs = json_decode($infojsx, true);

$prid = $infojs['prid'];
$price = $infojs['price'];
$desc = $infojs['desc'];
$catname = $infojs['categ'];
$trad = $infojs['tradble'] ? 1 : 0;
$pname = $infojs['name'];

$coverfile = $_FILES['cover'];
$pzip = $_FILES['zipf'];

$imgis = false;
$zipis = false;


        // Set the allowed format
        $coverallowed = ['image/jpeg', 'image/png', 'image/gif'];
        $zipAllowed = ['application/zip'];
        $coverav = false;
        $zipav = false;
        
        //check if cover not empty
        if(!empty($coverfile['name'])){
            $coverav = true;
        }
        
        // Check if zip file is not empty
        if (!empty($pzip['name'])) {
             $zipav = true;
        }

        
        
        // Check if cover file was uploaded
        if ($coverav && $coverfile['error'] === UPLOAD_ERR_OK) {
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
    if ($zipav && $pzip['error'] === UPLOAD_ERR_OK) {
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



 // Check if category exists
    $sql1 = "SELECT id FROM `category` WHERE `name` = '$catname'";
          $result1 = $conn->query($sql1);
    if ($result1) {
        if(mysqli_num_rows($result1) > 0) {
            $row = mysqli_fetch_assoc($result1);
            $catid = $row['id'];
        }
}

//we check if the image or zip is same as old
$sqlc = "SELECT `img`, `file` FROM `products` WHERE `id` = '$prid'";
$resc = $conn->query($sqlc);

if ($row = $resc->fetch_assoc() && $resc->num_rows > 0) {
    $imgv = $row['img'];
    $filev = $row['file'];
    
    if($imgv == $fullurl || !$coverav){
        $imgis = true;
    }
    if($filev == $fullzipurl || !$zipav){
        $zipis = true;
    }
    
}

if($imgis && $zipis){
    $sqlup = "UPDATE `products` SET `categoryid`= $catid,`name`='$pname',`desc`='$desc',`price`='$price',`tradeable`= $trad WHERE `id` = '$prid'";
    
    $resultup = $conn->query($sqlup);
       http_response_code(200);
    
}

else if($imgis){
    
     $sqlup = "UPDATE `products` SET `categoryid`= $catid,`name`='$pname',`desc`='$desc',`price`='$price',`tradeable`= $trad,`file` = '$fullzipurl' WHERE `id` = '$prid'";
    
    $resultup = $conn->query($sqlup);
       http_response_code(200);
    
  
}

else if($zipis){
    
     $sqlup = "UPDATE `products` SET `categoryid`= $catid,`name`='$pname',`desc`='$desc',`price`='$price',`tradeable`= $trad,`img` = '$fullurl' WHERE `id` = '$prid'";
    
    $resultup = $conn->query($sqlup);
       http_response_code(200);
    
}

else{
    
    $sqlup = "UPDATE `products` SET `categoryid`= $catid,`name`='$pname',`desc`='$desc',`price`='$price',`tradeable`= $trad,`img` = '$fullurl',`file` = '$fullzipurl' WHERE `id` = '$prid'";
    
    $resultup = $conn->query($sqlup);
       http_response_code(200);
    
}









    

?>