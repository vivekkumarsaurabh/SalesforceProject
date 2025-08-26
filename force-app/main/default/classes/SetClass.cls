public class SetClass {
    public static void setMethods(){
        Set<String> set1=new Set<String>();
       set1.add('a');
        set1.add('e');
        System.debug(set1);
        
       String str=new List<String> ( set1 )[0];
        
        
        System.debug(str);
        
        List<String> li=new List<String>(set1);
        System.debug(li.get(0));
        //addAll(setElement)
        Set<String> set2=new Set<String>{'c','d','e'};
            set1.addAll(set2);
        System.debug(set1);
        
        //addAll(listElement)
        List<String> ll=new List<String>{'a','a'};
            set2.addAll(ll);
        System.debug(set2);
        
        //clear()
        set1.clear();
        
        //clone();
        Set<String> set3=set2.clone();
        System.debug(set3);
        
        //contains(setElement)
        System.debug(set3.contains('a'));
        
        //containsAll(setTOCompare)
        System.debug(set1.containsAll(set2));
        
        //containsAll(listToComare)
        
        //equals(set2)
      
        System.debug(set2.equals(set3));
        
        //hashCode()
        //
        //
        //isEmpty()
        Set<String> set5=new Set<String>();
        System.debug(set5.isEmpty());
        
        //remove(setOfElementRemove)
        set3.remove('a');
        System.debug(set3);
        
        //removeAll(setOfElement)
        //if both have same value then remove that values
        
        //removeAll(ListOfElement)
        
        
       //retainAll(setOfElement) 
        Set<String> set6=new Set<String>{'c'};
        System.debug(set2.retainAll(set6));
        System.debug(set2);
        
       //size()
        System.debug(set6.size());
        
        //toString()
        Set<Integer> l34=new Set<Integer>{4,66,7,9};
          l34.toString();
        System.debug(l34);
    } 
}