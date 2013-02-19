package com.halcyon.util.utilities
{
	public interface Debugger
	{
		function classAdded(className:String):void;
		function classRemoved(className:String):void;
		function onDebug(className:String, level:int, debugString:String):void;
	}
}