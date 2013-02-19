package com.halcyon.interfaces.user
{
	/**
	 * IUser is a thin wrapper for all User objects in the system. The methods correspond to actual
	 * data points that are accessible for external applications to call directly. It is an interface
	 * accessible via the <code>com.halcyon.util.proxy.IAppProxy</code> interface for the application to
	 * access information about a particular user in the room.
	 *
	 * @see /imeet2.0/content5/applications/helloworld
	 * @see com.halcyon.util.proxy.IAppProxy
	 */
	public interface IUser
	{
		/**
		 * Returns the screen name of this user.
		 *
		 * @return The user's screen name.
		 */
		function getScreenName():String;
		
		/**
		 * Returns the ID of this user.
		 *
		 * @return The user's ID.
		 */
		function getId():Number;
		
		/**
		 * Returns the name of this user.
		 *
		 * @return The user's name.
		 */
		function getName():String;
		
		/**
		 * Returns the gender of this user.
		 *
		 * @return The user's gender.
		 */
		function getGender():String;
		
		/**
		 * Returns the location of this user in the following format:
		 *   <i>[city], [state]</i>
		 *
		 * @return The user's location.
		 */
		function getLocation():String;
		
		/**
		 * Returns the age of this user in years.
		 *
		 * @return The user's age.
		 */
		function getAge():int;
		
		/**
		 * Returns the date this user joined.
		 *
		 * @internal This method may need to be changed later to a Date data type.
		 *
		 * @return The date this user joined.
		 */
		function getJoined():String;
		
		/**
		 * Determines if this user is a guest.
		 *
		 * @return True if this user is a guest.
		 */
		function getIsGuest():Boolean
		
		/**
		 * Returns user preferences stored in a key/value pair format structure (typically Strings). Examples:
		 *   <ul>
		 *   <li>sex: [male|female]</li>
		 *   <li>hairStyle: [hip]</li>
		 *   <li>avatarSex: [male|female]</li>
		 *   </ul>
		 *
		 * @return A set of key/value pairs representing preferences.
		 */
		function getPrefs():Object;
		
		/**
		 * Sets user preference values that are stored in a key/value pair structure.
		 *
		 * @param prefs An Object containing a set of key/value pairs representing preferences.
		 */
		function setPrefs(prefs:Object):void;
		
		/**
		 * Returns the latitude of this user.
		 *
		 * @return The latitude of this user.
		 */
		function getLat():Number;
		
		/**
		 * Returns the longitude of this user.
		 *
		 * @return The longitude of this user.
		 */
		function getLong():Number;
		
		/**
		 * Returns the current user's account type. Known valid values are:
		 *   <ul>
		 *   <li>2 - Allows this user to use the navigation component.</li>
		 *   </ul>
		 *
		 * @return The account type of this user.
		 */
		function getAccountType():int;
		
		/**
		 * Returns the phone number of this user in the following format: (xxx) xxx-xxxx.
		 *
		 * @return The phone number of this user.
		 */
		function getPhone():String;
		
		/**
		 * Returns the intl prefix of the phone number
		 * @return The international dialing prefix of this user's phone number
		 */
		function getPhoneIntlPrefix():String;

		/**
		 * Returns the phone number extension of this user.
		 *
		 * @return The phone number extension of this user.
		 */
		function getPhoneExt():String;
		
		/**
		 * Returns the title of this user.
		 *
		 * @return The title of this user.
		 */
		function getTitle():String;
		
		/**
		 * Returns the e-mail of this user.
		 *
		 * @return The e-mail of this user.
		 */
		function getEmail():String;
		
		/**
		 * Returns the current image index.
		 *
		 * @return The index for this user's image.
		 */
		function getImageIdx():int;
		
		/**
		 * Returns the image type for this user. Possible valid values for this are:
		 *   <ul>
		 *   <li>0 - Default user tile image</li>
		 *   <li>1 - User tile group image</li>
		 *   <li>2 - Downloadable</li>
		 *   <li>3 - Mini avatar tile</li>
		 *   </ul>
		 *
		 * @return The image type for this user.
		 */
		function getImageType():int;
		
		/**
		 * Returns the company of this user.
		 *
		 * @return The company of this user.
		 */
		function getCompany():String;
		
		/**
		 * Returns the first name of this user.
		 *
		 * @return The first name of this user.
		 */
		function getFirstName():String;
		
		/**
		 * Returns the last name of this user.
		 *
		 * @return The last name of this user.
		 */
		function getLastName():String;
		
		/**
		 * Determines if this user is currently talking on the conference call.
		 *
		 * @return True if this user is currently talking on the conference call.
		 */
		function getIsActiveTalker():Boolean;
		
		/**
		 * Determines if this user is not logged in to the client and is instead only on the conference call.
		 *
		 * @return True if this user is dialed in to the conference call only.
		 */
		function getDialinOnly():Boolean;
		
		/**
		 * Determines if this user is on the conference call.
		 *
		 * @return True if this user is on the conference call.
		 */
		function getIsOnConference():Boolean;
		
		/**
		 * Determines if this user has been muted on the conference call.
		 *
		 * @return True if this user has been muted on the conference call.
		 */
		function getIsMuted():Boolean;
		
		/**
		 * Determines if this user is streaming the conference call.
		 *
		 * @return True if this user is streaming the conference call.
		 */
		function getStreaming():Boolean;
		
		/**
		 * Returns the GMT offset in <b>milliseconds</b> that are required to be added (or subtracted)
		 * to this user's current time in order to derive the correct time for the user.
		 *
		 * @internal This method may need to be renamed to getGMTOffsetMillis() for clarity reasons.
		 *
		 * @return The GMT offset of this user in milliseconds.
		 */
		function getGMTOffset():Number;
		
		/**
		 * Determines if this user has been merged with another user.
		 *
		 * @return True if this user has been merged with another user.
		 */
		function getMerged():Boolean;
		
		/**
		 * Gets the volume level for the user.
		 *
		 * @return The volume level.
		 */
		function getSpeakLevel() : int;
		
		function getCurrentPhotoURI():String;
		
		function getAbout():String;
		
		function getShowPhone():Boolean;
		
		function getShowVcard():Boolean;
		
		function getIsDVR():Boolean;
		
		function isHost():Boolean;
		
		function getIsSpectator():Boolean;
		
		function getPartId():String;
		
		function getLinkedProfilePicUrl():String;
		
		function isSocialUser():Boolean;
	}
}