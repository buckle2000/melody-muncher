package;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Mask;

/**
 * ...
 * @author DDRKirby(ISQ)
 */
class ShadowText extends Entity
{
	private var _orig:Text;
	private var _offsetX:Int;
	private var _offsetY:Int;
	private var _text:Text;

	public static function Create(text:Text, layer:Int = 0)
	{
		var text1:ShadowText = HXP.scene.create(ShadowText);
		text1.Reset(text, -1, 0);
		var text2:ShadowText = HXP.scene.create(ShadowText);
		text2.Reset(text, 1, 0);
		var text3:ShadowText = HXP.scene.create(ShadowText);
		text3.Reset(text, 0, -1);
		var text4:ShadowText = HXP.scene.create(ShadowText);
		text4.Reset(text, 0, 1);
		text1.layer = layer + 1;
		text2.layer = layer + 1;
		text3.layer = layer + 1;
		text4.layer = layer + 1;
	}

	public function Reset(text:Text, offsetX:Int, offsetY:Int)
	{
		_text = new Text("", 0, 0, text.width, text.height);
		_graphic = _text;
		_offsetX = offsetX;
		_offsetY = offsetY;
		_orig = text;
	}
	
	override public function update():Void 
	{
		super.update();
		_text.text = _orig.text;
		_text.size = _orig.size;
		_text.x = _orig.x + _offsetX;
		_text.y = _orig.y + _offsetY;
		_text.color = 0x000000;
		_text.alpha = _orig.alpha;
		_text.scale = _orig.scale;
		_text.originX = _orig.originX;
		_text.originY = _orig.originY;
		_text.visible = _orig.visible;
		_text.wordWrap = _orig.wordWrap;
	}
	
}