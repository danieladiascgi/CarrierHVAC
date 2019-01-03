public  class ImageViewerController{
    
    public String id{get;set;}
    
    public List<Attachment> attachments{get;set;}
    private final case cs;
    public List<AttachmentWrapper> wrpLst{get; set;}  
    
    public  ImageViewerController(ApexPages.StandardController stdController)   
    {  
        //id= System.currentPagereference().getParameters().get('id');    
        
        this.cs = (Case)stdController.getRecord();
        attachments=new list<attachment>(); 
        wrpLst = new List<AttachmentWrapper>();
        attachments=[select Id, Name, Description, BodyLength from Attachment where parentId=:cs.Id]; 
        
        if(attachments!=null && attachments.size()>0){
            for(Attachment eachAttachment : attachments){
                AttachmentWrapper wrp = new AttachmentWrapper(eachAttachment);
                if(true){
                    if(eachAttachment.Name.endsWith('.bmp') || eachAttachment.Name.endsWith('.dib')|| eachAttachment.Name.endsWith('.jpg')|| eachAttachment.Name.endsWith('.jpeg')|| eachAttachment.Name.endsWith('.jpe')|| eachAttachment.Name.endsWith('.jiff')|| eachAttachment.Name.endsWith('.gif')|| eachAttachment.Name.endsWith('.tif')|| eachAttachment.Name.endsWith('.tiff')|| eachAttachment.Name.endsWith('.png')){
                        wrp.isViewable = true;
                        wrpLst.add(wrp);
                    }
                }
                
            }
        }
        
    }
    
    public class AttachmentWrapper{
        public Boolean isChecked{get; set;}
        public Boolean isViewable{get; set;}
        public Attachment attach{get; set;}
        public AttachmentWrapper(Attachment attach){
            this.attach = attach;
        }
    }
}