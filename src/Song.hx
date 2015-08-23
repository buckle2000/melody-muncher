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
	
	// TODO: lag calibration in menu
	public static var LagCalibration:Float = 0.0;
	
	// For one side of the timing window.
	public static inline var kDefaultTimingWindow:Float = 0.2;
	
	private var _timingWindow:Float;
	
	var _bpm:Float;
	var _sfx:Sfx;
	var _beatPixelLength:Float;

	// Sorted by time.
	public var LeftEnemies:Array<Enemy> = new Array<Enemy>();
	public var RightEnemies:Array<Enemy> = new Array<Enemy>();
	
	private static var _level1Left:String =
"........ ........ ........ ........" +
"1...1... 1...1... ........ ........ 1...1... 1...1... ........ ........" +
"1.1..... 1.1..... ........ ........ 1.1..... 1.1..... ........ ........" +
"1...1... ....1... 1.1..... ..1..... 1.1..... 1....... ..1...1. ........" +
"";
	private static var _level1Right:String =
"........ ........ ........ ........" +
"........ ........ 1...1... 1...1... ........ ........ 1...1... 1...1..." +
"........ ........ 1.1..... 1.1..... ........ ........ 1.1..... 1.1....." +
"..1...1. 1.1..... ....1.1. 1...1.1. ....1.1. ..1.1... 1...1... 1......." +
"";
	private static var _level2Left:String =
"........ ........ ........ ........" +
"........ 2....... 2....... ........" +
"........ 2.....1. ......1. 2......." +
"2.1..... 2.1..... ....2.1. ....2..." +
"..1...1. ..1..... 2...2... 2.....2." +
"2.2..... ........ 2....... ....1..." +
"2....... 2....... ..2..... ..2.1.1." +
"2....... ........ ........ 2......." +
"2.....1. ........ 2....... ......1." +
"........";
	private static var _level2Right:String =
"........ ........ ........ ........" +
"2....... ........ ........ 2......." +
"2.....1. ........ 2....... ......1." +
"....2.1. ....1.1. 2.1..... 2.1...2." +
"2...2... 2...1.1. ..1...1. ..1.2..." +
"........ ..2.1.1. ..2..... ..1...1." +
"..2..... ..2...1. 2....... 2......." +
"........ 2....... 2....... ........" +
"........ 2.....1. ......1. 2......." +
"1.......";
	
	private static var _levelsLeft:Array<String> = [_level1Left, _level2Left];
	private static var _levelsRight:Array<String> = [_level1Right, _level2Right];
	
	private static var _levelSfxNames:Array<String> = ["sfx/level1", "sfx/level2"];
	private static var _levelsBeatDivision:Array<Float> = [2.0, 2.0];
	private static var _levelBpms:Array<Float> = [125.0, 115.0];
	private static var _levelBeatPixelLengths:Array<Float> = [80.0, 80.0];
	
	private static inline var kBounceTime:Float = 0.1;
	
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

		// Each side of timing window can't be larger than a quarter-beat length.
		result._timingWindow = kDefaultTimingWindow;
		var quarterBeat = result.BeatsToSeconds(0.25);
		//if (result._timingWindow > quarterBeat) {
		//	trace("timing window too large for this song, reduced from " + result._timingWindow + " to " + quarterBeat);
		//	result._timingWindow = quarterBeat;
		//}
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
				EnemyList(left).push(enemy);
			case "2":
				var enemy:StrongEnemy = MainScene.Instance.create(StrongEnemy);
				enemy.Reset(beat, left);
				EnemyList(left).push(enemy);
			default:
				trace("unknown char" + char);
		}
	}
	
	public function EnemyList(left:Bool):Array<Enemy>
	{
		return left ? LeftEnemies : RightEnemies;
	}
	
	public function Start()
	{
		_sfx.play(kMusicVolume);
	}
	
	public function Update()
	{
	}
	
	// Clamps.
	public function BeatToPosition(beat:Float, left:Bool):Float
	{
		var remainingBeats:Float = beat - CurrentBeat();
		var distance:Float = remainingBeats * _beatPixelLength;
		if (left) {
			distance = -distance;
		}
		var startPoint = left ? MainScene.LeftPosition : MainScene.RightPosition;
		var result:Float = distance + startPoint;
		if (left && result > MainScene.LeftHitPosition) {
			return MainScene.LeftHitPosition;
		}
		if (!left && result < MainScene.RightHitPosition) {
			return MainScene.RightHitPosition;
		}
		return result;
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
	
	public function ShouldBounce():Bool
	{
		return CurrentBeat() % 1.0 < kBounceTime || CurrentBeat() % 1.0 > 1.0 - kBounceTime;
	}
	
	public function EnemyToHit(left:Bool):Enemy
	{
		trace(CurrentBeat());
		var enemyList = EnemyList(left);
		
		for (enemy in enemyList) {
			var beatsLeft = enemy.BeatsLeft();
			// Skip if this enemy is already past.
			if (beatsLeft < -_timingWindow) {
				continue;
			}
			
			// Return the enemy if it's withing the timing window.
			if (beatsLeft <= _timingWindow) {
				return enemy;
			}
			
			// Otherwise stop, don't have to check any further enemies.
			break;
		}
		return null;
	}
}
