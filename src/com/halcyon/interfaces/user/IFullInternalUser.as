//------------------------------------------------------------------------------
//
//   iMeet 
// 
//   Copyright 2010 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package com.halcyon.interfaces.user {
	
	public interface IFullInternalUser extends IUser {
		
		/**
		 * Determines whether the user is the unknown caller.
		 *
		 * @return True if the user is the unknown caller; false otherwise.
		 */
		function getIsUnknownCaller() : Boolean;
		
		/**
		 * Determines whether the user is connecting to a phone line.
		 *
		 * @return True if the user is connecting; false otherwise.
		 */
		function getLoading() : Boolean;
		
		/**
		 * Gets the state for this user, if there is one.
		 * @return The state string for the user "" if there is no state.
		 */
		function getState() : String;
		
		/**
		 * Sets the company of this user.
		 *
		 * @param value The user's company.
		 */
		function setCompany(value:String) : void;
		
		/**
		 * Sets the value of the connecting flag.
		 *
		 * @param value True if the user is connecting; false otherwise.
		 */
		function setLoading(value:Boolean) : void;
		
		/**
		 * Sets the merged flag for this user.
		 *
		 * @param value True if the user is merged; false otherwise.
		 */
		function setMerged(value:Boolean) : void;
		
		/**
		 * Sets the name of this user.
		 *
		 * @param value The user's name.
		 */
		function setName(value:String) : void;
		
		/**
		 * Sets the title of this user.
		 *
		 * @param value The user's title.
		 */
		function setTitle(value:String) : void;
		
		/**
		 * Sends an UpdateUserReq message to the server
		 */
		function sendUpdate():void;
		
		/**
		 * Gets the value of the skipInfoPrompt user pref
		 * 
		 * @return
		 */
		function getSkipInfoPrompt():Boolean;
		
		/**
		 * Sets the value of the skipInfoPrompt user pref
		 * @param	value
		 */
		function setSkipInfoPrompt(value:Boolean):void;
	}
}