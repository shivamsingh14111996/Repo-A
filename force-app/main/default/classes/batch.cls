/* **********************************
Created By: Yogendra Rathi
Date: 15/06/2019
Modified BY:
Purpose: Creating all attachments and Files list for all 7 objects if retain flag is checked. and send data to batch class
Class Name: sharePointAttachments
Test Class: sendfilehelperTest
********************************* */

public class sharePointAttachments{
    string query;  
    List<Attachment> allattachments = new List<Attachment>(); 
    set<id> allRecsid = new set<id>();
    List<sobject> allrec = new List<sobject>();    
    set<id> documentid = new set<id>();
    List<ContentDocumentLink> cdl = new List<ContentDocumentLink>();
    List<ContentVersion> cv = new List<ContentVersion>();
    Map<id,ContentDocumentLink> cdlMap = new Map<id,ContentDocumentLink>();    
    Map<id,Account> accMap = new Map<id,Account>();
    Map<id,Contact> conMap = new Map<id,Contact>();
    Map<id,Case> casMap = new Map<id,case>();
    Map<id,Campaign> camMap = new Map<id,Campaign>();
    Map<id,Business_Plan__c> bplMap = new Map<id,Business_Plan__c>();
    Map<id,Water_Sample__c> wsMap = new Map<id,Water_Sample__c>();
    Map<id,Inspections__c> insMap = new Map<id,Inspections__c>();    
    Integer qLimit =  5; 
    Integer maxfileSize = limits.getLimitHeapSize()*2;
    List<wrapperCls> wpra = new List<wrapperCls>();

