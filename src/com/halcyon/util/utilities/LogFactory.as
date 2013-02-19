package com.halcyon.util.utilities
{
	import com.halcyon.util.utilities.Logger;
	
	import flash.display.MovieClip;
	
	public class LogFactory
	{
		private static var loggers:HashMap = new HashMap();
		private static var outputClip:MovieClip;
		
		public static var allowOutput:Boolean = false;
		
		private static var debuggers:Array = new Array();
		
		public static function setOutputClip( outputClip:MovieClip ) :void {		
			LogFactory.outputClip = outputClip;
		}
		
		public static function addDebugger(debugger:Debugger):void{
			debuggers.push(debugger);
		}
		
		public static function getAllLogNames():Array{
			return loggers.keys();
		}	
		
		public static function getLog( category:String, level:int = 0 ) :Logger { 
			
			category = category.toLowerCase(); 
			var logger:Logger;
			if(loggers.get(category) != null){
				return loggers.get(category) as Logger;
			}
					
			logger = new Logger( category, allowOutput );
			logger.setOutputClip( LogFactory.outputClip );
			logger.setLevel(level);
			LogFactory.loggers.put(category, logger );
			for(var i:int = 0; i<debuggers.length; i++){
				debuggers[i].classAdded(category);
			}
			
			return logger;
		}	
		
		public static function toString( ) :String {
			var s:String = "[Logfactory]";
			for( var i:int = 0; i < LogFactory.loggers.getValues().length; i++ ) {
				s+= "\n" + LogFactory.loggers.getValues()[i];
			}
			return s;
		}
		
		public static function setEnabled(value:Boolean):void{
			allowOutput = value;	
			
			for(var i:int = 0; i < LogFactory.loggers.getValues().length; i++){
				loggers.getValues()[i].setDebugOverride(value);	
			}
		}
	}
}