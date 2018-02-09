<g:if test="${isAdmin}">
	<sec:ifAnyGranted roles="ROLE_USER_LEADER">
		<g:render template="leader/index"/>
	</sec:ifAnyGranted>
</g:if>
<g:else>
	<sec:ifAnyGranted roles="ROLE_USER">
		<g:render template="user/index"/>
	</sec:ifAnyGranted>
</g:else>

