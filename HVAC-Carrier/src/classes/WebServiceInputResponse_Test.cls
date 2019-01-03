@IsTest
public class WebServiceInputResponse_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'   \"KQuoteResponse\": {'+
		'      \"Response\": {'+
		'         \"SalesDeal_Details\": {'+
		'            \"Sales_Deal\": \"0006007438\",'+
		'            \"Sales_Deal_Desc\": \"Claim Rewrite Test1_ICP\",'+
		'            \"Distributor\": \"0000110905\",'+
		'            \"Price_List\": \"5A\",'+
		'            \"HDR_Valid_From_Date\": 20180716,'+
		'            \"HDR_Valid_To_Date\": 20181231,'+
		'            \"KD_Level\": 1600,'+
		'            \"KD_Level_Desc\": \"RESIDENTIAL SUPER MEGA\",'+
		'            \"REF_QUOTE\": \"K06J8553\",'+
		'            \"Dealer_Details\": {'+
		'               \"Dealer\": \"HVP999999\",'+
		'               \"DLR_Valid_From_Date\": 20180716,'+
		'               \"DLR_Valid_To_Date\": 20181231'+
		'            },'+
		'            \"Material_Details\": ['+
		'               {'+
		'                  \"Material_Entered\": \"N4A324AKG\",'+
		'                  \"Brand\": \"UCF\",'+
		'                  \"Sell_Price\": \"       662\",'+
		'                  \"Buy_Price\": \"       543\",'+
		'                  \"ITEM_Valid_From_Date\": 20180716,'+
		'                  \"ITEM_Valid_To_Date\": 20181231'+
		'               },'+
		'               {'+
		'                  \"Material_Entered\": \"CAS151HAA0A00A\",'+
		'                  \"Brand\": \"UTX\",'+
		'                  \"Sell_Price\": \"      3800\",'+
		'                  \"Buy_Price\": \"      3750\",'+
		'                  \"ITEM_Valid_From_Date\": 20180716,'+
		'                  \"ITEM_Valid_To_Date\": 20181231'+
		'               }'+
		'            ]'+
		'         }'+
		'      }'+
		'   }'+
		'}';
		WebServiceInputResponse obj = WebServiceInputResponse.parse(json);
		System.assert(obj != null);
	}
}