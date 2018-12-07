({
    doInit : function(component, event, helper) {
        var attachmentName = component.get("v.attachmentName");
        if(attachmentName!=null && attachmentName!='undefiend' && attachmentName!=undefined && attachmentName.length>0){
           attachmentName = attachmentName.toLowerCase();
            if((attachmentName.includes('.bmp') || attachmentName.includes('.dib')|| attachmentName.includes('.jpg')|| attachmentName.includes('.jpeg')|| attachmentName.includes('.jpe')|| attachmentName.includes('.jiff')|| attachmentName.includes('.gif')|| attachmentName.includes('.tif')|| attachmentName.includes('.tiff')|| attachmentName.includes('.png'))){
                component.set("v.isIMage", "true");
            }
    }
}
 })