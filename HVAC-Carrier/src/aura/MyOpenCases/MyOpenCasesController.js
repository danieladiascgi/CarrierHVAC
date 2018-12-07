({
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
    
    doInit : function(component,event,helper){
        //call apex class method
        
        
        var action = component.get('c.getOpenCases');
        action.setParams({"EmailAddress":component.get("v.email")});
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in lstOpp attribute on component.
                //component.set('v.lstCases', response.getReturnValue());
                component.set('v.lstCasesWrapper',response.getReturnValue());
                
                // when response successfully return from server then apply jQuery dataTable after 500 milisecond
               setTimeout(function(){                    
                    $('#tableId').DataTable();                                                            
                    // add lightning class to search filter field with some bottom margin..  
                    $('div.dataTables_filter input').addClass('slds-input');
                    $('div.dataTables_filter input').css("marginBottom", "10px");
                }, 700); 
               
            }
        });
        $A.enqueueAction(action); 
    },
    
    sortCaseNumber: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.     
       component.set("v.selectedTabsoft", 'caseNumber');
       // call the helper function with pass sortField Name   
       helper.sortHelper(component, event, 'CaseNumber');
    },
    
    sortDate: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.     
       component.set("v.selectedTabsoft", 'createdDate');
       // call the helper function with pass sortField Name   
       helper.sortHelper(component, event, 'CreatedDate');
    },
    
    redirectToCaseDetail: function(component, event, helper){
       // alert('clickedCaseRecId '+event.currentTarget.id);          
        //var clickedCaseRecId = event.getSource().get("v.title");
        var clickedCaseRecId = event.currentTarget.id;
        component.set("v.clickedCaseRecId",clickedCaseRecId);
        var event = $A.get( 'e.c:NavigateToCaseDetail' );
        event.setParams({ "view": "This is Testing"}).fire();       
    },
    
    NavigateToCaseDetail : function(component,event,helper) {
       // alert('Navigate to SAP');
        
        $('#tableId_wrapper').hide();
        $('#closedCasesTableId_wrapper').hide();
        $('#openExpeditesTableId_wrapper').hide();
        var headerToHide = component.find("tabSet");
        $A.util.addClass(headerToHide, 'toggle');

        var selCaseRec = component.get("v.clickedCaseRecId");
        var destination = "c:CaseDetailCustom";
        //alert(this.type);
      //  alert(selCaseRec);
        $A.createComponent(destination, {"clickedCaseRecId":selCaseRec}, 
                           function(newCmp) {
                               var content = component.find("content");
                              // alert('#content:'+content);               
                               content.set("v.body", newCmp);
                               
                           });
    },
    handleOpenCases : function(component,event,helper) {
       // alert('Clicked on Open Cases');
       var action = component.get('c.getOpenCases');
        action.setParams({"EmailAddress":component.get("v.email")});
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in lstOpp attribute on component.
                //component.set('v.lstCases', response.getReturnValue());
                component.set('v.lstCasesWrapper',response.getReturnValue());
                
                // when response successfully return from server then apply jQuery dataTable after 500 milisecond
                setTimeout(function(){ 
                    if( $.fn.DataTable.isDataTable( '#closedCasesTableId' )){
                        $('#closedCasesTableId').DataTable().destroy();  
                    }
                    if( $.fn.DataTable.isDataTable( '#openExpeditesTableId' )){
                        $('#openExpeditesTableId').DataTable().destroy();  
                    }
                    $('#tableId').show();
                    $('#tableId').DataTable();                       
                    $('div.dataTables_filter input').addClass('slds-input');
                    $('div.dataTables_filter input').css("marginBottom", "10px");                    
                    $('#closedCasesTableId').hide();
                    $('#openExpeditesTableId').hide();
                    $('#tableId').show();
                    $('#tableId').DataTable();
                    
                     
                }, 500);     
            }
        });
        $A.enqueueAction(action); 
        
    },
    handleClosedCases : function(component,event,helper) {
        //alert('Clicked on Closed Cases');
        var action = component.get('c.getClosedCases');
        action.setParams({"EmailAddress":component.get("v.email")});
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in lstOpp attribute on component.
                //component.set('v.lstClosedCases', response.getReturnValue());
                component.set('v.lstClosedCasesWrapper', response.getReturnValue());
                
                // when response successfully return from server then apply jQuery dataTable after 500 milisecond
                setTimeout(function(){ 
                    if( $.fn.DataTable.isDataTable( '#tableId' )  ){
                        $('#tableId').DataTable().destroy();
                    }
                    if( $.fn.DataTable.isDataTable( '#openExpeditesTableId' )  ){
                        $('#openExpeditesTableId').DataTable().destroy();
                    }
                    
                     $('#closedCasesTableId').show();
                    $('#closedCasesTableId').DataTable();
                    $('div.dataTables_filter input').addClass('slds-input');
                    $('div.dataTables_filter input').css("marginBottom", "10px");
                    $('#tableId').hide();
                    $('#openExpeditesTableId').hide();
                    $('#closedCasesTableId').show();
                }, 500);       
            }
        });
        $A.enqueueAction(action); 
    },
    NavigateToChat : function(component, event, helper) {
        //alert('#url:');
        var caseNum = '';
        var purpose = '';
        var subPurpose = '';
        var nameVal = event.getSource().get("v.name");
        var buttonId = component.get("v.OnlineButton");
        if(nameVal.indexOf(';')!=-1){
            var nameArr = nameVal.split(';');
            caseNum = nameArr[0];
            purpose = nameArr[1];
            subPurpose = nameArr[2];
            
        }
        
        var urlVal = 'https://utc-ccs-customersgateway.secure.force.com/LiveChatButton?value='+sessionStorage.getItem('payload')+'&CaseNumber='+caseNum+'&purpose='+purpose+'&subPurpose='+subPurpose+'&buttonId='+buttonId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlVal 
        });
        urlEvent.fire();
    },
   
    tabSelected: function(component,event,helper) {
        alert(component.get("v.selTabId"));
    },
    handleOpenExpedites : function(component,event,helper) {
       // alert('Clicked on Open Cases');
       var action = component.get('c.getOpenExpedites');
        action.setParams({"EmailAddress":component.get("v.email")});
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in lstOpp attribute on component.
                //component.set('v.lstCases', response.getReturnValue());
                component.set('v.lstExpeditesWrapper',response.getReturnValue());
                
                // when response successfully return from server then apply jQuery dataTable after 500 milisecond
                setTimeout(function(){ 
                    if( $.fn.DataTable.isDataTable( '#tableId' )){
                        $('#tableId').DataTable().destroy();  
                    }
                    if( $.fn.DataTable.isDataTable( '#closedCasesTableId' )){
                        $('#closedCasesTableId').DataTable().destroy();  
                    }
                    
                    $('#openExpeditesTableId').show();
                    $('#openExpeditesTableId').DataTable();                       
                    $('div.dataTables_filter input').addClass('slds-input');
                    $('div.dataTables_filter input').css("marginBottom", "10px");
                    $('#openExpeditesTableId').show();
                    $('#tableId').hide();
                    $('#closedCasesTableId').hide();
                     
                }, 500);     
            }
        });
        $A.enqueueAction(action); 
        
    }

})