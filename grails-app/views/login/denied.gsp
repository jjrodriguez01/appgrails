<g:render  template="/comercial/navBar"/>

    <div class="gray-bg">
    <div class="fof">
            <!-- 403 error -->
        <div class="container  error-inner wow flipInX" style="padding:5%;">
            <asset:image src="miscellaneous/403.png"/>
            <h1><g:message code="general.error.403"/></h1>
            <p class="text-center"><g:message code="general.error.403.message"/></p>
            <a class="btn btn-info" href="${createLink(controller:'redirect', action:'principal')}"><g:message code="general.error.goBack"/></a>
        </div>
        <!-- /403 error -->
        </div>
    </div>
<g:render  template="/comercial/footer"/>