<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.util.ArrayList"  
    import="luke.models.classes.UploadItem"   
    import="luke.date.converter.DateConverter"
    import="luke.models.classes.User"    
    import="luke.models.classes.AccessoSportello"
    import="luke.ads.martino.AppConfig" 
    import="luke.models.classes.ReportItem"     
%>

<%! private String commentModal = "//";
	private String context = null;
	private User getUser(HttpServletRequest request) {
		return (User) request.getSession().getAttribute("user");
	}
	private String username(HttpServletRequest request) {
		return getUser(request).getName();
	}
%>

<% context = getServletContext().getContextPath(); %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Bootstrap Css -->
<!--link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous" -->
<link href='<%= context+"/" %>css/bootstrap/bootstrap.min.css' rel='stylesheet' type='text/css'>
<!-- My Local Css -->
<link href='<%= context+"/" %>css/mycss.css' rel='stylesheet' type='text/css'>
<!-- Bootstrap Datepicker Css -->
<link href='<%= context+"/" %>css/bootstrap-datepicker.min.css' rel='stylesheet' type='text/css'>

<meta charset="ISO-8859-1">
<title><%= AppConfig.titleHead %></title>
</head>
<body>
<!--script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script-->
<script src='<%= context+"/" %>js/bootstrap/bootstrap.bundle.min.js' type='text/javascript'></script>
<script src='<%= context+"/" %>js/jquery-3.6.0.min.js' type='text/javascript'></script>

<!-- Bootstrap Datepicker Js -->
<!-- https://makitweb.com/how-to-add-datepicker-in-bootstrap/ -->
<!-- https://bootstrap-datepicker.readthedocs.io/en/latest/ -->
<script src='<%= context+"/" %>js/bootstrap-datepicker.min.js' type='text/javascript'></script>
<script src='<%= context+"/" %>locales/bootstrap-datepicker.it.min.js' type='text/javascript'></script>


<script type="text/javascript">
$(document).ready(function(){
	// mostra il toast se ci sono messaggi
	if($('.toast .toast-body').html().trim()!="")
		$('.toast').toast('show');  // show the toast 
	
});
</script>

<!-- Bootstrap Navbar -->
<nav class="navbar navbar-expand-lg fixed-top navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="#"></a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="<%= getServletContext().getContextPath() %>/App"><%= username(request) %></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#"></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="dashboard"><%= AppConfig.labelDashboard %></a>
        </li>        
        <li class="nav-item">
          <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true"></a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <%= AppConfig.labelTables %>
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="table?table=giudici"><%= AppConfig.etichettaTabella("giudici") %></a></li>
            <li><a class="dropdown-item" href="table?table=volontari"><%= AppConfig.etichettaTabella("volontari") %></a></li>            
            <li><a class="dropdown-item" href="table?table=tipoads"><%= AppConfig.etichettaTabella("tipoads") %></a></li>
            <li><a class="dropdown-item" href="table?table=motiviaccesso"><%= AppConfig.etichettaTabella("motiviaccesso") %></a></li>
            <li><a class="dropdown-item" href="table?table=sedi"><%= AppConfig.etichettaTabella("sedi") %></a></li>
          </ul>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="files"><%= AppConfig.labelFiles %></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#"></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="logout"><%= AppConfig.labelLogout %></a>
        </li>
      </ul>
      <!--form class="d-flex">
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-success" type="submit">Search</button>
      </form-->
    </div>
  </div>
</nav>

<!-- Toast -->

<!-- For Overlay -->
<div style="position: relative;">

<!-- Flexbox container for aligning the toasts: position-fixed class do the overlay -->
<div aria-live="polite" aria-atomic="true" class="my-toast-flexbox-container d-flex justify-content-center align-items-center w-100">

<!-- Container for stacking the toasts (if you show more than one) -->
<div class="toast-container">

