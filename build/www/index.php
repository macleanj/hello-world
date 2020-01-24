<html>
<head>
	<link rel = "stylesheet"
		type = "text/css"
		href = "stylesheet.css"
	/>
	<title>Hello world!</title>
	<link href='//fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
</head>
<body>
	<a href="http://www.crosslogic-consulting.com"><img id="logo" src="logo.png" /></a>
	<h1><?php echo "Hello ".($_ENV["NAME"]?$_ENV["NAME"]:"world")."!"; ?></h1>
	<p style="margin: -20 0 0 0;font-size: 10px"><?php echo "Version: ".$_ENV["VERSION"]; ?></p>
	<h3><?php if($_ENV["HOSTNAME"]) {?><h3>My hostname is <?php echo $_ENV["HOSTNAME"]; ?></h3><?php } ?>

	<!-- START - Getting all variables for build process -->
	<div class=cicd_config>
		<?php
		$cicd_config = [];
		$cicd_config_def_vars = explode(" ", exec('egrep ".*=.*" config/*.conf | sed -e "s/.*:\(.*\)=.*/\1/g" | sort | uniq | tr "\r\n" " "'));
		
		// print_r($cicd_config_def_vars);
		// print_r($_ENV);
		$env_sort = $_ENV;
		ksort($env_sort);
		// print_r($env_sort);
		foreach($env_sort as $key => $value) {
			if(in_array($key, $cicd_config_def_vars, TRUE)) {
				?>
				<b><?php echo $key ?> = <?php echo $value ?><br />
				<?php
			}
		}
		?>
	</div>
	<!-- END - Getting all variables for build process -->

	<!-- START - Getting links in cloud config -->
	<div class=links>
		<?php
		$links = [];
		foreach($_ENV as $key => $value) {
			if(preg_match("/^(.*)_PORT_([0-9]*)_(TCP|UDP)$/", $key, $matches)) {
				$links[] = [
					"name" => $matches[1],
					"port" => $matches[2],
					"proto" => $matches[3],
					"value" => $value
				];
			}
		}
		if($links) {
		?>
			<h3>Links found</h3>
			<?php
			foreach($links as $link) {
				?>
				<b><?php echo $link["name"]; ?></b> listening in <?php echo $link["port"]+"/"+$link["proto"]; ?> available at <?php echo $link["value"]; ?><br />
				<?php
			}
			?>
		<?php
		}

		if($_ENV["DOCKERCLOUD_AUTH"]) {
			?>
			<h3>I have Docker Cloud API powers!</h3>
			<?php
		}
		?>
	</div>
	<!-- END - Getting links in cloud config -->

	<br>
	<br>
	<br>
	<br>
	<br>
	<!-- START - Other links -->
	<div class=other-resources>
		<ul id="listLinks">
			<h1 style="text-align: left">Other resources</h1>
			<li><a href="upload.php">Testing persistentStorage</a></li>
			<li><a href="todo.php">Testing localStorage</a></li>
		</ul>
	</div>
	<!-- END - Other links -->
	
</body>
</html>
