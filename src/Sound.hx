package;

import com.haxepunk.Sfx;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class Sound
{
	private static inline var Ext:String = #if flash ".mp3" #else ".ogg" #end;

	public static function Load(source:Dynamic, complete:Void->Void=null)
	{
		return new Sfx(source + Ext, complete);
	}
}
