package mygame.game.misc;
import legion.entity.Entity;
import mygame.game.misc.weapon.EDamageType;

/**
 * ...
 * @author GINER Jérémy
 */
interface IHit{

	public function damage_get() :Int;
	public function targetId_get() :Int;
	public function damageType_get() :EDamageType;
}