package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import openfl.display.Sprite;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class Enemy extends Entity
{
	// When to actually hit the player.
	private static inline var kAttackBeat:Float = -0.5;
	
	public var Beat:Float;
	public var Left:Bool;
	
	public function new(graphic:Graphic)
	{
		super(0, 0, graphic);
	}
	
	public function Reset(beat:Float, left:Bool)
	{
		Beat = beat;
		Left = left;
		y = MainScene.FloorY;
	}
	
	override public function update():Void 
	{
		x = Song.CurrentSong.BeatToPosition(Beat, Left);
		
		if (BeatsLeft() <= kAttackBeat) {
			Attack();
		}
		
		super.update();
	}
	
	public function BeatsLeft():Float
	{
		return Beat - Song.CurrentSong.CurrentBeat();
	}
	
	public function Hit():Void
	{
		// Camera shake.
		MainScene.Shake(1, 3);
		
		// Particles.
		for (i in 0...30) {
			MainScene.Instance.MainEmitter.emit("tiny", x, y);
		}
		
		// Overridden in base classes.
	}
	
	public function Attack():Void
	{
		MainScene.Instance.ThisPlayer.Flash(10);
		Sound.Load("sfx/hit").play();
		Destroy();
		MainScene.Instance.ResetChain();
	}
	
	public function Destroy():Void
	{
		MainScene.Instance.recycle(this);
		Song.CurrentSong.EnemyList(Left).remove(this);
	}
	
	private function Pulse(spritemap:Spritemap)
	{
		if (Song.CurrentSong.CurrentBeat() % 1.0 < 0.05 || Song.CurrentSong.CurrentBeat() % 1.0 > 1.0 - 0.05) {
			spritemap.color = 0xAAAAAA;
		} else if (Song.CurrentSong.CurrentBeat() % 1.0 < 0.1 || Song.CurrentSong.CurrentBeat() % 1.0 > 1.0 - 0.1) {
			spritemap.color = 0xCCCCCC;
		} else {
			spritemap.color = 0xFFFFFF;
		}
	}
	
	private function HandleGhosts(spritemap:Spritemap, spritemapTop:Spritemap, spritemapBottom:Spritemap,
								  spritemapTopF:Spritemap, spritemapBottomF:Spritemap)
	{
		var ghostBeats:Float = 0.4;
		var distance:Float = 40.0;
		
		var beatsLeft:Float = BeatsLeft();
		
		spritemapBottom.scale = 1;
		spritemapTop.scale = 1;
		spritemapBottom.x = Left ? MainScene.LeftPosition : MainScene.RightPosition;
		spritemapTop.x = Left ? MainScene.LeftPosition : MainScene.RightPosition;
		if (beatsLeft < 0.0) {
			spritemapTop.alpha -= 0.1;
			spritemapBottom.alpha -= 0.1;
		} else {
			spritemapTop.alpha = (1.0 - beatsLeft) * 0.8;
			spritemapBottom.alpha = (1.0 - beatsLeft) * 0.8;
		}
		spritemapTop.y = beatsLeft * distance;
		if (spritemapTop.y < 0) {
			spritemapTop.y = 0;
		}
		spritemapBottom.y = -spritemapTop.y;
		
		spritemapTop.y += MainScene.FloorY;
		spritemapBottom.y += MainScene.FloorY;
		spritemapTop.flipped = spritemap.flipped;
		spritemapBottom.flipped = spritemap.flipped;

		
		if (beatsLeft < 0.1 && beatsLeft > -0.1) {
			spritemapBottomF.visible = true;
			spritemapTopF.visible = true;
			spritemapBottomF.x = spritemapBottom.x;
			spritemapBottomF.y = spritemapBottom.y;
			spritemapTopF.x = spritemapTop.x;
			spritemapTopF.y = spritemapTop.y;
			spritemapBottomF.flipped = spritemapBottom.flipped;
			spritemapTopF.flipped = spritemapTop.flipped;
		} else {
			spritemapBottomF.visible = false;
			spritemapTopF.visible = false;
		}
	}
}
