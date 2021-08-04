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


<!-- Put page content here: -->

<!-- Bootstrap Sign in form -->
<div class="container-fluid">

  <h3>Please sign in to use all features</h3>
        <form>
            <div class="mb-3">
              <label for="email" class="form-label">Email address</label>
              <input type="email" class="form-control" formControlName="email" id="email" aria-describedby="emailHelp">
              <!-- div id="emailHelp" class="form-text">We'll never share your email with anyone else.</div -->
            </div>
            <div class="mb-3">
              <label for="password" class="form-label">Password</label>
              <input type="password" class="form-control" formControlName="password" id="password">
            </div>
            
            <button type="submit" class="btn btn-primary">Sign In</button>
        </form>
</div>

<!-- Bootstrap Table -->

<div class="container-fluid">
<div class="row d-flex justify-content-center">
<div class="mb-3 col-12">

<table class="table table-striped table-hover table-responsive">
 <thead>
    <tr>     
      <th scope="col">Id</th>
      <th scope="col">Nome</th>
      <th scope="col">Cognome</th>
      <th scope="col">Stipendio</th>
      <th class="d-none d-lg-table-cell" scope="col">Funzione</th>
      <th class="d-none d-md-table-cell" scope="col">Filiale</th>
      <th class="d-none d-md-table-cell" scope="col">Livello</th>      
    </tr>
  </thead>
  <tbody>
  	  
  	 <c:forEach var = "dip" items = "${list}">
      <tr>
        <td><c:out value = "${dip.id}" /></td>
        <td><c:out value = "${dip.nome}" /></td>
        <td><c:out value = "${dip.cognome}" /></td>
        <td><c:out value = "${dip.stipendio}" /></td>
        <td><c:out value = "${dip.funzione}" /></td>
        <td><c:out value = "${dip.filiale}" /></td>
        <td><c:out value = "${dip.livello}" /></td>
      </tr>
     </c:forEach>
  
  </tbody>
</table>
</div>
</div>
</div>

<!-- Page content end -->

</body>
</html>