global class CCC_BatchDeletion_Partner implements Database.Batchable<sObject>, Schedulable 
{   
    
    
    global CCC_BatchDeletion_Partner()
    {
           //constuctor  
    }
        
        
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //query to return all modify partner records         
        return Database.getQueryLocator([Select id from CCC_Partner__c where CCC_Integration_field__c='Modify']);
    } 
    
    global void execute(SchedulableContext sc)  
    {   
        //execute the batch
        CCC_BatchDeletion_Partner deleteCS = new CCC_BatchDeletion_Partner();
        ID batchprocessid = Database.executeBatch(deleteCS);
    }
    
    global void execute(Database.BatchableContext BC, list<sObject> scope)
    {     
      System.debug('## deleting '+scope.size()+' case share recs');   
 
        //delete list of expired Case Share records
            delete scope;   
            DataBase.emptyRecycleBin(scope); 
    }
    
    
    global void finish(Database.BatchableContext BC) 
    {                 
        //no post processing
      
       
    }
}