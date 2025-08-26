public class GraphQLApex {
    //get all contacts with account Name using this is body .
   // String graphqlQuery = 'query contactsByTheirAccountName {  uiapi {  query {  Contact {   edges {    node {  Id Name { value } Account { Name {value} }}}}}}}';
       String graphqlQuery = '{ contacts { edges { node { id name account { name } } } } }';

    
  // Method to make a POST request to a GraphQL API
    public static String executeGraphQLQuery(String graphqlQuery) {
        // Set the GraphQL endpoint URL
        String graphqlEndpoint = 'https://algocirruspvtltd-6d-dev-ed.develop.my.salesforce.com/services/data/v59.0/graphql'; // Replace with your actual GraphQL endpoint
       
        // Create the HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(graphqlEndpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        String payload = '{"query": "' + graphqlQuery + '"}';
        req.setBody(payload);
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Check the response status
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
            return null;
        }
    }
    
}