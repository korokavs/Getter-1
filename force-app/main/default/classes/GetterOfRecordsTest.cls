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
    }
    @isTest public static void queriesForChildRelationshipsTest(){
        GetterOfRecords getter = new GetterOfRecords(Account.sObjectType);
        System.assert(getter.queriesForChildRelationships(getter.getChildRelationships()).size() > 0);
    }
    

}