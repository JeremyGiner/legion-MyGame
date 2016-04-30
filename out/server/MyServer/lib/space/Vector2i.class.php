<?php

class space_Vector2i {
	public function __construct($x_ = null, $y_ = null) {
		if(!php_Boot::$skip_constructor) {
		if($y_ === null) {
			$y_ = 0;
		}
		if($x_ === null) {
			$x_ = 0;
		}
		$this->set($x_, $y_);
	}}
	public $x;
	public $y;
	public function hclone() {
		return new space_Vector2i($this->x, $this->y);
	}
	public function copy($oVector) {
		return $this->set($oVector->x, $oVector->y);
	}
	public function length_get() {
		return Math::sqrt($this->x * $this->x + $this->y * $this->y);
	}
	public function dotProduct($v) {
		return $this->x * $v->x + $this->y * $v->y;
	}
	public function distance_get($oVector) {
		return space_Vector2i::distance($this, $oVector);
	}
	public function set($x_, $y_ = null) {
		if($y_ === null) {
			$y_ = 0;
		}
		$this->x = $x_;
		$this->y = $y_;
		return $this;
	}
	public function add($x_, $y_ = null) {
		if($y_ === null) {
			$y_ = 0;
		}
		$this->x += $x_;
		$this->y += $y_;
		return $this;
	}
	public function vector_add($oVector) {
		return $this->add($oVector->x, $oVector->y);
	}
	public function mult($fMultiplicator) {
		$this->x = Math::round($this->x * $fMultiplicator);
		$this->y = Math::round($this->y * $fMultiplicator);
		return $this;
	}
	public function divide($fDivisor) {
		if(_hx_equal($fDivisor, 0)) {
			throw new HException("[ERROR] Vector3 : can not divide by 0.");
		}
		return $this->mult(Math::round(1 / $fDivisor));
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
			$this->x = Math::round($fLength);
		} else {
			$this->mult($fLength / $length);
		}
		return $this;
	}
	public function project($oVector) {
		$fDotprod = $oVector->dotProduct($this);
		$this->copy($oVector)->length_set(Math::abs($fDotprod) / $oVector->length_get());
		return $this;
	}
	public function equal($oVector) {
		return $oVector->x === $this->x && $oVector->y === $this->y;
	}
	public function angleAxisXY() {
		if($this->x === 0 && $this->y === 0) {
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
		return Math::sqrt($dx * $dx + $dy * $dy);
	}
	function __toString() { return 'space.Vector2i'; }
}
