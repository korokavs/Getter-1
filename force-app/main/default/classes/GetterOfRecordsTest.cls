@isTest private class GetterOfRecordsTest {

    @isTest public static void getFieldsTest(){
        GetterOfRecords getter = new GetterOfRecords(Attachment.sObjectType);
        Integer numberOfAttachmentFields = getter.getFields().keySet().size();
        Integer numberOfAttachmentFieldsExceptBinary = getter.getFieldsExceptBinaryFields(getter.getFields()).size();
        System.assert(numberOfAttachmentFields > numberOfAttachmentFieldsExceptBinary);    
    }
    @isTest public static void getChildRelationshipsTest(){
        GetterOfRecords getter = new GetterOfRecords(Account.sObjectType);
        System.assert(getter.getChildRelationships().size() > 0);
        //List<String> childs = new List<String>(getter.getChildRelationships(null).keySet());
        //System.debug(String.join(childs, ', '));
    }
    @isTest public static void queriesForEachChildRelationshipsTest(){
        GetterOfRecords getter = new GetterOfRecords(Account.sObjectType);
        //System.debug(String.join(getter.queriesForEachChildRelationships(getter.getChildRelationships(null)).values(), ', '));
        System.assert(getter.queriesForEachChildRelationships(getter.getChildRelationships(null)).size() > 0);
        //System.debug(String.join(getter.queriesForEachChildRelationships(getter.getChildRelationships(new List<String>{'Tasks'})).values(),', '));
        System.assert(getter.queriesForEachChildRelationships(getter.getChildRelationships(new List<String>{'Attachments', 'WorkOrders'})).size() == 2);
    }
    @isTest public static void queryForFieldsTest(){
        GetterOfRecords getter = new GetterOfRecords(Account.sObjectType);
        //System.debug(getter.queryForFields());
        System.assert(getter.queryForFields().length() != null);
    }        

}