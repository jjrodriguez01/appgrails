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
				<g:if test="${flash.message}">

				<div id="deniedModal" class="modal fade " role="dialog">
					<div class="modal-dialog">
						<!-- Modal content-->
						<div class="modal-content">
							<div class="modal-header alert-warning">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h4 class="modal-title">
									<g:message code="general.error" />
								</h4>
							</div>
							<div class="modal-body">
								<p>
									${flash.message}
								</p>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">
									OK
								</button>
							</div>			
						</div>
					</div>
				</div>

					<script type="text/javascript">
						$('#deniedModal').modal('show');
					</script>

				</g:if>
				<section class="col-lg-7 connectedSortable">
					<sec:ifAllGranted roles="ROLE_DEMO">
						<div class="box box-primary">
							<div class="box-header">
								<div class="have-tooltip"  title="${message(code:'tooltip.myUsers.title')}" data-content="${message(code:'tooltip.myUsers.text')}" data-placement="top" style="cursor:pointer">
									<i class="fa fa-users"  > </i>
									<h3 class="box-title">
										<g:message code="text.myUsers" />
									</h3>
								</div>
							</div>
							<div class="box-body" id="usersBody">
								<div class="row">
									<label class="col-md-4 col-md-offset-4" style="color:#999966;text-align: center; ">
										<g:message code="general.demo.info.notAllowed"/> 
									</label>
								</div>
							</div>
						</div>
					</sec:ifAllGranted>
					<sec:ifNotGranted roles='ROLE_DEMO'>
						<sec:ifAnyGranted roles="${functionality0.roles}">
						<!-- User List -->
							<div class="box box-primary">
								<div class="box-header">
									<div class="have-tooltip"  title="${message(code:'tooltip.myUsers.title')}" data-content="${message(code:'tooltip.myUsers.text')}" data-placement="top" style="cursor:pointer">
										<i class="fa fa-users"  > </i>
										<h3 class="box-title">
											<g:message code="text.myUsers" />
										</h3>
									</div>
									<div class="box-tools pull-right">
										<ul class="pagination pagination-sm inline">
											<li>
												<a href="#" onclick="setCurrentPage(currentPageNumber-1); return false;">&laquo; </a>
											</li>
											<g:if test="${total>0}">
												<g:each in="${1..total}">
													<li class="pageNumber" onclick="setCurrentPage(${it}); return false;" >
														<a href="#">${it} </a>
													</li>
												</g:each>
											</g:if>
											<li>
												<a href="#" onclick="setCurrentPage(currentPageNumber-1); return false;">&raquo; </a>
											</li>
										</ul>
									</div>
								</div>
								<!-- /.box-header -->
								<div class="box-body" id="usersBody">
									<ul class="todo-list">
									<g:each in="${users}" var="user" status="i">
										<g:if test="${i<7}"> 
										<li>
											<span> 
												<g:link controller="user" action="editUser" id="${user.id}" > 
													<div class="pull-left image" style="margin-right:5px;">
														<asset:image height="25px;" style="border:solid 1px black;"  src="avatars/${user.avatarFile}" class="img-circle" alt="User Image" /> 
													</div> ${user.fullname}
												</g:link>
											</span>
											
											<g:if test="${webLoggedInUsers[i]=='true'}">
												<small  class="label label-success connectInfo">
													<i class="fa fa-chain"> </i> Web
												</small>
											</g:if>
											<g:else>
												<small  class="label label-danger connectInfo"> 
													<i class="fa fa-chain-broken"> </i> Web
												</small>
											</g:else>
											
											<g:if  test="${desktopLoggedInUsers[i]=='true'}">
												<small class="label label-success connectInfo">
													<i class="fa fa-chain"> </i> Desktop
												</small> 
											</g:if>
											<g:else>
												<small  class="label label-danger connectInfo"> 
													<i class="fa fa-chain-broken"> </i> Desktop
												</small>
											</g:else>
											
											<sec:ifAnyGranted roles="${functionality2.roles}">
												<div class="tools">
													<g:link controller="user" action="editUser" id="${user.id}">
														<i class="fa fa-edit"> </i>
													</g:link>
													<i class="fa fa-trash-o" onclick="confirmDelete(${user.id})"> </i>
												</div>
											</sec:ifAnyGranted>
										</li>
										</g:if>
									</g:each>
									</ul>
								</div>
								<!-- /.box-body -->
								<sec:ifAnyGranted roles="${functionality1.roles}">
									<div class="box-footer clearfix no-border">
										<button id="newUserButton"class="btn btn-default pull-right" >
											<i class="fa fa-plus"> </i>
											<g:message code="text.addUser"/>
										</button>
									</div>
								</sec:ifAnyGranted>
							</div>
							<!-- /.box -->
						</sec:ifAnyGranted>
					</sec:ifNotGranted>
						


					
					<!-- Projects weather -->
					<div class="box box-warning">
						<div class="box-header">
							<div class="have-tooltip"  title="${message(code:'tooltip.projects.title')}" data-content="${message(code:'tooltip.projectsWeather.text')}" data-placement="top" style="cursor:pointer">
								<i class="ion ion-ios-partlysunny"> </i>
								<h3 class="box-title"><g:message code='text.projects'/></h3>
								<button class="btn btn-default btn-sm pull-right" data-widget='collapse' style="margin-right: 5px; border:1px solid #e0e0eb">
									<i class="fa fa-minus"> </i>
								</button>
							</div>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<ul style="padding-left:0px">
								<g:each in="${projects}" var='project'>
									<g:if test="${project.logs.size()==0}">
										<a href="${createLink(controller:'scenario', action:'index', id:project.id)}">
											<li style="list-style-type:none; background-color:#f4f4f4; margin-bottom:4px" class="projectWeather"><asset:image src='weather/health-80plus.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">0%</span>
											</li>
										</a>
									</g:if>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=80}">
										<a href="${createLink(controller:'scenario', action:'index', id:project.id)}">
											<li style="list-style-type:none; background-color:#f4f4f4;margin-bottom:4px " class="projectWeather"><asset:image src='weather/health-80plus.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=60}">
										<a href="${createLink(controller:'scenario', action:'index', id:project.id)}">
											<li style="list-style-type:none; background-color:#f4f4f4;margin-bottom:4px " class="projectWeather"><asset:image src='weather/health-60to79.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=40}">
										<a href="${createLink(controller:'scenario', action:'index', id:project.id)}">
											<li style="list-style-type:none; background-color:#f4f4f4; margin-bottom:4px" class="projectWeather"><asset:image src='weather/health-40to59.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=20}">
										<a href="${createLink(controller:'scenario', action:'index', id:project.id)}">
											<li style="list-style-type:none; background-color:#f4f4f4; margin-bottom:4px" class="projectWeather"><asset:image src='weather/health-20to39.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:else>
										<a href="${createLink(controller:'scenario', action:'index', id:project.id)}">
											<li style="list-style-type:none; background-color:#f4f4f4; margin-bottom:4px" class="projectWeather"><asset:image src='weather/health-00to19.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:else>

								</g:each>
							</ul>
							
						</div>
						<!-- /.box-body -->
						
					</div>
					<!-- /.box -->


					<!-- Cases box -->
					<div class="box box-success">
						<div class="box-header">
							<div class="have-tooltip"  title="${message(code:'tooltip.casesVsBrowser.title')}" data-content="${message(code:'tooltip.casesVsBrowser.text')}" data-placement="top" style="cursor:pointer">
								<i class="ion ion-network"> </i>
								<h3 class="box-title"><g:message code="text.casesByBrowser"/></h3>
								<button class="btn btn-default btn-sm pull-right" data-widget='collapse' 	style="margin-right: 5px; border:1px solid #e0e0eb">
									<i class="fa fa-minus"> </i>
								</button>
							</div>
						</div>

						<div class="box-body chart">

			                <canvas height="230" width="501" id="barChart" style="height: 230px; width: 501px;">
			                	
			                </canvas>
							
						</div>
						<!-- /.chat -->
						<div class="box-footer no-border">
							<div class="row" style="margin-right:1%; margin-left:4%; margin-top:-6%">
								<div  class="col-md-2 col-xs-2 col-sm-2" >
									<asset:image src='browsers/ch.png' width="50px" style="margin-left:10%"/>
								</div>
								<div  class="col-md-2 col-xs-2 col-sm-2" >
									<asset:image src='browsers/ff.png' width="50px" style="margin-left:10%"/>
								</div>
								<div  class="col-md-2 col-xs-2 col-sm-2" >
									<asset:image src='browsers/ed.png' width="50px" style="margin-left:10%"/>
								</div>
								<div  class="col-md-2 col-xs-2 col-sm-2" >
									<asset:image src='browsers/sa.png' width="50px" style="margin-left:10%" />
								</div>
								<div  class="col-md-2 col-xs-2 col-sm-2" >
									<asset:image src='browsers/ie.png' width="50px" style="margin-left:10%"/>
								</div>
								<div  class="col-md-2 col-xs-2 col-sm-2" >
									<asset:image src='browsers/op.png' width="50px" style="margin-left:10%"/>
								</div>
								
							</div>
						</div>
					</div>
					<!-- /.box (cases box) -->

					<!-- cases by month box  -->
					<div class="box box-primary">
			            <div class="box-header no-border">
			            	<div class="have-tooltip"  title="${message(code:'tooltip.executionsVsMonth.title')}" data-content="${message(code:'tooltip.executionsVsMonth.text')}" data-placement="top" style="cursor:pointer">
				              <i class="fa fa-line-chart"></i>
				              <h3 class="box-title"><g:message code="text.casesByMonth"/></h3>
				                <div class="box-tools pull-right">
					               <button class="btn btn-default btn-sm pull-right" data-widget='collapse' 	style="margin-right:5px;  border:1px solid #e0e0eb">
										<i class="fa fa-minus"> </i>
									</button>
								</div>
			              </div>
			            </div>
			            <div class="box-body">
			              <div class="chart">
			               <canvas id="areaChart" width="600" height="300"></canvas>

			              </div>
			            </div>
			            <!-- /.box-body -->
			          </div>
			          <!-- /.box (executions box) -->
				</section>






