package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class BasicEnemy extends Enemy
{
	private var _spritemap:Spritemap = new Spritemap("img/basicenemy.png", 16, 24);

	public function new()
	{
		super(_spritemap);
		_spritemap.originX = _spritemap.width / 2;
		_spritemap.originY = _spritemap.height;
	}
	
	override public function Reset(beat:Float, left:Bool)
	{
		// TODO: Randomization, etc.
		
		super.Reset(beat, left);
		_spritemap.flipped = !left;
		_spritemap.updateBuffer();
	}
	
	override public function Hit():Void 
	{
		super.Hit();
		Sound.Load("sfx/munchnormal").play();
		
		Destroy();
	}
	
	override public function update():Void 
	{
		super.update();
		
		Pulse(_spritemap);
	}
}
