public class SendMailSuccessFileInsertByTrigger {
    //Quesion On Send Mail with FileName When Insert a file
    public static void successfullyInsertAfterInsertFile(List<ContentDocument> newContentDoclist){
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(ContentDocument IterateConDoc : newContentDoclist){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{'ajay.rajput@algocirrus.com'});
            mail.setSubject('Document Inserted');
            String body = '<h4 Style="color:green">Hello Sir, Your file is Inserted Successfully'+IterateConDoc.Title+'</h4>';
            mail.setHTMLBody(body);
            messages.add(mail);            
        }
        Messaging.sendEmail(messages);        
    }
    
    //Quesion On Send mail with attach all files of an object
    public static void successfullyInsertAfterInsertFileWithAttachFile(List<ContentDocumentLink> newContentVerList){
        Messaging.SingleEmailMessage messages = new Messaging.SingleEmailMessage();  
        List<Messaging.EmailFileAttachment> filesAttachs = new List<Messaging.EmailFileAttachment>();
        Set<Id> newDocLinkedIds = new Set<Id>();        
        Set<Id> newDocIds = new Set<Id>();
        for(ContentDocumentLink iterateDocId : newContentVerList){
            newDocLinkedIds.add(iterateDocId.LinkedEntityId);
        } 
        newDocLinkedIds.remove(userInfo.getUserId());         
        for(ContentDocumentLink iterateDocIds : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN : newDocLinkedIds]){
            newDocIds.add(iterateDocIds.ContentDocumentId);
        }        
        for(ContentVersion iterateConDoc : [SELECT Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId IN :newDocIds]){    
            Blob filebody = iterateConDoc.VersionData;  
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setFileName(iterateConDoc.Title);
            attach.setBody(filebody);            
            filesAttachs.add(attach);
        } 
        messages.setToAddresses(new List<String>{'lokesh.patel@algocirrus.com'});
        messages.setSaveAsActivity(false);
        messages.setSubject('Document Inserted');
        String body = '<h4 Style="color:green">Hello Sir/Ma\'am,<br> Your file is Inserted Successfully</h4>';
        messages.setFileAttachments(filesAttachs);
        messages.setHTMLBody(body);  
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{messages}); 
    }
    
    //Question On Send Mail with attach table and files of an Object
    public static void AfterInsertFileAttachTable(List<ContentDocumentLink> newContentVerList){
        Messaging.SingleEmailMessage messages = new Messaging.SingleEmailMessage();  
        List<Messaging.EmailFileAttachment> filesAttachs = new List<Messaging.EmailFileAttachment>();        
        Set<Id> newDocLinkedIds = new Set<Id>();
        Set<Id> newDocIds = new Set<Id>();
        Map<Id, String> mapOfUrlPublicLink = new Map<Id, String>();
        String tableData ='';        
        List<ContentDistribution> listConVer = new List<ContentDistribution>();
        
        for(ContentDocumentLink iterateDocId : newContentVerList){
            newDocLinkedIds.add(iterateDocId.LinkedEntityId);
        } 
        newDocLinkedIds.remove(userInfo.getUserId()); 
        List<String> emailList = new List<String>();
        for(Contact iterateCon : [SELECT Email FROM Contact WHERE Id IN :newDocLinkedIds AND Email != NULL]){
            emailList.add(iterateCon.Email);
        }
            
        for(ContentDocumentLink iterateDocIds : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN : newDocLinkedIds]){
            newDocIds.add(iterateDocIds.ContentDocumentId);
        }       
        for(ContentVersion iterateConDoc : [SELECT Id, ContentDocumentId, Title, VersionData, CreatedDate, FileExtension, ContentSize FROM ContentVersion WHERE ContentDocumentId IN :newDocIds]){  
            ContentDistribution conDist = new ContentDistribution();
            conDist.name = iterateConDoc.Title;
            conDist.ContentVersionId = iterateConDoc.Id;
            conDist.PreferencesAllowOriginalDownload = true;
            conDist.PreferencesAllowPDFDownload = true;
            conDist.PreferencesAllowViewInBrowser = true;
            listConVer.add(conDist); 
        }
        insert listConVer; 
        for(ContentDistribution url: [Select Id,ContentDocumentId,ContentDownloadUrl,DistributionPublicUrl from ContentDistribution where ContentDocumentId IN :newDocIds]){
            mapOfUrlPublicLink.put(url.ContentDocumentId, url.DistributionPublicUrl);           
        }
        
        for(ContentVersion iterateConDoc : [SELECT Id, ContentDocumentId, Title, VersionData, CreatedDate, FileExtension, ContentSize FROM ContentVersion WHERE ContentDocumentId IN :newDocIds]){            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            Blob filebody = iterateConDoc.VersionData;            
            attach.setFileName(iterateConDoc.Title);
            attach.setBody(filebody);            
            filesAttachs.add(attach);
            if(mapOfUrlPublicLink.containsKey(iterateConDoc.ContentDocumentId)){
                tableData+='<tr><td><a href="'+mapOfUrlPublicLink.get(iterateConDoc.ContentDocumentId)+'" id="ach">'+iterateConDoc.Title+'</a></td><td>'+iterateConDoc.FileExtension+'</td><td>'+iterateConDoc.ContentSize+'</td><td>'+iterateConDoc.CreatedDate+'</td></tr>';
            }            
        } 
        System.debug(filesAttachs.size());
        //messages.setToAddresses(new List<String>{'kunal.garg@algocirrus.com'});
        messages.setToAddresses(emailList);
        messages.setSaveAsActivity(false);
        messages.setSubject('Document Inserted');
        String body = '<html><head><style> table, th, td{border: 1px solid black; padding:10px; border-collapse: collapse;} #tb{ background-color: #96D4D4; color:#000;} #tbhead{background-image: linear-gradient(to right top, #f026a7, #ff406a, #ff7d2e, #ecb400, #afe132); color:#ffffff;} #ach{text-decoration:none;} </style></head><body><h4>Hello Sir/Ma\'am,<br> Your file is Inserted Successfully <br> <table><tr id="tbhead"><th>Title</th><th>ContentType</th><th>Size</th><th>UploadDateTime</th></tr><tbody id="tb">'+tableData+'</tbody></table></h4></body></html>';
        messages.setFileAttachments(filesAttachs);
        messages.setHTMLBody(body);  
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{messages});  
    }
    
    
}