<!-- /.Left col -->
<!-- right col (We are only adding the ID to make the widgets sortable)-->
<section class="col-lg-5 connectedSortable">

	<!-- Map box -->
	<div class="box box-danger ">
		<div class="box-header have-tooltip"  title="${message(code:'tooltip.inventory.title')}" data-content="${message(code:'tooltip.inventory.text')}" data-placement="top" style="cursor:pointer">
			
			
			<div class="pull-right box-tools">
				<button class="btn btn-default btn-sm pull-right" data-widget='collapse' style="margin-right: 5px; border:1px solid #e0e0eb">
				<i class="fa fa-minus"> </i>
				</button>
			</div>

	<!-- /. tools -->

			<i class="ion ion-ios-box"> </i>
			<h3 class="box-title"><g:message code='text.inventory'/></h3>
		</div>
		<div class="box-body">
			<div class="info-box bg-yellow">
            <span class="info-box-icon"><i class="fa fa-product-hunt"></i></span>

            <div class="info-box-content">
              <span class="info-box-text"><g:message code="text.projects"/></span>
              <span class="info-box-number">${projects.size()}</span>

              <div class="progress">
                <div class="progress-bar" style="width: ${projects.size()*5%100}%"></div>
              </div>
                  <span class="progress-description">
                    <g:message code="statistic.message.projects" args="[projects.size()]"/>
                  </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
          <div class="info-box bg-green">
            <span class="info-box-icon"><i class="ion ion-ios-list-outline"></i></span>

            <div class="info-box-content">
              <span class="info-box-text"><g:message code='text.scenarios'/></span>
              <span class="info-box-number">${projects*.scenarios.flatten().size()}</span>

              <div class="progress">
                <div class="progress-bar" style="width: ${projects*.scenarios.flatten().size()*5%100}%"></div>
              </div>
                  <span class="progress-description">
                      <g:message code="statistic.message.scenarios" args="[projects*.scenarios.flatten().size()]"/>
                  </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
          <div class="info-box bg-red">
            <span class="info-box-icon"><i class="ion ion-network"></i></span>

            <div class="info-box-content">
              <span class="info-box-text"><g:message code="text.cases"/></span>
              <span class="info-box-number">${projects*.scenarios.flatten()*.cases.flatten().size()}</span>

              <div class="progress">
                <div class="progress-bar" style="width: ${projects*.scenarios.flatten()*.cases.flatten().size()*5%100}%"></div>
              </div>
                  <span class="progress-description">
                    <g:message code="statistic.message.cases" args="[projects*.scenarios.flatten()*.cases.flatten().size()]"/>
                  </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
          <div class="info-box bg-aqua">
            <span class="info-box-icon"><i class="ion-ios-browsers-outline"></i></span>

            <div class="info-box-content">
              <span class="info-box-text"><g:message code='text.pages'/></span>
              <span class="info-box-number">${projects*.pages.flatten().size()}</span>

              <div class="progress">
                <div class="progress-bar" style="width: ${projects*.pages.flatten().size()*5%100}%"></div>
              </div>
                  <span class="progress-description">
                   <g:message code="statistic.message.pages" args="[projects*.pages.flatten().size()]"/>
                  </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
		</div>
	<!-- /.box-body-->
	<div class="box-footer no-border">
		
	</div>
