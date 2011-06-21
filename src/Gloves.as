package
{
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class Gloves extends Sprite
	{
		public static const R_HIT:String = "gloveRHit";
		public static const L_HIT:String = "gloveLHit";		
		
		private var _gloves:Array = [];
		private var _gloveR:Glove;
		private var _gloveL:Glove;
		private var _angle:Number = 0;
		private var _hoverSpeed:Number = 0.13;
		private var _hoverReachY:Number = 10;
		private var _hoverReachX:Number = 12;
		private var _gloveRStartX:Number;
		private var _endFrameOffset:int = 5;
		private var _gloveLStartX:Number;
		
		public function Gloves()
		{
			_gloveR = this["glove_R"] as Glove;
			_gloveL = this["glove_L"] as Glove;
			_gloves = [ _gloveL, _gloveR ];
			
			_gloveRStartX = _gloveR.x;
			_gloveLStartX = _gloveL.x;
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function punch(key:int):void
		{
			if (key == VGKeyboard.LEFT)
			{
				setChildIndex(_gloveR, numChildren-1);
				_gloveL.hitting = true;
			}
			else if (key == VGKeyboard.RIGHT)
			{
				setChildIndex(_gloveL, numChildren-1);
				_gloveR.hitting = true;
			}
		}
		
		private function enterFrame(e:Event):void
		{
			_angle += _hoverSpeed;
			
			if (_gloveR.hitting)
			{
				if (_gloveR.currentFrame == 1) _gloveR.play();
				else if (_gloveR.currentFrame >= _gloveR.totalFrames-_endFrameOffset) _gloveR.hitting = false;
			}
			else
			{
				_gloveR.targPos.y = -_hoverReachY/2 + Math.sin(_angle) * _hoverReachY;
				_gloveR.targPos.x = _gloveRStartX + -_hoverReachX/2 + Math.cos(_angle) * -_hoverReachX;
			}
			
			if (_gloveL.hitting)
			{
				if (_gloveL.currentFrame == 1) _gloveL.play();
				else if (_gloveL.currentFrame >= _gloveL.totalFrames-_endFrameOffset) _gloveL.hitting = false;
			}
			else
			{	
				_gloveL.targPos.y = -_hoverReachY/2 + Math.sin(_angle + Math.PI) * _hoverReachY;
				_gloveL.targPos.x = _gloveLStartX + -_hoverReachX/2 + Math.cos(_angle + Math.PI) * _hoverReachX;
			}
			
			_gloveR.update();
			_gloveL.update();
		}
	}
}