    public List<wrapperCls> getAttachments(){     
    
           system.debug('head size in class'+ maxfileSize);
            if(!Test.isRunningTest()) {
                qLimit =integer.valueof(SharePoint_Credentials__c.getValues('QueryLimit').Credentials__c);           
            }
            
            List<case> cas = [select id,account.name,Contact.name,(select id from attachments where BodyLength <= :maxfileSize), (select id FROM ContentDocumentLinks) from case where Retain__c = true and (Business_Plan__r.Active__c = true or Business_Plan__c=null) limit :qLimit];
            for(case ca:cas){
                if(ca.attachments.size() > 0 || ca.ContentDocumentLinks.size() > 0){
                    allRecsid.add(ca.id);
                    casMap.put(ca.id,ca);
                } else {
                    ca.Retain__c = false;
                }
            }  
            List<Account> acc = [select id, name,(select id from attachments where BodyLength <= :maxfileSize) , (select id FROM ContentDocumentLinks) from Account where Retain__c = true and (Related_Active_Account__r.Active__c= true or  Related_Active_Account__c=null) limit :qLimit];
            for(Account aa:acc){
                if(aa.attachments.size() > 0 || aa.ContentDocumentLinks.size() > 0){
                allRecsid.add(aa.id);
                accMap.put(aa.id,aa);
                } else {
                aa.Retain__c = false;
                }
            } 
            List<Contact> con = [select id,account.name,name,(select id from attachments where BodyLength <= :maxfileSize) , (select id FROM ContentDocumentLinks) from Contact where Retain__c = true limit :qLimit];
            for(Contact co:con){
            if(co.attachments.size() > 0 || co.ContentDocumentLinks.size() > 0){
                allRecsid.add(co.id);
                conMap.put(co.id,co);
                } else {
                co.Retain__c = false;
                }
            } 
            List<Campaign> cam = [select id,Campaign_Sponsor__r.name,(select id from attachments where BodyLength <= :maxfileSize) , (select id FROM ContentDocumentLinks) from Campaign where Retain__c = true limit :qLimit];
            for(Campaign ca:cam){
            if(ca.attachments.size() > 0 || ca.ContentDocumentLinks.size() > 0){
                allRecsid.add(ca.id);
                camMap.put(ca.id,ca);
                } else {
                ca.Retain__c = false;
                }
            }
            List<Business_Plan__c> bplan = [select id,Account_Name__r.name,(select id from attachments where BodyLength <= :maxfileSize) , (select id FROM ContentDocumentLinks) from Business_Plan__c where Retain__c = true limit :qLimit];
            for(Business_Plan__c bp:bplan){
            if(bp.attachments.size() > 0 || bp.ContentDocumentLinks.size() > 0){
                allRecsid.add(bp.id);
                bplMap.put(bp.id,bp);
                } else {
                bp.Retain__c = false;
                }
            }
            List<Water_Sample__c> wsml = [select id,Water_Source__r.Account__r.name,(select id from attachments where BodyLength <= :maxfileSize) , (select id FROM ContentDocumentLinks) from Water_Sample__c where Retain__c = true limit :qLimit];
            for(Water_Sample__c ws:wsml){
            if(ws.attachments.size() > 0 || ws.ContentDocumentLinks.size() > 0){
                allRecsid.add(ws.id);
                wsMap.put(ws.id,ws);
                } else {
                ws.Retain__c = false;
                }
            }
            List<Inspections__c> ins = [select id,Account__r.name,(select id from attachments where BodyLength <= :maxfileSize) , (select id FROM ContentDocumentLinks) from Inspections__c where Retain__c = true limit :qLimit];
            for(Inspections__c is:ins){
            if(is.attachments.size() > 0 || is.ContentDocumentLinks.size() > 0){
                allRecsid.add(is.id);
                insMap.put(is.id,is);
                } else {
                is.Retain__c = false;
                }
            }
        
        
            // Code to get all attached Files
          if(allRecsid != null && !allRecsid.isEmpty()){
          
          system.debug('allRecsid' + allRecsid);
          for(ContentDocumentLink incdl: [SELECT ContentDocumentId,LinkedEntityId,LinkedEntity.Type,LinkedEntity.name,LinkedEntity.recordtype.name FROM ContentDocumentLink where LinkedEntityId in :allRecsid]){
              documentid.add(incdl.ContentDocumentId);
              cdlMap.put(incdl.ContentDocumentId,incdl); 
              system.debug('1-Files are coming'+ incdl.ContentDocumentId +'<br>');                   
          } 
          
         
          for(ContentVersion incv: [SELECT ContentSize, createddate, FileExtension,Title, id, ContentDocumentid,VersionData FROM ContentVersion  where ContentDocumentId in :documentid and (ContentSize > 0 and ContentSize <= :maxfileSize)]) {
                system.debug('get heap'+limits.getHeapSize() +'maxfileSize '+maxfileSize);
               //if(limits.getHeapSize() < maxfileSize )
               {
                   system.debug('Files are coming'+ incv.id +'<br>');
                   string chkbody = EncodingUtil.base64Encode(incv.VersionData);
                   String fname = incv.Title +'.' + incv.FileExtension ;
                   Id entyid =cdlMap.get(incv.ContentDocumentid).LinkedEntityId;
                   String entyType = cdlMap.get(incv.ContentDocumentid).LinkedEntity.Type;
                   String caccName = getaccountname(entyid,entyType);           
                   String conName = getcontactname(entyid,entyType);           
                   if(chkbody!=''){
                   system.debug('Files are coming'+ incv.id +'<br>');
                     wpra.add(new wrapperCls(incv.id,filename(fname),entyid,'files',entyType,incv.VersionData,caccName,conName,cdlMap.get(incv.ContentDocumentid).LinkedEntity.recordtype.name,cdlMap.get(incv.ContentDocumentid).LinkedEntity.name,incv.createddate));
                   }
                  } 
              
          }
            
            // End code to all Attached files
           system.debug('File*******'+wpra.size());
            for(Attachment allAtt : [SELECT createddate, Parent.Type, Body,BodyLength,ContentType,Name,ParentId,Parent.recordtype.name,parent.name FROM Attachment where ParentId in :allRecsid and BodyLength <= :maxfileSize]){
                
               //if(limits.getHeapSize() < maxfileSize ) 
               {
                    String caccName2 = getaccountname(allAtt.ParentId,allAtt.Parent.Type);           
                    String conName2 = getcontactname(allAtt.ParentId,allAtt.Parent.Type);
                    system.debug('Attachments are coming'+ allAtt.id +'<br>');
                    wpra.add(new wrapperCls(allAtt.id,filename(allAtt.name),allAtt.Parentid,'Attachments',allAtt.Parent.Type,allAtt.Body,caccName2,conName2,allAtt.Parent.recordtype.name,allAtt.Parent.name,allAtt.createddate));
               }
            }
            
            system.debug('*******'+wpra.size());
            
            // Update objects if no attachments and files found
                update cas;
                update acc;
                update con;
                update cam;
                update bplan;
                update wsml;
                update ins;
                   
            if(wpra != null && !wpra.isEmpty()) {
                system.debug(': Heap size is ' + limits.getHeapSize() + ' enforced is ' + limits.getLimitHeapSize());
                return wpra;
            } 
             
            
           } 
           return wpra;
     }   
    
    
    // Method to get record name
    string getaccountname(id id,String entyType){
        String acconame='';
         if(entyType=='Account'){
            return accMap.get(id).name;
        }
        else if(entyType=='Water_Sample__c'){
            return wsMap.get(id).Water_Source__r.Account__r.name;
        }
        else if(entyType=='Contact'){
            return conMap.get(id).account.name;
        }
        else if(entyType=='Case'){
            system.debug('Came Here');
            return casMap.get(id).account.name;
        }
        else if(entyType=='Campaign'){
            return camMap.get(id).Campaign_Sponsor__r.name;
        } else if(entyType=='Business_Plan__c'){
            return bplMap.get(id).Account_Name__r.name;
        }
         else if(entyType=='Inspections__c'){
            return insMap.get(id).Account__r.name;
        } else{
            return 'Not Found';
        }
        //return acconame;
    }
    
    // method to get case contact name
    string getcontactname(id id,String entyType){
        String conname='';
        if(entyType=='Case'){
            return casMap.get(id).Contact.name;
        } 
         
        return conname;
    }
    
    // method to remove special char
    string filename(String fname){
        fname = fname.replace('#','-');
        fname = fname.replace('%','-');
        fname = fname.replace('*','-');
        fname = fname.replace(':','-');
        fname = fname.replace('<','-');
        fname = fname.replace('>','-');
        fname = fname.replace('?','-');
        fname = fname.replace('/','-');
        fname = fname.replace('\'','-');
        return fname;
    }

}