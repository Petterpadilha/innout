<?php
require_once('/home/petter-padilha/Projects/innout/Debug/vendor/autoload.php');
require_once(dirname(__FILE__, 2) . '/src/config/database.php');

$sql = "SELECT * FROM users";


$result = Database::getResultFromQuery($sql);

while($row = $result->fetch_assoc()) {
        print_r($row);
        echo '</br>';


}
