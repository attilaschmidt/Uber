public class OpportunityTriggerHandler extends TriggerHandler {
    void OpportunityTriggerHandler(){}
    void beforeInsert(){}
    void beforeUpdate(){}
    void beforeDelete(){}
    void afterInsert(){calculateRollUpSummary(Trigger.new);}
    void afterUpdate(){calculateRollUpSummary(Trigger.new);}
    void afterDelete(){calculateRollUpSummary(Trigger.old);}
    void afterUndelete(){calculateRollUpSummary(Trigger.new);}

    
    private void calculateRollUpSummary(List<Opportunity> opportunityList){

    Set<Id> accountIds = new Set<Id>();
    List<Account> accountsToUpdate = new List<Account>();

    for (Opportunity opp: opportunityList) {
        accountIds.add(opp.AccountId);
    }

    GenericRollUpSummary rollUp = new GenericRollUpSummary(Account.SObjectType, 
                                                            Opportunity.SObjectType, 
                                                            accountIds, 
                                                            'AccountId', 
                                                            'Total_Pipeline__c', 
                                                            'Amount', 
                                                            'StageName != \'Closed Won\' AND StageName != \'Closed Lost\' AND ');    
    }
}