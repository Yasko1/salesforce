/**
 * Created by User on 22.12.2019.
 */

public with sharing class TaskTriggerHandler {


    public static void onAfterUpdate(List<Task> listTasks){
        TaskTriggerHelper.checkCompletedTask(listTasks);
    }

}