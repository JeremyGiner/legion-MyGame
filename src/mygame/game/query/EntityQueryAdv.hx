package mygame.game.query;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import legion.entity.Entity;
import legion.IQuery;
import mygame.game.ability.EntityAbility;
import mygame.game.ability.Loyalty;
import mygame.game.ability.UnitAbility;
import mygame.game.entity.Unit;
import mygame.game.MyGame;
import mygame.game.entity.City;
import mygame.game.tile.Tile;
import mygame.game.utils.IValidatorEntity;
import mygame.game.utils.validatorentity.ValiAbility;
import mygame.game.utils.validatorentity.ValiAllianceEntity;
import space.Vector2i;
import trigger.*;
import mygame.game.ability.Position;
import trigger.EventDispatcher2;
import utils.IValidator;
import utils.ListTool;
import utils.MapTool;

/**
 * ValidatorInRange
 * 	-> register key to manager
 *  -> mainCache.data_get()
 * on change
 * 	-> dispatch
 * 		-> trigger manager trick
 * 			-> get list of dispatcher
 * 			-> dispatch
 * 	
 * 
 * @author GINER Jérémy
 */
class EntityQueryAdv implements IQuery < MyGame, Bool, IntMap<Entity> > implements ITrigger {
	
	var _oGame :MyGame;
	
	var _mCache :IntMap<Entity>;
	var _mCacheValid :IntMap<ValidationCache>;
	
	var _aValidator :Array<IValidatorEntity>;
	var _aEventFilter :Array <IValidator<Dynamic>>;
	var _aEventDispatcher :Array<IEventDispatcher>;
	
	var _mValidatorRouter :Map<Int,Array<Int>>;
	
	
	/**
	 * A list of entity in wait to be processed
	 */
	var _mEntityQueue :Map<Int,Entity>;
	
	var _onSourceNew :EventDispatcher2<Entity>;
	var _onSourceDispose :EventDispatcher2<Entity>;
	
	public var onNew :EventDispatcher2<Entity>;
	public var onDispose :EventDispatcher2<Entity>;
	
	// DEBUG
	var iNope :Int = 0;
	var iYes :Int = 0;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( 
		oGame :MyGame, 
		aValidator :Array<IValidatorEntity>, 
		aEventDispatcher :Array<IEventDispatcher> = null,
		aValidatorMap :Array<Array<Int>> = null,
		aEventFilter :Array <IValidator<Dynamic>> = null
	) {
		_aEventFilter = (aEventFilter!=null)?aEventFilter:[];
		_mEntityQueue = new Map<Int,Entity>();
		
		if ( aValidator.length > 32 )
			throw('length too hight');
		
		_aValidator = aValidator;
		//_aEventDispatcher = aEventDispatcher != null ? aEventDispatcher : [];
		_aEventDispatcher = aEventDispatcher;
		_mValidatorRouter = new Map<Int,Array<Int>>();
		for ( i in 0...aValidatorMap.length )
			_mValidatorRouter.set( i, aValidatorMap[i] );
		_oGame = oGame;
		
		_mCache = null;
		
		// trigger
		_onSourceNew = _oGame.onEntityNew;
		_onSourceDispose = _oGame.onEntityDispose;
		_onSourceNew.attach( this );
		_onSourceDispose.attach( this );
		
		for ( oEventDispatcher in _aEventDispatcher ) {
			oEventDispatcher.attach( this );
		}
		
		onNew = new EventDispatcher2<Entity>();
		onDispose = new EventDispatcher2<Entity>();
	}
	
//_____________________________________________________________________________
//	Accessor
	
	public function data_get( o :Bool ) :IntMap<Entity> {
		
		if ( _mCache == null )
			_cache_init();
		
		// Process Queue
		_queue_process();
		
		return _mCache;
	}
	
//_____________________________________________________________________________
//	Sub-routine
	/**
	 * 101011 result
	 * 110000 check 
	 * 101111 value justifing of a true false result on validation
	 * 
	 * todo : find better name
	 * @param	oEntity
	 * @param	aValidatorMap
	 */
	function _haveNegativeValidation( oValidationCache :ValidationCache ) {
		
		// Get somthing
		// note : not( check ) == check^0xFFFF
		var i = (( oValidationCache.iCheck^0xFFFF ) | oValidationCache.iResult);
		
		return ( i != 0xFFFF );
	}
	
	function _validation_init( oEntity :Entity ) {
		var oValidResult = { iResult: 0xFFFF, iCheck: 0xFFFF };
		
		// Validate mapped validator until a false is found
		var bValidation = null;
		var bSkip = false;
		for ( iValidatorIndex in 0..._aValidator.length ) {
			if ( bSkip ) {
				oValidResult.iCheck = _bit_clr( oValidResult.iCheck, iValidatorIndex );
			} else {
				bValidation = _aValidator[ iValidatorIndex ].validate( oEntity );
				oValidResult.iResult = bValidation?
					_bit_set( oValidResult.iResult, iValidatorIndex ):
					_bit_clr( oValidResult.iResult, iValidatorIndex );
				//oValidResult.iCheck = _bit_set( oValidResult.iCheck, iValidatorIndex ); Done by default
				
				if ( bValidation == false )
				bSkip = true;
			}
			
		}
		
		// Store validation
		_mCacheValid.set( oEntity.identity_get(), oValidResult );
		
		// Store entity if valid
		if ( oValidResult.iResult == 0xFFFF && oValidResult.iCheck == 0xFFFF )
			_mCache.set( oEntity.identity_get(), oEntity );
	}
	/**
	 * 
	 * @param	oEntity
	 * @param	oValidResult
	 * @return	true on modification
	 */
	function _validation_update( oEntity :Entity, oValidResult :ValidationCache ) {
		
		// Validate mapped validator until a false is found
		var bValidation = null;
		
		for ( iValidatorIndex in 0..._aValidator.length ) {
			
			// Skip up to date validation
			if ( _bit_read( oValidResult.iCheck, iValidatorIndex ) == 1 )
				continue;
			
			// Validate
			bValidation = _aValidator[ iValidatorIndex ].validate( oEntity );
			oValidResult.iResult = bValidation?
				_bit_set( oValidResult.iResult, iValidatorIndex ):
				_bit_clr( oValidResult.iResult, iValidatorIndex );
			oValidResult.iCheck = _bit_set( oValidResult.iCheck, iValidatorIndex );
			
			// Stop loop at first negative validation
			if (  bValidation == false )
				break;
		}
	}
	
