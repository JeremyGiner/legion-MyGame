package mygame.spirit.motor;

/**
 * @author GINER Jérémy
 */

interface IMotor<COut> {
	public function resolution_get() :Int;
	public function out_get() :COut;
	
}