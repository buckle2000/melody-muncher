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

	public function new()
	{
		super(_spritemap);
	}
	
	override public function Reset(beat:Float, left:Bool)
	{
		// TODO: Randomization, etc.
		
		super.Reset(beat, left);
	}
}
