public class FiedlDependency {

 

@AuraEnabled
    public static List<DependentFieldMainWrp> getDependentPickListValues(String objectName, Map<String, String> dpntFldWithcntrFldMap){

        Map<String, Map<String, List<ValueSetWrp>>> dpntFldOfCntrValWithDpntValListMap = new Map<String, Map<String, List<ValueSetWrp>>>();
                Map<String, Map<String, List<ValueSetWrp>>> dpntFldOfCntrValWithDpntValListMap2 = new Map<String, Map<String, List<ValueSetWrp>>>();

        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        
        System.debug('dpntFldWithcntrFldMap=>>'+ dpntFldWithcntrFldMap);
        for(String dependentFieldKey: dpntFldWithcntrFldMap.keySet()){
            Map<String, List<ValueSetWrp>> controllingInfo = new Map<String, List<ValueSetWrp>>();
            Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(dpntFldWithcntrFldMap.get(dependentFieldKey)).getDescribe();
            System.debug('controllingFieldInfo==>'+controllingFieldInfo);
            Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentFieldKey).getDescribe();
            System.debug('dependentFieldInfo====>'+dependentFieldInfo);
            List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
            System.debug('controllingValues=====>'+controllingValues);
            List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
            System.debug('dependentValues=====>'+dependentValues);
            for (Schema.PicklistEntry currControllingValue : controllingValues){
                System.debug('data==>'+currControllingValue+'Value==>'+currControllingValue.getValue());
                controllingInfo.put(currControllingValue.getLabel()+'||'+currControllingValue.getValue(), new List<ValueSetWrp>());
            }       
            // Iterate through the dependent values
            for (Schema.PicklistEntry currDependentValue : dependentValues) {
                System.debug('CurrValue ====>'+currDependentValue);
                String jsonString = JSON.serialize(currDependentValue);
                MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
                String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();            
                
                Integer baseCount = 0;
                for (Integer curr : hexString.getChars()) {
                    ValueSetWrp fillDependentValue = new ValueSetWrp();
                    fillDependentValue.label = currDependentValue.getLabel();
                    fillDependentValue.value = currDependentValue.getValue();
                    Integer val = (curr >= 65) ? curr - 65 + 10 : curr - 48;
                    if ((val & 8) == 8) {
                        controllingInfo.get(controllingValues[baseCount + 0].getLabel()+'||'+controllingValues[baseCount + 0].getValue()).add(fillDependentValue);
                    }
                    if ((val & 4) == 4) {
                        controllingInfo.get(controllingValues[baseCount + 1].getLabel()+'||'+controllingValues[baseCount + 1].getValue()).add(fillDependentValue);
                    }
                    if ((val & 2) == 2) {
                        controllingInfo.get(controllingValues[baseCount + 2].getLabel()+'||'+controllingValues[baseCount + 2].getValue()).add(fillDependentValue);
                    }
                    if ((val & 1) == 1) {
                        controllingInfo.get(controllingValues[baseCount + 3].getLabel()+'||'+controllingValues[baseCount + 3].getValue()).add(fillDependentValue);
                    }
                    baseCount += 4;
                }
            }
            System.debug('dependentFieldKey ==>'+dependentFieldKey+'controllingInfo ====>'+controllingInfo);
            dpntFldOfCntrValWithDpntValListMap.put(dependentFieldKey, controllingInfo);
        }
        System.debug('dpntFldOfCntrValWithDpntValListMap =>> '+ dpntFldOfCntrValWithDpntValListMap);
        System.debug('dpntFldOfCntrValWithDpntValListMap serialize =>> '+ JSON.serialize(dpntFldOfCntrValWithDpntValListMap));
        
        
        List<DependentFieldMainWrp> dependentPicklistValueList = new List<DependentFieldMainWrp>();
        for(String key : dpntFldOfCntrValWithDpntValListMap.keySet()){
            //System.debug('Main Key =>> '+ key);
            DependentFieldMainWrp mainWrp = new DependentFieldMainWrp();
            mainWrp.controllingField = dpntFldWithcntrFldMap.get(key);
            mainWrp.dependentField = key;
             fieldDependenciesUsedWrp createFieldWrp  = new fieldDependenciesUsedWrp();
             List<String> keylist = new List<String>();
             keylist.add(key);                
           
            List<FieldDependenciesValueWrp> dependentRecList = new List<FieldDependenciesValueWrp>();
            for(String subKey : dpntFldOfCntrValWithDpntValListMap.get(key).KeySet()){
                 //System.debug('Sub Key =>> '+ subkey);
                FieldDependenciesValueWrp fillWrp = new FieldDependenciesValueWrp();
                ValueSetWrp fillValueWrp = new ValueSetWrp();
                fillValueWrp.label = subkey.substringBefore('||');
                fillValueWrp.value = subkey.substringAfter('||');
                fillWrp.controllingValue = fillValueWrp;
                
                
                fillWrp.dependentValueList = dpntFldOfCntrValWithDpntValListMap.get(key).get(subKey);
                dependentRecList.add(fillWrp);
            }
            mainWrp.dependenciesValuesList = dependentRecList;
            System.debug('mainWrp =>> '+ mainWrp);
            dependentPicklistValueList.add(mainWrp);
            createFieldWrp.headings = keylist;
        }
        System.debug('dependentPicklistValueList serialize =>> '+dependentPicklistValueList);
        return dependentPicklistValueList;
    }
    

  public class MyPickListInfo {
        @AuraEnabled public String validFor;
    }
    
    public class DependentPicklistValues{
        @AuraEnabled public List<FieldDependentWrp> dependentValues;  
    }
    
    public class FieldDependentWrp{
        @AuraEnabled public String controllingField;
        @AuraEnabled public String dependentField;
    }
    
    public class DependentFieldMainWrp{
        @AuraEnabled public String controllingField;
        @AuraEnabled public String dependentField;
        @AuraEnabled public List<FieldDependenciesValueWrp> dependenciesValuesList;
    }
    
    
    public class FieldDependenciesValueWrp{
        @AuraEnabled public ValueSetWrp controllingValue;
        @AuraEnabled public List<ValueSetWrp> dependentValueList;
    }
    
    public class ValueSetWrp{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class fieldDependenciesUsedWrp{
        public List<String> headings;
        public List<DependenciesValuesList> dependenciesValuesList;
    }
    
    
    public class DependenciesValuesList {
        public ControllingValue controllingValue;
        public List<List<ControllingValue>> dependentValueList;
    }
    
    public class ControllingValue {
        public String value;
        public String label;
    }
}