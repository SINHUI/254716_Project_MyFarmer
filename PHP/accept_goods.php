<?php
error_reporting(0);
include_once("dbconnect.php");
$goodsprice= $_POST['goodsprice'];
$goodsid = $_POST['goodsid'];
$email = $_POST['email'];
$credit = $_POST['credit'];

$sql = "UPDATE GOODS SET GOODSWORKER = '$email'  WHERE GOODSID = '$goodsid'";
if ($conn->query($sql) === TRUE) {
    $newcredit = $credit - $goodsprice;
    $sqlcredit = "UPDATE USER SET CREDIT = '$newcredit' WHERE EMAIL = '$email'";
    $conn->query($sqlcredit);
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>
