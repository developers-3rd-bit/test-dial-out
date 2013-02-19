package com.halcyon.core.user
{
	import com.halcyon.message.ref.AvatarRef;
	import com.halcyon.message.ref.RealmUserRef;
	import com.halcyon.message.ref.TileRef;
	import com.halcyon.util.utilities.LogFactory;
	import com.halcyon.util.utilities.Logger;
	
	public class Avatar extends RealmUser
	{
		private static var log:Logger = LogFactory.getLog("Avatar", Logger.DEBUG);
		private var version:Number;
		private var tileRef:TileRef;
		private var direction:int;
		private var state:String;
		private var specId:Number;
		private var name:String;
		private var description:String;
		private var emoticons:Array;
		private var color:Number = -1;
		private var status:String;
		private var opacity:int;
		
		public function Avatar(ref:AvatarRef){
			super(ref);
		}
		
		override protected function initFromRef( realmUserRef:RealmUserRef ) :void {
			super.initFromRef(realmUserRef);
			var ref:AvatarRef = realmUserRef as AvatarRef;
			this.tileRef = ref.getTileRef();
			this.direction = ref.getDirection();
			this.color = ref.getColor();
			this.state = ref.getState();
			this.status = ref.getStatus();
			this.opacity = ref.getOpacity();
		}	
		
		public function toString():String{
			var toRet:String = "[Avatar] version: " + version;
			toRet += " tileRef: " + tileRef;
			toRet +=" specId: " + specId;
			toRet += " direction: " + direction;
			toRet += " color: "+ color;
			toRet += " state: " + state;
			toRet += " name: " + name;
			toRet += " description: " + description;
			toRet += " status: " + status;
			toRet += " opacity: " + opacity;
			return toRet; 
		}
		
		public function getTileRef():TileRef{
			return this.tileRef;
		}
		
		public function getOpacity():int{
			return this.opacity;
		}
		
		public function getSpecId():Number{
			return this.specId;
		}
		
		public function setSpecId(specId:Number):void{
			this.specId = specId;
		}
		
		public function getStatus():String{
			return this.status;
		}
		
		public function getVersion():Number{
			return this.version;
		}
		
		public function getColor():Number{
			return this.color;
		}
		
		public function setColor(color:Number):void{
			this.color = color;
		}
		
		public function getDirection():int{
			return this.direction;
		}
		
		public function setDirection(direction:int):void{
			this.direction = direction;
		}
		
		public function getState():String{
			return this.state;
		}
	}
}