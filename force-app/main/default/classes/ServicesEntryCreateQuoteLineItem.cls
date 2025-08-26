/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 20/05/2024
* @Description : This is automation for creating Quote Line Item;
******************************************************************/
public class ServicesEntryCreateQuoteLineItem { 
    /**************************************************************************************************************************
* @description : This method is create Quote Line Item (Trigger Method on Service Location).
* @param : List<Service_Location__c> serviceLocationList.
* @return : N/A.
***************************************************************************************************************************/
    public static void createQuotationSendtoCustomer(List<Service_Location__c> serviceLocationList){
        Map<String, List<PricebookEntry>> prodBookMap = new Map<String, List<PricebookEntry>>();
        Map<String, String> guidProductMap = new Map<String, String>();
        Map<Id, List<Opportunity>> accOpporListMap = new Map<Id, List<Opportunity>>();       
        Map<Id, List<String>> accGuidtMap = new Map<Id, List<String>>();
        Map<String, List<String>> guidProdCodesMap = new Map<String, List<String>>();
        Map<String, Id> prodCodeProIdMap = new Map<String, Id>();
        Map<Id, String> proIdGuidMap = new Map<Id, String>();
        Map<String, String> opporguidMap = new Map<String, String>();        
        Set<Id> quoteIds = new Set<Id>();
        Set<String> productCodeSet = new Set<String>();
        Set<String> guidSet = new Set<String>();
        List<Quote> quoteList = new List<Quote>();
        List<Id> priceBookLists = new List<Id>();        
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        
        for(Service_Location__c iterateServiceLocat : serviceLocationList){
            List<String> guidList = new List<String>();
            if(accGuidtMap.containskey(iterateServiceLocat.Account__c)){
                guidList = accGuidtMap.get(iterateServiceLocat.Account__c);
            }
            guidList.add(iterateServiceLocat.GUID__c);
            accGuidtMap.put(iterateServiceLocat.Account__c, guidList);
            guidSet.add(iterateServiceLocat.GUID__c);
        }        
        //fill Configration guIds        
        for(GUID__mdt iterateGuid : [SELECT GUIDS__c, Product_Code__c FROM GUID__mdt WHERE GUIDS__c = :guidSet]){           
            List<String> productCodesList = new List<String>();
            if(guidProdCodesMap.containsKey(iterateGuid.GUIDS__c)){
                productCodesList = guidProdCodesMap.get(iterateGuid.GUIDS__c);
            }
            productCodesList.add(iterateGuid.Product_Code__c);
            guidProdCodesMap.put(iterateGuid.GUIDS__c, productCodesList);
            productCodeSet.add(iterateGuid.Product_Code__c);
        }
        if(!productCodeSet.isEmpty()){
            for(Product2 iterate : [SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN : productCodeSet]){
                prodCodeProIdMap.put(iterate.ProductCode, iterate.Id);
            }}
        for(String iterateGuid : guidProdCodesMap.keySet()){
            for(String iterateProdCode : guidProdCodesMap.get(iterateGuid)){
                if(prodCodeProIdMap.containskey(iterateProdCode)){
                    proIdGuidMap.put(prodCodeProIdMap.get(iterateProdCode), iterateGuid);
                }
            }
        }
        for(Pricebook2 iterate :[SELECT Id FROM Pricebook2 WHERE IsStandard = true Limit 1]){
            priceBookLists.add(iterate.Id);
        }        
        List<PricebookEntry> priceBooksList = [SELECT Id, Name, Pricebook2Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id IN :proIdGuidMap.keyset() AND Pricebook2Id IN :priceBookLists];      
        if(priceBooksList.size() > 0){
            for(PricebookEntry iteratePriceBookEntry : priceBooksList){
                List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
                if(prodBookMap.containsKey(proIdGuidMap.get(iteratePriceBookEntry.Product2Id))){
                    priceBookEntryList = prodBookMap.get(proIdGuidMap.get(iteratePriceBookEntry.Product2Id));                    
                }            
                priceBookEntryList.add(iteratePriceBookEntry);
                prodBookMap.put(proIdGuidMap.get(iteratePriceBookEntry.Product2Id), priceBookEntryList);            
            } 
        }
        for(Opportunity iterateOppor : [SELECT Id, AccountId, Owner.Email FROM Opportunity WHERE AccountId IN :accGuidtMap.keyset()]){        
            List<Opportunity> opportList = new List<Opportunity>();
            if(accOpporListMap.containsKey(iterateOppor.AccountId)){
                opportList = accOpporListMap.get(iterateOppor.AccountId);
            }
            opportList.add(iterateOppor);
            accOpporListMap.put(iterateOppor.AccountId, opportList);                        
        }        
        for(Id iterateAcc : accOpporListMap.keyset()){
            for(Opportunity iterateOppor : accOpporListMap.get(iterateAcc)){
                for(String iterateGuid : accGuidtMap.get(iterateOppor.AccountId)){
                    Quote createQuote = new Quote();
                    createQuote.Name = iterateGuid; 
                    createQuote.OpportunityId = iterateOppor.Id;
                    createQuote.Pricebook2Id = priceBookLists[0];
                    createQuote.Email = iterateOppor.Owner.Email;
                    quoteList.add(createQuote); 
                    opporguidMap.put(iterateOppor.Id+'-'+iterateGuid, iterateGuid);
                }                       
            }         
        }
        try{
            if(!quoteList.isEmpty() && quoteList.size() > 0) {
                Database.insert(quoteList, false);                     //Quote Insertion
            }
            for(Quote iterateQuotation : quoteList){ 
                String key = iterateQuotation.OpportunityId+'-'+iterateQuotation.Name;
                if(opporguidMap.containsKey(key) && prodBookMap.containsKey(opporguidMap.get(key))){
                    for(PricebookEntry iteratePriceBook : prodBookMap.get(opporguidMap.get(key))){
                        QuoteLineItem createQuoteListItem = new QuoteLineItem();
                        createQuoteListItem.QuoteId = iterateQuotation.Id;
                        createQuoteListItem.UnitPrice = iteratePriceBook.UnitPrice;
                        createQuoteListItem.PricebookEntryId = iteratePriceBook.Id;
                        createQuoteListItem.Quantity = 2;
                        quoteLineItemList.add(createQuoteListItem);                                             
                    }                
                }
                quoteIds.add(iterateQuotation.Id);
            }
            if(!quoteLineItemList.isEmpty() && quoteLineItemList.size() > 0) {
                Database.insert(quoteLineItemList);   //QuoteLineItem Insertion with priceBook Entry
            }            
            generateQuotePDF(quoteIds); 
           }catch(Exception e){
            System.debug('Error--'+e.getMessage());
          }
        
    } 
    
