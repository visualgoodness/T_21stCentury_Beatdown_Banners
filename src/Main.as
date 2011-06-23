package
{
	import com.visualgoodness.controller.VGKeyboard;
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	
	public class Main extends MovieClip implements IInputDelegate, IStartMenuDelegate
	{
		private var _bag:IBag;
		private var _gloves:Gloves;
		private var _score:ScoreKeeper;
		private var _panel:Panel;
		private var _inputManager:BoxingInputManager;
		private var _startMenu:StartMenu;
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_bag = this["bag_mc"] as IBag;
			_gloves = this["gloves_mc"] as Gloves;
			_panel = this["panel_mc"] as Panel;
			_startMenu = this["start_menu_mc"] as StartMenu;
			_startMenu.delegate = this;
			_score = new ScoreKeeper();
			_panel.scoreKeeper = _score;
			_bag.scoreKeeper = _score;
			_gloves.addEventListener(HitEvent.L_HIT, hit);
			_gloves.addEventListener(HitEvent.R_HIT, hit);
		}
		
		public function start(insuranceCoIndex:int):void
		{
			gotoAndPlay("startGame");
			activateInputs();
		}
		
		private function activateInputs():void
		{
			_inputManager = new BoxingInputManager(this, this["mouse_hit_mc"] as MovieClip);
		}
		
		public function swing(punch:int):void
		{
			_gloves.punch(punch);
		}
		
		private function hit(e:HitEvent):void
		{
			_score.hit();
			if (e.type == HitEvent.R_HIT)
			{
				//_bag.hit(VGKeyboard.RIGHT);
				_bag.hitWithLoc(Gloves.JAB_R, e.anchor);
			}
			else if (e.type == HitEvent.L_HIT)
			{
				//_bag.hit(VGKeyboard.LEFT);
				_bag.hitWithLoc(Gloves.JAB_L, e.anchor);
			}
		}
	}
}