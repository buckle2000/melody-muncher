package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Entity;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class TeleportEnemy extends Enemy
{
	private var _spritemap:Spritemap = new Spritemap("img/teleportenemy.png", 26, 26);
	private var _spritemapTop:Spritemap = new Spritemap("img/teleportenemy.png", 26, 26);
	private var _spritemapBottom:Spritemap = new Spritemap("img/teleportenemy.png", 26, 26);
	private var _firstHit:Bool = false;
	private var _topEntity:Entity;
	private var _bottomEntity:Entity;

	public function new()
	{
		super(_spritemap);
		_spritemap.originX = _spritemap.width / 2;
		_spritemap.originY = _spritemap.height - 1;
		_spritemap.add("walk", [0], 5);
		_spritemap.add("walk2", [0], 5);
		_spritemap.play("walk");
		_spritemapTop.originX = _spritemapTop.width / 2;
		_spritemapTop.originY = _spritemapTop.height - 1;
		_spritemapTop.add("walk", [1], 5);
		_spritemapTop.add("walk2", [1], 5);
		_spritemapTop.play("walk");
		_spritemapBottom.originX = _spritemapBottom.width / 2;
		_spritemapBottom.originY = _spritemapBottom.height - 1;
		_spritemapBottom.add("walk", [1], 5);
		_spritemapBottom.add("walk2", [1], 5);
		_spritemapBottom.play("walk");
		
				layer = 10;

	}
	
	override public function Destroy():Void 
	{
		super.Destroy();
		
		MainScene.Instance.remove(_topEntity);
		MainScene.Instance.remove(_bottomEntity);
		
		for (i in 0...4) {
			MainScene.Instance.MainEmitter.emit(Left ? "3" : "3r", x, y);
		}
	}
	override public function Reset(beat:Float, left:Bool)
	{
		// TODO: Randomization, etc.
		
		_topEntity = MainScene.Instance.addGraphic(_spritemapTop, layer, 0, 0);
		_bottomEntity = MainScene.Instance.addGraphic(_spritemapBottom, layer, 0, 0);
		super.Reset(beat, left);
		_spritemap.play("walk");
		_firstHit = false;
		_spritemap.flipped = !left;
		_spritemap.updateBuffer();
	}
	
	override public function Hit():Void 
	{
		super.Hit();
		
		if (_firstHit) {
			Destroy();
			Sound.Load("sfx/munchstrong2").play();
			MainScene.Instance.Score++;
			MainScene.Instance.AddChain();
		} else {
			MainScene.Instance.Score++;
			MainScene.Instance.AddChain();
			Sound.Load("sfx/teleporthit1").play();
			_firstHit = true;
			_spritemap.play("walk2");
			// Move back.
			Beat = Beat + 0.5;
			
			// Insert in other list and flip.
			_spritemap.flipped = !_spritemap.flipped;
			Song.CurrentSong.EnemyList(Left).remove(this);
			Left = !Left;
			Song.CurrentSong.EnemyList(Left).insert(0, this);
		}
	}
	
	override public function update():Void 
	{
		super.update();
		
		Pulse(_spritemap);
		HandleGhosts(_spritemap, _spritemapTop, _spritemapBottom);
	}
}
