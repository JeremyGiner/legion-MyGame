<?php

class mygame_game_misc_weapon_EDamageType extends Enum {
	public static $Bullet;
	public static $Flamme;
	public static $Laser;
	public static $Shell;
	public static $Torpedo;
	public static $__constructors = array(0 => 'Bullet', 4 => 'Flamme', 3 => 'Laser', 1 => 'Shell', 2 => 'Torpedo');
	}
mygame_game_misc_weapon_EDamageType::$Bullet = new mygame_game_misc_weapon_EDamageType("Bullet", 0);
mygame_game_misc_weapon_EDamageType::$Flamme = new mygame_game_misc_weapon_EDamageType("Flamme", 4);
mygame_game_misc_weapon_EDamageType::$Laser = new mygame_game_misc_weapon_EDamageType("Laser", 3);
mygame_game_misc_weapon_EDamageType::$Shell = new mygame_game_misc_weapon_EDamageType("Shell", 1);
mygame_game_misc_weapon_EDamageType::$Torpedo = new mygame_game_misc_weapon_EDamageType("Torpedo", 2);