</div>
<!-- /.box -->

<!--  -->
	<div class="box box-default">
            <div class="box-header have-tooltip"  title="${message(code:'tooltip.executionsVsBrowser.title')}" data-content="${message(code:'tooltip.executionsVsBrowser.text')}" data-placement="top" style="cursor:pointer">
              <div class="box-tools pull-right">
                <button class="btn btn-default btn-sm pull-right" data-widget='collapse' style="margin-right: 5px; border:1px solid #e0e0eb">
				<i class="fa fa-minus"> </i>
				</button>
               
              </div>
              <i class="ion ion-earth"> </i>
			<h3 class="box-title"><g:message code='text.browsersUsage'/></h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body">
              <div class="row">
                <div class="col-md-8">
                  <div class="chart-responsive">
                    <canvas style="width: 202px; height: 160px;" width="202" id="pieChart" height="160"></canvas>
                  </div>
                  <!-- ./chart-responsive -->
                </div>
                <!-- /.col -->
                <div class="col-md-4">
                  <ul class="chart-legend clearfix">
                    <li><i class="fa fa-circle-o text-green"></i> Chrome</li>
                    <li><i class="fa fa-circle-o text-orange"></i> FireFox</li>
                    <li><i class="fa fa-circle-o text-blue"></i> Edge</li>
                    <li><i class="fa fa-circle-o text-gray"></i> Safari</li>
                    <li><i class="fa fa-circle-o text-aqua"></i> IE</li>
                    <li><i class="fa fa-circle-o text-red"></i> Opera</li>
                  </ul>
                </div>
                <!-- /.col -->
              </div>
              <!-- /.row -->
            </div>
            <!-- /.box-body -->
            <div class="box-footer no-padding">
              
            </div>
            <!-- /.footer -->
          </div>
	<!-- /.box -->
		


		<!-- productivity box  -->
			<div class="box box-primary">
			    <div class="box-header have-tooltip"  title="${message(code:'tooltip.casesVsUser.title')}" data-content="${message(code:'tooltip.casesVsUser.text')}" data-placement="top" style="cursor:pointer">
			        <i class="ion ion-person-stalker"></i>
			        <h3 class="box-title"><g:message code="text.casesByUser"/></h3>
  	                <div class="box-tools pull-right">
		                <button class="btn btn-default btn-sm pull-right" data-widget='collapse' 	style="margin-right: 5px; border:1px solid #e0e0eb">
		             		<i class="fa fa-minus"> </i>
						</button>
                	</div>
           		</div>
			    <div class="box-body">
			    	<div class="progress-group">
				    <g:each in="${users}" var="curUser" status='i'>
				    	<asset:image id="avatares-02.png" height="40px" style="margin-bottom:3px;" src="avatars/${curUser.avatarFile}" class="img-circle avatarThumb" alt="User Image" />
	                    	<span class="progress-text">${curUser.fullname}</span>

	                    	<span class="progress-number"><b>${projects*.logs.flatten()*.logs.flatten().count{it.executorId == curUser.id}}</b>/${projects*.logs.flatten()*.logs.flatten().size()}</span>
		                    <div class="progress sm">
			                    <g:if test="${projects*.logs.flatten()*.logs.flatten().size()>0}">
			                    	<g:if test="${i%4==0}">
			                    		<div class="progress-bar progress-bar-aqua" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == curUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:if>
			                    	<g:elseif test="${i%4==1}">
			                    		<div class="progress-bar progress-bar-red" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == curUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${i%4==2}">
			                    		<div class="progress-bar progress-bar-green" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == curUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${i%4==3}">
			                    		<div class="progress-bar progress-bar-orange" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == curUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:elseif>
			                    </g:if>
			                    <g:else>
			                    	<g:if test="${i%4==0}">
			                    		<div class="progress-bar progress-bar-aqua" style="width: 0%"></div>
			                    	</g:if>
			                    	<g:elseif test="${i%4==1}">
			                    		<div class="progress-bar progress-bar-red" style="width: 0%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${i%4==2}">
			                    		<div class="progress-bar progress-bar-green" style="width: 0%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${i%4==3}">
			                    		<div class="progress-bar progress-bar-orange" style="width: 0%"></div>
			                    	</g:elseif>
			                    	
			                    </g:else>
		                    	
		                    </div>
				    	</g:each>


						<asset:image id="avatares-02.png" height="40px" style="margin-bottom:3px;" src="avatars/${properUser.avatarFile}" class="img-circle avatarThumb" alt="User Image" />
	                    	<span class="progress-text">${properUser.fullname}</span>

	                    	<span class="progress-number"><b>${projects*.logs.flatten()*.logs.flatten().count{it.executorId == properUser.id}}</b>/${projects*.logs.flatten()*.logs.flatten().size()}</span>
		                    <div class="progress sm">
			                    <g:if test="${projects*.logs.flatten()*.logs.flatten().size()>0}">
			                    	<g:if test="${users.size()%4==0}">
			                    		<div class="progress-bar progress-bar-aqua" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == properUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:if>
			                    	<g:elseif test="${users.size()%4==1}">
			                    		<div class="progress-bar progress-bar-red" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == properUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${users.size()%4==2}">
			                    		<div class="progress-bar progress-bar-green" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == properUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${users.size()%4==3}">
			                    		<div class="progress-bar progress-bar-orange" style="width: ${projects*.logs.flatten()*.logs.flatten().count{it.executorId == properUser.id}*100/projects*.logs.flatten()*.logs.flatten().size()}%"></div>
			                    	</g:elseif>
			                    </g:if>
			                    <g:else>
			                    	<g:if test="${users.size()%4==0}">
			                    		<div class="progress-bar progress-bar-aqua" style="width: 0%"></div>
			                    	</g:if>
			                    	<g:elseif test="${users.size()%4==1}">
			                    		<div class="progress-bar progress-bar-red" style="width: 0%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${users.size()%4==2}">
			                    		<div class="progress-bar progress-bar-green" style="width: 0%"></div>
			                    	</g:elseif>
			                    	<g:elseif test="${users.size()%4==3}">
			                    		<div class="progress-bar progress-bar-orange" style="width: 0%"></div>
			                    	</g:elseif>
			                    </g:else>


				    </div>
			    </div>
			<!-- /.box-body -->
			</div>
			<!-- /.box (productivity box) -->
		</section>
