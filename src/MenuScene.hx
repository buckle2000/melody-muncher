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
class MenuScene extends Scene
{
	public static var Difficulty:Int = 0;

	public static var Scores1:Array<Int> = new Array<Int>();
	public static var Scores2:Array<Int> = new Array<Int>();
	public static var Scores3:Array<Int> = new Array<Int>();
	public static var MaxScores1:Array<Int> = null;
	public static var MaxScores2:Array<Int> = null;
	public static var MaxScores3:Array<Int> = null;
	
	private var _scrollBackground1:Backdrop;
	private var _scrollBackground2:Backdrop;
	
	private static var _scrollRate1:Float = 0.2;
	private static var _scrollRate2:Float = 0.1;
	
	// TODO
	var _music:Sfx = Sound.Load("sfx/menu");
	static var _state:String = "main";
	static var _selectedChoice:Int = 0;

	var _mainChoices:Array<Text> = new Array<Text>();
	static inline var kMainChoiceStartX = 250;
	static inline var kMainChoiceStartY = 120;
	static inline var kMainChoiceSpacingY = 15;

	var _difficultyChoices:Array<Text> = new Array<Text>();
	static inline var kDifficultyChoiceStartX = 250;
	static inline var kDifficultyChoiceStartY = 120;
	static inline var kDifficultyChoiceSpacingY = 15;
	
	var _songsChoices:Array<Text> = new Array<Text>();
	static inline var kSongsChoiceStartX = 250;
	static inline var kSongsChoiceStartY = 100;
	static inline var kSongsChoiceSpacingY = 15;
	
	var _cursor:Image = new Image("img/cursor.png");

	var _faderIn:Image = new Image("img/white.png");
	var _fader:Image = new Image("img/white.png");
	static inline var kFadeoutDuration = 90;
	static inline var kFadeinDuration = 120;
	var _fadeTimer:Int = 0;
	
