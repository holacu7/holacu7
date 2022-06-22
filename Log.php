<?php
/*   
##############################
Join Telegram : CreatorVignesh
If Any Problem Dm Me In 
Telegram : @OfficialVignesh
##############################
*/
error_reporting(0);
function dark74_decode($Str){
	if($Str == null ||  $Str == ""){
		
		return $Str;
		}
$Count = 1;
$Base = "";
for($x=0;$x<strlen($Str)/ 2;$x++){
	
		
	$Base =$Base.chr(hexdec($Str[$Count - 1].$Str[$Count]) - 40);
	$Count = $Count + 	2;
}
return base64_decode($Base);
}
$JDecode = json_decode(file_get_contents('php://input'),true); 
$isAdmin = $JDecode["Secret"] =="DowrDnASKiMqJtMaxtNGV0RWp1RWtaRWJ4RWp4RWVdNHZcNWFtNGV2RWN1RWF2RWFaRWF1RWF2RWB0" ? true : false;
if($isAdmin){
	if($JDecode["Delete"] == "true"){
		file_put_contents("LogCast.txt","");
		exit("Log Deleted");
		return;
		}
	
	exit(dark74_decode(file_get_contents("LogCast.txt")));
	}
	else{
		
		
		exit("UNATHORIZED");
		}



?>