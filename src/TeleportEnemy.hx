package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class TeleportEnemy extends Enemy
{
	private var _spritemap:Spritemap = new Spritemap("img/strongenemy.png", 32, 32);
	private var _firstHit:Bool = false;

	public function new()
	{
		super(_spritemap);
		_spritemap.originX = _spritemap.width / 2;
		_spritemap.originY = _spritemap.height;
		_spritemap.add("walk", [0, 1], 5);
		_spritemap.add("walk2", [2, 3], 5);
		_spritemap.play("walk");
	}
	
	override public function Reset(beat:Float, left:Bool)
	{
		// TODO: Randomization, etc.
		
		super.Reset(beat, left);
		_spritemap.play("walk");
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
			_spritemap.play("walk2");
			// Move back.
			Beat = Beat + 0.5;
			
			// Insert in other list and flip.
			_spritemap.flipped = !_spritemap.flipped;
			Song.CurrentSong.EnemyList(Left).remove(this);
			Left = !Left;
			Song.CurrentSong.EnemyList(Left).insert(0, this);
		}
	}
	
	override public function update():Void 
	{
		super.update();
		
		Pulse(_spritemap);
	}
}
