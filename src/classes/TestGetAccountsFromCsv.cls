@isTest
public class TestGetAccountsFromCsv {
	@isTest(SeeAllData=true)
    static void testLoadData(){
        List<Account> accs = Test.loadData(Account.sObjectType, 'Accounts');
        System.debug('list size = ' + accs.size());
    //    System.assert(accs.size() == 3);
        
        System.debug('Name first acc is ' + accs[0].Name);
    }
}