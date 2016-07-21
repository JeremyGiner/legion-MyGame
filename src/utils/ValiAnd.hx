package utils;

/**
 * @author GINER Jérémy
 */

class ValiAnd<C> implements IValidator<C> {
	
	var _aV :List<IValidator<C>>;
	
	public function new( aV :Array<IValidator<C>> ) {
		_aV = new List<IValidator<C>>
		for ( oV in aV )
			_aV.push( oV );
	}
	
	public function validate( o :C ) {
		for ( oV in _aV )
			if ( oV.validate( o ) == false )
				return false;
		return true;
	};
}