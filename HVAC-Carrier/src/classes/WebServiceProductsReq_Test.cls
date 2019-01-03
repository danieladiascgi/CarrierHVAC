@IsTest
public class WebServiceProductsReq_Test {    
    
    static testMethod void testParse() {
        String json = '{'+
            '  \"records\": ['+
            '    {'+
            '      \"Name\": \"SampleProduct1\",'+
            '      \"Active__c\": \"true\",'+
            '      \"Brand__c\": \"Brand\",'+
            '      \"External_ID__c\": \"10345udgft65fd\",'+
            '      \"Material_Number__c\": \"Prod569876tfguh\"'+
            '    },'+
            '    {'+
            '      \"Name\": \"SampleProduct1\",'+
            '      \"Active__c\": \"true\",'+
            '      \"Brand__c\": \"Brand\",'+
            '      \"External_ID__c\": \"10345udgft65fd\",'+
            '      \"Material_Number__c\": \"Prod569876tfguh\"'+
            '    },'+
            '    {'+
            '      \"Name\": \"SampleProduct1\",'+
            '      \"Active__c\": \"true\",'+
            '      \"Brand__c\": \"Brand\",'+
            '      \"External_ID__c\": \"10345udgft65fd\",'+
            '      \"Material_Number__c\": \"Prod569876tfguh\"'+
            '    },'+
            '    {'+
            '      \"Name\": \"SampleProduct1\",'+
            '      \"Active__c\": \"true\",'+
            '      \"Brand__c\": \"Brand\",'+
            '      \"External_ID__c\": \"10345udgft65fd\",'+
            '      \"Material_Number__c\": \"Prod569876tfguh\"'+
            '    },'+
            '    {'+
            '      \"Name\": \"SampleProduct1\",'+
            '      \"Active__c\": \"true\",'+
            '      \"Brand__c\": \"Brand\",'+
            '      \"External_ID__c\": \"10345udgft65fd\",'+
            '      \"Material_Number__c\": \"Prod569876tfguh\"'+
            '    }'+
            '  ]'+
            '}';
        WebServiceProductsReq obj = WebServiceProductsReq.parse(json);
        System.assert(obj != null);
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(json);
        
        RestContext.request = request;
        ProductsWebServiceCall.ResponseWrapper responseJSON = ProductsWebServiceCall.upsertProducts();
    }
}