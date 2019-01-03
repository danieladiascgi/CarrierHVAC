@IsTest
public class WebServicePartnerReq_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Partner\": ['+
		'    {'+
		'      \"CCC_Relationship\": \"Brand\",'+
		'      \"HVP\": "1234567",'+
		'      \"CCC_Distributor\": \"0010m00000GmaTc\",'+
		'      \"CCC_Dealer\": \"0010m00000GlGEG\",'+
		'      \"CIN\": \"Prod569876tfguh\",'+
		'      \"Partner_External_ID\": \"Prod569876tfguh\"'+
		'    },'+
		'    {'+
		'      \"CCC_Relationship\": \"Brand\",'+
		'      \"HVP\": "1234567",'+
		'      \"CCC_Distributor\": \"0010m00000GmaTc\",'+
		'      \"CCC_Dealer\": \"0010m00000GlGEG\",'+
		'      \"CIN\": \"Prod569876tfguh\",'+
		'      \"Partner_External_ID\": \"Prod569876tfguh\"'+
		'    }'+
		'  ]'+
		'}';
		WebServicePartnerReq obj = WebServicePartnerReq.parse(json);
		System.assert(obj != null);
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(json);
        
        RestContext.request = request;
        PartnerWebServiceCall.PartnerResponseWrapper responseJSON = PartnerWebServiceCall.upsertPartner();
	}
}