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
	// Only one frame of attack prep for now.
	private static inline var kAttackPrepTime:Float = 0.00;
	
	private var _spritemap:Spritemap = new Spritemap("img/player.png", 20, 20);
	
	private var _attackPrepStartTime:Float;
	private var _attackPrepLeftPressed:Bool;
	private var _attackPrepRightPressed:Bool;
	
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
		
		HandleAttackPrep();
		
		HandleAttacking();
		
		_spritemap.updateBuffer();
	}
	
	private function HandleAttacking():Void
	{
		if (_spritemap.currentAnim == "attackright" || _spritemap.currentAnim == "attackboth") {
			if (_spritemap.complete) {
				_spritemap.play(Song.CurrentSong.ShouldBounce() ? "bounce" : "idle");
			}
		}
	}
	
	private function HandleAttackPrep():Void
	{
		if (_spritemap.currentAnim != "attackprep") {
			return;
		}
		
		var time:Float = Song.CurrentSong.CurrentTime() - _attackPrepStartTime;
		if (time > kAttackPrepTime) {
			if (_attackPrepLeftPressed && _attackPrepRightPressed) {
				AttackBoth();
			} else if (_attackPrepLeftPressed) {
				AttackLeft();
			} else if (_attackPrepRightPressed) {
				AttackRight();
			}
		}
	}
	
	private function SetupAnimations():Void
	{
		_spritemap.add("idle", [0], 30, true);
		_spritemap.add("bounce", [1], 30, true);
		_spritemap.add("attackprep", [2], 30, true);
		_spritemap.add("attackright", [3,6,5], 30, false);
		_spritemap.add("attackboth", [10,11,12,13], 60, false);
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
		if (_spritemap.currentAnim == "idle" || _spritemap.currentAnim == "bounce") {
			if (Input.pressed("left") || Input.pressed("right")) {
				_spritemap.play("attackprep");
				_attackPrepStartTime = Song.CurrentSong.CurrentTime();
				_attackPrepLeftPressed = Input.pressed("left");
				_attackPrepRightPressed = Input.pressed("right");
			}
		} else if (_spritemap.currentAnim == "attackprep") {
			_attackPrepLeftPressed = _attackPrepLeftPressed || Input.pressed("left");
			_attackPrepRightPressed = _attackPrepRightPressed || Input.pressed("right");
		}
	}
	
	private function AttackLeft():Void
	{
		_spritemap.play("attackright");
		_spritemap.flipped = true;
	}
	private function AttackRight():Void
	{
		_spritemap.play("attackright");
		_spritemap.flipped = false;
	}
	private function AttackBoth():Void
	{
		_spritemap.play("attackboth");
	}
}