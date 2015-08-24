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
	static inline var kChoiceStartY = 10;
	static inline var kChoiceSpacingY = 12;
	
	private var _description:Text;

	var _cursor:Image = new Image("img/cursor.png");

	var _faderIn:Image = new Image("img/white.png");
	var _fader:Image = new Image("img/white.png");
	static inline var kFadeoutDuration = 90;
	static inline var kFadeinDuration = 120;
	var _fadeTimer:Int = 0;
	
	var _playingMusic:Sfx;
	
	private var _musics:Array<Sfx> = [
	Sound.Load("sfx/intro"),
	Sound.Load("sfx/menu"),
	Sound.Load("sfx/level4"),
	Sound.Load("sfx/level5"),
	Sound.Load("sfx/level6"),
	Sound.Load("sfx/level7"),
	Sound.Load("sfx/level1"),
	Sound.Load("sfx/level9"),
	Sound.Load("sfx/level2"),
	Sound.Load("sfx/level3"),
	Sound.Load("sfx/level8"),
	Sound.Load("sfx/level10")
	];
	
	private var _descriptions:Array<String> = [
"Ms. Melody (Intro Sequence)\n" +
"Working time: 7 minutes\n\n" +
"I needed a little ditty for the opening cutscene, so I borrowed the melody from the title theme and added some arpeggios and blips underneath it.  In hindsight I would rather have not had the intro ditty match the very first part of the menu exactly, but I guess it still works out alright.",

"Sunny Day (Title Theme)\n" +
"Working time: 27 minutes\n\n" +
"Uncharacteristically, I didn't have that much trouble writing a happy and laidback menu theme -- it was a bit easier than I thought it might be.  I guess you could consider the opening riff here the main \"motif\" of Melody Muncher, but it only shows up here and in the intro, so it's not really as relevant in this soundtrack.",

"Let's Learn, Part 1 (Tutorial 1)\n" +
"Working time: 6 minutes\n\n" +
"A short and simple repeating song for the tutorial scene, so I came up with this 4-bar loop, using basic TR909 drums, then sprinkled on some chippy beeps for the enemy sounds.",

"Let's Learn, Part 2 (Tutorial 2)\n" +
"Working time: 4 minutes\n\n" +
"I had the idea here that I would just add on an element to the tutorial music each time I introduced a new element; eventually you'd have an entire song with chords and pads and all that!",

"Let's Learn, Part 3 (Tutorial 3)\n" +
"Working time: 3 minutes\n\n" +
"Now adding some driving motion using a 25% pulse wave bass...",

"Let's Learn, Part 4 (Tutorial 4)\n" +
"Working time: 2 minutes\n\n" +
"And now some more melodic material.  Huzzah!",

"Born to Be Free (Level 1)\n" +
"Working time: 1 hour 2 minutes\n\n" +
"The first song I wrote for the entire game.  It came out quite a lot more moody and intense than I would have imagined given the style of the game, but I have a tendency to write this kind of music, so I guess it can't really be helped.  The music for this game was much quicker to write than the Ripple Runner OST simply because inputting enemy charts into the game was much easier this time (Ripple Runner level programming was ridiculously hacky).  The experience I got from doing Ripple Runner and Rhythm Gunner also helped me out as I already knew how to use beeps, arps, and melodies to fit the rhythms of the game.",

"Solar Beam (Level 2)\n" +
"Working time: 52 minutes\n\n" +
"I wrote this song later on, after getting some feedback that the difficulty jump from level 1 to level 3 might be a bit too large for new players.  The goal was to write a faster song, so that you could get really comfortable with basic green enemies, before I strat introducing other concepts in Level 3 (which is slower).  The increased tempo apparently inspired me to make a super-driving song, that climaxes into a full-blown chorus, complete with sidechained pads and epic arp.  Well, sure!  I'll take that.  Trying to mix and balance the chorus was admittedly pretty difficult -- there's a lot of stuff going on -- but I did the best I could in a short timeframe.",

"Gonna Cut You Up (Level 3)\n" +
"Working time: 43 minutes\n\n" +
"The second song I wrote.  I tried to use a lot of eighth-note patterns to match up with the red enemies, which are introduced in this stage.  It's worth noting that having all of the rhythms fall on downbeats (at least, for Normal mode) affected my compositional process in an interesting way, as I was forced to shy away from using syncopations in my melodies when possible.",

"Standing Here Alone (Level 4)\n" +
"Working time: 48 minutes\n\n" +
"Trying to use echoey arpeggio patterns to highlight the teleporting of the blue enemies, which are introduced here.  The octave-arp synth that is used for the beginning and end here really harks back to Ripple Runner; I feel like I'm not the only one who will be making that association here.",

"Flower Fang (Level 5)\n" +
"Working time: 1 hour 7 minutes\n\n" +
"Somehow I ended up with this monster of a song, complete with massive sidechained bassline.  Again I almost feel like the music I ended up writing is a little TOO intense for the graphic style, but sometimes the music just kinda does what it wants!  I will say that this soundtrack in general flowed really smoothly and I had almost no problems with any of the writing.  I guess it probably shows in the sheer quantity of music that I was able to write (though to be fair, these songs are all on the short side).",

"Undying (Level 6)\n" +
"Working time: 51 minutes\n\n" +
"The last song that I'm writing for the 48-hour compo version of Melody Muncher.  I tried to strike a balance between making it a nice challenge vs. still making it accessible for people who are just coming from Level 5 (in other words, I didn't go all-out on the difficulty like I did with Ripple Runner Deluxe's final stage).  I upped the tempo and started things off with an awesome NES drumloop, sampled from virt/Jake Kaufman's Shovel Knight OST (go check it out if you haven't!).  I ended up with a spooky melody for the intro; everything else just fell into place from here, with the tritone chord progression and the big bassline.  I was also interested in using a drum solo for the enemy rhythms, so that made its way into this song as well.  Whelp, that's the last song (for now!)...hopefully you've enjoyed them!",
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
		
		_choices.push(new Text("Ms. Melody"));
		_choices.push(new Text("Sunny Day"));
		_choices.push(new Text("Let's Learn (Part 1)"));
		_choices.push(new Text("Let's Learn (Part 2)"));
		_choices.push(new Text("Let's Learn (Part 3)"));
		_choices.push(new Text("Let's Learn (Part 4)"));
		_choices.push(new Text("Born to be Free"));
		_choices.push(new Text("Solar Beam"));
		_choices.push(new Text("Gonna Cut You Up"));
		_choices.push(new Text("Standing Here Alone"));
		_choices.push(new Text("Flower Fang"));
		_choices.push(new Text("Undying"));
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
		_description.y = _choices[_choices.length - 1].y + 10;
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
