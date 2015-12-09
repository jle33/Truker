<?php
require("phpsqlinfo_dbinfo.php");
// Gets data from URL parameters
$cusID = $_GET['cusID'];
$lat = $_GET['dest_latitude'];
$lng = $_GET['dest_longitude'];

// Opens a connection to a MySQL server
$connection = mysql_connect ("server=us-cdbr-azure-west-c.cloudapp.net", "bad3c8f970d412", 197cee98);
if (!$connection) {
  die('Not connected : ' . mysql_error());
}
// Set the active MySQL database
$db_selected = mysql_select_db("cecs521_db", $connection);
if (!$db_selected) {
  die ('Can\'t use db : ' . mysql_error());
}
// Insert new row with user data
$query = sprintf("INSERT INTO creates_pickup_order " .
         " (cusID, dest_latitude, dest_longitude) " .
         " VALUES ('%c', '%s', '%s');",
		     mysql_real_escape_string($cusID),
         mysql_real_escape_string($dest_latitude),
         mysql_real_escape_string($dest_longitude));
$result = mysql_query($query);
if (!$result) {
  die('Invalid query: ' . mysql_error());
}
?>