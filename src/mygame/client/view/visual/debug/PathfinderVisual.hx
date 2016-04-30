package mygame.client.view.visual.debug;

import js.three.*;

import mygame.client.view.GameView;
import mygame.game.utils.PathFinderFlowField in Pathfinder;

class PathfinderVisual implements IVisual {
	var _oLine :Line = null;
	var _oPathfinder :Pathfinder;
	var _oGameView :GameView;
	
	public static var oInstance :PathfinderVisual = null;
	
	public function new( oGameView :GameView, oPathfinder :Pathfinder ){
		_oGameView = oGameView;
		_oPathfinder = oPathfinder;
		
		if ( oPathfinder == null ) {
			trace('[DEBUG]:PathfinderVisual:oPathfinder is null');
			return;
		}
		
		update();
		
		oInstance = this;
		
		_oGameView.scene_get().add( this.object3d_get() );
	}
	
	public function update() {
		if ( _oPathfinder == null ) return;
		
		var material = new LineBasicMaterial({ color: 0xff00ff });
		
		// Building geometry from pathfinder
		var geometry = new Geometry();
		for( i in 0..._oPathfinder.worldmap_get().sizeX_get() ) 
			for( j in 0..._oPathfinder.worldmap_get().sizeY_get()) {
				if ( _oPathfinder.refTile_getbyCoord(i, j) == null ) continue;
				var v = _oPathfinder.refMapDiff_get(i,j);//vector_get(i,j);
				if( v != null ) {
					//trace( v);
					geometry.vertices.push( new Vector3( i-0.2, j-0.2, 0 ) );
					geometry.vertices.push( new Vector3( i+0.2, j+0.2, 0 ) );
					
					geometry.vertices.push( new Vector3( i+0.2, j-0.2, 0 ) );
					geometry.vertices.push( new Vector3( i-0.2, j+0.2, 0 ) );
					
					geometry.vertices.push( new Vector3( i, j, 0 ) );
					geometry.vertices.push( new Vector3( i +(v.x*0.5), j +(v.y*0.5), 0 ) );
					
					//geometry.vertices.push( new Vector3( 0, 100, 0 ) );
					//geometry.vertices.push( new Vector3( 0, 0, 0 ) );
				}
			}
			
		if( _oLine != null ) {
			var scene = _oLine.parent;
			scene.remove( _oLine );
			_oLine = new Line( geometry, material );
			//_oLine.scale.set( GameView.WORLDMAP_MESHSIZE,GameView.WORLDMAP_MESHSIZE,GameView.WORLDMAP_MESHSIZE );
			_oLine.position.set( 2500, 2500, 2501 );
			_oLine.scale.set(10000,10000,10000);
			scene.add( _oLine );
		} else {
			_oLine = new Line( geometry, material );
			//_oLine.scale.set( GameView.WORLDMAP_MESHSIZE,GameView.WORLDMAP_MESHSIZE,GameView.WORLDMAP_MESHSIZE );
			_oLine.position.set( 2500,2500,2501 );
			_oLine.scale.set(10000,10000,10000);
		}
	}
	
	public function pathfinder_set( oPathfinder :Pathfinder ) {
		_oPathfinder = oPathfinder;
		update();
	};
	
	public function object3d_get() :Object3D { return _oLine; }
}