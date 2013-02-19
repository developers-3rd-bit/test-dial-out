package com.halcyon.interfaces.user 
{
	
	/**
	 * ...
	 * @author JCC
	 */
	public interface IUserContact 
	{
		function get fname():String;
		function get lname():String;
		function get email():String;
		function get phoneNum():String;
		function get phoneExt():String;
		function get phoneIntlPrefix():String;
		function get organization():String;
		function get title():String;
		function get id():Number;
		function get clientId():Number;
		function get furl():String;
		
	}
	
}