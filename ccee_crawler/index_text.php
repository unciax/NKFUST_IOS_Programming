<?php
	/*----------------------------------------------------
		
	NKFUST CCEE Teacher List v1.0

	Programmer : UnciaX (u0251055@nkfust.edu.tw)
	Last modified : 2015.12.02

	----------------------------------------------------*/

	// include files
	require_once('config.inc.php');
	//set_error_handler("customError"); 
	$teacher_array = array();
	header("Content-Type:text/html; charset=utf-8");
	$source = @file_get_contents($teacher_list);
	$errCount = 0;
	while ($source==false){
		sleep(1);
		$errCount++;
		$source = @file_get_contents($teacher_list);
		if($errCount>5){
			die('{"Message":"無法連線至伺服器，嘗試連線的網址為：' . $url .'，請稍後再試。"}');
		}
	}
	$source = substr($source,strpos($source,'<li id="Hln_1384" >'),strpos($source,'<li id="Hln_2283" >')-strpos($source,'<li id="Hln_1384" >'));
	$source = str_replace('<li id="Hln_1384" ><a class="drop"   href="/files/11-1021-152.php"  title="資訊領域"><div class="menu-item"><span class="cgarrow"><span></span></span>資訊領域</div>',"",$source);
	$source = str_replace('<!--[if IE 7]><!--></a><!--<![endif]--><!--[if lte IE 6]><table summary=""><tr><td><![endif]--><ul><div>',"",$source);
	$source = str_replace('</div></ul><!--[if lte IE 6]></td></tr></table></a><![endif]--></li>',"",$source);
	$source = str_replace('<li id="Hln_1389" ><a class="drop"   href="/files/11-1021-162.php"  title="通訊領域"><div class="menu-item"><span class="cgarrow"><span></span></span>通訊領域</div>',"",$source);
	$source = str_replace('<li id="Hln_1390" ><a class="drop"   href="/files/11-1021-293.php"  title="多媒體領域"><div class="menu-item"><span class="cgarrow"><span></span></span>多媒體領域</div>',"",$source);
	$source = str_replace('<li id="Hln_1391" ><a class="drop"   href="/files/11-1021-369.php"  title="晶片設計"><div class="menu-item"><span class="cgarrow"><span></span></span>晶片設計</div>',"",$source);
	$source = str_replace('<li id="Hln_3465" ><a href="http://www.ccee.nkfust.edu.tw/files/11-1021-7422.php"  title="系辦行政"  ><div class="menu-item">系辦行政</div></a></li>',"",$source);
	$source = str_replace('<li id="Hln_1438" ><a class="drop"   href="/files/11-1021-2361.php"  title="兼任教師"><div class="menu-item"><span class="cgarrow"><span></span></span>兼任教師</div>',"",$source);
	$source = str_replace('\n',"",$source);
	$teacher_table = explode("</li>", $source);
	//var_dump($teacher_table);
	for($i=0;$i<count($teacher_table);$i++){
		$teacher_table[$i] = substr($teacher_table[$i],strpos($teacher_table[$i],'href="')+6,strpos($teacher_table[$i],'"  t')-strpos($teacher_table[$i],'href="')-6);
		if(!strrpos($teacher_table[$i],".php")){ continue; }	
		if(strpos($teacher_table[$i],substr($ccee_domain,3,strlen($ccee_domain)-3)) == false){ $teacher_table[$i] = $ccee_domain . $teacher_table[$i]; }
		//echo "==========================================<br>";
		//echo $teacher_table[$i] . "<br>";
		
		$teacher_source =  @file_get_contents(trim($teacher_table[$i]));
		$errCount = 0;
		while ($teacher_source==false){
			sleep(1);
			$errCount++;
			$teacher_source =  @file_get_contents(trim($teacher_table[$i]));
			if($errCount>5){
				die('{"Message":"無法連線至伺服器，嘗試連線的網址為：' . $teacher_table[$i] .'，請稍後再試。"}');
			}
		}
		//echo strpos($teacher_source,'<div class="md_top show_title ">') . "<br>";
		//echo strpos($teacher_source,'</html>') . "<br>";
		$source = substr($teacher_source,strpos($teacher_source,'<div class="h3">'),strpos($teacher_source,'<hr color="#004b97" size="1" />')-strpos($teacher_source,'<div class="h3">'));
		if (!$source) {		
			$source = substr($teacher_source,strpos($teacher_source,'<div class="h3">'),strpos($teacher_source,'<td colspan="2" style="font-family: Verdana, Helvetica; color: rgb(57,57,57); font-size: 11pt">')-strpos($teacher_source,'<div class="h3">'));
		}
		$teacher_source="";
		$teacherName = substr($source,strpos($source,'<div class="h3">')+16,strpos($source,'</div>')-strpos($source,'<div class="h3">')-16);
		if($teacherName == "") { 
			$teacherName = substr($source,strrpos($source,'<div class="h3">')+16,strrpos($source,'</div>')-strrpos($source,'<div class="h3">')-16);
			$teacherName = str_replace("</div>","",$teacherName);
			$teacherName = str_replace("\n","",$teacherName);
		}
		$teacherEdu = substr($source,strpos($source,'最高學歷：')+15,strpos($source,'博士')-strpos($source,'最高學歷：')-9);
		$teacherEdu = str_replace('<td align="left" class="b6" colspan="2" valign="bottom">','',$teacherEdu);
		$teacherEdu = str_replace('<td align="left" class="b6" colspan="2" style="font-family: Verdana, Helvetica; color: rgb(57,57,57); font-size: 11pt" valign="bottom">','',$teacherEdu);
		$teacherEdu = str_replace('<td colspan="2" style="font-family: Verdana, Helvetica; color: rgb(57,57,57); font-size: 11pt" valign="bottom">','',$teacherEdu);
		$teacherEdu = str_replace('<p style="text-align: left"><span style="font-family: 新細明體,serif">','',$teacherEdu);
		$teacherEdu = str_replace('</span> <span style="font-family: 新細明體,serif">','',$teacherEdu);
		$teacherEdu = str_replace('<td align="left" class="b6" colspan="2" style="color: rgb(57, 57, 57); font-family: Verdana, Helvetica; font-size: 11pt;" valign="bottom">','',$teacherEdu);
		$teacherEdu = str_replace('<td align="left" colspan="2" valign="bottom">','',$teacherEdu);
		$teacherEdu = str_replace('<td align="left" colspan="2" style="font-family: Verdana, Helvetica; color: rgb(57,57,57); font-size: 11pt" valign="bottom">','',$teacherEdu);
		$teacherEdu = str_replace('</span>','',$teacherEdu);
		$teacherEdu = str_replace('<span style="font-size: 12px"><span style="font-family: 新細明體">','',$teacherEdu);
		$teacherEdu = str_replace('<span style="mso-bidi-font-family: \'Times New Roman\'; mso-bidi-font-size: 11.0pt; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin; mso-fareast-theme-font: minor-fareast; mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin; mso-bidi-theme-font: minor-bidi; mso-fareast-language: ZH-TW; mso-ansi-language: EN-US; mso-bidi-language: AR-SA"><font color="#000000">','',$teacherEdu);
		$teacherEdu = str_replace('</td>','',$teacherEdu);
		$teacherEdu = str_replace('\r\n','',$teacherEdu);
		$teacherEdu = trim($teacherEdu);
		$source = str_replace(' height="114"','',$source);	
		$teacherPic = $ccee_domain . substr($source,strpos($source,'<img alt="" src="')+17,strpos($source,'.jpg')-strpos($source,'<img alt="" src="')-13);
		$teacherEmail = substr($source,strpos($source,'mailto:')+7,strpos($source,'"><img alt="" src="/ezfiles/21/1021/img/900/e-mail20icon.jpg" ')-strpos($source,'mailto:')-7);
		if($teacherEmail == "") { $teacherEmail = substr($source,strpos($source,'mailto:')+7,strpos($source,'"><img alt="" src="http://www1.ccee.nkfust.edu.tw/ezfiles/21/1021/img/900/e-mail20icon.jpg" ')-strpos($source,'mailto:')-7); }
				if($teacherEmail == "") { $teacherEmail = substr($source,strpos($source,'mailto:')+7,strpos($source,'"><img alt="" src="http://www.ccee.nkfust.edu.tw/ezfiles/21/1021/img/900/e-mail20icon.jpg" ')-strpos($source,'mailto:')-7); }
		if(strlen($teacherEmail)>100) { $teacherEmail = substr($source,strpos($source,'mailto:')+7,strpos($source,'>danchen@nkfust.edu.tw</a>')-strpos($source,'mailto:')-8); }
		//var_dump($teacherEmail); echo "<br>";
		$teacherExt = substr($source,strpos($source,'Ext:')+4,4);
		$teacherOffice = substr($source,strpos($source,'研究室：')+12,4);
		if($teacherOffice == "</sp"){ $teacherOffice = substr($source,strpos($source,'研究室：')+19,4); }
		$teacher =array("name"=>$teacherName,"education"=>$teacherEdu,"imageURL"=>$teacherPic,"email"=>$teacherEmail,"ext"=>(int)$teacherExt,"office"=>$teacherOffice);
		array_push($teacher_array,$teacher);
	
	}
	if (function_exists("json_encode")){
		echo json_encode($teacher_array,JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
	}else{
		$output = "[";
		for($i=0;$i<count($teacher_array);$i++){
			$output = $output . '{"name":"' . $teacher_array[$i]["name"] .  '",';
			$output = $output . '"education":"' . $teacher_array[$i]["education"] . '",';
			$output = $output . '"imageURL":"' . $teacher_array[$i]["imageURL"] .  '",';
			$output = $output . '"email":"' . $teacher_array[$i]["email"] .  '",';
			$output = $output . '"ext":' . $teacher_array[$i]["ext"] . ',';
			$output = $output . '"office":"' . $teacher_array[$i]["office"]  .  '"}';
			if ($i != count($teacher_array)-1) { $output = $output . ","; }
		}
		$output = $output . "]";
		$handle = fopen( "static.txt", "w");
		fwrite($handle, $output);
		fclose($handle);
		echo $output;

	}
	
?>