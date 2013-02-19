package com.halcyon.util.events 
{
	import com.halcyon.interfaces.user.IUserContact;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author JCC
	 */
	public class UserContactEvent extends HalcyonEvent 
	{
		public static const SELECT_USER_CONTACT:String = "selectUserContact";
		public static const EDIT_USER_CONTACT:String = "editUserContact";
		public static const INVITE_USER_CONTACT_PHONE:String = "inviteUserContactPhone";
		public static const INVITE_USER_CONTACT_EMAIL:String = "inviteUserContactEmail";
		public static const INVITE_USER_CONTACT_PREVIEW_EMAIL:String = "inviteUserContactPreviewEmail";
		public static const DELETE_USER_CONTACT:String = "deleteUserContact";
		public static const ADD_USER_CONTACT:String = "addUserContact";
		public static const USER_CONTACTS_UPDATED:String = "userContactsUpdated";
		public static const USER_CONTACTS_LOADED:String = "userContactsLoaded";
		public static const GO_TO_ROOM:String = "goToRoom";
		
		public var userContact:IUserContact;
		public var userImage:DisplayObject;
		public var ownerId:Number;
		
		public function UserContactEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, extra:Object=null) 
		{
			super(type, bubbles, cancelable, extra);
			
		}
		
	}

}