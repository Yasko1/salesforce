/**
 * Created by User on 22.12.2019.
 */


trigger TaskTrigger on Task (after update, after insert) {

    List<Task> listTasks = Trigger.new;

    if(Trigger.isUpdate){
        TaskTriggerHandler.checkTaskAccount(listTasks);
        TaskTriggerHandler.onAfterUpdate(listTasks);
    }

}

