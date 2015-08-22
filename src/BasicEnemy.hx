package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class BasicEnemy extends Enemy
{
	private var _spritemap:Spritemap = new Spritemap("img/player.png", 20, 20);

	public function new(x:Float, y:Float)
	{
		super(x, y, _spritemap);
	}
}