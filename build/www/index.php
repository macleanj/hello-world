<html>
<head>
	<title>Hello world!</title>
	<link href='//fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<style>
	body {
		background-color: white;
		text-align: center;
		padding: 50px;
		font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;

		margin: 0;
		min-width: 250px;
	}

	#logo {
		margin-bottom: 40px;
		width: 25%;
    height: auto
	}
	ul {
		margin: 0 850 0 850;
		padding: 0;
	}

	/* Style the list items */
	ul li {
		text-align: left;
		cursor: pointer;
		position: relative;
		padding: 12px 8px 12px 40px;
		list-style-type: none;
		background: #eee;
		font-size: 15px;
		transition: 0.2s;
		
		/* make the list items unselectable */
		-webkit-user-select: none;
		-moz-user-select: none;
		-ms-user-select: none;
		user-select: none;
	}
	</style>
</head>
<body>
	<a href="http://www.crosslogic-consulting.com"><img id="logo" src="logo.png" /></a>
	<h1><?php echo "Hello ".($_ENV["NAME"]?$_ENV["NAME"]:"world")."!"; ?></h1>
	<p style="margin: -20 0 0 0;font-size: 10px"><?php echo "Version: ".$_ENV["VERSION"]; ?></p>
	<h3><?php if($_ENV["HOSTNAME"]) {?><h3>My hostname is <?php echo $_ENV["HOSTNAME"]; ?></h3><?php } ?>
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

	<br>
	<br>
	<br>
	<br>
	<br>
	<ul id="listLinks">
		<h1 style="text-align: left">Other resources</h1>
		<li><a href="upload.php">Testing persistentStorage</a></li>
		<li><a href="todo.php">Testing localStorage</a></li>
	</ul>

	
</body>
</html>
