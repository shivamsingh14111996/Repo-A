public class AccountContoller {
    
    @AuraEnabled
    //public static void sendEmail(List<String> toAddress, String subject, String body,List<String> emailDetails ) {   
    public static void sendEmail(String emailDetailStr ) {   
        EmailWrapper emailDetails = (EmailWrapper) JSON.deserialize(emailDetailStr, EmailWrapper.class);

        Messaging.reserveSingleEmailCapacity(2);
        try{
        
            ContentVersion cversion = [SELECT title, PathOnClient, FileType, versiondata FROM contentversion WHERE ContentDocumentId = :emailDetails.documentId ];

            blob WOCFbody = cversion.versiondata;
            Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
            efa1.setFileName(emailDetails.fileName);
            efa1.setBody(WOCFbody);

            messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
            mail.setToAddresses(emailDetails.toAddress);
            mail.setReplyTo('no-reply@xooa.com');
            String Name = UserInfo.getName();
            mail.setSenderDisplayName(Name);
            mail.setSubject(emailDetails.subject);
            mail.setHtmlBody(emailDetails.body);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{efa1});
            Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
        }
        catch (exception e){
            throw new AuraHandledException(e.getMessage());
            //return null;
        }
    }

    Class EmailWrapper {
        public List<String> toAddress;
        public List<String> ccAddress;
        public String subject;
        public String body;
        public Id documentId;
        public String fileName;
    }


    @AuraEnabled(cacheable=true)
    public static List<Account>  getAccounts(){
        try {
          return  [SELECT Name from Account Limit 10];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}