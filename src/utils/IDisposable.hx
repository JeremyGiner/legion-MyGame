package utils;

/**
 * @author GINER Jérémy
 */

interface IDisposable {
  public function dispose():Void;
  public function disposed_check():Bool;
}