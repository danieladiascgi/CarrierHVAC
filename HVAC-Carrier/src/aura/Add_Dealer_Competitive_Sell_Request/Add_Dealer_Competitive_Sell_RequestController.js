({
    init: function(cmp, event,helper){
        var action = cmp.get("c.getBrand");
        action.setCallback(this , function(a){
            var returnValue = a.getReturnValue();
            cmp.set("v.modelList",returnValue);
        });
        $A.enqueueAction(action); 
    },
    add : function(cmp,event,helper) {
        cmp.set("v.canRender","true");
        var list = cmp.get("v.TempList");
        list.push(cmp.get("v.TempList").length);
        cmp.set("v.TempList", list);
        var listas = cmp.get("v.modelList");
        var defaultModel = listas[0];
        var index = cmp.get("v.TempList").length - 1;
        var modelList = cmp.get("v.modelListSelected");
        modelList[index] = index+';'+defaultModel;   
        
    }, 
    RemoveBrand : function(cmp, event){ 
        
        var selectedList = cmp.get("v.TempList");
        var index = event.getSource().get("v.name");
        selectedList.splice(index,1);
        cmp.set("v.TempList",selectedList);
        
        var list = cmp.get("v.modelListSelected");
        list.splice(index,1);
        for(var i = index; i<list.length;i++){
            var id = list[i].split(';')[1];
            var currentvalue =  list[i].split(';')[0];
            var newvalue = currentvalue-1;
            var model = newvalue+';'+id;
            list[i] = model;
        }     
    },
    redesignThis : function(cmp,event, helper){	
        helper.sObjectCollection(cmp,event);  
    },
    onSingleSelectChange: function(cmp, event,helper){
        helper.onSingleSelectChange(cmp,event);
        helper.sObjectCollection(cmp,event);
    },   
    
    onRender : function(component,event,helper){
        var size=component.get("v.TempList").length;
        size--;
        if(component.get("v.canRender")){
            var acctlistInput=document.getElementById(size+"acctlistInput");
            acctlistInput.setAttribute("list", "acctlist");
        } 
    }
})