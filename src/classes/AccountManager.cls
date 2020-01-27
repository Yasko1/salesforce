/**
 * Created by User on 29.12.2019.
 */

@RestResource(urlMapping = '/Account/*')
global with sharing class AccountManager {


    @HttpGet
    global static Account getAccountById(){
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1
        );

        Account account = [SELECT Name FROM Account WHERE Id=:accId];
        return account;
    }

    @HttpPost
    global static Id createAccount(String name){
        Account account = new Account();
        account.Name = name;
        insert account;
        return account.Id;
    }

    @HttpDelete
    global static void deleteAccount(){
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1
        );



        Account acc = [SELECT Id FROM Account WHERE Id = :accId];
        delete acc;
    }

    @HttpPatch
    global static Id updateAccount(String name, String id){
        RestRequest req = RestContext.request;
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :id];
        acc.Name = name;
        update acc;
        return acc.Id;
    }

    @HttpPut
    global static Id upsertAccount(String name, String id){
        Account acc = new Account(Id = id, Name = name);
        upsert acc;
        return acc.Id;
    }

}