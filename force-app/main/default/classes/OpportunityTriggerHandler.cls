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
        
        for (Rollup_Summary_Setting__mdt rollupSetting : [SELECT Parent_Field__c,
                                                                 Rollup_Field__c,
                                                                 Filter__c
                                                          FROM Rollup_Summary_Setting__mdt
                                                          WHERE Object__c = 'Opportunity']) {
                                                                                                      
            GenericRollUpSummary rollUp = new GenericRollUpSummary(Account.SObjectType, 
                                                                   Opportunity.SObjectType, 
                                                                   accountIds, 
                                                                   'AccountId', 
                                                                   rollupSetting.Parent_Field__c,
                                                                   rollupSetting.Rollup_Field__c,
                                                                   rollupSetting.Filter__c + ' ');
        
        }
    }
}