@isTest private class CloneDataFromSourceObjectTest {
 
    @TestSetup public static void setup(){
        Account account = new Account(Name = 'Test');
        insert account;
    }
    
    @isTest public static void getFieldsTest(){
        CloneDataFromSourceObject cloneDataFromSourceObject = new CloneDataFromSourceObject();
        System.assert(cloneDataFromSourceObject.getFields(Account.sObjectType).size() > 0);
    }
    @isTest public static void getChildRelationshipsTest(){
        CloneDataFromSourceObject cloneDataFromSourceObject = new CloneDataFromSourceObject();
        System.assert(cloneDataFromSourceObject.getChildRelationships(Account.sObjectType).size() > 0);
    }
    @isTest public static void queriesForChildRelationShipsTest(){
        CloneDataFromSourceObject cloneDataFromSourceObject = new CloneDataFromSourceObject();
        Map<String, Schema.ChildRelationship> childRelationships = cloneDataFromSourceObject.getChildRelationships(Account.sObjectType);
        System.assert(cloneDataFromSourceObject.queriesForChildRelationShips(Account.sObjectType, childRelationships).size() > 0);
        childRelationships = new Map<String, Schema.ChildRelationship>();
        System.assert(cloneDataFromSourceObject.queriesForChildRelationShips(Account.sObjectType, childRelationships).size() == 0);
    } 
    @isTest public static void queryTest(){
        CloneDataFromSourceObject cloneDataFromSourceObject = new CloneDataFromSourceObject();
        System.debug(cloneDataFromSourceObject.query(Account.sObjectType));
        System.assert(cloneDataFromSourceObject.query(Account.sObjectType).length() > 0);
    }
    @isTest public static void useQuery(){
       CloneDataFromSourceObject cloneDataFromSourceObject = new CloneDataFromSourceObject();
        List<Account> accounts = Database.query(cloneDataFromSourceObject.query(Account.sObjectType));
        List<Account> result = new List<Account>();
        for(Account account_i : accounts){
            if(account_i.Name == 'Test'){
                result.add(account_i);
            }
        }
        System.assert(accounts.size() > 0);
    }
}