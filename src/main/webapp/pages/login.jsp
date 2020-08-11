<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%-- <c:url value="/login" var="loginUrl"/> --%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ALG AND PRO</title>
<style type="text/css">
*{
  box-sizing:border-box;
  -moz-box-sizing:border-box;
  -webkit-box-sizing:border-box;
  font-family:arial;
}
body{background:#376175;}
h1{
  color:#ccc;
  text-align:center;
  font-family: 'Vibur', cursive;
  font-size: 50px;
}

.login-form{
  width:350px;
  padding:40px 30px;
  background:#eee;
  border-radius:5px;
  margin:auto;
  position: absolute;
  left: 0;
  right: 0;
  top:20%;
}
.form-group{
  position: relative;
  margin-bottom:15px;
}
.form-control{
  width:100%;
  height:50px;
  border:none;
  padding:5px 7px 5px 15px;
  background:#fff;
  color:#666;
  border:2px solid #ddd;
}
.form-group .fa{
  position: absolute;
  right:15px;
  top:17px;
  color:#999;
}

.log-btn{
  background:#0AC986;
  dispaly:inline-block;
  width:100%;
  font-size:16px;
  height:50px;
  color:#fff;
  text-decoration:none;
  border:none;
}

</style>

</head>
<body>
<div class="login-form">
<form action="/admin" method="post">         
    <c:if test="${invalid != null}">          
        <p>  
            Invalid username and password.  
        </p>  
    </c:if>  
    <%-- <c:if test="${param.logout != null}">         
        <p>  
            You have been logged out.  
        </p>  
    </c:if> --%>
     <h1>Admin</h1>
     <div class="form-group">
       <input type="text" class="form-control" placeholder="Username " id="UserName" name="username">
       <i class="glyphicon glyphicon fa fa-user"></i>
     </div>
     <div class="form-group">
       <input type="password" class="form-control" placeholder="Password" id="Passwod" name="password">
       <i class="fa fa-lock" aria-hidden="true"></i>
     </div>
     <input type="hidden"                          
        name="${_csrf.parameterName}"  
        value="${_csrf.token}"/> 
     <button type="submit" class="log-btn" >Log in</button>    
   </div>
</form>
<% 
HttpServletResponse httpResponse = (HttpServletResponse) response;
httpResponse.setHeader("Cache-Control", "public, no-cache, no-store, must-revalidate"); // HTTP 1.1
httpResponse.setHeader("Pragma", "no-cache"); // HTTP 1.0
httpResponse.setDateHeader("Expires", 0); 
%>
</body>
</html>