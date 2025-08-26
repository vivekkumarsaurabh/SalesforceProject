public class ListClass {
    public static void listMethods(){
        List<Integer> li=new List<Integer>();
        
        //add(listElement)
        li.add(1);
        li.add(2);
        
        //add(index,listElement)
        li.add(0,45);
        
        //System.debug(li.get(0));
       
        List<Integer> li2 =new List<Integer>{3,4};
        
        //addAll(fromList)
         li.addAll(li2);
        
        for(integer k: li){
            System.debug(k);
        }
        
        
        //clear()
          li.clear();
        /** for(integer k: li){
            System.debug(k);
        } **/
        
        //clone()
        List<integer> ll= li2.clone();
        System.debug(ll.get(0)); 
        
        //contains(listElement)
        System.debug(ll.contains(3));
        
        //equals(list2)
        System.debug(li2.equals(ll));
        
        //get(index)
        System.debug(ll.get(1));
        
        //getSObjectType()
       
        List<Contact> sobj =new Contact[]{};
      
        System.debug(sobj.getSObjectType());
        
        List<String> llist=new List<String>();
        llist.add('vivek');
        llist.add('kumar');
        
        for(string ss:llist){
            System.debug(ss);
        }
        llist.add(0,'Saurabh');
      
        for(string ss:llist){
            System.debug(ss);
        }
        
        //indeOf(listElement)
         System.debug(llist.indexOf('vivek'));
        
        //isEmpty()
        List<integer> li3=new List<integer>();
        
        System.debug(li3.isEmpty());
        
        //itrator()
        
        //remove(index)
        llist.remove(1);
        System.debug(llist);
        
        //set(index,listElement)
        llist.set(0,'vivek');
        System.debug(llist);
        
        //size()
        System.debug(llist.size());
        
        //sort()
        llist.sort();
        System.debug(llist);
        
        //List<Integer> li4=new Integer[2];
        List<Integer> li4=new List<Integer>();
        li4.add(1);
        li4.add(2);
          li4.add(3);
        li4.toString();
        System.debug(li4);
        
        
       
        
       
    }
}