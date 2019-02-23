public class CloneDataFromSourceObject {
    sObjectType source;
    sObjectType target;
    Map<String, sObjectType> stringToTypeMap = new Map<String, sObjectType>();
    Map<sObjectType, String> typeToStringMap = new Map<sObjectType, String>();

//===== Empty Constructor For Test =====   
    public CloneDataFromSourceObject(){
    }

//===== Functional Constructor =====   
    public CloneDataFromSourceObject(sObjectType source, sObjectType target){
        this.source = source;
        this.target = target;
            
        	stringToTypeMap.put(String.valueOf(source), source);
        	stringToTypeMap.put(String.valueOf(target), target);
        
        	typeToStringMap.put(source, String.valueOf(source));
        	typeToStringMap.put(target, String.valueOf(target)); 
    }    

//===== Help Methods =====
    public Map<String, Schema.SObjectField> getFields(sObjectType type){
        return type.getDescribe().fields.getMap();
    }
    
    public Map<String, Schema.ChildRelationship> getChildRelationships(sObjectType type){
        Map<String, Schema.ChildRelationship> nameToChildRelationshipMap = new Map<String, Schema.ChildRelationship>();
        for(Schema.ChildRelationship childRelationship_i : type.getDescribe().getChildRelationships()){
            if(childRelationship_i.relationshipname != null){
            		nameToChildRelationshipMap.put(String.valueOf(childRelationship_i.relationshipname), childRelationship_i);
                }
        }
        return nameToChildRelationshipMap;
    }
    
    public List<String> queriesForChildRelationShips(sObjectType type, Map<String, Schema.ChildRelationship> childRelationships){
        List<String> queries = new List<String>();
        if(childRelationships.size() != 0){
        for(String childRelationship_i : childRelationships.keySet()){
            String query = '(SELECT ';
            List<String> fields = new List<String>(childRelationships
                                                   .get(childRelationship_i)
                                                   .getChildSObject()
                                                   .getDescribe()
                                                   .fields
                                                   .getMap()
                                                   .keySet());
            Map<String, sObjectField> nameTosObjectFieldMap = childRelationships
                                                   .get(childRelationship_i)
                                                   .getChildSObject()
                                                   .getDescribe()
                                                   .fields
                                                   .getMap();
            for(String key : nameTosObjectFieldMap.keySet()){
                if(nameTosObjectFieldMap.get(key).getDescribe().getType() == Schema.DisplayType.BASE64){
                    fields.remove(fields.indexOf(key));
                }
            }
            
            query += String.join(fields, ', ') + ' FROM ' + String.valueOf(type) + '.' + childRelationship_i + ')';
            queries.add(query);
        }
            }
        return queries;
    }
    public String query(sObjectType type){
        String query = 'SELECT ' + String.join(new List<String>(getFields(type).keySet()), ', ');
        if(queriesForChildRelationShips(type, getChildRelationships(type)).size() > 0){
          query += ', ' + String.join(queriesForChildRelationShips(type, getChildRelationships(type)), ', ');
          query += ' FROM ' + String.valueOf(type);  
        }
        return query;
    }
    
}