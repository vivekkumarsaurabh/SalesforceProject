public class ReturnRestContextFramework {
    public static RestRequest returnRestReq(String endPoint, String method, String body){
        RestRequest request = new RestRequest();
        request.requestUri = endPoint;
        request.httpMethod = method;
      //  request.addHeader('Authorization', 'Bearer '+System.Label.WHATSAPPSECRET);
        request.addHeader('Content-type','application/json');
        request.requestBody = Blob.valueOf(body);
        return request;
    }
}