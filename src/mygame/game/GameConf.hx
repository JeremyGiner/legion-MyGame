package mygame.game;

/**
 * ...
 * @author GINER Jérémy
 */
typedef GameConf = {
	var playerArr :Array<GameConfPlayer>;
	var map :GameConfMap;
	
}

typedef GameConfMap = {
	var sizeX :Int;
	var sizeY :Int;
	var tileArr :Array<Array<Int>>;
	var unitArr :Array<Int>;
	var modifier :GameConfMapModifier;
}

typedef GameConfPlayer = {
	var name :String;
	//TODO: color
	var roster :Array<String>;
}

enum GameConfMapModifier {
	None;
	MirrorX;
	MirrorY;
	//TODO: proc gen
}

class GameConfFactory {
	//______________________________________________________________________________
// Utils

	static public function gameConfDefault_get() :GameConf {
		return {
			playerArr: [
				{ 
					name: 'Player 0 (blue)', 
					roster: [
						'mygame.game.entity.Soldier',
						'mygame.game.entity.Bazoo',
						'mygame.game.entity.Tank',
					] 
				},
				{ 
					name: 'Player 1 (yellow)',
					roster: [
						'mygame.game.entity.Soldier',
						'mygame.game.entity.Bazoo',
						'mygame.game.entity.Tank',
					]
				}
			],
			map: {
				sizeX: 15,
				sizeY: 10,
				tileArr: [
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,1,2,4,4,4,4,4,1,2,1,1,1,0],
					[0,1,1,2,4,2,0,1,4,1,1,1,1,1,0],
					[0,1,1,4,4,0,0,0,4,1,3,1,4,1,0],
					[0,1,1,4,1,0,0,0,4,1,3,1,4,1,0],
					[0,1,4,4,1,0,0,2,4,4,4,4,4,1,0],
					[0,1,1,1,1,1,1,2,2,1,0,0,4,0,0],
					[0,0,1,1,1,1,1,1,1,1,0,0,1,1,0],
					[0,0,0,1,3,1,3,2,1,1,4,1,1,1,0],
					[0,0,0,1,1,1,1,0,0,0,0,0,0,4,0]
				],
				unitArr: [
				//TODO
				],
				modifier: MirrorX				
			}
		}
	}
}