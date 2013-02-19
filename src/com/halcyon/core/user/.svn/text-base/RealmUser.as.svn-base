package com.halcyon.core.user
{
	import com.halcyon.message.core.AvatarStateReq;
	import com.halcyon.message.ref.AvatarRef;
	import com.halcyon.message.ref.RealmUserRef;
	import com.halcyon.util.constants.UserConstants;
	import com.halcyon.util.utilities.LogFactory;
	import com.halcyon.util.utilities.Logger;
	
	public class RealmUser
	{
		private static var log:Logger = LogFactory.getLog("RealmUser", Logger.DEBUG);
		private var user:User;
		private var roles:int;
		private var appRefs:Array;
		
		function RealmUser( ref:RealmUserRef ) {
			if ( ref != null ) this.initFromRef( ref );
		}
		
		protected function initFromRef( ref:RealmUserRef ) :void {
			//get the user, but don't update the ref if it's "my" user
			this.user = User.getUser(ref.getUserRef(), (ref.getUserRef().getId() != AvatarManager.getInstance().getMyUser().getId()));
			this.roles = ref.getRoles();
			this.appRefs = ref.getApps();
			if((ref as AvatarRef).getStatus() == null || (ref as AvatarRef).getStatus() == "neutral"){
				this.user.setState(UserConstants.STATE_NONE);
				log.debug("Setting state to none by default");
			} else {
				log.debug("Setting state to: " + (ref as AvatarRef).getStatus());
				this.user.setState((ref as AvatarRef).getStatus());
			}
		}
		
		public function getUser():User{
			return this.user;
		}
		
		public function getRoles():int{
			return this.roles;
		}
		
		public function setRoles(roles:int):void{
			this.roles = roles;
			
		}
		
		public function getApps():Array{
			return this.appRefs;
		}
		
		public function getIsPresenter():Boolean{
			log.debug("Check for presenter: " + getRoles());
			return ((getRoles() & Role.ROLE_PRESENTER) > 0);
		}
		
		public function getIsSpectator():Boolean{
			return ((getRoles() & Role.ROLE_SPECTATOR) > 0);
		}
		
		public function getIsProducer():Boolean{
			return ((getRoles() & Role.ROLE_PRODUCER) > 0);
		}
	}
}