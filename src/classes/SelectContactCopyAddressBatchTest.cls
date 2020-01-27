/**
 * Created by Andrei_Krupin on 1/13/2020.
 */
@IsTest
public with sharing class SelectContactCopyAddressBatchTest {

    @TestSetup
    static void initData(){
        List<Account> listAcc = ObjectHelperTest.createTemporaryListAccounts(ObjectHelperTest.NUMBER_ACCOUNTS_TO_INSERT,
                ObjectHelperTest.ACCOUNT_NAME_TEMPLATE, true);
        ObjectHelperTest.createListContactsForAcs(listAcc, ObjectHelperTest.NUMBER_CONTACT_IN_ACCOUNT, true);
    }

    @IsTest
    static void testStartBatch(){
        insertAddressAcc(ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING, ObjectHelperTest.CHANGED_BILLING_CITY);
        Integer countCont = ObjectHelperTest.NUMBER_CONTACT_IN_ACCOUNT * ObjectHelperTest.NUMBER_ACCOUNT_FOR_CHANGE_BILLING;
        Test.startTest();
        Database.executeBatch(new SelectContactCopyAddressBatch());
        Test.stopTest();
        System.assertEquals(countCont, getCountContact(ObjectHelperTest.CHANGED_BILLING_CITY));
    }

    static Integer getCountContact(String address){
        Integer countCont = [SELECT COUNT()
        FROM Contact
        WHERE
                Account.BillingCity =: address
        ];
        return countCont;
    }

    static void insertAddressAcc(Integer countAcc, String templateAddress){
        Account[] accounts = Database.query('SELECT Id, BillingCity FROM Account LIMIT ' + countAcc);
        for(Account acc : accounts){
            acc.BillingCity = templateAddress;
        }
        System.debug(accounts.size() + ' ^^^^^^^^^^^^^^ ' + accounts[0].BillingCity);
        update accounts;
    }

}