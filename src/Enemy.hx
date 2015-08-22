package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
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
		MainScene.Shake(1, 5);
		
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
}
