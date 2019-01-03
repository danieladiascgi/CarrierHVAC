public class ExistingAttachmentsViewerController{
    
    public String id{get;set;}
    
    public List<Attachment> attachments{get;set;}
    //public List<Attachment> files{get;set;}
    //private string file{get;set;}
    private final case cs;
    public List<AttachmentWrapper> wrpLst{get; set;}  
    
    public ExistingAttachmentsViewerController(ApexPages.StandardController stdController)   
    {  
        id= System.currentPagereference().getParameters().get('id');    
        
        this.cs = (Case)stdController.getRecord();
        attachments=new list<attachment>(); 
        //files=new list<attachment>();
        wrpLst = new List<AttachmentWrapper>();
        
        
        //files=[select Id, Name, Description from Attachment where parentId=:id AND (name LIKE '%.txt')];
        attachments=[select Id, Name, Description, BodyLength from Attachment where parentId=:cs.id]; 
        
        if(attachments!=null && attachments.size()>0){
            for(Attachment eachAttachment : attachments){
                AttachmentWrapper wrp = new AttachmentWrapper(eachAttachment);
                if(eachAttachment.Name.endsWith('.bmp') || eachAttachment.Name.endsWith('.dib')|| eachAttachment.Name.endsWith('.jpg')|| eachAttachment.Name.endsWith('.jpeg')|| eachAttachment.Name.endsWith('.jpe')|| eachAttachment.Name.endsWith('.jiff')|| eachAttachment.Name.endsWith('.gif')|| eachAttachment.Name.endsWith('.tif')|| eachAttachment.Name.endsWith('.tiff')|| eachAttachment.Name.endsWith('.png')){
                    if(eachAttachment.BodyLength>=10000){
                        wrp.isViewable = true;
                        
                    }    
                }else{
                    wrpLst.add(wrp);
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