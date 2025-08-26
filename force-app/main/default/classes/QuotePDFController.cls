public class QuotePDFController {
    public Quote quote { get; private set; }
    public List<QuoteLineItem> quoteLineItem {get; private set;}
    public QuotePDFController() {
        // Retrieve Quote record
        String quoteId = ApexPages.currentPage().getParameters().get('id');
        quote = [SELECT Id, Name, QuoteNumber, ExpirationDate, TotalPrice FROM Quote WHERE Id = :quoteId];
        quoteLineItem = [SELECT QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, TotalPrice, Product2.Name FROM QuoteLineItem WHERE QuoteId = :quote.Id];
        
    }
    
    public static String returnCurrency(String currencyIsoCode, String rupees){
        String code;
        if(currencyIsoCode == 'INR'){
            return code = '₹'+rupees;
        }
        return code;
    }
}