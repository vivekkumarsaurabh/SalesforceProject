/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 07/12/2023
* @Description : Class of request of Composite API.
******************************************************************/
public class CompositeApiCreateRecords {
    
    /**************************************************************************************************************************
	* @description : This method is for create Record with Composite API .
	* @param : String method, String objName, Object obj.
	* @return : N/A.
	***************************************************************************************************************************/
    public static void createRecordWithCompositApi(String method, String objName, List<Object> obj){
        HttpResponse response = new HttpResponse();
        HttpRequest request = new HttpRequest();
        Http http = new Http(); 
        String body = createRecord(method, objName, obj);
        request = CreateHttpResuest.returnHttpRequest('callout:CredentialFirst/services/data/v59.0/composite/', 'POST', 'Content-Type', 'application/json', body);
        response = http.send(request);
        System.debug('response ===>'+response);
        System.debug('response body == >'+response.getBody());        
    }
    
    /**************************************************************************************************************************
	* @description : This method is create composite body of given object .
	* @param : String method, String objName, Object obj.
	* @return : String body.
	***************************************************************************************************************************/
    public static String createRecord(String method, String objName, List<Object> obj){
        String jsonStr = JSON.serialize(obj); 
        String body = '{"compositeRequest" : [{"method":"'+method+'","url":"/services/data/v59.0/sobjects/'+objName+'","referenceId":"ref'+objName+'","body":{'+jsonStr+'}]}';
        body  = body.remove('{"attributes":{"type":"'+objName+'"},');
        return body;
    }
}