<!-- right col -->
</div>
<!-- /.row (main row) -->

</section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->
<g:render template="leader/footer"/>


</div>





<!-- Modal de registro de usuario -->


<div id="newUserModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="modal.newUser.title" />
				</h4>
			</div>
			<div class="modal-body ">
				<div id="formNewUser">
					<label for="username"><g:message code="modal.user.fullname" /></label>
					<input class="form-control" type="text" name="username"  id="usernameNewUser"><br/>
					<label  for="email"><g:message code="modal.user.username" /></label>
					<input class="form-control" type="text" name="email"  id="emailNewUser"><br/> 
					<label><g:message code="modal.user.isAdminUser"/>
						<input id="isAdminUsercheck" class="ios-switch" type="checkbox">
						<div class="switch"></div>
					</label><br/><br/>
					<div class="row" style="margin-bottom:10px">
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-01.png" height="70px" style="box-shadow:0 .5em .5em .5em hsla(192,100%,47%,.8) inset, 0 0 .9em rgba(0, 142, 230, .8)" src="avatars/avatares-01.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-02.png" height="70px" src="avatars/avatares-02.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-03.png" height="70px" src="avatars/avatares-03.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-04.png" height="70px" src="avatars/avatares-04.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-05.png"  height="70px" src="avatars/avatares-05.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-06.png" height="70px" src="avatars/avatares-06.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<br/><br/><br/><br/>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-07.png" height="70px" src="avatars/avatares-07.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-08.png" height="70px" src="avatars/avatares-08.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-09.png" height="70px" src="avatars/avatares-09.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-10.png" height="70px" src="avatars/avatares-10.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-11.png" height="70px" src="avatars/avatares-11.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-12.png" height="70px" src="avatars/avatares-12.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<br/><br/><br/><br/>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-13.png" height="70px" src="avatars/avatares-13.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-14.png" height="70px" src="avatars/avatares-14.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-15.png" height="70px" src="avatars/avatares-15.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-16.png" height="70px" src="avatars/avatares-16.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-17.png" height="70px" src="avatars/avatares-17.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-18.png" height="70px" src="avatars/avatares-18.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<br/><br/><br/><br/>

					</div>

					<button type="button" id="formNewUserButton" class="btn btn-info" onclick="registerNewUser()"><g:message code="modal.button.createUser"/></button>
				</div>
			</div>
		</div>	
	</div>	
