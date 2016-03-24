package mygame.client.model;

import mygame.game.MyGame in Game;
import trigger.eventdispatcher.*;

import mygame.game.entity.Unit;

import haxe.ds.StringMap;

class UnitSelection {

	var _oGame :Game = null;
	var _oUnitList :List<Unit>;
	var _oUnitSelection :StringMap<List<Unit>>;	// Sorted by type
	
	public var onUpdate :EventDispatcher;
	
//______________________________________________________________________________
//	Constructor

	public function new( oGame :Game ) {
		_oGame = oGame;
		
		_oUnitList = new List<Unit>();
		_oUnitSelection = new StringMap<List<Unit>>();
		
		onUpdate = new EventDispatcher();
	}
//______________________________________________________________________________
//	Accessor

	public function game_get() { return _oGame; }
	
	public function unitSelection_get() { return _oUnitSelection; }
	
	public function unit_remove( oUnit :Unit ) :Bool {
		
		// Get class name
		var sClassName = unitClassName_get( oUnit );
		
		// 
		var oUnitList = _oUnitSelection.get( sClassName );
		if( oUnitList == null )
			return false;
		var res = oUnitList.remove( oUnit );
		_oUnitList.remove( oUnit );
		
		// Trigger
		onUpdate.dispatch( this );
		
		// 
		return res;
	}
	public function remove_all() {
		for( oUnitList in _oUnitSelection ) {
			oUnitList.clear();
		}
		_oUnitList.clear();
		onUpdate.dispatch( this );
	}
	public function unit_add( oUnit :Unit ) {
		
		// Get class name
		var sClassName = unitClassName_get(oUnit);
		
		// Create container for the className if does not exist
		if( _oUnitSelection.get(sClassName) == null )
			_oUnitSelection.set( sClassName, new List<Unit>());
		
		// Aplly change
		_oUnitSelection.get( sClassName).add( oUnit );
		_oUnitList.add( oUnit );
		
		// Trigger
		onUpdate.dispatch( this );
	}
	
	public function unitList_get() { 
		_update();
		return _oUnitList; 
	}
	public function unitList_get_byClass<CAbility:Unit>( oClass :Class<CAbility> ) :CAbility {
		// Check if oClass derived from IEntityAbility
		return cast _oUnitSelection.get( Type.getClassName( oClass ) );
	}

/*	public function unitList_get_byType( sClassName :String ) {
		
	}*/
//______________________________________________________________________________
//	Sub-routine

	function _update() {
		// Remove disposed unit frm the list
		var l = new List<Unit>();
		for (  oUnit in _oUnitList ) {
			if ( !oUnit.dispose_check() )
				l.add( oUnit );
		}
		_oUnitList = l;
	}
//______________________________________________________________________________
//	Utils

	function unitClassName_get( oUnit :Unit ) {
		return Type.getClassName( Type.getClass( oUnit ) );
	}
	
}