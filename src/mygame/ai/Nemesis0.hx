package mygame.ai;
import legion.entity.Entity;
import legion.entity.Player;
import math.Random;
import mygame.game.ability.Guidance;
import mygame.game.ability.Platoon;
import mygame.game.ability.Position;
import mygame.game.ability.Roster;
import mygame.game.action.UnitOrderMove;
import mygame.game.entity.Player;
import mygame.game.ability.LoyaltyShift;
import mygame.game.ability.LoyaltyShifter;
import mygame.game.action.UnitOrderBuy;
import mygame.game.entity.City;
import mygame.game.entity.Factory;
import mygame.game.entity.Soldier;
import mygame.game.MyGame;
import legion.IAction;
import mygame.game.ability.BuilderFactory;
import mygame.game.entity.Unit;
import mygame.game.query.EntityQuery;
import mygame.game.query.EntityDistance;
import mygame.game.query.UnitQuery;
import mygame.game.query.ValidatorEntity;
import utils.ListTool;
/**
 * ...
 * @author GINER Jérémy
 */
class Nemesis0 {

	var _oPlayer :Player; 
	var _oGame :MyGame;
	
	
	//_____
	var _iNextBuild :Int;	// next offer
	var _oShop :Factory;
	var _oShopAbility :BuilderFactory;
	
	var _oQueryMyUnit :EntityQuery;
	
	var _aObjective :Array<Entity>;
	
	
	var _aBO :Array<Int>;
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame, oPlayer :Player ) {
		
		_aBO = [ 0, 0, 0, 1 ];
		_aBO.reverse();
		
		_oGame = oGame;
		_oPlayer = oPlayer;
		
		_iNextBuild = null;
		
		_oShop = _shop_get();
		_oShopAbility = _oShop.ability_get(BuilderFactory);
		_oQueryMyUnit = new EntityQuery( _oGame, new ValidatorEntity(['player' => _oPlayer]) );
		
		_aObjective = [];
		var lCity = _oGame.query_get(UnitQuery).data_get(['type' => City]);
		// Convert
		for ( oEntity in lCity )
			_aObjective.push( oEntity );
	}
	
//_____________________________________________________________________________
//	Accessor
	
	
	public function action_get() {
		
		// Skip a few turn
		if ( _oGame.loopId_get() % 100 != 0 )
			return [];
		
		var aAction = new Array<IAction<MyGame>>();
		
		// Shop handle
		var oBuildOrder = _buildOrder_get();
		if ( oBuildOrder != null )
			aAction.push( oBuildOrder );
		
		//_____________________________
		// Get unit on spawn point
		var lUnit = _unitAtSpawnPoint_get();
		
		// Send those unit at random objective
		for ( oUnit in lUnit ) {
			var oObjective = _aObjective[ _random() % _aObjective.length ];
			aAction.push( 
				new UnitOrderMove( cast oUnit, oObjective.ability_get(Position).clone(), 0 )
			);
		}
		
		return aAction;
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	function _buildOrder_get() {
		var aOffer = _oShopAbility.offerArray_get();
		// Get type of next build
		if ( _iNextBuild == null ) {
			
			
			_iNextBuild = (_aBO.length != 0 ) ?
				_aBO.pop() :
				_random() % aOffer.length;
		}
		
		// Check price
		if( aOffer[_iNextBuild].cost_get() > _oPlayer.credit_get() )
			return null;
		
		// Create order
		var oOrder = new UnitOrderBuy( _oShop, _iNextBuild );
		_iNextBuild = null;
		return oOrder;
	}
	
	function _shop_get() :Factory {
		for ( oEntity in _oGame.entity_get_all() ) {
			if ( 
				Std.is( oEntity, Factory ) &&	//Assume factory have shop ability
				untyped oEntity.owner_get() == _oPlayer
			) return cast oEntity;
		}
		
		throw('Nemesis0 can not find shop');
	}
	
	function _unitAtSpawnPoint_get() {
		var lUnit = new List<Entity>();
		for ( oEntity in _oQueryMyUnit.data_get(null) ) {
			var oPlatoon = oEntity.ability_get(Platoon);
			if ( oPlatoon != null && oPlatoon.commander_get() != oEntity )
				continue;
			
			var oGuidance = oEntity.ability_get(Guidance);
			if ( oGuidance == null )
				continue;
			var l = oGuidance.waypointList_get();
			if ( l.length != 0 )
				continue;
			if ( 
				oEntity != _oShop &&
				_oGame.singleton_get(EntityDistance).data_get([cast oEntity, cast _oShop]).get() < 10000 
			)
				lUnit.push( oEntity );
		}
		return lUnit;
	}
	
	function _random() {
		return (new Random( Math.floor( Date.now().getTime() ) ).int());
	}
	
	/**
	 * Score an entity type ability to destroy another entity type
	 * @param	sEntityClassName
	 * @param	sTargetClassName
	 */
	static function weakness_check( sEntityClassName :String, sTargetClassName :String ) {
		var mScore = [
			'mygame.game.entity.Bazoo:mygame.game.entity.Tank' => 1,
		];
	}
}