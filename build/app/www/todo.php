<html>
<head>
	<title>Hello world!</title>
	<link href='//fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" type="text/css" href="todo.css">
	<style>
	body {
		background-color: white;
		text-align: center;
		padding: 50px;
		font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;

		margin: 0;
		min-width: 250px;
	}

	</style>
</head>
<body>

	<br>
	<div style="margin:0 250 0 250" id="myList" class="header">
		<h3 style="margin:5px">Task List</h3>
		<p style="margin: 0 0 15 0;font-size: 10px">Stored to local storage on /data</p>
		<input type="text" id="myInput" placeholder="New task name...">
		<span onclick="newElement()" class="addBtn">Add</span>
	</div>

	<ul id="myUL">
		<li>Hit the gym</li>
		<li>Wash the car</li>
		<li class="checked">Pay bills</li>
	</ul>

	<script src="todo.js"></script>

</body>
</html>
