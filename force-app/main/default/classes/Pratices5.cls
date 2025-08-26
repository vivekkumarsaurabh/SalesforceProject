public class Pratices5 {

    public virtual class MyException extends Exception{}
     //  public class Age extends MyException{}
        
        public void methodss(){
           try{
                integer i=0;
              if(i < 5)
                  throw new MyException('Invalid Error');
            }catch (MyException e){
                System.debug('this is custom error '+e.getMessage());
            } 
        }
          
}