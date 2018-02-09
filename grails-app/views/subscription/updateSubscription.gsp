<sec:ifAllGranted roles="ROLE_USER_LEADER">
    <g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>

<sec:ifNotGranted  roles="ROLE_USER_LEADER">
    <g:render template="/user/user/navBar"/>
</sec:ifNotGranted>


<asset:javascript src="jquery.validate_es.js" />
<asset:javascript src="validateForm.js"/>
<script src="http://cdn.jsdelivr.net/jquery.validation/1.15.0/additional-methods.min.js"></script>


<div class="content-wrapper">
<section class="content"  id="principalSection">
    <div class="" id="" style="padding-left:15px; margin-right:10px">
        <label>
            <g:message code="license.updateTitle"/>: 
        </label>

        <br/>    
        <br/>

        <g:form id="formularioPlan" url="[action:'updateCC', controller:'subscription']">

        <label for="userName">
            <g:message code="license.userName"/>
        </label>
        <input type="text" id="userName" placeholder="" class="form-control" value="${user}" disabled="disabled" />
        <br/>

        <label for="nameCC">
            <g:message code="license.nameCC"/>
        </label>
        <input type="text" id="nameCC" name="nameCC" placeholder="" class="form-control" value="${fullname}" disabled="disabled" />
        <br/>

        <label for="plan">
            <g:message code="license.selectedPlan"/>
        </label>
        <select id="planSelect" class="form-control" disabled="disabled" value="${actualPlan.idPlan}">     
            <g:each in="${planesSys}" var="curPlan">
                <option value="${curPlan.codigo_plan}">${curPlan.nombre}</option>
            </g:each>
        </select>

        <br/>

        <label for="typeCC" class="requerido, label_licencia"><g:message code="license.typeCC" /> <span class="requerido"></span> </label>
            <select id="typeCC" name="typeCC" class="form-control">
                <option value="VISA">Visa</option>
                <option value="MASTERCARD">MasterCard</option>
                <option value="AMEX">AmericanExpress</option>
                <option value="DINERS">DinerClub</option>
            </select>

        <br/>                                      

        <label for="numberCC"><g:message code="license.number"/></label>
        <input type="text" id="numberCC" name="numberCC" placeholder="***************" class="form-control cc-card-number"/>
        <br/>

        <label for="dateCC" class="requerido, label_licencia"><g:message code="license.dateCC" /> <span class="requerido"></span> </label>

        <div class="form-group" id="dateCC">
                      
            <div style="float: left;">
                <select id="ccMonth" name="ccMonth">
                    <option value="01"><g:message code="license.January" /></option>
                    <option value="02"><g:message code="license.February" /></option>
                    <option value="03"><g:message code="license.March" /></option>
                    <option value="04"><g:message code="license.April" /></option>
                    <option value="05"><g:message code="license.May" /></option>
                    <option value="06"><g:message code="license.June" /></option>
                    <option value="07"><g:message code="license.July" /></option>
                    <option value="08"><g:message code="license.August" /></option>
                    <option value="09"><g:message code="license.September" /></option>
                    <option value="10"><g:message code="license.October" /></option>
                    <option value="11"><g:message code="license.November" /></option>
                    <option value="12"><g:message code="license.December" /></option>
                </select>
            </div>  
            <div style="float: left; margin-left: 3%">
                <select id="ccYear" name="ccYear">
                    <option value="2016">2016</option>
                    <option value="2017">2017</option>
                    <option value="2018">2018</option>
                    <option value="2019">2019</option>
                    <option value="2020">2020</option>
                </select>
            </div>                              
        </div>

        <br/>

        <label> <g:message code="license.status"/></label>

            <input type='text' class="form-control" id='planStatus' value="${accountState}" disabled="disabled" />
  
        <br/>
        <br/>

        <input name="Submit"  class="submit" type="submit" value="<g:message code="license.updateTitle"/>">
        <br/>
        <br/>

        <input name="customerId"  id="customerId" value="${actualPlan.idClient}" type="hidden" >
        <input name="subscriptionID"  id="subscriptionID" value="${actualPlan.idSub}" type="hidden" >
        <input name="documentCC"  id="documentCC" value="${actualPlan.documentCC}" type="hidden" >



        </g:form>

    </div>

    </section>
    </div>

    <script type="text/javascript">

        $("#formularioPlan").validate({
            rules: {
                numberCC: {required: true, creditcard: true},
                nameCC: {required: true, minlength: 4, maxlength: 30}
            }
        });

        $(document).ready(function() {

            $("#planSelect").val("${actualPlan.idPlan}");
            $("#typeCC").val("${actualPlan.typeCC}");

        });


    </script>

    <asset:javascript src="jquery-2.2.0.min.js"/>
    <asset:javascript src="bootstrap.js"/>

    <sec:ifAllGranted roles="ROLE_USER_LEADER">
    <g:render template="/user/leader/footer"/>
    </sec:ifAllGranted>
    <sec:ifNotGranted  roles="ROLE_USER_LEADER">
        <g:render template="/user/user/footer"/>
    </sec:ifNotGranted>

</body>
</html>