</div>
<!-- Fin del modal de registro de usuario -->




<!-- Modal de información para cuenta demo -->

<div id="demoInfoModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-danger">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.error" />
				</h4>
			</div>
			<div class="modal-body">
				<p><g:message code="general.demo.info.notAllowed"/> </p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de informacion de la cuenta demo -->








<!-- Modal de exito de registro de usuario -->


<div id="newUserSuccessModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-success">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.success" />
				</h4>
			</div>
			<div class="modal-body">
				<p><g:message code="register.success.successCreateUser"/> </p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de exito de registro de usuario -->


<!-- Modal de error de registro de usuario -->

<div id="newUserErrorModal" class="modal fade " style="overflow:hidden" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-error">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.error" />
				</h4>
			</div>
			<div class="modal-body">
				<p id="newUserErrorMessage"> </p>

			</div>
		</div>

	</div>
</div>

<!-- Fin del modal de error de registro de usuario -->



<!-- Modal de expiración de sesión  -->

<div id="expiredSessionModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-warning">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.text.expiredSessionTitle" />
				</h4>
			</div>
			<div class="modal-body">
				<p id="expiredSessionAlert"> <g:message code="general.text.expiredSessionText" /></p>

			</div>
		</div>

	</div>
</div>
<!-- Fin del modal de expiración de sesión-->


