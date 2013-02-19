package com.halcyon.util.utilities
{
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.localization.Babelfish;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.describeType;

	/*
	 * Class that contains links to different usefull places and can build them out with the proper
	 * site or san base
	 */
	public class ClientUrls
	{
		private static var log:Logger = LogFactory.getLog("ClientUrls", Logger.DEBUG);

		//Singleton instance
		private static var inst:ClientUrls;

		public static const USER_TILE_GROUP:String = "new_client/cs3/userTile/group-avatar.png";

		//Asset Icon
		public static const ASSET_ICON_LIB:String = "services/client/assetIcon"; // /assetId/
		//Merge Cursor
		public static var MERGE_CURSOR:String = "new_client/cs3/interface/mergeCursors.swf";

		//Avatar list
		public static const AVATAR_SHORT_LIST:String						= "assets/xml_list?type=4";
		//Emoticon List
		public static const INVENTORY_EMOTICON_LIST:String				= "assets/xml_list?type=6";
		//Emoticon file
		public static const EMOTICON_LIB:String							= "services/client/emoticonLib";


		//API STuff
		public static const API_USER_REALMS:String = "services/api/user_realms";//?screen_name=nikki
		public static const API_REALM_SEARCH:String = "services/api/realms"; //q=vlad
		public static const API_USER:String = "services/api/users";
		public static const API_USER_FEED:String = "services/api/user_feed";
		public static const API_GROUP_FEED:String = "services/api/groups_feed"; //groupid
		public static const API_GROUP:String = "services/api/groups"; //?user_ids=num
		public static const API_COMBINED_SEARCH:String = "services/api/search";
		public static const API_ACCOUNT_REALMS:String = "services/api/account_realms";
		public static const API_USER_REALM_FEEDS:String = "services/api/realms_feed";

		//Configurable links
		public static var ACCOUNT_EDIT_PAGE:String = "http://imeetdemo.meetinghub.com"
		public static var LIVE_CHAT_HELP:String = "http://chatsupport.imeet.com/Chat/servlet/AppMain?__lFILE=iMeetChatForm.jsp";
		public static var GUIDE_HELP:String = "help/iMeet_User_Guide.htm"
		public static var GUIDE_WEB_HELP:String = "/webhelp/iMeet_User_Guide.htm"
		public static var FORGOT_PASSWORD:String = "";

		/***************************************************************************************************************************
		 * ALL iMeet 2.0 URLs should go below here!!!!!!!!
		 **************************************************************************************************************************/

		//Users
		public static const USER_IMAGE:String								= "services/client/userImage";
		public static const USER_IMAGE_DELETE:String						= "services/users/deleteUserImage";
		public static const USER_IMAGE_LIST:String							= "services/users/userImages";
		public static const USER_IMAGE_SELECT:String						= "services/users/selectUserImage";
		public static const USER_HOME_PAGE:String = "people/home/";


		// PROXY
		private static const PROXY:String									= "services/client/url";						// DONE: TESTED


		//Client Config XML Location
		/**THIS IS A VAR FOR A REASON! LIVE SERVERS USE A DIFFERENT CONFIG LOCATION BUT USE THE SAME
		 * LOGIN PROCESS
		 */
		public static var CLIENT_CONFIG:String = "services/client/config";
		public static const CLIENT_WEB_SCREENSHOT:String = "services/client/capture_web_screenshot";
		public static const CLIENT_WEB_GET_URL_STATUS:String = "services/client/url_status";


		public static const SKIN_SWF:String = "new_client/swflib/interface/skin.swf";
		public static const SKIN_SLIDING_MENU_SWF:String = "new_client/swflib/interface/skinExperiment.swf";
		public static const WEATHER_DISPLAY_SWF:String = "new_client/swflib/weather/weather.swf";
		public static const RIGHT_MENU_SWF:String = "new_client/swflib/interface/rightMenu.swf";
		public static const SILVER_NAVIGATOR_SWF:String = "new_client/swflib/interface/silverNavigator.swf";
		public static const BANDWIDTH_SWF:String = "new_client/swflib/interface/bandwidth.swf";

		public static const FILESHARE_HELP_TIP_SWF:String = "new_client/swflib/help/tipPanel.swf";

		//Webcam
		public static const WEBCAM_CONFIG:String						= "assets/tilecam";
		public static const WEBCAM_RED5_SERVER_URL:String = "rtmp://66.240.205.155/imeet";

		//CubePanels
		public static const EXTRA_LARGE_CUBE_TILE_SWF:String = "new_client/swflib/cubes/cubeExtraLarge.swf";
		public static const LARGE_CUBE_TILE_SWF:String = "new_client/swflib/cubes/cubeLarge.swf";
		public static const MEDIUM_CUBE_TILE_SWF:String = "new_client/swflib/cubes/cubeMedium.swf";
		public static const SMALL_CUBE_TILE_SWF:String = "new_client/swflib/cubes/cubeSmall.swf";
		public static const PRESENTATION_SHADOW_SWF:String = "new_client/swflib/show/presentationShadow.swf";
		public static const PRESENTATION_FULLSTAGE_SWF:String = "new_client/swflib/show/show_fullViewer.swf";
		public static const CUBE_SHADOW_SWF:String = "new_client/swflib/cubes/cubeShadow.swf";
		public static const TILE_PANELS_SWF:String = "new_client/swflib/cubes/panels.swf";
		public static const CHAT_PANEL_SWF:String = "new_client/swflib/chat/chat.swf";
		public static const CHAT_DING_MP3:String = "new_client/swflib/chat/chatDing.mp3";
		public static const NOTES_PANEL_SWF:String = "new_client/swflib/notes/notes.swf";
		public static const EMAIL_NOTES_PANEL_SWF:String = "new_client/swflib/notes/emailNotes.swf";
		public static const BREAKOUT_PANEL_SWF:String = "new_client/swflib/breakout/breakout.swf";
		public static const LOGIN_SWF:String = "new_client/swflib/login/login.swf";
		public static const LOGIN_PASSWORD_SWF:String = "new_client/swflib/login/roomKey.swf";
		public static const GUEST_SETUP_SWF:String = "new_client/swflib/login/guestLogin.swf";
		
		//for new menu UI - invite panel is now 3 separate panels
		public static const CALL_GUEST_WINDOW:String = "new_client/swflib/invite/callAGuest.swf";
		public static const EMAIL_GUEST_WINDOW:String = "new_client/swflib/invite/sendInvite.swf";
		public static const MY_CONTACTS_WINDOW:String = "new_client/swflib/invite/myContacts.swf";
		
		public static const INVITE_WINDOW:String = "new_client/swflib/invite/inviteGuests.swf";
		public static const MERGE_WINDOW:String = "new_client/swflib/merge/mergeDialog.swf";

		//Fileshare
		public static const FILESHARE_FULLSCREEN_SWF:String = "new_client/swflib/show/show_fullViewer.swf";
		public static const FILESHARE_WINDOW:String = "new_client/swflib/files/files.swf";
		public static const FILESHARE_ADD_WEB_WINDOW:String = "new_client/swflib/files/addWeb.swf";
		public static const USER_TILE_DEFAULT:String = "new_client/swflib/userTile/default-avatar.png";
		public static const USER_TILE_DEFAULT_CUBE:String = "new_client/swflib/userTile/defaultImage.swf";
		public static const EMAIL_INVITE_PANEL:String = "new_client/swflib/invite/inviteEmail.swf";
		//All Apps window
		public static const ALL_APPS_WINDOW:String = "new_client/swflib/apps/all_apps.swf";

		//Dock Manager application icon
		public static const DOCK_ICON:String = "new_client/swflib/apps/dockIcon.swf";

		//SWF For ProfileEditor
		public static const PROFILE_EDITOR_SWF:String = "new_client/swflib/profile/profile.swf";
		public static const SAVE_PROFILE_SWF:String = "new_client/swflib/profile/saveProfile.swf";

		// SWF for Photo Editor
		public static const EDIT_PHOTO_DIALOG:String = "new_client/swflib/profile/editPhoto.swf";

		//ALERT WINDOW
		public static const ALERT_WINDOW:String = "new_client/swflib/alert/alert.swf";
		//Timeout window
		public static const TIMEOUT_WINDOW:String = "new_client/swflib/alert/timeout.swf";

		//DISMISS WINDOW
		public static const DISMISS_PANEL:String = "new_client/swflib/dismiss/dismiss.swf";

		//SWF For Merge Confirmation
		public static const MERGE_PANEL:String = "new_client/swflib/merge/merge.swf";

		//END MEETING WINDOW
		public static const END_MEETING_MESSAGE:String = "new_client/swflib/exit/end.swf";
		public static const END_MEETING_MESSAGE_GUEST:String = "new_client/swflib/exit/end_guest.swf";
		public static const END_MEETING_MESSAGE_GUEST_BOOTED:String = "new_client/swflib/exit/guest_booted.swf";
		public static const END_MEETING_MESSAGE_HOST_BOOTED:String = "new_client/swflib/exit/host_booted.swf";
		public static const END_MEETING_MESSAGE_GLOBAL:String = "new_client/swflib/exit/end_meeting_global.swf";

		//EXIT WINDOW
		public static const EXIT_WINDOW:String = "new_client/swflib/exit/exit.swf";

		//Font Lib
		public static const FONT_LIB:String = "new_client/swflib/lib/fonts.swf"

		//SWF For add contact panel
		public static const ADD_CONTACT_PANEL:String = "new_client/swflib/invite/contact.swf";

		//SWF For settings panel
		public static const SETTINGS_PANEL:String = "new_client/swflib/settings/settings.swf";
		public static const THEMES_LOCATION:String	= "new_client/swflib/themes/";

		//SWF For Webcam panel
		public static const WEBCAM_PANEL:String = "new_client/swflib/webcam/webcamPanel.swf";

		//SWF For take photo panel
		public static const TAKE_PHOTO_PANEL:String = "new_client/swflib/profile/takePhoto.swf";

		// Generic frame for presentations
		public static const GENERIC_PRESENTATION_FRAME:String = "new_client/swflib/show/show_generic.swf";

		// Generic frame for presentations
		public static const PRESENTATION_FRAME:String = "new_client/swflib/show/show_presentation.swf";

		// Video frame for presentations
		public static const VIDEO_PRESENTATION_FRAME:String = "new_client/swflib/show/show_video.swf";

		// Video frame for presentations
		public static const IMEET_VIDEO_PRESENTATION_FRAME:String = "new_client/swflib/show/show_imeet_video.swf";

		// Video frame for presentations
		public static const WEB_PRESENTATION_FRAME:String = "new_client/swflib/show/show_web.swf";

		//SWF For Audio Conference joining
		public static var PGICONF_PANEL:String = "new_client/swflib/audioConference/joinConference.swf";
		//new_client/cs3/panels/audioConference/joinConference.swf";

		//SWF For Audio Conference Error
		public static const PGICONFERROR_PANEL:String = "new_client/swflib/audioConference/retryConference.swf";
		//"new_client/cs3/panels/audioConference/retryConference.swf";
		//SWF For emoticon window
		public static const EMOTICONS_PANEL:String = "new_client/swflib/chat/emoticons.swf";
//		public static const EMOTICONS_PANEL:String = "new_client/cs3/panels/emoticons/emoticons.swf";

		//AppStore
		public static const APP_STORE_SWF:String = "new_client/swflib/appStore/imeet_store.swf";
		public static const APP_STORE_APP_ICON_FILE:String = "app_icon.png";
		public static const APP_STORE_APP_PREVIEW_FILE:String = "preview.swf";

		//remoting gateway
		public static const REMOTING_GATEWAY_PATH :String = "services/rubyamf/gateway";

		//Softphone
		public static var SOFTPHONE_SIP_IP:String = "216.84.140.100"; //this is the fallback sip ip
		public static var SOFTPHONE_RTMP_SERVER:String; //if this is null, will use counterpath phone instead of Red5Phone
		public static var SOFTPHONE_SIP_PHONE_DEFAULT:String = "9551428";
		public static var SOFTPHONE_USERNAME:String = "test";
		public static var SOFTPHONE_PASSWORD:String = "test";
		public static var SOFTPHONE_DOMAIN:String = "test";
		public static const SOFTPHONE_10_3:String = "new_client/swflib/audioConference/mic.swf";
		
		public static var RED5_SOFTPHONE_USERNAME:String = "1001";
		public static var RED5_SOFTPHONE_PASSWORD:String = "1001";

		//SWF for Forgot Password Window
		public static const FORGOT_PASSWORD_WINDOW:String = "new_client/swflib/login/forgotPassword.swf";

		//Duplicate email thing
		public static const DUPLICATE_EMAIL_WINDOW:String = "new_client/swflib/login/retryLogin.swf";

		//Avatar Creator
		public static const AVATAR_CREATOR:String = "new_client/swflib/profile/create_avatar.swf";
		public static const MALE_AVATAR:String = "new_client/swflib/profile/male_avatar.swf";
		public static const FEMALE_AVATAR:String = "new_client/swflib/profile/female_avatar.swf";
		public static const FEMALE_CHAT_AVATAR:String = "new_client/swflib/profile/female_avatar_thumb.swf";
		public static const MALE_CHAT_AVATAR:String = "new_client/swflib/profile/male_avatar_thumb.swf";

		//Talking Points
		public static const TALKING_POINTS_DISPLAY:String = "new_client/swflib/show/show_talking_points.swf";
		public static const TALKING_POINTS_EDITOR:String = "new_client/swflib/files/talking_points.swf";

		//Video
		public static const VIDEO_PANEL:String = "new_client/swflib/files/videos.swf";
		public static const VIDEO_PLAY_PANEL:String = "new_client/swflib/show/show_video.swf";

		//Contextual Help
		public static const CONTEXTUAL_HELP:String = "new_client/swflib/help/contextual_help.swf";

		//USERVOICE
		public static const USER_VOICE_FEEDBACK:String = "uservoice/create_message";
		public static const USER_VOICE_SUGGESTION:String = "uservoice/create_suggestion";
		public static const FEEDBACK_WINDOW:String = "new_client/swflib/interface/feedback.swf";
		
		//HELP
		public static const HELP_WINDOW:String = "new_client/swflib/help/help.swf";
		public static var HELP_LINK_COMMUNITY:String = "";
		public static var HELP_LINK_TUTORIALS:String = "";
		public static var HELP_LINK_TUTORIALS_DT:String = "http://support.telekomcloud.com/category/2/2.8";
		public static var HELP_LINK_EMAIL:String = "";
		public static var HELP_LINK_CHAT:String = "http://chatsupport.pgi.com/iMeet/servlet/AppMain?__lFILE=ChatForm.jsp";
		public static var HELP_LINK_PHONE:String = "719 325-4322";
		public static const HELP_LINK_FACEBOOK:String = "https://www.facebook.com/PgiFans";
		public static const HELP_LINK_TWITTER:String = "https://twitter.com/pgi";
		public static const HELP_LINK_SYSTEMTEST:String = "browser-check";
		public static const PREMIUM_HELP_ADDRESS:String = "support/premium_help";
		
		//DVR
		public static const DVR_PANEL:String = "new_client/swflib/dvr/startRecordingPanel.swf";
		
		//Whiteboard
		public static const WHITEBOARD_SWF:String = "new_client/swflib/interface/whiteboard.swf";
		
		//Tool Downloads
		public static const TOOL_DOWNLOADS_WINDOW:String = "new_client/swflib/login/downloadTools.swf";
		public static const MAC_ROOM_MONITOR_LOCATION:String = "downloads/iMeetRoomMonitor/RoomMonitor.dmg";
		public static const WINDOWS_TOOL_LOCATION:String = "downloads/iMeetRoomMonitor/RoomMonitorWithToolbar.exe";

		//VCard
		public static var VCARD_AUTH:String = "https://myportal.premiereglobal.com/vcard/vcard/auth";
		public static var VCARD_SERVICE:String = "services/integration/download_vcard/";

		//Email to room
		public static var EMAIL_TO_ROOM_DOMAIN:String;
		//Ruby AMF
		public static const RUBY_AMF :String = "services/rubyamf/gateway";

		//files
		public static const UPLOAD_FILE_URL:String = "services/realms/upload_file";
		public static const UPLOAD_PRESENTATION_URL:String = "convert";
		public static const UPLOAD_LIST_URL:String = "services/realms/files";
		public static const UPLOAD_URL:String = "services/realms/upload_url";
		public static const DELETE_FILE_URL:String = "services/realms/delete_file";
		public static const USERS_UPLOAD_IMAGE:String= "services/users/uploadUserImage";
		public static const USERS_UPLOAD_AVATAR_IMAGE:String = "services/users/uploadAvatarImage";

		// New chat actions
		public static const SAVE_CHAT_ACTIONS:String = "services/integration/save_chat?";
		public static const EMAIL_CHAT_ACTIONS:String = "services/integration/email_chat?";
		public static const VIEW_CHAT_ACTIONS:String = "services/integration/view_chat?";

		// New note actions
		public static const SAVE_NOTE_ACTIONS:String = "services/integration/save_note?";
		public static const EMAIL_NOTE_ACTIONS:String = "services/integration/email_note?";
		public static const EVER_NOTE_SERVICE:String = "services/integration/send_evernote?";
		public static const EVER_NOTE_LIST:String = "https://pgiapi.imeetbeta.net/evernote/onlyNotelist";
		
		//View Lib
		public static const VIEW_LIB:String = "services/client/viewLib";
		//View Icon
		public static const VIEW_ICON:String = "services/client/viewIcon";

		//App Lib
		public static const APP_LIB:String = "services/client/appLib"; // /id
		//App Icon
		public static const APP_ICON:String = "services/client/appIcon"; // /id

		public static const THEME_LIB:String = "services/client/themeLib";
		public static const THEME_THUMB:String = "services/client/themeThumb";
		public static const THEME_PREVIEW:String = "services/client/themeLarge";
		
		//Trial Expired Window
		public static const TRIAL_EXPIRED_PANEL:String = "new_client/swflib/alert/trialExpired.swf";
		public static const OFFER_EXPIRED_SILENT_LOGIN:String = "signup/silent-login";
		public static const OFFER_EXPIRED_LINK:String = "signup/offer-expired";
		public static const OFFER_TRY_IT_FREE:String = "signup/try-now?how=try-it-free";
		
		public static const FOOTER_TERMS_URL:String  = "about/terms";
		public static const FOOTER_PGI_URL:String = "http://www.pgi.com";
		
		public static const MEETING_MINUTES_URL:String = "/meeting_minutes/meeting/";
		public static const MEETING_TRANSCRIPT_URL:String = "/meeting_minutes/transcripts/";
		
		public static const WELCOME_PANEL_SWF:String = "new_client/swflib/interface/welcomePanel.swf";
		
		
		
		public static const EMAIL_TRANSCRIPT_ACTION:String = "services/integration/email_transcript?";
		public static const EMAIL_DVR_ACTION:String = "services/integration/email_dvr_transcript?";
		
		public static const NEW_NAV_FEATURE_PAGE_URL:String = "https://community.imeet.com/thread/3074";
		
		
		//Javascript function for opening popups
		public static var FUNCTION_OPENPOPUP:String = "openPopup_link";

		public static var INSERT_FUNCTION_OPENPOPUP:String = "document.insertScript = function ()" + "{ " +
			"if (document." + ClientUrls.FUNCTION_OPENPOPUP + "==null)" +
			"{" +ClientUrls.FUNCTION_OPENPOPUP + " = function (url)" + "{" +
			"var wtop = (screen.height-550)/2;" +
			"var wleft = (screen.width-750)/2;" +
			"win_linkedin = window.open(url,'win_link','height=680,width=1024,left='+wleft+',top='+wtop+',toolbar=no,scrollbars=yes,resizable=yes');"+
			"}" + "}" + "}";

		//Should use the
		private var san:String;
		private var localSan:String;
		private var site:String;
		private var fms:String;
		private var clientVersion:Number;
		private var sessionID:String;
		private var realmUri:String;
		private var uploadUri:String;
		private var mapKey:String;
		private var cid:String;
		private var _additionalLogoPath:String;

		//Singleton instance constructor
		public static function getInstance():ClientUrls{
			if(inst == null){
				inst = new ClientUrls();
			}
			return inst;
		}

		public static function setInstance(inst:ClientUrls):void{
			ClientUrls.inst = inst;
		}

		public function ClientUrls():void
		{
			//CONFIG::imeet
			//{
				ExternalInterface.call(INSERT_FUNCTION_OPENPOPUP);
			//}
			EventManager.getInstance().addEventListener(Babelfish.EVENT_TRANSLATIONS_READY, onTranslationsUpdated);
		}
		
		private function onTranslationsUpdated(e:Event):void
		{
			this.localize();
		}
		
		
		public function localize():void
		{
			var varList:XMLList = describeType(ClientUrls)..variable;

			for (var i:int; i < varList.length(); i++)
			{
				//trace(varList[i].@name + ':' + RealmText[varList[i].@name]);
				var varName:String = varList[i].@name;
				ClientUrls[varName] = Babelfish.getInstance().getSwf(varName, ClientUrls[varName]);
			}
		}

		public function buildSanUrl(url:String):String{
			if(Util.endsWith(".swf",Util.trimText(url.toLowerCase()))){
				return san + url;
			} else {
				return localSan + url;
			}
		}

		/**
		 * Build the full url to an address at the site
		 * @param	url address to append to the base site address
		 * @param	domainOnly If true, filter out the part of the server preceeding imeet.com (or imeetbeta.net)
		 * @return  The full url to the address on the site
		 */
		public function buildSiteUrl(url:String, domainOnly:Boolean = false):String{
			if (domainOnly)
			{
				var urlArray:Array = this.site.split(".");
				urlArray.splice(0,1);
				return "https://"+urlArray.join(".") + url;
			}
			else
				return site + url;
		}

		public function getClientVersion():Number{
			return this.clientVersion;
		}

		public function setClientVersion(clientVersion:Number):void{
			this.clientVersion = clientVersion;
		}

		public function setSan(san:String):void{
			this.san = san;
		}

		public function getSan():String{
			return this.san;
		}

		public function setSite(site:String):void{
			this.site = site;
		}

		public function setLocalSan(localSan:String):void{
			this.localSan = localSan;
		}

		public function getLocalSan():String{
			return this.localSan;
		}

		public function getSite():String{
			return this.site;
		}

		public function getFMS():String{
			return this.fms;
		}

		public function setFMS(fms:String):void{
			this.fms = fms;
		}

		public function setSessionID(id:String):void{
			this.sessionID = id;
		}

		public function getSessionID():String{
			return this.sessionID;
		}

		public function setRealmUri(realmUri:String):void{
			this.realmUri = realmUri;
		}

		public function getRealmUri():String{
			return this.realmUri;
		}

		public function setUploadUri(uploadUri:String):void{
			this.uploadUri = uploadUri;
			Security.allowDomain(this.uploadUri);
		}

		public function getUploadUri():String{
			return this.uploadUri;
		}

		public function setMapKey(mapKey:String):void{
			this.mapKey = mapKey;
		}

		public function getMapKey():String{
			return this.mapKey;
		}

		public function setCID(cid:String):void{
			this.cid = cid;
		}

		public function getCID():String{
			return this.cid;
		}
		
		public function set additionalLogoPath(value:String):void
		{
			_additionalLogoPath = value;
		}
		
		public function get additionalLogoPath():String
		{
			return _additionalLogoPath;
		}

		
		public function getRealmName():String{
			var arr:Array = this.realmUri.split("/");
			log.debug("Realm Name array length: " + arr.length);
			var s:String;
			if(arr.length > 4){
				s = arr[arr.length - 2] + "." + arr[arr.length - 1];
			} else {
			 	s = arr[arr.length - 1];
			}

			return s;
		}

		public function getDomain():String{
			var str:String = this.getRealmUri().replace("https://","");
			var arr:Array = str.split("/");
			return (arr[0] as String);
		}

		public function buildProxyUrl(url:String):String{

			var temp:String =this.san.replace("https://","");
			temp = temp.replace("http://","");
			log.debug("TEMP is: " + temp);
			var tok:Array = temp.split("/");
			var toRet:String = tok[0] + "/" + PROXY + "?url=" + url;
			if(Util.startsWith("https",this.san) && !Util.startsWith("http",toRet)){
				toRet = "https://" + toRet;
			} else if(!Util.startsWith("http",toRet)){
				toRet = "http://" + toRet;
			}
			log.debug("URL IS: " + toRet);
			return toRet;
		}

		public function buildWebBase(url:String):String{

			var temp:String =this.san.replace("https://","");
			temp = temp.replace("http://","");
			temp = temp.replace("/san/","/");
			log.debug("TEMP is: " + temp);
			var tok:Array = temp.split("/");
			var toRet:String = tok[0] + "/" + PROXY + "?url=" + url;
			if(Util.startsWith("https",this.san) && !Util.startsWith("http",toRet)){
				toRet = "https://" + toRet;
			} else if(!Util.startsWith("http",toRet)){
				toRet = "http://" + toRet;
			}
			log.debug("URL IS: " + toRet);
			return toRet;
		}

		public function openPopupUrl(url:String):void{
			ExternalInterface.call(FUNCTION_OPENPOPUP,url);
		}
		
		//this is used to enable different default properites within the client and experimental features
		public function isDevServer():Boolean {
			return(getDomain() == "dev004.imeetbeta.net");
			//return false;
		}
		
		public function isTestServer():Boolean
		{
			return (this.realmUri.indexOf("imeetbeta.net") > -1 || this.realmUri.indexOf("dt.imeet.com") > -1);
		}
	}
}
