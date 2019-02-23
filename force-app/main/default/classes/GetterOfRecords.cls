/*
This class used for getting all records by type including fields and child relationships
excepting binary fields of child relationships because Exception
*/

public class GetterOfRecords {
    
    sObjectType type;
    
    // Empty Construcor For Tests
    public GetterOfRecords(){}
    
    // Constractor for using class
    public GetterOfRecords(sObjectType type){
    this.type = type;    
    }
    
    // Final Method
    public List<sObject> getRecords(){
     List<sObject> allRecords = new List<sObject>();
        
     return allRecords;   
    }
    
    
    // Methods
    public Map<String, Schema.SObjectField> getFields(){
        Map<String, Schema.SObjectField> fields = type.getDescribe().fields.getMap();
        return fields;
    }
    
    public Map<String, Schema.ChildRelationship> getChildRelationships(){
        Map<String, Schema.ChildRelationship> nameToChildRelationshipMap = new Map<String, Schema.ChildRelationship>();
        for(Schema.ChildRelationship childRelationship_i : type.getDescribe().getChildRelationships()){
            if(childRelationship_i.relationshipname != null){
                nameToChildRelationshipMap.put(String.valueOf(childRelationship_i.relationshipname), childRelationship_i);
            }
        }
        return nameToChildRelationshipMap;
    }  
    
    public Map<String, Schema.SObjectField> getFieldsExceptBinaryFields(Map<String, Schema.SObjectField> fields){  
        Map<String, Schema.SObjectField> fieldsExceptBinary = new Map<String, Schema.SObjectField>();
        for(String key : fields.keySet()){
           if(fields.get(key).getDescribe().getType() != Schema.DisplayType.BASE64){
                fieldsExceptBinary.put(key, fields.get(key));
            } 
        }
        return fieldsExceptBinary;
    }
}