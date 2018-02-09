<g:render template="/comercial/navBar"/>
<script src='https://www.google.com/recaptcha/api.js'></script>
<div class="row login-bg" >
    <br>
    <div class="container" style="margin-top:50px;">

        <g:if test='${emailSent}'>
            <br />
             <div class="col-xs-8 col-xs-offset-2 col-sm-6 col-sm-offset-3 col-md-6 col-md-offset-3 alert alert-success" style="display: block; margin-bottom:50px;">
                <g:message code='register.email.sent' args="${[username]}"/>
            </div>
        </g:if>
        <g:else>

            <g:if test="${command.hasErrors() || (flash.message!=null)}">
                 <div class="row" id="error-alert ">
                    <div class="col-xs-8 col-xs-offset-2 col-sm-6 col-sm-offset-3 col-md-6 col-md-offset-3 alert alert-danger" style="display: block">
                        <g:hasErrors bean="${command}">
                           
                                    <g:eachError bean="${command}">
                                        <p style="color: red;">
                                            <li>
                                                <g:message error="${it}" />
                                            </li>
                                        </p>
                                    </g:eachError>
                                    
                        </g:hasErrors>
                        <g:if test="${flash.message}">
                            <p style="color: red;">
                                <li>
                                    <g:message code="${flash.message}" />
                                </li>
                            </p>
                        </g:if>
                    </div>
                </div>
            </g:if>
            <div class="form-wrapper">
            <g:form id ="registerForm" name="registerForm" class="form-signin wow fadeInUp"  url="[action:'register',controller:'register']">
                    <h2 class="form-signin-heading"><g:message code="register.form.registerNow"/></h2>
                    <div class="login-wrap">
                        <p><g:message code="register.form.personalDetails"/></p>
                        <input type="text" class="form-control" id="fullname" name='fullname' placeholder="* <g:message code="register.form.fullname"/>" value="${command.fullname}" autofocus="" maxLength='100'>
                        <div class="form-inline">
                            <input type="text" class="form-control" id="phone" name='phone' placeholder="<g:message code="register.form.phone"/>" autofocus="" value="${command.phone}" maxLength='20'>
                            <input type="text"  class="form-control" id="extension" name='extension' placeholder="ext." autofocus="" value="${command.extension}" maxLength='10'>
                        </div>
                        <input type="text" class="form-control" id="mobile" name='mobile' placeholder="* <g:message code="register.form.mobile"/>" autofocus="" value="${command.mobile}" maxLength='12'>
                        <input type="text" class="form-control" name='address' placeholder="* <g:message code="register.form.address"/>" autofocus="" value="${command.address}" maxLength='100' >
                        <input type="text" class="form-control" name='organization' placeholder="* <g:message code="register.form.organization"/>" autofocus="" value="${command.organization}" maxLength='100' >

                        <p><g:message code="register.form.accountDetails"/></p>
                        <input type="text" class="form-control" name='username' placeholder="* <g:message code="register.form.username"/>" autofocus="" value="${command.username}" maxLength='100' >
                        <input type="password" class="form-control" name='password' placeholder="* <g:message code="register.form.password"/>" maxLength='64'>
                        <input type="password" class="form-control" name='password2' placeholder="* <g:message code="register.form.password2"/>" maxLength='64'>
                        
                        <div style="font-size:11px; text-align:right;">* Campos Obligatorios</div>

                        <label class="checkbox" style="color:#797979;"> <g:message code="register.form.termsMessage"/></label>
                        <div>
                            <label class="checkbox" class="form-control" style="padding-left:20px; color:#797979;">
                                <input id="offersChk" value="false" name="offersChk"  type="checkbox" checked  style="opacity:0.5; "/> <g:message code="register.form.offersMessage"/>
                            </label>
                        </div>                      
                        
                        <br>
                        <div class="g-recaptcha" data-sitekey="6LfsGCETAAAAAG3ewnkn8pdBO93ANRfmhbmX1O06"></div>
                        <br>
                        <br>

                        <button id="btnRegister" class="btn btn-lg btn-login btn-block btn-register" type="button">
                        <g:message code="register.form.registerNow"/></button>

                        <div class="registration">
                            <g:message code="register.form.alreadyRegistered"/> <g:link controller="login" action="auth"><g:message code="register.form.login"/></g:link>                            
                        </div>

                    </div>

               </g:form>
            </div>
        </g:else>
    </div>

</div>



<!-- Modal de Terminos y condiciones -->

<div id="termsModal" class="modal fade " role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header " style="background-color:#0080c0; color:white">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
                    <g:message code="register.form.termsTitle" />
                </h4>
            </div>
            <div class="modal-body">
                <p><g:message code="register.form.termsBody"/> </p>

            </div>

        </div>

    </div>
</div>
<!-- Fin del modal de informacion de la cuenta demo -->

<script>

/*$("#registerForm").validate({
        rules: {
            phone: {digits: true, minlength: 7, maxlength: 20},
            mobile: {digits: true, minlength: 10, maxlength: 12},
            ext: {digits: true, minlength: 1, maxlength: 10}
        }
    });*/

$('.btn-register').click(function(event){
    event.preventDefault()
    $(this).html("<i class='fa fa-spinner fa-spin'></i>")
    $(this).prop('disabled', true)
    $('#registerForm').submit()
})

function showTermsModal() {
    $('#termsModal').modal('show')
    return false;
}

$(document).ready(function(){
    $("#fullname").keyup(function(event){
        var inputValue = event.which;       
        if(!validateAlphabetic(inputValue) && inputValue != 8) { 
            event.preventDefault();            
        }
    });
    $("#phone").keypress(function(event){
        var inputValue = event.which;       
        if(validateSpecialCharacters(inputValue)) { 
            event.preventDefault();            
        }
    });
    $("#mobile").keypress(function(event){
        var inputValue = event.which;       
        if(validateSpecialCharacters(inputValue)) {
            event.preventDefault();            
        }
    });
});

function validateAlphabetic(inputValue){
     // Permite letras y espacios en blanco, tildes de vocales y letra Ñ 
    if(!(inputValue >= 65 && inputValue <= 90) && !(inputValue >= 97 && inputValue <= 122) && (inputValue != 32 && inputValue != 0 && inputValue != 225 && inputValue != 233 && inputValue != 237 && inputValue != 243 && inputValue != 250 && inputValue != 241 && inputValue != 209 && inputValue != 193 && inputValue != 201 && inputValue != 205 && inputValue != 211 && inputValue != 218)) { 
        return false
    }
    return true
}

function validateSpecialCharacters(inputValue){
    //Validación de Caracteres Especiales
    if(!(inputValue >= 33 && inputValue <= 47) && !(inputValue >= 58 && inputValue <= 64) && !(inputValue >= 91 && inputValue <= 96) && !(inputValue >= 123 && inputValue <= 191)) { 
        return false
    }
    return true
}

</script>
<g:render template="/comercial/footer"/>