package mygame.ai;
import legion.entity.Entity;
import legion.entity.Player;
import mygame.game.ability.Guidance;
import mygame.game.ability.Position;
import mygame.game.entity.PlatoonUnit;
import mygame.game.entity.Player;
import mygame.game.ability.LoyaltyShift;
import mygame.game.ability.LoyaltyShifter;
import mygame.game.action.UnitOrderBuy;
import mygame.game.entity.City;
import mygame.game.entity.Factory;
import mygame.game.MyGame;
import legion.IAction;
import mygame.game.ability.BuilderFactory;
import mygame.game.entity.Unit;
import mygame.game.query.UnitDist;
import mygame.game.query.UnitQuery;
import utils.ListTool;
/**
 * ...
 * @author GINER Jérémy
 */
class Nemesis0 {

	var _oPlayer :Player; 
	var _oGame :MyGame;
	
	
	//_____
	
	var _oShop :Factory;
	
//_____________________________________________________________________________
//	Constructor
	
	public function new( oGame :MyGame, oPlayer :Player ) {
		_oGame = oGame;
		_oPlayer = oPlayer;
		
		_oShop = _shop_get();
	}
	
//_____________________________________________________________________________
//	Accessor
	
	
	public function action_get() {
		
		//return [];
		
		var aAction = new Array<IAction<MyGame>>();
		
		// Shop handle
		var iMoney = _oPlayer.credit_get();
		
		if ( iMoney > 10 )
			aAction.push( new UnitOrderBuy( _oShop, 0 ) );
		/*
		for ( oUnit in _oGame.unitList_get() ) {
			oUnit.
		}
		*/
		
		if ( _oGame.loopId_get() % 10 == 0 )
			return [];
		
		// Get all infantry not guarding a city
		var lIdler = _infantryIdler_get();
		
		
		// Get untagged city
		var lCity = _oGame.query_get(UnitQuery).data_get(['type'=>City, 'owner' => _oGame.player_get(0)]);
		lCity = ListTool.merged_get( 
			lCity, 
			_oGame.query_get(UnitQuery).data_get(['type' => City, 'owner' => null ])
		);
		
		for ( oIdler in lIdler ) {
			var oCity = lCity.pop();
			oIdler.ability_get(Guidance).goal_set( oCity.ability_get(Position) );
		}
		
		
		return aAction;
	}
	
//_____________________________________________________________________________
//	Sub-routine
	
	
	function _shop_get() :Factory {
		for ( oEntity in _oGame.entity_get_all() ) {
			if ( 
				Std.is( oEntity, Factory ) &&	//Assume factory have shop ability
				untyped oEntity.owner_get() == _oPlayer
			) return cast oEntity;
		}
		
		throw('Nemesis0 can not find shop');
	}
	
	function _infantryIdler_get() {
		var lIdler = new List<Unit>();
		
		// Iterate throught infantry
		for ( oUnit0 in _oGame.query_get(UnitQuery).data_get(['type'=>PlatoonUnit, 'owner'=>_oPlayer ]) ) {
			
			// Filter busy infantry
			if( oUnit0.ability_get(Guidance).goal_get() != null)
				continue;
			
			var bIsClose = false;
			
			// Iterate throught cities
			for( oUnit1 in _oGame.query_get(UnitQuery).data_get(['type'=>City ]) ) {
				
				// Test distance
				var d = _oGame.query_get(UnitDist).data_get([ oUnit0, oUnit1 ]);
				if ( d > LoyaltyShift.RANGE )
					continue;
				
				bIsClose = true;
				break;
			}
			
			if ( !bIsClose )
				lIdler.add( oUnit0 );
		}
		
		return lIdler;
	}
}