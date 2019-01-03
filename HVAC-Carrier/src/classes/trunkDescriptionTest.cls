@isTest(seeAllData=True)
public Class trunkDescriptionTest
{
    Static testMethod void method1()
    {
        Task newTask= new Task();
        newTask.Trunk_Number__c='7301';
        newTask.Subject='Call';
        
        insert newTask;
    }

}