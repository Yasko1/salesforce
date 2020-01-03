/**
 * Created by User on 23.12.2019.
 */

public with sharing class AccountTriggerHelper {

    static final String SELECT_ACCOUNT_FOR_NEW_TASK = 'SELECT Id, Name FROM Account WHERE Id =:idAccounts';
    static final String SELECT_ALL_CONTACTS = 'SELECT Id, AccountId FROM Contact WHERE AccountId=:setId';
    static final String SELECT_All_ACCOUNT = 'SELECT Id, (SELECT Id, OwnerId FROM Tasks) FROM Account WHERE Id=:ids';
    static final Integer MAX_TASKS_FOR_USER = 3;
    static final String ID_USER_TO_ASSIGN_TASKS = '0052w000000L3j1AAC';

    public static void createTask(Set<Id> idAccounts) {
        futureCreateTask(idAccounts);
    }

    @Future
    static void futureCreateTask(Set<Id> idAccounts) {
        List<Task> listTasks = new List<Task>();
        List<Account> accountList = Database.query(SELECT_ACCOUNT_FOR_NEW_TASK);

        for (Account acc : accountList) {
            Task task = new Task(Subject = 'Negotiations with ' + acc.Name);
            task.WhatId = acc.Id;
            task.Is_Synced__c = false;
            listTasks.add(task);
            System.debug('task ' + task.Subject + ' was inserted');
        }

        insert listTasks;
        System.debug('All tasks was inserted');
    }

    public static void checkChangeBilling(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
        Set<Id> changedAddressAccount = new Set<Id>();
        for (Id accId : newMap.keySet()) {
            if (
                    (oldMap.get(accId).BillingCity != newMap.get(accId).BillingCity) ||
                            (oldMap.get(accId).BillingAddress != newMap.get(accId).BillingAddress) ||
                            (oldMap.get(accId).BillingCountry != newMap.get(accId).BillingCountry) ||
                            (oldMap.get(accId).BillingPostalCode != newMap.get(accId).BillingPostalCode) ||
                            (oldMap.get(accId).BillingState != newMap.get(accId).BillingState) ||
                            (oldMap.get(accId).BillingStreet != newMap.get(accId).BillingStreet) ||
                            (oldMap.get(accId).BillingLatitude != newMap.get(accId).BillingLatitude) ||
                            (oldMap.get(accId).BillingLongitude != newMap.get(accId).BillingLongitude) ||
                            (oldMap.get(accId).BillingGeocodeAccuracy != newMap.get(accId).BillingGeocodeAccuracy)
                    ) {
                changedAddressAccount.add(accId);
            }
        }
        if (changedAddressAccount.size() != 0) {
            changeStatusContact(changedAddressAccount);
        }
    }

    @Future
    static void changeStatusContact(Set<Id> setId) {
        List<Contact> listContacts = Database.query(SELECT_ALL_CONTACTS);

        if (!listContacts.isEmpty() && !setId.isEmpty()) {
            for (Contact cont : listContacts) {
                cont.Processed_By_Future__c = true;
                cont.Is_Synced__c = false;
            }
        }

        update listContacts;
    }

    public static void checkChangeBillingQue(Map<Id, Account> oldMap, Map<Id, Account> newMap){
        Set<Id> idAccounts = new Set<Id>();
        System.debug('IN METHOD');
        for (Id accId : newMap.keySet()) {
            if (
                    (oldMap.get(accId).BillingCity != newMap.get(accId).BillingCity) ||
                            (oldMap.get(accId).BillingAddress != newMap.get(accId).BillingAddress) ||
                            (oldMap.get(accId).BillingCountry != newMap.get(accId).BillingCountry) ||
                            (oldMap.get(accId).BillingPostalCode != newMap.get(accId).BillingPostalCode) ||
                            (oldMap.get(accId).BillingState != newMap.get(accId).BillingState) ||
                            (oldMap.get(accId).BillingStreet != newMap.get(accId).BillingStreet) ||
                            (oldMap.get(accId).BillingLatitude != newMap.get(accId).BillingLatitude) ||
                            (oldMap.get(accId).BillingLongitude != newMap.get(accId).BillingLongitude) ||
                            (oldMap.get(accId).BillingGeocodeAccuracy != newMap.get(accId).BillingGeocodeAccuracy)
                    ) {
                idAccounts.add(accId);
            }
        }
        if(idAccounts.size() != 0) {
            System.enqueueJob(new UpdateContactChangeAcc(idAccounts));
        }
    }

    public static void checkCountAccountTasks(Set<Id> ids){
        List<Account> listAccounts = Database.query(SELECT_All_ACCOUNT);
        List<Task> tasksToUpdate = new List<Task>();

        for(Account acc :listAccounts){
            if ((acc.Tasks.size() > MAX_TASKS_FOR_USER)) {
                for(Task tasks : acc.Tasks){
                    if(tasks.OwnerId != ID_USER_TO_ASSIGN_TASKS) {
                        tasks.OwnerId = ID_USER_TO_ASSIGN_TASKS;
                        tasksToUpdate.add(tasks);
                        System.debug('Task id=' + tasks.Id + ' was assigned to User id=' + ID_USER_TO_ASSIGN_TASKS);
                    }
                }
            }
        }
        update tasksToUpdate;
    }

}