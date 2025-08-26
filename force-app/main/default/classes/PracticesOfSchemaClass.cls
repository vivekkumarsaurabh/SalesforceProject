public class PracticesOfSchemaClass {

    public static void methods(){
        
/**Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
List<Schema.ChildRelationship> C = R.getChildRelationships();
        for(Schema.ChildRelationship g1: C){
                  System.debug(g1.getLabel());
        }**/
        
    /**    // Get tab set describes for each app
List<Schema.DescribeTabSetResult> tabSetDesc = Schema.DescribeTabs();

// Iterate through each tab set describe for each app and display the info
for(Schema.DescribeTabSetResult tsr : tabSetDesc) {            
    // Display tab info for the Sales app
    if (tsr.getLabel() == 'Sales') {
        // Get color information for the first tab
        List<Schema.DescribeColorResult> colorDesc = tsr.getTabs()[0].getColors();
        // Display the icon color, theme, and context of the first color returned
        System.debug('Color: ' + colorDesc[0].getColor());
        System.debug('Theme: ' + colorDesc[0].getTheme());
        System.debug('Context: ' + colorDesc[0].getContext());
    }            
}
**/
// Example debug statement output
// DEBUG|Color: 1797C0
// DEBUG|Theme: theme4
// DEBUG|Context: primary

        

        
        
 /**       List <DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();

           DataCategoryGroupSobjectTypePair pair1 = new DataCategoryGroupSobjectTypePair();
            pair1.setSobject('KnowledgeArticleVersion');
            pair1.setDataCategoryGroupName('Regions');

            DataCategoryGroupSobjectTypePair pair2 = new DataCategoryGroupSobjectTypePair();
			pair2.setSobject('Questions');
			pair2.setDataCategoryGroupName('Regions');

		  pairs.add(pair1);
		  pairs.add(pair2);

List<Schema.DescribeDataCategoryGroupStructureResult>results = Schema.describeDataCategoryGroupStructures(pairs, true);
        System.debug(results);**/
        
 /**  //Schema.DescribeFieldResult AccountVar = Account.Created_Date_TIme__c.getDescribe();
      Schema.DescribeFieldResult AccountVar = Account.Rating.getDescribe();
       //Schema.DescribeFieldResult AccountVar = Account.Rating.getDescribe();
       // System.debug(AccountVar.getByteLength());
      //System.debug(AccountVar.getCalculatedFormula());
     // System.debug(AccountVar.getDefaultValue()); 
       // System.debug(AccountVar.getDefaultValueFormula());
       //  System.debug('getdigit =>'+AccountVar.getDigits());
       //  System.debug(AccountVar.getInlineHelpText());
      //  System.debug('Label=>'+AccountVar.getLabel());
        //System.debug('Length=>'+AccountVar.getLength());
      //  System.debug('getlocalName=>'+AccountVar.getLocalName());
      //  System.debug('name=>'+AccountVar.getName());
      //  System.debug('Rating => '+AccountVar.getPicklistValues());
      //  
        Schema.DescribeFieldResult FloorVar = Floor__c.Name.getDescribe();
        System.debug('precision=>'+FloorVar.getPrecision());
        System.debug('refrenceTargetField => '+FloorVar.getReferenceTargetField());
        System.debug('getreferenceto ==>'+FloorVar.getReferenceTo());
        System.debug('getrelationshipname => '+FloorVar.getRelationshipName());
        System.debug('scale=>'+FloorVar.getScale());
        System.debug('getSOAPType=> '+Floorvar.getSoapType());
        System.debug('getSobjectfield => '+FloorVar.getSobjectField());
        System.debug('getSobjectType=>'+FloorVar.getSObjectType());
        System.debug('isAccessible   =>'+FloorVar.isAccessible());
        System.debug('isCalculated=>'+FloorVar.isCalculated());
        System.debug('iscascadedeleted =>'+FloorVar.isCascadeDelete());
        System.debug('iscaseSensitive =>'+FloorVar.isCaseSensitive());
        System.debug('iscreateble =>'+FloorVar.isCreateable());
        System.debug('isCustom = > '+FloorVar.isCustom());
        System.debug('isDependentPicklist =>'+AccountVar.isDependentPicklist());
        System.debug('isLookup = > '+FloorVar.isIdLookup());**/
        
        
        
  /**      List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();


for(Schema.DescribeTabSetResult tsr : tabSetDesc) {            
    // Get tab info for the Sales app
    if (tsr.getLabel() == 'Sales') {
        // Get icon information for the first tab
        List<Schema.DescribeIconResult> iconDesc = tsr.getTabs()[0].getIcons();
        // Display the icon height and width of the first icon
        System.debug('Height: ' + iconDesc[0].getHeight());
        System.debug('Width: ' + iconDesc[0].getWidth());
         System.debug('URL: ' + iconDesc[0].getUrl());
        System.debug('Theme: ' + iconDesc[0].getTheme());
        
    }            
}**/
        
       /** Schema.DescribeSObjectResult d = Account.sObjectType.getDescribe();
Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
        System.debug(FsMap);**/
        
    /**    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
       
        for(String Key: gd.KeySet()){
            System.debug(Key+'===>'+gd.get(Key));
        }  **/    
        
       List<Schema.DescribeSObjectResult> descResult = Schema.describeSObjects(new String[]{'Account'});
       // List<Schema.DescribeTabSetResult> dt=Schema.describeTabs();
       // System.debug(descResult);
        for(DescribeSObjectResult c:descResult){
           
        //   System.debug(c.getName()); 
           // System.debug('\n');
        }
        
        
      List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        
       // System.debug(tabSetDesc);
/**
// Iterate through each tab set describe for each app and display the info
        for(DescribeTabSetResult tsr : tabSetDesc) {
            String appLabel = tsr.getLabel();
            System.debug('Label: ' + appLabel);
            System.debug('Logo URL: ' + tsr.getLogoUrl());
            System.debug('isSelected: ' + tsr.isSelected());
            String ns = tsr.getNamespace();
            if (ns == '') {
                System.debug('The ' + appLabel + ' app has no namespace defined.');
            }
            else {
                System.debug('Namespace: ' + ns);
            }
            
            // Display tab info for the Sales app
            if (appLabel == 'Sales') {
                List<Schema.DescribeTabResult> tabDesc = tsr.getTabs();
                System.debug('-- Tab information for the Sales app --');
                for(Schema.DescribeTabResult tr : tabDesc) {
                    System.debug('getLabel: ' + tr.getLabel());
                    System.debug('getColors: ' + tr.getColors());
                    System.debug('getIconUrl: ' + tr.getIconUrl());
                    System.debug('getIcons: ' + tr.getIcons());
                    System.debug('getMiniIconUrl: ' + tr.getMiniIconUrl());
                    System.debug('getSobjectName: ' + tr.getSobjectName());
                    System.debug('getUrl: ' + tr.getUrl());
                    System.debug('isCustom: ' + tr.isCustom());
                    System.debug('\n');
                }
            }
        }
        **/
        
     Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
     List<Schema.ChildRelationship> C = R.getChildRelationships();
         for(Schema.ChildRelationship g: C){
                 // System.debug(C);
        }
        
     /** Map<String,Schema.sObjectType> mapOfSchema=Schema.getGlobalDescribe();
       for(String k: mapOfSchema.keySet()){
            System.debug(k+'===>'+mapOfSchema.get(k));
        }**/
        
  
          List<Schema.DescribeSObjectResult> descR = Schema.describeSObjects(new List<String>{'Account'});
       // List<Schema.DescribeTabSetResult> dt=Schema.describeTabs();
       // System.debug(descResult);
        for(DescribeSObjectResult c1:descR){
             //System.debug(c1.getname()); 
           // System.debug('\n');
        }
        
        
        String s='Account';
        List<Schema.DescribeSObjectResult> de=Schema.DescribeSObjects(new List<String>{s});
        for(DescribeSObjectResult cobj: de){
            System.debug(cobj);
            System.debug('\n');
        }
        
       
        
     
       
    }
    
    public static List<String> getField(String objectName){
        List<String> reqfields=new List<String>();
        //get all object
        Map<String,Schema.SObjectType> sobj= Schema.getGlobalDescribe();
        //obj string convert to sObjectType
        Schema.SObjectType objname=sobj.get(objectName);       
        Schema.DescribeSObjectResult res=objname.getDescribe();
        //System.debug(res);
       
        Map<String,Schema.SObjectField> mapOfField = res.fields.getMap();
        
        for(String fieldName: mapOfField.keySet()){
           // Schema.SObjectField field=mapOfField.get(fieldName);
           //Schema.DescribeFieldResult f=field.getDescribe();
            
          //  System.debug('field ==>'+field);
           // System.debug('f-->'+f.getType()); //typeoffield
              //System.debug(mapOfField.get(fieldName)); 
            reqfields.add(fieldName);
        }
        //System.debug(reqfields);
       
            
     return reqfields; 
    } 
    
    
    public static void fieldsetmethod(){
        Schema.DescribeSObjectResult d = Account.sObjectType.getDescribe();
   Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
        for(FieldSet fieldsetname:FsMap.values()){
        system.debug(fieldsetname.getLabel());    
            //for(String field: FsMap.keySet()){
          //  Schema.SObjectField fe=FsMap.get(fieldName);
            //System.debug('F==>'+fieldName);
          //System.debug('fields==>'+FsMap.get(fieldName));
        }
    }
}