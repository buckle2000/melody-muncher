package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class Enemy extends Entity
{
	// When to actually hit the player.
	private static inline var kAttackBeat:Float = -0.5;
	
	public var Beat:Float;
	public var Left:Bool;
	
	public function new(graphic:Graphic)
	{
		super(0, 0, graphic);
	}
	
	public function Reset(beat:Float, left:Bool)
	{
		Beat = beat;
		Left = left;
		y = MainScene.FloorY;
	}
	
	override public function update():Void 
	{
		x = Song.CurrentSong.BeatToPosition(Beat, Left);
		
		if (BeatsLeft() <= kAttackBeat) {
			Attack();
		}
		
		super.update();
	}
	
	public function BeatsLeft():Float
	{
		return Beat - Song.CurrentSong.CurrentBeat();
	}
	
	public function Hit():Void
	{
		// Camera shake.
		MainScene.Shake(1, 3);
		
		// Particles.
		for (i in 0...30) {
			MainScene.Instance.MainEmitter.emit("tiny", x, y);
		}
		
		// Overridden in base classes.
	}
	
	public function Attack():Void
	{
		Destroy();
	}
	
	public function Destroy():Void
	{
		MainScene.Instance.recycle(this);
		Song.CurrentSong.EnemyList(Left).remove(this);
	}
	
	private function Pulse(spritemap:Spritemap)
	{
		if (Song.CurrentSong.CurrentBeat() % 1.0 < 0.05 || Song.CurrentSong.CurrentBeat() % 1.0 > 1.0 - 0.05) {
			spritemap.color = 0xAAAAAA;
		} else if (Song.CurrentSong.CurrentBeat() % 1.0 < 0.1 || Song.CurrentSong.CurrentBeat() % 1.0 > 1.0 - 0.1) {
			spritemap.color = 0xCCCCCC;
		} else {
			spritemap.color = 0xFFFFFF;
		}
	}
}
