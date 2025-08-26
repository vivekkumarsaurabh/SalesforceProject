public virtual class PracticeApexClass{
	//instacne variabr
	//without static keyword
	public String name;
    public String rollNum;
    //class variable 
    //static key must
    static string collegeName;
    
    //constructor
  /**  public PracticeApexClass(String name, String rollNum){
       this.name = name;
       this.rollNum = rollNum;
       System.debug('===> '+rollNum);
    }**/
    
 /**   public PracticeApexClass(Integer name, String rollNum){
       this.name = String.valueOf(name);
       this.rollNum = rollNum;
       System.debug('===> '+rollNum);
    } **/
    
      public virtual class Abc{
        public virtual void abb(){
             System.debug('checking');
        }
           
    }
    
public class Pract1 extends Abc{
    
    public override void abb(){
        System.debug('checking2');
    }
}
    

    public virtual void ff(){
          String strt ='102,103';
   List<String> str1 = strt.split(',');
    for(String str : str1){
        System.debug(str);
    }
    

       // System.debug('mynameisvivek');
    }

     
    
}