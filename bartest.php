<?php
	//echo "HELLO!";
	// 11, 55
	error_reporting(E_ALL ^ E_WARNING);
	include "barcode.php";
	
	$text = (isset($_POST["text"])?$_POST["text"]:"0");
	$height = (isset($_POST["height"])?$_POST["height"]:"30");
	$width = (isset($_POST["width"])?$_POST["width"]:"30");
	$textArr = array();
	$outArr = array();
	
	if((strlen($text) * 11) + 55 > $width) {
		$textArr = str_split($text, strlen($text) / ceil(((strlen($text) * 11) + 55) / $width));
		
		$height = $height / count($textArr);
	} else {
		array_push($textArr,$text);
	}
	
	foreach($textArr as $textIn) {
		//echo $textIn . "\n";
		//echo barcode("", $textIn, $height, "horizontal", "code128", false ) . "\n";
		array_push($outArr, barcode("", $textIn, $height, "horizontal", "code128", false ));
	}
	echo json_encode($outArr);
?>