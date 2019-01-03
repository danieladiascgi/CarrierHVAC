({
    afterRender : function(component, helper) {
        var acctlistInput=document.getElementById("select-02");
        acctlistInput.setAttribute("list", "DealerNameList");
        
        
        return this.superAfterRender();
    }
    
})