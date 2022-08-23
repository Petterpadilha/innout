<?php

if (!function_exists('dd')) {
    function dd()
    {
        $args = func_get_args();
        call_user_func_array('dump', $args);
        die();
    }
}

if (!function_exists('d')) {
    function d()
    {
        $args = func_get_args();
        call_user_func_array('dump', $args);
    }
}

if (!function_exists('dds')) {
    function dds($sql)
    {
        
        if(is_array($sql)){
            $sql = implode(";", $sql);
        }
        
        echo SqlFormatter::format($sql);
        die();
    }
}

if (!function_exists('ds')) {
    function ds($sql)
    {
        
        if(is_array($sql)){
            $sql = implode(";", $sql);
        }
        
        echo SqlFormatter::format($sql);
    }
}