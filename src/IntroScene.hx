import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.media.SoundTransform;

class IntroScene extends Scene
{
	public static var Instance:IntroScene;
	public var ThisPlayer:Player;
	
	private static var _scrollRate1:Float = 0.2;
	private static var _scrollRate2:Float = 0.1;
	
	private var _scrollBackground1:Backdrop;
	private var _scrollBackground2:Backdrop;
	
	private var _fadeOutFader:Image = new Image("img/white.png");
	private var _fadeOutTimer:Int = 0;
	private var kFadeDuration:Int = 120;
	
	private var _timer:Int = 0;
	
	public function new()
	{
		super();
		Instance = this;
	}
	
	public override function begin()
	{
		
		//if (Level == 1 || Level == 2 || Level == 3) {
			addGraphic(new Image("img/level1_fore.png"), 100);
			addGraphic(new Image("img/level1_back.png"), 1000);
			_scrollBackground1 = new Backdrop("img/level1_scroll1.png");
			addGraphic(_scrollBackground1, 500);
			_scrollBackground2 = new Backdrop("img/level1_scroll2.png");
			addGraphic(_scrollBackground2, 600);
		//}

		var playerBackgroundImage = new Image("img/player_background.png");
		playerBackgroundImage.originX = playerBackgroundImage.width / 2;
		playerBackgroundImage.originY = playerBackgroundImage.height;
		addGraphic(playerBackgroundImage, 200, MainScene.PlayerX, MainScene.FloorY + 3);

		// Spawn player.
		ThisPlayer = new Player();
		add(ThisPlayer);
		
		// Add faders.
		_fadeOutFader.color = 0x000000;
		_fadeOutFader.scale = HXP.width * 2;
		_fadeOutFader.alpha = 0;
		addGraphic(_fadeOutFader, -5000);
		
		var flash:ScreenFlash = create(ScreenFlash);
		flash.Reset(0x000000, 1, 0.05);
		
		var title:Text = new Text("DDRKirby(ISQ) Presents", 250, 50);
		title.size = 16;
		title.originX = title.textWidth / 2;
		title.smooth = false;
		addGraphic(title);
		ShadowText.Create(title);
		
		Sound.Load("sfx/intro").play(Song.kMusicVolume);
	}
	
	
	override public function update() 
	{

		
		HandleBackdrops();
		
		super.update();
		
		_timer++;
		
		if (_timer > 180) {
			_fadeOutFader.alpha += 1.0 / kFadeDuration;
		}
		
		if (_fadeOutFader.alpha >= 1.0) {
			HXP.scene = new MenuScene();
		}
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
	
}
