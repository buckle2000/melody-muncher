import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class Player extends Entity
{
	private var _spritemap:Spritemap = new Spritemap("img/player.png", 20, 20);
	private var _playerNumber:Int;
	
	public function new(x:Float, y:Float, playerNumber:Int)
	{
		super(x, y, _spritemap);
		layer = 0;
		type = "player";
		_playerNumber = playerNumber;
	}
	
	override public function update():Void 
	{
		super.update();

		// Handle input.
		HandleInput();
	}
	
	private function HandleInput():Void
	{
		
	}
}