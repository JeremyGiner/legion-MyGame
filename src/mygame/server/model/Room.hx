package mygame.server.model;

import mygame.game.MyGame;
import mygame.server.model.Client;
import haxe.ds.IntMap;
import trigger.eventdispatcher.EventDispatcher;

import mygame.connection.message.ResGameStepInput;

import legion.IAction;

import mygame.game.process.MobilityProcess;



class Room {

	var _oGame :MyGame;
	
	var _aoSlot :Array<Client>;
	var _iSlotQuantityMax :Int;
	var _iSpectatorMax :Int = 0;	// -1 : infinite
	
	var _bPlayerSpontaneous :Bool = true; // enable/disable spontaneous player creation
	var _sPasswordShadow :String = '';
	
	var _loAction :List<IAction<MyGame>>;
	
	var _oGamePaceTimer :Float;
	var _fGamePaceLapse :Float = 45;	// in msec, pace in which the room desire to be synchronised 
	
	var _abPause :Array<Bool>;	// indexed by slot id
	
	public var onUpdate :EventDispatcher;

//______________________________________________________________________________
//	Constructor

	public function new( oGame :MyGame ) {
		_oGame = oGame;
		_aoSlot = new Array<Client>();
		_abPause = new Array<Bool>();
		_iSlotQuantityMax = 5;
		for( i in 0..._iSlotQuantityMax )
			_aoSlot[ i ] = null;
		_loAction = new List<IAction<MyGame>>();
		
		onUpdate = new EventDispatcher();
		
		_oGame.onLoop.attach( new MobilityProcess( _oGame ) );
		
		timer_reset();
		
	}
	
//______________________________________________________________________________
//	Accessor

	public function spectatorMax_get() { return _iSpectatorMax; }
	public function spectatorMax_set( iSpectatorMax :Int ) { _iSpectatorMax = iSpectatorMax; }
	
	public function client_get( iSlotId :Int ) { return _aoSlot[ iSlotId ]; }
	
	public function clientList_get() {
		var loClient = new List<Client>();
		for( oClient in _aoSlot )
			if( oClient != null )
				loClient.push( oClient );
		return loClient;
	}
	
	public function pauseList_get() {
		trace(_aoSlot);
		trace(_abPause);
		return _abPause;
	}
	
	public function paused_get() :Bool {
		
		if ( _abPause.length == 0 )
			return true;
		
		for ( bPlayerReady in _abPause ) {
			if ( !bPlayerReady )
				return true;
		}
		
		return false;
	}
	
	public function slotIndex_get_byClient( oClient :Client ) {
		
		for ( i in 0..._aoSlot.length )
			if( _aoSlot[i] == oClient ) 
				return i;
		return null;
	}
	
	public function game_get() { return _oGame; }
	
	public function gameActionList_get() { return _loAction; }
	
	public function gameSpeed_get() { return _fGamePaceLapse; }
	
	public function timerExpire_check() { return _oGamePaceTimer < Date.now().getTime(); }
	
//______________________________________________________________________________
//	Modifier

	public function clientReady_update( oClient :Client, bReady :Bool )  {
		var iSlotIndex = slotIndex_get_byClient( oClient );
		
		if ( iSlotIndex == null ) {
			trace( 'invalid client for clientReady_update' );
			return null;
		}
		
		_abPause[ iSlotIndex ] = bReady;
		
		onUpdate.dispatch( this );
		
		return this;
	}
	
	public function slot_occupy( oClient :Client, iSlotId :Int ) :Int {
		//TODO : check client
		//TODO : constraint to 1 match per client
		trace('occupying #'+iSlotId);
		
		// Check slot id validity
		if ( !slotIdInRange_check( iSlotId ) ) 
			//return null;
			throw('slot not in range');
		
		// Check if the slot is available
		if ( slotOccupy_check( iSlotId ) ) 
			throw('slot #'+iSlotId+' is unavailable :'+_aoSlot[ iSlotId ]);
			//return null;
		
		// Occupy slot
		oClient.room_set( this, iSlotId );
		_aoSlot[ iSlotId ] = oClient;
		_abPause[ iSlotId ] = false;
		
		trace('create');
		trace(_abPause);
		
		return iSlotId;
	}
	
	public function slot_leave( oClient :Client ) {
		trace('Client #'+oClient.resource_get()+'leaving slot #'+oClient.slotId_get());
		//TODO : chack client's slot and room
		_aoSlot[ oClient.slotId_get() ] = null;
		var i = oClient.slotId_get();
		_abPause.slice( i, i);
	}
	
	// return : true = occupy; false = free
	public function slotOccupy_check( iSlotId :Int ) :Bool {
		if ( client_get( iSlotId ) == null ) 
			return false;
		return true;
	}
	
	public function slotFreeAny_get() {
		for( i in 0..._iSlotQuantityMax )
			if( _aoSlot[ i ] == null )
				return i;
		return null;
	}
	
	public function slotFreeList_get() {
		//TODO
		throw('not implemented yet');
	}
	
	public function gameAction_add( oAction :IAction<MyGame> ) { 
		_loAction.push( oAction ); 
	}
	
//______________________________________________________________________________
//	Utils

	public function process() {
		
		//Process input
		for( oInput in _loAction ) {
			_oGame.action_run( oInput );
		}
		
		// Process the game
		_oGame.loop();
		
		//Test
		//trace( 'Expire overflow : '+( Date.now().getTime() - _oGamePaceTimer  ) );
		
		// Reset timer
		timer_reset();
		
		// Flush input stack
		_loAction = new List<IAction<MyGame>>();
		
	}
	
	function timer_reset() {
		_oGamePaceTimer = Date.now().getTime() +_fGamePaceLapse;
	}
	
	function slotIdInRange_check( iSlotId :Int ) :Bool {
		if( iSlotId >= 0 && iSlotId < _iSlotQuantityMax )
			return true;
		return false;
	}
//______________________________________________________________________________
//	Sub-routine

	
}
