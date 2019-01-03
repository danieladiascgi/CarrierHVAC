public class WebServicePartnerReq {

	public List<Partner> Partner;

	public class Partner {
		public String CCC_Relationship;
		public String HVP;
		public String CCC_Distributor;
		public String CCC_Dealer;
		public String CIN;
		public String Partner_External_ID;
	}

	
	public static WebServicePartnerReq parse(String json) {
		return (WebServicePartnerReq) System.JSON.deserialize(json, WebServicePartnerReq.class);
	}
}