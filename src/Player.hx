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
	
	public function new()
	{
		super(MainScene.PlayerX, MainScene.FloorY, _spritemap);
		layer = 0;
		type = "player";
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