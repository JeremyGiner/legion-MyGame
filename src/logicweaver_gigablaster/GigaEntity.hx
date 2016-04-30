package logicweaver_gigablaster;

import logicweaver.entity.Entity;
import logicweaver.entity.sensor.Const;
import logicweaver.node.NodeNetASMLike;
import logicweaver_gigablaster.motor.EndTurn;
import logicweaver_gigablaster.motor.UnitOrder;
import logicweaver_gigablaster.motor.MotorEyeball;
import logicweaver_gigablaster.sensor.Context;
import logicweaver_gigablaster.sensor.Eyeball;

/**
 * 
 * 
 * @author GINER Jérémy
 */

class GigaEntity extends Entity {
	
	var _oGame :Dynamic;
	var _iPlayerId :Dynamic;
	
//_____________________________________________________________________________
// Constructor

	public function new( 
		iIdentity :Int, 
		sOrigin :String,
		oNodeNet :NodeNetASMLike
	) {
		//Sys.println('generating entity #'+iIdentity);
		var oEyeball = new Eyeball( this );
		super(
			iIdentity,
			sOrigin,
			oNodeNet,
			[
				new Context( this ),
				new Const([for(i in 0...11) i]),
				oEyeball,
			],
			[
				new EndTurn(),
				new UnitOrder(),
				new MotorEyeball( oEyeball ),
			]
		);
		
		_oGame = null;
		_iPlayerId = null;
	}
	
//_____________________________________________________________________________
//	Accessor

	/**
	 * Player id the entity play as
	 */
	public function playerId_get() {
		return _iPlayerId;
	}
	
	public function game_get() {
		return _oGame;
	}
	
//_____________________________________________________________________________
//	Modifier
	
	public function context_set( oGame :Dynamic, iPlayerId :Int ) {
		_oGame = oGame;
		_iPlayerId = iPlayerId;
	}
	
//_____________________________________________________________________________
//	Process
	
	override public function process() {
		//Check context
		if ( _oGame == null || _iPlayerId == null )
			throw('invalid context');
		
		return super.process();
	}
	
//_____________________________________________________________________________
//	Disposer

	override public function dipose() {
		// Not necessary for this object
	}
	

	
}