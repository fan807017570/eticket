package com.zteingenico.eticket.buyerportal.utils;  
 
import javax.mail.*;  
    
public class MyAuthenticator extends Authenticator{  
    String userName=null;  
    String password=null;  
       
    public MyAuthenticator(){  
    }  
    public MyAuthenticator(String username, String password) {   
        this.userName = username;   
        this.password = password;   
    }   
    protected PasswordAuthentication getPasswordAuthentication(){  
        return new PasswordAuthentication(userName, password);  
    }  
 
   


public static boolean sendMail(String title,String content,String mailAddress){  
         //这个类主要是设置邮件  
      MailSenderInfo mailInfo = new MailSenderInfo();   
      mailInfo.setMailServerHost("smtp.163.com");   
      mailInfo.setMailServerPort("25");   
      mailInfo.setValidate(true);   
      mailInfo.setUserName("liangjh2010@163.com"); //发送邮箱帐号  
      mailInfo.setPassword("liang123");//发送邮箱密码   
      mailInfo.setFromAddress("liangjh2010@163.com");//发送邮箱帐号     
      
      mailInfo.setToAddress(mailAddress);   //接收邮箱帐号
      mailInfo.setSubject(title);   
      mailInfo.setContent(content);   
      
         //这个类主要来发送邮件  
      SimpleMailSender sms = new SimpleMailSender();  
          boolean  b = sms.sendTextMail(mailInfo);//发送文体格式   
//          sms.sendHtmlMail(mailInfo);//发送html格式  
          return b;
    }



/**
 * 邮件内容封装
 * @param args
 */




    public static void main(String args[]){ 
    	sendMail("TEST", "test","309741123@qq.com");
    }

    
}