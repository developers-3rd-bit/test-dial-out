package com.halcyon.util.utilities
{
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.HalcyonEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * An utility class that consolidates same Alerts from different panels.
	 * 
	 * @author: IH
	 */ 
	
	public class AlertHelper extends EventDispatcher
	{
		public function AlertHelper(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function showDTConsumerAlert():void
		{
			// Show an alert
			var evt:HalcyonEvent = new HalcyonEvent("ALERT"); // AlertManager.ALERT;
			var obj:Object = new Object();
			// obj.title = Babelfish.getInstance().getText("alertText", "whoops", "Whoops. Something went wrong.");
			// obj.body = Babelfish.getInstance().getText("alertText", "siteFailed", "iMeet is having trouble finding the web site '") + baseFile.getFileName() + Babelfish.getInstance().getText("alertText", "siteFailed2", "'. Please check that it was typed correctly and try again.");
			obj.title = "Sorry";
			obj.body = "Coming soon, product upgrades are not available at this time.";
			evt.setExtra(obj);
			EventManager.getInstance().dispatchEvent(evt);
		}
		
	}
} class SingletonEnforcer {}