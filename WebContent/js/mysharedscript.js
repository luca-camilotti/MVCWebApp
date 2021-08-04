
$(document).ready(function(){
	if($('.toast .toast-body').html().trim()!="")
		$('.toast').toast('show');  // show the toast 
})