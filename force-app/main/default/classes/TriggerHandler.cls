public abstract class TriggerHandler {
    abstract void beforeInsert();
    abstract void beforeUpdate();
    abstract void beforeDelete();
    abstract void afterInsert();
    abstract void afterUpdate();
    abstract void afterDelete();
    abstract void afterUndelete();

    public void execute(){
        if (Trigger.isInsert){
            if(Trigger.isBefore){
                beforeInsert();
            } else {
                afterInsert();
            }
        }
         if (Trigger.isUpdate){
            if(Trigger.isBefore){
                beforeUpdate();
            } else {
                afterUpdate();
            }
        }
        if (Trigger.isDelete){
            if(Trigger.isBefore){
                beforeDelete();
            } else {
                afterDelete();
            }
        } else if (Trigger.isUndelete){
            afterUndelete();
        }
    }
}
