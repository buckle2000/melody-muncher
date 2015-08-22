import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import StringTools;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class Song
{
	public static inline var kMusicVolume:Float = 0.8;
	public static var LagCalibration:Float = 0.01;
	
	var _bpm:Float;
	var _sfx:Sfx;
	var _beatPixelLength:Float;
	var _enemies:Array<Enemy>;
	
	private static var _level1Left:String =
	".... X.X. ....";
	private static var _level1Right:String =
	".... .... X.X.";
	
	private static var _levelsLeft:Array<String> = [_level1Left];
	private static var _levelsRight:Array<String> = [_level1Right];

	
	public static var CurrentSong(get, null):Song;
	static function get_CurrentSong():Song
	{
		return MainScene.Instance.ThisSong;
	}
	
	public function new()
	{
	}
	
	public static function LoadLevel(level:Int):Song
	{
		var result:Song = new Song();
		result.Load(_levelsLeft[level - 1], _levelsRight[level - 1]);
		return result;
	}
	
	private function Load(leftText:String, rightText:String)
	{
		StringTools.replace(leftText, " ", "");
		StringTools.replace(rightText, " ", "");
		
		for (i in 0...leftText.length) {
			leftText.charAt(i);
		}
	}
	
	public function Update()
	{
	}
	
	// Clamps to left/right side.
	public function BeatToPosition(beat:Float, left:Bool):Float
	{
		var remainingBeats:Float = beat - CurrentBeat();
		if (remainingBeats < 0) {
			remainingBeats = 0;
		}
		var distance:Float = remainingBeats * _beatPixelLength;
		if (left) {
			distance = -distance;
		}
		var startPoint = left ? MainScene.LeftPosition : MainScene.RightPosition;
		return distance + startPoint;
	}
	
	public function BeatsToSeconds(beats:Float):Float
	{
		return beats * _bpm / 60.0;
	}

	public function SecondsToBeats(seconds:Float):Float
	{
		return seconds * 60 / _bpm;
	}
	
	public function CurrentTime():Float
	{
		// Compensate for lag.
		return _sfx.position - LagCalibration;
	}
	
	public function CurrentBeat():Float
	{
		return SecondsToBeats(CurrentTime());
	}
}
