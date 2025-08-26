public class MapClass {
    public static void mapMethods(){
                Map<Integer,String> mmap=new Map<Integer,String>{1=>'vk',2=>'kv'};
                      System.debug(mmap);
        //clear()
        
        Map<Integer,String> map1=new Map<Integer,String>();
        map1.put(45,'vivek');
        System.debug(map1);
        
        //map1.clear();
        System.debug(map1);
        
        //clone()
        Map<Integer,String> map2=map1.clone();
        System.debug(map2);
        
        //deepClone()
        //
        
        //equals(map2)
        System.debug(map1.equals(map2));
        
        //get(key)
        System.debug(map1.get(45));
        
      //getSObjectType()
          
        //hashCode()
       //Map<Integer,Integer> nn= mmap.hashCode();
       // System.debug(nn);
        
        //isEmpty()
        Map<String,String> map4=new Map<String,String>();
        System.debug(map4);
        
        //keySet()
        map4.put('a','apple');
        map4.put('b','ball');
        Set<String> keys=new Set<String>();
        keys=map4.keySet();
        System.debug(keys);
        
        //put(key,value)
        Map<String,String> map7=new Map<String,String>();
       map7.put('c','cat');
        System.debug(map7.get('c'));
        
        //putAll(fromMap)
        map7.putAll(map4);
        System.debug(map7);
        
        //putAll(sObjectArray)
        List<Account> acc=new List<Account>();
        acc.add(new Account(Name='TestAcc'));
        //insert acc;
        
        Map<ID,Account> map9=new Map<ID,Account>();
        map9.putAll(acc);
        System.debug(map9);
        
        
        //remove(Key)
       //Map<String,String> map10=new Map<>();
       System.debug(map7);
        map7.remove('c');
        System.debug(map7);
        
        //size()
        System.debug(map7.size());
        
        //toString()
        Map<String,String> mmp=new Map<String,String>{'k'=>'ka'};
            mmp.toString();
        
        System.debug(mmp);
        
        //values()
        List<String> lii=new List<String>();
       lii=mmp.values();
        System.debug(lii);
       
    }
}