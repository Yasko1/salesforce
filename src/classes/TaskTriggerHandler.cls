/**
 * Created by User on 22.12.2019.
 */

public with sharing class TaskTriggerHandler {
    final static String COMPLETED = 'Completed';

    public static void onAfterUpdate(List<Task> listTasks){
        List<Account> listAccounts = new List<Account>();
        for(Task task : listTasks){
            if(task.Status.equals(COMPLETED)){
                String ids = task.WhatId;
                Account account = [SELECT Id, Plans_Discussed__c FROM Account WHERE Id =: task.WhatId];
                account.Plans_Discussed__c = true;
                listAccounts.add(account);
            }
        }
        update listAccounts;
    }

}