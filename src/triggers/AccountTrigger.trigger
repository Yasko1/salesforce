trigger AccountTrigger on Account (after update, after insert, after undelete, after delete, before insert,
        before update, before delete) {
    if(Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.onAfterCreate(Trigger.newMap.keySet());
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
        }
    }
}