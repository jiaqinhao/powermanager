package com.neusoft.util;

public class Contents{

    public static String  to_col(String pro){
        int  index=0;
        char[] chars=pro.toCharArray();
        for(int i=0;i<chars.length;i++){
            if(chars[i]>='A'&&chars[i]<='Z'){
                index=i;
                break;
            }
        }
        return pro.substring(0,index)+"_"+pro.substring(index);


    }
}
