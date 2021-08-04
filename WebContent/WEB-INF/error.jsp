<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<!-- Css -->
<jsp:include page="shared/cssinclude.jsp"> <jsp:param name="context" value="${context}"/> 
</jsp:include>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>${title}</title>
</head>
<body>

<!-- JavaScript -->
<jsp:include page="shared/jsinclude.jsp"> <jsp:param name="context" value="${context}"/> 
</jsp:include>

<!-- Bootstrap Navbar -->
<jsp:include page="shared/navbar.jsp"> <jsp:param name="context" value="${context}"/> 
</jsp:include>

<!-- Bootstrap Toast -->
<jsp:include page="shared/toast.jsp"> <jsp:param name="context" value="${message}"/> 
</jsp:include>

<h1>Error!</h1>
<h3>${message}</h3>
</body>
</html>