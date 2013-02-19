package com.halcyon.util.utilities{
	//import com.halcyon.util.RealmText;
	//import com.halcyon.util.events.AlertEvents;
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.HalcyonEvent;
	//import com.halcyon.util.localization.Babelfish;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	//import mx.formatters.PhoneFormatter;

	public class Util {

		private static var log:Logger = LogFactory.getLog("Util");
		
		private static var _mayShowChatToolTip:Boolean = false;
		
		/**
		 * This state is maintained from core package.  The reason the state is copied
		 * here b/c "content" package needs access the this state.
		 */ 
		public static var isDTConsumer:Boolean = false;
		
		/**
		 * Used to print create a string representing an array
		 * @param name The name of the array, included in the string
		 * @param list The array to be printed
		 * @return A string representing the array
		 */
		public static function printArray( name:String, list:Array ) :String {
			var s:String = "\n\n ARRAY --> [" + name + "] length: " + list.length + "\n";
			for( var i:Number = 0; i < list.length; i++ ) {
				s+= "\n\n index: " + i + " --> " + list[i];
			}
			return s;
		}

		/**
		 * Used to determine if a given string begins with a supplied string
		 * @param prefix The string that you are checking for
		 * @param text the text that you are interested in seeing if starts with the prefix
		 * @return True if "text" begins with "prefix" False otherwise
		 */
		public static function startsWith( prefix:String, text:String ) :Boolean {
			var target:String = text.substring(0, prefix.length );
			return ( target == prefix );
		}

		/**
		 * Used to see if a given string ends with another given string
		 * @param postFix the string you are searching for
		 * @param text The text you are searching
		 * @return True if "text" ends with the string "postFix" False otherwise
		 */
		public static function endsWith( postFix:String, text:String ) :Boolean {
			var target:String = text.substring( text.length - postFix.length, text.length );
			return ( target == postFix );
		}

		/**
		 * Runs through a string, replacing all occurances of one char with another.  Note that the original string is not
		 * changed, a new string is created with the operation performed.
		 * @param text The string to perform this operation on
		 * @param inputChar The character you wish to replace
		 * @param outputChar The char you want to replace occurances of "inputChar" with
		 * @return A copy of "text" with all occurances of "inputChar" replaced with "outputChar"
		 */
		public static function replaceChar( text:String, inputChar:String, outputChar:String ) :String {
			var result:String = "";
			var len:Number = text.length;
			var char:String;
			for( var i:Number = 0; i < len; i++ ) {
				char = text.charAt(i);
				if ( char == inputChar ) {
					result+= outputChar;
				} else {
					result+= char;
				}
			}
			return result;
		}

		/**
		 * Takes in input string and returns all leading and trailing whitespace and linebreaks.
		 * This should leave the original string unmodified
		 * @param text The string on which to remove all leading and trailing whitespace
		 * @return A String with no leading or trailing whitespace or linebreaks
		 */
		public static function trimText( text:String, removeLineBreaks:Boolean = true ) :String {
			if ( text == null ) return "";
			if ( text == "" ) return "";

			var leadResult:String = "";
			var trailResult:String = "";
			var len:Number = text.length;
			var i:Number;
			var char:String;

			// TRIM LEADING SPACES
			for( i = 0; i < len; i++ ) {
				char = text.charAt(i);
				if ( char == " " || text.charCodeAt(i) == 9 ) {
					continue;
				} else {
					leadResult = text.substring(i, len);
					break;
				}
			}

			// TRIM TRAILING SPACES
			len = leadResult.length;
			for( i = (len-1); i >=0; i-- ) {
				char = leadResult.charAt(i);
				if ( char == " " || text.charCodeAt(i) == 9 ) {
					continue;
				} else {
					trailResult = leadResult.substring(0,i+1);
					break;
				}
			}

			if (!removeLineBreaks) return trailResult;
			var breaksRemoved:String = Util.removeLineBreaks(trailResult);
			return breaksRemoved;
		}

		/**
		 * Abbreviates a filename (or any String) by replacing any excess
		 * characters in the middle of the String with an ellipsis.
		 *
		 * @param string  The filename to be abbreviated
		 * @param maxChars  The maximum character length of the returned String
		 *
		 * @return A possibly abbreviated version of filename
		 */
		public static function abbreviateFilename (
			filename:String, maxChars:Number = 18) : String {
			var abbreviatedFilename:String = filename;
			if (filename.length > maxChars) {
				const prefixLength:int = Math.floor(maxChars/2);
				// Adjust suffix length to accomodate the ellipsis character
				// appropriately when maxChars is even : odd
				const suffixLength:int = (prefixLength * 2 == maxChars) ?
					prefixLength-1 : prefixLength;
				abbreviatedFilename =
					filename.substr(0, prefixLength) +
					'\u2026' /* ellipsis */ +
					filename.substr(-suffixLength);
			}
			return abbreviatedFilename;
		}

		/**
		 * Removes all linebreaks from the supplied string.
		 * This should remove any newline or carriage return characters
		 * @param text The string object to perform this operation on
		 * @return A String with no linebreaks
		 */
		public static function removeLineBreaks( text:String ) :String {
			var result:String = "";
			var len:Number = text.length;
			var charCode:Number;
			log.debug("My Text: " + text);
			for( var i:Number = 0; i < len; i++ ) {
				charCode = text.charCodeAt(i);
				if ( charCode == 10 ) continue;
				if ( charCode == 13 ) continue;
				result+= text.charAt(i);
			}
			return result;
		}

		/**
		 * Removes all leading whitepsace from a string.  Note that this will not remove newlines or carriage returns
		 * @param string The string to remove leading padding from.  THe original string is not modified.
		 * @return A String with no leading padding
		 */
		public static function removePadding( string:String ) :String {
			var result:String = "";
			var len:Number = string.length;
			var char:String;
			for( var i:Number = 0; i <= len; i++ ) {
				char = string.charAt(i);
				if ( char == "0" ) continue;
				result = string.substring( i, len );
				return result;
			}
			return "";
		}

		/**
		 * Pads the end of a given string with any number of a given character
		 * @param string The string to perform this operation on.
		 * @param padChar The character that you wish to append
		 * @param padCount The number of characters you wish to append
		 * @return The changed string
		 */
		public static function padString( string:String, padChar:String, padCount:Number ) :String {
			var len:Number = string.length;
			var padCountRemaining:Number = padCount - len;
			var result:String = string;
			for( var i:Number = 0; i < padCountRemaining; i++ ) {
				result = padChar + result;
			}
			return result;
		}

		/**
		 * Checks to see if a given string is a valid email address.  This is only to check formatting, not to see
		 * if the email address is valid.
		 * @param s The string to check
		 * @return True if s is a valid email address format, False if not
		 */
		public static function validateEmail(s:String):Boolean{

			if(trimText(s) == ""){
				return false;
			}
			if(s.lastIndexOf("@") == -1){
				return false;
			}
			if(s.lastIndexOf(".") == -1){
				return false;
			}
			s = trimText(s);
			if(!s.match(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/)){
				return false;
			}

			return true;
		}


		/*
		* An Actionscript implementation of utf8 coding algorithm
		* Version 1.0 Copyright (C)2003 by Tobias Fendel
		*/
		//May not work with Client 5 yet, needs debugging
		public static function utf8_encode(txt:String) :String{
	        var r:Array = [];
	        for(var n:int=0; n<txt.length; n++) {
	        	var c:int = txt.charCodeAt(n);
	            if (c<128) {                        /* the signs of ansi => 1byte */
					r.push(String.fromCharCode(c));
	            } else if((c>127) && (c<2048)) {    /* the signs between 127 and 2047 => 2byte */
					r.push(String.fromCharCode((c>>6)|192));
	                r.push(String.fromCharCode((c&63)|128));
	            } else {                            /* the signs between 2048 and 65536 => 3byte */
					r.push(String.fromCharCode((c>>12)|224));
	                r.push(String.fromCharCode(((c>>6)&63)|128));
	                r.push(String.fromCharCode((c&63)|128));
	            }
	        }
	        return r.join("");
		}


		//May not work with Client 5 yet, needs debugging
		public static function utf8_decode( txt:String ) :String{
	        var r:Array=[];
	        var i:int=0;
	        while(i<txt.length) {
				var c1:int=txt.charCodeAt(i);
	            var c2:int=txt.charCodeAt(i+1);
	            var c3:int=txt.charCodeAt(i+2);
	            if (c1<128) {
	            	r.push(txt.charAt(i));
	                i+=1;
	            } else if((c1>191) && (c1<224)) {
	            	r.push(String.fromCharCode(((c1&31)<<6)|(c2&63)));
	                i+=2;
	            } else {
	                r.push(String.fromCharCode(((c1&15)<<12)|((c2&63)<<6)|(c3&63)));
	                i+=3;
	            }
	        }
	        return r.join("");
		}


		public static function scaleClipProportionally( mc:MovieClip, hostWidth:Number, hostHeight:Number ) :void {

			// SCALE
			mc.scaleX = 100;
			mc.scaleY = 100;
			if ( ( mc.width > hostWidth ) || ( mc.height > hostHeight ) ) {
				var scale:Number = Math.min( hostWidth/mc.width, hostHeight/mc.height)*100;
				mc.scaleX = scale;
				mc.scaleY = scale;

			}

	       	// CENTER
	       	mc.x = hostWidth / 2 - mc.width / 2;
	       	mc.y = hostHeight / 2 - mc.height / 2;


		}

		public static function getProportionalScale( mc:MovieClip, hostWidth:Number, hostHeight:Number ) :Number {
			if ( ( mc.width > hostWidth ) || ( mc.height > hostHeight ) ) {
				return Math.min( hostWidth / mc.width, hostHeight / mc.height) * 100;
			}
			return 100;
		}

		public static function splitHexColorValues( hexColor:Number ) :Object {
			var hexMask:Number = 0xFF;
			var b:Number = (hexColor >> 0) & hexMask;
			var g:Number = (hexColor >> 8) & hexMask;
			var r:Number = (hexColor >> 16) & hexMask;
			return {r:r, g:g, b:b}
		}

		public static function colorClipAndPreserveOutlines( mcClip:MovieClip, hexColor:Number, percentage:Number = 1) :void {

			if ( mcClip == null ) return;
			if ( hexColor == -1 ) hexColor = 0xFFFFFF;
			var rgb:Object = Util.splitHexColorValues(hexColor);
			var r:Number = rgb.r - 255;
			var g:Number = rgb.g - 255;
			var b:Number = rgb.b - 255;
			var colorTransform:ColorTransform = new ColorTransform( percentage,percentage,percentage,1,r,g,b,0);
			mcClip.transform.colorTransform = colorTransform;
		}

		public static function formatTokens( tokens:Number ) :String {
			var result:String = "";
			var s:String = String(tokens);
			var len:Number = s.length;
			var counter:Number = 0;
			for( var i:Number = (len-1); i >= 0; i-- ) {
				counter++;
				var char:String = s.charAt(i);
				result = char + result;
				if ( ( i > 0 ) && (counter % 3 == 0 ) ) {
					result = "," + result;
				}
			}
			return result;
		}

		public static function removeDuplicateLineBreaks( text:String ) :String {
			//log.output("################# Util.removeDuplicateLineBreaks() B4: " + text);
			var len:Number = text.length;
			var editedText:String = "";
			var previousCharCode:Number;
			var nextCharCode:Number;
			var nextChar:String;
			for( var i:Number = 0; i < len; i++ ) {
				nextChar = text.charAt(i);
				nextCharCode = text.charCodeAt(i);
				//log.output("################# Util.removeDuplicateLineBreaks() char: " + nextChar + ", code: " + nextCharCode);
				if ( ( nextCharCode == 10) && (  previousCharCode == 13 ) ) {
					// nuttin
				} else {
					editedText+= nextChar;
				}
				previousCharCode = nextCharCode;
			}
			//log.output("################# Util.removeDuplicateLineBreaks() AFTER: " + editedText);
			return editedText;
		}

		public static function setSkinnableButtonLabel(button:MovieClip, label:String):void{
			button.tfLabel.text = label;
			var labelIncrease:Number = button.tfLabel.textWidth - button.tfLabel._width + 20;
			button.tfLabel._width = button.tfLabel.textWidth + 20;
			var bgIncrease:Number = button.tfLabel.textWidth + 50 - button.mcBg._width;
			button.mcBg._width = button.tfLabel.textWidth + 50;
			button.tfLabel._x -= labelIncrease/2;
			button.mcBg._x -= bgIncrease/2;
		}

		public static function drawOval( clip:Graphics, x:Number, y:Number, radius:Number, yRadius:Number = -9999) :void {
			// ==============
			// mc.drawOval() - by Ric Ewing (ric@formequalsfunction.com) - version 1.1 - 4.7.2002
			//
			// x, y = center of oval
			// radius = radius of oval. If [optional] yRadius is defined, r is the x radius.
			// yRadius = [optional] y radius of oval.
			// ==============

			// init variables
			var theta:Number, xrCtrl:Number, yrCtrl:Number, angle:Number, angleMid:Number, px:Number, py:Number, cx:Number, cy:Number;
			// if only yRadius is undefined, yRadius = radius
			if (yRadius == -9999) {
				yRadius = radius;
			}
			// covert 45 degrees to radians for our calculations
			theta = Math.PI/4;
			// calculate the distance for the control point
			xrCtrl = radius/Math.cos(theta/2);
			yrCtrl = yRadius/Math.cos(theta/2);
			// start on the right side of the circle
			angle = 0;
			clip.moveTo(x+radius, y);
			// this loop draws the circle in 8 segments
			for (var i:Number = 0; i<8; i++) {
				// increment our angles
				angle += theta;
				angleMid = angle-(theta/2);
				// calculate our control point
				cx = x+Math.cos(angleMid)*xrCtrl;
				cy = y+Math.sin(angleMid)*yrCtrl;
				// calculate our end point
				px = x+Math.cos(angle)*radius;
				py = y+Math.sin(angle)*yRadius;
				// draw the circle segment
				clip.curveTo(cx, cy, px, py);
			}
		}

		/**
	     * duplicateDisplayObject
	     * creates a duplicate of the DisplayObject passed.
	     * similar to duplicateMovieClip in AVM1
	     * @param target the display object to duplicate
	     * @param autoAdd if true, adds the duplicate to the display list
	     * in which target was located
	     * @return a duplicate instance of target
	     */
	    public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
	        // create duplicate
	        var targetClass:Class = Object(target).constructor;
	        var duplicate:DisplayObject = new targetClass();

	        // duplicate properties
	        duplicate.transform = target.transform;
	        duplicate.filters = target.filters;
	        duplicate.cacheAsBitmap = target.cacheAsBitmap;
	        duplicate.opaqueBackground = target.opaqueBackground;
	        if (target.scale9Grid) {
	            var rect:Rectangle = target.scale9Grid;
	            // Flash 9 bug where returned scale9Grid is 20x larger than assigned
	            rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
	            duplicate.scale9Grid = rect;
	        }

	        // add to target parent's display list
	        // if autoAdd was provided as true
	        if (autoAdd && target.parent) {
	            target.parent.addChild(duplicate);
	        }
	        return duplicate;
	    }

		/**
		 * Takes in strings and formats them in a way specified by the design team.  Basically
		 * this format is all caps except for 'iMEET' which has a lower case i.  As this may
		 * change in the future I'm making a centralized method for applying this format.
		 * @param toFormat A string to format with the iMeet formatting rule
		 * @return A formatted String
		 */
		public static function iMeetTitleFormat(toFormat:String):String{
			var toRet:String = toFormat.toString();
			toRet = toRet.toUpperCase();
			var pattern:RegExp = / IMEET/g;
			toRet = toRet.replace(pattern," iMEET");
			if(Util.startsWith("IMEET",toRet)){
				toRet = "iMEET" + toRet.substr(5);
			}
			return toRet;
		}
		
		/**
		 * Utility method to remove the posession apostostrophe if the room name
		 * contains the Host's first name, AND the language requirements specify to.
		 * @param	str The text of the string to analyze (usually the realm name)
		 * @param	possessor The string of the possible posesser (usually host first name)
		 * @return The text with or without the posession apostrophe
		 */
		/*public static function applyRoomNamePossession(str:String, possessor:String):String
		{
			var bf:Babelfish = Babelfish.getInstance();
			if (!bf || !bf.ready) return str;
			if (bf.getText("common", "possessionApostrophe") == "yes") return str;
			
			var words:Array = str.split(" ");
			var newWords:Array = [];
			for each (var word:String in words)
			{
				var parts:Array = word.split("'");
				if (parts.length != 2)
				{
					newWords.push(word);
					continue;
				}
				
				if (parts[0].toLowerCase() == possessor.toLowerCase())
				{
					newWords.push(parts.join(""));
				} else
				{
					newWords.push(word);
				}
			}
			
			return newWords.join(" ");
		}*/

		/**
		 * Returns the state of the user's browser popup blocker
		 * @return True if the popup blocker is enabled.
		 */
		public static function isPopupBlocked():Boolean{
			return ExternalInterface.call("isPopupBlocked");
		}

		private static var _regSmall : RegExp = new RegExp( /([a-z]+)/ );
		private static var _regBig : RegExp = new RegExp( /([A-Z]+)/ );
		private static var _regNum	: RegExp = new RegExp( /([0-9]+)/ );
		private static var _regSpecial : RegExp = new RegExp( /(\W+)/ );

		/**
		 * Returns the strength of the password in number of character classes where character
		 * classes are defined as lower case, upper case, numbers and special characters.
		 * @param password The password to check
		 * @return int representing the number of character classes
		 */
		public static function checkPasswordStrength(password:String):int{
			var toRet:int = 0;
			if( password.search( _regSmall ) != -1 )
			{
				toRet ++;
			}
			if( password.search( _regBig ) != -1 )
			{
				toRet ++;
			}
			if( password.search( _regNum ) != -1 )
			{
				toRet ++;
			}
			if( password.search( _regSpecial ) != -1 )
			{
				toRet ++;
			}
			return toRet;

		}

		/**
		 * Compares properties of the srcObject with the same properties of objToCompare
		 * This function does NOT determine if two objects are identical.
		 * @param	srcObject Object to compare to
		 * @param	objToCompare Object to compare with
		 * @return true if all the props of srcObject exist in objToCompare and contain the same value
		 */
		public static function compareObject(srcObject:Object,objToCompare:Object):Boolean
		{
			try {
				for (var prop:String in srcObject)
				{
					log.debug("" + prop + ":" + srcObject[prop] + "?=" + objToCompare[prop]);
					if (srcObject[prop] != objToCompare[prop]) return false;
				}
			} catch (e:Error) { return false;}
			return true;
		}
		
		/**
		 * Returns whether or not the user has allowed access
		 * to the camera and mic via the Flash settings panel
		 * @return
		 */
		public static function getMicCamAllowed():Boolean
		{
			if (Microphone.isSupported && (Microphone.names.length>0))
			{
				return !Microphone.getMicrophone().muted;
			}
			
			if (Camera.isSupported && (Camera.names.length>0))
			{
				return !Camera.getCamera().muted;
			}
			return true;
		}
		
		/**
		 * Makes a true deep copy of an object using ByteArrays
		 * NOTE: Does not work with custom data types
		 * @param	srcObj The Object to copy
		 * @return  The copied object
		 */
		public static function getDuplicateObject(srcObj:Object):Object
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject(srcObj);
			ba.position = 0;
			return ba.readObject();
		}
		
		/**
		*       Formats a number to include a specified thousands separator and decimal point character,
		*       as well, it rounds the number to a specified number of decimal places
		*
		*       @param p_num The number that will be formatted
		*       @param p_separator The character to use as a thousands separator
		*       @param p_decimalPlaces The number of decimal places
		*       @param p_decimal The character to use as a decimal point
		*       @return A string with the specified decimal point, decimal places and thousands separator
		*
		*       @langversion ActionScript 3.0
		*       @playerversion Flash 9.0
		*       @tiptext
		*/
		public static function formatNumber(p_num:Number, p_separator:String="", p_decimalPlaces:Number=0, p_decimal:String="."):String
		{
			var out:String = "";
			var numArray:Array = String(p_num).split(".");
			var intVal:String = numArray[0];
			var decVal:String = numArray[1];
			var rounded:int;
			var isNeg:Boolean = false;

			if (p_num < 0)
			{
					isNeg = true;
					p_num = Math.abs(p_num);
			}

			if (p_decimalPlaces > -1)
			{
					if (p_num < 0.1)
					{
							out = (isNeg==true) ? "-0" + p_decimal : "0" + p_decimal;

							rounded = Math.pow(10, p_decimalPlaces);
							p_num = Math.round(p_num * rounded);

							var decCount:int = p_decimalPlaces;
							var strLen:int = String(p_num).length;
							while (decCount > strLen) {
									out += "0";
									decCount--;
							}
							out += String(p_num);

							return out;
					}

					rounded = Math.pow(10, p_decimalPlaces);
					p_num = Math.round(p_num * rounded);

					if (p_decimalPlaces == 0)
					{
							intVal = String(p_num);
					}

					decVal = (p_decimalPlaces > 0) ? p_decimal + String(p_num).substr(String(p_num).length - p_decimalPlaces) : "";

			} else {
					decVal = p_decimal + decVal;
			}

			var pattern:RegExp = /\d{1,3}(?=(\d{3})+(?!\d))/g;

			var patObj:String = "$&"+ p_separator;

			while (pattern.test(intVal))
			{
					intVal = intVal.replace(pattern, patObj);
			}

			out = intVal + decVal;

			return out;
		}
		
		/**
		 * Returns the current client's flash version as a Number
		 * i.e. 11
		 * @return
		 */
		public static function getFlashVersionAsNumber():Number
		{
			var verArray:Array = Capabilities.version.split(" ")[1].split(",");
			var flashVer:Number = parseInt(verArray[0]);
			var decimal:Number = parseFloat("." + (verArray[1] + verArray[2] + verArray[3]));
			flashVer += decimal;
			return flashVer;
		}
		
		public static var fakeDT:Boolean = false;
		
		/**
		 * Returns whether or not we are running on a Deutsche Telekom environment
		 * @return TRUE if the client is on imeet.de or dt.imeet.com
		 */
		/*public static function isDT():Boolean
		{
			// fake-DT for test purposes
			if (fakeDT)
			{
				return fakeDT;
			}
			
			var realmUri:String = ClientUrls.getInstance().getRealmUri();
			return (realmUri.indexOf("imeet.de") > -1 || realmUri.indexOf("dt.imeet.com") > -1);
		}*/
				
		/**
		 * Return IE version #
		 * @return
		 */
		public static function getIEVersion():Number
		{
			var ua:String = ExternalInterface.call("function(){return navigator.userAgent}");
			
			var regEx:RegExp = /MSIE ([0-9]{1,}[\.0-9]{0,})/;
			var match:Array = ua.match(regEx);
			if (match == null) return -1;
			var verNum:Number = parseFloat(ua.match(regEx)[1]);
			log.debug ("getIEVersion:" + verNum);
			return verNum;
		}
		
		/*static public function showAlert(title:String, body:String):void
		{
			var alertEvent:HalcyonEvent = new HalcyonEvent(AlertEvents.ALERT);
			var extra:Object = new Object();
			extra.title = title;
			extra.body = body;
			extra.type = AlertEvents.TYPE_NORMAL
			alertEvent.setExtra(extra);
			EventManager.getInstance().dispatchEvent(alertEvent);
		}*/
		
		static public function get mayShowChatToolTip():Boolean 
		{
			return _mayShowChatToolTip;
		}
		
		static public function set mayShowChatToolTip(value:Boolean):void 
		{
			_mayShowChatToolTip = value;
		}
	}
}
