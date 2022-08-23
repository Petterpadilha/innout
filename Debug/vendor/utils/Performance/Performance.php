<?php

class Performance {
    
    static protected $perfStack = [];

    protected $times = [];
    protected $name;

    public function __construct($name){

        $this->name = $name;
        $this->flag('start');
        return $this;
    }

    public function flag($name){

        $this->times[$name] = microtime(true);
        return $this;
    }
    public function stop(){

        $this->flag($this->name);
        return $this;
    }
    public function audit(){

        $timeStack = [];
        foreach($this->times as $name => $time){

            if(isset($lastTime)){

                $timeStack[$name] = $time - $lastTime;
            }
            $lastTime = $time;
        }

        return (object) $timeStack;
    }

    static public function start($name){

        $inst = new self($name);
        self::$perfStack[$name] = $inst;
        return $inst;
    }


    static public function finnish($name){

        return self::$perfStack[$name]->stop()->audit();
    }
}