@isTest
public with sharing class OpportunityTriggerHandlerTest {
    
    @TestSetup
    static void insertTestData(){

        // Insert parent Accounts
        List<Account> newAccounts = new List<Account>();
        
        Account a1 = new Account(Name = 'TestAccount1');
        Account a2 = new Account(Name = 'TestAccount2');
        newAccounts.add(a1);
        newAccounts.add(a2);
        Database.insert(newAccounts);

        //Insert child Opportunities with open and closed stages
        List<Opportunity> newOppties = new List<Opportunity>();
        for (Account a :newAccounts){
            for (Integer i=0; i<10; i++) {
                newOppties.add(new Opportunity(
                    Name = 'TestOpportunity'+i,
                    AccountId = a.Id,
                    Amount = 1000,
                    StageName = 'Prospecting',
                    CloseDate = date.today()
                    )
                );
                newOppties.add(new Opportunity(
                    Name = 'TestOpportunity'+i,
                    AccountId = a.Id,
                    Amount = 1000,
                    StageName = 'Closed Won',
                    CloseDate = date.today()
                    )
                );
            }
        }
        // Insert Opportunities
        Database.insert(newOppties);
    }


    @isTest
    public static void calculateRollUpSummaryonAccountWhenOpportunitesInserted() {

        List<Account> accountList = [SELECT Id, Total_Pipeline__c FROM Account];

        // Assert Total_Pipeline__c on the 1st Account record with SUM of Amount on open Child Opportunities 
        Id acc1Id = accountList.get(0).Id;
        Decimal totalPipeLineonAccount1 = accountList.get(0).Total_Pipeline__c;
        AggregateResult sum = [SELECT SUM(Amount) FROM Opportunity WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND AccountId  = :acc1Id];
        Decimal sumAmount = Decimal.ValueOf(String.ValueOf(sum.get('expr0')));
        System.assertEquals(totalPipeLineonAccount1, sumAmount);

        // Assert Total_Pipeline__c on the 2nd Account record with SUM of Amount on open Child Opportunities
        Id acc2Id = accountList.get(1).Id;
        Decimal totalPipeLineonAccount2 = accountList.get(1).Total_Pipeline__c;
        AggregateResult sum2 = [SELECT SUM(Amount) FROM Opportunity WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND AccountId  = :acc2Id];
        Decimal sumAmount2 = Decimal.ValueOf(String.ValueOf(sum2.get('expr0')));
        System.assertEquals(totalPipeLineonAccount2, sumAmount2);

    }

    
    @isTest
    public static void calculateRollUpSummaryonAccountWhenOpportunitesUpdated() {
        // Update Amount on all Opportunities
        List<Opportunity> opp = [SELECT Id, Amount FROM Opportunity];
        for (Opportunity o :opp) {
            o.Amount = 500;
        }

        //update Opportunities
        Test.startTest();
            Database.update(opp);
        Test.stopTest();

        List<Account> accountList = [SELECT Id, Total_Pipeline__c FROM Account];

        // Assert Total_Pipeline__c on the 1st Account record with SUM of Amount on open Child Opportunities
        Id acc1Id = accountList.get(0).Id;
        Decimal totalPipeLineonAccount1 = accountList.get(0).Total_Pipeline__c;
        AggregateResult sum = [SELECT SUM(Amount) FROM Opportunity WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND AccountId = :acc1Id];
        Decimal sumAmount = Decimal.ValueOf(String.ValueOf(sum.get('expr0')));
        System.assertEquals(totalPipeLineonAccount1, sumAmount);

        // Assert Total_Pipeline__c on the 2nd Account record with SUM of Amount on open Child Opportunities
        Id acc2Id = accountList.get(1).Id;
        Decimal totalPipeLineonAccount2 = accountList.get(1).Total_Pipeline__c;
        AggregateResult sum2 = [SELECT SUM(Amount) FROM Opportunity WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND AccountId = :acc2Id];
        Decimal sumAmount2 = Decimal.ValueOf(String.ValueOf(sum2.get('expr0')));
        System.assertEquals(totalPipeLineonAccount2, sumAmount2);
    }
    
    @isTest
    public static void calculateRollUpSummaryonAccountWhenOpportunitesDeleted() {
        List<Opportunity> opptoDelete = [SELECT Id FROM Opportunity];
        
        Test.startTest();
            Database.delete(opptoDelete.get(0));
        Test.stopTest();
        
        List<Account> accountList = [SELECT Id, Total_Pipeline__c FROM Account];

        // Assert Total_Pipeline__c on the 1st Account record with SUM of Amount on open Child Opportunities
        Id acc1Id = accountList.get(0).Id;
        Decimal totalPipeLineonAccount1 = accountList.get(0).Total_Pipeline__c;
        AggregateResult sum = [SELECT SUM(Amount) FROM Opportunity WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND AccountId = :acc1Id];
        Decimal sumAmount = Decimal.ValueOf(String.ValueOf(sum.get('expr0')));
        System.assertEquals(totalPipeLineonAccount1, sumAmount);

        // Assert Total_Pipeline__c on the 2nd Account record with SUM of Amount on open Child Opportunities
        Id acc2Id = accountList.get(1).Id;
        Decimal totalPipeLineonAccount2 = accountList.get(1).Total_Pipeline__c;
        AggregateResult sum2 = [SELECT SUM(Amount) FROM Opportunity WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND AccountId = :acc2Id];
        Decimal sumAmount2 = Decimal.ValueOf(String.ValueOf(sum2.get('expr0')));
        System.assertEquals(totalPipeLineonAccount2, sumAmount2);
    }
}
