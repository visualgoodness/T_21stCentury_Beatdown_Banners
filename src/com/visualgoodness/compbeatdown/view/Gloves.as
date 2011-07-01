package com.visualgoodness.compbeatdown.view
{
	import com.visualgoodness.compbeatdown.events.HitEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class Gloves extends Sprite
	{	
		public static const JAB_R:int 			= 0;
		public static const JAB_L:int 			= 1;
		public static const HOOK:int 			= 2;
		public static const LOW:int 			= 3;
		public static const CHEAP_SHOT:int 		= 4;
		
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
		private var _hittingGlove:Glove = new Glove();
		private var _nonHitGlove:Glove;
		private var _punchType:String;
		private var _alternate:Boolean = false;
		private var _doIdleMovement:Boolean = true;
		private var _currentPunchType:int;
		
		public function Gloves()
		{
			_gloveR = this["glove_R"] as Glove;
			_gloveL = this["glove_L"] as Glove;
			_gloveL.gloveFrame = 3;
			_gloves = [ _gloveL, _gloveR ];
			
			_gloveRStartX = _gloveR.x;
			_gloveLStartX = _gloveL.x;
			
			_gloveL.addEventListener(HitEvent.HIT_COMPLETE, hitComplete);
			_gloveR.addEventListener(HitEvent.HIT_COMPLETE, hitComplete);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function hitComplete(e:HitEvent):void
		{
			_hittingGlove.hitting = false;
		}
		
		public function toggleIdleMovement():void
		{
			_doIdleMovement = !_doIdleMovement;
		}
		
		public function punch(type:int):void
		{
			_currentPunchType = type;
			if (!_hittingGlove.hitting)
			{
				if (type == CHEAP_SHOT)
				{
					selectOtherGlove();
					_punchType = "cheapShot";
				}
				else if (type == JAB_L)
				{
					_hittingGlove = _gloveL;
					_nonHitGlove = _gloveR;
					_punchType = "jab";
				}
				else if (type == JAB_R) 
				{ 
					_hittingGlove = _gloveR;
					_nonHitGlove = _gloveL;
					_punchType = "jab";
				}
				else if (type == HOOK)
				{
					selectOtherGlove();
					_punchType = "hook";
				}
				else if (type == LOW) 
				{ 
					selectOtherGlove();
					_punchType = "low";
				}
				
				setChildIndex(_hittingGlove, 0);
				_hittingGlove.gotoAndPlay(_punchType);
				_hittingGlove.hitting = true;
			}
		}
		
		private function selectOtherGlove():void
		{
			_alternate = !_alternate;
			_hittingGlove = _alternate ? _gloveR : _gloveL;
			_nonHitGlove = _alternate ? _gloveL : _gloveR;
		}
		
		private function enterFrame(e:Event):void
		{
			_angle += _hoverSpeed;
			
			if (!_gloveR.hitting && _doIdleMovement)
			{
				_gloveR.targPos.y = -_hoverReachY/2 + Math.sin(_angle) * _hoverReachY;
				_gloveR.targPos.x = _gloveRStartX + -_hoverReachX/2 + Math.cos(_angle) * -_hoverReachX;
			}
			
			if (!_gloveL.hitting && _doIdleMovement)
			{
				_gloveL.targPos.y = -_hoverReachY/2 + Math.sin(_angle + Math.PI) * _hoverReachY;
				_gloveL.targPos.x = _gloveLStartX + -_hoverReachX/2 + Math.cos(_angle + Math.PI) * _hoverReachX;
			}
			
			_gloveR.update();
			_gloveL.update();
		}
	}
}