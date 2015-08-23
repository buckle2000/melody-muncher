package;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class MenuScene extends Scene
{
	public static var Difficulty:Int = 0;
	
	// TODO
	var _music:Sfx = Sound.Load("sfx/level1");
	static var _state:String = "main";
	static var _selectedChoice:Int = 0;

	var _mainChoices:Array<Text> = new Array<Text>();
	static inline var kMainChoiceStartX = 250-45;
	static inline var kMainChoiceStartY = 170;
	static inline var kMainChoiceSpacingY = 15;

	var _difficultyChoices:Array<Text> = new Array<Text>();
	static inline var kDifficultyChoiceStartX = 250-45;
	static inline var kDifficultyChoiceStartY = 170;
	static inline var kDifficultyChoiceSpacingY = 15;
	
	var _songsChoices:Array<Text> = new Array<Text>();
	static inline var kSongsChoiceStartX = 250-45;
	static inline var kSongsChoiceStartY = 170;
	static inline var kSongsChoiceSpacingY = 15;
	
	var _cursor:Image = new Image("img/cursor.png");

	var _fader:Image = new Image("img/white.png");
	static inline var kFadeoutDuration = 120;
	var _fadeTimer:Int = 0;
	
	override public function begin() 
	{
		super.begin();
		
		//addGraphic(new Image("img/menu.png"));
		
		var title:Text = new Text("Melody Muncher", 250, 100);
		title.size = 24;
		title.originX = title.textWidth / 2;
		title.smooth = false;
		addGraphic(title);
		var title2:Text = new Text("by DDRKirby(ISQ)", 250, 125);
		title2.size = 8;
		title2.originX = title2.textWidth / 2;
		title2.smooth = false;
		addGraphic(title2);
		var title3:Text = new Text("Created in 48 hrs for LD33 - " + Main.kVersion, 250, 280);
		title3.size = 8;
		title3.originX = title3.textWidth / 2;
		title3.smooth = false;
		addGraphic(title3);
		
		_music.loop(Song.kMusicVolume);
		
		_mainChoices.push(new Text("Start"));
		_mainChoices.push(new Text("Jukebox"));
		for (i in 0..._mainChoices.length) {
			_mainChoices[i].y = kMainChoiceStartY + kMainChoiceSpacingY * i;
			_mainChoices[i].x = kMainChoiceStartX;
			_mainChoices[i].size = 8;
			addGraphic(_mainChoices[i]);
			_mainChoices[i].smooth = false;
		}

		_difficultyChoices.push(new Text("Normal - For beginners"));
		_difficultyChoices.push(new Text("Hard - For rhythm gamers"));
		_difficultyChoices.push(new Text("Expert - For crazy people"));
		_difficultyChoices.push(new Text("Back to Main Menu"));
		for (i in 0..._difficultyChoices.length) {
			_difficultyChoices[i].y = kDifficultyChoiceStartY + kDifficultyChoiceSpacingY * i;
			_difficultyChoices[i].x = kDifficultyChoiceStartX;
			_difficultyChoices[i].size = 8;
			addGraphic(_difficultyChoices[i]);
			_difficultyChoices[i].smooth = false;
		}

		_songsChoices.push(new Text("Tutorial 1 - Welcome to Melody Muncher"));
		_songsChoices.push(new Text("Level 1 - arst"));
		_songsChoices.push(new Text("Tutorial 2 - Armored Enemies"));
		_songsChoices.push(new Text("Level 2 - arst"));
		_songsChoices.push(new Text("Tutorial 3 - Split Munch"));
		_songsChoices.push(new Text("Level 3 - arst"));
		_songsChoices.push(new Text("Back"));
		for (i in 0..._songsChoices.length) {
			_songsChoices[i].y = kSongsChoiceStartY + kSongsChoiceSpacingY * i;
			_songsChoices[i].x = kSongsChoiceStartX;
			_songsChoices[i].size = 8;
			addGraphic(_songsChoices[i]);
			_songsChoices[i].smooth = false;
		}
		
		_cursor.x = kMainChoiceStartX;
		_cursor.originY = 4;
		_cursor.originX = 16;
		addGraphic(_cursor);
		
		_fader.scale = 1100;
		_fader.color = 0x000000;
		_fader.alpha = 0;
		addGraphic(_fader);
		
		var flash:ScreenFlash = create(ScreenFlash);
		flash.Reset(0x000000, 1, 0.05);
	}

	private function MainUpdate()
	{
		for (choice in _mainChoices) {
			choice.visible = true;
		}
		_cursor.x = kMainChoiceStartX;
		_cursor.y = kMainChoiceStartY + _selectedChoice * kMainChoiceSpacingY;

		if (_fadeTimer > 0) {
			// we are fading, just do the fade and nothing else.
			_music.volume -= Song.kMusicVolume / kFadeoutDuration;
			_fader.alpha += 1 / kFadeoutDuration;
			
			if (_fadeTimer > kFadeoutDuration) {
				switch(_selectedChoice) {
					case 1:
						// jukebox
						_music.stop();
						
						// TODO
						HXP.scene = new MenuScene();
				}
				return;
			}
			
			_fadeTimer++;
			return;
		}
		
		if (Input.pressed(Key.DOWN)) {
			_selectedChoice++;
			_selectedChoice = (_selectedChoice + _mainChoices.length) % _mainChoices.length;
			Sound.Load("sfx/cursor").play();
		}
		if (Input.pressed(Key.UP)) {
			_selectedChoice--;
			_selectedChoice = (_selectedChoice + _mainChoices.length) % _mainChoices.length;
			Sound.Load("sfx/cursor").play();
		}
		
		if (Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE)) {
			switch(_selectedChoice) {
				case 0:
					// start
					Sound.Load("sfx/cursor").play();
					_state = "difficulty";
					_selectedChoice = 0;
				case 1:
					// jukebox
					_fadeTimer++;
					Sound.Load("sfx/cursor").play();
			}
		}
	}
	
	private function DifficultyUpdate()
	{
		for (choice in _difficultyChoices) {
			choice.visible = true;
		}
		_cursor.x = kDifficultyChoiceStartX;
		_cursor.y = kDifficultyChoiceStartY + _selectedChoice * kDifficultyChoiceSpacingY;

		if (Input.pressed(Key.DOWN)) {
			_selectedChoice++;
			_selectedChoice = (_selectedChoice + _difficultyChoices.length) % _difficultyChoices.length;
			Sound.Load("sfx/cursor").play();
		}
		if (Input.pressed(Key.UP)) {
			_selectedChoice--;
			_selectedChoice = (_selectedChoice + _difficultyChoices.length) % _difficultyChoices.length;
			Sound.Load("sfx/cursor").play();
		}
		
		if (Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE)) {
			switch(_selectedChoice) {
				case 0:
					// normal
					Sound.Load("sfx/cursor").play();
					_state = "songs";
					Difficulty = _selectedChoice;
				case 1:
					// hard
					Sound.Load("sfx/cursor").play();
					_state = "songs";
					Difficulty = _selectedChoice;
				case 2:
					// expert
					Sound.Load("sfx/cursor").play();
					_state = "songs";
					Difficulty = _selectedChoice;
				case 3:
					// back
					Sound.Load("sfx/cursor").play();
					_state = "main";
			}
			_selectedChoice = 0;
		}
	}
	
	private function SongsUpdate()
	{
		for (choice in _songsChoices) {
			choice.visible = true;
		}
		_cursor.x = kSongsChoiceStartX;
		_cursor.y = kSongsChoiceStartY + _selectedChoice * kSongsChoiceSpacingY;

		if (_fadeTimer > 0) {
			// we are fading, just do the fade and nothing else.
			_music.volume -= Song.kMusicVolume / kFadeoutDuration;
			_fader.alpha += 1 / kFadeoutDuration;
			
			if (_fadeTimer > kFadeoutDuration) {
				switch(_selectedChoice) {
					case 1:
						// Tutorial 1
						HXP.scene = new MainScene(1);
					case 2:
						// level 1
						HXP.scene = new MainScene(1);
					case 3:
						// Tutorial 2
						HXP.scene = new MainScene(2);
					case 4:
						// level 2
						HXP.scene = new MainScene(2);
					case 5:
						// Tutorial 3
						HXP.scene = new MainScene(3);
					case 6:
						// level 3
						HXP.scene = new MainScene(3);
				}
				return;
			}
			
			_fadeTimer++;
			return;
		}
		
		if (Input.pressed(Key.DOWN)) {
			_selectedChoice++;
			_selectedChoice = (_selectedChoice + _songsChoices.length) % _songsChoices.length;
			Sound.Load("sfx/cursor").play();
		}
		if (Input.pressed(Key.UP)) {
			_selectedChoice--;
			_selectedChoice = (_selectedChoice + _songsChoices.length) % _songsChoices.length;
			Sound.Load("sfx/cursor").play();
		}
		
		if (Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE)) {
			if (_selectedChoice == _songsChoices.length - 1) {
				_state = "difficulty";
				_selectedChoice = Difficulty;
				Sound.Load("sfx/cursor").play();
			} else {
				_fadeTimer++;
				Sound.Load("sfx/cursor").play();
			}
		}
	}
	
	override public function update() 
	{
		super.update();
		
		for (choice in _mainChoices) {
			choice.visible = false;
		}
		for (choice in _difficultyChoices) {
			choice.visible = false;
		}
		for (choice in _songsChoices) {
			choice.visible = false;
		}
		
		if (_state == "main") {
			MainUpdate();
		} else if (_state == "difficulty") {
			DifficultyUpdate();
		} else if (_state == "songs") {
			SongsUpdate();
		}
	}
}
