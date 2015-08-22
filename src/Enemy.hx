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
	
	public function new(x:Float, y:Float, graphic:Graphic, beat:Float, left:Bool)
	{
		super(x, y, graphic);
		Beat = beat;
		Left = left;
	}
	
	override public function update():Void 
	{
		x = Song.CurrentSong.BeatToPosition(Beat, Left);
		
		super.update();
	}
}
