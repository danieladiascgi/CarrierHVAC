@isTest(SeeAllData=True)
public class PHDBAccessTokenGeneratorTest{

public static testMethod void testSchedule()
{
test.startTest();
PHDBAccessTokenGenerator PHDBATG=new PHDBAccessTokenGenerator();
String sch = '0 0 23 * * ?'; system.schedule('Token Schedule', sch, PHDBATG);
Test.stopTest();
}
}