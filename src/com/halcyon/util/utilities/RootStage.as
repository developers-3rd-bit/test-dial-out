package com.halcyon.util.utilities
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import com.halcyon.util.events.HalcyonEvent;
	import com.halcyon.util.events.EventManager;

	/*
	 * Singleton class to provide access to the application's root
	 */
	public class RootStage
	{
		private static var inst:RootStage;

		private var stage:Stage;
		private var panelOffsets:HashMap;

		public static function getInstance():RootStage{
			if(inst == null){
				inst = new RootStage();
			}
			return inst;
		}

		public function RootStage(){
			panelOffsets = new HashMap();
			EventManager.getInstance().addEventListener("changeFrameRate", onChangeFrameRate);
		}

		private function onChangeFrameRate(e:Event):void {
			var he:HalcyonEvent = (e as HalcyonEvent);
			stage.frameRate = he.getExtra().frameRate;
		}

		public function getStage():Stage {
			return this.stage;
		}

		public function setStage(stage:Stage):void{
			this.stage = stage;
			this.stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		}



		public function getPanelOffsets():HashMap{
			return this.panelOffsets;
		}

		public function setPanelOffsets(panelOffsets:HashMap):void{
			this.panelOffsets = panelOffsets;
		}

		private function onMouseClick(e:Event):void{
			var focusevent:HalcyonEvent = new HalcyonEvent("FOCUS_CHAT");
			EventManager.getInstance().dispatchEvent(focusevent);
		}
	}
}