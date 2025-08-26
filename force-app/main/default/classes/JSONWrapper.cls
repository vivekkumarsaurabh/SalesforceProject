public class JSONWrapper {

    Public static ControllingField makeWrapper(){
        ControllingField c = new ControllingField();
        List<DependentField> depList = new List<DependentField>();
        List<FieldValueList> fieldValList = new List<FieldValueList>();
        List<FieldValueList> fieldValList2 = new List<FieldValueList>();
        FieldValueList flVal1 = new FieldValueList();
        flVal1.lable = 'Approve';
        flVal1.value = 'Approve';
        FieldValueList flVal2 = new FieldValueList();
        flVal2.lable = 'Not Approve';
        flVal2.value = 'Not Approve';
        FieldValueList flValsate1 = new FieldValueList();
        flValsate1.lable = 'Up';
        flValsate1.value = 'Up';
        FieldValueList flValstate2 = new FieldValueList();
        flValstate2.lable = 'Bihar';
        flValstate2.value = 'Bihar';
        fieldValList.add(flVal1);
        fieldValList.add(flVal2);
        fieldValList2.add(flValsate1);
        fieldValList2.add(flValstate2);
        DependentField dep1 = new DependentField();
        dep1.FieldName = 'Approval Status';
        dep1.fl = fieldValList;
         DependentField dep2 = new DependentField();
        dep2.FieldName = 'State';
        dep2.fl = fieldValList2;
        depList.add(dep1);
        depList.add(dep2);
       // c.countryName = 'India';
        c.dp = depList;
        return c;
    }
    
    public static List<DependentField> makeJson(){
        ControllingField c = new ControllingField();
        List<DependentField> dli = new List<DependentField>();
        DependentField d1 = new DependentField();
        d1.FieldName = 'l';
        DependentField d2 = new DependentField();
        d2.FieldName = 'k';
        dli.add(d1);
        dli.add(d2);
        c.dp = dli;
        return dli;
    }
    
    public class ControllingField{       
        public List<DependentField> dp;        
    }
    
    public class DependentField{
       public String FieldName;
       public List<FieldValueList> fl;       
          
    }
    
    public class FieldValueList{
        public String lable;
        public String value;
    }
        
        
}