import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

class MainScene extends Scene
{
	private static var _backgrounds:Array<String> = ["img/level1.png"];
	
	public static var Instance:MainScene;
	public var ThisPlayer:Player;
	public var ThisSong:Song;
	
	public var Level:Int;
	
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
		addGraphic(new Image(_backgrounds[Level - 1]), 100);

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
	
	override public function update() 
	{
		ThisSong.Update();

		super.update();
	}
}
