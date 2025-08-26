public class CreateCustomReportType {
    public void createReportType() {
       // String endpoint = 'https://yourInstance.salesforce.com/services/Soap/m/53.0';     
       String endpoint = 'https://algocirruspvtltd-6d-dev-ed.develop.lightning.force.com/services/Soap/m/53.0';        
   
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setBody(createReportTypeRequestBody());
        
        Http http = new Http();
        HttpResponse res = http.send(req);       
        
        System.debug('resBody---->'+res.getBody());
    }
    
    private String createReportTypeRequestBody() {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
             '<ReportType xmlns="http://soap.sforce.com/2006/04/metadata">'+
             '<baseObject>Account</baseObject'+
            '<category>accounts</category>'+
    '<deployed>true</deployed>'+
    '<description>Account linked to Contacts and Assets</description>'+
    '<join>'+
        '<join>'+
            '<outerJoin>false</outerJoin>'+
            '<relationship>Assets</relationship>'+
        '</join>'+
        '<outerJoin>false</outerJoin>'+
        '<relationship>Contacts</relationship>'+
    '</join>'+
    '<label>Account Contacts and Assets</label>'+
    '<sections>'+
        '<columns>'+
            '<checkedByDefault>true</checkedByDefault>'+
            '<field>obj_lookup__c.Id</field>'+
            '<table>Account</table>'+
        '</columns>'+
        '<columns>'+
            '<checkedByDefault>false</checkedByDefault>'+
            '<field>obj_lookup__c.Name</field>'+
            '<table>Account</table>'+
        '</columns>'+
        '<columns>'+
          '<checkedByDefault>false</checkedByDefault>'+
           '<field>Opportunity__c.Amount</field>'+
            '<table>Account</table>'+
        '</columns>'+
        '<columns>'+
            '<checkedByDefault>false</checkedByDefault>'+
            '<field>Owner.IsActive</field>'+
            '<table>Account</table>'+
        '</columns>'+
        '<masterLabel>Accounts</masterLabel>'+
    '</sections>'+
    '<sections>'+
        '<columns>'+
            '<checkedByDefault>false</checkedByDefault>'+
            '<field>Owner.Email</field>'+
            '<table>Account.Contacts</table>'+
        '</columns>'+
        '<columns>'+
           '<checkedByDefault>false</checkedByDefault>'+
            '<field>byr__c</field>'+
            '<table>Account.Contacts</table>'+
        '</columns>'+
       '<columns>'+
            '<checkedByDefault>true</checkedByDefault>'+
            '<field>ReportsTo.CreatedBy.Contact.Owner.MobilePhone</field>'+
            '<table>Account.Contacts</table>'+
        '</columns>'+
        '<masterLabel>Contacts</masterLabel>'+
    '</sections>'+
'</ReportType>';
    }
}