<html>
	<head>
		<title>Upload files</title>
		<link href='//fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
		<style>
		body {
			background-color: white;
			text-align: center;
			padding: 0 250 0 250;
			font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;

			margin: 0;
			min-width: 250px;
		}
		</style>
	</head>
	<body>
		<br>
		<br>
		<?php
			$dir="/data/"; // Directory where files are stored

			if(isset($_FILES['image'])){
				$errors= array();
				$file_name = basename($_FILES['image']['name']);
				$file_size =$_FILES['image']['size'];
				$file_tmp =$_FILES['image']['tmp_name'];
				$file_type=$_FILES['image']['type'];
				$file_ext=strtolower(end(explode('.',$_FILES['image']['name'])));
				
				$expensions= array("jpeg","jpg","png");
				
				if(in_array($file_ext,$expensions)=== false){
					$errors[]="extension not allowed, please choose a JPEG or PNG file.";
				}
				
				if($file_size > 2097152){
					$errors[]='File size must be smaller than 2 MB';
				}
				
				if(empty($errors)==true){
					// echo "sys_dir = " . sys_get_temp_dir() . "<br>";
					if (move_uploaded_file($file_tmp, $dir.$file_name)) {
						// echo "$file_tmp,$dir$file_name";
					}else{
						die ("no file in move_upload_file: " . strtolower($dir.$file_name));
					}
				}else{
					print_r($errors);
				}
			}
		?>

		<form action="" method="POST" enctype="multipart/form-data">
			<p>Select file to upload:</p>
			<input type="file" name="image"/>
			<input type="submit" value="Upload file"/>
		</form>

		<br>
		<hr><p>Files already present on the system (/data)</p> <hr>
		<?php
			if ($dir_list = opendir($dir)){
				while(($filename = readdir($dir_list)) != false)
				{
					if (substr($filename , 0, 1) != '.'){
						?>
						<p><?php echo $filename;?></p>
						<?php
					}
				}
				closedir($dir_list);
			}
		?>
	</body>
</html>
