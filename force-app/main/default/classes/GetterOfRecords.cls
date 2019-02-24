/*
This class used for getting all records by type including fields and child relationships
excepting binary fields of child relationships because Exception
*/

public class GetterOfRecords {
    
    // Initialize in constructor
    sObjectType type;
    
    // Constractor for using class
    public GetterOfRecords(sObjectType type){
    this.type = type;    
    }   
        
    // Methods to get fields, child relationships and childs relationship fields except binary
    public Map<String, Schema.SObjectField> getFields(){
        Map<String, Schema.SObjectField> fields = type.getDescribe().fields.getMap();
        return fields;
    }

    							// args may be null, empty new List<String>(), or new List<String>(String1, String2, ...)
    public Map<String, Schema.ChildRelationship> getChildRelationships(List<String> chosenChildRelationships){ 
        Map<String, Schema.ChildRelationship> nameToChildRelationshipMap = new Map<String, Schema.ChildRelationship>();
        if(type.getDescribe().getChildRelationships().size() > 0){           
            for(Schema.ChildRelationship childRelationship_i : type.getDescribe().getChildRelationships()){  
                if(chosenChildRelationships == null || chosenChildRelationships.size() == 0){        
                    nameToChildRelationshipMap.put(String.valueOf(childRelationship_i.relationshipname), childRelationship_i);    
                }
                else {
                    for(String chosenChildRelationship : chosenChildRelationships){
                        if(chosenChildRelationship == String.valueOf(childRelationship_i.relationshipname)){
                          nameToChildRelationshipMap.put(String.valueOf(childRelationship_i.relationshipname), childRelationship_i);  
                        }  
                    }
                }
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
    
    //Methods to create queries
    public Map<String, String> queriesForEachChildRelationships(Map<String, Schema.ChildRelationship> childRelationships){
        Map<String, String> childRelationShipNameToQueryMap = new Map<String, String>();
        List<String> queries = new List<String>();
        if(childRelationships.size() > 0){
            for(String childRelationship_i : childRelationships.keySet()){
                String query = '(SELECT ';
                List<String> fields = new List<String>(getFieldsExceptBinaryFields(childRelationships.get(childRelationship_i)
                                                                                  .getChildSObject()
                                                                                  .getDescribe()
                                                                                  .fields
                                                                                  .getMap()).keySet());
                query += String.join(fields, ', ') + ' FROM ' + String.valueOf(type) + '.' + String.valueOf(childRelationship_i) + ')';
                queries.add(query);
                childRelationShipNameToQueryMap.put(childRelationship_i, query);
            }
        }
       // return queries;
       		return childRelationShipNameToQueryMap;
    }
    
}