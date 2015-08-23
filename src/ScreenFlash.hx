import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Mask;

class ScreenFlash extends Entity
{
	private var _image:Image = new Image("img/white.png");
	private var _fadeRate:Float;
	
	public function Reset(color:Int, alpha:Float, fadeRate:Float = 0.05)
	{
		_image.scaleX = HXP.width * 2;
		_image.scaleY = HXP.height * 2;
		_image.color = color;
		_image.scrollX = 0;
		_image.scrollY = 0;
		_image.alpha = alpha;
		graphic = _image;
		x = 0;
		y = 0;
		_fadeRate = fadeRate;
		
		layer = -2000;
	}
	
	override public function update()
	{
		_image.alpha -= _fadeRate;
		if (_image.alpha <= 0) {
			HXP.scene.recycle(this);
		}
	}
}
