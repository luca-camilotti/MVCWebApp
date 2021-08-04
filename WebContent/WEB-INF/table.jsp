<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.util.ArrayList"  
    import="luke.models.classes.UploadItem"   
    import="luke.date.converter.DateConverter"
    import="luke.models.classes.User"    
    import="luke.models.classes.AccessoSportello"
    import="luke.models.classes.SimpleRecord"
    import="luke.ads.martino.AppConfig"
    import="luke.ads.martino.AppConfig" 
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
<% context = getServletContext().getContextPath(); 
	String etichettaTabella = AppConfig.etichettaTabella((String) request.getAttribute("table"));
%>

<!DOCTYPE html>
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




/* jQuery password strength checker:
	
 * https://phppot.com/jquery/jquery-password-strength-checker/
 
   https://www.c-sharpcorner.com/Blogs/how-to-check-password-strength-in-jquery
 */
 

var myModalSearch;  // modal with a form submit
var myModalMessage;  // modal with a message
var myModalDelete;  // modal with a form submit for deleting an element
var myForm; 
var uploadForm; 


$(document).ready(function(){
	// mostra il toast se ci sono messaggi
	if($('.toast .toast-body').html().trim()!="")
		$('.toast').toast('show');  // show the toast 
	
		
	myModalSearch = new bootstrap.Modal(document.getElementById('myModalSearch'), {
		backdrop : 'static', // do not close modal if user click outside
		keyboard : false
	})
	// mostra il modale di ricerca (collegato con l'azione "Cerca")
	$('a[href = "#search"]').click(function(){
		 //alert('Cerca!');
		myModalSearch.show(); 
	});
	
	// Show dialog to confirm delete record:
	myModalDelete = new bootstrap.Modal(document.getElementById('myModalDelete'), {
		backdrop: 'static',  // do not close modal if user click outside
		keyboard: false   // cannot even press esc from keyboard
	}) 
	formDelete = document.getElementById("delete-record-form");
	
	$(document).on("click", "#deleteRecord", function () {
		//alert("Elimina");
		$('#myModalDelete .modal-body #id-delete').html($(this).data('id')); // set inner html
		$('#myModalDelete .modal-body #id').val($(this).data('id')); // get the value of data-id attribute
		myModalDelete.show();
	});
	
	$(document).on("click", "#delete-form-submit", function () {
		//alert("Elimina");
		formDelete.submit();
		myModalDelete.dismiss();
	});
	
	/* Other stuff */
	
	/*
	myModalMessage = new bootstrap.Modal(document.getElementById('myModalMessage'), {
		backdrop: 'static',  // do not close modal if user click outside
		keyboard: false
	}) 
	
	
	// make a redirect when the modal closes
	var myModalM = document.getElementById('myModalMessage');
	myModalM.addEventListener('hidden.bs.modal', function(event) {
		$(location).attr('href', 'Login')  // redirect to a page
	});

	// $('#myModal').modal({backdrop: 'static', keyboard: false})
	myModal = new bootstrap.Modal(document.getElementById('myModal'), {
			backdrop : 'static', // do not close modal if user click outside
			keyboard : false
	})
<%= commentModal %>myModal.show();  // comment this line of code depending on commentModal value
	
	myForm = document.getElementById("modal-form-id");  // normal auth form
	
	uploadForm = document.getElementById("file-upload-form");	// upload file form
	*/
});




