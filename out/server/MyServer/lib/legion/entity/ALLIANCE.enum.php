<?php

class legion_entity_ALLIANCE extends Enum {
	public static $ally;
	public static $ennemy;
	public static $__constructors = array(0 => 'ally', 1 => 'ennemy');
	}
legion_entity_ALLIANCE::$ally = new legion_entity_ALLIANCE("ally", 0);
legion_entity_ALLIANCE::$ennemy = new legion_entity_ALLIANCE("ennemy", 1);
