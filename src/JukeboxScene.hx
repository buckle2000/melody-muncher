package;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Backdrop;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class JukeboxScene extends Scene
{
	private var _scrollBackground1:Backdrop;
	private var _scrollBackground2:Backdrop;
	
	private static var _scrollRate1:Float = 0.2;
	private static var _scrollRate2:Float = 0.1;
	
	static var _selectedChoice:Int = 0;

	var _choices:Array<Text> = new Array<Text>();
	static inline var kChoiceStartX = 250;
	static inline var kChoiceStartY = 50;
	static inline var kChoiceSpacingY = 15;
	
	private var _description:Text;

	var _cursor:Image = new Image("img/cursor.png");

	var _faderIn:Image = new Image("img/white.png");
	var _fader:Image = new Image("img/white.png");
	static inline var kFadeoutDuration = 90;
	static inline var kFadeinDuration = 120;
	var _fadeTimer:Int = 0;
	
	var _playingMusic:Sfx;
	
	private var _musics:Array<Sfx> = [
	Sound.Load("sfx/level1"),
	Sound.Load("sfx/level2"),
	Sound.Load("sfx/level3"),
	Sound.Load("sfx/level4"),
	Sound.Load("sfx/level5"),
	Sound.Load("sfx/level6"),
	Sound.Load("sfx/level7"),
	Sound.Load("sfx/level8")];
	
	private var _descriptions:Array<String> = [
	"arst1",
	"arst2",
	"arst3",
	"arst4",
	"arst5",
	"arst6",
	"arst7",
	"arst8"
	];
	
	override public function begin() 
	{
		super.begin();
		

		addGraphic(new Image("img/level1_fore.png"), 100);
		addGraphic(new Image("img/level1_back.png"), 1000);
		_scrollBackground1 = new Backdrop("img/level1_scroll1.png");
		addGraphic(_scrollBackground1, 500);
		_scrollBackground2 = new Backdrop("img/level1_scroll2.png");
		addGraphic(_scrollBackground2, 600);
		
		var tinter:Image = new Image("img/white.png");
		tinter.scale = 1100;
		tinter.color = 0x000000;
		tinter.alpha = 0.5;
		addGraphic(tinter, 10);
		
		_choices.push(new Text("Song 1"));
		_choices.push(new Text("Song 2"));
		_choices.push(new Text("Song 3"));
		_choices.push(new Text("Song 4"));
		_choices.push(new Text("Song 5"));
		_choices.push(new Text("Song 6"));
		_choices.push(new Text("Song 7"));
		_choices.push(new Text("Song 8"));
		_choices.push(new Text("Back"));
		for (i in 0..._choices.length) {
			_choices[i].y = kChoiceStartY + kChoiceSpacingY * i;
			_choices[i].x = kChoiceStartX;
			_choices[i].size = 8;
			addGraphic(_choices[i]);
			_choices[i].originX = _choices[i].textWidth / 2;
			ShadowText.Create(_choices[i]);
			_choices[i].smooth = false;
		}
		
		_description = new Text("", 0, 0, HXP.width - 40, 1000);
		_description.y = _choices[_choices.length - 1].y + 20;
		_description.x = 20;
		_description.wordWrap = true;
		_description.resizable = false;
		_description.size = 8;
		addGraphic(_description);
		ShadowText.Create(_description);

		_cursor.x = kChoiceStartX;
		_cursor.originY = 4;
		_cursor.originX = 16;
		addGraphic(_cursor);
		
		_fader.scale = 1100;
		_fader.color = 0x000000;
		_fader.alpha = 0;
		addGraphic(_fader, -1000);
		_faderIn.scale = 1100;
		_faderIn.color = 0x000000;
		_faderIn.alpha = 1;
		
		var flash:ScreenFlash = create(ScreenFlash);
		flash.Reset(0x000000, 1, 0.05);
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
	
	override public function update() 
	{
		super.update();
		
		HandleBackdrops();
		
		_faderIn.alpha -= 1.0 / kFadeinDuration;

		if (_selectedChoice < _descriptions.length) {
			_description.text = _descriptions[_selectedChoice];
		} else {
			_description.text = "";
		}
		
		for (i in 0..._musics.length) {
			if (_musics[i].playing) {
				_choices[i].color = 0xFFFF00;
			} else {
				_choices[i].color = 0xFFFFFF;
			}
		}
		
		_cursor.x = - _choices[_selectedChoice].textWidth / 2 + _choices[_selectedChoice].x;
		_cursor.y = _choices[_selectedChoice].y;

		if (_fadeTimer > 0) {
			// we are fading, just do the fade and nothing else.
			_fader.alpha += 1 / kFadeoutDuration;

			// fade music.
			for (i in 0..._musics.length) {
				_musics[i].volume = 1.0 - _fader.alpha;
			}
			
			if (_fadeTimer > kFadeoutDuration) {
				HXP.scene = new MenuScene();
				for (i in 0..._musics.length) {
					_musics[i].stop();
				}
				return;
			}
			
			_fadeTimer++;
			return;
		}
		
		if (Input.pressed(Key.DOWN)) {
			_selectedChoice++;
			_selectedChoice = (_selectedChoice + _choices.length) % _choices.length;
			Sound.Load("sfx/cursor").play();
		}
		if (Input.pressed(Key.UP)) {
			_selectedChoice--;
			_selectedChoice = (_selectedChoice + _choices.length) % _choices.length;
			Sound.Load("sfx/cursor").play();
		}
		
		if (Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE)) {
			if (_selectedChoice == _choices.length - 1) {
				// back.
				_fadeTimer++;
				Sound.Load("sfx/startgame").play();
			} else {
				// Look for a playing song, if there is one, stop it.
				Sound.Load("sfx/cursor").play();
				var playing:Bool = false;
				for (i in 0..._musics.length) {
					if (_musics[i].playing) {
						_musics[i].stop();
						if (i == _selectedChoice) {
							playing = true;
						}
					}
				}
				if (!playing) {
					// Start music.
					_musics[_selectedChoice].play();
				}
			}
		}
	}
}
