package com.halcyon.util.utilities
{
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.HalcyonEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ButtonUtil 
	{
		private static var log:Logger = LogFactory.getLog("ButtonUtil");
		
		private static var buttonList:Array;
		
		public function ButtonUtil()
		{
		}
		
		public static function setupListeners(button:Sprite, bg:MovieClip = null, toolTip:String = null):void{
			if(buttonList==null){
				buttonList = new Array();
			}
			
			if(bg == null){
				bg = button["mcButton"]; 
			}
			button.tabEnabled = false;
			button.buttonMode = true;
			
			gotoAndStop(bg, "up");
			
			if(button.hasEventListener(MouseEvent.MOUSE_OVER)) return;
			
			var obj:Object = new Object();
			obj.tooltip = toolTip;
			obj.btnBG = bg;
			
			obj.func_over = function(e:MouseEvent):void{onMouseOver(e,obj.btnBG, obj.tooltip)};
			obj.func_out = function(e:MouseEvent):void{onMouseOut(e,obj.btnBG)};
			obj.func_down = function(e:MouseEvent):void{onMouseDown(e,bg)}
			obj.func_up = function(e:MouseEvent):void{onMouseUp(e,bg)}
			obj.func_frame = function(e:Event):void{onEnterFrame(e,button)}
				
			button.addEventListener(MouseEvent.ROLL_OVER, obj.func_over);
			button.addEventListener(MouseEvent.ROLL_OUT, obj.func_out);
			button.addEventListener(MouseEvent.MOUSE_DOWN, obj.func_down);
			button.addEventListener(MouseEvent.MOUSE_UP, obj.func_up);
			bg.addEventListener(Event.ENTER_FRAME, obj.func_frame);
			disableText(button);
		}
	
		
		private static function disableText(obj:Sprite):void{
			for(var i:int = 0; i < obj.numChildren; i++){
				if(obj.getChildAt(i) is TextField){
					(obj.getChildAt(i) as TextField).mouseEnabled = false;
				} else if(obj.getChildAt(i) is Sprite){
					disableText(obj.getChildAt(i) as Sprite);
				}
			}
		}
		
		private static function gotoAndStop(clip:MovieClip,label:String):void
		{
			try 
			{
				clip.gotoAndStop(label);
			} catch (e:ArgumentError) 
			{ 
				clip.stop();
				log.debug("clip " + clip.name + " does not contain the label " + label);
			}
		}
		
		private static function onEnterFrame(e:Event,button:Sprite):void{
			if(button["mcButton"] == null) return;
			if(button["mcButton"].currentFrameLabel == "inactive"){
				button.buttonMode = false;
			} else {
				button.buttonMode = true;
			}
		}
		
		private static function onMouseOver(e:Event,bg:MovieClip, toolTip:String):void{
			if(bg.currentLabel != "inactive"){
				gotoAndStop(bg, "over");
			}
			if(toolTip != null){
				var event:HalcyonEvent = new HalcyonEvent("TOOL_TIP_SHOW");
				var extra:Object = new Object();
				extra.text = toolTip;
				event.setExtra(extra);
				EventManager.getInstance().dispatchEvent(event);
			}
		}
		
		private static function onMouseOut(e:Event,bg:MovieClip):void{
			log.debug("GOT MOUSEOUT!");
			if(bg.currentLabel != "inactive"){
				gotoAndStop(bg, "up");
			}
			var event:HalcyonEvent = new HalcyonEvent("TOOL_TIP_HIDE");
			EventManager.getInstance().dispatchEvent(event);
		}
		
		private static function onMouseDown(e:Event,bg:MovieClip):void{
			log.debug("mouse down");
			if(bg.currentLabel != "inactive"){
				gotoAndStop(bg, "down");
			}
		}
		
		private static function onMouseUp(e:Event,bg:MovieClip):void{
			if(bg.currentLabel != "inactive"){
				gotoAndStop(bg, "up");
			}
			//bg.dispatchEvent(new Event(MouseEvent.CLICK));
			var event:HalcyonEvent = new HalcyonEvent("TOOL_TIP_HIDE");
			EventManager.getInstance().dispatchEvent(event);
		}
		 
		private static function onClick(e:Event):void{
			log.debug("Click");
			
		}
	}
}   