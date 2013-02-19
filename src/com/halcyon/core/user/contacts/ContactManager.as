package com.halcyon.core.user.contacts
{
	import com.adobe.serialization.json.JSON;
	import com.halcyon.core.user.AvatarManager;
	import com.halcyon.interfaces.user.IFullInternalUser;
	import com.halcyon.util.events.AlertEvents;
	import com.halcyon.util.events.NotificationEvent;
	import com.halcyon.util.localization.Babelfish;
	import com.halcyon.util.utilities.TextUtil;
	import flash.utils.Dictionary;
	
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.HalcyonEvent;
	import com.halcyon.util.events.UserContactEvent;
	import com.halcyon.util.utilities.ClientUrls;
	
	import com.halcyon.util.utilities.LogFactory;
	import com.halcyon.util.utilities.Logger;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author JCC
	 */
	public class ContactManager
	{
		private static var log:Logger = LogFactory.getLog("ContactManager", Logger.DEBUG);
		private static var _LISTENERS_ADDED:Boolean = false;
		private static var _USERS:Dictionary = new Dictionary();
		
		public static const DELETE_USER_CONTACT:String = "deleteUserContact";
		public static const USER_CONTACTS_UPDATED:String = "userContactsUpdated";
		
		private static const CONTACTS_GET_URL:String = "services/client/getContactList/";
		private static const CONTACTS_ADD_URL:String = "services/client/addContact";
		private static const CONTACTS_REMOVE_URL:String = "services/client/removeContact";
		private static const CONTACTS_UPDATE_URL:String = "services/client/updateContact";
		
		private var _contactsLoaded:Boolean = false;
		private var _queuedContacts:Array = [];
		private var _contacts:Array = [];
		private var _userId:Number;
		private var _removeContactLoader:URLLoader;
		private var _addContactLoader:URLLoader;
		private var _getContactsLoader:URLLoader;
		
		public function ContactManager(userId:Number)
		{
			_userId = userId;
			_contactsLoaded = false;
			//this.updateContactsFromServer();
			this.addListeners();
		}
		
		public static function getContactManager(userId:Number):ContactManager
		{
			if (!_USERS[userId.toString()]) _USERS[userId.toString()] = new ContactManager(userId);
			
			return _USERS[userId.toString()] as ContactManager;
		}
		
		private function addListeners():void
		{
			EventManager.getInstance().addEventListener(DELETE_USER_CONTACT, onDeleteUserContactEvent);
			
			if (!_LISTENERS_ADDED) ContactManager.addListeners();
			//EventManager.getInstance().addEventListener(UserContactEvent.ADD_USER_CONTACT, onAddUserContact);
		}
		
		private function onDeleteUserContactEvent(e:UserContactEvent):void
		{
			var info:Object = e.getExtra();
			var id:Number = (info.id) ? info.id : (info.userContact as UserContact).id;
			log.debug("onDeleteUserContactEvent id=" + id);
			if (_userId == e.ownerId)
			{
				this.deleteContact(id)
			}
		}
		
		private function addRemoveRemoveListeners(add:Boolean = true):void
		{
			if (add)
			{
				_removeContactLoader.addEventListener(Event.COMPLETE, onRemoveContact);
				_removeContactLoader.addEventListener(IOErrorEvent.IO_ERROR, onRemoveContactIOError);
				_removeContactLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRemoveContactSecurityError);
			}
			else
			{
				_removeContactLoader.removeEventListener(Event.COMPLETE, onRemoveContact);
				_removeContactLoader.removeEventListener(IOErrorEvent.IO_ERROR, onRemoveContactIOError);
				_removeContactLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onRemoveContactSecurityError);
			}
		}
		
		private function onRemoveContactSecurityError(e:SecurityErrorEvent):void
		{
			log.debug("onRemoveContactSecurityError error text=" + e.text);
			this.addRemoveRemoveListeners(false);
		}
		
		private function onRemoveContactIOError(e:IOErrorEvent):void
		{
			log.debug("onRemoveContactIOError error text=" + e.text);
			this.addRemoveRemoveListeners(false);
		}
		
		private function onRemoveContact(e:Event):void
		{
			log.debug("onRemoveContact status=" + (e.target as URLLoader).data);
			this.addRemoveRemoveListeners(false);
			this.dispatchUpdateEvent();
		}
		
		/**
		 * Delets the specified contact and makes a
		 * removeContact HTTP call
		 * @param	id
		 */
		private function deleteContact(id:Number):void
		{
			
			var n:int = _contacts.length;
			for (var i:int = 0; i < n; i++)
			{
				var uc:UserContact = _contacts[i];
				if (uc.id == id)
				{
					uc = null;
					break;
				}
			}
			if (i < n)
			{
				_contacts.splice(i, 1);
			}
			
			_removeContactLoader = new URLLoader();
			this.addRemoveRemoveListeners(true);
			
			var urlRequest:URLRequest = new URLRequest(ClientUrls.getInstance().buildSiteUrl(CONTACTS_REMOVE_URL));
			urlRequest.method = URLRequestMethod.POST;
			var vars:URLVariables = new URLVariables();
			vars.id = id;
			vars.owner_id = _userId;
			
			urlRequest.data = vars;
			
			_removeContactLoader.load(urlRequest);
		}
		
		//GET/POST callbacks
		private function onGetContacts(e:Event):void
		{
			this.addRemoveGetListeners(false);
			_contactsLoaded = true;
			
			//clear contacts
			_contacts = [];
			
			//parse list and set the _contacts array
			var contactsLoader:URLLoader = (e.target as URLLoader);
			var contactsArray:Array = com.adobe.serialization.json.JSON.decode(contactsLoader.data);
			//data structure of response
			/*
			 * first_name
			 * last_name
			 * email
			 * phone
			 * phone_ext
			 * phone_intl_prefix
			 * id
			 * owner_id
			 * position
			 * company
			 * */
			
			var n:int = contactsArray.length;
			for (var i:int = 0; i < n; i++)
			{
				var contactObj:Object = contactsArray[i];
				if (contactObj.owner_id != _userId)
					continue;
				var uc:UserContact = new UserContact(contactObj.first_name, contactObj.last_name, contactObj.email, contactObj.phone, contactObj.phone_ext, contactObj.phone_intl_prefix, contactObj.position, contactObj.company, contactObj.id);
				if (contactObj.furl) uc.furl = contactObj.furl;
				if (contactObj.user_id) uc.clientId = contactObj.user_id;
				if (contactObj.imageIdx) uc.imageIDX = contactObj.imageIdx;
				if (contactObj.imageType) uc.imageType = contactObj.imageType;
				_contacts.push(uc);
			}
			
			this.dispatchUpdateEvent();
		}
		
		private function onGetSecurityError(e:SecurityErrorEvent):void
		{
			log.debug("onGetSecurityError error text=" + e.text);
			_contacts = [];
			this.dispatchUpdateEvent();
			this.addRemoveGetListeners(false);
		}
		
		private function onGetIOError(e:IOErrorEvent):void
		{
			log.debug("onGetIOError error text=" + e.text);
			_contacts = [];
			this.dispatchUpdateEvent();
			this.addRemoveGetListeners(false);
		}
		
		private function onAddContactSecurityError(e:SecurityErrorEvent):void
		{
			log.debug("onAddContactSecurityError error text=" + e.text);
			this.addRemoveAddListeners(false);
		}
		
		private function onAddContactIOError(e:IOErrorEvent):void
		{
			log.debug("onAddContactIOError error text=" + e.text);
			this.addRemoveAddListeners(false);
		}
		
		private function onAddContact(e:Event):void
		{
			//contact added successfully
			this.addRemoveAddListeners(false);
			//this.updateContactsFromServer();
			this.createContactFromServerObject((e.target as URLLoader).data);
		}
		
		private function createContactFromServerObject(serverResult:String):void
		{
			var userObject:Object = com.adobe.serialization.json.JSON.decode(serverResult);
			var newContact:UserContact = new UserContact(userObject.first_name, userObject.last_name, userObject.email, userObject.phone, userObject.phone_ext, userObject.phone_intl_prefix, userObject.position, userObject.company, userObject.id);
			if (userObject.furl) newContact.furl = userObject.furl;
			if (userObject.user_id) newContact.clientId = userObject.user_id;
			if (userObject.imageIdx) newContact.imageIDX = userObject.imageIdx;
			if (userObject.imageType) newContact.imageType = userObject.imageType;
			
			_contacts.push(newContact);
			this.dispatchUpdateEvent();
		}
		
		private function dispatchUpdateEvent():void
		{
			var evt:UserContactEvent = new UserContactEvent(UserContactEvent.USER_CONTACTS_UPDATED);
			evt.ownerId = _userId;
			EventManager.getInstance().dispatchEvent(evt);
		}
		
		private function addRemoveAddListeners(add:Boolean = true):void
		{
			if (add)
			{
				_addContactLoader.addEventListener(Event.COMPLETE, onAddContact);
				_addContactLoader.addEventListener(IOErrorEvent.IO_ERROR, onAddContactIOError);
				_addContactLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onAddContactSecurityError);
			}
			else
			{
				_addContactLoader.removeEventListener(Event.COMPLETE, onAddContact);
				_addContactLoader.removeEventListener(IOErrorEvent.IO_ERROR, onAddContactIOError);
				_addContactLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onAddContactSecurityError);
			}
		}
		
		private function addRemoveUpdateListeners(add:Boolean = true):void
		{
			if (add)
			{
				_addContactLoader.addEventListener(Event.COMPLETE, onUpdateContact);
				_addContactLoader.addEventListener(IOErrorEvent.IO_ERROR, onAddContactIOError);
				_addContactLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onAddContactSecurityError);
			}
			else
			{
				_addContactLoader.removeEventListener(Event.COMPLETE, onUpdateContact);
				_addContactLoader.removeEventListener(IOErrorEvent.IO_ERROR, onAddContactIOError);
				_addContactLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onAddContactSecurityError);
			}
		}
		
		private function onUpdateContact(e:Event):void
		{
			this.addRemoveUpdateListeners(false);
			this.dispatchUpdateEvent();
		}
		
		private function addContactToServer(userContact:UserContact, isUpdate:Boolean = false):void
		{
			//post contact to server
			_addContactLoader = new URLLoader();
			if (!isUpdate)
			{
				this.addRemoveAddListeners(true);
			}
			else
			{
				this.addRemoveUpdateListeners(true);
			}
			
			var urlRequest:URLRequest = new URLRequest(ClientUrls.getInstance().buildSiteUrl((isUpdate) ? CONTACTS_UPDATE_URL : CONTACTS_ADD_URL));
			urlRequest.method = URLRequestMethod.POST;
			var vars:URLVariables = new URLVariables();
			vars.first_name = userContact.fname;
			vars.last_name = userContact.lname;
			vars.email = userContact.email;
			if (userContact.phoneNum != "")
				vars.phone = userContact.phoneNum;
			if (userContact.phoneExt != "")
				vars.phone_ext = userContact.phoneExt;
			if (userContact.phoneIntlPrefix != "")
				vars.phone_intl_prefix = userContact.phoneIntlPrefix;
			if (userContact.clientId > -1)
				vars.clientId = userContact.clientId;
			vars.position = userContact.title;
			vars.company = userContact.organization;
			if (isUpdate)
			{
				vars.id = userContact.id;
				vars.owner_id = _userId;
			}
			else
			{
				vars.id = _userId;
			}
			
			urlRequest.data = vars;
			
			_addContactLoader.load(urlRequest);
		}
		
		//CONFIG::test
		public function getFakeContacts():void
		{
			_contacts = [];
			_contacts.push(new UserContact("Tony", "Romo", "qb@cowboys.com", "1234567890", "", ""));
			_contacts.push(new UserContact("Hines", "Ward", "cheapshot@artist.com", "2345678901", "", ""));
			_contacts.push(new UserContact("Tom", "Landry", "coach@cowboys.com", "3456789012", "", ""));
			_contacts.push(new UserContact("Metta", "Worldpeace", "looney@tunes.com", "4567890123", "", ""));
			_contacts.push(new UserContact("Ignatius", "Riley", "iriley@dunces.com", "5678901234", "", ""));
			_contacts.push(new UserContact("Homer", "Simpson", "homer@snpp.com", "6789012345", "", ""));
			_contacts.push(new UserContact("Stewie", "Griffin", "loismustdie@yahoo.com", "7890123456", "", ""));
			_contacts.push(new UserContact("Terry", "Bradshaw", "terry15426@aol.com", "8901234567", "", ""));
			_contactsLoaded = true;
			this.dispatchUpdateEvent();
		}
		
		private function addRemoveGetListeners(add:Boolean = true):void
		{
			if (add)
			{
				_getContactsLoader.addEventListener(Event.COMPLETE, onGetContacts);
				_getContactsLoader.addEventListener(IOErrorEvent.IO_ERROR, onGetIOError);
				_getContactsLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onGetSecurityError);
			}
			else
			{
				_getContactsLoader.removeEventListener(Event.COMPLETE, onGetContacts);
				_getContactsLoader.removeEventListener(IOErrorEvent.IO_ERROR, onGetIOError);
				_getContactsLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onGetSecurityError);
			}
		}
		
		/**
		 * Retrieve the user's contacts
		 */
		private function updateContactsFromServer():void
		{
			_contactsLoaded = false;
			
			//until server is ready
			//getFakeContacts();
			//return;
			
			//TODO - HTTP call to get contacts - returned in JSON format
			_getContactsLoader = new URLLoader();
			this.addRemoveGetListeners(true);
			
			var urlRequest:URLRequest = new URLRequest(ClientUrls.getInstance().buildSiteUrl(CONTACTS_GET_URL + _userId));
			urlRequest.method = URLRequestMethod.GET;
			_getContactsLoader.load(urlRequest);
		}
		
		/**
		 * Update an existing User Contact
		 * @param	existingContact The UserContact object to update
		 * @param	fName User's first name
		 * @param	lName User's last name
		 * @param	email User's email
		 * @param	phoneNum User's phone number
		 * @param	phoneExt User's phone extension
		 * @param	phoneIntlPrefix User's intl phone prefix
		 * @param	title User's title/position
		 * @param	organization User's organization/company
		 * @param	clientId The Imeet ID of the user
		 */
		public function updateContact(existingContact:UserContact, fName:String = "", lName:String = "", email:String = "", phoneNum:String = "", phoneExt:String = "", phoneIntlPrefix:String = "", title:String = "", organization:String = "", clientId:Number = -1):void
		{
			//modify the local contact
			existingContact.fname = fName;
			existingContact.lname = lName;
			existingContact.email = email;
			existingContact.phoneNum = phoneNum;
			existingContact.phoneExt = phoneExt;
			existingContact.phoneIntlPrefix = phoneIntlPrefix;
			existingContact.title = title;
			existingContact.organization = organization;
			existingContact.clientId = clientId;
			
			//send the update to the server
			this.addContactToServer(existingContact, true);
		}
		
		/**
		 * Force a refresh (via an HTTP GET) of the user's contact list
		 */
		public function refreshContacts():void
		{
			this.updateContactsFromServer();
		}
		
		/**
		 * Add a contact to the user's contact array
		 * @param	fName First name
		 * @param	lName Last name
		 * @param	email Email address
		 * @param	phoneNum Phone number
		 * @param	phoneExt Phone extension
		 * @param	phoneIntlPrefix International Prefix
		 * @param   title User title/position
		 * @param   organization User organization/company
		 * @param	id Internal Contact ID
		 * @param	clientId Client Id, if the user is already an iMeet user
		 */
		public function addContact(fName:String = "", lName:String = "", email:String = "", phoneNum:String = "", phoneExt:String = "", phoneIntlPrefix:String = "", title:String = "", organization:String = "", notify:Boolean=false):void
		{
			// send to Server - don't handle internally?  Just refresh the contacts afterward?
			var evt:NotificationEvent;
			if (!this.isDup(email,fName+lName))
			{
				var newContact:UserContact = new UserContact(fName, lName, email, phoneNum, phoneExt, phoneIntlPrefix, title, organization);
				this.addContactToServer(newContact);
				if (notify)
				{
					//chat notification
					evt = new NotificationEvent(NotificationEvent.SEND_NOTIFICATION, "", fName + " " + lName + Babelfish.getInstance().getText("alertText", "hasBeenAdded", " has been added to your contacts"));
					EventManager.getInstance().dispatchEvent(evt);
				}
			}
			else
			{
				//dup notification?
				evt = new NotificationEvent(NotificationEvent.SEND_NOTIFICATION, "", fName + " " + lName + Babelfish.getInstance().getText("alertText", "isAlreadyAdded", " is already one of your contacts"));
				EventManager.getInstance().dispatchEvent(evt);
			}
			
		}
		
		private function isDup(email:String,fullname:String):Boolean
		{
			for each (var item:UserContact in _contacts)
			{
				if (email == "")
				{
					if ((item.fname + item.lname) == fullname) return true;
				}
				else if (item.email == email) return true;
			}
			return false;
		}
		
		/**
		 * Return an array of contacts based on a search string
		 * @param	name String to search (searches first name, last name and organization)
		 * @return Array of UserContact objects
		 */
		public function findContacts(searchString:String):Array
		{
			var matchingContacts:Array = [];
			for each (var item:UserContact in _contacts)
			{
				if (TextUtil.fuzzySearch(item.fname + " " + item.lname + " " + item.organization, searchString))
					matchingContacts.push(item);
			}
			return matchingContacts;
		}
		
		public function hasImeetContact(imeetId:Number):Boolean
		{
			for each (var item:UserContact in _contacts)
			{
				if (item.clientId == imeetId) return true;
			}
			return false;
		}
		
		/**
		 * Retrieve all contacts, sorted or not
		 * @param	sorted Whether or not to sort the contacts by last name
		 * @param	sortDescending If TRUE, contacts will be sorted in Descending order
		 * @return Array containing all the UserContacts attached to the user
		 */
		public function getAllContacts(sort:Boolean = false, sortDescending:Boolean = false):Array
		{
			if (sort)
			{
				var sorted:Array = _contacts.concat();
				if (sortDescending)
				{
					sorted.sortOn("lname", Array.DESCENDING);
				}
				else
				{
					sorted.sortOn("lname");
				}
				return sorted;
			}
			else
			{
				return _contacts.concat();
			}
		}
		
		/**
		 * Perform a "fuzzy" search on a string
		 * @param	textToCheck String to search
		 * @param	str String to match
		 * @return True if the strings "match"
		 */
		private function fuzzySearch(textToCheck:String, str:String):Boolean
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
				pattern += str.charAt(i) + ".*"
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
		
		public function get contactsLoaded():Boolean
		{
			return _contactsLoaded;
		}
		
		public static function init():void
		{
			ContactManager.addListeners();
		}
		private static function addListeners():void
		{
			EventManager.getInstance().addEventListener(UserContactEvent.ADD_USER_CONTACT, onAddUserContact);
			_LISTENERS_ADDED = true;
		}
		
		private static function onAddUserContact(e:UserContactEvent):void
		{
			var ownerId:Number = e.ownerId;
			var user:IFullInternalUser = e.getExtra().user;

			if (AvatarManager.getInstance().getMyUser().getIsGuest())
			{
				var realmUri:String = ClientUrls.getInstance().getRealmUri();
				var isDT:Boolean = (realmUri.indexOf("imeet.de") > -1 || realmUri.indexOf("dt.imeet.com") > -1);

				var evt:HalcyonEvent = new HalcyonEvent(AlertEvents.ALERT);
				var extra:Object = new Object();
				var babelfish:Babelfish = Babelfish.getInstance();
				extra.title = babelfish.getText("alertText", "getRoom", "Get a Room!");
				var signUpUrl:String = ClientUrls.getInstance().buildSiteUrl("signup/try-now?how=try-it-free&email="+encodeURI(AvatarManager.getInstance().getMyUser().getEmail()));
				
				
				var linkText:String = "<font color=\'#00AEFF\'><b><u><a href=\'" + signUpUrl + "\' target=\'_blank\'>" +
						babelfish.getText("alertText", "linkMessage", "Sign up for an iMeet room!") + "</a></u></b></font>";
				
				if (isDT)
				{
					extra.body = babelfish.getText("alertText", "mustHaveRoom", "You must have your own iMeet room to add ")+"\n\n"+linkText;
				} else
				{
					extra.body = babelfish.getText("alertText", "mustHaveRoom", "You must have your own iMeet room to add ") +
						user.getFirstName() + babelfish.getText("alertText", "followLink",
						" to your contacts.\n\nPlease follow the link below for instructions.\n\n") +
						linkText;
				}
				
				extra.type = AlertEvents.TYPE_NORMAL;
				evt.setExtra(extra);
				EventManager.getInstance().dispatchEvent(evt);
			} else
			{
				var cmInstance:ContactManager = getContactManager(ownerId);
				cmInstance.addContact(user.getFirstName(), user.getLastName(), user.getEmail(), user.getPhone(), user.getPhoneExt(), user.getPhoneIntlPrefix(), user.getTitle(), user.getCompany(), true);
			}
		}
	}
}