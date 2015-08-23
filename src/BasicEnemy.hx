package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class BasicEnemy extends Enemy
{
	private var _spritemap:Spritemap = new Spritemap("img/basicenemy.png", 24, 24);

	public function new()
	{
		super(_spritemap);
		_spritemap.originX = _spritemap.width / 2;
		_spritemap.originY = _spritemap.height;
		_spritemap.add("walk", [0, 1], 5);
		_spritemap.play("walk");
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
		MainScene.Instance.Score++;
		MainScene.Instance.AddChain();
	}
	
	override public function update():Void 
	{
		super.update();
		
		Pulse(_spritemap);
	}
}
