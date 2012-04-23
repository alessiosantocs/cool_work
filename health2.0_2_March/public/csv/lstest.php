<html>
<body>

<?php
$command = "/bin/ls /var/www/csvfiles/*.csv";
$output = array();
exec($command, $output);
?>
<p align="center">
<h1 align="center">Segment Based CSV Files</h1>
<p align="center">
<?
$oList = array();
foreach($output as &$i){
if ($i != "indexHealth20.py"){
$i = substr($i, 18, strlen($i) -1);
print "<br><a href=\"/csvfiles/".str_replace(" ","%20",$i)."\">".$i."</a>\n";

}
}
?>
</p>
</p>
<body>
</html>



