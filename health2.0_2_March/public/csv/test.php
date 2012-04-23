<html>
<body>

<?php
print("Starting Generation<br>");
$command = "/usr/bin/python2.6 /var/www/csvfiles/indexHealth20.py";
$output = array();
exec($command, $output);
print_r($output);
print("<br>Spreadsheets Generated");

?>
<body>
</html>



