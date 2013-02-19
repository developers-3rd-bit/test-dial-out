package com.halcyon.util.utilities
{
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.HalcyonEvent;
	
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	
	public class Logger
	{
		//import com.halcyon.util.utilities.Flashout;
	
		public static const FATAL:int 	= 1;
		public static const WARN:int 	= 2;
		public static const ERROR:int 	= 3;
		public static const INFO:int 	= 4;
		public static const DEBUG:int 	= 5;
		public static const REMOTE_LOG_EVENT:String = 'REMOTE_LOG_EVENT';
		
		public static var LEVELS:Array = new Array({label:"FATAL",data:FATAL},{label:"WARN",data:WARN},{label:"ERROR",data:ERROR},{label:"INFO",data:INFO},{label:"DEBUG",data:DEBUG});
		public static var NULL_LOG:Boolean = false;  // Never check it in...
		public static var ALLOWED_LOGGERS:Array;//  = new Array("nsinfo", "webcamsessionmanager", "baseroom", "standardcubefrontpm", "userimagepresentation", "nsmanager", "filesharefilefactory");
		
		private static var _DEBUGGER_CALLBACK:Function;
		//private static var DebugOverride:Boolean = false;
		
		private var level:int = Logger.ERROR;
		private var category:String = "ROOT";
		private var mcOutputClip:MovieClip;
		private var allowOutput:Boolean = false;
		
		private var debugHistory:String = "";
		
		public function Logger( category:String, allowOutput:Boolean ) {
			this.category = category;
			this.allowOutput = allowOutput;
		}
		
		public function getCategory( ) :String {
			return this.category;
		}
		
		public function setLevelByName( name:String ) :Boolean {
			var levelSet:Boolean = false;
			var level:int = this.getLevelByName( name );
			if ( level != -1 ) {
				this.setLevel(level);
				levelSet = true;
			}
			return levelSet;
		}
		
		public function setLevel( level:int ) :void {
			this.level = level;
		}
		
		public function getLevel( ) :int {
			return this.level;
		}
		
		public function isDebugEnabled( ) :Boolean {
			return (this.level >= Logger.DEBUG) && (this.allowOutput);
		}
		
		public function debug( message:String ) :void {
			if (NULL_LOG) return;
			// TODO: Never check it in... I.H.
			if (ALLOWED_LOGGERS && ALLOWED_LOGGERS.indexOf(category) < 0) return;
			if ( this.level >= Logger.DEBUG ) {
				trace(message);
				this.output( this.getOutputMessage( message ) );
			}
		}
		
		public function isInfoEnabled( ) :Boolean {
			return this.level >= Logger.INFO;
		}
			
		
		public function info( message:String ) :void {
			if (NULL_LOG) return;
			if ( this.level >= Logger.INFO ) {
				this.output( this.getOutputMessage( message ) );
			}
		}
		
		public function isWarnEnabled( ) :Boolean {
			return this.level >= Logger.WARN;
		}
		
		public function warn( message:String ) :void {
			if ( this.level >= Logger.WARN ) {
				if (!NULL_LOG) this.output( this.getOutputMessage( message ) );
				EventManager.getInstance().dispatchEvent(new HalcyonEvent(REMOTE_LOG_EVENT, false, false, {logText:message, level:Logger.WARN, clazz:category}));
			}
		}
		
		public function isErrorEnabled( ) :Boolean {
			return this.level >= Logger.ERROR;
		}
		
		public function error( message:String ) :void {
			if ( this.level >= Logger.ERROR ) {
				if (!NULL_LOG) this.output( this.getOutputMessage( message ) );
				EventManager.getInstance().dispatchEvent(new HalcyonEvent(REMOTE_LOG_EVENT, false, false, {logText:message, level:Logger.ERROR, clazz:category}));
			}
		}
		
		public function isFatalEnabled( ) :Boolean {
			return this.level >= Logger.FATAL;
		}
		
		public function fatal( message:String ) :void {
			if ( this.level >= Logger.FATAL ) {
				if (!NULL_LOG) this.output( this.getOutputMessage( message ) );
				EventManager.getInstance().dispatchEvent(new HalcyonEvent(REMOTE_LOG_EVENT, false, false, {logText:message, level:Logger.FATAL, clazz:category}));
			}
		}
		
		
		public function setOutputClip( mcOutputClip:MovieClip ) :void {
			this.mcOutputClip = mcOutputClip;
		}
		
		private function getOutputMessage( message:String ) :String {
			var sOutput:String = "";
			
			var sLevelName:String = this.getLevelName(this.level).toUpperCase();
			sOutput = sLevelName + ": " + this.category.toUpperCase() + ":\t\t\t" + message;
			
			return sOutput;
		}
		
		
		public function output( message:String ) :void {
			if (NULL_LOG) return;
			if(!allowOutput){
				var date:Date = new Date();
				//this.debugHistory += "\n" + date.getHours() + " " + date.getMinutes() + date.getSeconds() + " - " + message;
				this.debugHistory += "\n" + getTimer() + " - " + message;
				if(this.debugHistory.length >= 10000){
					this.debugHistory = this.debugHistory.substr(10000);
				}
			}  else {
				outputRuntimeMessage(message);
			}
		}
		
		public function outputSessionMessage( message:String ) :void {
			this.output(message);
		}
		
		public function setDebugOverride( override:Boolean) :void {
			
			allowOutput = override;
			if(override == true){
				outputRuntimeMessage(this.debugHistory);
				this.debugHistory = "";
			}
		}
	
		public function outputRuntimeMessage( message:String ) :void {
			if (NULL_LOG) return;
			//var event:HalcyonEvent = new HalcyonEvent(EventManager.DEBUG);
			var debugObject:Object = new Object();
			debugObject.message = message;
			debugObject.className = category;
			/*event.setExtra(debugObject);
			EventManager.getInstance().dispatchEvent(event);*/
			
			Logger.outputMessage(debugObject);
		}
		
		public static function clearDebug( ) :void {
			//_level0.mcTarget.mcDebug.taOutput.text = "";
			//_level0.mcTarget.mcDebug.taOutput.vPosition = _level0.mcDebug.taOutput.maxVPosition;
		}
		
		private function getLevelName( level:int ) :String {
			switch( level ) {
				case Logger.FATAL:
					return "FATAL";
					break;
				case Logger.WARN:
					return "WARN";
					break;
				case Logger.ERROR:
					return "ERROR";
					break;
				case Logger.INFO:
					return "INFO";
					break;
				case Logger.DEBUG:
					return "DEBUG";
					break;
				default: return "UNKNOWN LEVEL";
			}
		}
		
		public function getLevelByName( levelName:String ) :int {
			switch( levelName ) {
				case "FATAL":
					return Logger.FATAL;
					break;
				case "WARN":
					return Logger.WARN;
					break;
				case "ERROR":
					return Logger.ERROR;
					break;
				case "INFO":
					return Logger.INFO;
					break;
				case "DEBUG":
					return Logger.DEBUG;
					break;
			}
			return -1;
		}
		
		public function toString( ) :String {
			var s:String = "[Logger] category: " + this.category + ", level: " + this.getLevelName( this.level );
			return s;
		}
		
		static public function setCallback(fxn:Function):void
		{
			_DEBUGGER_CALLBACK = fxn;
		}
		
		static private function outputMessage(debugObject:Object):void
		{
			try {
				_DEBUGGER_CALLBACK.call(null, debugObject);
			} catch(e:Error) { /* callback not yet set */ }
		}
	}
}