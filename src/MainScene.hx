import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

class MainScene extends Scene
{
	public static var Instance:MainScene;
	public var ThisPlayer:Player;
	public var ThisSong:Song;
	
	public var Level:Int;
	
	private var _shakeIntensity:Int = 0;
	private var _shakeTime:Int = 0;
	
	private static var _scrollRate1:Float = 0.2;
	private static var _scrollRate2:Float = 0.1;
	
	private var _scrollBackground1:Backdrop;
	private var _scrollBackground2:Backdrop;
	
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
	}
	
	public override function begin()
	{
		// Load level.
		ThisSong = Song.LoadLevel(Level);
		
		if (Level == 1 || Level == 2) {
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
