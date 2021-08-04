<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.util.ArrayList"  
    import="luke.models.classes.UploadItem"   
    import="luke.date.converter.DateConverter" 
    import="luke.models.classes.User"  
    import="luke.app.controller.AppConfig" 
%>

<%! private String commentModal = "//";
	private String context = null;	 
%>
<% context = getServletContext().getContextPath(); %>
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
<!-- Show Hide Password Plugin -->
<!-- https://www.jqueryscript.net/form/jQuery-Plugin-To-Show-Hidden-Password-In-Password-Field-inputShowPwd.html -->
<script src='<%= context+"/" %>js/showhide.js' type='text/javascript'></script>

<script type="text/javascript">




/* jQuery password strength checker:
	
 * https://phppot.com/jquery/jquery-password-strength-checker/
 
   https://www.c-sharpcorner.com/Blogs/how-to-check-password-strength-in-jquery
 */
var myModal;  // modal with a form submit
var myModalMessage;  // modal with a message
var myForm; 

var passwordOk = false;

$(document).ready(function(){
	if($('.toast .toast-body').html().trim()!="")
		$('.toast').toast('show');  // show the toast 
	
	
	myModalMessage = new bootstrap.Modal(document.getElementById('myModalMessage'), {
		backdrop: 'static',  // do not close modal if user click outside
		keyboard: false
	})
		
		
	/* Reset password */
	
		
	
	
	var passwordForm = document.getElementById("password-form");	// password form
	
	$(document).on("click", "#submit-password", function(event) {
		event.preventDefault();
		// Options:
		// uploadForm.submit();  // 1) simply submit the form
		
		if($('#id').val()=="" || $('#token').val()=="") {
			$('.toast-body').html("Pagina non valida! L'url è incompleto!");
			$('.toast').toast('show');
			return;
		}
		
		
		// Check if password field is ok, otherwise return a toast message
		if($('#password').val()=="") {
			$('.toast-body').html("Inserisci una nuova password valida!");
			$('.toast').toast('show');
			return;
		}
		else if($('#password').val() != $('#password2').val()) {
			$('.toast-body').html("Le due password non corrispondono!");
			$('.toast').toast('show');
			return;
		}
		else if(!passwordOk) {
			$('.toast-body').html("La password inserita è troppo debole!");
			$('.toast').toast('show');
			return;
		}
		
		passwordForm.submit();
		
	});
	
	/* Reset password - end */
		
	
	
	/*
	myModalMessage.addEventListener('hidden.bs.modal', function (event) {
		$(location).attr('href', 'Login')  // redirect to a page
	}) */
	/*
	myModalMessage.bind('hidden.bs.modal', function (event) {
		$(location).attr('href', 'Login')  // redirect to a page
	}) */
	
	/*
	// make a redirect when the modal closes
	var myModalM = document.getElementById('myModalMessage');
	myModalM.addEventListener('hidden.bs.modal', function(event) {
		$(location).attr('href', 'dashboard')  // redirect to a page
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

// COMMENT OUT FROM HERE

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
<nav class="navbar navbar-expand-lg fixed-top navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="#"></a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="<%= getServletContext().getContextPath() %>/App"><%= AppConfig.labelLogin %></a>
        </li>
        <!--li class="nav-item">
          <a class="nav-link" href="#">Link</a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Dropdown
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="#">Action</a></li>
            <li><a class="dropdown-item" href="#">Another action</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="#">Something else here</a></li>
          </ul>
        </li>
        <li class="nav-item">
          <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
        </li-->
      </ul>      
    </div>
  </div>
</nav>

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


<!-- Bootstrap Form -->
<div class="container-fluid">

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-sm-10 col-md-8 col-lg-4">
	<h2>Reimposta la password</h2>
<!-- div class="row align-items-center"-->
  </div>
</div>


<style>
#frmCheckPassword {border-top:#F0F0F0 2px solid;background:#FAF8F8;padding:10px;}
.demoInputBox{padding:7px; border:#F0F0F0 1px solid; border-radius:4px;}
#password-strength-status {padding: 5px 10px;color: #FFFFFF; border-radius:4px;margin-top:5px;}
.medium-password{background-color: #E48B00;border:#BBB418 1px solid;}
.weak-password{background-color: #FF6600;border:#AA4502 1px solid;}
.strong-password{background-color: #12CC1A;border:#0FA015 1px solid;}
</style>


<form id="password-form" method="post" action="<%= context+"/" %>App/setpwd">

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-sm-10 col-md-8 col-lg-4" >
     <input type="text" class="form-control" name="id" id="id" required value="${id}" hidden>    
  </div>
 </div>

<div class="row d-flex justify-content-center">
  <div class="mb-3 col-sm-10 col-md-8 col-lg-4">
     <input type="text" class="form-control" name="token" id="token" required value="${token}" hidden>
    <div id="password-strength-status"></div>
  </div>
 </div>


<div class="row d-flex justify-content-center">
  <div class="mb-3 col-sm-10 col-md-8 col-lg-4" id="frmCheckPassword">
    <label for="password" class="form-label">Nuova Password</label>
    <input type="password" class="form-control demoInputBox" name="password" id="password" required onKeyUp="checkPasswordStrength()">
    <div id="password-strength-status"></div>
  </div>
 </div>
 <div class="row d-flex justify-content-center">
  <div class="mb-3 col-sm-10 col-md-8 col-lg-4">
    <label for="password" class="form-label">Ripeti Password</label>
    <input type="password" class="form-control" name="password2" id="password2" required>
  </div>
  </div>
  <div class="row d-flex justify-content-center">
  
  <div class="mb-3 col-sm-10 col-md-8 col-lg-4 offset-1 form-check">
    <input type="checkbox" class="form-check-input" name="exampleCheck" id="showHide">
    <label class="form-check-label" for="exampleCheck">Mostra password</label>
  </div>
  </div>
  
  <div class="row d-flex justify-content-center">
  <div class="mb-3  col-sm-10 col-md-8 col-lg-4">
  </div>
  </div>
  
  <div class="row d-flex justify-content-center">
  <div class="mb-3  col-sm-10 col-md-8 col-lg-4">
  <button id="submit-password" type="submit" class="btn btn-primary">Reimposta</button>
  </div>
  </div>
  
  </form>
  
</div>
 
  


<!--  div class="container">
<div class="row align-items-center">
<div class="col-6" -->

<%
	/*
	ArrayList<UploadItem> filelist = (ArrayList<UploadItem>) request.getAttribute("filelist");
	if (filelist != null) {
		for (UploadItem t : filelist) {
			out.println("<p>"+t.getId()+", "+DateConverter.formatDate(t.getD(), DateConverter.itFormat)+", "+t.getName() +", "+t.getDescription()+", "+t.getSize()+"<a class=\'btn btn-primary\' href=\'downloadFile?id="+t.getId()+"\' target=\'_blank\' role=\'button\'>Link</a></p>");
		}
	}
	*/
%>

<!-- Upload file form -->
<!--  form id="file-upload-form" action="FileUpload" method="post" enctype="multipart/form-data" -->

<!-- Button Modal -->
<!-- input id="btnModal1" class="btn btn-primary btnModal" type="button" data-id="15" value="Modal 15" -->
<!-- input id="btnModal2" class="btn btn-primary btnModal" type="button" data-id="28" value="Modal 28" -->

<!-- Bootstrap Datepicker -->
<!-- readonly="readonly" makes the field non editable, so user must choose from datapicker -->
				<!-- div class="form-group date" data-provide="datepicker"
					data-date-language="it" data-date-format="dd/mm/yyyy">
					<input type="text" id="datefile" name="date" class="form-control" required placeholder="dd/mm/yyyy" readonly="readonly" >
					<div class="input-group-addon">
						<span class="glyphicon glyphicon-th"></span>
					</div>
				</div -->

<!-- File upload -->
<!-- div class="input-group">
  <input type="file" name="file" class="form-control" id="inputGroupFile" required aria-describedby="inputGroupFileAddon" aria-label="Upload" >
  <button class="btn btn-outline-secondary" type="button" id="inputGroupFileAddon">Upload</button>
</div>
</form>

</div>
</div>
</div -->

	<!-- Modal with form -->
	<!-- data-bs-backdrop="static" data-bs-keyboard="false" on the button means the modal do not close if the background is clicked -->
<div id="myModal" class="modal" tabindex="-1" >
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p id="modal-message">Warning: delete </p>
        <form id="modal-form-id">
          <input type="text" name="myId" id="myId" value=""/>
          <!--button id="your-id">submit</button-->
		</form>  
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="modal-form-submit" onClick="myModal.hide()">Save changes</button>
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






</body>
</html>