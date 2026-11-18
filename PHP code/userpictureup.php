<?php

include 'dbconnection.php';
$conn = connect();
$infojs = json_decode(file_get_contents('php://input'), true);

 //take the file and save them
        $coverfile = $_FILES['cover'];
        $usid = $_POST['usid'];
  
        //set the allowed format
        $coverallowed = ['image/jpeg', 'image/png', 'image/gif'];
  
     
        $coverav = false;
        
        //check if cover not empty
        if(!empty($coverfile['name'])){
            $coverav = true;
        }
     

        // Check if cover file was uploaded
        if ($coverfile['error'] === UPLOAD_ERR_OK) {
            $coverfile2 = $coverfile['name'];
            $covertmp = $coverfile['tmp_name'];
            $coverdest = "image/usersimg/" . $coverfile2;
            // get the cover type
            $covertype = mime_content_type($covertmp);
            // check the type of the cover if in the allowed files
            if(in_array($covertype,$coverallowed)){
            // move the cover from the temp to the cover folder
            move_uploaded_file($covertmp, $coverdest);
            $coverpath = $coverdest;
    
        }
        else{
            $coverav == false;
        }
    }
    $fullurl = 'https://testribbi24.000webhostapp.com/' . $coverpath;
    
      //insert to database
    if($coverav == true){
    $sqladd = "UPDATE `users` SET `pimg`='$fullurl' WHERE id = '$usid'";
    $conn->query($sqladd);
    
     $response = array(
        'pimg' => $fullurl
    );
    header('Content-Type: application/json');
    echo json_encode($response);
    
    http_response_code(200);
   
    
    }
    else{
        http_response_code(400);
        
    }
    
    
    
    
    ?>