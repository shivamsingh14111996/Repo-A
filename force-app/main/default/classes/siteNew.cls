/**
* An apex class that creates a portal user
*/
public without sharing class SiteNew {
    /*
    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.      
    private static Id PORTAL_ACCOUNT_ID =  '0018C000007sBnW';   //0014W00001igmZrQAI';     //'001x000xxx35tPN';
    
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    @AuraEnabled
    public static String registerUser(
        String email,
        //String username,
        //String communityNickname,
        String firstName,
        String lastName,
        String password,
        String confirmPassword
    ) {
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword(password, confirmPassword)) {
            throw new AuraHandledException(Label.site.passwords_dont_match);
        }    
        
      /*  //cretae contact 
        Contact contact1 = new Contact(
            FirstName = firstName,
            Lastname = LastName,
            AccountId = PORTAL_ACCOUNT_ID,
            Email = email
        );
        Database.insert(contact1);
        
        //create portal user 
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
        User user1 = new User(
            Username = email,
            ContactId = contact1.Id,
            ProfileId = PORTAL_ACCOUNT_ID,
            Email = email,
            LastName = LastName,
            CommunityNickname = FirstName
        );
        Database.insert(user1); 
        
        
        
        
        User u = new User();
        u.Username = email;
        // System.debug('firstName is '+ FirstName );
        u.FirstName = FirstName;
        u.ContactId ='0038C000004bXyH';
        u.LastName = LastName;
        u.Email = email;
        u.CommunityNickname = FirstName;
        
        String accountId = PORTAL_ACCOUNT_ID;
        
        // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        //System.assert(false, )
        String userId = Site.createPortalUser(u, PORTAL_ACCOUNT_ID, password, true);
        System.assert(false,'userId'+userId );
        //String userId = Site.createExternalUser(user1,PORTAL_ACCOUNT_ID,password,true);
        System.assert(false, 'userId '+ userId);
        if (userId != null) {
            if (password != null && password.length() > 1) {
                return Site.login(email, password, null).getUrl();
            }
            else {
                PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page.getUrl();
            }
        }
        
        return null;
    }*/
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
        //
       
     @AuraEnabled
	public static string CreateSiteUser(String email,
        //String username,
        //String communityNickname,
        String firstName,
        String lastName,
        String password,
        String confirmPassword)
    {
        User portalAccountOwner1 = [select id , name from User where UserRole.name='Community Admin' limit 1];
        //Create portal account owner
          /*  UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
                     UserRoleId = portalRole.Id,
                     ProfileId = profile1.Id,
                     Username = 'dotnetcodex@gmail.com' + System.now().millisecond() ,
                     Alias = 'sfdc',
                     Email='dotnetcodex@gmail.com',
                     EmailEncodingKey='UTF-8',
                     Firstname='Dhanik',
                     Lastname='Sahni',
                     LanguageLocaleKey='en_US',
                     LocaleSidKey='en_US',
                     TimeZoneSidKey='America/Chicago'
            );
            Database.insert(portalAccountOwner1);*/

             Account act = new Account(
                     Name = firstName+lastName,
                     //LastName ='Sahni',
                     Owner = portalAccountOwner1
            );
        
            Database.insert(act);
            myFutureMethod(email,firstName,lastName,password,confirmPassword,act.Id);
        	PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page.getUrl();
            
       
    }
        @future
    public static void myFutureMethod(String email,
        //String username,
        //String communityNickname,
        String firstName,
        String lastName,
        String password,
        String confirmPassword, Id actId)
    {   
        Profile p=[Select Id from Profile where Name='Standard User' LIMIT 1];
        	User u = New User(
                
                FirstName = firstName,
                LastName = lastName,
                Alias = 'test',
                email = email,
                CommunityNickName = string.valueOf(math.random()).substring(0,6),
                ProfileID = p.id,
                TimeZoneSidKey = 'America/New_York', 
                LocaleSidKey = 'en_US', 
                EmailEncodingKey = 'UTF-8', 
                LanguageLocaleKey = 'en_US'
            );
        u.UserName = u.Alias+email;
        	//string userId='';
       		try {
            	string userId = Site.createExternalUser(u, actId, null);
               	System.Debug(userId);
            } catch(Site.ExternalUserCreateException ex) {
                System.debug('exception***'+ ex.getDisplayMessages());
               	Messaging.SingleEmailMessage emailmsg = new Messaging.SingleEmailMessage();
        		string[] to = new string[] {'pierre@sputnikmoment.com'};
 				emailmsg.setToAddresses(to);
               	emailmsg.setSubject('Test Mail');
                List<String> sList = (List<String>)ex.getDisplayMessages();
                String msgBody = string.join(sList,',');
        		emailmsg.setHtmlBody(msgBody);
      			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailmsg });
            }
    }

        
}