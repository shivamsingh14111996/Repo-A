/* 
***** Class for the SiteRegisterComponent ***
***** Description : This class is used to insert the Portal User *****
*/
public without sharing class siteOLD {
    /* This method is used to insert the user for Community Portal and if username alread exists it will give an error message */
    @AuraEnabled
    public static String createUserInCommunity(String createUserJson) {
        try {
            if(String.isNotBlank(createUserJson)) {
                AddUserParams params = (AddUserParams) JSON.deserialize(createUserJson, AddUserParams.class);
                SignUpMessage__c adv = SignUpMessage__c.getOrgDefaults();
                if(String.isNotBlank(params.FirstName) && String.isNotBlank(params.LastName)) {
                    
                    Boolean ein = adv.EIN__c;
                    Boolean organizationLegalName = adv.Organization_Legal_Name__c ;
                    Boolean einFormat = adv.EIN_Formatting__c;
                    System.debug(organizationLegalName);
                    System.debug(ein);
                    User createUser = new User();
                    if(ein == true) {
                        //System.debug('1');
                        if(organizationLegalName == true) {
                            if(String.isNotBlank(params.organizationLegalName)) {
                                createUser.FirstName = params.FirstName;
                                createUser.LastName = params.lastName;
                                createUser.CommunityNickname = string.valueOf(math.random()).substring(0,6);
                                createUser.Email = params.Email;
                                createUser.Organization_Legal_Name__c = params.organizationLegalName;
                                createUser.Username = params.Email;
                            }
                            else {
                                String messageForOrganizationLegalName = String.valueOf(adv.Required_Organization_Legal_Name__c);
                                return messageForOrganizationLegalName;
                            }
                        }
                        else {
                            createUser.FirstName = params.FirstName;
                            createUser.LastName = params.lastName;
                            createUser.CommunityNickname = string.valueOf(math.random()).substring(0,6);
                            createUser.Email = params.Email;
                            //createUser.Organization_Legal_Name__c = params.organizationLegalName;
                            createUser.Username = params.Email;
                            
                        }
                        if(String.isNotBlank(params.ein)) {
                            if(einFormat == true) {
                                
                                String formatPat = '##-#######';
                                String str = params.ein;
                                 // String pattern = str.format('yyyy-MM-dd');
                                //String pattern = str.left(2) +  '- ' +str.substring(2,str.length()-1);
                                //String pattern = str.substring(0,1) + '-' + str.substring(2,8);
                                //System.debug(pattern);
                                //String output = str +'-' + str.format();
                                //String subsring = '####';
                                Pattern p = Pattern.compile('(\\d)(\\d)-(\\d+)');
                                //Boolean isMatched = Pattern.matcher(p,params.ein);
                                Matcher pm = p.matcher(params.ein);
                                System.debug(pm);
                                if(pm.matches() == true) {
                               // if(String.isNotBlank(pattern)) {
                               System.debug(params.ein);
                                    createUser.EIN__c= params.ein; 
                                }
                                else {
                                    String einFormatMessage = String.valueOf(adv.EIN_Format_Error_Message__c);
                                    return einFormatMessage; 
                                }
                            }
                            //System.debug('5');
                            else {
                                createUser.EIN__c= params.ein;
                            }
                        }
                        else {
                            String messageForEIN = String.valueOf(adv.Required_EIN__c);
                            return messageForEIN;
                            
                        }
                        
                        
                        
                        
                        
                    }
                    else {
                        if(organizationLegalName == true) {
                            if(String.isNotBlank(params.organizationLegalName)) {
                                createUser.FirstName = params.FirstName;
                                createUser.LastName = params.lastName;
                                createUser.CommunityNickname = string.valueOf(math.random()).substring(0,6);
                                createUser.Email = params.Email;
                                createUser.Organization_Legal_Name__c = params.organizationLegalName;
                                createUser.Username = params.Email;
                            }
                            else {
                                return 'Please Enter Organization Legal Name';
                            }
                        }
                        else {
                            createUser.FirstName = params.FirstName;
                            createUser.LastName = params.lastName;
                            createUser.CommunityNickname = string.valueOf(math.random()).substring(0,6);
                            createUser.Email = params.Email;
                            //createUser.Organization_Legal_Name__c = params.organizationLegalName;
                            createUser.Username = params.Email;
                            
                        }
                        
                        
                    }
                    
                    
                    
                    System.debug(createUser);
                    
                    List<User> userList = new List<User>();
                    userList = [
                        Select Id,Username
                        from User 
                        where Username =: createUser.Username 
                        // WHERE FirstName =: createUser.FirstName AND LastName =: createUser.LastName 
                    ];
                    System.debug(userList);
                    //SignUpMessage__c adv = SignUpMessage__c.getOrgDefaults();
                    if(userList.size() > 0) {
                        
                        System.debug('userList'+userList[0]);
                        String message = String.valueOf(adv.Custom_Messge__c);
                        return message;
                        //return 'This email address is already in use. Reset your password.';
                    }
                    else {
                        String userId='';
                        
                        String accountId = String.valueOf(adv.AccountId__c);
                        
                        userId = Site.createExternalUser(createUser,accountId);
                        //SiteRegisterPage_Ctrl.redirectToLogin();
                        return 'User Created';
                        
                    }
                    
                }
                
            }
        }
        // }
        catch(Exception e) {
            System.debug(e.getLineNumber());
        }
        return null;
        
        
        
    }
    public class AddUserParams {
        @AuraEnabled
        public String firstName {get;set;}
        @AuraEnabled
        public String lastName {get;set;}
        @AuraEnabled
        public String email {get;set;}
        @AuraEnabled
        public String organizationLegalName {get;set;}
        @AuraEnabled
        public String ein {get;set;}
        
    }
    
    
    
}