<?php

class space_Vector3 {
	public function __construct($x_ = null, $y_ = null, $z_ = null) {
		if(!php_Boot::$skip_constructor) {
		if($z_ === null) {
			$z_ = 0;
		}
		if($y_ === null) {
			$y_ = 0;
		}
		if($x_ === null) {
			$x_ = 0;
		}
		$this->set($x_, $y_, $z_);
	}}
	public $x;
	public $y;
	public $z;
	public function hclone() {
		return new space_Vector3($this->x, $this->y, $this->z);
	}
	public function copy($oVector) {
		$this->set($oVector->x, $oVector->y, $oVector->z);
	}
	public function set($x_, $y_ = null, $z_ = null) {
		if($z_ === null) {
			$z_ = 0;
		}
		if($y_ === null) {
			$y_ = 0;
		}
		$this->x = $x_;
		$this->y = $y_;
		$this->z = $z_;
		return $this;
	}
	public function add($x_ = null, $y_ = null, $z_ = null) {
		if($z_ === null) {
			$z_ = 0;
		}
		if($y_ === null) {
			$y_ = 0;
		}
		if($x_ === null) {
			$x_ = 0;
		}
		$this->x += $x_;
		$this->y += $y_;
		$this->z += $z_;
		return $this;
	}
	public function mult($fMultiplicator) {
		$this->x *= $fMultiplicator;
		$this->y *= $fMultiplicator;
		$this->z *= $fMultiplicator;
	}
	public function divide($fDivisor) {
		if(!_hx_equal($fDivisor, 0)) {
			$this->mult(1 / $fDivisor);
		} else {
			throw new HException("[ERROR] Vector3 : can not divide by 0.");
		}
	}
	public function normalize() {
		$this->divide($this->length_get());
		return $this;
	}
	public function length_set($fLength) {
		if($fLength < 0) {
			throw new HException("Invalid length : " . _hx_string_rec($fLength, ""));
		}
		$length = $this->length_get();
		if(_hx_equal($length, 0)) {
			$this->x = $fLength;
		} else {
			$this->mult($fLength / $length);
		}
		return $this;
	}
	public function length_get() {
		return Math::sqrt($this->x * $this->x + $this->y * $this->y + $this->z * $this->z);
	}
	public function dotProduct($v) {
		return $this->x * $v->x + $this->y * $v->y + $this->z * $v->z;
	}
	public function vector3_add($oVector) {
		$this->add($oVector->x, $oVector->y, $oVector->z);
	}
	public function vector3_sub($oVector) {
		$this->add(-$oVector->x, -$oVector->y, -$oVector->z);
	}
	public function angleAxisXY() {
		if(_hx_equal($this->x, 0) && _hx_equal($this->y, 0)) {
			return null;
		}
		return Math::atan2($this->y, $this->x);
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
	static function distance($v1, $v2) {
		$dx = $v1->x - $v2->x;
		$dy = $v1->y - $v2->y;
		$dz = $v1->z - $v2->z;
		return Math::sqrt($dx * $dx + $dy * $dy + $dz * $dz);
	}
	function __toString() { return 'space.Vector3'; }
}
