<?php
	include "conn.php";
	$sql = "SELECT * FROM drink_list;";
	$result = mysqli_query($linki, $sql);
	$data_ary = array();
	while($row = mysqli_fetch_assoc($result))
	{
		$data_ary[$row["id"]] = $row;
	}
	$json_data = json_encode($data_ary);
	echo "$json_data";
?>
