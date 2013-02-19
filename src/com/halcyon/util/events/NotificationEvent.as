package com.halcyon.util.events {
	
	
	public class NotificationEvent extends HalcyonEvent {
		
		/**
		 * Represents a request to send a notification into the chat 
		 * panel
		 */
		public static const SEND_NOTIFICATION:String = "sendChatNotification";
		
		public var title:String = "";
		public var body:String = "";
		public var timeoutLength:int = 5;
		public function NotificationEvent(type:String, title:String="", body:String="", timeoutLength:int=5) {
			super(type);
			this.title = title;
			this.body = body;
			this.timeoutLength = timeoutLength;
		}
	}
}