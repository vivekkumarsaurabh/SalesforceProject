public class BuildingFloorOfficeEmp {
    public static void BuildingFloorOfficemP(){
        Map<String,Map<String,Map<String,List<String>>>> mapOfBuildingFloorOfficeEmp =new Map<String,Map<String,Map<String,List<String>>>>();
        for(Employee__c emp :[SELECT Name,Employee__c.Office__r.Name,Employee__c.Office__r.Floor__r.Name,Employee__c.Office__r.Floor__r.Building__r.Name FROM Employee__c WHERE Employee__c.Office__r.Floor__r.Building__r.Name !=NULL]){
            Map<String,Map<String,List<String>>> mapOfFloorOfficeEmp = new Map<String,Map<String,List<String>>>();
            Map<String,List<String>> mapOfOfficeEmp = new Map<String,List<String>>();
            List<String> listOfEmp=new List<String>();
            if(mapOfBuildingFloorOfficeEmp.containsKey(emp.Office__r.Floor__r.Building__r.Name)){
                mapOfFloorOfficeEmp=mapOfBuildingFloorOfficeEmp.get(emp.Office__r.Floor__r.Building__r.Name);
                if(mapOfFloorOfficeEmp.containsKey(emp.Office__r.Floor__r.Name)){
                    mapOfOfficeEmp=mapOfFloorOfficeEmp.get(emp.Office__r.Floor__r.Name);
                    if(mapOfOfficeEmp.containsKey(emp.Office__r.Name)){
                        listOfEmp=mapOfOfficeEmp.get(emp.Office__r.Name);
                    }                                   
                }
            }
            listOfEmp.add(emp.Name);
            mapOfOfficeEmp.put(emp.Office__r.Name, listOfEmp);
            mapOfFloorOfficeEmp.put(emp.Office__r.Floor__r.Name, mapOfOfficeEmp);
            mapOfBuildingFloorOfficeEmp.put(emp.Office__r.Floor__r.Building__r.Name, mapOfFloorOfficeEmp);        
        }
        for(String Key:mapOfBuildingFloorOfficeEmp.KeySet()){
            System.debug(key+'----->'+mapOfBuildingFloorOfficeEmp.get(Key));
        }
    }  
}