/*
// submit modal form
$(document).on("click", "#modal-form-submit", function () {
	myForm.submit();  // submit modal internal form
	//$(location).attr('href', 'Login')  // redirect
});


// upload file ajax request
$(document).on("click", "#inputGroupFileAddon", function () {
	event.preventDefault();
	// Options:
	// uploadForm.submit();  // 1) simply submit the form
	
	// Check if form is ok, otherwise return a toast message
	if($('#inputGroupFile').val()=="" || $('#datefile').val()=="") {
		$('.toast-body').html("Missing field!");
		$('.toast').toast('show');
		return;
	}
	
	// 2) Ajax request
	var data = new FormData(uploadForm);  // get form data
	
					$.ajax({  // send ajax request to FileUpload servlet
						type : "POST",
						enctype : 'multipart/form-data',
						url : 'FileUpload',
						data : data,
						processData : false,
						contentType : false,
						cache : false,
						success : function(responseText) {
							// $('#ajaxGetUserServletResponse').text(responseText);
							$('#myModalMessage .modal-body #modal-message').html(responseText);
							myModalMessage.show();
						}
					});
	
	
		


});

	$(document).on(
			"click",
			".btnModal",
			function() {
				//var x = new Date(); 
				//var myHeading = "<p>I Am Added Dynamically </p>";
				var message = $('.modal-body #modal-message').html(); // get inner html
				//$("#modal-body").html(myHeading + x);   
				$('#myModal .modal-body #modal-message').html(
						message + $(this).data('id') + '?'); // set inner html
				$('#myModal .modal-body #myId').val($(this).data('id')); // get the value of data-id attribute
				myModal.show();
			});
*/
</script>
<!-- Bootstrap Navbar -->
<div class="container">
<nav class="navbar fixed-top navbar-expand-lg navbar-light bg-light">
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
      <!--form class="d-flex" >
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-success" type="submit">Search</button>
      </form -->
    </div>
  </div>
</nav>
</div>



<!-- Toast -->

<!-- For Overlay -->
<div style="position: relative;">

<!-- Flexbox container for aligning the toasts: position-fixed class do the overlay -->
<div aria-live="polite" aria-atomic="true" class="d-flex justify-content-center align-items-center w-100 my-toast-flexbox-container">

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

<!-- Toast - End -->

<div class="container-fluid">

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-6">
	<h3></h3>
  </div>
  <div class="mb-3 col-3">
  </div>
</div>


</div>



<!-- Table -->
<div class="container">

<div class="row d-flex justify-content-center">
  
  <div class="mb-3 col-6"><!-- Contenitore form -->
  
  	<div class="mb-3 col-8">
		<h3>Inserisci un nuovo dato</h3>
  	</div>
  
  	<form method="post" id="insertForm" action="simpleinsert">

  	<div class="mb-3 col-8">
    	<label for="table" class="form-label">Tabella</label>
    	<input type="text" class="form-control" name="table" id="table" required readonly="readonly" value="${table}">
  	</div>
  <% 
  if(request.getAttribute("table")!= null) {
  	String tabletype = (String) request.getAttribute("table"); 
  	if(tabletype.equalsIgnoreCase("giudici") || tabletype.equalsIgnoreCase("volontari")) {
  		out.println("<div class=\"mb-3 col-8\"><label for=\"surname\" class=\"form-label\">Cognome</label>"
  			    +"<input type=\"text\" class=\"form-control\" name=\"surname\" id=\"surname\" required ></div>"
  			  +"<div class=\"mb-3 col-8\"><label for=\"name\" class=\"form-label\">Nome</label>"
  			    +"<input type=\"text\" class=\"form-control\" name=\"name\" id=\"name\" required ></div>");
  	}
  	else if(tabletype.equalsIgnoreCase("tipoads") || tabletype.equalsIgnoreCase("motiviaccesso") || tabletype.equalsIgnoreCase("sedi")) {
  		out.println("<div class=\'mb-3 col-8\'><label for=\'value\' class=\'form-label\'>Valore</label><input type=\'text\' class=\'form-control\' name=\'value\' id=\'value\' required ></div>");
  			  
  	}
  }  	
  %>
  	<div class="mb-3 col-8">
  		<h3></h3>
	</div>
  	<div class="mb-3 col-8">
  		<button type="submit" class="btn btn-primary">Aggiungi</button>
	</div>

