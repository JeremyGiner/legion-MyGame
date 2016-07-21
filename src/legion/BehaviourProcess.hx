package legion;

import haxe.ds.IntMap;
import legion.entity.Entity;
import legion.IBehaviour;

import trigger.*;

//TODO: cf LoyaltyShiftProcess
class BehaviourProcess<CGame:Game,COption> implements ITrigger implements IProcessBehaviour<COption> {

	var _oGame :CGame;
	/**
	 * 
	 */
	var _mOption :IntMap<COption>;	// List of CAbility recently updated 

//______________________________________________________________________________
//	Constructor

	function new( oGame :CGame ) {
		_oGame = oGame;
		_mOption = new IntMap<COption>();
		
		_oGame.onEntityDispose.attach( this );
	}
	
//______________________________________________________________________________
//	Accessor
	
	public function hasEntity( oEntity :Entity ) :Bool {
		return _mOption.exists( oEntity.identity_get() );
	}
	
	public function option_get( oEntity :Entity ) {
		return _mOption.get( oEntity.identity_get() );
	}

//______________________________________________________________________________
//	Modifier

	public function add( oEntity :Entity, oOption :COption ) {
		_mOption.set( oEntity.identity_get(), oOption );
		oEntity.behaviour_add( this );
	}
	
	public function remove( oEntity :Entity ) {
		_mOption.remove( oEntity.identity_get() );
	}
	
//______________________________________________________________________________
//	Process
	
	public function process() {
		throw('override me');
	} 
	
//______________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) :Void { 
		
		// on entity remove
		if( oSource == _oGame.onEntityDispose ) {
			this.remove( _oGame.onEntityDispose.event_get() );
			return;
		}
	}
}