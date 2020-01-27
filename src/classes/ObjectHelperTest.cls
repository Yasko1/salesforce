/**
 * Created by Andrei_Krupin on 1/14/2020.
 */
@IsTest
public with sharing class ObjectHelperTest {
    public static final String ACCOUNT_NAME_TEMPLATE = 'TestAccount';
    public static final Integer NUMBER_ACCOUNTS_TO_INSERT = 50;
    public static final Integer NUMBER_CONTACT_IN_ACCOUNT = 3;
    public static final Integer NUMBER_ACCOUNT_FOR_CHANGE_BILLING = 10;
    public static final String CHANGED_BILLING_CITY = 'TestCity';


    public static Account createTemporaryAccount(String name, Boolean needInsert){
        Account acc = new Account();
        acc.Name = name;

        if(needInsert){
            insert acc;
        }

        return acc;
    }

    /**
     * @author Andrei_Krupin on 1/9/2020.
     * @description Create tasks for accounts
     */
    public static Task createTemporaryTask(Account acc, Boolean needInsert){
        Task ts = new Task();
        ts.Subject = 'Negotiations with ' + acc.Name;
        ts.WhatId = acc.Id;
        return ts;
    }

    /**
     * @author Andrei_Krupin on 1/9/2020.
     * @description Change status tasks
     */
    public static List<Task> changeStatusTask(List<Task> listTasks, Boolean needUpdate){
        for(Integer i = 0 ; i < listTasks.size(); i++){
            listTasks[i].Status = 'Completed';
        }

        if(needUpdate){
            update listTasks;
        }

        return listTasks;
    }

    /**
     * @author Andrei_Krupin on 1/9/2020.
     * @description Create accounts for test
     */
    public static List<Account> createTemporaryListAccounts(Integer numberAcc, String templateName,  Boolean needInsert){
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < numberAcc; i++){
            accounts.add(createTemporaryAccount(templateName + i , false));
        }

        if(needInsert){
            insert accounts;
        }

        return accounts;
    }

    public static List<Contact> createListContactsForAcs(List<Account> accountList, Integer countContacts, Boolean needInsert){

        if(accountList.isEmpty() || countContacts <=0){
            return null;
        }

        List<Contact> contactList = new List<Contact>();

        for(Integer i = 0; i < accountList.size(); i++){
            for(Integer j = 0; j < countContacts; j++){
                Contact contact = new Contact(LastName = accountList[i].Name + j);
                contact.Is_Synced__c = true;
                contact.AccountId = accountList[i].Id;
                contactList.add(contact);
            }
        }

        if(needInsert){
            insert contactList;
        }

        return contactList;
    }
}