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

	// Amount of beats to miss for.
	private static inline var kMissBeats:Float = 0.50;
	
	private var _spritemap:Spritemap = new Spritemap("img/player.png", 150, 100);
	
	private var _attackPrepStartTime:Float;
	private var _attackPrepLeftPressed:Bool;
	private var _attackPrepRightPressed:Bool;
	
	private var _missStartBeat:Float;
	
	private var _flashTimer:Int = 0;
	
	public function new()
	{
		super(MainScene.PlayerX, MainScene.FloorY + 3, _spritemap);
		_spritemap.originX = _spritemap.width / 2;
		_spritemap.originY = _spritemap.height;
		layer = 0;
		type = "player";
		SetupAnimations();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (MainScene.Instance == null) {
			// don't do anything in intro scene.
			_spritemap.originX = _spritemap.width / 2 + (_spritemap.flipped ? 0 : 1);
			_spritemap.play("idle");
			return;
		}
		
		// Handle input.
		HandleInput();

		HandleBounce();
		
		HandleAttackPrep();
		
		HandleAttacking();
		
		HandleMiss();

		_spritemap.originX = _spritemap.width / 2 + (_spritemap.flipped ? 0 : 1);
		_spritemap.updateBuffer();
		
		HandleFlashing();
	}
	
	public function Flash(time:Int):Void
	{
		_flashTimer = time;
	}
	
	private function HandleFlashing():Void
	{
		if (_flashTimer <= 0) {
			_spritemap.visible = true;
			return;
		}
		
		_flashTimer--;
		_spritemap.visible = _flashTimer % 2 == 0;
	}
	
	private function HandleMiss():Void
	{
		if (_spritemap.currentAnim == "missright" || _spritemap.currentAnim == "missboth" ||
		_spritemap.currentAnim == "bothmissleft" || _spritemap.currentAnim == "bothmissright") {
			if (Song.CurrentSong.CurrentBeat() - _missStartBeat >= kMissBeats) {
				_spritemap.play(Song.CurrentSong.ShouldBounce() ? "bounce" : "idle");
			}
		}
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
		_spritemap.add("intro", [0, 0, 0, 0, 0, 0, 0, 0, 1], 15, true);

		_spritemap.add("idle", [0], 30, true);
		_spritemap.add("bounce", [1], 30, true);
		_spritemap.add("attackprep", [2], 30, true);
		_spritemap.add("attackright", [3, 4, 4], 20, false);
		_spritemap.add("attackboth", [6, 7, 7], 20, false);
		_spritemap.add("missright", [3, 5, 5, 5, 5], 15, false);
		_spritemap.add("missboth", [6, 8, 8, 8, 8], 15, false);
		_spritemap.add("bothmissleft", [6, 10, 10, 10, 10], 15, false);
		_spritemap.add("bothmissright", [6, 11, 11, 11, 11], 15, false);
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
		if (_spritemap.currentAnim == "idle" || _spritemap.currentAnim == "bounce" ||
		_spritemap.currentAnim == "attackright" || _spritemap.currentAnim == "attackboth") {
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
		
		var enemy:Enemy = Song.CurrentSong.EnemyToHit(true);
		if (enemy != null) {
			enemy.Hit();
		} else {
			Sound.Load("sfx/miss").play();
			_spritemap.play("missright");
			_missStartBeat = Song.CurrentSong.CurrentBeat();
			MainScene.Instance.MainEmitter.emit("bad", x - 1, y - 50);
			MainScene.Instance.ResetChain();
		}
	}
	private function AttackRight():Void
	{
		_spritemap.play("attackright");
		_spritemap.flipped = false;

		var enemy:Enemy = Song.CurrentSong.EnemyToHit(false);
		if (enemy != null) {
			enemy.Hit();
		} else {
			Sound.Load("sfx/miss").play();
			_spritemap.play("missright");
			_missStartBeat = Song.CurrentSong.CurrentBeat();
			MainScene.Instance.MainEmitter.emit("bad", x - 1, y - 50);
			MainScene.Instance.ResetChain();
		}
	}
	private function AttackBoth():Void
	{
		_spritemap.play("attackboth");
		
		var enemyLeft:Enemy = Song.CurrentSong.EnemyToHit(true);
		if (enemyLeft != null) {
			enemyLeft.Hit();
		}
		var enemyRight:Enemy = Song.CurrentSong.EnemyToHit(false);
		if (enemyRight != null) {
			enemyRight.Hit();
		}
		if (enemyLeft == null && enemyRight == null) {
			Sound.Load("sfx/miss").play();
			_spritemap.play("missboth");
			_missStartBeat = Song.CurrentSong.CurrentBeat();
			MainScene.Instance.MainEmitter.emit("bad", x - 1, y - 50);
			MainScene.Instance.ResetChain();
		} else if (enemyLeft == null) {
			Sound.Load("sfx/miss").play();
			_spritemap.play("bothmissleft");
			_spritemap.flipped = false;
			_missStartBeat = Song.CurrentSong.CurrentBeat();
			MainScene.Instance.MainEmitter.emit("bad", x - 1, y - 50);
			MainScene.Instance.ResetChain();
		} else if (enemyRight == null) {
			Sound.Load("sfx/miss").play();
			_spritemap.play("bothmissright");
			_spritemap.flipped = false;
			MainScene.Instance.MainEmitter.emit("bad", x - 1, y - 50);
			_missStartBeat = Song.CurrentSong.CurrentBeat();
			MainScene.Instance.ResetChain();
		}
	}
}