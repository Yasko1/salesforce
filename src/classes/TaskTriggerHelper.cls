/**
 * Created by User on 23.12.2019.
 */

public with sharing class TaskTriggerHelper {
    final static String COMPLETED = 'Completed';

    public static void checkCompletedTask(List<Task> listTasks){
        List<Account> listAccounts = new List<Account>();
        for(Task task : listTasks){
            if(task.Status.equals(COMPLETED)){
                Account account = new Account();
                account.Id = task.WhatId;
                account.Plans_Discussed__c = true;
                listAccounts.add(account);
            }
        }
        update listAccounts;
    }

}