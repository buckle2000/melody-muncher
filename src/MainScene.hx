import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Emitter;
import openfl.media.SoundTransform;

class MainScene extends Scene
{
	public var Score:Int = 0;
	public var Chain:Int = 0;
	
	public static var Instance:MainScene;
	public var ThisPlayer:Player;
	public var ThisSong:Song;
	
	public var Level:Int;
	
	public var MainEmitter:Emitter = new Emitter("img/particles.png", 32, 32);

	private var _stars:Array<Spritemap> = new Array<Spritemap>();
	
	private var _shakeIntensity:Int = 0;
	private var _shakeTime:Int = 0;
	
	private static var _scrollRate1:Float = 0.2;
	private static var _scrollRate2:Float = 0.1;
	
	private var _scrollBackground1:Backdrop;
	private var _scrollBackground2:Backdrop;
	
	private var _scoreText:Text = new Text();
	private var _chainText:Text = new Text();
	
	public static var LeftPosition(get, null):Float;
	static function get_LeftPosition()
	{
		return PlayerX - 50;
	}
	public static var RightPosition(get, null):Float;
	static function get_RightPosition()
	{
		return PlayerX + 50;
	}
	public static var LeftHitPosition(get, null):Float;
	static function get_LeftHitPosition()
	{
		return PlayerX - 20;
	}
	public static var RightHitPosition(get, null):Float;
	static function get_RightHitPosition()
	{
		return PlayerX + 20;
	}
	
	public static var FloorY(get, null):Float;
	static function get_FloorY()
	{
		return 150;
	}
	
	public static var PlayerX(get, null):Float;
	static function get_PlayerX()
	{
		return HXP.halfWidth;
	}
	
	public function new(level:Int)
	{
		super();
		Instance = this;
		Level = level;
		
		MainEmitter.newType("tiny", [0]);
		MainEmitter.setMotion("tiny", 0, 30, 10 / 60.0, 360, 50, 10 / 60.0);
		MainEmitter.setAlpha("tiny");
	}
	
	public override function begin()
	{
		// Load level.
		ThisSong = Song.LoadLevel(Level);
		
		if (Level == 1 || Level == 2 || Level == 3) {
			addGraphic(new Image("img/level1_fore.png"), 100);
			addGraphic(new Image("img/level1_back.png"), 1000);
			_scrollBackground1 = new Backdrop("img/level1_scroll1.png");
			addGraphic(_scrollBackground1, 500);
			_scrollBackground2 = new Backdrop("img/level1_scroll2.png");
			addGraphic(_scrollBackground2, 600);
		}

		var playerBackgroundImage = new Image("img/player_background.png");
		playerBackgroundImage.originX = playerBackgroundImage.width / 2;
		playerBackgroundImage.originY = playerBackgroundImage.height;
		addGraphic(playerBackgroundImage, 200, PlayerX, FloorY + 3);

		// Spawn player.
		ThisPlayer = new Player();
		add(ThisPlayer);
		
		// Add particles.
		addGraphic(MainEmitter, -500);
		
		// Add score.
		addGraphic(_scoreText, -600);
		_scoreText.x = HXP.halfWidth - 50;
		_scoreText.y = 200;
		addGraphic(_chainText, -600);
		_chainText.x = HXP.halfWidth - 50;
		_chainText.y = 220;
		
		for (i in 0...5) {
			var star = new Spritemap("img/star.png", 17, 17);
			star.add("0", [0]);
			star.add("1", [1]);
			star.add("2", [2]);
			star.add("3", [3]);
			star.add("4", [4]);
			star.add("5", [5]);
			star.add("6", [6]);
			star.play("0");
			_stars.push(star);
			addGraphic(star, -600, HXP.halfWidth - 17 * 2.5 + i * 17, 180);
		}
		
		// Start level.
		ThisSong.Start();
	}
	
	public static function Shake(intensity:Int, time:Int)
	{
		Instance._shakeIntensity = cast(Math.max(Instance._shakeIntensity, intensity), Int);
		Instance._shakeTime = cast(Math.max(Instance._shakeTime, time), Int);
	}
	
	override public function update() 
	{
		ThisSong.Update();

		HandleShake();
		
		HandleBackdrops();
		
		super.update();
		
		HandleScore();
	}
	
	private function HandleScore()
	{
		_scoreText.text = "Score: " + Score + "/" + Song.CurrentSong.MaxScore;
		_chainText.text = "Chain: " + Chain;
		
		for (i in 0...5) {
			var star:Spritemap = _stars[i];
			
			if (Score / cast(Song.CurrentSong.MaxScore, Float) >= (i + 1) / 5.0) {
				star.play("6");
			} else if (Score / cast(Song.CurrentSong.MaxScore, Float) < (i) / 5.0) {
				star.play("0");
			} else {
				var progress = (Score / cast(Song.CurrentSong.MaxScore, Float)) * 5.0;
				progress = progress - Math.floor(progress);
				if (progress >= 0.0) {
					star.play("0");
				}
				if (progress >= 0.16) {
					star.play("1");
				}
				if (progress >= 0.33) {
					star.play("2");
				}
				if (progress >= 0.5) {
					star.play("3");
				}
				if (progress >= 0.66) {
					star.play("4");
				}
				if (progress >= 0.83) {
					star.play("5");
				}
			}
		}
	}
	
	public function AddChain()
	{
		Chain++;
	}

	public function ResetChain()
	{
		Chain = 0;
	}
	
	private function HandleBackdrops()
	{
		if (_scrollBackground1 != null) {
			_scrollBackground1.x += _scrollRate1;
		}
		if (_scrollBackground2 != null) {
			_scrollBackground2.x += _scrollRate2;
		}
	}
	
	private function HandleShake()
	{
		if (_shakeTime <= 0) {
			HXP.camera.x = 0;
			HXP.camera.y = 0;
			return;
		}
		_shakeTime--;
		
		HXP.camera.x = HXP.rand(_shakeIntensity + 1) * (HXP.rand(2) * 2 - 1);
		HXP.camera.y = HXP.rand(_shakeIntensity + 1) * (HXP.rand(2) * 2 - 1);
	}
}
