package
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.geom.Point;

	public class GlovesIntro
	{
		private var _gloves:Gloves;
		private var _startPoint:Point = new Point(93,142);
		private var _gamePoint:Point = new Point(122,98);
		
		public function GlovesIntro(gloves:Gloves)
		{
			_gloves = gloves;
			_gloves.x = _startPoint.x;
			_gloves.y = _startPoint.y;
			_gloves.x = _startPoint.x;
			_gloves.y = _startPoint.y;
		}
		
		public function playIntro():void
		{
			TweenNano.delayedCall(1, _gloves.punch, [ VGKeyboard.LEFT ]);
			TweenNano.delayedCall(1.2, _gloves.punch, [ VGKeyboard.LEFT ]);
			TweenNano.delayedCall(1.5, _gloves.punch, [ VGKeyboard.RIGHT ]);
			TweenNano.delayedCall(1.8, _gloves.punch, [ VGKeyboard.LEFT ]);
			TweenNano.delayedCall(2.2, _gloves.punch, [ VGKeyboard.UP ]);
			TweenNano.delayedCall(2.4, _gloves.toggleIdleMovement);
		}
		
		private function startGame():void
		{
			TweenNano.to(_gloves, 0.5, { ease:Sine.easeInOut, x:_gamePoint.x, y:_gamePoint.y });
		}
	}
}