({
    init: function(cmp, evt,hlpr){
        var action = cmp.get("c.getBrand");
        action.setCallback(this , function(a){
            var returnValue = a.getReturnValue();
            cmp.set("v.modelList",returnValue);
            console.log(cmp.get("v.modelList"));
        });
        $A.enqueueAction(action); 
    },
    add : function(component, event, helper) {
        var list = component.get("v.ListCenas");
        list.push(component.get("v.ListCenas").length);
        component.set("v.ListCenas", list);
    }, 
    RemoveBrand : function(cmp, event){ 
        
        var selectedList = cmp.get("v.ListCenas");
        var index = event.getSource().get("v.name");
        selectedList.splice(index,1);
        cmp.set("v.ListCenas",selectedList);
        
        var list = cmp.get("v.modelListSelected");
        list.splice(index,1);
        
        
        
        
    },
    redesignThis : function(cmp,evt, hlpr){	
        
        /*var list = cmp.get("v.modelListSelected");
        
        var name = evt.getSource().getLocalId();
        cmp.set("v.modelListSelected",list);
        
        list.push(x);*/
        
        hlpr.sObjectCollection(cmp,evt);
        
        
    },
    
    onSingleSelectChange: function(cmp,event) {
        var index = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        var unique_id=index+';'+value;
        var list = cmp.get("v.modelListSelected");
        
        var exists = false;
        var i;
        for(i=0;i<list.length;i++){
            if(list[i].split(';')[0]=index){
                list[index] = unique_id;
                exists=true;
                break;
            }
        }
        if(exists!=true){
            list.push(unique_id);
        }
        
        list.sort();
        cmp.set("v.modelListSelected",list);
    },
    
    
    
    
    
    
})