public with sharing class DemoOfsObjectFieldIds extends FieldIdsForObject{
    public String selectedObjectName{get;set;} // Selected Object name
    public map<String,String> fields{get;set;} // Field Id Map
    public DemoOfsObjectFieldIds(){
    }
    
    public list<selectOption> getFieldsForSelectedObject(){ 
        list<selectOption> objectsList = new list<selectOption>();
        try{
             list<String> tempObject = new list<String>{'Account','Lead','Opportunity','Contact','Case'};
             Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
             Schema.DescribeSObjectResult r;
             Schema.SobjectType sobjecttype;       
             for(String objectKey: gd.keySet()){ 
                 sobjecttype = gd.get(objectKey);
                 r = sobjecttype.getDescribe();
                 if((r.getName()).contains('__c'))
                     objectsList.add(new SelectOption(r.getName(), r.getLabel()));
             }
             for(string obj:tempObject){ 
                objectsList.add(new selectOption(obj,obj));
             }
        }catch(Exception ex){
                apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to get fields for selected Object!'));
        }
        return objectsList;
    }
    
    public pageReference getFieldsIds(){
        try{
            fields = getFieldsIdsMap(selectedObjectName);
        }catch(Exception e){
            
        }
        return null;
    }
    
    public pagereference prepopulate(){
        string params = '';
        Integer a = 0;
        getFieldsIds();
        for(string p:fields.values()){
            params += p+'=Test Value '+a+'&';
            a++;
        }
        PageReference p = new PageReference('/' +  Schema.getGlobalDescribe().get(selectedObjectName).getDescribe().getKeyPrefix() + '/e?'+params+'nooverride=1');
        p.setRedirect(true);
        return p;
    } 
}