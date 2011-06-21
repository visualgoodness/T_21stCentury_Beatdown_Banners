package
{
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Main extends Sprite
	{
		private var _bag:Bag;
		private var _gloves:Gloves;
		private var _keyboard:VGKeyboard;
		private var _mouseHitArea:MovieClip;
		private var _score:ScoreKeeper;
		private var _panel:Panel;
		
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_mouseHitArea = this["mouse_hit_mc"] as MovieClip;
			_bag = this["bag_mc"] as Bag;
			_gloves = this["gloves_mc"] as Gloves;
			_panel = this["panel_mc"] as Panel;
			_score = new ScoreKeeper();
			_panel.scoreKeeper = _score;
			
			_gloves.addEventListener(Gloves.L_HIT, hit);
			_gloves.addEventListener(Gloves.R_HIT, hit);
			
			// Activate keyboard input
			_keyboard = new VGKeyboard();
			_keyboard.activate(stage);
			_keyboard.poll(VGKeyboard.LEFT, swing);
			_keyboard.poll(VGKeyboard.RIGHT, swing);
			_keyboard.poll(VGKeyboard.UP, swing);
			_keyboard.poll(VGKeyboard.DOWN, swing);
			_keyboard.startPolling(1000/18);
			
			_mouseHitArea.buttonMode = true;
			_mouseHitArea.addEventListener(MouseEvent.CLICK, clicked);
		}
		
		private function swing(key:int):void
		{
			_gloves.punch(key);
		}
		
		private function hit(e:Event):void
		{
			_score.hit();
			if (e.type == Gloves.R_HIT)
				_bag.hit(VGKeyboard.RIGHT);
			else if (e.type == Gloves.L_HIT)
				_bag.hit(VGKeyboard.LEFT);
		}
		
		private function clicked(e:MouseEvent):void
		{
			var t:MovieClip = e.currentTarget as MovieClip;
			var mx:Number = t.mouseX - t.width/2;
			var my:Number = -t.mouseY + t.height/2;
			var area:int = 0;
			var rad:Number = Math.atan2(my,mx) / Math.PI * 180;
			
			// DIAGONAL
			/*if (rad < 45 && rad > -45) swing(VGKeyboard.RIGHT);
			if (rad > 135 && rad < 180) swing(VGKeyboard.LEFT);
			if (rad > -180 && rad < -135) swing(VGKeyboard.LEFT);
			if (rad > -135 && rad < -45) swing(VGKeyboard.DOWN);
			if (rad > 45 && rad < 135) swing(VGKeyboard.UP);*/
			
			// HALF
			if (mx > 0) swing(VGKeyboard.RIGHT);
			else swing(VGKeyboard.LEFT);
		}
	}
}