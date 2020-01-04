<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

function randompassword()
{
    $random ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*_';
    return substr(str_shuffle($random),0,15);
}

$tempass = randompassword();
$tempasssha = sha1($tempass);

$sql ="UPDATE USER SET PASSWORD='$tempasssha' WHERE EMAIL = '$email' ";


$sqls = "SELECT * FROM USER WHERE EMAIL = '$email' AND VERIFY ='1'";
$result = $conn->query($sqls);

if ($conn -> query($sql) ===TRUE && $result->num_rows > 0) {
    sendEmail($email,$tempass);
    echo "Please check your email.";
} else {
    echo "Email is does not exist";
}


function sendEmail($useremail,$tpw) {
    $to      = $useremail; 
    $subject = 'Reset Password for MyFarmer'; 
   $message = 'Your new password is: '.$tpw. "\nPlease use the temporary password to change your own password."; 
    $headers = 'From: noreply@myfarmer.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
    
}

?>
