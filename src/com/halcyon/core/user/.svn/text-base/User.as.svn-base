package com.halcyon.core.user
{
	import com.halcyon.core.application.Application;
	import com.halcyon.core.communications.session.Session;
	import com.halcyon.core.presentation.FileshareFullscreenManager;
	import com.halcyon.core.user.contacts.ContactManager;
	import com.halcyon.interfaces.user.IFullInternalUser;
	import com.halcyon.message.core.PrefStatBrd;
	import com.halcyon.message.core.UpdateUserReq;
	import com.halcyon.message.pgi.ActiveTalkerBrd;
	import com.halcyon.message.ref.AppRef;
	import com.halcyon.message.ref.LevelRef;
	import com.halcyon.message.ref.UserRef;
	import com.halcyon.util.RealmText;
	import com.halcyon.util.events.BandwidthEvent;
	import com.halcyon.util.events.EventManager;
	import com.halcyon.util.events.HalcyonEvent;
	import com.halcyon.util.localization.Babelfish;
	import com.halcyon.util.parsers.weather.WeatherBugParser;
	import com.halcyon.util.photo.ServerImageUploader;
	import com.halcyon.util.photo.UserImageManager;
	import com.halcyon.util.utilities.ClientUrls;
	import com.halcyon.util.utilities.ContextManager;
	import com.halcyon.util.utilities.LogFactory;
	import com.halcyon.util.utilities.Logger;
	import com.halcyon.util.utilities.PhoneUtil;
	import com.halcyon.util.utilities.Util;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	

	public class User implements IFullInternalUser
	{
		private static var log:Logger = LogFactory.getLog("User",Logger.DEBUG);
		static private var SYSUSER_ID:int = 1;
		
		protected static const USER_TYPE_SYSTEM:int = 1;
		protected static const USER_TYPE_REGULAR:int = 2;
		protected static const USER_TYPE_PREMIUM:int = 4;
		protected static const USER_TYPE_CONTRIB:int = 8;
		protected static const USER_TYPE_ANONYM:int = 16;
		protected static const USER_TYPE_GROUP:int = 32;
		protected static const USER_TYPE_ADMIN:int = 64;
		protected static const USER_TYPE_MODERATOR:int = 128;
		protected static const USER_TYPE_ACCT:int = 256;
		protected static const USER_TYPE_ACCT_ADMIN:int = 512;
		protected static const USER_TYPE_OPS:int = 1024;
		protected static const USER_TYPE_LINKEDIN:int = 2048;
		protected static const USER_TYPE_FACEBOOK:int = 4096;
		
		public static const USER_UPDATED:String = "USER_UPDATED";
		public static const MY_USER_UPDATED:String = "MY_USER_UPDATED";
		
		public static const STATUS_ACTIVE:int        = 1;
		public static const STATUS_SUSPENDED:int    = 2;
		public static const STATUS_INACTIVE:int        = 3;
		public static const STATUS_REVIEW:int        = 4;
		public static const STATUS_DELETED:int       = 5;
		public static const STATUS_EXPIRED:int       = 6;
		
		public static const IMAGE_TYPE_DEFAULT:int = 0;
		public static const IMAGE_TYPE_AVATAR:int  =1;
		public static const IMAGE_TYPE_IMAGE:int = 2;
		public static const DISABLED_TEMP:int = -99;
		
		private var ref:UserRef;
		private var id:Number;
		private var screenName:String;
		private var name:String;
		private var age:int;
		private var lastNudge:int = 0;
		private var gender:String;
		private var location:String;
		private var weatherLink:String;
		private var autoLocation:Boolean;
		private var joined:String;
		private var isGuest:Boolean = false;
		private var points:int = -1;
		private var level:LevelRef;
		private var prefs:Object;
		private var showUserNames:Boolean;
		private var showHelp:Boolean;
		private var muteSounds:Boolean = false;
		private var lat:Number;
		private var long:Number;
		private var isMuted:Boolean;
		private var accountId:Number;
		private var userType:int;
		private var showAvatarUpdates:Boolean;
		private var showToolUpdates:Boolean;
		private var accountType:int;
		private var phone:String;
		private var phoneExt:String;
		private var phoneIntlPrefix:String;
		private var phoneLabel:String;
		private var phone2:String;
		private var phone2Ext:String;
		private var phone2IntlPrefix:String;
		private var phone2Label:String;
		private var phone3:String;
		private var phone3Ext:String;
		private var phone3IntlPrefix:String;
		private var phone3Label:String;
		private var showPhone:Boolean;
		private var title:String = "";
		private var email:String;
		private var imageIdx:int;
		private var company:String;
		private var firstName:String;
		private var lastName:String;
		private var about:String;
		private var isActiveTalker:Boolean;
		private var dialinOnly:Boolean;
		private var breakout:Boolean;
		private var showVcard:Boolean;
		private var streaming:Boolean;
		private var onSoftPhone:Boolean;
		private var gmtOffset:Number;
		private var temp:int = User.DISABLED_TEMP;
		private var currentCondition:String;
		private var weatherForecastUrl:String;
		private var trial:Boolean; //whether or not the user is currently on a trial offer
		private var isDVR:Boolean = false;
		private var _contacts:ContactManager;
		private var _countryCode:String;
		private var _region:String;
		private var _lang:String;
		private var _cabinetToken:String;
		
		private var _updateImage:Boolean = false;
		
		private var merged:Boolean;
		private var useImage:int;
		//0 - use whatever is on server
		//1 - use default image
		//2 - use group
		private var loading:Boolean;
		private var speakLevel:int;
		private var listenLevel:int;
		private var isUnknown:Boolean;
		private var smsPhone:String;
		
		private var userPhoneNums:Array;
		
		public static const OUTLOOK:int = 1;
		public static const MONITOR:int = 2;
		private var appDownloads:int;
		
		private var notifyEmail:String;
		
		private var isBooted:Boolean = false;
		
		//Used for thigns like away, question etc.
		private var state:String;
		
		private var offerExpired:Boolean;
		private var _cubeApplications:Dictionary;
		
		private var _appRefs:Dictionary; //key is AppRef::assetId
		
		private static var _ALLOW_INSTANTIATION:Boolean = false;
		
		private static var _USERS:Dictionary = new Dictionary(true);
		private var _profilePicUri:String;
		
		public function User( ref:UserRef ) {
			if (!_ALLOW_INSTANTIATION) throw new Error("User instantiation not allowed.  Use User.getUser(ref:UserRef)");
			
			this.ref = ref;
			this.isMuted = false;
			if ( ref != null ) this.initFromRef( ref );
			addListeners();
			_USERS[id] = this;
		}
		
		/**
		 * Either returns(and updates) or creates a User object based on the UserRef parameter
		 * The method will look for and existing User based on the UserRef.getId() method
		 * @param	ref The UserRef object used to create/update the User object
		 * @return  the newly created/updated User Object
		 */
		public static function getUser(ref:UserRef, update:Boolean = true):User
		{
			var id:Number = ref.getId();
			log.debug("Looking up user with id: " + id);
			if (_USERS[id])
			{
				log.debug("Returning existing");
				if ( ref != null && update) (_USERS[id] as User).initFromRef(ref);
				return _USERS[id];
			}
			log.debug("Creating new");
			_ALLOW_INSTANTIATION = true;
			var user:User = new User(ref);
			_ALLOW_INSTANTIATION = false;
			return user;
		}
		
		/**
		 * Returns an existing User object based on the given id parameter
		 * @param	id The id to use to look up the User object
		 * @return  The requested User object, or null if none exists w/ the supplied id
		 */
		public static function getUserById(id:Number):User
		{
			if (_USERS[id])
			{
				return _USERS[id];
			}
			return null;
		}
		
		public function toString( ) :String {
			var s:String = "[User]";
			s+= "id: " + this.id;
			s+= ", temp: " + this.temp;
			s+= ", screenName: " + this.screenName;
			s+= ", name: " + this.name;
			s+= ", age: " + this.age;
			s+= ", gender: " + this.gender;
			s+= ", location: " + this.location;
			s+= ", joined: " + this.joined;
			s+= ", isGuest: " + this.isGuest;
			s+= ", points: " + this.points;
			s+= ", imageIdx: " + this.imageIdx;
			s+= ", dialinOnly: " + this.dialinOnly;
			s+= ", level: " + this.level;
			s+= ", company: " + this.company;
			s += ", title: " + this.title;
			s += ", autoLocate: " + this.autoLocation;
			s+= ", ref company: " + this.ref.getCompany();
			s+= ", ref title: " + this.ref.getTitle();
			return s;
		}
			
		private function initFromRef( ref:UserRef ) :void {
			log.debug("initFromRef: " + ref);
			this.id = ref.getId();
			this.screenName = ref.getScreenName();
			this.age = ref.getAge();
			this.lat = ref.getLat();
			this.long = ref.getLng();
			this.gender = ref.getGender();
			this.joined = ref.getJoined();
			this.isGuest = ref.getIsGuest();
			this.points = ref.getPoints();
			this.prefs = ref.getPrefs();
			this.showHelp = ref.getShowHelp();
			this.showUserNames = ref.getShowUserNames();
			this.muteSounds = ref.getMuteSounds();
			this.accountId = ref.getAccountId();
			this.userType = ref.getUserType();
			this.showAvatarUpdates = ref.getShowAvatarUpdates();
			this.showToolUpdates = ref.getShowToolUpdates();
			this.accountType = ref.getAccountType();
			this.phone = ref.getPhone();
			this.phoneExt = ref.getPhoneExt();
			this.phoneIntlPrefix = ref.getPhoneIntlPrefix();
			this.phoneLabel = ref.getPhoneLabel();
			this.phone2 = ref.getPhone2();
			this.phone2Ext = ref.getPhone2Ext();
			this.phone2IntlPrefix = ref.getPhone2IntlPrefix();
			this.phone2Label = ref.getPhone2Label();
			this.phone3 = ref.getPhone3();
			this.phone3Ext = ref.getPhone3Ext();
			this.phone3IntlPrefix = ref.getPhone3IntlPrefix();
			this.phone3Label = ref.getPhone3Label();
			this.showPhone = ref.getShowPhone();
			this.title = ref.getTitle();
			this.imageIdx = ref.getImageIdx();
			this.useImage = ref.getImageType();
			this.company = ref.getCompany();
			this.firstName = ref.getFirstName();
			this.lastName = ref.getLastName();
			this.email = ref.getEmail();
			this.location = ref.getLocation();
			this.weatherLink = ref.getWeatherLink();
			this.dialinOnly = ref.getDialinOnly();
			this.ref = ref;
			this.name = Util.trimText(getFirstName()) + " " + Util.trimText(getLastName());
			this.breakout = ref.getBreakout();
			this.showVcard = ref.getShowVcard();
			this.streaming = ref.getStreaming();
			this.merged = ref.getMerged();
			this.about = ref.getAbout();
			this.onSoftPhone = ref.getOnSoftphone();
			this.loading = ref.getLoading();
			this.speakLevel = ref.getSpeakLevel();
			this.listenLevel = ref.getListenLevel();
			this.smsPhone = ref.getSMSPhone();
			this.autoLocation = ref.getAutolocate();
			//this.canDialInternational = ref.getInternationalDial();
			this.notifyEmail = ref.getNotifyEmail();
			this.userPhoneNums = ref.getUserPhoneRefs();
			this.offerExpired = ref.getOfferExpired();
			this.trial = ref.getTrial();
			this._countryCode = ref.getCountryCode();
			this._region = ref.getRegion();
			this._lang = (ref.lang != null)?ref.lang:"en-us";
			if (_cabinetToken == null || _cabinetToken.length == 0) _cabinetToken = ref.cabinetToken;
			
			var sep:Array;
			if ( this.firstName == "Unknown Caller" || this.firstName == "Dial In Host")
			{
				this.isUnknown = true;
			} else {
				this.isUnknown = false;
			}
			//For Live "Unknown Caller" is kind of a bad name, we're going to rename them to just "Speaker"
			if(ContextManager.getInstance().isIMeetLive() && ( this.firstName == "Unknown Caller" || this.firstName == "Dial In Host")){
				this.firstName = "Speaker";
			}
			
			//TODO need to find a better way to not overwrite gmtOffset if it's a "bad" value
			if (isNaN(this.gmtOffset) || !(this.gmtOffset != 0 && ref.getUTCOffsetMillis() == 0)) this.gmtOffset = ref.getUTCOffsetMillis();
			
			//new weather
			if (ref.weatherRef && ref.weatherRef.curCond)
			{
				this.currentCondition = ref.weatherRef.curCond;
				this.weatherForecastUrl = ref.weatherRef.forecastUrl;
			}
			if (ref.weatherRef && ref.weatherRef.temp)
			{
				this.temp = parseInt(ref.weatherRef.temp);
			}
			
			
			this.appDownloads = ref.getDownloads();
			
			//determine DVR-bot flag based on user email address
			var reg:RegExp =/dvr-*\d+@pgi.com/i;
			this.isDVR = reg.test(this.email);
			
			if (!_profilePicUri && ref.pictureUri) _profilePicUri = ref.pictureUri;  //if profilePicUri has already been set, don't overwrite it with a null value
			//if (_profilePicUri && _profilePicUri != "") this.setImageType(2);
			
			var event:HalcyonEvent;
			if (AvatarManager.getInstance().getMyUser()!=null && this.id == AvatarManager.getInstance().getMyUser().getId())
			{
				event = new HalcyonEvent(MY_USER_UPDATED);
			} else
			{
				event = new HalcyonEvent(USER_UPDATED);
			}
			event.setExtra(this);
			EventManager.getInstance().dispatchEvent(event);
			
			//log.debug("the bandwidth details are: " + this.prefs[UserPrefs.BANDWIDTH]);
		}
		
		private function onParticipantExited(e:Event):void
		{
			
			var event:HalcyonEvent = e as HalcyonEvent;
			var user:User = (event.getExtra().participant as RealmUser).getUser();
			if (user.getId() == this.id)
			{
				this.removeListeners();
				delete this;
			}
		}
		
		private function addListeners():void
		{
			var eventManager:EventManager = EventManager.getInstance();
			eventManager.addEventListener(ActiveTalkerBrd.EVENT_ID, onActiveTalker);
			eventManager.addEventListener(Application.ADD_APP_TO_CUBE, onAddApp);
			eventManager.addEventListener(AvatarManager.PARTICIPANT_EXITED, onParticipantExited);
			eventManager.addEventListener(BandwidthEvent.BANDWIDTH_AVG, onBandwidthAvgEvent);
			eventManager.addEventListener(BandwidthEvent.SHOW_BANDWIDTH, onShowBandwidthEvent);
			eventManager.addEventListener(Babelfish.EVENT_TRANSLATIONS_READY, onLanguageChange);
			eventManager.addEventListener(FileshareFullscreenManager.ANNOTATION_EVENT, onAnnotationEvent);
			eventManager.addEventListener(PrefStatBrd.EVENT_ID, onPrefStatBrd);
		}
		
		private function onPrefStatBrd(e:Event):void
		{
			log.debug("onPrefStatBrd");
		}
		
		
		private function removeListeners():void
		{
			var eventManager:EventManager = EventManager.getInstance();
			eventManager.removeEventListener(ActiveTalkerBrd.EVENT_ID, onActiveTalker);
			eventManager.removeEventListener(Application.ADD_APP_TO_CUBE, onAddApp);
			eventManager.removeEventListener(AvatarManager.PARTICIPANT_EXITED, onParticipantExited);
			eventManager.removeEventListener(BandwidthEvent.BANDWIDTH_AVG, onBandwidthAvgEvent);
			eventManager.removeEventListener(BandwidthEvent.SHOW_BANDWIDTH, onShowBandwidthEvent);
			eventManager.removeEventListener(Babelfish.EVENT_TRANSLATIONS_READY, onLanguageChange);
			eventManager.removeEventListener(FileshareFullscreenManager.ANNOTATION_EVENT, onAnnotationEvent);
			eventManager.removeEventListener(PrefStatBrd.EVENT_ID, onPrefStatBrd);
		}
		
		public function update(ref:UserRef):void{
			log.debug("User update:" + this.id );
			initFromRef(ref);
		}
		
		private function onLanguageChange(e:HalcyonEvent):void
		{
			if (this.id == AvatarManager.getInstance().getMyUser().getId())
			{
				this.setLang(Babelfish.getInstance().currentLang);
				this.sendUpdate();
			}
		}
		
		private function onAddApp(e:HalcyonEvent):void
		{
			var extra:Object = e.getExtra();
			if (extra.userId != this.id) return;
			
			if (!_cubeApplications) _cubeApplications = new Dictionary();

			var application:Application = extra.application as Application;
			var state:Object = application.getState();
			_cubeApplications[application.toString()] = state;
		}
		
		private function onActiveTalker(e:Event):void{
			var event:HalcyonEvent = e as HalcyonEvent;
			var brd:ActiveTalkerBrd = event.getExtra() as ActiveTalkerBrd;
			
			this.isActiveTalker = false;
			for(var i:int = 0; i < brd.getUserIds().length; i++){
				if(brd.getUserIds()[i] == this.id){
					this.isActiveTalker = true;
				}
			}
		}
		
		private function onShowBandwidthEvent(e:BandwidthEvent):void
		{
			this.prefs[UserPrefs.SHOW_BANDWIDTH] = (e.show)?"true":"false";
			this.ref.setPrefs(prefs);
			this.sendUpdate();
		}
		
		private function onBandwidthAvgEvent(e:BandwidthEvent):void {
			
			this.prefs[UserPrefs.BANDWIDTH] = e.avgStats;
			this.ref.setPrefs(prefs);
			this.sendUpdate();
		}
		
		private function onAnnotationEvent(e:HalcyonEvent):void
		{
			this.prefs[UserPrefs.GUEST_ANNOTATIONS] = (e.getExtra()["hostOnly"] as Boolean).toString();
			this.ref.setPrefs(prefs);
			this.sendUpdate();
		}
		
		
		
		/**
		 * Sends an UpdateUserReq message to the server
		 */
		public function sendUpdate():void
		{
			var req:UpdateUserReq = new UpdateUserReq();
			req.setUserRef(this.ref);
			log.debug("sendUpdate Request - flashver=" + this.ref.prefs[UserPrefs.FLASH_VER]);
			req.updateImage = _updateImage;
			Session.getInstance().sendMessage(req);
			_updateImage = false;
		}
		
		//Getters setters
			
		public function getScreenName():String {
			return screenName;
		}
	
		public function setScreenName(screenName:String):void {
			this.screenName = screenName;
			this.ref.setScreenName(screenName);
		}
	
		public function getId():Number {
			return id;
		}
	
		public function setId(id:Number):void {
			this.id = id;
		}
	
		public function getName():String {
			return Util.trimText(getFirstName()) + " " + Util.trimText(getLastName());
		}
	
		public function setName(name:String):void {
			this.name = name;
		}
		
		public function getGender():String {
			return gender;
		}
		
		public function setGender(gender:String):void{
			this.gender = gender;
			this.ref.setGender(gender);
		}
	
		public function getLocation():String {
			if (this.location == null || this.location == "null") return "";
			return location;
		}
		
		public function getWeatherLink():String{
			return weatherLink;
		}
		
		public function setLocation(location:String):void{
			this.location = location;
			this.ref.setLocation(location);
		}
	
		public function getAge():int {
			return age;
		}
		
		public function setAge(age:int):void{
			this.age = age;
		}
	
		public function getJoined():String {
			return joined;
		}
	
		public function getIsGuest():Boolean {
			return isGuest;
		}
	
		public function isSystemUser():Boolean {
			return id == User.SYSUSER_ID;
		}
		
		public function getIsDVR():Boolean
		{
			return this.isDVR;
		}
		
		static public function getSystemUserId():int {
			return User.SYSUSER_ID;
		}
		
		public function getPoints():int {
			return points;
		}
	
		public function setPoints(points:int):void {
			this.points = points;
		}
		
		public function getPrefs():Object{
			if(prefs == null){
				return new Object();
			}
			return this.prefs;
		}
		
		public function setPrefs(prefs:Object):void{
			this.prefs = prefs;
			ref.setPrefs(prefs);
		}
		
		/*
		public function getRealmId():int {
			return realmId;
		}
		*/
	
		public function getLevel():LevelRef {
			return level;
		}
	
		public function getLastNudge():int {
			return lastNudge;
		}
	
		public function setLastNudge(lastNudge:int):void {
			this.lastNudge = lastNudge;
		}
		
		public function getShowUserNames():Boolean{
			return this.showUserNames;
		}
		
		public function setShowUserNames(showUserNames:Boolean):void{
			this.showUserNames = showUserNames;
			ref.setShowUserNames(showUserNames);
		}
		
		public function getShowHelp():Boolean{
			return this.showHelp;
		}
		
		public function setShowHelp(showHelp:Boolean):void{
			this.showHelp = showHelp;
			ref.setShowHelp(showHelp);
		}
		
		public function getMuteSounds():Boolean{
			return this.muteSounds;
		}
		
		public function setMuteSounds(muteSounds:Boolean):void{
			this.muteSounds = muteSounds;
			ref.setMuteSounds(muteSounds);
		}
		
		public function getLat():Number{
			return this.lat;
		}
		
		public function getLong():Number{
			return this.long;
		}
		
		public function setLat(lat:Number):void{
			this.lat = lat;
			this.ref.setLat(lat);
		}
		
		public function setLng(lng:Number):void{
			this.long = lng;
			this.ref.setLng(lng);
		}
		
		public function getRef():UserRef{
			return this.ref;
		}
		
		public function setMute(mute:Boolean):void{
			this.isMuted = mute;
		}
		
		public function getMute():Boolean{
			return this.isMuted;
		}
		
		public function getShowAvatarUpdates():Boolean{
			return this.showAvatarUpdates;
		}
		
		public function setShowAvatarUpdates(showAvatarUpdates:Boolean):void{
			this.showAvatarUpdates = showAvatarUpdates;
			ref.setShowAvatarUpdates(showAvatarUpdates);
		}
		
		public function getShowToolUpdates():Boolean{
			return this.showToolUpdates;
		}
		
		public function setShowToolUpdates(showToolUpdates:Boolean):void{
			this.showToolUpdates = showToolUpdates;
			ref.setShowToolUpdates(showToolUpdates);
		}
		
		public function getAccountType():int{
			return this.accountType;
		}
		
		public function getUserType():int{
			return this.userType;
		}
		
		public function getPhone():String{
			return PhoneUtil.formatPhone(this.phone, this.phoneIntlPrefix);
		}
		
		public function setPhone(phone:String):void{
			this.phone = phone;
			this.ref.setPhone(phone);
		}
		
		public function getPhoneExt():String{
			if(this.phoneExt == null || this.phoneExt == "null") return "";
			return this.phoneExt;
		}
		
		public function setPhoneExt(phoneExt:String):void{
			this.phoneExt = phoneExt;
			ref.setPhoneExt(phoneExt);
		}
		
		public function getPhoneLabel():String{
			if(this.phoneLabel == null || this.phoneLabel == "null") return "";
			return this.phoneLabel;
		}
		
		public function setPhoneLabel(phoneLabel:String):void{
			this.phoneLabel = phoneLabel;
			ref.setPhoneLabel(phoneLabel);
		}
		
		public function getPhone2():String{
			return PhoneUtil.formatPhone(this.phone2, this.phone2IntlPrefix);
		}
		
		public function setPhone2(phone2:String):void{
			this.phone2 = phone2;
			ref.setPhone2(phone2);
		}
		
		public function getPhone2Ext():String{
			return this.phone2Ext;
		}
		
		public function setPhone2Ext(phone2Ext:String):void{
			this.phone2Ext = phone2Ext;
			ref.setPhone2Ext(phone2Ext);
		}
		
		public function getPhone2Label():String{
			if(this.phone2Label == null || this.phone2Label == "null") return "";
			return this.phone2Label;
		}
		
		public function setPhone2Label(phone2Label:String):void{
			this.phone2Label = phone2Label;
			ref.setPhone2Label(phone2Label);
		}
		
		public function getPhone3():String{
			return PhoneUtil.formatPhone(this.phone3, this.phone3IntlPrefix);
		}
		
		public function setPhone3(phone3:String):void{
			this.phone3 = phone3;
			ref.setPhone3(phone3);
		}
		
		public function getPhone3Ext():String{
			return this.phone3Ext;
		}
		
		public function setPhone3Ext(phone3Ext:String):void{
			this.phone3Ext = phone3Ext;
			ref.setPhone3Ext(phone3Ext);
		}
		
		public function getPhone3Label():String{
			if(this.phone3Label == null || this.phone3Label == "null") return "";
			return this.phone3Label;
		}
		
		public function setPhone3Label(phone3Label:String):void{
			this.phone3Label = phone3Label;
			ref.setPhone3Label(phone3Label);
		}

		public function getShowPhone():Boolean{
			return this.showPhone;
		}
		
		public function setShowPhone(showPhone:Boolean):void{
			this.showPhone = showPhone;
			ref.setShowPhone(showPhone);
		}
		
		public function getTitle():String{
			if(this.title == null) return "";
			return this.title;
		}
		
		public function setTitle(title:String):void{
			this.title = title;
			ref.setTitle(title);
		}
		
		public function getEmail():String{
			if(this.email == null) return "";
			if(this.email == "null") return "";
			return this.email;
		}
		
		public function setEmail(email:String):void{
			this.email = email;
			this.ref.setEmail(email);
		}
		
		public function getImageIdx():int{
			return this.imageIdx;
		}
		
		public function setImageIdx(imageIdx:int):void{
			this.imageIdx = imageIdx;
		}
		
		public function setImageType(useImage:int):void{
			this.useImage = useImage;
			ref.setImageType(useImage);
		}
		
		public function getImageType():int{
			return this.useImage;
		}
		
		public function setCompany(company:String):void{
			this.company = company;
			ref.setCompany(company);
		}
		
		public function getCompany():String{
			if(this.company == null) return "";
			return this.company;
		}
		
		public function getFirstName():String{
			if(this.firstName == null || this.firstName == "null") return "";
			return this.firstName;
		}
		
		public function setFirstName(firstName:String):void{
			this.firstName = firstName;
			ref.setFirstName(firstName);
		}
		
		public function getAbout():String{
			if(this.about == null || this.about == "null") return "";
			return this.about;
		}
		
		public function setAbout(about:String):void{
			this.about = about;
			ref.setAbout(about);
		}
		
		public function getLastName():String{
			if(this.lastName == null || this.lastName == "null") return "";
			return this.lastName;
		}
		
		public function setLastName(lastName:String):void{
			this.lastName = lastName;
			this.ref.setLastName(lastName);
		}
		
		public function getIsActiveTalker():Boolean{
			return this.isActiveTalker;
		}
		
		public function getDialinOnly():Boolean{
			return this.dialinOnly
		}
		
		public function getIsOnConference():Boolean{
			//log.debug("Call Status: " + ref.getCallStatus() + " is Present result: " + ((this.ref.getCallStatus() & UserRef.CALL_STATUS_PRESENT) > 0));
			return (this.ref.getCallStatus() & UserRef.CALL_STATUS_PRESENT) > 0;
		}
		
		public function getIsMuted():Boolean{
			return (this.ref.getCallStatus() & UserRef.CALL_STATUS_MUTED) > 0;
		}
		
		public function getBreakout():Boolean{
			return this.breakout;
		}
		
		public function setBreakout(breakout:Boolean):void{
			//log.debug("**************************** setBreakout: "+breakout.toString());
			this.breakout = breakout;
		}
		
		public function getShowVcard():Boolean{
			return this.showVcard;
		}
		
		public function setShowVcard(showVcard:Boolean):void{
			this.showVcard = showVcard;
			ref.setShowVcard(showVcard);
		}
		
		public function getStreaming():Boolean{
			return this.streaming;
		}
		
		public function setStreaming(streaming:Boolean):void{
			this.streaming = streaming;
			this.ref.setStreaming(streaming);
		}
		
		public function getGMTOffset():Number{
			return this.gmtOffset;
		}
		
		public function getTemp():int{
			return this.temp;
		}
		
		public function getCurrentCondition():String{
			return this.currentCondition;
		}
		
		public function getForecastUrl():String{
			return this.weatherForecastUrl;
		}
		
		public function getMerged():Boolean{
			return this.merged;
		}
		
		public function setMerged(merged:Boolean):void{
			this.merged = merged;
		}
		
		public function getOnSoftPhone():Boolean{
			return this.onSoftPhone;
		}
		
		public function getLoading():Boolean{
			return this.loading;
		}
		
		public function setLoading(value:Boolean):void{
			this.loading = value;
			this.ref.setLoading(value);
		}
		
		public function getListenLevel():int{
			return this.listenLevel;
		}
		
		public function getSpeakLevel():int{
			return this.speakLevel;
		}
		
		public function getIsUnknownCaller():Boolean{
			return this.isUnknown;
		}
		
		public function getCurrentPhotoURI():String{
			var randNum:Date = new Date();
			return ClientUrls.getInstance().buildSiteUrl(ClientUrls.USER_IMAGE  + "?id=" + getId()+"&idx="+ getImageIdx().toString() + "&r=" + randNum.valueOf());
		}
		
		public function getPhotoURI(idx:int):String{
			var randNum:Date = new Date();
			return ClientUrls.getInstance().buildSiteUrl(ClientUrls.USER_IMAGE  + "?id=" + getId()+"&idx="+ idx + "&r=" + randNum.valueOf());
		}
		
		public function getSMSPhone():String{
			return this.smsPhone
		}
		
		public function setSMSPhone(smsPhone:String):void{
			this.smsPhone = smsPhone;
			this.ref.setSMSPhone(smsPhone);
		}
		
		public function getOutlookDownloaded():Boolean{
			return this.appDownloads > 0;
		}
		
		public function getMonitorDownloaded():Boolean{
			return this.appDownloads > 0;
		}
		
		public function getAutoLocation():Boolean{
			return this.autoLocation;
		}
		
		public function setAutolocate(autoLocate:Boolean):void{
			this.autoLocation = autoLocate;
			this.ref.setAutolocate(this.autoLocation);
		}
		
		public function getNotifyEmail():String{
			return this.notifyEmail;
		}
		
		public function setNotifyEmail(notifyEmail:String):void{
			this.notifyEmail = notifyEmail;
		}
		
		public function setState(state:String):void{
			this.state = state;
		}
		
		public function getState():String{
			return this.state;
		}
		
		public function getPhoneIntlPrefix():String{
			return this.phoneIntlPrefix;
		}
		
		public function setPhoneIntlPrefix(phoneIntlPrefix:String):void{
			this.phoneIntlPrefix = phoneIntlPrefix;
			ref.setPhoneIntlPrefix(this.phoneIntlPrefix);
		}
		
		public function getPhone1IntlPrefixId():Number{
			if (this.ref.getDialoutNumberId()) return this.ref.getDialoutNumberId();
			return (this.prefs.internationalPrefix1Id != null)?this.prefs.internationalPrefix1Id: -1;
		}
		
		/**
		 * Set the dialout number id for phone1
		 * use -1 for null
		 * @param	id
		 */
		public function setPhone1IntlPrefixId(id:Number = NaN):void {
			if (isNaN(id)) id = -1;
			this.ref.setDialoutNumberId(id);
			this.prefs.internationa2Prefix1Id = id.toString();
		}
		
		public function getPhone2IntlPrefix():String{
			return this.phone2IntlPrefix;
		}
		
		public function setPhone2IntlPrefix(phone2IntlPrefix:String):void{
			this.phone2IntlPrefix = phone2IntlPrefix;
			ref.setPhone2IntlPrefix(this.phone2IntlPrefix);
		}
		
		public function getPhone2IntlPrefixId():Number{
			if (this.ref.getDialoutNumberId2()) return this.ref.getDialoutNumberId2();
			return (this.prefs.internationalPrefix2Id != null)?this.prefs.internationalPrefix2Id: -1;
		}
		
		/**
		 * Set the dialout number id for phone2
		 * use -1 for null
		 * @param	id
		 */
		public function setPhone2IntlPrefixId(id:Number=NaN):void{
			if (isNaN(id)) id = -1;
			this.ref.setDialoutNumberId2(id);
			this.prefs.internationalPrefix2Id = id.toString();
		}
		
		public function getPhone3IntlPrefix():String{
			return this.phone3IntlPrefix;
		}
		
		public function setPhone3IntlPrefix(prefix:String):void{
			this.phone3IntlPrefix = prefix;
			ref.setPhone3IntlPrefix(this.phone3IntlPrefix);
		}
		
		public function getPhone3IntlPrefixId():Number {
			if (this.ref.getDialoutNumberId3()) return this.ref.getDialoutNumberId3();
			return (this.prefs.internationalPrefix3Id != null)?this.prefs.internationalPrefix3Id: -1;
		}
		
		/**
		 * Set the dialout number id for phone3
		 * use -1 for null
		 * @param	id
		 */
		public function setPhone3IntlPrefixId(id:Number=NaN):void{
			if (isNaN(id)) id = -1;
			this.ref.setDialoutNumberId3(id);
			this.prefs.internationalPrefix3Id = id.toString();
		}
		
		public function getPreviousUserPhoneNums():Array{
			return this.userPhoneNums;
		}
		
		public function setPreviousUserPhoneNums(userPhoneRefs:Array):void{
			this.userPhoneNums = userPhoneRefs;
			this.ref.setUserPhoneRefs(userPhoneRefs);
		}
		
		
		public function getOfferExpired():Boolean{
			return this.offerExpired;
		}
		
		public function setOfferExpired(offerExpired:Boolean):void{
			this.offerExpired = offerExpired;
			this.ref.setOfferExpired(offerExpired);
		}
		
		/**
		 * Gets the value of the celcius user pref
		 * @return
		 */
		public function getShowCelsius():Boolean
		{
			//if the pref doesn't exist set the the default value
			//false for NA, true of all other regions
			var defaultValue:Boolean = (this.getRegion() == "NA")?false:true;
			return (prefs["celsius"] != null)?(prefs["celsius"] as String).toLowerCase()=="true":defaultValue;
		}

		/**
		 * Sets the value of the celcius user pref
		 * @param	value
		 */
		public function setShowCelsius(value:Boolean):void
		{
			prefs["celsius"] = value.toString();
		}
		
		/**
		 * Gets the value of the celcius user pref
		 * @return
		 */
		public function getShow24HourClock ():Boolean
		{
			var defaultValue:Boolean = (this.getRegion() == "NA")?false:true;
			return (prefs["24hourclock"] != null)?(prefs["24hourclock"] as String).toLowerCase()=="true":defaultValue;
		}

		/**
		 * Sets the value of the celcius user pref
		 * @param	value
		 */
		public function setShow24HourClock(value:Boolean):void
		{
			prefs["24hourclock"] = value.toString();
		}
		
		/**
		 * Gets the value of the skipInfoPrompt user pref
		 * @return
		 */
		public function getSkipInfoPrompt():Boolean
		{
			return (prefs["skip_info_prompt"] != null)?(prefs["skip_info_prompt"] as String).toLowerCase()=="true":false;
		}

		/**
		 * Sets the value of the skipInfoPrompt user pref
		 * @param	value
		 */
		public function setSkipInfoPrompt(value:Boolean):void
		{
			prefs["skip_info_prompt"] = value.toString();
		}
		
		/**
		 * Whether or not the user is currently in a trial offer period
		 * @return true if in "free trial" mode
		 */
		public function isTrial():Boolean { return this.trial; }
		
		public function isProfilePhoneNumber(phoneNum:String):Boolean{
			return PhoneUtil.matches(phoneNum,this.phone) || PhoneUtil.matches(phoneNum,this.phone2) || PhoneUtil.matches(phoneNum,this.phone3);
		}
		
		public function getIsBooted():Boolean{
			return this.isBooted;
		}
		
		public function setIsBooted(isBooted:Boolean):void{
			this.isBooted = isBooted;
		}
		
		/**
		 * Get the ContactManager for the User
		 * @return ContactManager of the User
		 */
		public function getContacts():ContactManager
		{
			if (!_contacts) _contacts = ContactManager.getContactManager(this.id);
			return _contacts;
		}
		
		/**
		 * Returns whether or not the user is a "spectator"
		 * Primarily for iMeet Live
		 * @return True if the user is of role type Spectator
		 */
		public function getIsSpectator():Boolean {
			if (this.isDVR) return false;
			var isSpec:Boolean;
			try
			{
				isSpec = AvatarManager.getInstance().getPlayerById(this.id).getIsSpectator();
			} catch (e:Error) {
				isSpec = false;
			}
			return isSpec;
		}
		
		/**
		 * User's ISO 3166-1 alpha-3 country code
		 * @return Three-Letter country code
		 */
		public function getCountryCode():String
		{
			return _countryCode;
		}
		
		/**
		 * Set the User's ISO 3166-1 alpha-3 country code
		 * @param	new Three-letter country code
		 */
		public function setCountryCode(value:String):void
		{
			_countryCode = value;
		}
		
		/**
		 * Retrieve the user's geo region
		 * NA, LA, EMEA, AP
		 * @return The user's geo region
		 */
		public function getRegion():String
		{
			return (_region == "North America")?"NA":_region;
		}
		
		public function getFurl():String { return this.ref.getFurl(); }
		
		public function getPartId():String
		{
			return ref.getPartId();
		}
		
		/**
		 * Retrieves a Dictionary object of the cube applications attached to the User
		 * The key of the Dictionary is the appID, and the value is a reference to
		 * com.halcyon.core.application.Application
		 * @return Dictionary Object of Cube Applications
		 */
		public function get cubeApplications():Object
		{
			return _cubeApplications;
		}
		
		public function get cabinetToken():String
		{
			return _cabinetToken;
		}
	
		public function getLang():String
		{
			return _lang;
		}
		
		public function setLang(newLang:String):void
		{
			_lang = newLang;
			this.ref.lang = newLang;
		}
		
		
		public function addAppRef(appRef:AppRef):void
		{
			if (!_appRefs) _appRefs = new Dictionary();
			_appRefs[appRef.getAssetId()] = appRef;
		}
		
		public function getAppRef(assetId:Number):AppRef
		{
			return (_appRefs)?_appRefs[assetId]:null;
		}
		
		public function getAppRefByName(appName:String):AppRef
		{
			for each (var item:AppRef in _appRefs)
			{
				if (item.getName() == appName) return item;
			}
			return null;
		}

		public function getAppRefs():Dictionary
		{
			return _appRefs;
		}
		

		public function getLinkedProfilePicUrl():String
		{
			return _profilePicUri;
		}
		
		/**
		 * Whether or not the user logged in via a social network login
		 * i.e. Facebook or LinkedIn
		 * @return True if user logged in via Facebook or LinkedIn
		 */
		public function isSocialUser():Boolean
		{
			return (Boolean(this.userType & USER_TYPE_FACEBOOK) || Boolean(this.userType & USER_TYPE_LINKEDIN));
		}
		
		/**
		 * Sets the state of the user's password - whether
		 * or not one exists
		 * @param	hasPassword True if the user has a password
		 */
		public function setHasPassword(hasPassword:int):void
		{
			_hasPassword = Boolean(hasPassword);
		}
		
		private var _hasPassword:Boolean = false;
		/**
		 * Returns the state of the User's password
		 * If false, it means they are a guest who has not
		 * yet entered a password
		 */
		public function get hasPassword():Boolean { return _hasPassword; }
		
		public function get updateImage():Boolean
		{
			return _updateImage;
		}
		
		public function set updateImage(value:Boolean):void
		{
			_updateImage = value;
		}
		
		public function isHost():Boolean
		{
			return (Boolean(this.userType & USER_TYPE_REGULAR));
		}
	}
}