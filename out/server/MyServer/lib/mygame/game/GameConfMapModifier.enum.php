<?php

class mygame_game_GameConfMapModifier extends Enum {
	public static $MirrorX;
	public static $MirrorY;
	public static $None;
	public static $__constructors = array(1 => 'MirrorX', 2 => 'MirrorY', 0 => 'None');
	}
mygame_game_GameConfMapModifier::$MirrorX = new mygame_game_GameConfMapModifier("MirrorX", 1);
mygame_game_GameConfMapModifier::$MirrorY = new mygame_game_GameConfMapModifier("MirrorY", 2);
mygame_game_GameConfMapModifier::$None = new mygame_game_GameConfMapModifier("None", 0);
