




<g:render template="/comercial/navBar"></g:render>
<br>
<br>
<div class="gray-bg price-container" style='padding-bottom:60px'>
	<div class="container" >
		<div class="row mar-b-30">
			<!--price start-->
			<div class="text-center price-one">
				<h1 class="wow flipInX"><g:message code="pricing.chooseYourPlan" /></h1>
				<p class="wow fadeIn"><g:message code="pricing.description"/>
				</p>
			</div>
			<div class="col-lg-4 col-sm-4">
				<div class="pricing-table wow fadeInUp" style="padding-left:10px; padding-right:10px">
					<div class="pricing-head">
						<h1>Demo</h1>
						<h2>
							<span class="note">$</span>0
						</h2>
					</div>
					<ul class="list-unstyled">
						<!--  <li>Free setup</li>
						<li>Unlimited Bandwidth</li>
						<li>2% Transaction fee</li>
						<li>1Gb Storage</li>
						<li>Private URLs</li>
						<li>Enhanced Security</li>-->
					</ul>
					<div class="price-actions">
						<g:link  class="btn" action="registerForm" params="[plan: 0, token:'198asdboifb39basiduf9387biausdf']" ><g:message code="pricing.registerNow"/></g:link>
					</div>
				</div>
			</div>
			
			<div class="col-lg-4 col-sm-4">
				<div class="pricing-table wow fadeInUp" style="padding-left:10px; padding-right:10px">
					<div class="pricing-head">
						<h1>Gold</h1>
						<h2>
							<span class="note">$</span>49 
						</h2>
					</div>
					<ul class="list-unstyled">
						<!--  <li>Free setup</li>
						<li>Unlimited Bandwidth</li>
						<li>0% Transaction fee</li>
						<li>10Gb Storage</li>
						<li>Private URLs</li>
						<li>Enhanced Security</li>-->
					</ul>
					<div class="price-actions">
						<g:link method="post" class="btn" action="registerForm"  params="[plan: 1, token:'8997wjihasdiuoqawhasd89whuyoijdfg']"><g:message code="pricing.registerNow"/></g:link>
					</div>
				</div>
			</div>
			<div class="col-lg-4 col-sm-4">
				<div class="pricing-table wow fadeInUp" style="padding-left:10px; padding-right:10px">
					<div class="pricing-head">
						<h1>Platinum</h1>
						<h2>
							<span class="note">$</span>69 
						</h2>
					</div>
					<ul class="list-unstyled">
						<!--  <li>Free setup</li>
						<li>Unlimited Bandwidth</li>
						<li>0% Transaction fee</li>
						<li>Unlimited Storage</li>
						<li>Private URLs</li>
						<li>Enhanced Security</li>-->
					</ul>
					<div class="price-actions">
						<g:link method="get" class="btn" action="registerForm"  params="[plan: 2, token:'978123gyasgdf6734guykgsudafguywfi']"><g:message code="pricing.registerNow"/></g:link>
				
					</div>
				</div>
			</div>
			<!--price end-->
		</div>


	</div>
</div>
</body>
<!--container end-->
<g:render template="/comercial/footer"></g:render>
</html>
