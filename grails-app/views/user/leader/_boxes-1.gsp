				<div class="row">
					<div class="col-lg-3 col-xs-6" style="cursor:pointer">
						<!-- small box -->
						<div   class="small-box bg-aqua navLink" style="overflow: hidden" onclick="window.location='${createLink(action:"index", controller:"scenario",id:projectId)}'" >
							<div class="inner" >
								<h2>
									<g:message code="text.scenarios" />
								</h2>
							</div>
							<div  class="icon">
								<i class="fa fa-th"> </i>
							</div>
							<div class="small-box-footer" style="height: 20px">
							</div>
						</div>
					</div>
					<!-- ./col -->
					<div class="col-lg-3 col-xs-6" style="cursor:pointer">
						<!-- small box -->
						<div   class="small-box bg-red navLink" style="overflow: hidden" onclick="window.location='${createLink(action:"index", controller:"step",id:scenarioId)}'" >
							<div class="inner" >
								<h2>
									<g:message code="text.steps" />
								</h2>
							</div>
							<div  class="icon">
								<i class="fa fa-sort-amount-desc"> </i>
							</div>
							<div class="small-box-footer" style="height: 20px">
							</div>
						</div>
					</div>
					

					<!-- ./col -->
					<div class="col-lg-3 col-xs-6" style="cursor:pointer">
						<!-- small box -->
						<div   class="small-box bg-green navLink" style="overflow: hidden" onclick="window.location='${createLink(action:"index", controller:"case",id:scenarioId)}'" >
							<div class="inner" >
								<h2>
									<g:message code="text.cases" />
								</h2>
							</div>
							<div  class="icon">
								<i class="fa fa-code-fork "> </i>
							</div>
							<div class="small-box-footer" style="height: 20px">
							</div>
						</div>
					</div>
					
					<!-- ./col -->
					<div class="col-lg-3 col-xs-6 navLink"  style="cursor:pointer">
						<!-- small box -->
						<div   class="small-box bg-yellow" style="overflow: hidden" onclick="window.location='${createLink(action:"scenario", controller:"message", id:scenarioId)}'" >
							<div class="inner" >
								<h2>
									<g:message code="text.messages" />
								</h2>
							</div>
							<div  class="icon">
								<i class="fa fa-envelope-o"> </i>
							</div>
							<div class="small-box-footer" style="height: 20px">
							</div>
						</div>
					</div>
				</div>
				
				<script>
					$(document).ready(function(){
						$('[data-toggle="popover"]').popover();
					});
				</script>