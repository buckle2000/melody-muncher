import com.haxepunk.Scene;

class MainScene extends Scene
{
	public static var Instance:MainScene;
	public var ThisPlayer:Player;
	public var ThisSong:Song;
	
	public static var LeftPosition(get, null):Float;
	static function get_LeftPosition()
	{
		return 200;
	}
	public static var RightPosition(get, null):Float;
	static function get_RightPosition()
	{
		return 400;
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
		ThisPlayer = new Player(200, 250, 0);
		add(ThisPlayer);
	}
	
	override public function update() 
	{
		ThisSong.Update();

		super.update();
	}
}
