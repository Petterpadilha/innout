<?php
require_once('/home/petter-padilha/Projects/innout/Debug/vendor/autoload.php');
require_once(dirname(__FILE__, 2) . '/src/config/config.php');
// require_once(VIEW_PATH . '/login.php');

require_once(MODEL_PATH . '/Login.php');

$login = new Login([
    'email' => 'admin@projeto.com',
    'password' => 'a'

]);

try {
    $login->CheckLogin();
    echo "Deu certo";

} catch( exception $e ) {
    echo 'Problema no login :p';
}



