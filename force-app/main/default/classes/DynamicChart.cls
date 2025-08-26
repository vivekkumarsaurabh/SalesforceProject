/*
* @Description : This class is used for made Report Of Chart in LWC;
* @author      : Vivek Kumar Saurabh
* @date        : 18/10/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 18/10/2024
*/
public class DynamicChart {
    
    /*
	* @description : This method is for get all report and return all Report data with report IdName.
	* @param : N/A.
	* @return : Map<String, List<Map<String, Object>>> .
	*/     
    @AuraEnabled
    public static Map<String, List<Map<String, Object>>> getReports(){
        System.debug('aaya');
        Map<String, List<Map<String, Object>>> reportWithMultipleDataMap = new Map<String, List<Map<String, Object>>>();
        for(Report iterateReport : [SELECT Id, Name FROM Report WHERE Id = '00O5j000007RTujEAG' AND Name != NULL LIMIT 1]){
            List<Map<String, Object>> reportDataList = chartData(iterateReport.Id);
            String idNameKey = iterateReport.Id+'-'+iterateReport.Name;
            reportWithMultipleDataMap.put(idNameKey, reportDataList);
        }
        System.debug('reportWithMultipleDataMap---->'+reportWithMultipleDataMap);
       return reportWithMultipleDataMap; 
    }
    
    /*
	* @description : This method is return chart Data.
	* @param : String reportId take reportId  of report.
	* @return : List<Map<String, Object>> reportDateList.
	*/ 
    @AuraEnabled
    public static List<Map<String, Object>> chartData(String reportId){
        List<Map<String, Object>> reportDateList = new List<Map<String, Object>>();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        //String reportId = '00O5j000007RTujEAG';
        // String reportId = '00O5j000007RRwREAW';
        try{
            if(reportId != NULL){
                // Run the report and retrieve the report data in Excel format
                String baseURL = URL.getOrgDomainURL().toExternalForm();
                String reportUrl = baseURL+'/services/data/v58.0/analytics/reports/' + reportId + '?view=dom.Excel';
                HttpRequest httpReq = new HttpRequest();
                httpReq.setHeader('Authorization', 'Bearer ' + CustomListView.apiEnabledSessionId());
                httpReq.setHeader('Content-Type','application/json');
                httpReq.setEndpoint(reportUrl);
                httpReq.setMethod('GET');
                Blob reportData = http.send(httpReq).getBodyAsBlob();
                if(reportData != NULL){
                    String reportString = reportData.toString();    
                    System.debug('reportString---->'+reportString);
                    reportDateList = parseExcelToData(reportString);   
                }            
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('DynamicChart', 'chartData', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        } 
        return reportDateList;
    }
    
    /*
	* @description : This method is parserExcel to Data.
	* @param : String jsonData JsonData of report.
	* @return : List<Map<String, Object>> parseData return parse Data.
	*/ 
    @AuraEnabled
    public static List<Map<String, Object>> parseExcelToData(String jsonData) {        
        List<Map<String, Object>> parsedData = new List<Map<String, Object>>(); 
        try{
            if(jsonData != NULL){
                // Parse the JSON string into a Map        
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonData);        
                //get column
                Map<String, Object> reportMetadata = (Map<String, Object>) jsonMap.get('reportMetadata');
                List<String> columns = new List<String>();
                if(reportMetadata != NULL){
                    Object getColumn = reportMetadata.get('detailColumns');
                    String removeBracesFromColumn = getColumn.toString().remove('(').remove(')');
                    columns = removeBracesFromColumn.split(',');
                }                
                // Navigate to the relevant data (the factMap and its rows)
                Map<String, Object> factMap = (Map<String, Object>) jsonMap.get('factMap');
                if(factMap != NULL){
                    for(String iterateKey : factMap.keySet()){            
                        Map<String, Object> fact = (Map<String, Object>) factMap.get(iterateKey);            
                        List<Object> rows = (List<Object>) fact.get('rows');            
                        if(!rows.isEmpty() && !columns.isEmpty()){                
                            for (Object rowObj : rows) {                    
                                Map<String, Object> rowData = (Map<String, Object>) rowObj;
                                List<Object> dataCells = (List<Object>) rowData.get('dataCells');                    
                                Map<String, Object> rowMap = new Map<String, Object>();                    
                                for (Integer iterateDataCell = 0; iterateDataCell < dataCells.size(); iterateDataCell++) {
                                    Map<String, Object> cell = (Map<String, Object>) dataCells.get(iterateDataCell);
                                    rowMap.put(columns[iterateDataCell], cell.get('label'));
                                }                    
                                parsedData.add(rowMap);
                            }
                        }
                    } //end for loop
                }
            }
        }catch(Exception e){
            ExceptionHandlingClass.exceptionLogRecords('DynamicChart', 'parseExcelToData', e.getMessage(), e.getStackTraceString(), e.getLineNumber());
        } 
        return parsedData;
    }
    
}