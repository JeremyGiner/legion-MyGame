<?php

class cloner_Cloner {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->stringMapCloner = new cloner_MapCloner($this, _hx_qtype("haxe.ds.StringMap"));
		$this->intMapCloner = new cloner_MapCloner($this, _hx_qtype("haxe.ds.IntMap"));
		$this->classHandles = new haxe_ds_StringMap();
		$this->classHandles->set("String", (isset($this->returnString) ? $this->returnString: array($this, "returnString")));
		$this->classHandles->set("Array", (isset($this->cloneArray) ? $this->cloneArray: array($this, "cloneArray")));
		$this->classHandles->set("haxe.ds.StringMap", (isset($this->stringMapCloner->{"clone"}) ? $this->stringMapCloner->{"clone"}: array($this->stringMapCloner, "hclone")));
		$this->classHandles->set("haxe.ds.IntMap", (isset($this->intMapCloner->{"clone"}) ? $this->intMapCloner->{"clone"}: array($this->intMapCloner, "hclone")));
	}}
	public $cache;
	public $classHandles;
	public $stringMapCloner;
	public $intMapCloner;
	public function returnString($v) {
		return $v;
	}
	public function hclone($v) {
		$this->cache = new haxe_ds_ObjectMap();
		$outcome = $this->_clone($v);
		$this->cache = null;
		return $outcome;
	}
	public function _clone($v) {
		if(Std::is($v, _hx_qtype("String"))) {
			return $v;
		}
		{
			$_g = Type::typeof($v);
			switch($_g->index) {
			case 0:{
				return null;
			}break;
			case 1:{
				return $v;
			}break;
			case 2:{
				return $v;
			}break;
			case 3:{
				return $v;
			}break;
			case 4:{
				return $this->handleAnonymous($v);
			}break;
			case 5:{
				return null;
			}break;
			case 6:{
				$c = _hx_deref($_g)->params[0];
				{
					if(!$this->cache->exists($v)) {
						$this->cache->set($v, $this->handleClass($c, $v));
					}
					return $this->cache->get($v);
				}
			}break;
			case 7:{
				$e = _hx_deref($_g)->params[0];
				return $v;
			}break;
			case 8:{
				return null;
			}break;
			}
		}
	}
	public function handleAnonymous($v) {
		$properties = Reflect::fields($v);
		$anonymous = _hx_anonymous(array());
		{
			$_g1 = 0;
			$_g = $properties->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$property = $properties[$i];
				{
					$value = $this->_clone(Reflect::getProperty($v, $property));
					$anonymous->{$property} = $value;
					unset($value);
				}
				unset($property,$i);
			}
		}
		return $anonymous;
	}
	public function handleClass($c, $inValue) {
		$handle = null;
		{
			$key = Type::getClassName($c);
			$handle = $this->classHandles->get($key);
		}
		if($handle === null) {
			$handle = (isset($this->cloneClass) ? $this->cloneClass: array($this, "cloneClass"));
		}
		return call_user_func_array($handle, array($inValue));
	}
	public function cloneArray($inValue) {
		$array = $inValue->copy();
		{
			$_g1 = 0;
			$_g = $array->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$array[$i] = $this->_clone($array[$i]);
				unset($i);
			}
		}
		return $array;
	}
	public function cloneClass($inValue) {
		$outValue = Type::createEmptyInstance(Type::getClass($inValue));
		$this->cache->set($inValue, $outValue);
		$fields = Reflect::fields($inValue);
		{
			$_g1 = 0;
			$_g = $fields->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$field = $fields[$i];
				$property = Reflect::getProperty($inValue, $field);
				{
					$value = $this->_clone($property);
					$outValue->{$field} = $value;
					unset($value);
				}
				unset($property,$i,$field);
			}
		}
		return $outValue;
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	static function STclone($v) {
		return _hx_deref(new cloner_Cloner())->hclone($v);
	}
	function __toString() { return 'cloner.Cloner'; }
}
