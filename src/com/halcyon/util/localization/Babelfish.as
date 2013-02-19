package com.halcyon.util.localization
{
	import com.halcyon.util.RealmText;
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.HalcyonEvent;
	import com.halcyon.util.utilities.ClientUrls;
	import com.halcyon.util.utilities.LogFactory;
	import com.halcyon.util.utilities.Logger;
	import com.halcyon.util.utilities.RootStage;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * Class that handles the loading and retrieving of localized text
	 * for the iMeet client
	 * @author JCC
	 */
	public class Babelfish
	{
		private static var _LOG:Logger = LogFactory.getLog("Babelfish",Logger.DEBUG);

		public static const EVENT_TRANSLATIONS_READY:String = "translationsReady";
		public static const EVENT_TRANSLATIONS_FAILED:String = "translationsFailed";
		
		private static const TOKEN_LIST:Array = ["#hostFirstName"]
		
		public static const GERMAN:String = "de";
		public static const ENGLISH:String = "en-us";
		
		public static const LANG_LIST:Array = ["en-us", "de"];
		
		private static var _INSTANCE:Babelfish;
		private static var _ALLOW_INSTANTIATION:Boolean = false;
		private static const _DEFAULT_LANG:String = "en-us";
		
		public static const TEXTFIELD_PREFIX:String = "lang_";
		public static const TEXTFIELD_COMMON_PREFIX:String = "common_";
		
		
		private var _text:Object = {};
		private var _ready:Boolean = false;
		private var _loadNextLang:String = "";
		private var _currentLang:String;// = _DEFAULT_LANG;
		private var _hostLang:String = _DEFAULT_LANG;
		private var _letterSpacingFactor:Number = 1.0;
		private var _swf:Object;
		private var _loginCookie:SharedObject;
		
		private var _enabled:Boolean = false;
		
		
		
		public function Babelfish()
		{
			if (!_ALLOW_INSTANTIATION) throw new Error("Babelfish is a singleton!  Use Babelfish.getInstance()");
			_loginCookie = SharedObject.getLocal("LoginInfo","/");
		}
		
		/**
		 *
		 * @param	lang
		 */
		public function loadLang(lang:String):void
		{
			if (lang == _currentLang) return;
			
			_ready = false;
			
			if (lang != _DEFAULT_LANG && _loadNextLang == "")
			{
				_loadNextLang = lang;
				lang = _DEFAULT_LANG;
			} else
			{
				_loadNextLang = "";
			}
			var langLoader:URLLoader = new URLLoader();
			langLoader.addEventListener(Event.COMPLETE, onLangLoadComplete);
			langLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			var xmlPath:String = ClientUrls.getInstance().buildSanUrl("new_client/lang/" + lang + "/lang.xml?cacheBuster="+(new Date().time));
			langLoader.load(new URLRequest(xmlPath));
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			_LOG.error("Language file not loaded: ");
			var evt:HalcyonEvent = new HalcyonEvent(EVENT_TRANSLATIONS_FAILED);
			EventManager.getInstance().dispatchEvent(evt);
		}
		
		private function onLangLoadComplete(e:Event):void
		{
			var langLoader:URLLoader = (e.target as URLLoader);
			langLoader.removeEventListener(Event.COMPLETE, onLangLoadComplete);

			var langXML:XML = new XML(langLoader.data);
			
			parseLang(langXML);
		}
		
		private function parseLang(langXML:XML):void
		{
			var sections:XMLList = langXML.section;
			for each (var section:XML in sections)
			{
				var sectionName:String = section.@name;
				var keys:XMLList = section.key;
				if (!_text[sectionName]) _text[sectionName] = { };
				var key:XML;
				for each (key in keys)
				{
					_text[sectionName][key.@name] = key.toString();
				}
			}
			
			_swf = { };
			for each (var item:XML in langXML..swf)
			{
				_swf[item.@name] = item.toString();
			}
			
			if (_loadNextLang != "")
			{
				loadLang(_loadNextLang);
			} else
			{
				_ready = true;
				_currentLang = langXML.@lang;
				_loginCookie.data.lang = _currentLang;
				_loginCookie.flush();
				_letterSpacingFactor = ((langXML.@letterSpacingFactor as XMLList).length()>0 && langXML.@letterSpacingFactor != "")?parseFloat(langXML.@letterSpacingFactor):1.0;
				
				RealmText.localize();
				ClientUrls.getInstance().localize();
				
				var evt:HalcyonEvent = new HalcyonEvent(EVENT_TRANSLATIONS_READY);
				EventManager.getInstance().dispatchEvent(evt);
				_LOG.debug("language files loaded: " + _currentLang);
			}
			langXML = null;
			sections = null;
		}
		
		/**
		 * Get a localized piece of text, given the section and key
		 * @param	section The section of the localization document
		 * @param	key The key for the individual localization element
		 * @param   defaultText Optional text to return if the key is not found
		 * @return The localized text string, or a string containg the section and key if
		 * the key doesn't exist
		 */
		public function getText(section:String, key:String, defaultText:String=null, tokenVal:String = null):String
		{
			if (!_ready && defaultText != null) return defaultText;
			
			var retVal:String = "" + section + "_" + key;
			var found:Boolean = false;
			try
			{
				retVal = _text[section][key];
				found = (retVal != null);
				//if (found) retVal = swapTokens(retVal);
				
				if (found) {
					retVal = scanTokens(retVal);
					if (tokenVal != null) {
						retVal = swapToken(retVal, tokenVal);
					}
				}
			} catch (e:Error) { retVal = "" + section + "_" + key; }
			finally
			{
				if (!retVal) retVal = "" + section + "_" + key;
			}
			if (retVal === "~EMPTY~") retVal = "";
			return (!found && defaultText != null)?defaultText:retVal;
		}
		
		
		
		
		private function scanTokens(inputText:String):String
		{
			for (var i:int = 0; i < TOKEN_LIST.length; i++) {
				var token:String = TOKEN_LIST[i];
				while (inputText.search(token) != -1) {
					inputText = inputText.replace(token, getTokenVal(i));
				}
			}
			return inputText;
		}
		
		private function getTokenVal(token:int):String
		{
			switch(token) {
				case 0: //TOKEN_LIST[0] is #hostFirstName
					return RootStage.getInstance().getStage().loaderInfo.parameters.host_name.split(' ')[0];
			}
			return "tokenFailed";
		}
		
		
		
		
		/**
		 * Swaps tokens when the replacement text is passed into getText. 
		 * This is for guest specific values that aren't consistent, so the token is just #token
		 * @param	inputText 	text to be scanned
		 * @param	tokenVal 	text to be inserted
		 * @return 	the updated text
		 */
		public function swapToken(inputText:String, tokenVal:String):String 
		{
			while (inputText.search("#token") != -1) {
				inputText = inputText.replace("#token", tokenVal);
			}
			return inputText;
		}
		
		/**
		 * Get udpated SWF location if it is specified in the language file
		 * @param	key static variable name from ClientUrls
		 * @param	defaultUrl The current path to the swf
		 * @return The updated swf url if needed, or the default url if not
		 */
		public function getSwf(key:String, defaultUrl:String):String
		{
			var retVal:String = defaultUrl;
			var found:Boolean = false;
			try
			{
				if (_swf[key] != null)
				{
					retVal = defaultUrl.replace("/swflib/", "/swflib_alt/");
					found = true;
				}
			} catch (e:Error) { retVal = defaultUrl; }
			finally
			{
				if (!retVal) retVal = defaultUrl;
			}
			return (!found && defaultUrl != null)?defaultUrl:retVal;
		}
		
		
		/**
		 * Returns the instance of the Babelfish Singleton
		 * @return
		 */
		public static function getInstance():Babelfish
		{
			if (!_INSTANCE)
			{
				_ALLOW_INSTANTIATION = true;
				_INSTANCE = new Babelfish();
				_ALLOW_INSTANTIATION = false;
			}
			return _INSTANCE;
		}
		
		/**
		 * Returns the readiness of the loaded translations
		 */
		public function get ready():Boolean
		{
			return _ready;
		}

		/**
		 * Iterate through all TextFields of a MovieClip and the
		 * MovieClips children to find/update TextFields marked for
		 * translation.
		 * @param	parentMC The parent MovieClip to localize
		 * @param	section The translation section to use for the localization
		 */
		public function localizeMovieClip(parentMC:DisplayObjectContainer, section:String):void
		{
			if (!_ready) return;
			var startIdx:int = parentMC.numChildren - 1;
			var key:String;
			for(var i:int = startIdx; i >= 0 ; i--  )
			{
				var dispObj:DisplayObject = parentMC.getChildAt(i);
				var tFormat:TextFormat;
				var split:Array;
				var isUpper:Boolean = (dispObj.name.indexOf("u_") != -1)? true : false;
				
				if(dispObj is TextField)
				{
					tFormat = (dispObj as TextField).getTextFormat();
					if (dispObj.name.indexOf(Babelfish.TEXTFIELD_PREFIX) != -1)
					{
						split = dispObj.name.split(Babelfish.TEXTFIELD_PREFIX);
						key = split[split.length-1];
						(dispObj as TextField).text = (isUpper)? this.getText(section, key).toUpperCase() : this.getText(section, key);
						
					} else if (dispObj.name.indexOf(Babelfish.TEXTFIELD_COMMON_PREFIX) != -1)
					{
						split = dispObj.name.split(Babelfish.TEXTFIELD_COMMON_PREFIX);
						key = split[split.length-1];
						(dispObj as TextField).text = (isUpper)? this.getText("common", key).toUpperCase() : this.getText("common", key);
					}
					//re-apply formatting
					tFormat.letterSpacing = (tFormat.letterSpacing as Number) * _letterSpacingFactor;
					(dispObj as TextField).setTextFormat(tFormat);
					(dispObj as TextField).defaultTextFormat = tFormat;
				}
				
				if (dispObj is DisplayObjectContainer)
					try
					{
						this.localizeMovieClip(dispObj as DisplayObjectContainer, section);
					} catch (e:SecurityError) { /* ignore security errors */ }
			}
			
		}
		
		public function sendAppTrans(section:String, dictionary:Array):void {
			_text[section] = dictionary;
		}
		
		/**
		 * The currently loaded language (2 letter ISO code)
		 */
		public function get currentLang():String
		{
			return _currentLang;
		}
		
		/**
		 * The realm's host language
		 */
		public function get hostLang():String
		{
			return _hostLang;
		}
		
		public function set hostLang(value:String):void
		{
			_hostLang = value;
		}
		
		public function get letterSpacingFactor():Number
		{
			return _letterSpacingFactor;
		}
		
		/**
		 * Determines whether or not user-initiated changing of languages
		 * is enabled
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * Determines whether or not user-initiated changing of languages
		 * is enabled
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
	}

}