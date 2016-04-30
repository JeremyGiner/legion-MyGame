package logicweaver.entity.motor;

/**
 * @author GINER Jérémy
 */

interface IMotor<COut> {
	public function resolution_get() :Int;
	public function translate( aOutNode :Array<Float>) :COut;
	
}