<!-- Modal de asignación de usuario  -->

<div id="userAsignationModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.text.reasignUser" />
				</h4>
			</div>
			<div class="modal-body">
				<p id="posibleUsers">
					
				</p>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">
					<g:message code="general.text.cancel" />
				</button>
				<button type="button" class="btn btn-info "
					onclick="reasignUser()">
					<g:message code="general.text.continue" />
				</button>
			</div>
		</div>

	</div>
</div>
<!-- Fin del modal de asignacion de usuario-->



<!-- Modal de confirmación de borrado de usuario  -->

<div id="confirmModal" class="modal fade " role="dialog">
	<div class="modal-dialog">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-warning">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.text.confirmTitle" />
				</h4>
			</div>
			<div class="modal-body">
				<p>
					<g:message code="general.text.confirmMessage" />
				</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">
					<g:message code="general.text.cancel" />
				</button>
				<button type="button" class="btn btn-warning "
					onclick="deleteUser()">
					<g:message code="general.text.continue" />
				</button>
			</div>			
		</div>
	</div>
</div>
<!-- Fin del modal de confirmación de borrado de usuario-->


<script type="text/javascript">
	var selectedAvatar="avatares-01.png"
	var currentPageNumber = 1
	var webLoggedInUsers
	var desktopLoggedInUsers
	var users = "${users.encodeAsJSON()}"
	var userDeletingId = null

	$('#btn-options').on('click', function(){
	    if(!$('#theme-options').hasClass('active')){
	    	$('#theme-options').addClass('active');
	    }
	    else{
	    	$('#theme-options').removeClass('active');
	    }
	});

	var data = {
	    labels: ["", "", "","", "", ""],
	    datasets: [
	        {
	            label: "${message(code:'general.error')}",
	            fillColor: "rgba(230,33,23,0.7)",
	            strokeColor: "rgba(255,0,0,0.9)",
	            highlightFill: "rgba(255,0,0,0.3)",
	            highlightStroke: "rgba(255,0,0,0.4)",
	            data: [${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome') && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox') && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge') && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari') && !it.isSuccess}},${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer') && !it.isSuccess}},${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera') && !it.isSuccess}}]
	        },
	        {
	            label: "${message(code:'general.success')}",
	            fillColor: "rgba(151,187,205,0.5)",
	            strokeColor: "rgba(151,187,205,0.8)",
	            highlightFill: "rgba(151,187,205,0.3)",
	            highlightStroke: "rgba(151,187,205,0.4)",
	            data: [${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome') && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox') && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge') && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari') && it.isSuccess}},${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer') && it.isSuccess}},${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera') && it.isSuccess}}]
	        }
	    ]
	};


	var pieData = [
    
    {
        value: ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome')}},
        color: "#00a65a",
        highlight: "#3DD991",
        label: "Chrome"
    },
    {
        value: ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox')}},
        color: "#f39c12",
        highlight: "#F5BB5F",
        label: "FireFox"
    },
    
    {
        value: ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge')}},
        color: "#0073b7",
        highlight: "#73A9C9",
        label: "Edge"
    },
    {
        value: ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari')}},
        color: "#d2d6de",
        highlight: "#E6E8ED",
        label:"Safari"
    },
    {
        value: ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer')}},
        color: "#00c0ef",
        highlight: "#AEDDE8",
        label: "IE"
    },
    {
        value: ${projects*.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera')}},
        color:"#dd4b39",
        highlight: "#E3887D",
        label: "Opera"
    }
]



	var lineData = {
	    labels: ["${message(code:'text.january')}", "${message(code:'text.february')}", "${message(code:'text.march')}", "${message(code:'text.april')}", "${message(code:'text.may')}", "${message(code:'text.june')}", "${message(code:'text.july')}", "${message(code:'text.august')}", "${message(code:'text.september')}", "${message(code:'text.october')}", "${message(code:'text.november')}", "${message(code:'text.december')}"],
	    datasets: [
	        {
	            label: "${message(code:'general.success')}",
	            fillColor: "rgba(0,166,90,0.2)",
	            strokeColor: "rgba(0,160,90,1)",
	            pointColor: "rgba(0,160,90,1)",
	            pointStrokeColor: "rgba(0,160,90,1)",
	            pointHighlightFill: "#43CC8D",
	            pointHighlightStroke: "#43CC8D",
	            data: [${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  &&  it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()   && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}]
	        },
	        {
	            label: "${message(code:'general.error')}",
	            fillColor: "rgba(221,75,57,0.2)",
	            strokeColor: "rgba(221,75,57,1)",
	            pointColor: "rgba(221,75,57,1)",
	            pointStrokeColor: "rgba(221,75,57,1)",
	            pointHighlightFill: "#rgba(151,187,205,0.2)",
	            pointHighlightStroke: "rgba(151,187,205,0.6)",
	            data: [${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}]
	        }
	    ]
	};



	var lastHtml=$('#usersBody ul').html()


	$(".avatarThumb").click(function(){
		$(this).css('box-shadow','0 .5em .5em .5em hsla(192,100%,47%,.8) inset, 0 0 .9em rgba(0, 142, 230, .8)')
		selectedAvatar=$(this).attr('id')

		$('.avatarThumb').not(this).each(function(){
			$(this).css('box-shadow','');
		});


	})

	$(window).load(function(){
		setInterval(getNotifications, 8000);
		setInterval(updateUsers, 30000);

	})

	$('#newUserButton').click(function(){
		var p = <sec:loggedInUserInfo field="plan"/>
		if(p>1){
			$('#newUserModal').modal('show')
		}
		else{
			$('#demoInfoModal').modal('show')	
		}
		
	})

	$('#expiredSessionModal').on('hidden.bs.modal', function () {
		location.reload()
	})
	$('#newUserModal').on('hidden.bs.modal', function () {
		$('#loadingState').css("display","none");
	})




	function confirmDelete(id){
		userDeletingId = id
		$('#confirmModal').modal('show')
		
	}


	function deleteUser(){
		$('#confirmModal').modal('hide')
		$.ajax({
				url : "${createLink(controller:'user',action:'deleteUser')}",
				data:{
					id:userDeletingId,
				},
			success : function(result) {

				updateUsers()
				$('#userAsignationModal').modal('hide')
			},
			error: function(status, text, result, xhr){
				var users = JSON.parse(status.responseText)
				
				var newHtml='<div class="btn-group form-control" data-toggle="buttons" style="height:auto">'
				for(var i=0;i < users.length; i++){
					if(users[i].id!=userDeletingId){
						newHtml+='<label class="btn-thunder btn btn-default btn-user" id="'+users[i].id+'">'
						newHtml+='<input type="radio" id="'+users[i].id+'"/>'
						newHtml+='<a href="#" data-toggle="tooltip" title="'+users[i].fullname+' ">'
						newHtml+='<img src="${createLink(controller:"assets", action:"avatars")}/'+users[i].avatarFile+'" style="border:solid 1px black;" class="img-circle" height="50px;"></a></label>'
					}
					

				}
				newHtml+="</div>"
				$('#posibleUsers').html(newHtml)
				$('#posibleUsers label').first().removeClass('btn-default')
				$('#posibleUsers label').first().addClass('active btn-info')
				$('#userAsignationModal').modal('show')

				$('.btn-thunder').click(function(){
					$('.btn-thunder').each(function(){
						$(this).removeClass('btn-default btn-info')
						$(this).addClass('btn-default')
					})
					if($(this).attr('id')=='specificDays'){
						$('#daysDiv').css('display', 'block')
					}
					else{
						$('#daysDiv').css('display', 'none')
					}
					$(this).removeClass('btn-default')
					$(this).addClass(' btn-info ')
				})


			}
		});
	}

	
	function setCurrentPage(curPage){
		if(curPage<=0){
			currentPageNumber=1;
		}
		else if(curPage>Math.ceil(users.length/7)){
			currentPageNumber=Math.ceil(users.length/7)
		}
		else{
			currentPageNumber=curPage
		}

		var html=""
		var last = Math.min(7*currentPageNumber, users.length)
		if(users.length>0){
			for(var i=7*(currentPageNumber-1);i<last;i++){
					var link="${createLink(controller:'user', action:'editUser')}"
					html+='<li>	<span> <a href="'+link+'/'+users[i].id+'"><div class="pull-left image" style="margin-right:5px;"> <img src="${createLink(controller:"assets", action:"avatars")}/'+users[i].avatarFile+'" height="25px;" style="border:solid 1px black;" class="img-circle" alt="User Image"> </div>'+users[i].fullname+'</a></span> <small class="label '
						if(webLoggedInUsers[i]=='true'){
							html+='label-success connectInfo"> <i class="fa fa-chain">'
						}
						else{
							html+='label-danger connectInfo"> <i class="fa fa-chain-broken">'
						}
						html+=' </i> Web </small>'
						if(desktopLoggedInUsers[i]=='true'){
							html+='<small  class="label label-success connectInfo"> <i class="fa fa-chain">'
						}
						else{
							html+='<small  class="label label-danger connectInfo"> <i class="fa fa-chain-broken">'
						}
						html+='</i> Desktop </small> <div class="tools"> <a href="'+link+'/'+users[i].id+'"> <i class="fa fa-edit"> </i> </a> <i class="fa fa-trash-o" onclick="confirmDelete('+users[i].id+');"> </i> </div> </li>'
					
			}
			if(lastHtml!=html){
				$('#usersBody ul').html(html)
				lastHtml=html
			}
		}
		
	}



	function updateUsers(){
		$.ajax({
			url : "${createLink(controller:'user',action:'getConnectedUsers')}",
			success : function(result) {
				webLoggedInUsers = result.webLoggedInUsers
				desktopLoggedInUsers = result.desktopLoggedInUsers
				users = result.users
				setCurrentPage(currentPageNumber)

			},
			error: function(status, text, result, xhr){
			}
		})
	}

	function registerNewUser(){
		$('#formNewUserButton').prop("disabled", true);
		$('#formNewUserButton').html('<i class="fa fa-spinner fa-spin fa-2"></i>');

		$.ajax({
			url : "${createLink(controller:'user',action:'registerBasicUserForLeader')}",
			data:{username:$("#emailNewUser").val(),
			fullname: $("#usernameNewUser").val(), 
			isAdminUser:$('#isAdminUsercheck').prop('checked'),
			avatarFile:selectedAvatar
		},
		success : function(result) {
			$('#newUserModal').modal('hide'); 
			$('#newUserSuccessModal').modal('show');
			$('#myUsersList').append($('<li> </li>'))
			$('#formNewUserButton').text('${g.message(code:"modal.button.createUser")}');
			$('#formNewUserButton').prop("disabled", false);

		},
		error: function(status, text, result, xhr){
			$('#newUserErrorMessage').html(status.responseText)
			$('#newUserModal').modal('hide');
			$('#newUserErrorModal').modal('show');
			$('#formNewUserButton').text('${g.message(code:"modal.button.createUser")}');
			$('#formNewUserButton').prop("disabled", false);

		}
	});
	}

	$('.modal').on('hidden.bs.modal', function() {
		$("body").css('padding-right','0px')
	})


function reasignUser(){
	var newUser = null
	$('.btn-user').each( function(){
		if($(this).hasClass('active')){
			newUser = $(this).attr('id')
		}
	})

	$.ajax({
			url : "${createLink(controller:'user', action:'reasignUser')}",
			data:{
				oldUser:userDeletingId,
				newUser: newUser, 
			},
		success : function(result) {
			updateUsers()
			$('#userAsignationModal').modal('hide')

		},
		error: function(status, text, result, xhr){
			$('#newUserErrorMessage').text('${message(code:"general.error")}')
			$('#newUserErrorModal').modal('show')
		}
	});

}


	$('.projectWeather').mouseover(function(){
		$(this).css('background-color','#EDEDED')
		$(this).css('border-radius','5px')
	})

	$('.projectWeather').mouseout(function(){
		$(this).css('background-color','#F4F4F4')
	})





    var barChartCanvas = $("#barChart").get(0).getContext("2d");
    var barChart = new Chart(barChartCanvas);
    var barChartData = data;
    barChartData.datasets[1].fillColor = "#00a65a";
    barChartData.datasets[1].strokeColor = "#00a65a";
    barChartData.datasets[1].pointColor = "#00a65a";
    var barChartOptions = {
      //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
      scaleBeginAtZero: true,
      //Boolean - Whether grid lines are shown across the chart
      scaleShowGridLines: true,
      //String - Colour of the grid lines
      scaleGridLineColor: "rgba(0,0,0,.05)",
      //Number - Width of the grid lines
      scaleGridLineWidth: 1,
      //Boolean - Whether to show horizontal lines (except X axis)
      scaleShowHorizontalLines: true,
      //Boolean - Whether to show vertical lines (except Y axis)
      scaleShowVerticalLines: true,
      //Boolean - If there is a stroke on each bar
      barShowStroke: true,
      //Number - Pixel width of the bar stroke
      barStrokeWidth: 2,
      //Number - Spacing between each of the X value sets
      barValueSpacing: 5,
      //Number - Spacing between data sets within X values
      barDatasetSpacing: 1,
      //String - A legend template
      legendTemplate: "",
      //Boolean - whether to make the chart responsive
      responsive: true,
      maintainAspectRatio: true
    };

    barChartOptions.datasetFill = false;
    barChart.Bar(barChartData, barChartOptions);


    var pieChartCanvas = $("#pieChart").get(0).getContext("2d");
	var myPieChart = new Chart(pieChartCanvas).Doughnut(pieData,barChartOptions);

	var lineChartCanvas = $("#areaChart").get(0).getContext("2d");
	var myLineChart = new Chart(lineChartCanvas).Line(lineData,{
		datasetFill : true,
	});

</script>
</body>
</html>