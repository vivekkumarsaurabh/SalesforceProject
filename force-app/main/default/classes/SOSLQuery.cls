/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 13/08/2025
* @Description : Class of SOSL query.
******************************************************************/
public class SOSLQuery {
    /**************************************************************************************************************************
	* @description : This method is for sosl query dynamic and also static query.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/ 
    public static void soslQuery(){
        //List<List<SObject>> groups = [FIND 'Group' IN NAME FILDS RETURNING Group(Id, Name)];
		//System.debug(groups);
		
		//List<List<SObject>> gr = [ FIND 'Group' IN Name FIELDS RETURNING Group (Id,Name,Type WHERE Type = 'Regular')];
		//System.debug(gr);
		//Database.search([ FIND 'Group' IN Name FIELDS RETURNING Group (Id,Name,Type WHERE Type = 'Regular')];);

        String filterValue = 'Group';
        String fieldType = 'Name';   
        String typefilter = 'Regular';
        List<String> fields  = new List<String>{'Id', 'Name', 'Type'};
        String query = 'FIND \''+filterValue+'\' IN '+fieldType+' FIELDS RETURNING Group ('+String.join(fields, ',')+' WHERE Type = \''+typefilter+'\')';
        List<List<sObject>> data = search.query(query);
        System.debug('Data =>'+data);
    }
    
}