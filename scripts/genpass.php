<?php
if (count($argv) > 1)
	$passwd = $argv[1];
else 
	$passwd = substr(base64_encode(file_get_contents('/dev/urandom', false, null, 0, 50)), 0, 12);
	print( "passwd = $passwd\n");
if (count($argv) > 2) 
	$salt = $argv[2];
else
	$salt = substr(base64_encode(file_get_contents('/dev/urandom', false, null, 0, 50)), 0, 22);

$v = "sha512";
$cost= 25000;

print "\$pbkdf2-$v\$$cost\$$salt\$" .base64_encode(hash_pbkdf2($v, $passwd, $salt, $cost, 0, true)). "\n";
?>

