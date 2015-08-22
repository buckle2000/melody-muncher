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
		SetupAnimations();
	}
	
	override public function update():Void 
	{
		super.update();
		
		// Handle input.
		HandleInput();

		HandleBounce();
	}
	
	private function SetupAnimations():Void
	{
		_spritemap.add("idle", [0], 30, true);
		_spritemap.add("bounce", [1], 30, true);
		_spritemap.add("attackprep", [2], 30, true);
		_spritemap.add("attackleft", [2], 30, true);
		_spritemap.add("attackright", [2], 30, true);
		_spritemap.add("attackboth", [2], 30, true);
		_spritemap.play("idle");
	}
	
	private function HandleBounce():Void
	{
		if (Song.CurrentSong.ShouldBounce()) {
			if (_spritemap.currentAnim == "idle") {
				_spritemap.play("bounce");
			}
		} else {
			if (_spritemap.currentAnim == "bounce") {
				_spritemap.play("idle");
			}
		}
	}
	
	private function HandleInput():Void
	{
		
	}
	
	private function AttackLeft():Void
	{
		
	}
}