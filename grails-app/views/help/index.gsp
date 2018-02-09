<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>

<div class="content-wrapper">
	<!-- Main content -->
	<section class="content"  id="principalSection">
		<div class="col-md-4 col-md-offset-8" style="">
			  <div class="input-group">
			      <input type="text" class="form-control" placeholder="Search for...">
			      <span class="input-group-btn">
			        <button class="btn btn-default" type="button">Go!</button>
			      </span>
			    </div><!-- /input-group -->
		</div>

		<g:each in="${tutoriales}" status="i" var="tutorial">
			<g:if test="${i%2==0}">
				<g:if test="${language=='es'}">
					<div class="container" style="margin-top:50px">
						<div class="row">
							<div class="col-md-6">
								<h3>${tutorial.title}</h3>
								<p>
									${tutorial.html} 
								</p>
							</div>
							<div class="col-md-6">
								<div class="flex-video widescreen hidden-xs" style="margin: 0 auto;">
			 						<iframe src="${tutorial.url}" allowfullscreen="" frameborder="0" height="281" width="500"></iframe>
			  					</div>
							</div>
						</div>
					</div>
				</g:if>
				<g:else>
					<div class="container" style="margin-top:50px">
						<div class="row">
							<div class="col-md-6">
								<h3>${tutorial.englishTitle}</h3>
								<p>
									${tutorial.englishHtml} 
								</p>
							</div>
							<div class="col-md-6">
								<div class="flex-video widescreen hidden-xs" style="margin: 0 auto;">
			 						<iframe src="${tutorial.url}" allowfullscreen="" frameborder="0" height="281" width="500"></iframe>
			  					</div>
							</div>
						</div>
					</div>
				</g:else>
				<br/><br/>
			</g:if>
			<g:else>
				<div class="container bg-gray">
					<g:if test="${language=='es'}">
						<div class="row">
							<div class="col-md-6">
								<h3>${tutorial.title}</h3>
								<p>
									${tutorial.html} 
								</p>
							</div>
							<div class="col-md-6">
								<div class="flex-video widescreen hidden-xs" style="margin: 0 auto;">
			 						<iframe src="${tutorial.url}" allowfullscreen="" frameborder="0" height="281" width="500"></iframe>
			  					</div>
							</div>
						</div>
					</g:if>
					<g:else>
						<div class="row">
							<div class="col-md-6">
								<h3>${tutorial.englishTitle}</h3>
								<p>
									${tutorial.englishHtml} 
								</p>
							</div>
							<div class="col-md-6">
								<div class="flex-video widescreen hidden-xs" style="margin: 0 auto;">
			 						<iframe src="${tutorial.url}" allowfullscreen="" frameborder="0" height="281" width="500"></iframe>
			  					</div>
							</div>
						</div>

					</g:else>
				</div>
			</g:else>

		</g:each>

		




	</section>
	<!-- /.content -->
</div>
<!-- ./wrapper -->

<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/footer"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/footer"/>
</sec:ifNotGranted>


<asset:javascript src="zoom.js"/>

<script>

	$(window).load( function(){
		notificationsInterval = setInterval(getNotifications, 8000);
		setZoomImages()
	})



</script>
