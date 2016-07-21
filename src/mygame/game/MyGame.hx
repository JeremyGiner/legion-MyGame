package mygame.game;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import legion.Game;
import legion.LocalBehaviourProcess;
import mygame.game.misc.PositionDistance;
import mygame.game.misc.weapon.WeaponTypeSoldier;
import mygame.game.misc.weapon.WeaponTypeBazoo;
import mygame.game.misc.weapon.WeaponTypeTank;
import mygame.game.query.CityTile;
import mygame.game.query.EntityDistance;
import mygame.game.query.EntityDistanceTile;
import mygame.game.query.EntityDistance;
import mygame.game.query.UnitQuery;
import space.Vector2i;
import trigger.EventDispatcher2;

import mygame.game.entity.Player;

import mygame.game.entity.WorldMap;
import mygame.trigger.*;

import trigger.eventdispatcher.*;

import mygame.game.ability.*;
import mygame.game.entity.*;
import mygame.game.process.*;

import legion.IAction;
import mygame.game.action.UnitDirectControl;
import mygame.game.action.UnitOrderBuy;
import mygame.game.action.UnitOrderMove;

import space.Vector3 in Vector2;

/**
 * Best gam eva
 * 
 * @author GINER Jérémy
 */
class MyGame extends Game {
	
	var _oMap :WorldMap = null;
	
	var _aoPlayer :Array<Player>;
	
	var _oWinner :Player;
	
	var _oPositionDistance :PositionDistance;
	
	var _aAction :IntMap<List<IAction<Dynamic>>>;	//Logs : list of actions indexed by loop id
	
	var _aRoster :Array<Roster>; // indexed by player id
	
	//_____
	
	public var guidance :LocalBehaviourProcess<MyGame,Guidance>;
	public var deploy :LocalBehaviourProcess<MyGame,Deploy>;
	
	//_____
	
	public var onLoop :EventDispatcher;
	public var onLoopEnd :EventDispatcher;
	
	public var onHealthAnyUpdate :EventDispatcher2<Health>;
	public var onLoyaltyAnyUpdate :EventDispatcherFunel<Loyalty>;
	public var onPositionAnyUpdate :EventDispatcherFunel<Position>;
	public var onPositionTileAnyUpdate :EventDispatcherFunel<Position>;
	public var onCreditAnyUpdate :EventDispatcherFunel<Player>;
	//public var onUnitMove :EventDispatcher2<Unit>;
	
	//_____
	
	public var oVictoryCondition :VictoryCondition;
	
	//____

//______________________________________________________________________________
//	Constructor
 
