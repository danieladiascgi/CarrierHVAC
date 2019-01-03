@isTest(SeeAllData=true)
public class CCC_getJobDetailsTest{
Static testMethod void method1(){
CCC_getJobDetails getjob=new CCC_getJobDetails();
Case newCase=new Case();
newcase=[Select Id from case limit 1];
CCC_getJobDetails.getJobDetails(newCase.Id);
}
}