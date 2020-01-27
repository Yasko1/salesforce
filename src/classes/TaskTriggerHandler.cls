/**
 * Created by User on 22.12.2019.
 */

public with sharing class TaskTriggerHandler {
    public static Boolean isFirstTime = true;

    public static void onAfterUpdate(List<Task> listTasks){
        if(isFirstTime) {
            isFirstTime = false;
            TaskTriggerHelper.checkCompletedTask(listTasks);
        }
    }

}