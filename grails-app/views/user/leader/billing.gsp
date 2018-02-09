<g:render template="leader/navBar"/>
	<asset:javascript src="chart.js"/>
<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper">
		<!-- Main content -->
		<section class="content"  id="principalSection">
			<!-- Small boxes (Stat box) -->
			<g:render template="leader/boxes-0"/>
			<!-- /.row -->
			<!-- Main row -->
			<div class="row">
				<!-- Left col -->
				<section class="col-lg-6 connectedSortable">
					<div class="box box-primary">
						<div  class="have-tooltip box-header"  title="${message(code:'tooltip.myUsers.title')}" data-content="${message(code:'tooltip.myUsers.text')}" data-placement="top" style="cursor:pointer">
							<i class="fa fa-credit-card"  > </i>
							<h3 class="box-title">
								<g:message code="text.billingInfo" />
							</h3>
						</div>
						<div class="row box-body">
							<div class="col-lg-4 col-md-4 billing-title">
								<g:message code='text.memberAndBilling'/>
								<button class="btn btn-default" style="margin-top:10px" data-toggle="modal" data-target="#confirmModal"><g:message code='text.cancelSubscription'/></button>
							</div>
							<div class="col-lg-8 col-md-8">
								<div class="col-lg-6 col-md-6">
									<b><sec:username/></b>
									<g:message code='text.password'/>: *******
								</div>
								<div class="col-lg-6 col-md-6">
									<a href="#" ><g:message code="text.changeEmailAndPass"/></a>
								</div>
							</div>
							<div class="col-lg-8 col-md-8 col-lg-offset-4 col-md-offset-4" style="margin-top: -40px">
								<hr>
								<div class="col-lg-6 col-md-6">
									<b>Visa: **** **** **** 0123</b>
								</div>
								<div class="col-lg-6 col-md-6">
									<a href="#"><g:message code="text.changeBillingMethod"/></a>
								</div>
							</div>
							<div class="col-lg-12 col-md-12">
							<hr/>
								<div class="col-lg-4 col-md-4 billing-title" >
									<g:message code='text.plan'/>
								</div>
								<div class="col-lg-8 col-md-8">
									<div class="col-lg-6 col-md-6">
										<b>
											<sec:ifAllGranted roles='ROLE_GOLD'>
												<asset:image src="gold.png" height='20px' style="margin-top:-1px"/>   <g:message code='text.gold'/>
											</sec:ifAllGranted>
											<sec:ifAllGranted roles='ROLE_PLATINUM'>
												<asset:image src="platinum.png" height='20px' style="margin-top:-1px"/>   <g:message code='text.platinum' />
											</sec:ifAllGranted>
										</b>
									</div>
									<div class="col-lg-6 col-md-6">
										<a href="#" ><g:message code="text.changePlan"/></a>
									</div>
								</div>
							</div>
						</div>
						<hr/>
					</div>
				</section>
				<!-- /.Left col -->

				<!-- right col -->
				<section class="col-lg-6 connectedSortable">

				</section>
				<!-- right col -->
			</div>
			<!-- /.row (main row) -->

		</section>
		<!-- /.content -->
	<!-- /.content-wrapper -->
	</div>
	<g:render template="leader/footer"/>


	<!-- Modal de confirmación de cancelación de la subscripción -->
	<div id="confirmModal" class="modal fade " role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header alert-warning">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.text.confirmTitle" />
					</h4>
				</div>
				<div class="modal-body">
					<p>
						<g:message code="text.confirmSubscriptionCancel" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="cancelSubscription()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->


<script type="text/javascript">
	$(window).load(function(){
		setInterval(getNotifications, 8000);
	})
</script>
</body>
</html>