	override public function begin() 
	{
		if (MaxScores1 == null) {
			MaxScores1 = new Array<Int>();
			MaxScores2 = new Array<Int>();
			MaxScores3 = new Array<Int>();
			for (i in 1...Song.NumSongs+1) {
				MaxScores1.push(Song.MaxScoreForLevel(i));
				MaxScores2.push(Song.MaxScoreForLevel(i));
				MaxScores3.push(Song.MaxScoreForLevel(i));
				Scores1.push(0);
				Scores2.push(0);
				Scores3.push(0);
			}
		}
		
		super.begin();
		

		addGraphic(new Image("img/level1_fore.png"), 100);
		addGraphic(new Image("img/level1_back.png"), 1000);
		_scrollBackground1 = new Backdrop("img/level1_scroll1.png");
		addGraphic(_scrollBackground1, 500);
		_scrollBackground2 = new Backdrop("img/level1_scroll2.png");
		addGraphic(_scrollBackground2, 600);
		
		//addGraphic(new Image("img/menu.png"));
		
		var title:Text = new Text("Melody Muncher", 250, 50);
		title.size = 24;
		title.originX = title.textWidth / 2;
		title.smooth = false;
		addGraphic(title);
		var title2:Text = new Text("by DDRKirby(ISQ)", 250, 80);
		title2.size = 8;
		title2.originX = title2.textWidth / 2;
		title2.smooth = false;
		addGraphic(title2);
		var title3:Text = new Text("Created in 48 hrs for LD33 - " + Main.kVersion, 250, 280);
		title3.size = 8;
		title3.originX = title3.textWidth / 2;
		title3.smooth = false;
		addGraphic(title3);
		ShadowText.Create(title);
		ShadowText.Create(title2);
		ShadowText.Create(title3);
		
		_music.loop(Song.kMusicVolume);
		
		_mainChoices.push(new Text("Start"));
		_mainChoices.push(new Text("Jukebox"));
		for (i in 0..._mainChoices.length) {
			_mainChoices[i].y = kMainChoiceStartY + kMainChoiceSpacingY * i;
			_mainChoices[i].x = kMainChoiceStartX;
			_mainChoices[i].size = 8;
			addGraphic(_mainChoices[i]);
			_mainChoices[i].originX = _mainChoices[i].textWidth / 2;
			ShadowText.Create(_mainChoices[i]);
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
			ShadowText.Create(_difficultyChoices[i]);
			_difficultyChoices[i].smooth = false;
			_difficultyChoices[i].originX = _difficultyChoices[i].textWidth / 2;
		}

		_songsChoices.push(new Text("Tutorial 1 - Welcome to Melody Muncher"));
		_songsChoices.push(new Text("Level 1 - arst: " + Scores1[0] + "/" + MaxScores1[0]));
		_songsChoices.push(new Text("Level 1.5 - arst: " + Scores1[1] + "/" + MaxScores1[1]));
		_songsChoices.push(new Text("Tutorial 2 - Armored Enemies"));
		_songsChoices.push(new Text("Level 2 - arst: " + Scores1[1] + "/" + MaxScores1[1]));
		_songsChoices.push(new Text("Tutorial 3 - Split Munch"));
		_songsChoices.push(new Text("Level 3 - arst: " + Scores1[2] + "/" + MaxScores1[2]));
		_songsChoices.push(new Text("Tutorail 4"));
		_songsChoices.push(new Text("level 4"));
		_songsChoices.push(new Text("Back"));
		for (i in 0..._songsChoices.length) {
			_songsChoices[i].y = kSongsChoiceStartY + kSongsChoiceSpacingY * i;
			_songsChoices[i].x = kSongsChoiceStartX;
			_songsChoices[i].size = 8;
			addGraphic(_songsChoices[i]);
			ShadowText.Create(_songsChoices[i]);
			_songsChoices[i].smooth = false;
		}
		
		_cursor.x = kMainChoiceStartX;
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
	
	private function MainUpdate()
	{
		for (choice in _mainChoices) {
			choice.visible = true;
		}
		_cursor.x = - _mainChoices[_selectedChoice].textWidth / 2 + _mainChoices[_selectedChoice].x;
		_cursor.y = kMainChoiceStartY + _selectedChoice * kMainChoiceSpacingY;

		for (i in 0..._mainChoices.length) {
			if (i == _selectedChoice) {
				_mainChoices[i].color = 0xFFFF00;
			} else {
				_mainChoices[i].color = 0xFFFFFF;
			}
		}

		if (_fadeTimer > 0) {
			// we are fading, just do the fade and nothing else.
			_music.volume -= Song.kMusicVolume / kFadeoutDuration;
			_fader.alpha += 1 / kFadeoutDuration;
			
			if (_fadeTimer > kFadeoutDuration) {
				switch(_selectedChoice) {
					case 1:
						// jukebox
						_music.stop();
						
						HXP.scene = new JukeboxScene();
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
					Sound.Load("sfx/startgame").play();
			}
		}
	}
	
	private function DifficultyUpdate()
	{
		for (choice in _difficultyChoices) {
			choice.visible = true;
		}
		_cursor.x = - _difficultyChoices[_selectedChoice].textWidth / 2 + _difficultyChoices[_selectedChoice].x;
		_cursor.y = kDifficultyChoiceStartY + _selectedChoice * kDifficultyChoiceSpacingY;

		for (i in 0..._difficultyChoices.length) {
			if (i == _selectedChoice) {
				_difficultyChoices[i].color = 0xFFFF00;
			} else {
				_difficultyChoices[i].color = 0xFFFFFF;
			}
		}

		
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
		if (Input.pressed(Key.ESCAPE)) {
			_state = "main";
			_selectedChoice = 0;
			Sound.Load("sfx/cursor").play();
		}
	}
	
	private function SongsUpdate()
	{
		var scoreArray = null;
		var maxScoreArray = null;
		if (Difficulty == 0) {
			scoreArray = Scores1;
			maxScoreArray = MaxScores1;
		} else if (Difficulty == 1) {
			scoreArray = Scores2;
			maxScoreArray = MaxScores2;
		} else if (Difficulty == 2) {
			scoreArray = Scores3;
			maxScoreArray = MaxScores3;
		} else {
			trace("awftnuyawfotn");
		}
		_songsChoices[0].text = "Tutorial 1 - Welcome to Melody Muncher";
		_songsChoices[1].text = "Level 1 - arst (Score: " + scoreArray[0] + "/" + maxScoreArray[0] + ")";
		_songsChoices[2].text = "Level 2 - arst (Score: " + scoreArray[8] + "/" + maxScoreArray[8] + ")";
		_songsChoices[3].text = "Tutorial 2 - Armored Enemies";
		_songsChoices[4].text = "Level 3 - arst (Score: " + scoreArray[1] + "/" + maxScoreArray[1] + ")";
		_songsChoices[5].text = "Tutorial 3 - Split Munch";
		_songsChoices[6].text = "Level 4 - arst (Score: " + scoreArray[2] + "/" + maxScoreArray[2] + ")";
		_songsChoices[7].text = "Tutorial 4 - Teleporters";
		_songsChoices[8].text = "Level 5 - arst (Score: " + scoreArray[7] + "/" + maxScoreArray[7] + ")";

		for (i in 0..._songsChoices.length) {
			if (i == _selectedChoice) {
				_songsChoices[i].color = 0xFFFF00;
			} else {
				_songsChoices[i].color = 0xFFFFFF;
			}
		}
		
		for (choice in _songsChoices) {
			choice.visible = true;
			choice.originX = choice.textWidth / 2;
		}
		_cursor.x = - _songsChoices[_selectedChoice].textWidth / 2 + _songsChoices[_selectedChoice].x;
		_cursor.y = kSongsChoiceStartY + _selectedChoice * kSongsChoiceSpacingY;

		if (_fadeTimer > 0) {
			// we are fading, just do the fade and nothing else.
			_music.volume -= Song.kMusicVolume / kFadeoutDuration;
			_fader.alpha += 1 / kFadeoutDuration;
			
			if (_fadeTimer > kFadeoutDuration) {
				switch(_selectedChoice) {
					case 0:
						// Tutorial 1
						HXP.scene = new MainScene(4);
					case 1:
						// level 1
						HXP.scene = new MainScene(1);
					case 2:
						// level 2
						HXP.scene = new MainScene(9);
					case 3:
						// Tutorial 2
						HXP.scene = new MainScene(5);
					case 4:
						// level 2
						HXP.scene = new MainScene(2);
					case 5:
						// Tutorial 3
						HXP.scene = new MainScene(6);
					case 6:
						// level 3
						HXP.scene = new MainScene(3);
					case 7:
						// tutorial 4
						HXP.scene = new MainScene(7);
					case 8:
						// level 4
						HXP.scene = new MainScene(8);
					default:
						trace("reawftnuynoaw");
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
				// start game
				_fadeTimer++;
				Sound.Load("sfx/startgame").play();
			}
		}
		if (Input.pressed(Key.ESCAPE)) {
			_state = "difficulty";
			_selectedChoice = Difficulty;
			Sound.Load("sfx/cursor").play();
		}
	}
	
	override public function update() 
	{
		super.update();
		
		HandleBackdrops();
		
		_faderIn.alpha -= 1.0 / kFadeinDuration;
		
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
