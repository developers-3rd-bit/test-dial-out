package com.halcyon.util.utilities
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * Utility class that contains various helper functions that have
	 * to do with Text and TextFields
	 * @author JCC
	 */
	public class TextUtil
	{
		private static var log:Logger = LogFactory.getLog("TextUtil", Logger.DEBUG);
		
		/**
		 * Reduces the font size of a text field until the width of the field
		 * is less than the specified amount
		 * @param	tf TextField to resize
		 * @param	width Width, in pixels to fit the width to
		 * @param	minSize Minimum size to set the font to
		 * @param	letterSpacing Amount of letterspacing applied to the textfield
		 * @return  The final width of the text field
		 */
		public static function resizeTextToFitWidth(tf:TextField, width:int, minSize:int, letterSpacing:Object=null):Number
		{
			//log.debug("resizeTextToFitWidth tf.width=" + tf.width);
			var tempFormat:TextFormat = tf.getTextFormat();
			var tSize:int = tempFormat.size as int;
			if (tf.width > width)
			{
				if (letterSpacing) tempFormat.letterSpacing = letterSpacing as Number;
				while (tf.width>width)
				{
					tempFormat.size =--tSize;
					tf.setTextFormat(tempFormat);
					log.debug("resizeTextToFitWidth reducing size to "+tSize);
					if (tSize == minSize) break;
				}
			}
			return tSize;
		}
		
		/**
		 * Perform a "fuzzy" search on a string
		 * @param	textToCheck String to search
		 * @param	str String to match
		 * @return True if the strings "match"
		 */
		public static function fuzzySearch(textToCheck:String, str:String, strict:Boolean=true):Boolean
		{
			var i:int;
			str = str.toLocaleLowerCase();
			str = str.replace(/[^\w\u0400-\u0460\s]*/g, "");
			var string:String = textToCheck.toLocaleLowerCase();
			if (str == "")
			{
				return false;
			}
			var pattern:String = "";
			for (i = 0; i < str.length; i++)
				pattern += str.charAt(i) + ((strict)?"":".*");
				
			log.debug("fuzzySearch pattern=" + pattern);
			var regexp:RegExp = new RegExp(pattern, "g")
			var p:int = string.search(regexp);
			if (p >= 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Remove HTML tag characters from the given string
		 * @param	value String containing text
		 * @return The inputted string with HTML chars removed
		 */
		public static function stripHTML(value:String):String
		{
			return value.replace(/<.*?>/g, "");
		}
		
		/**
		 * Sets the letterSpacing of the requested TextField's TextFormat
		 * @param	tf TextField to apply the letterSpacing to
		 * @param	letterSpacing The amount of letterSpacing
		 */
		public static function setLetterSpacing(tf:TextField, letterSpacing:Number):void
		{
			var tFormat:TextFormat = tf.getTextFormat();
			tFormat.letterSpacing = letterSpacing;
			tf.setTextFormat(tFormat);
			tf.defaultTextFormat = tFormat;
		}
		
		/**
		 * Sets the text of a dynamic TextField and reapplies the TextFormatting
		 * This preserves properties like letterSpacing
		 * @param	textField The textfield to set the text of
		 * @param	newText The string to use as the new text
		 */
		public static function setText(textField:TextField, newText:String):void
		{
			var tFormat:TextFormat = textField.getTextFormat();
			textField.text = newText;
			
			//re-apply formatting
			textField.setTextFormat(tFormat);
			textField.defaultTextFormat = tFormat;
		}
		
		public static function underlineText(textField:TextField):void
		{
			var tFormat:TextFormat = textField.getTextFormat();
			tFormat.underline = true;
			
			//re-apply formatting
			textField.setTextFormat(tFormat);
			textField.defaultTextFormat = tFormat;
		}
		
		public static function stringContains(str:String, searchStrings:Array):Boolean
		{
			var n:int = searchStrings.length;
			for (var i:int = 0; i < n; i++)
			{
				if (str.indexOf(searchStrings[i]) >= 0) return true;
			}
			return false;
		}
		
		public static function cloneTextFormat(srcFormat:TextFormat):TextFormat
		{
			var rawObj:Object = Util.getDuplicateObject(srcFormat);
			var tf:TextFormat = new TextFormat();
			for (var prop:String in rawObj)
			{
				tf[prop] = rawObj[prop];
			}
			return tf;
		}
	}

}