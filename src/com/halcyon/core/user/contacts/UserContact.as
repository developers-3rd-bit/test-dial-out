package com.halcyon.core.user.contacts 
{
	import com.halcyon.interfaces.user.IUserContact;
	//import com.halcyon.util.utilities.PhoneUtil;
	/**
	 * ...
	 * @author JCC
	 */
	public class UserContact implements IUserContact
	{
		private var _fname:String;
		private var _lname:String;
		private var _email:String;
		private var _phoneNum:String;
		private var _phoneExt:String;
		private var _phoneIntlPrefix:String;
		private var _title:String;
		private var _organization:String;
		private var _id:Number;
		private var _furl:String;
		private var _clientId:Number; //for synching w/ actual iMeet users
		private var _imageIDX:int = -1;
		private var _imageType:int = 0;
		
		public function UserContact(fName:String="", lName:String="", email:String="", phoneNum:String="", phoneExt:String="", phoneIntlPrefix:String="",title:String="", organization:String="", id:Number=-1,clientId:Number=-1)
		{
			_phoneNum = phoneNum;
			_fname = fName;
			_lname = lName;
			_email = email;
			_phoneNum = phoneNum;
			_phoneExt = phoneExt;
			_phoneIntlPrefix = phoneIntlPrefix;
			_clientId = clientId;
			_organization = organization;
			_title = title;
			_id = id;
		}
		
		public function get fname():String 
		{
			return _fname;
		}
		
		public function set fname(value:String):void 
		{
			_fname = value;
		}
		
		public function get lname():String 
		{
			return _lname;
		}
		
		public function set lname(value:String):void 
		{
			_lname = value;
		}
		
		public function get email():String 
		{
			return _email;
		}
		
		public function set email(value:String):void 
		{
			_email = value;
		}
		
		public function get phoneNum():String 
		{
			return (_phoneNum!=null)?_phoneNum:"";
		}
		
		public function set phoneNum(value:String):void 
		{
			_phoneNum = value;
		}
		
		public function get phoneExt():String 
		{
			return (_phoneExt!=null)?_phoneExt:"";
		}
		
		public function set phoneExt(value:String):void 
		{
			_phoneExt = value;
		}
		
		public function get phoneIntlPrefix():String 
		{
			return (_phoneIntlPrefix!=null)?_phoneIntlPrefix:"";
		}
		
		public function set phoneIntlPrefix(value:String):void 
		{
			_phoneIntlPrefix = value;
		}
		
		public function get formatedPhoneNum():String 
		{ 
			//var phoneString:String = PhoneUtil.formatPhone(_phoneNum);
         var phoneString:String = _phoneNum;
			if (_phoneIntlPrefix != "" && _phoneIntlPrefix != null) phoneString = _phoneIntlPrefix +" " + phoneString;
			return phoneString;
		}
		
		public function get clientId():Number 
		{
			return _clientId;
		}
		
		public function set clientId(value:Number):void 
		{
			_clientId = value;
		}
		
		public function get id():Number 
		{
			return _id;
		}
		
		public function set id(value:Number):void 
		{
			_id = value;
		}
		
		public function get title():String 
		{
			return (_title!=null)?_title:"";
		}
		
		public function set title(value:String):void 
		{
			_title = value;
		}
		
		public function get organization():String 
		{
			return (_organization!=null)?_organization:"";
		}
		
		public function set organization(value:String):void 
		{
			_organization = value;
		}
		
		public function get furl():String 
		{
			return _furl;
		}
		
		public function set furl(value:String):void 
		{
			_furl = value;
		}
		
		public function get imageIDX():int 
		{
			return _imageIDX;
		}
		
		public function set imageIDX(value:int):void 
		{
			_imageIDX = value;
		}
		
		public function get imageType():int 
		{
			return _imageType;
		}
		
		public function set imageType(value:int):void 
		{
			_imageType = value;
		}
		
		public function toString():String
		{
			var s:String = "[UserContact]";
			s+= "fname: " + _fname;
			s+= ", lname: " + _lname;
			s += ", email: " + _email;
			s += ", id: " + _id;
			
			return s;
		}
	}

}