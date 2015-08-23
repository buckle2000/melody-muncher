package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class StrongEnemy extends Enemy
{
	private var _spritemap:Spritemap = new Spritemap("img/strongenemy.png", 16, 24);
	private var _firstHit:Bool = false;

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
		_firstHit = false;
		_spritemap.flipped = !left;
		_spritemap.updateBuffer();
	}
	
	override public function Hit():Void 
	{
		super.Hit();
		
		if (_firstHit) {
			Destroy();
			Sound.Load("sfx/munchstrong2").play();
		} else {
			Sound.Load("sfx/munchstrong1").play();
			_firstHit = true;
			// Move back.
			Beat = Beat + 0.5;
		}
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (Song.CurrentSong.ShouldBounce()) {
			_spritemap.color = 0x808080;
		} else {
			_spritemap.color = 0xFFFFFF;
		}
	}
	
}