</form>
  
  </div><!-- form -->
  
  
  <div class="mb-3 col-6">
	<h2>Tabella <%= etichettaTabella %></h2>
	
	<table class="table table-striped table-hover table-responsive">
 	<thead>
    <tr>      
      <th scope="col">Valore</th>
      <th scope="col">ID</th>
      <th scope="col"></th>
    </tr>
  	</thead>
  <tbody>
    
    
    <%
    ArrayList<SimpleRecord> list = (ArrayList<SimpleRecord>) request.getAttribute("list");
    if (list != null) {
		for (SimpleRecord t : list) {  // send parameter id and table to url deletesimple
			// <a class=\'btn btn-primary\' data-id=\'"+t.getId()+"\' href=\'simpledelete?id="+t.getId()+"&table="+request.getAttribute("table")+"\' role=\'button\'>Elimina</a>
			// <input id=\'btnModalConfirm\' class=\'btn btn-primary btnModal\' type=\'button\' data-id=\'"+t.getId()+"\' value=\'Elimina\'>
			out.println("<td>"+t.getValue()+"</td><td scope=\"row\">"+t.getId()+"</td><td><input id=\'deleteRecord\' class=\'btn btn-primary btnModal\' type=\'button\' data-id=\'"+t.getId()+"\' value=\'Elimina\'></td></tr>");
		}
	}
    %>
    
  </tbody>
</table>
	

  </div><!-- col-6 -->
</div><!-- row dflex -->



</div>

<!-- Modal with form: confirm to delete record -->
<div id="myModalDelete" class="modal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" >
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Conferma</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p id="modal-message">Sei sicuro di voler eliminare in modo definitivo la riga <span id='id-delete'></span> da ${table}?</p>
        <form id="delete-record-form" method="post" action="simpledelete">
          <input hidden type="text" name="id" id="id" value=""/>
          <input hidden type="text" name="table" id="table" value="${table}"/>
          <!--button id="your-id">submit</button-->
		</form>  
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annulla</button>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal" id="delete-form-submit" >Elimina</button>
      </div>
    </div>
  </div>
</div>


<!-- Modal with form -->
<div id="myModalSearch" class="modal" tabindex="-1" >
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Cerca</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p id="modal-message">Imposta i campi per la ricerca. I campi vuoti saranno ignorati.</p>
        <form id="modal-form-id" method=post action="<%= context+"/" %>App/search">
        	<div class="form-group date mb-3 col-3" data-provide="datepicker"	data-date-language="it" data-date-format="dd/mm/yyyy">
    			<label for="fromdate" class="form-label">Dalla data</label>
				<input type="text" id="fromdate" name="fromdate" class="form-control" placeholder="dd/mm/yyyy" readonly="readonly" >
				<div class="input-group-addon">
					<span class="glyphicon glyphicon-th"></span>
				</div>
  			</div>
  			<div class="form-group date mb-3 col-3" data-provide="datepicker"	data-date-language="it" data-date-format="dd/mm/yyyy">
    			<label for="todate" class="form-label">Alla data</label>
				<input type="text" id="todate" name="todate" class="form-control" placeholder="dd/mm/yyyy" readonly="readonly" >
				<div class="input-group-addon">
					<span class="glyphicon glyphicon-th"></span>
				</div>
  			</div>
  			<div class="mb-3 col-8">
    			<label for="benef" class="form-label">Beneficiario</label>
    			<input type="text" class="form-control" name="benef" id="benef" >
  			</div>
  			<div class="mb-3 col-8">
    			<label for="ads" class="form-label">Amministratore</label>
    			<input type="text" class="form-control" name="ads" id="ads" >
  			</div>
  			<div class="mb-3 col-8">
    			<label for="opr" class="form-label">Operatore sportello</label>
    			<input type="text" class="form-control" name="opr" id="opr" >
  			</div>
  			<div class="mb-3 col-8">
    			<label for="motivo" class="form-label">Motivo accesso</label>
    			<input type="text" class="form-control" name="motivo" id="motivo" >
  			</div>
  			<div class="mb-3 col-3">
  			    <button type="submit" id="submitForm" class="btn btn-primary" id="your-id">Avvia ricerca</button>
  			</div>
		</form>  
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
        
      </div>
    </div>
  </div>
</div>


</body>
</html>