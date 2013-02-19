   package com.halcyon.util
{
	import com.halcyon.util.localization.Babelfish;
	import flash.utils.describeType;
	// import mx.messaging.channels.StreamingAMFChannel;

	public class RealmText
	{
		//Interface tool tips
		public static var USERS_TOOL_TIP:String = "View participants in this room";
		public static var HELP_TOOL_TIP:String = "Get help using iMeet";
		public static var HOST_NAME_TOOL_TIP:String = "View the host's details";
		public static var MUTE_TOOL_TIP:String = "Mute sounds";
		public static var UNMUTE_TOOL_TIP:String = "Unmute sounds";
		public static var SETTINGS_TOOL_TIP:String = "Change settings for this room";
		public static var EMOTICON_TOOL_TIP:String = "Select an emoticon";
		public static var PROFILE_TOOL_TIP:String = "Edit your avatar";
		public static var ACTIONS_TOOL_TIP:String = "Select an action for your avatar to perform";
		public static var WINKS_TOOL_TIP:String = "Send a wink to someone in this room";
		public static var POINTER_TOOL_TIP:String = "Drag the arrow to point something out";
		public static var CHAT_WINDOW_TOOL_TIP:String = "Show chat history";
		public static var INVENTORY_TOOL_TIP:String = "Manage items in this room";
		public static var MAP_TOOL_TIP:String = "View room minimap";
		public static var NAVIGATOR_TOOL_TIP:String = "Navigate to a different room";
		public static var CHAT_MODE_TOOL_TIP:String = "Switch to chat view";
		public static var SCENE_MODE_TOOL_TIP:String = "Switch to scene view";
		public static var TOOL_MODE_TOOL_TIP:String = "Switch to tool view";
		public static var PHOTO_USER_LIST_TOOL_TIP:String = "Show participant photos";
		public static var TEXT_USER_LIST_TOOL_TIP:String = "Show list of participants";
		public static var INVITE_TOOL_TIP:String = "Invite others to your meeting";

		//User Tool Tip stuff
		public static var MUTE_USER_TOOL_TIP:String = "Mute chat from this person";
		public static var UNMUTE_USER_TOOL_TIP:String = "Unmute chat from this person";
		public static var USER_DETAIL_TOOL_TIP:String = "View this person’s details";
		public static var USER_GOTO_ROOM_TOOL_TIP:String = "Go to the selected room";

		//Dialogs
		public static var LEAVE_MEETING:String = "To get back in the iMeet room, refresh your browser. ";
		public static var LEAVE_MEETING_TITLE:String  = "MISS YOU ALREADY";
		public static var DEFAULT_SHUTDOWN:String = "The owner of the room has decided to shut it down.";
		public static var DISCONNECT_TITLE:String = "TIMEOUT";
		public static var DISCONNECT_MESSAGE:String = "Nothing was happening so we cut your connection. Hit refresh or just close this window.";
		public static var DISMISS_DIALOG_TITLE:String = "SHOW THEM THE DOOR ";
		public static var DISMISS_DIALOG:String = "Sure you want to dismiss ";
		public static var MERGE_TITLE:String = "MERGE AHEAD";
		public static var MERGE_MESSAGE:String = "Sure you want to merge ";
		public static var UNMERGE_TITLE:String = "THEY DON'T BELONG TOGETHER";
		public static var UNMERGE_MESSAGE:String = "Sure you want to unmerge ";
		public static var DISMISS_GUEST_TITLE:String = "SOMETHING YOU SAID?";
		public static var DISMISS_GUEST_MESSAGE:String = "The host has dismissed you from the meeting room.";
		public static var ROOM_LOCKED_TITLE:String = "IT'S NOTHING PERSONAL";
		public static var ROOM_LOCKED_MESSAGE:String = "The host has locked this meeting room.";
		public static var ROOM_LOCKED_HOST_TITLE:String = "AUDIO STILL UNLOCKED";
		public static var ROOM_LOCKED_HOST_MESSAGE:String = "Your room is locked. If you want to lock the audio part, you need to get your own audio going first. (Just click Connect.)";
		public static var ROOM_FULL_TITLE:String = "NO CHAIRS TO SPARE";
		public static var ROOM_FULL_MESSAGE:String = "Sorry, this meeting room is full.";
		public static var ROOM_FULL_HOST_TITLE:String = "ROOM FULL";
		public static var ROOM_FULL_HOST_MESSAGE:String = "Sorry, you can't have more than 15 guests.";
		public static var WEBCAM_FMS_ERROR_TITLE:String = "WEBCAM TIMEOUT";
		public static var WEBCAM_FMS_ERROR_MESSAGE:String = "We're having Webcam issues right now. Please try again later.";
		public static var WEBCAM_CAP_TITLE:String = "WEBCAM MANIA";
		public static var WEBCAM_CAP_BODY:String = "The max number of people are iMeeting in video. Please try again later.";
		public static var WEBCAM_NOT_DETECTED:String = "You'd look great on webcam, but we don't detect one on your computer.";
		public static var ALREADY_CONNECTING_AUDIO_TITLE:String = "WE'RE ON IT";
		public static var ALREADY_CONNECTING_AUDIO_TEXT:String = "iMeet is already trying to connect your audio, so please give us a sec.";
		public static var DIALOUT_DISSALLOWED_TITLE:String = "DIAL IN ONLY";
		public static var DIALOUT_DISSALLOWED_BODY:String = 'Your iMeet host turned off "Call My Phone", so please dial-in old school at: ';
		public static var DIALOUT_DISSALLOWED_BODY2:String = " passcode: ";
		public static var AUTO_LOGIN_TITLE:String = "HOLD TIGHT";
		public static var AUTO_LOGIN_BODY:String = "You fell off there for a second. We're getting you back in, pronto.";
		public static var USER_BOOTED_TITLE:String = "WHICH IS THE REAL YOU?";
		public static var USER_BOOTED_BODY:String = "Sorry. iMeet had to log you out because you were both here and in a different, faraway room.";
		public static var USER_NOT_CONFIRMED_TITLE:String = "WHO GOES THERE";
		public static var USER_NOT_CONFIRMED_BODY:String = "Before you iMeet again, you need to confirm your email address. Please click the link in the confirmation email we sent you.";
		public static var ENTER_PASSWORD_TITLE:String = "Enter Password";
		public static var ENTER_PASSWORD_BODY:String = "Enter your password to complete this request.";

		//Loader text
		public static var CONNECTING:String = "We\'re dusting your cube…";
		public static var CONNECTION_ESTABLISHED:String = "The sweetest meeting ever, coming up…";
		public static var CREATING_ROOM:String = "We\'re warming up the room for you…";
		public static var ENTERING_ROOM:String = "Get ready to be iMeet-a-fied…";
		public static var CREATING_DISPLAY:String = "Take this time to fix your hair…";
		public static var LOADING_SKIN:String = "Give us a sec to turn on the lights…";

		//File status messages
		public static var FILE_SHARE_CLEAR_ALL_FILES_ALERT_TITLE:String = "CLEAR ALL FILES?";
		public static var FILE_SHARE_CLEAR_ALL_FILES_ALERT_BODY:String = "Sure you want to clear all your files?";
		public static var FILE_SHARE_CLEAR_ALL_LINKS_ALERT_TITLE:String = "CLEAR ALL WEB PAGES?";
		public static var FILE_SHARE_CLEAR_ALL_LINKS_ALERT_BODY:String = "Sure you want to clear all your web pages?";
		public static var FILE_SHARE_UPLOADING:String = "Grabbing your doc";
		public static var FILE_SHARE_CONVERTING_NUM:String = "iMeet-a-fying page {slidenumber}";
		public static var FILE_SHARE_CONVERTING_NO_NUM:String = "iMeet-a-fying";
		public static var FILE_SHARE_DELETING:String = "Deleting your file";
		public static var FILE_SHARE_QUEUED:String = "{filename} is on deck";
		public static var FILE_SHARE_LOADING:String = "{filename} is loading";
		public static var FILE_SHARE_NO_PERMISSION:String = "Sorry. Guests do not have permission to view files.";
		public static var BAD_FILENAME_TITLE:String = "SHADY CHARACTERS";
		public static var BAD_FILENAME_MESSAGE:String = "This file name isn't iMeet friendly. Please rename and upload again.";
		public static var FILE_UPLOAD_ERROR_TITLE:String = "UPLOAD HICCUP";
		public static var FILE_UPLOAD_ERROR_MESSAGE:String = "Sorry, we had trouble uploading your file.";
		public static var YOUTUBE_ADD_NOTICE:String = " video(s) added. Grab another or click Done.";
		public static var YOUTUBE_NO_ACCESS:String = "Your company does't allow YouTube searches. (Our sympathies.) Please speak with your system administrator.";
		public static var YOUTUBE_NO_RESULT:String = "0 results found.";
		public static var FILE_WEBSEARCH_NO_RESULT:String = "0 results found.";
		public static var FILE_SIZE_FULL_TITLE:String = "NEED SOME SPACE";
		public static var FILE_SIZE_FULL_BODY:String = "You hit your file storage limit. Please remove files to make room.";
		public static var FILE_SIZE_LOADING_TITLE:String = "Loading file size.";
		public static var FILE_SIZE_LOADING_BODY:String = "We are getting your storage size, please wait few seconds and try again.";
		public static var FILE_UPLOAD_SIZE_EXCEEDED_TITLE:String = "The file upload failed";
		public static var FILE_UPLOAD_SIZE_EXCEEDED_BODY:String = "The maximum file size is currently 30MB.";
		public static var FILE_UPLOAD_SIZE_EXCEEDED_VIDEO_TITLE:String = "The video upload failed";
		public static var FILE_UPLOAD_SIZE_EXCEEDED_VIDEO_BODY:String = "Videos larger than 20MB can be added to your room using YouTube. " +
			"First upload your movie to YouTube then in iMeet click Add Videos. From there you can search for your movie name or enter the direct link.";
		public static var PHOTO_LOAD_ERROR_MESSAGE:String = "Sorry, we had trouble loading your photo. Please try again.";
		public static var PHOTO_FLASH_SIZE_EXCEEDED_ERROR_MESSAGE:String = "Oops. {filename} is too big. Try a smaller photo.";
		public static var CROPPED_PHOTO_UPLOAD_SIZE_EXCEEDED_ERROR_MESSAGE:String = "Oops. Cropped {filename} is too big. Try a smaller photo.";

		/*
		You’ve been invited to get together at iMeet. To enter your host’s meeting room, click their personal iMeet address  www.imeet.com/nina.

Come on in, and iMeet will ring your phone like magic.
No computer? Then dial-in old school.

1-877-555-9730
Audio Key: 246534
*/

		//Other text
		public static var INVITE_INVALID_EMAIL:String = "Invalid Email."
		public static var INVITE_SUBJECT:String = "Join me in iMeet "
		public static var INVITE_MESSAGE0:String = "You've been invited to get together at iMeet."
		public static var INVITE_MESSAGE:String = "To enter your host's meeting room, click their personal iMeet address ";
		public static var INVITE_MESSAGE_PASSCODE:String = "Room Key: ";
		public static var INVITE_MESSAGE2:String = "Come on in, and iMeet will ring your phone like magic.%0dNo computer? Then dial-in old school.%0d";
		public static var INVITE_MESSAGE3:String ="%0d";
		public static var INVITE_MESSAGE4:String = "%0dAudio Key: ";
		public static var INVITE_MESSAGE5:String = "%0d%0dMobile Phone: ";
		public static var INVITE_MESSAGE6:String = "%0d%0dReady to see everyone, learn more about them and always know who’s talking? Great things happen when we’re all in the same room.";
		public static var INVITE_MESSAGE7:String = "";
		//public static var INVITE_MESSAGE3:String = "Mobile One-Click: 719-955-9052x993882#";

		public static var BIO_DEFAULT:String = "Give your bio some beef. \r \r" +
				"You went to Harvard. You live in St. Louis. You're an ace presenter. That's great and all, but we know there's more to your story. No pressure, but here are some thought starters to get you going.\r \r" +
				"Strange hobbies or interests? It's cool that you collect kites. Or at least we think so.\r \r" +
				"What scares you the most? Be it spiders or the IRS, fellow iMeeters can sympathize.\r \r" +
				"If you could travel anywhere, where would it be? Thailand? Italy? Delaware?\r \r" +
				"Favorite movie quotes? Or feel free to drop a beloved Seinfeld episode on us.";
		public static var BIO_VIEW_DEFAULT:String = "Hi. I haven't written my bio yet. (Been busy in meetings.) But when I do, you'll learn all sorts of wonderful and impressive things about me.";

		public static var SOFTPHONE_STATUS_CONNCTING:String = "Connecting...";
		public static var SOFTPHONE_STATUS_PASSCODE:String = "Checking passcode...";
		public static var SOFTPHONE_STATUS:String = "Calling computer";

		public static var PREPARING_TO_DIAL:String = "Preparing to Dial...";
		public static var AUTOLOCATE_PREFIX:String = "You are at or near "
		public static var AUTOLOCATE_NOTIFICATION:String = "Autolocating based on IP";
		//password text
		public static var PASSWORD_TOO_SHORT:String = "Whoops. Your password is too short.";
		public static var INVALID_PASSWORD_CONFIRMATION:String = "Whoops. Your passwords don't match.";
		public static var INVALID_PASSWORD:String = "Whoops. Wrong password.";
		public static var PASSWORD_FIELD_EMPTY:String = "Whoops. Just need your password.";


		//INTERNATIONAL DIALING
		public static var NO_HOST_INTERNATIONAL_DIAL_ALERT_BODY:String = "You cannot dial an international number until the Host has entered the room. Please try to dial again after the Host arrives or talk in the room using your computer (Click Menu, Connect, Call Computer).";
		public static var NO_HOST_INTERNATIONAL_DIAL_ALERT_TITLE:String = "Host has not arrived yet";
		
		//SCREENSHARE
		public static var SCREENSHARE_PAUSE_NOTIFICATION_BODY:String = "<font size='13'><b>The host's screen is currently in 'sleep' mode.</b></font>"
		public static var SCREENSHARE_PAUSE_NOTIFICATION_TITLE:String = "<font size='13'><b>Screen Sharing</b></font>"
		public static var SCREENSHARE_START_NOTIFICATION_BODY:String = "<font size='13'><b>{fname}'s screen is now being shared with the room.</b></font>"
		public static var SCREENSHARE_START_NOTIFICATION_BODY_HOST:String = "<font size='13'><b>Your screen is now being shared with the room.</b></font>"
		public static var SCREENSHARE_START_NOTIFICATION_TITLE:String = "<font size='13'><b>Screen Sharing</b></font>"
		public static var SCREENSHARE_STOP_NOTIFICATION_BODY_HOST:String = "<font size='13'><b>Your screen is no longer being shared with the room.</b></font>"
		public static var SCREENSHARE_STOP_NOTIFICATION_TITLE:String = "<font size='13'><b>Screen Sharing</b></font>"
		public static var ROOMKEY_NOTEXIST_ERROR_TITLE:String = "iMeet for Desktop";
		public static var ROOMKEY_NOTEXIST_ERROR_BODY:String = "iMeet Screen Share is powered by the latest version of iMeet for Desktop. Install now.";
		public static var SCREENSHARE_INTERRUPT_TITLE:String = "YOU ARE CURRENTLY SHARING YOUR SCREEN";
		public static var SCREENSHARE_INTERRUPT_BODY:String = "Would you like to stop sharing your screen, and present this file in iMeet?";
		
		//PREMIUM SUPPORT
		public static var PREMIUM_SUPPORT_CALL_FIRSTNAME:String = "iMeet";
		public static var PREMIUM_SUPPORT_CALL_LASTTNAME:String = "Help";
		
		//NETWORK ERROR
		public static var NETWORK_ERROR_TITLE:String = "NETWORK ERROR";
		public static var NETWORK_ERROR_BODY:String = "iMeet appears to have lost its connection to the internet. Please check your network connection and enter the room again.";
		
		public function RealmText() {
		}
		
		public static function localize():void
		{
			var varList:XMLList = describeType(RealmText)..variable;

			for (var i:int; i < varList.length(); i++)
			{
				//trace(varList[i].@name + ':' + RealmText[varList[i].@name]);
				var varName:String = varList[i].@name;
				RealmText[varName] = Babelfish.getInstance().getText("RealmText", varName, RealmText[varName]);
			}
		}

	}
}