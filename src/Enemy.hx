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
	}
	
	override public function update():Void 
	{
		x = Song.CurrentSong.BeatToPosition(Beat, Left);
		
		super.update();
	}
}
