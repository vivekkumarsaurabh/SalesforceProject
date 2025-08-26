public class Pratices3 {
  /** private static String name{get;set;}    
    
  public String NameValue{
         get{return name;}
        set{name=value;}
    } **/
    
    // private String name{set;} 
   
   /** public String NameValue{
    
        set{name=value;}
    }**/
    
     // private String name{get;} 
        
  /**    public String NameValue{
         get{return name;}
        
    }**/
    
    
 /**public String Prat{
        get{return Prat;}
        set{Prat=value;}
            
    }
    **/
    
    
 
      
   /**   public void setName(String newName){
        this.Name=newName;        
    }
    public String getName(){
        return Name;
        
    }
    **/

     public String name;
     public String email;
     private String Phone;
     
  
 /**   public Pratices3(String name, String email,String phone){
        this.name=name;
        this.email=email;
        this.phone=phone;
        
    }
    
    public void print(){
        System.debug('name==>'+name);
        System.debug('email==>'+email);
        System.debug('phone==>'+phone);
    }
    **/
    
    
    
    
    //Multilevel Inheritance
  
   public abstract class abs{
       public abs(){
           
           System.debug('Checking Contructor ');
       }
     
       public abstract void p();
        public virtual void k(){
            System.debug('k');
        }
    } 
    
 public virtual class Other1 extends abs{
    public override void p(){
         System.debug('checking');
     }   
   public Other1(){
         super();
       
       }
        public virtual void fun1(){
            System.debug('Hello World');
        }
 
     
    }

  public virtual class Other2 extends Other1{
         //override method
        public override void fun1(){
            System.debug('Algocirrus');
        }
       
    }
    
    public virtual class Other3 extends Other2{

        public void fu(){
              System.debug('Testing Multilevel');
        }

        
    }
    
 
  
  /**  public void mef(){
        System.debug('testing');
    } **/
}