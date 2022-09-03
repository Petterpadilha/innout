<?php
require_once('/home/petter-padilha/Projects/innout/Debug/vendor/autoload.php');
require_once(dirname(__FILE__, 2) . '/src/config/config.php');
require_once(dirname(__FILE__, 2) . '/src/models/User.php');

$user = new User(['name' => 'lucas', 'email'=> 'lucas@projeto.com']);
// dd($user);

$user->email = 'lucas@projeto.com.br';

dd($user);
