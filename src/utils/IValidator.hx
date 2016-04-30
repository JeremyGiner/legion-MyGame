package utils;

/**
 * @author GINER Jérémy
 */

interface IValidator<C> {
	public function check( o :C ) :Bool;
}