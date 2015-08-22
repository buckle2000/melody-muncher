import com.haxepunk.HXP;
import com.haxepunk.Scene;

class MainScene extends Scene
{
	public static var Instance:MainScene;
	public var ThisPlayer:Player;
	public var ThisSong:Song;
	
	public static var LeftPosition(get, null):Float;
	static function get_LeftPosition()
	{
		return PlayerX - 20;
	}
	public static var RightPosition(get, null):Float;
	static function get_RightPosition()
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
		ThisSong = Song.LoadLevel(level);
	}
	
	public override function begin()
	{
		// Spawn player.
		ThisPlayer = new Player();
		add(ThisPlayer);
		
		ThisSong.Start();
	}
	
	override public function update() 
	{
		ThisSong.Update();

		super.update();
	}
}
