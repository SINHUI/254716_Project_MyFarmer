<?php
//error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$name = $_POST['name'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,VERIFY,CREDIT) VALUES ('$name','$email','$password','$phone','0','100')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "success";
} else {
    echo "The email is already in use.";
}

function sendEmail($useremail) {
    $caption = "Please click the link to verify your account.\n";
    $to      = $useremail; 
    $subject = 'Verification for MyFarmer'; 
    $message = $caption.'http://lastyeartit.com//myFarmer/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@myfarmer.com.my' . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>
