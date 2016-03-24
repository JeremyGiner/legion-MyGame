package legion.ability;

//import legion.IError;

interface IAbility {

	//public function id_get():Int;
/*
	public function user_set( oUnit :Unit ):Void;
	public function user_check():Bool;

	public function target_set( oTarget :Dynamic ):Void;
	public function target_check():Bool;
	
	public function use():Void;*/
	
	//public function error_get():IError;
	
	public function dispose() :Void;
	
	public function mainClassName_get() :String;
}