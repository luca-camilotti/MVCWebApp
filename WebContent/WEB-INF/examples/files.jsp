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
    import="luke.token.utils.TokenUtils" 
%>

<%! private String commentModal = "//";
	private String context = null;
	private User getUser(HttpServletRequest request) {
		return (User) request.getSession().getAttribute("user");
	}
	private String username(HttpServletRequest request) {
		return getUser(request).getName();
	}
	/*
	per l'upload del file vengono passati:
		- id del record accesso (sarà il valore di fkid nel record della tabella upload)
		- la data del record accesso (sarà il valore di date in upload)
		- file
		- descrizione
		- uid (user id) dell'utente, necessario per recuperare la chiave privata e verificare il token
		- token contente:
			- email dell'utente
			- id del record di accesso, da confrontare con il paramentro id del post
	*/
	
%>
<% context = getServletContext().getContextPath(); 

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

<script src='<%= context+"/" %>js/jquery-3.6.0.min.js' type='text/javascript'></script>
<script src='<%= context+"/" %>js/bootstrap/bootstrap.bundle.min.js' type='text/javascript'></script>


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
var myModalUpload;  // modal to upload file
var myForm; 
var uploadForm; 


$(document).ready(function(){
	// mostra il toast se ci sono messaggi
	if($('.toast .toast-body').html().trim()!="")
		$('.toast').toast('show');  // show the toast 
	
	/* Modal File Upload */
	
	myModalUpload = new bootstrap.Modal(document.getElementById('myModalUpload'), {
		backdrop : 'static', // do not close modal if user click outside
		keyboard : false
	})
	
	$(document).on("click", "#newfile", function () {
			event.preventDefault();
			myModalUpload.show();	
	});
		
	/* Modal Search */
	
	myModalSearch = new bootstrap.Modal(document.getElementById('myModalSearch'), {
		backdrop : 'static', // do not close modal if user click outside
		keyboard : false
	})
	// mostra il modale di ricerca (collegato con l'azione "Cerca")
	$('a[href = "#search"]').click(function(){
		 //alert('Cerca!');
		myModalSearch.show(); 
	});
	
	/* Modal Delete */
	
	// Show dialog to confirm delete record:
	myModalDelete = new bootstrap.Modal(document.getElementById('myModalDelete'), {
		backdrop: 'static',  // do not close modal if user click outside
		keyboard: false   // cannot even press esc from keyboard
	}) 
	formDelete = document.getElementById("delete-record-form");
	
	$(document).on("click", "#deleteRecord", function () {
		//alert("Elimina");
		$('#myModalDelete .modal-body #id-delete-span').html($(this).data('id')); // set inner html
		$('#myModalDelete .modal-body #id-delete').val($(this).data('id')); // get the value of data-id attribute
		myModalDelete.show();
	});
	
	$(document).on("click", "#delete-form-submit", function () {
		//alert("Elimina");
		formDelete.submit();
		myModalDelete.dismiss();
	});
	
	
	/* Modal to confirm upload */
	
	/* file upload */	
	
	myModalMessage = new bootstrap.Modal(document.getElementById('myModalMessage'), {
		backdrop: 'static',  // do not close modal if user click outside
		keyboard: false
	}) 
	
	
	// Make a redirect when the modal closes (reload the page to update content)
	var myModalM = document.getElementById('myModalMessage');
	myModalM.addEventListener('hidden.bs.modal', function(event) {
		if($('#file-upload-form #id').val() < 0)
			$(location).attr('href', 'files')  // redirect to a page
		else
			$(location).attr('href', 'files?id=${id}&date=${date}')  // redirect to a page
	});
	
	var myModalU = document.getElementById('myModalUpload');
	myModalU.addEventListener('hidden.bs.modal', function(event) {
		// Clean up fields when dialog is dismissed
		$('#file-upload-form #desc').val("");
		$('#inputGroupFile').val("");
		$('#modal-upload-message').html("");
	});
	

	// upload file ajax request
	uploadForm = document.getElementById("file-upload-form");	// upload file form
	
	$(document).on("click", "#inputGroupFileAddon", function () {
		event.preventDefault();
		// Options:
		// uploadForm.submit();  // 1) simply submit the form
		
		// Check if form is ok, otherwise return a toast message
		if($('#inputGroupFile').val()=="" || $('#file-upload-form #date').val()=="" || $('#file-upload-form #id').val()=="" || $('#file-upload-form #token').val()=="" || $('#file-upload-form #desc').val()=="") {
			//$('.toast-body').html("Inserisci tutti i campi!");
			//$('.toast').toast('show');
			$('#modal-upload-message').html("Inserisci tutti i campi!");
			return;
		}
		
		// 2) Ajax request
		var data = new FormData(uploadForm);  // get form data
		 
						$.ajax({  // send ajax request to FileUpload servlet
							type : "POST",
							enctype : 'multipart/form-data',
							// url : '<%= getServletContext().getContextPath() %>/upload',
							url : 'upload',
							data : data,
							processData : false,
							contentType : false,
							cache : false,
							success : function(responseText) {
								// $('#ajaxGetUserServletResponse').text(responseText);
								$('#myModalMessage .modal-body #modal-message').html(responseText);
								$('#myModalUpload').modal('hide');  // hide upload modal (dismiss() function does not work!)
								myModalMessage.show();								
								
							}
						});
		

	});

	
	/*
	// $('#myModal').modal({backdrop: 'static', keyboard: false})
	myModal = new bootstrap.Modal(document.getElementById('myModal'), {
			backdrop : 'static', // do not close modal if user click outside
			keyboard : false
	})
<%= commentModal %>myModal.show();  // comment this line of code depending on commentModal value
	
	myForm = document.getElementById("modal-form-id");  // normal auth form
	
	
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
      <form class="d-flex" >        
        <button id="newfile" class="btn btn-outline-success" type="submit">Nuovo</button>
      </form>
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


<!-- div class="container-fluid">

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-6">
	<h3></h3>
  </div>
  <div class="mb-3 col-3">
  </div>
</div>


</div-->



<!-- Form -->
<div class="container-fluid">

<!-- form end -->
<!-- div class="row d-flex justify-content-center">
  
  <div class="mb-3 col-9">
  
  	<div class="pt-5 mb-3 col-9">
		<h3>Inserisci un nuovo file</h3>
  	</div>
  
  	<form id="file-upload-form" action="FileUpload" method="post" enctype="multipart/form-data" >

	<div class="mb-3 col-9">
		<input hidden type="text" class="form-control" name="id" id="id" required readonly="readonly" value="${id}">
	</div>
	<div class="mb-3 col-9">
		<input hidden type="text" class="form-control" name="uid" id="uid" required readonly="readonly" value="<%= getUser(request).getId() %>">
	</div>
	<div class="mb-3 col-9">
    	<label for="table" class="form-label">descrizione</label>
    	<input type="text" class="form-control" name="desc" id="desc" required>
  	</div>
  	
		
		<div class="form-group date mb-3 col-3" data-provide="datepicker"	data-date-language="it" data-date-format="dd/mm/yyyy">
    		<label for="date" class="form-label">Data</label>
			<input type="text" id="date" name="date" class="form-control" required placeholder="dd/mm/yyyy" readonly="readonly" value="${date}">
			<div class="input-group-addon">
			<span class="glyphicon glyphicon-th"></span>
			</div>
  		</div>
	
	<div class="mb-3 col-9">	
		<input hidden type="text" class="form-control" name="token" id="token" required readonly="readonly" value="<%= TokenUtils.createToken(getUser(request).getEmail(), ""+(Integer) request.getAttribute("id"), (String) request.getAttribute("key")) %>">
	</div>	  	
  	<div class="mb-3 col-9">
  	<div class="input-group">
  		<input type="file" name="file" class="form-control" id="inputGroupFile" required aria-describedby="inputGroupFileAddon" aria-label="Upload" >
  		<button class="btn btn-outline-secondary" type="button" id="inputGroupFileAddon">Salva</button>
	</div>
	</div>
  	<div class="mb-3 col-9">
  		<h3></h3>
	</div>
  	<div class="mb-3 col-9">
  		<button hidden type="submit" class="btn btn-primary">Aggiungi</button>
	</div>

</form>
  
  </div>
  
</div --> <!-- form end -->
<div class="row d-flex justify-content-center">
  
  <div class="mb-3 col-9">
	<h2><%
	if(((Integer) request.getAttribute("id")).intValue() < 0)
		out.print(AppConfig.titleFiles);
	else
		out.print(AppConfig.titleAllegati); %></h2>
	
	<table class="table table-striped table-hover table-responsive">
 	<thead>
    <tr>
      <th scope="col">Data</th>
      <th scope="col">Nome file</th>
      <th scope="col">Dimensione (byte) </th>
      <th scope="col">Descrizione</th>
      <th scope="col">ID</th>
      <th scope="col" colspan="2"></th>
    </tr>
  	</thead>
  <tbody>
    
    
    <%
    /* lista dei file allegati con pulsante download e elimina:
    	per il download vengono passati:
    		- id del file da cancellare
    		- uid (user id) dell'utente, necessario per recuperare la chiave privata e verificare il token
    		- token crittato con la chiave privata utente, contenente:
    			- email utente
    			- nome file da scaricare (verrà confrontato con l'id per verificarne la corrispondenza)
    			
    */
    ArrayList<UploadItem> list = (ArrayList<UploadItem>) request.getAttribute("list");
    if (list != null) {
		for (UploadItem t : list) {  // send parameter id and table to url deletesimple
			// <a class=\'btn btn-primary\' data-id=\'"+t.getId()+"\' href=\'simpledelete?id="+t.getId()+"&table="+request.getAttribute("table")+"\' role=\'button\'>Elimina</a>
			// <input id=\'btnModalConfirm\' class=\'btn btn-primary btnModal\' type=\'button\' data-id=\'"+t.getId()+"\' value=\'Elimina\'>
			out.println("<th scope=\"row\">"+DateConverter.formatDate(t.getD(), DateConverter.itFormat)+"</th><td>"+t.getName()+"</td><td>"+t.getSize()+"</td><td>"+t.getDescription()+"<td scope=\"row\">"+t.getId()+"</td><td><input id=\'deleteRecord\' class=\'btn btn-primary btnModal\' type=\'button\' data-id=\'"+t.getId()+"\' value=\'Elimina\'></td><td><form method=\'post\' action=\'"/* +getServletContext().getContextPath()+"/" */+"download\'><input hidden type=\'text\' id=\'id\' name=\'id\' value=\'"+t.getId()+"\'/><input hidden type=\'text\' id=\'uid\' name=\'uid\' value=\'"+getUser(request).getId()+"\'/><input hidden type=\'text\' id=\'token\' name=\'token\' value=\'"+TokenUtils.createToken(getUser(request).getEmail(), t.getName(), (String) request.getAttribute("key"))+"\'/><button type=\'submit\' class=\'btn btn-primary btnModal\' id=\'submit-download\'>Scarica</button></form></td></tr>");
			
			// old download
			// <td><a class=\'btn btn-primary\' href=\'"+getServletContext().getContextPath()+"/download?id="+t.getId()+"&uid="+getUser(request).getId()+"&token="+TokenUtils.createToken(getUser(request).getEmail(), t.getName(), (String) request.getAttribute("key"))+"\' target=\'_blank\' role=\'button\'>Scarica</a></td>
			//System.out.println("file name: \'"+t.getName()+"\'");
			//System.out.println("token: \'"+TokenUtils.createToken(getUser(request).getEmail(), t.getName(), (String) request.getAttribute("key"))+"\'");
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
        <p id="modal-message">Sei sicuro di voler eliminare in modo definitivo il file con id <span id='id-delete-span'></span>?</p>
        <form id="delete-record-form" method="post" action="files">
          <input hidden type="text" name="id-delete" id="id-delete" value=""/>
          <input hidden type="text" name="id" id="id" value="${id}"/> 
          <input hidden type="text" name="date" id="date" value="${date}"/>         
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


<!-- Modal for messages -->
	<!-- data-bs-backdrop="static" data-bs-keyboard="false" on the button means the modal do not close if the background is clicked -->
<div id="myModalMessage" class="modal" tabindex="-1" >
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Message</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p id="modal-message"></p>
                
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<!-- File Upload Modal -->
<div id="myModalUpload" class="modal" tabindex="-1" >
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Inserisci un nuovo file</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        
          	<form id="file-upload-form" action="FileUpload" method="post" enctype="multipart/form-data" >

						<div class="mb-3 col-9">
							<input hidden type="text" class="form-control" name="id" id="id"
								readonly="readonly" value="${id}">
						</div>
						<div class="mb-3 col-9">
							<input hidden type="text" class="form-control" name="uid"
								id="uid" required readonly="readonly"
								value="<%=getUser(request).getId()%>">
						</div>
						<div class="mb-3 col-9">
							<label for="table" class="form-label">descrizione</label> <input
								type="text" class="form-control" name="desc" id="desc" required>
						</div>

						<!--div class="mb-3 col-9"-->
						<!-- input type="text" class="form-control" name="date" id="date" required readonly="readonly" value="${date}" -->

						<div class="form-group date mb-3 col-3" data-provide="datepicker"
							data-date-language="it" data-date-format="dd/mm/yyyy">
							<label for="date" class="form-label">Data</label> <input
								type="text" id="date" name="date" class="form-control" required
								placeholder="dd/mm/yyyy" readonly="readonly" value="${date}">
							<div class="input-group-addon">
								<span class="glyphicon glyphicon-th"></span>
							</div>
						</div>
						<!--/div-->
						<div class="mb-3 col-9">
							<input hidden type="text" class="form-control" name="token"
								id="token" required readonly="readonly"
								value="<%=TokenUtils.createToken(getUser(request).getEmail(), "" + (Integer) request.getAttribute("id"),
					(String) request.getAttribute("key"))%>">
						</div>
						<div class="mb-3 col-9">
							<div class="input-group">
								<input type="file" name="file" class="form-control"
									id="inputGroupFile" required
									aria-describedby="inputGroupFileAddon" aria-label="Upload">
								<button class="btn btn-outline-secondary" type="button"
									id="inputGroupFileAddon">Salva</button>
							</div>
						</div>
						<div class="mb-3 col-9">
							<h3></h3>
						</div>
						<div class="mb-3 col-9">
							<button hidden type="submit" class="btn btn-primary">Aggiungi</button>
						</div>

					</form>
					<div class="text-danger fs-4" id="modal-upload-message"></div>  
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
        
      </div>
    </div>
  </div>
</div>



<!-- Search Modal -->
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