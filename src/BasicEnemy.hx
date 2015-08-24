package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class BasicEnemy extends Enemy
{
	private var _spritemap:Spritemap = new Spritemap("img/basicenemy.png", 26, 26);
	private var _spritemapTop:Spritemap = new Spritemap("img/basicenemy.png", 26, 26);
	private var _spritemapBottom:Spritemap = new Spritemap("img/basicenemy.png", 26, 26);
	private var _topEntity:Entity;
	private var _bottomEntity:Entity;
	private var _spritemapTopF:Spritemap = new Spritemap("img/basicenemy.png", 26, 26);
	private var _spritemapBottomF:Spritemap = new Spritemap("img/basicenemy.png", 26, 26);

	public function new()
	{
		super(_spritemap);
		_spritemap.originX = _spritemap.width / 2;
		_spritemap.originY = _spritemap.height - 1;
		_spritemap.add("walk", [0, 1], 5);
		_spritemap.play("walk");
		_spritemapTop.originX = _spritemapTop.width / 2;
		_spritemapTop.originY = _spritemapTop.height - 1;
		_spritemapTop.add("walk", [2, 3], 5);
		_spritemapTop.play("walk");
		_spritemapBottom.originX = _spritemapBottom.width / 2;
		_spritemapBottom.originY = _spritemapBottom.height - 1;
		_spritemapBottom.add("walk", [2, 3], 5);
		_spritemapBottom.play("walk");
		_spritemapTopF.originX = _spritemapTop.width / 2;
		_spritemapTopF.originY = _spritemapTop.height - 1;
		_spritemapTopF.add("walk", [4, 5], 5);
		_spritemapTopF.play("walk");
		_spritemapBottomF.originX = _spritemapBottom.width / 2;
		_spritemapBottomF.originY = _spritemapBottom.height - 1;
		_spritemapBottomF.add("walk", [4, 5], 5);
		_spritemapBottomF.play("walk");
		layer = 10;
	}
	
	override public function Destroy():Void 
	{
		super.Destroy();
		
		MainScene.Instance.remove(_topEntity);
		MainScene.Instance.remove(_bottomEntity);
		
		for (i in 0...4) {
			MainScene.Instance.MainEmitter.emit(Left ? "1" : "1r", x, y);
		}
	}
	
	override public function Reset(beat:Float, left:Bool)
	{
		// TODO: Randomization, etc.
		
		super.Reset(beat, left);
		_spritemap.flipped = !left;
		_spritemap.updateBuffer();
		_topEntity = MainScene.Instance.addGraphic(_spritemapTop, layer, 0, 0);
		_bottomEntity = MainScene.Instance.addGraphic(_spritemapBottom, layer, 0, 0);
		_topEntity.addGraphic(_spritemapTopF);
		_bottomEntity.addGraphic(_spritemapBottomF);
	}
	
	override public function Hit():Void 
	{
		super.Hit();
		Sound.Load("sfx/munchnormal").play();
		
		Destroy();
		MainScene.Instance.Score++;
		MainScene.Instance.AddChain();
	}
	
	override public function update():Void 
	{
		super.update();
		
		Pulse(_spritemap);
		HandleGhosts(_spritemap, _spritemapTop, _spritemapBottom, _spritemapTopF, _spritemapBottomF);
	}
}
