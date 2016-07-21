package mygame.client.view.visual.entity;
import haxe.ds.StringMap;
import legion.entity.Entity;
import mygame.client.view.GameView;
import mygame.client.view.visual.EntityVisual;

//import mygame.client.view.visual.entity.*;
import mygame.client.view.visual.entity.ProjectileVisual;
import mygame.client.view.visual.entity.WorldMapVisual;

//@:build(haxe.macro.Compiler.include('mygame.client.view.visual.entity') )

/**
 * Create an EntityVisual given an Entity
 * @author GINER Jérémy
 */
class EntityVisualFactory {

	var _oGameView :GameView;
	
	/**
	 * 
	 */
	var _mCache :Map<String,Class<EntityVisual<Dynamic>>>;
	
	public function new( oGameView :GameView ) {
		_oGameView = oGameView;
		_mCache = new Map<String,Class<EntityVisual<Dynamic>>>();
	}
	
	function _class_get( oClass :Class<Entity> ) {
		
		var sClassName = Type.getClassName( oClass );
		
		// Case : cache need update
		if ( !_mCache.exists( sClassName ) ) {
			// Create entry
			var a = sClassName.split('.');
			var sShortName = a[ a.length - 1 ];
			
			var oClassVisual = Type.resolveClass( 'mygame.client.view.visual.entity.' + sShortName + 'Visual' );
			_mCache.set( sClassName, cast oClassVisual );
		}
		
		return _mCache.get( sClassName );
	}
	
	public function create( oEntity :Entity ) :EntityVisual<Dynamic> {
		
		var oClass = _class_get( Type.getClass( oEntity ) );
		if ( oClass == null )
			return null;
		
		return cast Type.createInstance( 
			oClass, 
			[
				_oGameView, 
				oEntity
			]
		);
		
	}
}