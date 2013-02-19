package
{
   import com.halcyon.core.user.contacts.UserContact;
   import com.halcyon.layout.common.HalcyonScrollableVGroup;
   import com.halcyon.layout.common.VGroupElement;
   import com.halcyon.util.events.UserContactEvent;
   
   import common.UserContactEntry;
   
   import flash.display.Sprite;
   import flash.display.StageScaleMode;
   
   public class TestUserContact extends Sprite
   {
      private var _contacts:Array = [];
      private var _vGroup:HalcyonScrollableVGroup;
      
      public function TestUserContact()
      {
         _vGroup = new HalcyonScrollableVGroup(480, 300);
         prepareDummyData();
         for(var i:int=0;i<_contacts.length;i++) {
            var userContact:UserContact = _contacts[i] as UserContact;
            var userContactEntry:UserContactEntry = new UserContactEntry(userContact, true);
            userContactEntry.addEventListener(UserContactEvent.DELETE_USER_CONTACT, onContactDelete, false, 0, true); 
            _vGroup.addChild(userContactEntry);
         }
         stage.scaleMode = StageScaleMode.NO_SCALE;
         this.addChild(_vGroup);
      }
      
      private function onContactDelete(event:UserContactEvent):void 
      {
         _vGroup.deleteElement(event.currentTarget as VGroupElement);
      }
      
      private function prepareDummyData():void 
      {
         _contacts.push(new UserContact("Tony", "Romo", "qb@cowboys.com", "1234567890", "", "", "", "", 0));
         _contacts.push(new UserContact("Hines", "Ward", "cheapshot@artist.com", "2345678901", "", "", "", "", 1));
         _contacts.push(new UserContact("Tom", "Landry", "coach@cowboys.com", "3456789012", "", "", "", "", 2));
         _contacts.push(new UserContact("Metta", "Worldpeace", "looney@tunes.com", "4567890123", "", "", "", "", 3));
         _contacts.push(new UserContact("Ignatius", "Riley", "iriley@dunces.com", "5678901234", "", "", "", "", 4));
         _contacts.push(new UserContact("Homer", "Simpson", "homer@snpp.com", "6789012345", "", "", "", "", 5));
         _contacts.push(new UserContact("Stewie", "Griffin", "loismustdie@yahoo.com", "7890123456", "", "", "", "", 6));
         _contacts.push(new UserContact("Terry", "Bradshaw", "terry15426@aol.com", "8901234567", "", "", "", "", 7));
      }
   }
}