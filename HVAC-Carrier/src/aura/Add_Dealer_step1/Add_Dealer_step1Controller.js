({
    init :function(cmp, event, helper){
        //receives from apex the related accounts of the user logged in
        var action = cmp.get("c.GetUserAccounts");
        action.setCallback(this, function(response) {
            var t=response.getReturnValue()[0].Account.Id;
            cmp.set("v.distributorId",t);
            cmp.set("v.AccountNameList",response.getReturnValue());
            
            var action = cmp.get("c.GetDealerName");
            action.setParams({"account_id" : String(t)});
            action.setCallback(this, function(response){
                cmp.set("v.DealerNameList",response.getReturnValue());
                cmp.set("v.dealerNumber",response.getReturnValue()[0].CIN__c );
                cmp.set("v.dealerName",response.getReturnValue()[0].CCC_Dealer__r.Name);
            });
            $A.enqueueAction(action);
        });
        $A.enqueueAction(action);
    }
    
    ,
    
    StoreValue : function(cmp, event){
        //saves the values to so the flow receives it
        var value = document.getElementById("select-01");
        var t=value.options[value.selectedIndex].value;
        cmp.set("v.distributorId",t);
        var action = cmp.get("c.GetDealerName");
        action.setParams({"account_id" : String(t)});
        action.setCallback(this, function(response){
            try{  
                
                if(!$A.util.isEmpty(response.getReturnValue())){
                    cmp.set("v.DealerNameList",response.getReturnValue());
                    cmp.set("v.dealerNumber",response.getReturnValue()[0].CIN__c );
                	cmp.set("v.dealerName",response.getReturnValue()[0].CCC_Dealer__r.Name);
                }else{
                    cmp.set("v.DealerNameList", "");
                    cmp.set("v.dealerNumber","" );
                	cmp.set("v.dealerName","");
                }
                
            }
            catch(err){} 
        });
        $A.enqueueAction(action);
        
        
    },
    
    DealerNumber : function(cmp, event){
        var name=document.getElementById("select-02").value;
        var size = cmp.get("v.DealerNameList").length;
        
        for(var i=0;i<size;i++){
            
            if(cmp.get("v.DealerNameList")[i].CCC_Dealer__r.Name==name){
                
                cmp.set("v.dealerNumber",cmp.get("v.DealerNameList")[i].CIN__c); 
                
            }
        }
    }
    
    
    
    
    
    
    
})