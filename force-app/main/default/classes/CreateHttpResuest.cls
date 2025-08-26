/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 06/12/2023
* @Description : Class of Create HTTP Request Framework.
******************************************************************/
public class CreateHttpResuest {
    
     /**************************************************************************************************************************
	* @description : This method is for HttpRequest Framework.
	* @param : String endPoint, String method, String typeHeader, String typeOfHeader, String body.
	* @return : HttpRequest.
	***************************************************************************************************************************/
    public static HttpRequest returnHttpRequest(String endPoint, String method, String typeHeader, String typeOfHeader, String body){
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endPoint);
        request.setMethod(method);
        request.setHeader(typeHeader , typeOfHeader);        
        request.setBody(body);
        return request;
    }
}