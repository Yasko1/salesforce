trigger AccountTrigger on Account (after insert, after update, after delete) {
  Set<Id> ids = Trigger.newMap.keySet();
   List<Account> accountList = [SELECT Id, Name FROM Account WHERE Id in:ids];

   if(Trigger.isInsert){
      AccountTriggerHandler.onAfterCreate(accountList);
   } else if(Trigger.isUpdate){
       AccountTriggerHandler.onAfterUpdateCheckCountTask(ids);
       AccountTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.newMap, ids);
   // AccountTriggerHandler.afterInsert();
   }

}
