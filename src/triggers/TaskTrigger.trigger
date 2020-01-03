/**
 * Created by User on 22.12.2019.
 */

trigger TaskTrigger on Task (after update, after insert, after undelete, after delete, before insert,
        before update, before delete ) {

    if(Trigger.isAfter) {
        if (Trigger.isUpdate) {
            TaskTriggerHandler.onAfterUpdate(Trigger.new);
        }
    }

}