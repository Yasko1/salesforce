/**
 * Created by Andrei_Krupin on 1/9/2020.
 */
@IsTest
public with sharing class TaskTriggerTest {
    static final String ACCOUNT_NAME_TEMPLATE = 'TestAccount';
    static final Integer NUMBER_OF_CONTACTS_TO_INSERT = 100;
    static final Integer COUNT_CHANGED_TASK = 10;
    static final String STATUS_VALUE = 'Completed';

    @TestSetup
    static void initTestData(){
        ObjectHelperTest.createTemporaryListAccounts(NUMBER_OF_CONTACTS_TO_INSERT, ACCOUNT_NAME_TEMPLATE, true);
    }

    @IsTest
    public static void updateAccountTest(){
        List<Task> updatedTasks = getTasks(COUNT_CHANGED_TASK);
        List<Account> updAcc = getTruePlansAccounts();
        Test.startTest();
        System.assertEquals(COUNT_CHANGED_TASK, updatedTasks.size());
        System.assertEquals(COUNT_CHANGED_TASK, updAcc.size());
        Test.stopTest();
    }

    static void updateTask(Integer countTask) {
        List<Task> listTasks = Database.query('SELECT Subject, WhatId FROM Task LIMIT ' + COUNT_CHANGED_TASK);
        Set<Id> accId = new Set<Id>();
        for (Integer i = 0; i < listTasks.size(); i++) {
            listTasks[i].Status = STATUS_VALUE;
            accId.add(listTasks[i].WhatId);
        }

        if (!accId.isEmpty()) {
            List<Account> accList = [SELECT Id, Plans_Discussed__c FROM Account WHERE Id = :accId];
            for (Account acc : accList) {
                acc.Plans_Discussed__c = true;
            }
            update accList;
        }

        update listTasks;
    }

    static List<Task> getTasks(Integer countTask){
        updateTask(countTask);
        return [SELECT Subject FROM Task WHERE Status='Completed' LIMIT 10];
    }

    static List<Account> getTruePlansAccounts(){
        return [SELECT Id FROM Account WHERE Plans_Discussed__c = true];
    }
}