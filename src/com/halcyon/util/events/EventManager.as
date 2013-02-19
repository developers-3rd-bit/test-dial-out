package com.halcyon.util.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.halcyon.util.utilities.HashMap;

	/*
	 * A singleton version of Flash's built in Event Dispatcher
	 */
	public class EventManager extends EventDispatcher
	{
		public static const DISPLAY_LOADED:String = "DISPLAY_LOADED";
		public static const SEND_CHAT:String = "SEND_CHAT";
		public static const CHAT_MESSAGE:String = "CHAT_MESSAGE";
		public static const CHAT_LOADED:String = "CHAT_LOADED";
		public static const DEBUG:String = "DEBUG";
		public static const TOOL_CONTROLLER_ACTION:String = "TOOL_CONTROLLER_ACTION";
		public static const CONF_RECORDING_TOGGLE:String = "CONF_RECORDNG_TOGGLE";
		public static const WEATHER_TOGGLE:String = "WEATHER_TOGGLE";
		public static const WEATHER_LOADED_IN_CLIENT:String = "WEATH_LOADED_IN_CLIENT";
		public static const MERGE_EVENT:String = "MERGE_EVENT";
		
		private static var inst:EventManager;

		private var previousEventMap:HashMap;

		public static function getInstance():EventManager{
			if(inst == null){
				inst = new EventManager();
			}
			return inst;
		}

		public function EventManager():void{
			this.previousEventMap = new HashMap;
		}

		/**
		 * Override of the default dispatchEvent, this will archive the event if nothing is listening for it
		 */
		override public function dispatchEvent(event:Event):Boolean{

			if(!this.hasEventListener(event.type)){
				if(this.previousEventMap.get(event.type) == null){
					this.previousEventMap.put(event.type,new Array());
				}

				this.previousEventMap.get(event.type).push(event);
				return false;
			} else {
				return super.dispatchEvent(event);
			}
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function addEventListenerAndReplay(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			var previousEvents:Array = this.previousEventMap.get(type) as Array;

			if(previousEvents != null){
				for(var i:int = 0; i < previousEvents.length; i++){
					listener(previousEvents[i]);
				}
			}
			return super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
	}
}