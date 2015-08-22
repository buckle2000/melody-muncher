import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Main extends Engine
{
	public static inline var kVersion:String = "v0.00";

	override public function init()
	{
		HXP.randomizeSeed();
		
		#if debug
		HXP.console.enable();
		#end
		
		HXP.screen.scale = 2;
		HXP.screen.smoothing = false;
		HXP.scene = new MainScene(1);
		
		Input.define("player0_up", [Key.UP]);
		Input.define("player0_left", [Key.LEFT]);
		Input.define("player0_right", [Key.RIGHT]);
	}

	public static function main() { new Main(1000, 600, 60, false); }
}
