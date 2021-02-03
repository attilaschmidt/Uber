public class GenericRollUpSummary {
    public GenericRollUpSummary(Schema.SObjectType parentObjectName, 
                                Schema.SObjectType childObjectName,
                                Set<Id> parentIdSet, 
                                String ParentId, 
                                String rollUpFieldName, 
                                String sumFieldName,
                                String customQuery) {
               
        String query = 'Select ' + ParentId+ ', SUM(' + sumFieldName + ') MY_SUM From '+ childObjectName + ' WHERE ' +
                        customQuery + ParentId + ' IN :parentIdSet GROUP BY '+ ParentId;
        List <AggregateResult> result = Database.query(query);
        Map<Id, AggregateResult> idToResult = new Map<Id, AggregateResult>();
        for (AggregateResult ar: result) {
            Id parId = String.ValueOf(ar.get(ParentId));
            idToResult.put(parId, ar);
        }
        System.debug('idToResult' + idToResult);
        
        List<SObject> parentObjectList = new List<SObject>();
        String query2 = 'SELECT Id, ' + rollUpFieldName + ' FROM ' + parentObjectName + ' WHERE ID IN: parentIdSet';
        for (SObject par: Database.query(query2)){
            Decimal rollUpSum = Decimal.ValueOf(String.ValueOf(idToResult.get(par.Id).get('MY_SUM')));
            par.put(rollupFieldName, rollUpSum);
            parentObjectList.add(par); 
        }

        if (parentObjectList.size() > 0){
            update parentObjectList;
        }
    }
}
