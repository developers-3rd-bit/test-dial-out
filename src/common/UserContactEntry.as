package common
{
	import com.greensock.TweenMax;
	import com.halcyon.core.user.contacts.UserContact;
	import com.halcyon.layout.common.VGroupElement;
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.UserContactEvent;
	import com.halcyon.util.localization.Babelfish;
	import com.halcyon.util.utilities.ButtonUtil;
	import com.halcyon.util.utilities.ClientUrls;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UserContactEntry extends McContactContainer implements VGroupElement
	{
		private static var _SELECTION_DISABLED:Boolean = false;
		
		private var _eventManager:EventManager;

      private var _confirmFurlYesButton:MovieClip;
		private var _confirmFurlNoButton:MovieClip;
		
		private var _confirmDeleteYesButton:MovieClip;
		private var _confirmDeleteNoButton:MovieClip;
		
		private var _confirmCallYesButton:MovieClip;
		private var _confirmCallNoButton:MovieClip;
		
		private var _confirmEmailYesButton:MovieClip;
		private var _confirmEmailNoButton:MovieClip;
		private var _confirmEmailViewButton:MovieClip;
		
		private var _imageContainer:MovieClip;
		private var _userName:TextField;
		private var _userTitle:TextField;
		private var _userOrg:TextField;
		
		private var _goRoomBtn:MovieClip;
		private var _emailBtn:MovieClip;
		private var _phoneBtn:MovieClip;
		private var _editBtn:MovieClip;
		private var _deleteBtn:MovieClip;
		
		private var _selectedStroke:MovieClip;
		private var _filledBackground:MovieClip;
		
		private var _selected:Boolean;
		private var _userContact:UserContact;
		private var _buttonsContainer:Sprite;
		
		private var _langContactsDeleteToolTip:String;
		private var _langContactsEditToolTip:String;
		private var _langContactsPhoneToolTip:String;
		private var _langContactsInviteToolTip:String;
		private var _langContactsEnterToolTip:String;
		private var _dialoutEnabled:Boolean;
      
      private var _mcSpinner:McSpinner;
		
		public function UserContactEntry(userContact:UserContact, fillBackground:Boolean, dialoutEnabled:Boolean = true )
		{
			this._dialoutEnabled = dialoutEnabled;
			this._userContact = userContact;
         this._mcSpinner = new McSpinner();
			_eventManager = EventManager.getInstance();
			this.init(fillBackground);
		}
		
		private function init(fillBackground:Boolean):void
		{
			setTranslations();
			
			//TODO wire up clip w/ variables
			_userName = mcContactElements.tfName;
			_userTitle = mcContactElements.tfTitle;
			_userOrg = mcContactElements.tfCompany;
			
			_deleteBtn = setupButton(mcContactElements.mcDeleteContact,_langContactsDeleteToolTip);
			_editBtn = setupButton(mcContactElements.mcEditContact, _langContactsEditToolTip);
			_emailBtn = setupButton(mcContactElements.mcEmailContact, _langContactsInviteToolTip);
			if (_userContact.email == null || _userContact.email == "")
			{
				_emailBtn.mcButton.gotoAndStop("inactive");
			}
			_goRoomBtn = setupButton(mcContactElements.mcEnterContactsRoom, _langContactsEnterToolTip);
			if (_userContact.furl == null || _userContact.furl == "")
			{
				_goRoomBtn.mcButton.gotoAndStop("inactive");
				_goRoomBtn.visible = false;
			}
			_phoneBtn = setupButton(mcContactElements.mcCallContact,_langContactsPhoneToolTip);
			if (_userContact.phoneNum==null || _userContact.phoneNum == "" || !_dialoutEnabled)
			{
				_phoneBtn.mcButton.gotoAndStop("inactive");
			}
			//Move buttons into a separate sprite container to make
			//showing/hiding them easier.
			_buttonsContainer = new Sprite();
			_buttonsContainer.x = _goRoomBtn.x;
			_buttonsContainer.y = _goRoomBtn.y;
			var xPos:Object = { emailX:_emailBtn.x, phoneX:_phoneBtn.x, editX:_editBtn.x, deleteX: _deleteBtn.x };
			_buttonsContainer.addChild(_goRoomBtn);
			_goRoomBtn.x = 0;
			_buttonsContainer.addChild(_emailBtn);
			_emailBtn.x = xPos.emailX - _buttonsContainer.x;
			_buttonsContainer.addChild(_phoneBtn);
			_phoneBtn.x = xPos.phoneX - _buttonsContainer.x;
			_buttonsContainer.addChild(_editBtn);
			_editBtn.x = xPos.editX - _buttonsContainer.x;
			_buttonsContainer.addChild(_deleteBtn);
			_deleteBtn.x = xPos.deleteX - _buttonsContainer.x;
			mcContactElements.addChild(_buttonsContainer);
			
			var nameFormat:TextFormat = _userName.getTextFormat();
			_userName.restrict = null;
			_userName.text = _userContact.fname + " " + _userContact.lname;
			
			//nameFormat.bold = true;
			_userName.setTextFormat(nameFormat);
			
			_userTitle.text = _userContact.title;
			_userOrg.text = _userContact.organization;
			
			if (!fillBackground)
			{
				mcContactBg.alpha = 0;
			}
			//mcContactBg.alpha = fillBackground?100:0;
			
			//TODO - check userContact to see if picture and furl are avail
			mcImage.visible = false;
			
			//confirm dialogs
			_confirmCallYesButton = setupButton(mcConfirmCall.mcConfirmCallYes);
			_confirmCallNoButton = setupButton(mcConfirmCall.mcConfirmCallNo);
			var confirmFormat:TextFormat = (mcConfirmCall.tfPhone as TextField).getTextFormat();
			mcConfirmCall.tfPhone.text = _userContact.formatedPhoneNum;
			//confirmFormat.bold = true;
			mcConfirmCall.tfPhone.setTextFormat(confirmFormat);
			_confirmDeleteYesButton = setupButton(mcConfirmDelete.mcConfirmDeleteYes);
			_confirmDeleteNoButton = setupButton(mcConfirmDelete.mcConfirmDeleteNo);
			mcConfirmDelete.tfName.text = _userContact.fname + " " + _userContact.lname;
			mcConfirmDelete.tfName.setTextFormat(confirmFormat);
			
			_confirmFurlYesButton = setupButton(mcConfirmFurl.mcConfirmFurlYes);
			_confirmFurlNoButton = setupButton(mcConfirmFurl.mcConfirmFurlNo);
			mcConfirmFurl.tfName.text = _userContact.fname + " " +_userContact.lname;
			mcConfirmFurl.tfName.setTextFormat(confirmFormat);
			
			_confirmEmailYesButton = setupButton(mcConfirmEmail.mcConfirmEmailYes);
			_confirmEmailNoButton = setupButton(mcConfirmEmail.mcConfirmEmailNo);
			_confirmEmailViewButton = setupButton(mcConfirmEmail.mcConfirmEmailView);
			mcConfirmEmail.tfEmail.text = _userContact.email;
			mcConfirmEmail.tfEmail.setTextFormat(confirmFormat);
         _mcSpinner.x = mcConfirmCall.tfPhone.x + 80;
         _mcSpinner.y = mcConfirmCall.tfPhone.y - 3;
         _mcSpinner.visible = false;
         mcConfirmCall.addChild(_mcSpinner);
			mcConfirmCall.visible = false;
			mcConfirmDelete.visible = false;
			mcConfirmEmail.visible = false;
			mcConfirmFurl.visible = false;
			
			//localize confirm dialogs
			var babelfish:Babelfish = Babelfish.getInstance();
			babelfish.localizeMovieClip(mcConfirmCall, "addGuestPanel");
			babelfish.localizeMovieClip(mcConfirmEmail, "addGuestPanel");
			babelfish.localizeMovieClip(mcConfirmDelete, "addGuestPanel");
			babelfish.localizeMovieClip(mcConfirmFurl, "addGuestPanel");
			
			switch (_userContact.imageType)
			{
				case 0:
					//show silhouette
					this.mcNoPhoto.visible = true;
					this.mcImage.visible = false;
					break;
				case 1:
					//No Avatar display for now
					this.mcNoPhoto.visible = true;
					/*this.mcNoPhoto.visible = false;
					displayAvatar();*/
					break;
				case 2:
					//standard photo - load it
					if (_userContact.imageIDX>-1 && _userContact.clientId>-1)
					{
						this.mcNoPhoto.visible = false;
						this.mcImage.visible = true;
						this.mcImage.mcLoading.play();
						var imageLoader:Loader = new Loader();
						imageLoader.contentLoaderInfo.addEventListener(Event.INIT, onPhotoInit);
						imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPhotoError);
						imageLoader.load(new URLRequest(ClientUrls.getInstance().buildSiteUrl(ClientUrls.USER_IMAGE + "?id=" + _userContact.clientId + "&idx=" + _userContact.imageIDX)));
					} else
					{
						this.mcNoPhoto.visible = true;
						this.mcImage.visible = false;
					}
					break;
			}

			this.select(false, true);
			this.addListeners();
			
		}
		
		public function setTranslations():void
		{
			var babelfish:Babelfish = Babelfish.getInstance();
			/*
			if (babelfish.ready) {
				lang_contactsDeleteToolTip = babelfish.getText("addGuestPanel", "contactsDeleteToolTip");
				lang_contactsEditToolTip = babelfish.getText("addGuestPanel", "contactsEditToolTip");
				lang_contactsPhoneToolTip = babelfish.getText("addGuestPanel", "contactsPhoneToolTip");
				lang_contactsInviteToolTip = babelfish.getText("addGuestPanel", "contactsInviteToolTip");
				lang_contactsEnterToolTip = babelfish.getText("addGuestPanel", "contactsEnterToolTip");
			} else {
			*/
				_langContactsDeleteToolTip = "Delete Contact";
				_langContactsEditToolTip = "Edit Contact Details";
				_langContactsEnterToolTip = "Enter Room";
				_langContactsInviteToolTip = "Invite via Email";
				_langContactsPhoneToolTip = "Invite via Phone";
			// }
			
			if(_deleteBtn) setupButton(_deleteBtn, _langContactsDeleteToolTip);
			if(_editBtn) setupButton(_editBtn, _langContactsEditToolTip);
			if(_phoneBtn) setupButton(_phoneBtn, _langContactsPhoneToolTip);
			if(_emailBtn) setupButton(_emailBtn, _langContactsInviteToolTip);
			if(_goRoomBtn) setupButton(_goRoomBtn, _langContactsEnterToolTip);
			
		}

		private function setupButton(mcClip:MovieClip,toolTip:String=""):MovieClip
		{
			ButtonUtil.setupListeners(mcClip,null,(toolTip!="")?toolTip:null);
			return mcClip;
		}

		private function onPhotoError(e:IOErrorEvent):void
		{
			this.mcImage.mcLoading.stop();
			this.mcImage.mcLoading.visible = false;
			this.mcNoPhoto.visible = true;
			this.mcImage.visible = false;
		}

		private function onPhotoInit(e:Event):void 
      {
			this.mcImage.mcLoading.stop();
			this.mcImage.mcLoading.visible = false;
			var imageLoader:Loader = (e.target as LoaderInfo).loader;
			var image:Bitmap = imageLoader.content as Bitmap;
			image.smoothing = true;
			image.height = this.mcImage.height;
			image.width = this.mcImage.width;
			this.mcImage.addChild(image);
			this.mcNoPhoto.visible = false;
			mcImage.alpha = 0;
			TweenMax.to(mcImage, .5, { alpha:1 } );
			this.mcImage.visible = true;
		}

		private function addListeners():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, onSelect);
			if (_userContact.email != null && _userContact.email != "") _emailBtn.addEventListener(MouseEvent.CLICK, onEmail);
			if (_userContact.phoneNum != null && _userContact.phoneNum != "" && _dialoutEnabled) _phoneBtn.addEventListener(MouseEvent.CLICK, onPhone);
			_editBtn.addEventListener(MouseEvent.CLICK, onEdit);
			_deleteBtn.addEventListener(MouseEvent.CLICK, onDelete);
			if (_goRoomBtn.visible) _goRoomBtn.addEventListener(MouseEvent.CLICK, onGoRoom);
			_eventManager.addEventListener(UserContactEvent.SELECT_USER_CONTACT, onSelectEvent);
			_confirmCallYesButton.addEventListener(MouseEvent.CLICK, onConfirmCallYes);
			_confirmCallNoButton.addEventListener(MouseEvent.CLICK, onConfirmCallNo);
			_confirmDeleteYesButton.addEventListener(MouseEvent.CLICK, onConfirmDeleteYes);
			_confirmDeleteNoButton.addEventListener(MouseEvent.CLICK, onConfirmDeleteNo);
			_confirmEmailYesButton.addEventListener(MouseEvent.CLICK, onConfirmEmailYes);
			_confirmEmailNoButton.addEventListener(MouseEvent.CLICK, onConfirmEmailNo);
			_confirmEmailViewButton.addEventListener(MouseEvent.CLICK, onConfirmEmailView);
			_confirmFurlYesButton.addEventListener(MouseEvent.CLICK, onConfirmFurlYes);
			_confirmFurlNoButton.addEventListener(MouseEvent.CLICK, onConfirmFurlNo);
		}
		
		private function removeListeners():void
		{
			this.removeEventListener(MouseEvent.CLICK, onSelect);
			_emailBtn.removeEventListener(MouseEvent.CLICK, onEmail);
			if (_phoneBtn.hasEventListener(MouseEvent.CLICK)) _phoneBtn.removeEventListener(MouseEvent.CLICK, onPhone);
			_editBtn.removeEventListener(MouseEvent.CLICK, onEdit);
			_deleteBtn.removeEventListener(MouseEvent.CLICK, onDelete);
			if (_goRoomBtn.visible) _goRoomBtn.removeEventListener(MouseEvent.CLICK, onGoRoom);
			_eventManager.removeEventListener(UserContactEvent.SELECT_USER_CONTACT, onSelectEvent);
			_confirmCallYesButton.removeEventListener(MouseEvent.CLICK, onConfirmCallYes);
			_confirmCallNoButton.removeEventListener(MouseEvent.CLICK, onConfirmCallNo);
			_confirmDeleteYesButton.removeEventListener(MouseEvent.CLICK, onConfirmDeleteYes);
			_confirmDeleteNoButton.removeEventListener(MouseEvent.CLICK, onConfirmDeleteNo);
			_confirmEmailYesButton.removeEventListener(MouseEvent.CLICK, onConfirmEmailYes);
			_confirmEmailNoButton.removeEventListener(MouseEvent.CLICK, onConfirmEmailNo);
			_confirmEmailViewButton.removeEventListener(MouseEvent.CLICK, onConfirmEmailView);
			_confirmFurlYesButton.removeEventListener(MouseEvent.CLICK, onConfirmFurlYes);
			_confirmFurlYesButton.removeEventListener(MouseEvent.CLICK, onConfirmFurlNo);
		}
		
		private function onGoRoom(e:MouseEvent):void
		{
			this.showFurlConfirm(true);
		}
		
		private function onConfirmFurlNo(e:MouseEvent):void
		{
			this.showFurlConfirm(false);
		}
		
		private function onConfirmFurlYes(e:MouseEvent):void
		{
			//navigateToURL(new URLRequest(_userContact.furl),"_self");
			this.showFurlConfirm(false);
			var evt:UserContactEvent = new UserContactEvent(UserContactEvent.GO_TO_ROOM);
			evt.setExtra( { target:_goRoomBtn.localToGlobal(new Point(0, 0)) } );
			_eventManager.dispatchEvent(evt);
			
			this.removeListeners();
			// TweenMax.delayedCall(Skin.GO_TO_ROOM_ANIMATION_DURATION, goToThisRoom);
		}
		
		private function goToThisRoom():void
		{
			navigateToURL(new URLRequest(_userContact.furl),"_self");
		}
		
		private function showFurlConfirm(show:Boolean):void
		{
			_SELECTION_DISABLED = show;
			TweenMax.fromTo(mcContactElements, .25, { alpha:show?1:0 }, { autoAlpha:show?0:1 } );
			TweenMax.fromTo(mcConfirmFurl, .25, { alpha:show?0:1 }, { autoAlpha:show?1:0 } );
			//mcContactElements.visible = !show;
			//mcConfirmFurl.visible = show;
		}
		
		private function onConfirmEmailView(e:MouseEvent):void
		{
			//send event to show preview window
			var evt:UserContactEvent = new UserContactEvent(UserContactEvent.INVITE_USER_CONTACT_PREVIEW_EMAIL);
			evt.userContact = _userContact;
			evt.userImage = this.getUserImage();
			_eventManager.dispatchEvent(evt);
			this.showEmailConfirm(false);
		}
		
		private function onConfirmEmailNo(e:MouseEvent):void
		{
			this.showEmailConfirm(false);
		}
		
		private function onConfirmEmailYes(e:MouseEvent):void
		{
			/*var evt:HalcyonEvent = new HalcyonEvent(InviteConstants.EVENT_SEND_EMAIL);
			evt.setExtra( { emails:_userContact.email, subject: RealmText.INVITE_SUBJECT.replace("%name%", AvatarManager.getInstance().getMyUser().getFirstName()), body:RealmText.INVITE_MESSAGE0 } );
			_eventManager.dispatchEvent(evt);
         */
			this.showEmailConfirm(false);
		}
		
		private function onConfirmDeleteNo(e:MouseEvent):void
		{
			this.showDeleteConfirm(false);
		}
		
		private function onConfirmDeleteYes(e:MouseEvent):void
		{
			var evt:UserContactEvent = new UserContactEvent(UserContactEvent.DELETE_USER_CONTACT);
			//evt.ownerId = AvatarManager.getInstance().getMyUser().getId();
			evt.setExtra( {userContact:_userContact } );
			dispatchEvent(evt);
         this.showDeleteConfirm(false);
			
			this.removeListeners();
		}
		
		private function onConfirmCallNo(e:MouseEvent):void
		{
         _mcSpinner.visible = false;
			this.showCallConfirm(false);
		}
		
		private function onConfirmCallYes(e:MouseEvent):void
		{
         _mcSpinner.visible = true;
			var evt:UserContactEvent = new UserContactEvent(UserContactEvent.INVITE_USER_CONTACT_PHONE);
			evt.userContact = _userContact;
			_eventManager.dispatchEvent(evt);
			//this.showCallConfirm(false);
		}
		
		private function showEmailConfirm(show:Boolean=true):void
		{
			_SELECTION_DISABLED = show;
			TweenMax.fromTo(mcContactElements, .25, { alpha:show?1:0 }, { autoAlpha:show?0:1 } );
			TweenMax.fromTo(mcConfirmEmail, .25, { alpha:show?0:1 }, { autoAlpha:show?1:0 } );
		}

		private function showDeleteConfirm(show:Boolean=true):void
		{
			_SELECTION_DISABLED = show;
			TweenMax.fromTo(mcContactElements, .25, { alpha:show?1:0 }, { autoAlpha:show?0:1 } );
			TweenMax.fromTo(mcConfirmDelete, .25, { alpha:show?0:1 }, { autoAlpha:show?1:0 } );
		}

		private function showCallConfirm(show:Boolean=true):void
		{
			_SELECTION_DISABLED = show;
			TweenMax.fromTo(mcContactElements, .25, { alpha:show?1:0 }, { autoAlpha:show?0:1 } );
			TweenMax.fromTo(mcConfirmCall, .25, { alpha:show?0:1 }, { autoAlpha:show?1:0 } );
		}
		
		private function onSelectEvent(e:UserContactEvent):void
		{
			var selectedUserContact:UserContact = e.userContact as UserContact;
			this.select(e.userContact.id == _userContact.id);
		}
		
		private function onDelete(e:MouseEvent):void
		{
			this.showDeleteConfirm();
		}
		
		private function onEdit(e:MouseEvent):void
		{
			//send event to launch the AddUser panel
			var evt:UserContactEvent = new UserContactEvent(UserContactEvent.EDIT_USER_CONTACT);
			evt.userContact = _userContact;
			_eventManager.dispatchEvent(evt);
		}
		
		private function onPhone(e:MouseEvent):void
		{
         /*if (CoreUtil.isDTConsumer())
			{
				AlertHelper.showDTConsumerAlert();
				return;
			}
			*/
			this.showCallConfirm();
		}
		
		private function onEmail(e:MouseEvent):void
		{
			this.showEmailConfirm();
		}
		
		private function onSelect(e:MouseEvent):void
		{
			if (_SELECTION_DISABLED) return;
			var evt:UserContactEvent = new UserContactEvent(UserContactEvent.SELECT_USER_CONTACT);
			evt.userContact = _userContact;
			_eventManager.dispatchEvent(evt);
		}
		
		private function select(value:Boolean, force:Boolean = false ):void
		{
			if (_selected != value || force)
			{
				_selected = value;

				mcSelectedStroke.alpha = (value)?0:1;
            TweenMax.to(mcSelectedStroke, (force)?0:.25, { autoAlpha:(value && !force)?1:0 } );
			}
		}
		
		/**
		 * Retrive the User image of the Contact as a DisplayObject
		 * @return DisplayObject of the user's image
		 */
		public function getUserImage():DisplayObject
		{
			var imageToUse:DisplayObject = (mcImage.visible)?mcImage:mcNoPhoto.mcGuestDefaultMask;
			var bmd:BitmapData;
			var dupImage:Bitmap;
			
			if (mcImage.visible)
			{
				bmd = new BitmapData(imageToUse.width, imageToUse.height, true, 0x00000000);
				bmd.draw(imageToUse);
				dupImage = new Bitmap(bmd);
				return dupImage;
			} 
         else
			{
				bmd = new BitmapData(mcNoPhoto.width, mcNoPhoto.height, false, 0xFFFFFFFF);
				var sMat:Matrix = new Matrix();
				sMat.scale(.3, .3);
				sMat.translate(-1, 3);
				bmd.draw(imageToUse,sMat);
				dupImage = new Bitmap(bmd);
				return dupImage;
			}
		}

		/**
		 * Reset the UI state of the contact
		 */
		public function reset():void
		{
			mcConfirmCall.visible = false;
			mcConfirmDelete.visible = false;
			mcConfirmEmail.visible = false;
			mcConfirmFurl.visible = false;
			mcContactElements.alpha = 1;
			mcContactElements.visible = true;
			_SELECTION_DISABLED = false;
		}
		
		/**
		 * Remove all listeners - should enable the instance for
		 * GC
		 */
		public function kill():void
		{
			this.removeListeners();
		}
		
		public function get firstName():String { return _userContact.fname; }
		public function get lastName():String { return _userContact.lname; }
      public function get elementId():Number { return _userContact.id; }
		public function get organization():String { return _userContact.organization; }
	}

}