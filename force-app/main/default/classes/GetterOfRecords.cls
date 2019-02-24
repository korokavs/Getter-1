/*
This class used for getting all records.
Max SOQL query length is 20,000 characters;
Max quantity of child relationships in SOQL is 20;
No binary fields in child relationship queries.
*/

public class GetterOfRecords {
    
    Integer maxLengthOfQuery = 20000;
    
    // Initialize in constructor
    sObjectType type;
    
    // Constructor for using class
    public GetterOfRecords(sObjectType type){
    this.type = type;    
    }  
    
//================================================================================= Fields Getter    
        
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
        for(String name : nameToChildRelationshipMap.keySet()){
            if(name == null || name == ''){
               nameToChildRelationshipMap.remove(name); 
            }
        }
        return nameToChildRelationshipMap;
    }  
    
    public Map<String, Schema.ChildRelationship> getChildRelationships(){
        return getChildRelationships(null);
    }
    
    							// returns fields except binary and accessible
    public Map<String, Schema.SObjectField> getFieldsExceptBinaryFields(Map<String, Schema.SObjectField> fields){  
        Map<String, Schema.SObjectField> fieldsExceptBinary = new Map<String, Schema.SObjectField>();
        for(String key : fields.keySet()){
           if(fields.get(key).getDescribe().getType() != Schema.DisplayType.BASE64  && fields.get(key).getDescribe().isAccessible() == true){
                fieldsExceptBinary.put(key, fields.get(key));                   
            } 
        }
        return fieldsExceptBinary;
    }
    
//================================================================================= Queries Getter
	//Methods to create queries for fields    
    public String queryForFields(){
          return 'SELECT ' + String.join(new List<String>(getFields().keySet()), ',') + ' FROM ' + String.valueOf(type);  
    }
        
    //Methods to create queries for child relationships
    public Map<String, String> queriesForEachChildRelationships(Map<String, Schema.ChildRelationship> childRelationships){
        Map<String, String> childRelationShipNameToQueryMap = new Map<String, String>();
        if(childRelationships.size() > 0){
            for(String childRelationship_i : childRelationships.keySet()){
                String query = '(SELECT ';
                List<String> fields = new List<String>(getFieldsExceptBinaryFields(childRelationships.get(childRelationship_i)
                                                                                  .getChildSObject()
                                                                                  .getDescribe()
                                                                                  .fields
                                                                                  .getMap()).keySet());
                query += String.join(fields, ',') + ' FROM ' + String.valueOf(type) + '.' + String.valueOf(childRelationship_i) + ')';
                childRelationShipNameToQueryMap.put(childRelationship_i, query);
            }
        }
       		return childRelationShipNameToQueryMap;
    }    
}