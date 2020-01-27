/**
 * @author Andrei_Krupin on 1/9/2020.
 * @description It is test for checking correct working AccountTrigger, AccountHandler, AccountHelper
 */
@IsTest
class AccountTriggerTest {

    @testSetup
    static void initTestData() {
       List<Account> accList = ObjectHelperTest.createTemporaryListAccounts(ObjectHelperTest.NUMBER_ACCOUNTS_TO_INSERT,
               ObjectHelperTest.ACCOUNT_NAME_TEMPLATE, true);
        ObjectHelperTest.createListContactsForAcs(accList, ObjectHelperTest.NUMBER_CONTACT_IN_ACCOUNT,
                true);
    }

    @isTest
    static void testInsertAcc(){
        List<Account> accountList;
        Integer countTask = 0;

        Test.startTest();
        accountList = getInsertedAcc();
        Test.stopTest();

        for(Integer i = 0; i < accountList.size(); i++){
            countTask += accountList[i].Tasks.size();
        }
        System.assertEquals(ObjectHelperTest.NUMBER_ACCOUNTS_TO_INSERT, countTask);
    }

    @isTest
    static void testUpdateBillingAccFuture(){
        Test.startTest();
        update changeAddressAccount(ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING);
        Test.stopTest();
        Integer countCont = getContactAfterUpdateBillingFuture(ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING);
        Integer expectedCountContact = ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING *
                ObjectHelperTest.NUMBER_CONTACT_IN_ACCOUNT;
        System.assertEquals(expectedCountContact , countCont);
    }

    @isTest
    static void testUpdateBillingAccQueueable(){
        Test.startTest();
        update changeAddressAccount(ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING);
        Test.stopTest();
        Integer countCont = getContactAfterUpdateBillingQueueable(ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING);
        Integer expectedCountContact = ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING *
                ObjectHelperTest.NUMBER_CONTACT_IN_ACCOUNT;
        System.assertEquals(expectedCountContact , countCont);
    }

    @isTest
    static void testAssignedTasksToAnotherAcc(){
        Task task = [SELECT Id,WhatId, OwnerId FROM Task LIMIT 1];
        String oldOwner = task.OwnerId;
        List<Task> taskList = createNewTasks(task.WhatId, 'testTask', 5);
        Test.startTest();
        insert taskList;
        System.debug(task.OwnerId);

        Account acc = [SELECT Id, Name FROM Account WHERE Id =: task.WhatId];
        acc.Name = 'AnotherName';
        update acc;
        Test.stopTest();
        Task newTask = [SELECT OwnerId FROM Task WHERE Id =: task.Id];
        System.assertNotEquals(task.OwnerId, newTask.OwnerId);
    }

    static List<Account> getInsertedAcc(){
        return [SELECT Name, (SELECT Id FROM Tasks)
        FROM Account
        WHERE Name LIKE :('%' + ObjectHelperTest.ACCOUNT_NAME_TEMPLATE + '%')
        ];
    }

    static List<Account> changeAddressAccount(Integer count){
        List<Account> accList = Database.query('SELECT Id, BillingCity FROM Account LIMIT ' + count);
        for(Account acc : accList){
            acc.BillingCity = ObjectHelperTest.CHANGED_BILLING_CITY;
        }
        return accList;
    }

    static Integer getContactAfterUpdateBillingFuture(Integer countToUpdate){
        return [SELECT COUNT() FROM Contact WHERE Processed_By_Future__c = true];
    }

    static Integer getContactAfterUpdateBillingQueueable(Integer countToUpdate){
        return [SELECT COUNT() FROM Contact WHERE Processed_By_Queue__c = true];
    }

    static List<Task> createNewTasks(Id whatId, String taskName, Integer countTask){
        List<Task> listTasks = new List<Task>();
        for(Integer i = 0; i < countTask; i++){
            Task task = new Task(Subject = taskName + i, WhatId = whatId);
            listTasks.add(task);
        }
        return listTasks;
    }


}