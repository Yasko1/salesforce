/**
 * Created by Andrei_Krupin on 1/14/2020.
 */
@IsTest
public with sharing class TestAccountManager {
    static String END_POINT = 'https://resourceful-moose-vgl8e4-dev-ed.my.salesforce.com/services/apexrest/Account/';
    static String NAME_CREATED_ACCOUNT = 'TestCreateAcc';
    static String WRONG_ID_FOR_GET = '123123123';
    static String ERROR_MESSAGE_WRONG_GET_ACC = 'List has no rows for assignment to SObject';
    static String NEW_NAME_FOR_ACC = 'NewNameTest';

    @TestSetup
    static void initData(){
        ObjectHelperTest.createTemporaryListAccounts(ObjectHelperTest.NUMBER_CONTACT_IN_ACCOUNT,
            ObjectHelperTest.ACCOUNT_NAME_TEMPLATE, true);
    }

    @IsTest
    static void testGetAccById(){
        Account acc = getSingleAccount();
        String testParamId = acc.Id;
        RestRequest req = new RestRequest();
        req.requestURI = END_POINT + testParamId;
        RestContext.request = req;
        Test.startTest();
        Account testAcc = AccountManager.getAccountById();
        Test.stopTest();
        System.assertEquals(acc.Name, testAcc.Name);
    }

    @IsTest
    static void testGetAccByIdWithWrongId(){
        String errorMessage;
        RestRequest req = new RestRequest();
        req.requestURI = END_POINT + WRONG_ID_FOR_GET;
        RestContext.request = req;
        Test.startTest();
        try {
            AccountManager.getAccountById();
        } catch (QueryException ex){
            errorMessage = ex.getMessage();
        }
        Test.stopTest();
        System.assertEquals(errorMessage, ERROR_MESSAGE_WRONG_GET_ACC);
    }

    @IsTest
    static void testCreateAccount(){
        System.assertEquals(0, getAccountByName(NAME_CREATED_ACCOUNT));

        Test.startTest();
        AccountManager.createAccount(NAME_CREATED_ACCOUNT);
        Test.stopTest();

        System.assertEquals(1, getAccountByName(NAME_CREATED_ACCOUNT));
    }

    @IsTest
    static void testDeleteAccount(){
        Account account = getSingleAccount();
        RestRequest req = new RestRequest();
        req.requestURI = END_POINT + account.Id;
        RestContext.request = req;
        System.assertEquals(1, getAccountById(account.Id));

        Test.startTest();
        AccountManager.deleteAccount();
        Test.stopTest();

        System.assertEquals(0, getAccountById(account.Id));
    }

    @IsTest
    static void testDeleteAccountWrongId(){
        RestRequest req = new RestRequest();
        req.requestURI = END_POINT + WRONG_ID_FOR_GET;
        RestContext.request = req;
        String errorMessage;
        Test.startTest();
        try {
            AccountManager.deleteAccount();
        } catch (QueryException ex){
            errorMessage = ex.getMessage();
        }
        Test.stopTest();

        System.assertEquals(errorMessage, ERROR_MESSAGE_WRONG_GET_ACC);
    }

    @IsTest
    static void testUpdateAccount(){
        Account account = getSingleAccount();
        System.assertEquals(0, getAccountByName(NEW_NAME_FOR_ACC));

        Test.startTest();
        AccountManager.updateAccount(NEW_NAME_FOR_ACC, account.Id);
        Test.stopTest();

        System.assertEquals(1, getAccountByName(NEW_NAME_FOR_ACC));
    }

    @IsTest
    static void testUpdateAccountWrongId(){
        String errorMessage;

        Test.startTest();
        try {
            AccountManager.updateAccount(NEW_NAME_FOR_ACC, WRONG_ID_FOR_GET);
        } catch (QueryException ex){
            errorMessage = ex.getMessage();
        }
        Test.stopTest();

        System.assertEquals(errorMessage, ERROR_MESSAGE_WRONG_GET_ACC);
    }

    @IsTest
    static void testUpsertAccount(){
        Account account = getSingleAccount();
        System.assertEquals(0, getAccountByName(NEW_NAME_FOR_ACC));

        Test.startTest();
        AccountManager.upsertAccount(NEW_NAME_FOR_ACC, account.Id);
        Test.stopTest();

        System.assertEquals(1, getAccountByName(NEW_NAME_FOR_ACC));
    }


    static Account getSingleAccount(){
        return [SELECT Id, Name FROM Account LIMIT 1];
    }

    static Integer getAccountByName(String name){
        return [SELECT COUNT() FROM Account WHERE Name =: name];
    }

    static Integer getAccountById(String id){
        return [SELECT COUNT() FROM Account WHERE Id =: id];
    }
}