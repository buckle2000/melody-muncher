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
	"........ 1.1..... 1.1.....";
	private static var _level1Right:String =
	"........ ....1.1. ....1.1.";
	
	private static var _levelsLeft:Array<String> = [_level1Left];
	private static var _levelsRight:Array<String> = [_level1Right];
	
	private static var _levelSfxNames:Array<String> = ["sfx/level1"];
	private static var _levelsBeatDivision:Array<Float> = [2.0];
	private static var _levelBpms:Array<Float> = [135.0];
	private static var _levelBeatPixelLengths:Array<Float> = [100.0];
	
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
		result.Load(_levelsLeft[level - 1], _levelsRight[level - 1], _levelsBeatDivision[level - 1]);
		result._sfx = Sound.Load(_levelSfxNames[level - 1]);
		result._bpm = _levelBpms[level - 1];
		result._beatPixelLength = _levelBeatPixelLengths[level - 1];
		return result;
	}
	
	private function Load(leftText:String, rightText:String, beatDivision:Float)
	{
		leftText = StringTools.replace(leftText, " ", "");
		rightText = StringTools.replace(rightText, " ", "");
		
		for (i in 0...leftText.length) {
			var beat = i / beatDivision;
			ProcessChar(leftText.charAt(i), beat, true);
			ProcessChar(rightText.charAt(i), beat, false);
		}
	}
	
	private function ProcessChar(char:String, beat:Float, left:Bool)
	{
		switch(char) {
			case ".":
				// Do nothing.
			case "1":
				var enemy:BasicEnemy = MainScene.Instance.create(BasicEnemy);
				enemy.Reset(beat, left);
			default:
				trace("unknown char" + char);
		}
	}
	
	public function Start()
	{
		_sfx.play(kMusicVolume);
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
		return beats * 60 / _bpm;
	}

	public function SecondsToBeats(seconds:Float):Float
	{
		return seconds * _bpm / 60.0;
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
