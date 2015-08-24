import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Main extends Engine
{
	public static inline var kVersion:String = "v1.11";

	override public function init()
	{
		HXP.randomizeSeed();
		
		#if debug
		HXP.console.enable();
		#end
		
		HXP.screen.scale = 2;
		HXP.screen.smoothing = false;
		//HXP.scene = new MenuScene();
		//HXP.scene = new JukeboxScene();
		//HXP.scene = new MainScene(8);
		HXP.scene = new IntroScene();
		
		Input.define("up", [Key.UP]);
		Input.define("left", [Key.LEFT]);
		Input.define("right", [Key.RIGHT]);
	}

	public static function main() { new Main(1000, 600, 60, false); }
}