	function _bit_set( i :Int, iBitIndex :Int ) :Int {
		return i | (1 << iBitIndex);
	}
	function _bit_clr( i :Int, iBitIndex :Int ) :Int {
		return i & (~(1 << iBitIndex));
	}
	function _bit_read( i :Int, iBitIndex :Int ) :Int {
		return ( i >> iBitIndex) & 1;
	}

	function _queue_process() {
		
		var lEntityQueue :List<Entity> = MapTool.toList( _mEntityQueue );
		if ( lEntityQueue.length == 0 )
			return;
		
		for ( oEntity in lEntityQueue ) {
			var oValidResult = _mCacheValid.get( oEntity.identity_get() );
			_validation_update( oEntity, oValidResult );
			
			// Update cache
			if ( oValidResult.iResult == 0xFFFF && oValidResult.iCheck == 0xFFFF ) {
				_mCache.set( oEntity.identity_get(), oEntity );
			} else {
				_mCache.remove( oEntity.identity_get() );
			}
		}
		
		// Flush queue
		_mEntityQueue = new Map<Int,Entity>();
	}
	function _cache_init() {
		
		_mCache = new IntMap<Entity>();
		_mCacheValid = new IntMap<ValidationCache>();
		
		// Create new cache
		for ( oEntity in _oGame.entity_get_all() ) {
			_validation_init( oEntity );
		}
		
	}
	
	function _something( oEntity :Entity, iEventDispatcherIndex :Int ) {
		//______________
		var oValidResult = _mCacheValid.get( oEntity.identity_get() );
		var aValidatorMapped = _mValidatorRouter.get( iEventDispatcherIndex );//TDOO
		
		// Set mapped validator as undefined
		for ( iValidatorIndex in aValidatorMapped ) {
			oValidResult.iCheck = _bit_clr( oValidResult.iCheck, iValidatorIndex );
		}
		
		
		// Case : entity have a false on validator that are not mapped to this eventdispatcher
		if ( _haveNegativeValidation( oValidResult ) ) {
			return;
		}
		
		_mEntityQueue.set( oEntity.identity_get(), oEntity );
	}
	
//_____________________________________________________________________________
//	Trigger

	public function trigger( oSource :IEventDispatcher ) {
		
		// Case : no cache to update
		if ( _mCache == null )
			return;
		
		//_______________
		if ( oSource == _onSourceNew ) {
			_validation_init( _onSourceNew.event_get() );
			return;
		}
		
		if ( oSource == _onSourceDispose ) {
			var oEntity = _onSourceDispose.event_get();
			_mCache.remove( oEntity.identity_get() );
			_mCacheValid.remove( oEntity.identity_get() );
			_mEntityQueue.remove( oEntity.identity_get() );
			return;
		}
		
		//______________
		// Get index of source
		
		var iEventDispatcherIndex = null;
		
		if ( _aEventDispatcher[3] == oSource )
			iEventDispatcherIndex = 3;
		else
		
		for ( i in 0..._aEventDispatcher.length )
			if ( _aEventDispatcher[i] == oSource )
				iEventDispatcherIndex = i;
		
		// Check event filter
		if ( 
			_aEventFilter[ iEventDispatcherIndex ] != null &&
			!_aEventFilter[ iEventDispatcherIndex ].validate( oSource.event_get() )
		) {
			this.iNope ++;
			return;
		}
		this.iYes ++;
		//_______________
		
		var oEntity :Entity = null;
		if ( Std.is( oSource.event_get(), Array )) {
			var aEntity :Array<Entity> = cast oSource.event_get();
			for ( oEntity in aEntity )
				_something( oEntity, iEventDispatcherIndex );
			return;
		} else if ( Std.is( oSource.event_get(), Entity ) ) {
			oEntity = cast oSource.event_get();
		} else if ( Std.is( oSource.event_get(), Position ) ) {
			oEntity = cast oSource.event_get().unit_get();
		} else if ( Std.is( oSource.event_get(), EntityAbility ) ) {
			oEntity = cast oSource.event_get().entity_get();
		} else if ( Std.is( oSource.event_get(), UnitAbility ) ) {
			oEntity = cast oSource.event_get().unit_get();
		} else {
			//Case : ability add / remove : EventEntityAbility
			oEntity = cast oSource.event_get().entity;
		}
		_something( oEntity, iEventDispatcherIndex );
		
	}
//_____________________________________________________________________________
//	Disposer

	public function dispose() {
		// trigger
		_oGame.onEntityNew.remove( this );
		_oGame.onEntityDispose.remove( this );
		
		for ( oEventDispatcher in _aEventDispatcher ) {
			oEventDispatcher.remove( this );
		}
	}
}

private typedef ValidationCache = {
	var iResult :Int;	// Store result of validators
	var iCheck :Int; 	// store check mark of if validation is up to date
}