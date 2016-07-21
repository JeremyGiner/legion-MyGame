package mygame.game.query;
import haxe.ds.IntMap;
import mygame.game.MyGame;
import mygame.game.utils.CascadingValiEntity;
import mygame.game.utils.CascadingValiEntityCompoAnd;
import trigger.IEventDispatcher;
import utils.CascadingValue;
import legion.entity.Entity;
import utils.IValidator;

/**
 * ...
 * @author GINER Jérémy
 */
class CascadingEntityList extends CascadingValue<IntMap<Entity>> {

	var _oGame :MyGame;
	
	var _aVali :Array<IValidator<Entity>>;
	
	var _mCascadingChildrenQueue :IntMap<CascadingValiEntityCompoAnd>;
	var _mCascadingChildren :IntMap<CascadingValiEntityCompoAnd>;
	
	public function new( oGame :MyGame, aVali :Array<IValidator<Entity>>  ) {
		
		_aVali = aVali;
		_oGame = oGame;
		
		_mCascadingChildrenQueue = new IntMap<CascadingValiEntityCompoAnd>();
		_mCascadingChildren = new IntMap<CascadingValiEntityCompoAnd>();
		
		super([ _oGame.onEntityNew, _oGame.onEntityDispose ]);
		_oValue = new IntMap<Entity>();
		
		for ( o in _oGame.entity_get_all() ) {
			_entity_init( o );
		}
		
		
	}
	
	function _entity_init( o :Entity ) {
		
		var oCasca = new CascadingValiEntityCompoAnd( o, _aVali );
		_aDispatcher.push( oCasca.onUpdate );
		oCasca.onUpdate.attach( this );
		
		_mCascadingChildren.set( o.identity_get(), oCasca );
		_mCascadingChildrenQueue.set( o.identity_get(), oCasca );
	}
	
	
	
	override function _update() {
		// process updated value
		for( oCasca in _mCascadingChildrenQueue ) {
			var oEntity = oCasca.entity_get();
			if ( oCasca.get() == true ) 
				_oValue.set( oEntity.identity_get(), oEntity );
			else
				_oValue.remove( oEntity.identity_get() );
		}
		
		_mCascadingChildrenQueue = new IntMap<CascadingValiEntityCompoAnd>();
	}
	
	override public function trigger(oSource:IEventDispatcher) {
		
		if ( oSource == _oGame.onEntityNew ) {
			_entity_init( _oGame.onEntityNew.event_get() );
		} else if ( oSource == _oGame.onEntityDispose ) {
			var o = _oGame.onEntityDispose.event_get();
			var iKey = o.identity_get();
			var oCasca = _mCascadingChildren.get( iKey );
			
			oCasca.onUpdate.remove( this );
			_aDispatcher.remove( oCasca.onUpdate );
			
			_oValue.remove( iKey );
			
			_mCascadingChildren.remove( iKey );
			_mCascadingChildrenQueue.remove( iKey );
		} else {
		//Assume it's a cascading value update
			// Set triggering cascading 
			var oCasca :CascadingValiEntityCompoAnd = cast oSource.event_get();
			_mCascadingChildrenQueue.set( oCasca.entity_get().identity_get(), oCasca );
		}
		
		// Set up to date flag 
		super.trigger(oSource);
	}
	
}