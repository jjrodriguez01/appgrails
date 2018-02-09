				<div class="row " >
					<div class="col-lg-3 col-xs-6" style="cursor:pointer">
						<!-- small box -->
						<div   class="small-box bg-aqua navLink" style="overflow: hidden" onclick="window.location='${createLink(action:"index", controller:"project")}'" >
							<div class="inner" >
								<h2>
									<g:message code="general.text.projects" />
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
						<a href='${createLink(action:"index", controller:"stage")}' class="navLink">
							<div  class="small-box bg-red" style="overflow: hidden" >
								<div class="inner" >
									<h2>
										<g:message code="general.text.stage" />
									</h2>
								</div>
								<div  class="icon">
									<i class="fa fa-exchange"> </i>
								</div>
								<div class="small-box-footer" style="height: 20px">
								</div>
							</div>
						</a>
					</div>
					

					<!-- ./col -->
					<div class="col-lg-3 col-xs-6" style="cursor:pointer">
						<!-- small box -->
						<div   class="small-box bg-green navLink" style="overflow: hidden" onclick="window.location='${createLink(action:"index", controller:"execution")}'" >
							<div class="inner" >
								<h2>
									<g:message code="general.text.executions" />
								</h2>
							</div>
							<div  class="icon">
								<i class="ion ion-stats-bars"> </i>
							</div>
							<div class="small-box-footer" style="height: 20px">
							</div>
						</div>
					</div>
					
					<!-- ./col -->
					<div class="col-lg-3 col-xs-6" style="cursor:pointer">
						<!-- small box -->
						<div  class="small-box bg-yellow navLink" style="overflow: hidden" onclick="window.location='${createLink(action:"index", controller:"log")}'" >
							<div class="inner" >
								<h2>
									<g:message code="general.text.evidences" />
								</h2>
							</div>
							<div  class="icon">
								<i class="fa fa-book"> </i>
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