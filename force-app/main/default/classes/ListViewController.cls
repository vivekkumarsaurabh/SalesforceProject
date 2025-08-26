/*
* @Description : This class is used for listViewController for aura ListView Component;
* @Author      : Vivek Kumar Saurabh
* @Created Date: 03/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 03/06/2024
*/
public class ListViewController {
    /*
	* @description : This method is apex method to fetch wrapper of list view.
	* @param : string objectInfo  objectApi Name used as a param.
	* @return : list<listViewWrapper>  return wrapper list of ListView with their developerName And Label Name.
	*/
    @AuraEnabled
    public static list<ListViewWrapper> retriveListValueApiName(string objectInfo){ // Method name should be more clear and relevant
        list<ListViewWrapper> listViewWrapperList = new list<ListViewWrapper>();        
        for(ListView iterateListView : [SELECT id, Name, DeveloperName FROM ListView WHERE sObjectType = : objectInfo ORDER By Name ASC]){ 
            ListViewWrapper wrapper = new ListViewWrapper();
            wrapper.label = iterateListView.Name;
            wrapper.developerName = iterateListView.DeveloperName;
            listViewWrapperList.add(wrapper);
        }
        try{
            if(listViewWrapperList != NULL){ // I don't think you need to check both the things on the same list
                return listViewWrapperList;
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('ListViewController', 'retriveListValueApiName', e.getMessage(), e.getStackTraceString(), e.getLineNumber()); 
        }
        return listViewWrapperList; 
    }
    
    public class ListViewWrapper{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
    }
}