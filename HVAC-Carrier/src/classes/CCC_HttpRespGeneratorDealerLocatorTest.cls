@isTest
Global class CCC_HttpRespGeneratorDealerLocatorTest implements HttpCalloutMock
{
public static String siteType='Consumer';
public static String brand= 'CA';
public static String searchType='territory';
public static String zip='13206';
public static integer dealerCount=20;
public static String country='USA';
public static Integer radius=25;
public static String filters='All Dealers';

public static String body;

Global HttpResponse respond(HttpRequest req)
{
String clientKey = '6B8A7EE7-9046-4F2D-A511-8BCE992AB2FB';      
String baseURL = 'http://www.services.hvacpartners.com/RDLWebService/ResidentialDealerLocator.asmx/GetDealers?strClientKey='+clientKey;        
 // asserting the endpoin from webservice an from mock
 System.assertEquals(baseURL+'&strSiteType='+siteType+'&strBrand='+brand+'&strSearchType='+searchType+'&strZip='+zip+'&idealerCount='+dealerCount+'&strCountry='+country+'&iSearchRadius='+radius+'&strFilter='+filters,req.getEndpoint());      
 
 body='<DealerLocatorResults><Dealers><Dealer DealerId="23912"><Icons><ProductOfferings><Generator>0</Generator><DFS>0</DFS><Geothermal>0</Geothermal><HealthyAir>1</HealthyAir></ProductOfferings><SpeaksSpanish>0</SpeaksSpanish><FactoryAuthorizedDealer>1</FactoryAuthorizedDealer><NATEDealer>1</NATEDealer><PastDealerOfTheYear>0</PastDealerOfTheYear><DistinguishedDealer>0</DistinguishedDealer><PinnacleDealer>0</PinnacleDealer><EnergyExpert>0</EnergyExpert><OffersFinancing>1</OffersFinancing><OffersPromotion1>0</OffersPromotion1><OffersPromotion2>0</OffersPromotion2><IndoorAirSpecialistDealer>0</IndoorAirSpecialistDealer></Icons>';
 body+='<DealerName>Burkhardt Heating &amp; Air Conditioning</DealerName><PostalAddress>8232 N Teutonia Ave</PostalAddress><City>Milwaukee</City><State>WI</State><ZipCode>53209</ZipCode><Country>USA</Country><Phone>414-214-2932</Phone><TollFree /><Fax>414-355-5506</Fax><Email /><Website>http://www.burkhardtheating.com</Website><MarketingMessage /><RetailStore>0</RetailStore><HoursOfOperation>Available 24/7 for all Calls</HoursOfOperation><YearsInBusiness>More than 50 years of serving homeowners</YearsInBusiness>';
 body+=' <LeadEligible>0</LeadEligible><DistanceInMiles>0</DistanceInMiles><DistanceInKM>0</DistanceInKM><Latitude>0.752781450336178</Latitude><Longitude>-1.53497344389771</Longitude><MapURL>http://www.apps.hvacpartners.com/dealerlocatorcustomercare/SiteAdvantage/Advantage.aspx?transaction=locMap&amp;country=US&amp;address=8232+N+Teutonia+Ave&amp;city=Milwaukee&amp;stateProvince=WI&amp;postalCode=53209&amp;AppVersion=BR</MapURL><ContactFormURL>http://www.apps.hvacpartners.com/dealerlocatorcustomercare/DealerSearch/br/ContactForm.aspx?zipcode=53209&amp;DealerId=23912</ContactFormURL></Dealer></Dealers></DealerLocatorResults>';
HttpResponse res= new HttpResponse();
 res.setBody(body);
return res;
}// method response(HttpRequest req)

}//class HttpResponseGeneratorDealerLocator