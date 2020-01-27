/**
 * Created by User on 24.12.2019.
 */

global class SelectTasksBatchJob implements Database.Batchable<sObject>{

    public SelectTasksBatchJob(){
        System.debug('BUTCH WAS STARTED');
    }

    final String SELECT_ALL_SYNC_TASKS = 'SELECT Id, Is_Synced__c, WhatId, Account.Owner.Name FROM Task WHERE Is_Synced__c = false';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('WAS STARTED');
        return Database.getQueryLocator(SELECT_ALL_SYNC_TASKS);
    }

    global void execute(Database.BatchableContext bc, List<Task> scope){
        List<Account> accountList = new List<Account>();
        System.debug('Batch started');
        for(Task task : scope){
            task.Is_Synced__c = true;
            task.Account_Owner__c = task.Account.Owner.Name;
            Account account = new Account();
            account.Id = task.WhatId;
            account.Updated_By_Task__c = true;
            accountList.add(account);
            System.debug(account.Id + ' ' + account.Updated_By_Task__c);
        }
        update scope;
        System.debug('Tasks was updated from batch');
        update accountList;
        System.debug('Account was updated from batch');
    }

    global void finish(Database.BatchableContext bc){

    }

}