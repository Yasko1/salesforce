trigger AccountTrigger on Account (after update, after insert, after undelete, after delete, before insert,
        before update, before delete) {

   if(Trigger.isInsert && Trigger.isAfter){
      AccountTriggerHandler.onAfterCreate(Trigger.newMap.keySet());
   } else if(Trigger.isUpdate && Trigger.isAfter){
       AccountTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
   }
}
