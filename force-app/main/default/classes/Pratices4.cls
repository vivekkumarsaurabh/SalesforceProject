public class Pratices4 {
  /**
    
    //Interface acheive 100% abstraction
    interface A{
      
      void run();
    }
    interface B{
        void run();
    }
    public virtual class AClass implements A,B{
        public virtual void run()
        {
            System.debug('Interface ');
        }
    }
    public class BClass extends AClass implements A{
        public BClass(){
            super();
            System.debug('New');
        }
        
        public override void run(){
            List<string> listX = new List<String> {'A','B','C'};
                   Iterator<String> iter = listX.iterator();
                while(iter.hasNext()){
                    System.debug(iter.next());
                }
       
            System.debug('Interface 2');
        }
}
        **/
    
    
  
   // public static String var='saurabh';
      public virtual class A{
        public virtual void print(){
              System.debug('Check 1'); 
          }
          String var;
          {
                    System.debug(var); 
          }
   
         
     /**  public A(){
              // System.debug(var);
            System.debug('con1');
            
        }**/
        /**  public void method122(){
              System.debug(var);
          }
         **/
          
         
    }
 public class B extends A{
       String var;
     
     {      
     System.debug(var);  
     } 
public B(){
   
     this.var='ans';
        System.debug(var);
         System.debug('llll');
     }
   
  /**   public override void print(){
         super.print();
         var='k';
         System.debug(var);
         System.debug('check 2 ');
     }
    **/
  }
    
  /**  public void metod(){
          
Pratices4.B obj=new Pratices4.B();
     
     System.debug(obj instanceof Pratices4.A);
    
    }   **/
   /** static{
         var='kumar';
         
    }**/   
 /**   {
       System.debug(var); 
    }
    
        **/
   
    
    public class Datt{
  /**     transient datetime d1;
        datetime d2;
        public String getd1(){
            if(d1==null) d1=System.now();
            return ' '+d1;
        }
         public String getd2(){
            if(d2==null) d2=System.now();
            return ' '+d2;
        } **/
        {
           /** try{
                   integer k=1/0;
               System.debug(k);
            } catch(MathException ajay){
                System.debug('this is erroe'+ajay);
            }finally{
                System.debug('this is always execute');
            }**/
            
            
           /** try{
                   String s;
                
               System.debug(s.toLowerCase());
            } catch(Exception ajay){
                System.debug('this is erroe'+ajay);
            }finally{
                System.debug('this is always execute');
            }
**/
            
            
     
        }
    }
}