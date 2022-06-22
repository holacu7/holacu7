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

function dark74_encode($Str){
	 	
$Base =  base64_encode($Str);
$Text = "";

for($x=0;$x < strlen($Base);$x++){
	$Text = $Text.dechex(ord($Base[$x])+40);
	
}

return $Text;

}


function ExitAlert($msg){
    exit("gg.alert('".$msg."')");
}
$FileName = "UserInfoo.json";
$Hour = date('d-m-Y H:i');
$LogCast = dark74_decode(file_get_contents("LogCast.txt"));
$JDecode = json_decode(file_get_contents('php://input'),true); 
$Authorization = $JDecode["Authorization"] == "DowrDnASKiDdJFxXPxEDcjf42BUqHzkbUaCNm4wHw8AyTpa7gEGEybswr6G3JgE3paHkZbTapcWZbe4NHD"? true : false;
$Action  = $JDecode["Action"];
$Token = $JDecode["Token"] != null ? explode(":::",$JDecode["Token"]) : [];
$Owner = $Token[0] == null ? "Admin" : $Token[0];
$Content =json_decode(file_get_contents($FileName),true);
$isAdmin = $JDecode["Secret"] =="DowrDnASKiMqJtMaxtNGV0RWp1RWtaRWJ4RWp4RWVdNHZcNWFtNGV2RWN1RWF2RWFaRWF1RWF2RWB0" ? true : false;
if($LogCast == null){
	$LogCast = "";
	}
if($Content == null){
$Content = [];
}

if($isAdmin == false){
		if($Content[dark74_encode(strtolower($Token[0]))] != null){
			if($Content[dark74_encode(strtolower($Token[0]))]["password"] == dark74_encode($Token[1])){
				if($Content[dark74_encode(strtolower($Token[0]))]["Level"] == 1 ){
					
					
					
					}
					else{
				exit("UNATHORIZED");
				}
				}
				else{
					exit("UNATHORIZED");
					}
			
			}
		else{
			exit("UNATHORIZED");
			}
		
		}

if($Authorization == true){
	if($isAdmin == false){
	$Username = strtolower($JDecode["Username"]);
	if($Content[dark74_encode($Username)] <> null){
		if($Content[dark74_encode($Username)]["Level"] <> null){
			if($Content[dark74_encode($Username)]["Level"]  == $Content[dark74_encode(strtolower($Token[0]))]["Level"]){
			
				ExitAlert("UNATHORIZED");
				
				}
			}
		
		
		
		}
		else{
			
			ExitAlert("⚠User does not exist⚠");
			}
			}
	if($Action == "Reset"){
		$Username = strtolower($JDecode["Username"]);
		if($Content[dark74_encode($Username)] <> null){
			$Content[dark74_encode($Username)]["userAgent"] = "null";
			file_put_contents($FileName,json_encode($Content,true));
			file_put_contents("LogCast.txt",dark74_encode($LogCast."\n"."[".$Hour."]\n"."Action: RESET\nUsername: ".$Username."\nAdmin: ".$Owner));
			ExitAlert("Sucess ✅");
		}
		}
		
if($Action == "Delete"){
	$Username = strtolower($JDecode["Username"]);
	
	if($Content[dark74_encode($Username)] <> null){
	unset($Content[dark74_encode($Username)]);
file_put_contents($FileName,json_encode($Content,true));
file_put_contents("LogCast.txt",dark74_encode($LogCast."\n"."[".$Hour."]\n"."Action: DELETE\nUsername: ".$Username."\nAdmin: ".$Owner));
ExitAlert("Sucess ✅");

}
else{
	ExitAlert("⚠User does not exist⚠");
}

}
	if($Action == "Edit"){
		$Username = strtolower($JDecode["Username"]);
		$Password = $JDecode["password"];
		$Date = $JDecode["date"];
		$Actived = $JDecode["actived"];
		if($isAdmin){
		$Level = $JDecode["level"] == "true" ? 1 : 0;
		}
		else{
			$Level = 0;
			}
		if($Content[dark74_encode($Username)]["password"] <> null){
			$Content[dark74_encode($Username)]["password"] = dark74_encode($Password);
			$Content[dark74_encode($Username)]["ExpireData"] = dark74_encode($Date);
			$Content[dark74_encode($Username)]["Actived"] = dark74_encode($Actived);
			$Content[dark74_encode($Username)]["Level"] = $Level;
			file_put_contents($FileName,json_encode($Content,true));
			$Data = "\nActive: ".$Actived."\nData: ".$Date."\nPassword: ".$Password."\nAdmin: ".(string)$Level;
			file_put_contents("LogCast.txt",dark74_encode($LogCast."\n"."[".$Hour."]\n"."Action: EDIT\nUsername: ".$Username.$Data."\nAdmin: ".$Owner));
ExitAlert("Sucess ✅");
			}
			
			else{
				ExitAlert("⚠User does not exist⚠");
				}
	}
if($Action == "Renovate"){
	date_default_timezone_set('Asia/Kolkata');
	$Username = strtolower($JDecode["Username"]);
	$Expiration = $JDecode["Expire"];
	if($Content[dark74_encode($Username)]["password"] <> null){
	    $date = dark74_decode($Content[dark74_encode($Username)]["ExpireData"]);
		$ExpireData = date('d-m-Y', strtotime("+".$Expiration." days",strtotime($date)));
		$Content[dark74_encode($Username)]["ExpireData"] = dark74_encode($ExpireData);
		file_put_contents($FileName,json_encode($Content,true));
		file_put_contents("LogCast.txt",dark74_encode($LogCast."\n"."[".$Hour."]\n"."Action: RENOVAR\nUsername: ".$Username."\nDias: ".$Expiration."\nAdmin: ".$Owner));
ExitAlert("Sucess ✅");
		}
	}
	}
?>