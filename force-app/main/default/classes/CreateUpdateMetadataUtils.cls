/*
* @Description : This class is used to Create or Update Metadata records;
* @author      : Vivek Kumar Saurabh
* @Created Date: 02/08/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 02/08/2024
*/
public class CreateUpdateMetadataUtils implements Metadata.DeployCallback {
    
    /*
* @description : This method is used for check our update metadata record sequece.
* @param : Metadata.DeployResult result  In this we take params as result which is deploy, Metadata.DeployCallbackContext context  that is callback context which is return JobId of this .
* @return : N/A.
*/       
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
    }
    
    /*
* @description : This method is used for create and update metadata record.
* @param : String fullName In this we send as params full name of Metadata and fieldName, String label fieldName as a label, Map<String, Object> fieldWithValuesMap record values which is .
* @return : N/A.
*/  
    public static void createUpdateMetadata(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;        
        for(String key : fieldWithValuesMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldWithValuesMap.get(key); 
            customMetadata.values.add(customField);
        }        
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        CreateUpdateMetadataUtils callback = new CreateUpdateMetadataUtils();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
}