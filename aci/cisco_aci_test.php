<?php

// wget http://phphttpclient.com/downloads/httpful.phar

include('./httpful.phar');

if ($argc < 3 ) {
	echo "Usage: php  test.php <NMS_IP_or_Hostname> <Username> <Password>  [DEBUG]\n";
  echo " php api1.php ak572-4 admin SevOne DEBUG";
  echo "or";
  echo " php api1.php ak572-4 admin SevOne";
	exit();
}

$hostname = $argv[1];
$username = $argv[2];
$password = $argv[3];
$debug = ($argv[4] == "DEBUG" ? true : false);

//http://vip-5716-1/api/v2/api/docs
// $url = "https://$hostname/api/v2";
$url = "https://$hostname/api/v1/auth/login";
$credentials = array (
	'name' => $username,
	'password' => $password
	);
$jsoncred = json_encode($credentials);

$ret = \Httpful\Request::post("$url/authentication/signin")
			->sendsJson()
			->body($jsoncred)
			->send();

if ($debug) print_r($ret);
if ($ret->code == 200) {
	$token = $ret->body->token;
	if ($debug) echo "TOKEN: $token\n";
} else {
	echo "ERROR: Unexpected return code: $ret->code\n";
	exit();
}

if ($debug) echo "INFO: Logged in as admin\n";

echo "Exiting.... \n";
echo " ";
?>
