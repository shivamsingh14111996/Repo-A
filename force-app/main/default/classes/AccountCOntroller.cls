public class AccountCOntroller {

        @AuraEnabled(cacheable=true)
        public static List<Account> getAccountList() {
            return [SELECT Id, Name, Type, Rating, Phone, Website, AnnualRevenue FROM Account where id ='0012x00000VHfhAAAT'];
        }

        @AuraEnabled
        public static void deleteAccount() {
            Account[] doomedAccts = [select Name from Account where id ='0012x00000VHfhAAAT'];
            delete doomedAccts;
        }

}