    public function new( oConf :GameConf ){
		super();
		
	//___________
		
		onLoop = new EventDispatcher();
		onLoopEnd = new EventDispatcher();
		
		onHealthAnyUpdate = new EventDispatcher2<Health>();
		onLoyaltyAnyUpdate = new EventDispatcherFunel<Loyalty>();
		onPositionAnyUpdate = new EventDispatcherFunel<Position>();
		onPositionTileAnyUpdate = new EventDispatcherFunel<Position>();
		onCreditAnyUpdate = new EventDispatcherFunel<Player>();
		
		_aoPlayer = new Array<Player>();
		
		_oPositionDistance = new PositionDistance();
		
		_oWinner = null;
		
		_aAction = new IntMap<List<IAction<Dynamic>>>();
		
	//__________________
	// Loading Singleton
		// WeaponType
		_singleton_add( new WeaponTypeBazoo() );
		_singleton_add( new WeaponTypeSoldier() );
		_singleton_add( new WeaponTypeTank() );
		
		// Query
		_singleton_add( new CityTile( this ) );
		_singleton_add( new EntityDistance( this ) );
		_singleton_add( new EntityDistance( this ) );
		_singleton_add( new EntityDistanceTile( this ) );
		_singleton_add( new UnitQuery( this ) );
	
		
	//__________
	// Loading entities
		_oMap = WorldMap.load( 
			{
				iSizeX : oConf.map.sizeX,
				iSizeY : oConf.map.sizeY,
				aoTile : oConf.map.tileArr
			},
			this
		);
		for ( oConfPlayer in oConf.playerArr ) {
			var oPlayer = new Player( this, oConfPlayer.name );
			oPlayer.ability_add( new Roster( this, oConfPlayer.roster ) );
			player_add( oPlayer );
		}
		
		entity_add( _oMap );
		
		entity_add( new City( this, null, _oMap.tile_get( 2, 6 ) ) );
		entity_add( new City( this, null, _oMap.tile_get( 2, 13 ) ) );
		
		entity_add( new City( this, null, _oMap.tile_get( 9, 1 ) ) );
		entity_add( new City( this, null, _oMap.tile_get( 9, 18 ) ) );
		
		entity_add( new City( this, null, _oMap.tile_get( 13, 7 ) ) );
		entity_add( new City( this, null, _oMap.tile_get( 13, 12 ) ) );
		
		var oFactory = new Factory( this, player_get(0), _oMap.tile_get( 3, 2 ) );
		entity_add( oFactory );
		player_get( 0 ).ability_get(Roster).factory_set( oFactory );
		
		oFactory = new Factory( this, player_get(1), _oMap.tile_get( 3, 17 ) );
		entity_add( oFactory );
		player_get( 1 ).ability_get(Roster).factory_set( oFactory );
		
		//entity_add( new Bazoo( this, player_get(0), new Vector2( 2.5, 2.5) ) );
		//entity_add( new Tank( this, player_get(1), new Vector2i( 35000, 35000) ) );
		//entity_add( new Copter( this, player_get(1), new Vector2i( 35000, 35000) ) );
		//entity_add( new PlatoonUnit( this, player_get(1), new Vector2( 3.5, 3.5) ) );
		
		
	//__________________
	// Loading rules(process)
		
		new VolumeEjection( this );
		new MobilityProcess( this );	
		_singleton_add( new WeaponProcess( this ) );
		new LoyaltyShiftProcess( this );
		new Death( this );
		new DeathPlatoon( this );
		new CreditIncome( this );
		new AuraProcess( this );
		oVictoryCondition = new VictoryCondition( this );
		
		guidance = new LocalBehaviourProcess<MyGame,Guidance>( this );
		deploy = new LocalBehaviourProcess<MyGame,Deploy>( this );
		_aProcessCallOrder = [
			guidance,
			deploy
		];
	}

//______________________________________________________________________________
// Process

	public function loop(){
		process();
		
		onLoop.dispatch( this );
		//trace( 'Pre-loop :' + (Date.now().getTime() - iTime) );
		
		onLoopEnd.dispatch( this );
		//trace( 'Post-loop :'+(Date.now().getTime() - iTime) );
	}
	
//______________________________________________________________________________
//	Accessor

	public function log_get() {
		return _aAction;
	}

	public function winner_get() {
		return _oWinner;
	}

	public function map_get(){ 
		//TODO : check if loaded
		return _oMap;
	}
	
	override public function action_run( oAction :IAction<Dynamic> ) :Bool {  
		//TODO : check if compatible with this class of game
		if( !oAction.check( this ) ) 
			return false;
		
		// Save to logs
		if ( _aAction.get(_iLoop) == null )
			_aAction.set( _iLoop, new List<IAction<Dynamic>>() );
		_aAction.get(_iLoop).add( oAction );
		
		// Execute
		oAction.exec( this );
		return true;
	}
	
	public function player_get( iKey:Int ) { return _aoPlayer[ iKey ]; }
	public function player_get_all() { return _aoPlayer; }
	
	public function positionDistance_get() {
		return _oPositionDistance;
	}
	
//______________________________________________________________________________
//	Modifier

	public function end( oWinner :Player ) {
		_oWinner = oWinner;
	}
	
	public function player_add( oPlayer:Player ) {
		var i = _aoPlayer.length;
		_aoPlayer[ i ] = oPlayer;
		oPlayer.playerId_set( i );
		entity_add( oPlayer );
		return i;
	}

//______________________________________________________________________________
//	Utils

	public static function load( oGameState :Dynamic ) :MyGame {
		if( Std.is( oGameState, String ) )
			return haxe.Unserializer.run( cast oGameState );
			
		// Can't resolve
		throw('[ERROR] MyGame : load : can not resolve.');
		return null;
	}
	
	public function save() :String {
		haxe.Serializer.USE_CACHE = true;
		return haxe.Serializer.run( this );
		
	}
	
	
}