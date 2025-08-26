public class DynamicBindQuery {
    public static void bindingQuery(Map<String, Object> bindParams){
        String query = 'SELECT Id, Name FROM Account WHERE name = :name';        
        // return Database.queryWithBinds( queryString, bindParams, AccessLevel.USER_MODE);       
    }
}