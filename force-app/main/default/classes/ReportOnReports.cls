/*
* @Description : This class is used for reports of report functionality where we show all reports in single View and filter that reports; // Can you please explain the use of this class in details
* @author      : Vivek Kumar Saurabh
* @Created Date: 23/08/2024
* @modified by  : Vivek Kumar Saurabh 
*@modified date: 08/02/2025
*/
public class ReportOnReports { 
    
    /*
	* @description : This method is used for getting all reports informations.
	* @param : String columnFilterList, String key (data comes with columFilterList  and behalf on Search key).
	* @return : List<ReportWrapper> In this wrapper getting all informations about report fill in this reportWrapper list.
	*/ 
    @AuraEnabled
    public static List<ReportWrapper> getAllReports(String columnFilterList, String key){
        String query;
        String searchKey = '%'+key+'%';
        String nullValue = '_';
        List<ReportWrapper> reportWrapperList = new List<ReportWrapper>();  
        String filter;
        if(columnFilterList != NULL && columnFilterList != 'null'){ // I don't think you need to do that both the check togather rather than this you can use some string class standard method with and condition. //this variable contians null in js and getting strigify then we check both.
            List<FilterList> filterListt = (List<FilterList>) JSON.deserialize(columnFilterList, List<FilterList>.class);
            if(!filterListt.isEmpty()){
                if(filterListt.size() == 1){
                    filter = filterListt[0].fieldName+' = '+'\''+filterListt[0].value+'\'';
                }else{
                    for(Integer iterateFilter = 0; iterateFilter < filterListt.size(); iterateFilter++){
                        // Try to use ternary operater here
                        if(iterateFilter == 0){
                            filter = filterListt[0].fieldName+' = '+'\''+filterListt[0].value+'\' AND ';
                        }else if(iterateFilter == filterListt.size()-1){
                            filter+= filterListt[iterateFilter].fieldName+' = '+'\''+filterListt[iterateFilter].value+'\'';
                        }else{
                            filter+= filterListt[iterateFilter].fieldName+' = '+'\''+filterListt[iterateFilter].value+'\' AND ';
                        }
                    }
                } 
            }
        }
        // Try to use ternary operater here 
        query = filter != NULL ? 'SELECT Id, Name, DeveloperName, Format, FolderName, Owner.Name FROM Report WHERE Id != NULL AND Name != NULL AND DeveloperName != NULL AND FolderName != NULL AND '+filter+' AND Name LIKE :searchKey' : 'SELECT Id, Name, DeveloperName, Format, FolderName, Owner.Name FROM Report WHERE Id != NULL AND Name != NULL AND DeveloperName != NULL AND FolderName != NULL AND Name LIKE :searchKey';      
        List<Report> reportList = Database.query(query); 
        if(!reportList.isEmpty()){
            for(Report iterateReportRecord : reportList){
                try {
                    Reports.ReportMetadata metadata = Reports.ReportManager.describeReport(iterateReportRecord.Id).getReportMetadata();                  
                    ReportWrapper createReportInstance = new ReportWrapper();
                    createReportInstance.id = iterateReportRecord.Id;
                    createReportInstance.name = iterateReportRecord.Name;
                    createReportInstance.developerName = iterateReportRecord.DeveloperName;
                    createReportInstance.folderName = iterateReportRecord.FolderName;
                    createReportInstance.ownerName = iterateReportRecord.Owner.Name;
                    createReportInstance.format = iterateReportRecord.Format;
                    createReportInstance.fieldscolumns = metadata.getDetailColumns();                   
                    List<Reports.ReportFilter> reportFilterList  = metadata.getReportFilters();
                    List<FilterWrapper> FilterWrapperList = new List<FilterWrapper>();
                    if(!reportFilterList.isEmpty()){
                        for(Reports.ReportFilter iterateReportFilter : reportFilterList){
                            FilterWrapper createFilterWrapper = new FilterWrapper();                           
                            createFilterWrapper.column = String.valueOf(iterateReportFilter.getColumn());
                            createFilterWrapper.filterType = String.valueOf(iterateReportFilter.getFilterType());
                            createFilterWrapper.operator = iterateReportFilter.getOperator();
                            createFilterWrapper.value = iterateReportFilter.getValue();                         
                            FilterWrapperList.add(createFilterWrapper);
                        }
                        createReportInstance.filterList = FilterWrapperList;
                    }else{
                        FilterWrapper createFilterWrapper = new FilterWrapper();                           
                        createFilterWrapper.column = nullValue;
                        createFilterWrapper.filterType = nullValue;
                        createFilterWrapper.operator = nullValue;
                        createFilterWrapper.value = nullValue;                         
                        FilterWrapperList.add(createFilterWrapper);
                        createReportInstance.filterList = FilterWrapperList; 
                    }
                    List<Reports.StandardFilter> standardFilterList = metadata.getStandardFilters();
                    List<StandardFilter> standardFilterWrapperList = new List<StandardFilter>();
                    if(!standardFilterList.isEmpty()){
                        for(Reports.StandardFilter iterateStandardFilter : standardFilterList){
                            StandardFilter createStandardFilter = new StandardFilter();
                            createStandardFilter.name = iterateStandardFilter.getName();   
                            createStandardFilter.value = iterateStandardFilter.getValue();                          
                            standardFilterWrapperList.add(createStandardFilter);
                        }
                        createReportInstance.standardFilters = standardFilterWrapperList;
                    }else{
                        StandardFilter createStandardFilter = new StandardFilter();
                        createStandardFilter.name = nullValue;                             
                        createStandardFilter.value = nullValue;
                        standardFilterWrapperList.add(createStandardFilter);
                        createReportInstance.standardFilters = standardFilterWrapperList;
                    }
                    List<Reports.CrossFilter> crossFilterList = metadata.getCrossFilters();
                    List<CrossFilter> crossFilterWrapperList = new List<CrossFilter>();
                    if(!crossFilterList.isEmpty()){
                        for(Reports.CrossFilter iterateCrossFilter : crossFilterList){
                            CrossFilter createCrossFilterWrapper = new CrossFilter();
                            createCrossFilterWrapper.includesObject = iterateCrossFilter.getIncludesObject();
                            createCrossFilterWrapper.primaryEntityField = iterateCrossFilter.getPrimaryEntityField();
                            createCrossFilterWrapper.relatedEntity = iterateCrossFilter.getRelatedEntity();
                            createCrossFilterWrapper.relatedEntityJoinField = iterateCrossFilter.getRelatedEntityJoinField();
                            crossFilterWrapperList.add(createCrossFilterWrapper);
                        }
                        createReportInstance.crossFilters = crossFilterWrapperList;
                    }else{
                        CrossFilter createCrossFilterWrapper = new CrossFilter();
                        createCrossFilterWrapper.includesObject = false;
                        createCrossFilterWrapper.primaryEntityField = nullValue;
                        createCrossFilterWrapper.relatedEntity = nullValue;
                        createCrossFilterWrapper.relatedEntityJoinField = nullValue;
                        crossFilterWrapperList.add(createCrossFilterWrapper);
                        createReportInstance.crossFilters = crossFilterWrapperList;
                    }
                    reportWrapperList.add(createReportInstance);             
                } catch (Reports.FeatureNotSupportedException e) {               
                    ExceptionHandlingClass.exceptionLogRecords('ReportsOfReport', 'getAllReports', e.getMessage(), e.getStackTraceString(), e.getLineNumber());                    
                }
            } 
        }
        return reportWrapperList;
    }
    
    public class ReportWrapper{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String developerName;
        @AuraEnabled public String folderName;
        @AuraEnabled public String description;
        @AuraEnabled public String ownerName;
        @AuraEnabled public String format;
        @AuraEnabled public List<String> fieldscolumns;
        @AuraEnabled public List<FilterWrapper> filterList;
        @AuraEnabled public List<CrossFilter> crossFilters;
        @AuraEnabled public List<StandardFilter> standardFilters;
    }
    
    public class StandardFilter{
        @AuraEnabled public String name;
        @AuraEnabled public String value;
    }
    
    public class CrossFilter{
        @AuraEnabled public Boolean includesObject;
        @AuraEnabled public String primaryEntityField;
        @AuraEnabled public String relatedEntity;
        @AuraEnabled public String relatedEntityJoinField;
    }
    
    public class FilterList{
        @AuraEnabled public String fieldName;
        @AuraEnabled public String value;
    }
    
    public class FilterWrapper{
        @AuraEnabled public String column;
        @AuraEnabled public String filterType;
        @AuraEnabled public String operator;
        @AuraEnabled public String value;
    }
}