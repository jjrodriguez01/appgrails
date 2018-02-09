<g:render  template="/comercial/navBar"/>

    <div class="gray-bg">
    <div class="fof">
            <!-- 404 error -->
        <div class="container  error-inner wow flipInX" style="padding:5%;">
            <asset:image src="miscellaneous/404.png"/>
            <h1>404</h1>
            <p class="text-center"><g:message code="general.error.404"/></p>
            <a class="btn btn-info" href="${createLink(controller:'redirect', action:'principal')}"><g:message code="general.error.goBack"/></a>
        </div>
        <!-- /404 error -->
        </div>
    </div>
<g:render  template="/comercial/footer"/>