<div class="toast" data-bs-delay="<%= AppConfig.toastTime %>" data-autohide="false" role="alert" aria-live="assertive" aria-atomic="true">
  <div class="toast-header">
    <!-- img src="..." class="rounded me-2" alt="..." -->
    <svg class="bd-placeholder-img rounded me-2" width="20" height="20" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" preserveAspectRatio="xMidYMid slice" focusable="false"><rect width="100%" height="100%" fill="#007aff"></rect></svg>
    <strong class="me-auto"><%= AppConfig.titleToast %></strong>
    <small>popup</small>
    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
  </div>
  <div class="toast-body">
    ${message}
  </div>
</div>

</div>
</div>
</div>


<!-- Report -->
<div class="container-fluid">

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-7">
	<h2><%= AppConfig.titleReport %></h2>
  </div>
  <div class="mb-3 col-3">
  </div>
</div>

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-10">

<div class="card text-dark bg-light mb-3">
  <div class="card-header"><h5 class="card-title">Parametri del report</h5></div>
  <div class="card-body">
    <!--  h5 class="card-title">Parametri del report</h5-->
    <p class="card-text">Dalla data ${fromdate} alla data ${todate}</p>
    <p class="card-text">Sede: ${sede}</p>
  </div>
</div>

<div class="card text-dark bg-light mb-3">
  <div class="card-header"><h5 class="card-title">Risultati</h5></div>
  <div class="card-body">
    <!--  h5 class="card-title">Parametri del report</h5-->
    <p class="card-text"><h6>Numero totale di accessi: ${num}</h6></p>
    <p class="card-text"><h6>Numero di persone distinte che hanno effettuato gli accessi: ${persone}</h6></p>
    
    <p class="card-text"><h2>Totale accessi raggruppati per motivo:</h2></p>
    
    <table class="table table-striped table-hover table-responsive">
 	<thead>
    <tr>      
      <th scope="col">Motivo Accesso</th>
      <th scope="col">Numero accessi</th>      
    </tr>
  	</thead>
  	<tbody>
    
    <%
    ArrayList<ReportItem> motivi = (ArrayList<ReportItem>) request.getAttribute("motivi");
    if (motivi != null) {
		for (ReportItem t : motivi) {
			out.println("<tr><td>"+t.getField() +"</td><td>"+t.getValue() +"</td></tr>");
		}
	}
    %>
    </tbody>
	</table>
    
    
    <p class="card-text"><h2>Totale accessi raggruppati per qualifica ads:</h2></p>
    
    <table class="table table-striped table-hover table-responsive">
 	<thead>
    <tr>      
      <th scope="col">Qualifica Ads</th>
      <th scope="col">Numero accessi</th>      
    </tr>
  	</thead>
  	<tbody>
    
    <%
    ArrayList<ReportItem> tads = (ArrayList<ReportItem>) request.getAttribute("tads");
    if (tads != null) {
		for (ReportItem t : tads) {
			out.println("<tr><td>"+t.getField() +"</td><td>"+t.getValue() +"</td></tr>");
		}
	}
    %>
    </tbody>
	</table>
    
    
    <p class="card-text"><h2>Totale accessi raggruppati per motivo e per qualifica ads:</h2></p>
    
    <table class="table table-striped table-hover table-responsive">
 	<thead>
    <tr>      
      <th scope="col">Motivo Accesso</th>
      <th scope="col">Qualifica Ads</th>
      <th scope="col">Numero accessi</th>      
    </tr>
  	</thead>
  	<tbody>
    
    <%
    ArrayList<ReportItem> motivitads = (ArrayList<ReportItem>) request.getAttribute("motivitads");
    if (motivitads != null) {
		for (ReportItem t : motivitads) {			
			out.println("<tr><td>"+t.getField()+"</td><td>"+t.getSecondfield()+"</td><td>"+t.getValue() +"</td></tr>");
		}
	}
    %>
    </tbody>
	</table>
    
  </div>
</div>

</div>
</div>

</div>

</body>
</html>