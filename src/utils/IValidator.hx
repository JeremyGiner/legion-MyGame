package utils;

/**
 * @author GINER Jérémy
 */

interface IValidator<C> {
	public function validate( o :C ) :Bool;
}