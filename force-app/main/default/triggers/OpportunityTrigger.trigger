trigger OpportunityTrigger on Opportunity (
    after insert, 
    after update, 
    after delete, 
    after undelete) {
    OpportunityTriggerHandler triggerhandler = new OpportunityTriggerHandler();
    triggerhandler.execute();
}


