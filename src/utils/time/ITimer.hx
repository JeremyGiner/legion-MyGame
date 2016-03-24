package utils.time;

interface ITimer {

	public function isExpired_get():Bool;
	
	public function expire_get():Int;
	
	public function expirePercent_get():Float;
}