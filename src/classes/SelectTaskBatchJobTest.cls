/**
 * Created by User on 12.01.2020.
 */
@IsTest
public with sharing class SelectTaskBatchJobTest {

    static final String ACCOUNT_NAME_TEMPLATE = 'TestAccount';
    static final Integer NUMBER_OF_CONTACTS_TO_INSERT = 100;

    @TestSetup
    static void initData(){
        ObjectHelperTest.createTemporaryListAccounts(NUMBER_OF_CONTACTS_TO_INSERT, ACCOUNT_NAME_TEMPLATE, true);
    }

    @IsTest
    static void testChangeJobAndAccountStatus(){
        System.debug('123&&&&&&&&&&&&&&&&&&&&&&&&&&');
        System.assertEquals(NUMBER_OF_CONTACTS_TO_INSERT, countTaskFalseSynced());
        Test.startTest();
        Database.executeBatch(new SelectTasksBatchJob());
        Test.stopTest();
        System.assertEquals(NUMBER_OF_CONTACTS_TO_INSERT, countTaskTrueSynced());
    }

    static Integer countTaskTrueSynced(){
        return [SELECT COUNT() FROM Task WHERE Is_Synced__c = true];
    }
    static Integer countTaskFalseSynced(){
        return [SELECT COUNT() FROM Task WHERE Is_Synced__c = false];
    }

}