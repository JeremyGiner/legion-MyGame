package mygame.connection;

import haxe.Serializer;
import legion.entity.Entity;

/**
 * Serializer specialized for the use of MyGame and his actions
 * @author GINER Jérémy
 */

class MySerializer extends Serializer {
	
	var _bUseRelative :Bool;	// if true -> serialize Entity only with their id (have priority on the static)
	
	static public var _bUSE_RELATIVE :Bool = false;	// if true -> serialize Entity only with their id
	
//______________________________________________________________________________
//	Constructor
	
	override public function new() {
		super();
		useRelative_set( _bUSE_RELATIVE );
	}

//______________________________________________________________________________
//	Accessor

	function useRelative_set( bUseRelative : Bool ) {
		_bUseRelative = bUseRelative;
	}
	
//______________________________________________________________________________
//	
	
	override public function serialize( v :Dynamic ) :Void {
		if ( _bUseRelative && Std.is(v, Entity) ) {
			buf.add("U");
			serialize( untyped v.identity_get() );
		} else {
			super.serialize( v );
		}
		/*
		switch( Type.typeof( v ) ) {
			case TObject:
			case TClass:

				if ( _bUseRelative && Std.is(v, Entity) ) {
					buf.add("U");
					serialize( untyped v.identity_get() );
				} else
					super.serialize( v );
			default :
				super.serialize( v );
		}*/
	}
	
//______________________________________________________________________________
//
	
	static public function run( v :Dynamic ) {
		var s = new MySerializer();
		s.serialize( v );
		return s.toString();
	}
}