    /**************************************************************************************************************************
* @description : This method is for generate pdf and send Quote tto Account Owner.
* @param : Set<Id> quoteIdSet.
* @return : N/A.
***************************************************************************************************************************/
    @future(callout=true)
    public static  void generateQuotePDF(Set<Id> quoteIdSet) {
        List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Quote> quoteList = [SELECT Id, Name, QuoteNumber, Email FROM Quote WHERE Id IN :quoteIdSet]; 
        Map<String, List<Messaging.EmailFileAttachment>> mailAttachmentsMap = new Map<String, List<Messaging.EmailFileAttachment>>(); //same owner have attach multiple emails
        if(!quoteIdSet.isEmpty() && quoteIdSet.size() > 0) {            
            for(Quote iterateQuote :quoteList) { 
                List<Messaging.EmailFileAttachment> attchments = new List<Messaging.EmailFileAttachment>();           
                PageReference quotePage = new PageReference('/apex/QuotePDFPage');
                quotePage.getParameters().put('id', iterateQuote.Id);
                Blob quoteBlob;
                try {
                    quoteBlob = quotePage.getContentAsPDF();
                    if(mailAttachmentsMap.containsKey(iterateQuote.Email)){
                        attchments = mailAttachmentsMap.get(iterateQuote.Email);
                    }
                    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                    attach.setContentType('application/pdf');                    
                    String fileName = 'Quotation'+iterateQuote.Id+'.pdf';
                    attach.setFileName(fileName);        
                    attach.Body = quoteBlob; 
                    attchments.add(attach);    
                    mailAttachmentsMap.put(String.valueOf(iterateQuote.Email), attchments);                   
                } catch(Exception e) {
                    System.debug('Error generating PDF: ' + e.getMessage());        
                }              
                QuoteDocument quoteDoc = new QuoteDocument();
                quoteDoc.Document = quoteBlob;
                quoteDoc.QuoteId = iterateQuote.Id;                
                lstQuoteDoc.add(quoteDoc);
            }
        }
        if(!lstQuoteDoc.isEmpty() && lstQuoteDoc.size() > 0) {
            Database.insert(lstQuoteDoc);
        }
        System.debug('mailAttachmentsMap===>'+mailAttachmentsMap);
        for(String iterateEmail : mailAttachmentsMap.keyset()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();           
            mail.setToAddresses(new String[] {iterateEmail});
            mail.setSubject('Quotation');
            mail.setHtmlBody('Hello Sir/Ma\'am, <BR><BR> Here Your quotation');
            mail.setFileAttachments(mailAttachmentsMap.get(iterateEmail));     
            mails.add(mail);            
        }       
        System.debug('mails==>'+mails);
        if(!mails.isEmpty())
        {
            Messaging.SendEmail(mails);
        }
    }
    /**************************************************************************************************************************
* @description : This method is for send Mail after Update quote line item.
* @param : List<Quote> quoteList.
* @return : N/A.
***************************************************************************************************************************/
    public static void sendMailafterUpdateQuote(List<Quote> quoteList){
        Set<Id> quoteIds = new Set<Id>();
        for(Quote iterate : quoteList){
            quoteIds.add(iterate.Id);  
        }
        generateQuotePDF(quoteIds);
    }
}