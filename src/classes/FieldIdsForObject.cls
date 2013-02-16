/*
	@Author      : Mohammad Usman
	@Version     : v1.0
	@Description :Generate field Ids for any object(Custom,Standard) and pre-populate fields for selected object
*/
public abstract class FieldIdsForObject {
    /*
    	@Param : sObjectName
    	@Return: map(value=> Field Id,Key => Field label name) 
    */
    public map<String, String> getFieldsIdsMap(String sObjectName) { 
        map<String, String> label_IdMap = new map<String, String>();
        if(null!= sObjectName && sObjectName.trim() != '') {
        	if(!isObjectValid(sObjectName)){
        		return null;
        	}
            PageReference p = new PageReference('/' +  Schema.getGlobalDescribe().get(sObjectName).getDescribe().getKeyPrefix() + '/e?nooverride=1');
            String html = '';
            if(!Test.isRunningTest()) {
                html = p.getContent().toString();
            } else {
                html = ''; 
            }
            Matcher m = Pattern.compile('<label for="(.*?)">(<span class="requiredMark">\\*</span>)?(.*?)</label>').matcher(html);
            while(m.find()) {
                String label = m.group(3);
                String id = m.group(1);
                label_IdMap.put(label, id);
            }
        }
        return label_IdMap;
    }
    
    /*Remove field vlabel and field id from the map*/
    public virtual void removeFieldLabel(map<String, String> filedIdMapToBeRemoveLabel,String fieldLabel) {
    	if(filedIdMapToBeRemoveLabel != null && fieldLabel != null && fieldLabel.trim() != ''){
    		filedIdMapToBeRemoveLabel.remove(fieldLabel);
    	}
    }
    
	/*Add a new field label and field Id*/
    public virtual map<String, String> addFieldLabel(map<String, String> filedIdMapToBeAddLabel,String fieldLabel,String fieldId) {
    	if(filedIdMapToBeAddLabel != null && fieldLabel != null && fieldLabel.trim() != '' && fieldId != null && fieldId.trim() != ''){
    		filedIdMapToBeAddLabel.put(fieldLabel,fieldId);
    		return filedIdMapToBeAddLabel;
    	}
    	return null;
	}
    
    /*Convert field Id to pre-populate reference field*/
    public virtual String converFieldIdForLookupFieldId(String fieldId){
    	if(fieldId != null && fieldId.trim() != ''){
    		return fieldId+'_lkid';
    	}	
    	return '';
    }
    
    /*Object name Validate*/
    private boolean isObjectValid(String sObjectName){
    	try{
    		sObject obj = Database.query('SELECT Id FROM '+sObjectName+' limit 1');
    		return true;
    	}catch(DMLException ex){
    		return false;
    	}
    	return false;
    }
}
