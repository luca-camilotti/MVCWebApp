/*Nina Kong*/

function showPassword() {
	var target = $("#showHide");
	target.click(function() {
		if ($("#password").attr("type")=="password") {
			$("#password").attr("type", "text");
		} else {
			$("#password").attr("type", "password");
		}
		if ($("#password2").attr("type")=="password") {
			$("#password2").attr("type", "text");
		} else {
			$("#password2").attr("type", "password");
		}
	})
}

$(document).ready(function () {
	"use strict";
	showPassword();
});

function checkPasswordStrength() {
	var number = /([0-9])/;
	var alphabets = /([a-zA-Z])/;
	var special_characters = /([~,!,@,#,$,%,^,&,*,-,_,+,=,?,>,<])/;

	if($('#password').val().length<8) {
		$('#password-strength-status').removeClass();
		$('#password-strength-status').addClass('weak-password');
		$('#password-strength-status').html("La password deve avere una lunghezza di almeno 8 caratteri.");
		passwordOk = false;
	} else {  	
    	if($('#password').val().match(number) && $('#password').val().match(alphabets) && $('#password').val().match(special_characters)) {            
			$('#password-strength-status').removeClass();
			$('#password-strength-status').addClass('strong-password');
			$('#password-strength-status').html("Password OK");
			passwordOk = true;
    	} else {
			$('#password-strength-status').removeClass();
			$('#password-strength-status').addClass('medium-password');
			$('#password-strength-status').html("La password &egrave; debole: deve contenere almeno una lettera, una cifra e un carattere speciale (@, #, $, &, %, ..)");
			passwordOk = false;
    	} 
	}
}	

