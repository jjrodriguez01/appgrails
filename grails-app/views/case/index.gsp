<%@page defaultCodec="none" %>
<sec:ifAllGranted roles="ROLE_USER_LEADER">
<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>

<div class="content-wrapper">
	<!-- Main content -->
	<section class="content" id="principalSection">
		<!-- Small boxes (Stat box) -->
		<sec:ifAllGranted roles="ROLE_USER_LEADER">
			<g:render template="/user/leader/boxes-1"/>
		</sec:ifAllGranted>
		<sec:ifNotGranted  roles="ROLE_USER_LEADER">
			<g:render template="/user/user/boxes-1"/>
		</sec:ifNotGranted>
<!-- /.row -->
<!-- Main row -->
		<div class="row">
			<div class="col-xs-12">
				<div class="nav-tabs-custom">
					<!-- Tabs within a box -->
					<ul class="nav nav-tabs pull-right">
						<li class="active" id="listTab">
							<a href="#revenue-chart" data-toggle="tab">
								<i class="fa fa-list-alt" style="color: blue"> </i> 
								<g:message code="text.list" />
							</a>
						</li>
						<sec:ifAnyGranted roles="${functionality14.roles}">
							<li>
								<a href="#newCase-chart" data-toggle="tab">
									<i class="fa fa-plus" style="color: green"></i> 
									<g:message code="text.new" />
								</a>
							</li>
						</sec:ifAnyGranted>
						<li >
							<a href="#generatorsDiv" data-toggle="tab" id="generatorsTab">
								<i class="fa fa-database" style="color: #f39c12"></i> 
								<g:message code="text.extractorsAndGnerators" />
							</a>
						</li>
						<li>
							<sec:ifAnyGranted roles="${functionality17.roles}">
								<g:if test="${associatedScenario.isWeb() || associatedScenario.type == 2}" >
									<a href="#" onclick="showBrowsers(${associatedScenario.id}); return false;">
										<i class="fa fa-play-circle-o" style="color: green"></i> 
										<g:message code="text.execute" />
									</a>
								</g:if>
								<g:else>
									<a href="#"onclick="executeScenario(${associatedScenario.id}); return false;">
										<i class="fa fa-play-circle-o" style="color: green"></i> 
										<g:message code="text.execute" />
									</a>
								</g:else>
							</sec:ifAnyGranted>
						</li>
						<li class="pull-left header">
							<i class="fa fa-code-fork "> </i> 
							<g:message code="text.cases" />
						</li>
					</ul>
					<div class="tab-content no-padding">
						<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
							<div class="box">
								<div class="box-header">
									<div class="box-header col-md-12">
										<div class="col-md-6">
											<h3>
												<i class="fa  fa-code-fork "> </i>
												<g:message code="text.cases"/>
											</h3>
										</div>
										<div class="col-md-6">
											<ol class="breadcrumb pull-right" style="background-color:white">
												<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
									        	<li><g:link controller='project' action='index'>${associatedScenario.project.name}</g:link></li>
									       		<li><g:link controller='scenario' action='index' id='${associatedScenario.project.id}'>${associatedScenario.name}</g:link></li>
									       		<li class="active"><g:message code="text.cases"/></li>
									    	</ol>
										</div>
									</div>
								</div>
								<!-- /.box-header -->
								<div class="box-body row" style="padding-left:20px">
									<g:if test="${cases.size()==0}">
										<div id="notSupportActionsAdded" class="row" >
											<label class="col-md-4 col-md-offset-4" style="color:#999966 ">
												<g:message code="text.notCases"/>
											</label>
										</div>
									</g:if>
									<g:else>
										<div class="col-md-12 row" style="overflow-x:scroll" >
																						
											<label>
											<g:message code="datatable.showing"/></label>
											<select id="rowsPerPageSelect" >
												<option value="10">10</option>
												<option value="25">25</option>
												<option value="50">50</option>
												<option value="100">100</option>
											</select>
											<label style="margin-right:45px">  <g:message code="datatable.entries"/>
											</label>
											<label for="search">
												<g:message code="datatable.search"/>: 
											</label>

											<input id="datatablesearch" table="casesTable" name="search" type="text"/>

											<button class="btn btn-danger pull-right" id="deleteSelection" ><g:message code="text.delete" /> <i class="fa fa-trash"></i></button>

											<label style="padding-top: 6px; margin-right:30px;" class="pull-right">
												<g:message code="general.text.selectAll" />
												<input id="selectAllRowsSwitch" class="ios-switch"  type="checkbox">
												<div class="switch"></div>
											</label>
											<table id="casesTable" class="table table-bordered table-condensed table-hover sortable paginated">
												<thead>
													<tr style="background-color: rgba(60, 141, 188, 0.56);">
		    											<th></th>
	    												<th></th>
	    												<th></th>
	    												<th></th>
	    												<g:if test="${associatedScenario.type==1}">
	    													<th></th>
	     												</g:if>
	    												<g:each in="${steps}" var="paso" status="i">
	    													<g:if test="${paso.isEnabled && !paso.isHidden}">
	    													<th><small class="label label-primary"> <g:message
	    																code="${paso.principalAction.action.name}" />
	    													</small> <br>
	    														<div style="margin-top: 3px">
	    															<g:each in="${paso.supportActions.sort{it.execOrder}}"
	    																var="action" status="k">
	    																<div style="margin-top: 3px">
	    																	<small class="label label-success"> <g:message
	    																			code="${action.action.name}" />
	    																	</small>
	    																</div>
	    															</g:each>
	    														</div>
	    														</th>
	    													</g:if>
	    												</g:each>
	    												<sec:ifAllGranted roles="ROLE_USER_LEADER">
	    													<th></th>
	    												</sec:ifAllGranted>
	    											</tr>
													<tr>
														<th></th>
														<th>
															<label style="" class="pull-left">
																<g:message code="general.text.activateAll" />
																<input id="selectAllSwitch" class="ios-switch"  type="checkbox">
																<div class="switch"></div>
															</label>
														</th>
														<th>ID</th>
														<g:if test="${associatedScenario.type==1}">
															<th>
																<g:message code="text.orientation" />
															</th>
														</g:if>
														<th><g:message code="text.description" /></th>
														<g:each in="${steps.sort{it.execOrder}}" var="step">
															<g:if test="${step.isEnabled && !step.isHidden}">
																<g:if test="${step.object!=null}">
																	<th style="vertical-align:top"><p align="center">${step.object.name}</p></th>
																</g:if>
																<g:else>
																	<th>--</th>
																</g:else>
																
															</g:if>
														</g:each>
														<sec:ifAnyGranted roles="${functionality15.roles}">
															<th><g:message code="text.edit" />/<g:message code="text.delete" /></th>
														</sec:ifAnyGranted>
													</tr>
													
												</thead>
												<tbody>													
													<g:each status="i" in="${cases.sort{it.execOrder}}" var="casei">
														<g:if test="${casei.stateLastExecution==1}">
															<tr id="${casei.id}" class="trSelectableCases" style="background-color:rgba(128, 219, 86,0.5);" select="0">
														</g:if>
														<g:elseif test="${casei.stateLastExecution==2}">
															<tr id="${casei.id}" class="trSelectableCases" style="background-color:rgba(193, 81, 66, 0.5);" select="0">
														</g:elseif>
														<g:else>
															<tr id="${casei.id}" class="trSelectableCases" select="0">
														</g:else>
															<sec:ifAnyGranted roles="${functionality16.roles}">
																<td data-placement="top"
			    													data-container="body"
			    													style="cursor: pointer;" class="duplicateCell"
			    													data-title="<center><g:message code='text.duplicate'/></center>"
			    													data-content="<input type='number' min='1' max='50' class='form-control' id='duplicateText${casei.id}'/><button style='margin-top: 8px; margin-bottom:3px;' class='pull-right btn btn-primary btn-xs ' onclick='duplicate(${casei.id})'><g:message code='general.text.continue'/></button>" data-html="true">
																	<i class="fa fa-copy"></i>
																</td>
															</sec:ifAnyGranted>
															<sec:ifNotGranted roles="${functionality16.roles}">
																<td>
																	<a href="#" onclick="showDemoRestrictionModal()">
																		<i class="fa fa-copy" style="color:black"> </i>
																	</a>
																</td>
															</sec:ifNotGranted>
															<td>
																<g:if test="${casei.isEnabled}">
																	<label>
																		<input	id="${casei.id}" type="checkbox"
																		class="ios-switch enabledcheck" checked/>
																		<div class="switch"></div>
																	</label>
																</g:if>
																<g:else>
																	<label>
																		<input id="${casei.id}" type="checkbox"
																		class="ios-switch enabledcheck" />
																		<div class="switch"></div>
																	</label>
																</g:else>													
															</td>
															<td id="name${casei.id}">
																${casei.name}
															</td>
															<g:if test="${associatedScenario.type==1}">
																<td id="errorOriented${casei.id}" errororiented="${casei.errorOriented?'true':'false'}" steperrorid="${casei.errorStep?.id}" action="${message(code:casei.errorStep?.principalAction?.action?.name)}" object="${casei.errorStep?.object?.name}">
																	<g:if test="${!casei.errorOriented}" >
																		<small class="label label-success"><g:message code="general.success"/></small>
																	</g:if>
																	<g:else>
																		<small class="label label-danger"><g:message code="general.error"/></small>
																	</g:else>
																</td>
															</g:if>
															<td id="description${casei.id}" description="${casei.description}">
																<g:if test="${casei.description.length()<40}">
		    														${casei.description}
		    													</g:if>
		    													<g:else>
	    															${casei.description.substring(0,40)}...
	    														</g:else>
															</td>
															<g:each in="${casei.steps.sort{it.step.execOrder}}" var="curStep">
																<g:if test="${curStep.step.isEnabled && !curStep.step.isHidden }">
																	<td id="td${curStep.id}" principal="${curStep.principalAction.id}" support="${curStep.getSupportIds()}" data-placement="top" data-toggle="popover" data-container="body"
					    											style="cursor: pointer;"
					    											data-title="<center>${curStep.step.object!=null?curStep.step.object.name:'--'}</center>"
					    											data-content='<h5><b><g:message code="text.principalAction"/>:</b></h5><div style="border-radius: 5px; border: 1px solid #D0D7D9; padding-bottom:5px; padding-right:10px; margin-top:5px">
					    											<div class="row" style="margin: 0px 0px 0px 2px"><div class="col-md-5"><h5><b><g:message code="${curStep.principalAction.action.action.name}"/></b></h5></div> <label style="padding-top:6px;" class="pull-right col-md-7">
																	<g:if test="${curStep.principalAction.isActive}">
																		<input id="check${curStep.principalAction.id}" step="${curStep.id}" type="checkbox" class="ios-switch actionCheck" onclick="changeSmallColor(this)" checked>
																	</g:if>
																	<g:else>
																		<input id="check${curStep.principalAction.id}"  step="${curStep.id}"type="checkbox" class="ios-switch actionCheck" onclick="changeSmallColor(this)">
																	</g:else>
					    											  <div class="switch"></div></label></div> ${curStep.principalAction.getHtml().replace('replaceForCode',message(code:curStep.principalAction.action.action.name))}</div>
					    											<g:if test="${curStep.supportActions.size()>0}">
																		<h5><b><g:message code="text.supportActions"/>:</b></h5>
					    											</g:if>
					    											<g:each in="${curStep.supportActions.sort{it.execOrder}}" var="curSupAction">
					    												<div style="border-radius: 5px; border: 1px solid #D0D7D9; padding-bottom:5px; padding-right:10px; margin-top:5px">
					    												<div class="row" style="margin: 0px 0px 0px 2px;"><div class="col-md-5"><h5><b><g:message code="${curSupAction.action.action.name}"/></b></h5></div> <label style="padding-top:6px;" class="pull-right col-md-7">
																		<g:if test="${curSupAction.isActive}">
					    													<input id="check${curSupAction.id}" type="checkbox" class="ios-switch actionCheck" onclick="changeActionState(this)" checked>
																		</g:if>
																		<g:else>
																			<input id="check${curSupAction.id}" type="checkbox" class="ios-switch actionCheck" onclick="changeActionState(this)">
																		</g:else>
					    												<div class="switch"></div></label></div> ${curSupAction.getHtml().replace('replaceForCode', message(code:curSupAction.action.action.name))}</div>
					    											</g:each>' data-html="true">
																	<g:if test="${curStep.supportActions.size()==0}">
																		<g:if test="${curStep.principalAction.isActive}">
																			<small mult="f" id="small${curStep.id}" class="label label-primary"  >
																				<g:if test='${curStep.principalAction.value.indexOf('#;#')>-1}'>
																						${curStep.principalAction.value.substring(0,curStep.principalAction.value.indexOf('#;#'))}
																				</g:if>
																				<g:else>
																				<g:if test="${curStep.principalAction.value=='replaceForCode' && curStep.principalAction.getHtml().indexOf('<input')==-1}">

																					${message(code:curStep.principalAction.action.action.name)}
																				</g:if>
																				<g:else>
																					${curStep.principalAction.value}
																				</g:else>
																					
																				</g:else> 
																			</small>
																		</g:if>
																		<g:else>
																			<g:if test='${curStep.principalAction.value.indexOf('#;#')>-1}'>
																						<small id="small${curStep.id}" class="label label-default"  >${curStep.principalAction.value.substring(0,curStep.principalAction.value.indexOf('#;#'))}</small>
																				</g:if>
																				<g:else>
																				<small id="small${curStep.id}" class="label label-default">
																					${curStep.principalAction.value}</small>
																				</g:else> 
																		</g:else>
																			
																	</g:if>
																	<g:else>
																		<g:if test="${curStep.principalAction.isActive}">
																			<small mult="t" id="small${curStep.id}" class="label label-success">${curStep.principalAction.value}
																					<span class="badge" style="background-color:white; color:green">
																						${curStep.supportActions.size()}
																					</span>
																				</small>
																		</g:if>
																		<g:else>
																			<small mult="t" id="small${curStep.id}" class="label label-default">${curStep.principalAction.value}
																					<span class="badge" style="background-color:white; color:green">
																						${curStep.supportActions.size()}
																					</span>
																				</small>
																		</g:else>
																	</g:else>
																	</td>
																</g:if>
															</g:each>

															<sec:ifAnyGranted roles="${functionality15.roles}">
																<td>
																	<a href="#" onclick="showEditCaseModal(${casei.id}); return false;" >
																	<i class="fa fa-pencil-square-o "> </i></a>

																	<a style="color:red;" href="#" onclick="setDeletingId(${casei.id}); return false;">
																	<i class="fa fa-trash-o"> </i></a>
																</td>
															</sec:ifAnyGranted>
														</tr>	
													</g:each>
												</tbody>
											</table>
										</div>
									</g:else>
								</div>
		<!-- /.box-body -->
							</div>
		<!-- /.box -->
						</div>

						<div class="chart tab-pane" id="newCase-chart" style="position: relative;">
							<div id="formNewCase" style="margin-left: 20px; margin-right: 20px;">
								<br> 
								<label for="newCaseDescription">
									<g:message code="text.description"/>
								</label>
								<input id="newCaseDescription" name="newCaseDescription" type="text" class="form-control"/>
								<br/>
								<div class="col-md-12">
									<button type="button" id="formNewCaseButton" style="margin-bottom: 30px"
									class="btn btn-info pull-right">
										<g:message code="general.text.save" />
									</button>
								</div>
							</div>
						</div>


						<div class="chart tab-pane" id="generatorsDiv" style="position: relative; padding:30px">
							<div id="bdGeneratorsDiv">
								<sec:ifAllGranted roles="ROLE_DEMO">
									<div class="row well" >
										<p style="color:#EB6912;"><b><g:message code="tooltip.upgrade.text" /></b></p>
									</div>
									<br/>
								</sec:ifAllGranted>

								<sec:ifAnyGranted roles="${functionality20.roles}">
									<h3><g:message code="extractor.dbExtractor"/></h3>
									<g:each in="${bdExtractors.sort{it.dateCreated}}" var="extractor" status="i">
										<div idExtractor="${extractor.id}" class="box box-info" style="background-color:rgb(249,249,249); border-bottom: 1px solid rgb(220,220,220);  border-right: 1px solid rgb(220,220,220); border-left:1px solid rgb(220,220,220)">
											<div class="box-header" >
												<button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="dbCollapse${i}">
													<i class="fa fa-minus"></i>
			                					</button>
			                					<label class="pull-right" style="margin-left:30px;">
			                						<g:message code='text.isEnabled'/>
			                						<g:if test="${extractor.enabled}">
														<input id="dbExtractorSwitch${i}" class="ios-switch dbExtractorSwitch" savedId="${extractor.id}" type="checkbox" checked>
			                						</g:if>
													<g:else>
														<input id="dbExtractorSwitch${i}" class="ios-switch dbExtractorSwitch" savedId="${extractor.id}"  type="checkbox">
													</g:else>
													<div class="switch"></div>
													
												</label>
				
			                					<label id="dbExtractorHeader${i}" style="font-family: 'Source Sans Pro', sans-serif; font-size:18px; font-weight: 500;">${extractor.name} </label> <i class="fa fa-floppy-o"></i>
			                					<i class="fa fa-trash" style="color:red; cursor:pointer" index="${i}" onclick="confirmDBExtractorDelete(${extractor.id}, ${i})"></i>
											</div>

											<div class="box-body" id="collapsable${i}">
												<label for="exName${i}"><g:message code="extractor.extratorName"/></label>
												<input type="text" class="form-control extractorName" id="dbExtractorName${i}" index="${i}" value="${extractor.name}"/>
												<br/>
												<label for="dbManager${i}"><g:message code="extractor.dbManager"/></label>
												<select class="form-control" id="dbManager${i}">
													<option value="MySQL">MySQL</option>
													<option value="Oracle">Oracle</option>
													<option value="Postgres">PostgreSQL</option>
													<option value="DB2">DB2</option>
													<option value="SQL">SQL-Server</option>
												</select>


												<script>
													$('#dbManager${i}').val("${extractor.dbGestor}")
												</script>



												<br/>
												<label for="ip${i}">IP</label>
												<input type="text" class="form-control" id="ip${i}" placeholder="e.g. 127.0.0.1" value="${extractor.ip}"/>
												<br/>
												<label for="port${i}"><g:message code="extractor.port"/></label>
												<input type="text" class="form-control" id="port${i}" placeholder="e.g. 5432" value="${extractor.port}"/>
												<br/>
												<label for="dbname${i}"><g:message code="extractor.dbName"/></label>
												<input type="text" class="form-control" id="dbname${i}" placeholder="e.g. mydatabase" value="${extractor.bdName}"></input>
												<br/>
												<label for="user${i}"><g:message code="extractor.dbUser"/></label>
												<input type="text" class="form-control" id="user${i}" placeholder="e.g. root" value="${extractor.dbUser}"/>
												<br/>
												<label for="pass${i}"><g:message code="extractor.dbPass"/></label>
												<input type="password" class="form-control" id="pass${i}" placeholder="" value="${extractor.dbPass}"/>
												</br>
												<button class="btn btn-primary btn-db-conection" id="testConection${i}" index="${i}" style="margin-bottom:10px"><g:message code="extractor.testConection"/></button><label class="dbConectionP " id="dbConectionP${i}" style="margin-left:15px;"></label>
												<br/>
												<label for="query${i}"><g:message code="extractor.query"/></label>
												<textarea class="form-control" id="query${i}"  style="resize:vertical" >${extractor.query}</textarea>
												<br/>
												<label for="dbCases${i}"><g:message code="text.cases"/></label>
												</br>
												<label style="margin-left:30px;">
													<g:message code="text.all" />
													<g:if test="${extractor.originalCases=='ALL'}">
														<input id="dbCasesSwitch${i}" class="ios-switch dbCasesSwitch" index="${i}" type="checkbox" checked/>
														<div class="switch"></div>
														</label>
														<input type="text" class="form-control casesInput" id="dbCases${i}" placeholder="e.g.1-4" style="display:none"/>
													</g:if>
													<g:else>
														<input id="dbCasesSwitch${i}" class="ios-switch dbCasesSwitch" index="${i}" type="checkbox"/>
														<div class="switch"></div>
														</label>
														<input type="text" class="form-control casesInput" id="dbCases${i}" placeholder="e.g. 1-4" value="${extractor.originalCases}"/>
													</g:else>
												<br/>
												<label for="dbTable${i}"><g:message code="extractor.fieldMap"/></label>
												<div class="col-md-12" style="padding:0px" id="dbTable${i}">
													<div class="col-md-8"  style="padding:0px">
														<table class="table table-bordered table-condensed table-hover" id="dbFieldsMap${i}">
															<thead>
																<th><g:message code="text.object"/></th>
																<th><g:message code="extractor.dbField"/></th>
																<th></th>
															</thead>
															<tbody>
																<g:each in="${extractor.fieldsMap.split(';')}" var="map">
																	<tr index="${status}" stepname="name" stepid="${map.substring(0,map.indexOf(':'))}" class="maptr"> <td> <small class="label label-primary" style="margin-top:2px">${steps.find{String.valueOf(it.id)==map.substring(0,map.indexOf(':'))}?.object?.name}</small></td><td><input class="form-control dbFieldInput" type="text" value="${map.substring(map.indexOf(":")+1)}"></td><td style="text-align:center"><i index="${i}" stepid='${map.substring(0,map.indexOf(":"))}'  id="dbi${map.substring(0,map.indexOf(':'))}" onclick="deleteMap('dbi${map.substring(0,map.indexOf(':'))}', ${i}, 'db')" class="fa fa-trash maptrash" style="color:red; cursor:pointer"></i></td></tr>
																</g:each>
																
															</tbody>
														</table>
													</div>
												</div>
												<div class="col-md-12" style="padding:0px; margin-bottom: 20px">
													<div class="col-md-8"  style="padding:0px">
														<select id="dbCasesSelect${i}" class="form-control">
															<g:each in="${steps.sort{it.execOrder}}" var="step">
																<g:if test="${step.object && step.principalAction.action.name!='genericAction.click' && !(extractor.fieldsMap.contains(String.valueOf(step.id)+':'))}">
																	<option value="${step.id}"><g:message code="${step.object.name}" /></option>
																</g:if>																
															</g:each>
														</select>
													</div>
													
													<div class="col-md-3" style="margin-bottom:20px;">
														<button class="btn btn-primary db-field-map-button " index="${i}">
															<g:message code="text.add"/>
														</button>
													</div>
													
													<div class="col-md-8" style="padding:0px">
														<label for="clueField${i}"><g:message code="extractor.clueField"/></label>
														<input type="text" class="form-control" id="clueField${i}" placeholder="${message(code:'extractor.placeholder.document')}" value="${extractor.clueField}"/>
														<br/>
													</div>
												</div>
												
												<button class="btn btn-primary db-extractor-update-button center-block"  index="${i}" id="${extractor.id}">
													<g:message code="default.button.update.label"/>
												</button>
											</div>
										</div>
										<script>
											  element =$("#dbCollapse${i}")
										      //Find the box parent
										      var box = element.parents(".box").first();
										      //Find the body and the footer
										      var box_content = box.find("> .box-body, > .box-footer");
										      if (!box.hasClass("collapsed-box")) {
										        //Convert minus into plus
										        element.children(":first")
										                .removeClass("fa fa-minus")
										                .addClass("fa fa-plus");
										        //Hide the content
										        box_content.slideUp(300, function () {
										          box.addClass("collapsed-box");
										        });
										      } else {
										        //Convert plus into minus
										        element.children(":first")
										                .removeClass("fa fa-plus")
										                .addClass("fa fa-minus");
										        //Show the content
										        box_content.slideDown(300, function () {
										          box.removeClass("collapsed-box");
										        });
										      }
										</script>										
									</g:each>
									<div class="box box-info" style="background-color:rgb(249,249,249); border-bottom: 1px solid rgb(220,220,220);  border-right: 1px solid rgb(220,220,220); border-left:1px solid rgb(220,220,220)">
										<div class="box-header" >

											<button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="dbCollapse${bdExtractors.size()}">
												<i class="fa fa-minus"></i>
		                					</button>
		                					<label class="pull-right" style="margin-left:30px;">
		                						<g:message code='text.isEnabled'/>
												<input id="dbExtractorSwitch${bdExtractors.size()}" class="ios-switch dbExtractorSwitch"  savedId="none" type="checkbox" checked>
												<div class="switch"></div>
												
											</label>
			
		                					<label id="dbExtractorHeader${bdExtractors.size()}" style="font-family: 'Source Sans Pro', sans-serif; font-size:18px; font-weight: 500;"></label>
										</div>
										<div class="box-body">
											<label for="exName${bdExtractors.size()}"><g:message code="extractor.extratorName"/></label>
											<input type="text" class="form-control extractorName" id="dbExtractorName${bdExtractors.size()}" index="${bdExtractors.size()}"/>
											<br/>
											<label for="dbManager${bdExtractors.size()}"><g:message code="extractor.dbManager"/></label>
											<select class="form-control" id="dbManager${bdExtractors.size()}">
												<option value="MySQL">MySQL</option>
												<option value="Oracle">Oracle</option>
												<option value="Postgres">PostgreSQL</option>
												<option value="DB2">DB2</option>
												<option value="SQL">SQL-Server</option>
											</select>
											<br/>
											<label for="ip${bdExtractors.size()}">IP</label>
											<input type="text" class="form-control" id="ip${bdExtractors.size()}" placeholder="e.g. 127.0.0.1"/>
											<br/>
											<label for="port${bdExtractors.size()}"><g:message code="extractor.port"/></label>
											<input type="text" class="form-control" id="port${bdExtractors.size()}" placeholder="e.g. 5432"/>
											<br/>
											<label for="dbname${bdExtractors.size()}"><g:message code="extractor.dbName"/></label>
											<input type="text" class="form-control" id="dbname${bdExtractors.size()}" placeholder="e.g. mydatabase"></input>
											<br/>
											<label for="user${bdExtractors.size()}"><g:message code="extractor.dbUser"/></label>
											<input type="text" class="form-control" id="user${bdExtractors.size()}" placeholder="e.g. root"/>
											<br/>
											<label for="pass${bdExtractors.size()}"><g:message code="extractor.dbPass"/></label>
											<input type="password" class="form-control" id="pass${bdExtractors.size()}" placeholder=""/>
											</br>
											<button class="btn btn-primary btn-db-conection" id="testConection${bdExtractors.size()}" index="${bdExtractors.size()}" style="margin-bottom:10px"><g:message code="extractor.testConection"/></button><label class="dbConectionP " id="dbConectionP${bdExtractors.size()}" style="margin-left:15px;"></label>
											<br/>
											<label for="query${bdExtractors.size()}"><g:message code="extractor.query"/></label>
											<textarea class="form-control" id="query${bdExtractors.size()}"  style="resize:vertical"></textarea>
											<br/>
											<label for="dbCases${bdExtractors.size()}"><g:message code="text.cases"/></label>
											</br>
											<label style="margin-left:30px;">
												<g:message code="text.all" />
												<input id="dbCasesSwitch${bdExtractors.size()}" class="ios-switch dbCasesSwitch" index="${bdExtractors.size()}" type="checkbox"/>
												<div class="switch"></div>
												
											</label>
											<input type="text" class="form-control casesInput" id="dbCases${bdExtractors.size()}" placeholder="e.g. 1-4"/>
											<br/>
											<label for="dbTable${bdExtractors.size()}"><g:message code="extractor.fieldMap"/></label>
											<div class="col-md-12" style="padding:0px" id="dbTable${bdExtractors.size()}">
												<div class="col-md-8"  style="padding:0px">
													<table class="table table-bordered table-condensed table-hover" id="dbFieldsMap${bdExtractors.size()}">
													    
														<thead>
															<th><g:message code="text.object"/></th>
															<th><g:message code="extractor.dbField"/></th>
															<th></th>
														</thead>
														<tbody>
															
														</tbody>
													</table>
												</div>
											</div>
											<div class="col-md-12" style="padding:0px; margin-bottom: 20px">
												<div class="col-md-8"  style="padding:0px">
													<select id="dbCasesSelect${bdExtractors.size()}" class="form-control">
														<g:each in="${steps.sort{it.execOrder}}" var="step">
															<g:if test="${step.object && step.principalAction.action.name!='genericAction.click'}">
																<option value="${step.id}"><g:message code="${step.object.name}" /></option>
															</g:if>
															
														</g:each>
													</select>
												</div>
												
												<div class="col-md-3" style="margin-bottom:20px;">
													<button class="btn btn-primary db-field-map-button " index="${bdExtractors.size()}">
														<g:message code="text.add"/>
													</button>
												</div>
												
												<div class="col-md-8" style="padding:0px">
													<label for="clueField${bdExtractors.size()}"><g:message code="extractor.clueField"/></label>
													<input type="text" class="form-control" id="clueField${bdExtractors.size()}" placeholder="${message(code:'extractor.placeholder.document')}"/>
													<br/>
												</div>
											</div>
											
											<button class="btn btn-primary db-extractor-save-button center-block"  index="${bdExtractors.size()}">
												<g:message code="general.text.save"/>
											</button>
										</div>
									</div>
								</sec:ifAnyGranted>
							</div>		

							<div id="txtGeneratorsDiv">
								<sec:ifAnyGranted roles="${functionality21.roles}">
									<h3><g:message code="extractor.txtExtractor"/></h3>						
									<g:each in="${txtExtractors.sort{it.id}}" status="k" var="extractor">								
										<div class="box box-danger" style="background-color:rgb(249,249,249); border-bottom: 1px solid rgb(220,220,220);  border-right: 1px solid rgb(220,220,220); border-left:1px solid rgb(220,220,220)">
											<div class="box-header" >
												<button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="txtCollapse${k}">
													<i class="fa fa-minus"></i>
					                			</button>
					                			<label class="pull-right" style="margin-left:30px;">
					                				<g:message code='text.isEnabled'/>
					                				<g:if test="${extractor.isEnabled}">
														<input id="txtExtractorSwitch${k}" class="ios-switch txtExtractorSwitch" savedId="${extractor.id}" type="checkbox" checked>
													</g:if>
													<g:else>
														<input id="txtExtractorSwitch${k}" class="ios-switch txtExtractorSwitch" savedId="${extractor.id}" type="checkbox" >
													</g:else>
													<div class="switch"></div>
												</label>			
					                			<label id="txtExtractorHeader${k}" style="font-family: 'Source Sans Pro', sans-serif; font-size:18px; font-weight: 500;">${extractor.name}</label> <i class="fa fa-floppy-o"></i>
					                					<i class="fa fa-trash" style="color:red; cursor:pointer" index="${i}" onclick="confirmTXTExtractorDelete(${extractor.id}, ${k})"></i>		                			
											</div>
											<div class="box-body">
												<g:form method="post" enctype="multipart/form-data"  controller='extractor' action="updateTxtExtractor" id="${associatedScenario.id}" index="${k}" class="formTxt">
													<label for="txtExName${k}">
														<g:message code="extractor.extratorName"/></label>
													<input type="text" class="form-control txtExtractorName" name="name" id="txtExtractorName${k}" index="${k}" value="${extractor.name}"/>
													<br/>
													<label for="txtFile"><g:message code="extractor.file"/></label>
														<input type="file" id="txtFile" name="txtFile" value="${extractor.fileName}"/>
													<br/>
													<label for="delimiter"><g:message code="extractor.delimiter"/></label>
													<input type="text"  name="delimiter" class="form-control" value="${extractor.delimiter}" />
													<br/>
													<label for="txtCases${k}">
														<g:message code="text.cases"/>
													</label>
													</br>
													<label style="margin-left:30px;">
														<g:message code="text.all" />
														<g:if test="${extractor.originalCases=='ALL'}">
															<input id="txtCasesSwitch${k}" class="ios-switch txtCasesSwitch" index="${k}" type="checkbox" checked/>
														</g:if>
														<g:else>
															<input id="txtCasesSwitch${k}" class="ios-switch txtCasesSwitch" index="${k}" type="checkbox"/>
														</g:else>
														<div class="switch"></div>
													</label>
													<input type="text" class="form-control casesInput" id="txtCases${k}" placeholder="e.g. 1-4" value="${extractor.originalCases=='ALL'?'':extractor.originalCases}"/>
													<g:if test="${extractor.originalCases=='ALL'}">
														<script type="text/javascript">
															$('#txtCases${k}').hide()
														</script>
													</g:if>													
													<br/>
													<label for="txtTable${k}">
														<g:message code="extractor.fieldMap"/>
													</label>
													<div class="col-md-12" style="padding:0px" id="txtTable${k}">
														<div class="col-md-8"  style="padding:0px">
															<table class="table table-bordered table-condensed table-hover" id="txtFieldsMap${k}">
															    
																<thead>
																	<th><g:message code="text.object"/></th>
																	<th><g:message code="extractor.txtField"/></th>
																	<th></th>
																</thead>
																<tbody>
																	<g:each in="${extractor.fieldsMap.split(';')}" var="map">
																		<tr index="${status}" stepname="${steps.find{String.valueOf(it.id)==map.substring(0,map.indexOf(':'))}?.object?.name}" stepid="${map.substring(0,map.indexOf(':'))}" class="maptr"> <td> <small class="label label-primary" style="margin-top:2px">${steps.find{String.valueOf(it.id)==map.substring(0,map.indexOf(':'))}?.object?.name}</small></td><td><input class="form-control txtFieldInput" type="text" value="${map.substring(map.indexOf(":")+1)}"></td><td style="text-align:center"><i index="${k}" stepid='${map.substring(0,map.indexOf(":"))}'  id="txti${map.substring(0,map.indexOf(':'))}" onclick="deleteMap('txti${map.substring(0,map.indexOf(':'))}', ${k}, 'txt')" class="fa fa-trash maptrash" style="color:red; cursor:pointer"></i></td></tr>
																	</g:each>
																</tbody>
															</table>
														</div>
													</div>
													<br/>

													<div class="col-md-12" style="padding:0px; margin-bottom: 20px">
														<div class="col-md-8"  style="padding:0px">
															<select id="txtCasesSelect${k}" class="form-control">
																<g:each in="${steps.sort{it.execOrder}}" var="step">
																	<g:if test="${step?.object && step.principalAction.action.name!='genericAction.click' && !(extractor.fieldsMap.contains(String.valueOf(step.id)))}">
																		<option value="${step.id}"><g:message code="${step.object.name}" /></option>
																	</g:if>
																</g:each>
															</select>
														</div>
														
														<div class="col-md-3" style="margin-bottom:20px;">
															<button class="btn btn-primary txt-field-map-button" index="${k}">
																<g:message code="text.add"/>
															</button>
														</div>
														
														<br/>
													</div>
													<input type="hidden" value="${extractor.id}" name="idTxt" />
													<input type="submit" class="btn btn-primary center-block" value="${message(code:'general.text.update')}"/>
												</g:form>
											</div>
											<div class="box-footer">
												
											</div>
										</div>								
										<script>
										  element =$("#txtCollapse${k}")
										     //Find the box parent
										     var box = element.parents(".box").first();
										     //Find the body and the footer
										     var box_content = box.find("> .box-body, > .box-footer");
										     if (!box.hasClass("collapsed-box")) {
										       //Convert minus into plus
										       element.children(":first")
										               .removeClass("fa fa-minus")
										               .addClass("fa fa-plus");
												        //Hide the content
										        box_content.slideUp(300, function () {
										          box.addClass("collapsed-box");
										        });
										      } else {
												        //Convert plus into minus
										        element.children(":first")
										            .removeClass("fa fa-plus")
										            .addClass("fa fa-minus");
											        //Show the content
										   		     box_content.slideDown(300, function () {
											          box.removeClass("collapsed-box");
											        });
										      }
										</script>
									</g:each>						
									<div class="box box-danger" style="background-color:rgb(249,249,249); border-bottom: 1px solid rgb(220,220,220);  border-right: 1px solid rgb(220,220,220); border-left:1px solid rgb(220,220,220)">
										<div class="box-header" >
											<button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="collapse${txtExtractors.size()}">
												<i class="fa fa-minus"></i>
				                			</button>
				                			<label class="pull-right" style="margin-left:30px;">
				                				<g:message code='text.isEnabled'/>
												<input id="txtExtractorSwitch${txtExtractors.size()}" class="ios-switch txtExtractorSwitch" savedId="none" type="checkbox" checked>
				                				
												<div class="switch"></div>
											</label>
					
				                			<label id="txtExtractorHeader${txtExtractors.size()}" style="font-family: 'Source Sans Pro', sans-serif; font-size:18px; font-weight: 500;"> </label> 
				                			
										</div>

										<div class="box-body">
											<g:form method="post" enctype="multipart/form-data"  controller='extractor' action="saveTxtExtractor" id="${associatedScenario.id}" index="${txtExtractors.size()}" class="formTxt">
												<label for="txtExName${txtExtractors.size()}">
													<g:message code="extractor.extratorName"/></label>
												<input type="text" class="form-control txtExtractorName" name="name" id="txtExtractorName${txtExtractors.size()}" index="${txtExtractors.size()}"/>
												<br/>
												<label for="txtFile"><g:message code="extractor.file"/></label>
													<input type="file" id="txtFile" name="txtFile" />
												<br/>
												<label for="delimiter"><g:message code="extractor.delimiter"/></label>
													<input type="text"  name="delimiter" class="form-control" />
												<br/>
												<label for="txtCases${txtExtractors.size()}">
													<g:message code="text.cases"/>
												</label>
												</br>
												<label style="margin-left:30px;">
													<g:message code="text.all" />
													<input id="txtCasesSwitch${txtExtractors.size()}" class="ios-switch txtCasesSwitch" index="${txtExtractors.size()}" type="checkbox"/>
													<div class="switch"></div>
												</label>
												<input type="text" class="form-control casesInput" id="txtCases${txtExtractors.size()}" placeholder="e.g. 1-4"/>
												<br/>
												<label for="txtTable${txtExtractors.size()}">
													<g:message code="extractor.fieldMap"/>
												</label>
												<div class="col-md-12" style="padding:0px" id="txtTable${txtExtractors.size()}">
													<div class="col-md-8"  style="padding:0px">
														<table class="table table-bordered table-condensed table-hover" id="txtFieldsMap${txtExtractors.size()}">
														    
															<thead>
																<th><g:message code="text.object"/></th>
																<th><g:message code="extractor.txtField"/></th>
																<th></th>
															</thead>
															<tbody>
																
															</tbody>
														</table>
													</div>
												</div>
												<br/>

												<div class="col-md-12" style="padding:0px; margin-bottom: 20px">
													<div class="col-md-8"  style="padding:0px">
														<select id="txtCasesSelect${txtExtractors.size()}" class="form-control">
															<g:each in="${steps.sort{it.execOrder}}" var="step">
																<g:if test="${step.object && step.principalAction.action.name!='genericAction.click'}">
																	<option value="${step.id}"><g:message code="${step.object.name}" /></option>
																</g:if>
															</g:each>
														</select>
													</div>
													
													<div class="col-md-3" style="margin-bottom:20px;">
														<button class="btn btn-primary txt-field-map-button" index="${txtExtractors.size()}">
															<g:message code="text.add"/>
														</button>
													</div>
													
													<br/>
												</div>
												<input type="submit" class="btn btn-primary center-block" value="${message(code:'general.text.save')}"/>
											</g:form>
										</div>

										<div class="box-footer">
											
										</div>
									</div>
								</sec:ifAnyGranted>
							</div>						

							<!--Generador-->
							<div id="generatorDiv">
								<sec:ifAnyGranted roles="${functionality22.roles}">
									<h3><g:message code="extractor.generator"/></h3>
									<g:each in="${generators.sort{it.dateCreated}}" var="generator" status="i">
										<div class="box box-success" idGenerator="${generator.id}">
											<div class="box-header">
												<button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="collapseGen${i}">
													<i class="fa fa-minus"></i>
			                					</button>
			                					<label class="pull-right" style="margin-left:30px;">
				                					<g:message code='text.isEnabled'/>
				                					<g:if test="${generator.enabled}">
														<input id="generatorSwitch${i}" class="ios-switch generatorSwitch" savedId="${generator.id}" type="checkbox" checked>
													</g:if>
													<g:else>
														<input id="generatorSwitch${i}" class="ios-switch generatorSwitch" savedId="${generator.id}" type="checkbox">
													</g:else>		                				
													<div class="switch"></div>
												</label>			
				                				<label id="generatorHeader${i}" style="font-family: 'Source Sans Pro', sans-serif; font-size:18px; font-weight: 500;">${generator.name} </label> 
				                				<i class="fa fa-floppy-o"></i>
					                			<i class="fa fa-trash" style="color:red; cursor:pointer" index="${i}" onclick="confirmGeneratorDelete(${generator.id}, ${i})"></i>
											</div>
											<div class="box-body" id="collapsableGen${i}">
												
												<!--Nombre-->
												
												<label for="genName${i}"><g:message code="extractor.generatorName"/></label>
												<input type="text" class="form-control generatorName" id="generatorName${i}" index="${i}" value="${generator.name}" />
												<br/>
												
												<!--Tipo de Generación-->
												
												<label for="genType${i}"><g:message code="extractor.generatorType"/></label>
												<select class="form-control genType" id="genType${i}" index="${i}">
													<option value="1"><g:message code="extractor.generatorTypeString"/></option>
													<option value="2"><g:message code="extractor.generatorTypeNumeric"/></option>
													<!--<option value="3"><g:message code="extractor.generatorTypeFormat"/></option>-->
												</select>
												<br/>

												<script>
													$('#genType${i}').val("${generator.type}")
												</script>
												
												<!--Radio Seleccion-->
												
												<div class="col-md-12" style="padding:0px" id="genRadios${i}">
													<div class="col-md-8" style="padding:0px">
														<input type="radio" id="genLength${i}" name="length${i}" class="genLength" index="${i}" value="genLength"> <g:message code="extractor.generatorLength"/>
		  												<input type="radio" id="genPattern${i}" name="length${i}" class="genPattern" index="${i}" value="genPattern"> <g:message code="extractor.generatorCompound"/>
													</div>
												</div>
												<br/>
												<br/>									

												<!--Longitud-->
												
												<div id="divLength${i}" index="${i}">
													<label for="genLength${i}"><g:message code="extractor.generatorLength"/></label>
													<input type="number" class="form-control" id="generatorLength${i}" min="1" max="150" index="${i}" value="${generator.length}" />
													<br/>
												</div>
												
												<!--Patrón-->
												
												<div id="divPattern${i}" style="display:none;" index="${i}">
													<label for="genPattern${i}"><g:message code="extractor.generatorPattern"/></label>
													<input type="text" class="form-control" id="generatorPattern${i}" index="${i}" value="${generator.pattern}" />
													<br/>
												</div>
												
												<!--Rango Inicial-->
												
												<div id="divRangeInit${i}" style="display:none;" index="${i}">
													<label for="genRangeInit${i}"><g:message code="extractor.generatorRangeInit"/></label>
													<input type="number" class="form-control" id="generatorRangeInit${i}" min="1" index="${i}" value="${generator.rangeInit}" />
													<br/>
												</div>
												
												<!--Rango Final-->
												
												<div id="divRangeEnd${i}" style="display:none;" index="${i}">
													<label for="genRangeEnd${i}"><g:message code="extractor.generatorRangeEnd"/></label>
													<input type="number" class="form-control" id="generatorRangeEnd${i}" min="1" index="${i}" value="${generator.rangeEnd}" />
													<br/>
												</div>
												
												<!--Casos seleccionados-->
												
												<label for="genCases${i}">
													<g:message code="text.cases"/>
												</label>
												</br>
												<label style="margin-left:30px;">
													<g:message code="text.all" />
													<input id="genCasesSwitch${i}" class="ios-switch genCasesSwitch" index="${i}" type="checkbox"/>
													<div class="switch"></div>
												</label>
												<input type="text" class="form-control casesInput" id="genCases${i}" placeholder="e.g. 1-4" />
												<br/>

												<script>
													var cases = '${generator.cases}'
													if(cases != 'ALL'){
														$("#genCasesSwitch${i}").prop('checked', false)
														$('#genCases${i}').show()
														$('#genCases${i}').val('${generator.cases}')												
													} else {
														$("#genCasesSwitch${i}").prop('checked', true)
														$('#genCases${i}').hide()
													}
												</script>
												
												<!--Tabla con los Campos para dar generacion-->
												
												<div class="col-md-12" style="padding:0px" id="genTable${i}">
													<div class="col-md-6"  style="padding:0px">
														<table class="table table-bordered table-condensed table-hover" id="genFieldsMap${i}"> 
															<thead>
																<th><g:message code="text.object"/></th>													
																<th></th>
															</thead>
															<tbody>
																<g:each in="${generator.fieldsMap.split(';')}" var="map">
																	<tr index="${status}" stepname="${steps.find{String.valueOf(it.id)==map}?.object?.name}" stepid="${map}" class="maptr"> <td> <small class="label label-primary" style="margin-top:2px">${steps.find{String.valueOf(it.id)==map}?.object?.name}</small></td><td style="text-align:center"><i index="${i}" stepid='${map}'  id="geni${map}" onclick="deleteMap('geni${map}', ${i}, 'gen')" class="fa fa-trash maptrash" style="color:red; cursor:pointer"></i></td></tr>
																</g:each>
															</tbody>
														</table>
													</div>
												</div>
												<br/>
												
												<!--Div Campos a Seleccionar-->
												
												<div class="col-md-12" style="padding:0px; margin-bottom: 20px">
													<div class="col-md-8"  style="padding:0px">
														<select id="genCasesSelect${i}" class="form-control">
															<g:each in="${steps.sort{it.execOrder}}" var="step">
																<g:if test="${step.object && step.principalAction.action.name!='genericAction.click' && !(generator.fieldsMap.contains(String.valueOf(step.id)))}">
																	<option value="${step.id}"><g:message code="${step.object.name}" /></option>
																</g:if>
															</g:each>
														</select>
													</div>											
													<div class="col-md-3" style="margin-bottom:20px;">
														<button class="btn btn-primary gen-field-map-button" index="${i}">
															<g:message code="text.add"/>
														</button>
													</div>

												</div>
												<br/>
												<button class="btn btn-primary generator-update-button center-block"  index="${i}" id="${generator.id}">
													<g:message code="default.button.update.label"/>
												</button>
											</div>	
											<div class="box-footer">
												
											</div>
										</div>
										<script>
											//Mostrar Campos de Texto
											var typeGen = '${generator.type}'
											switch(typeGen){
												case '1':
													var length = '${generator.length}'
													if(length != ''){
														$("#genLength${i}").prop('checked', true)
														$("#divLength${i}").show()
														$("#divPattern${i}").hide()												
													} else {
														$("#genPattern${i}").prop('checked', true)
														$("#divLength${i}").hide()
														$("#divPattern${i}").show()
													}
													$("#divRangeInit${i}").hide()
													$("#divRangeEnd${i}").hide()					
													break
												case '2':
													var length = '${generator.length}'
													if(length != ''){
														$("#genLength${i}").prop('checked', true)
														$("#divLength${i}").show()
														$("#divRangeInit${i}").hide()
														$("#divRangeEnd${i}").hide()
													} else {
														$("#genPattern${i}").prop('checked', true)
														$("#divLength${i}").hide()
														$("#divRangeInit${i}").show()
														$("#divRangeEnd${i}").show()
													}
													$("#divPattern${i}").hide()
													break
											}


											element =$("#collapseGen${i}")
											//Find the box parent
											var box = element.parents(".box").first();
											//Find the body and the footer
											var box_content = box.find("> .box-body, > .box-footer");
											if (!box.hasClass("collapsed-box")) {
											    //Convert minus into plus
											    element.children(":first")
											            .removeClass("fa fa-minus")
											            .addClass("fa fa-plus");
											    //Hide the content
											    box_content.slideUp(300, function () {
											        box.addClass("collapsed-box");
											    });
											} else {
												//Convert plus into minus
												element.children(":first")
												    .removeClass("fa fa-plus")
												    .addClass("fa fa-minus");
												//Show the content
												box_content.slideDown(300, function () {
												    box.removeClass("collapsed-box");
												});
											}
										</script>
									</g:each>
									<div class="box box-success">
										<div class="box-header">
											<button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="collapseGen${generators.size()}">
												<i class="fa fa-minus"></i>
		                					</button>
		                					<label class="pull-right" style="margin-left:30px;">
			                					<g:message code='text.isEnabled'/>
												<input id="generatorSwitch${generators.size()}" class="ios-switch generatorSwitch" savedId="none" type="checkbox" checked>		                				
												<div class="switch"></div>
											</label>			
			                				<label id="generatorHeader${generators.size()}" style="font-family: 'Source Sans Pro', sans-serif; font-size:18px; font-weight: 500;"> </label> 
										</div>
										<div class="box-body">
											
											<!--Nombre-->
											
											<label for="genName${generators.size()}"><g:message code="extractor.generatorName"/></label>
											<input type="text" class="form-control generatorName" id="generatorName${generators.size()}" index="${generators.size()}"/>
											<br/>
											
											<!--Tipo de Generación-->
											
											<label for="genType${generators.size()}"><g:message code="extractor.generatorType"/></label>
											<select class="form-control genType" id="genType${generators.size()}" index="${generators.size()}">
												<option value="1"><g:message code="extractor.generatorTypeString"/></option>
												<option value="2"><g:message code="extractor.generatorTypeNumeric"/></option>
												<!--<option value="3"><g:message code="extractor.generatorTypeFormat"/></option>-->
											</select>
											<br/>
											
											<!--Radio Seleccion-->
											
											<div class="col-md-12" style="padding:0px" id="genRadios${generators.size()}">
												<div class="col-md-8" style="padding:0px">
													<input type="radio" id="genLength${generators.size()}" name="length${generators.size()}" class="genLength" index="${generators.size()}" value="genLength" checked> <g:message code="extractor.generatorLength"/>
	  												<input type="radio" id="genPattern${generators.size()}" name="length${generators.size()}" class="genPattern" index="${generators.size()}" value="genPattern"> <g:message code="extractor.generatorCompound"/>
												</div>
											</div>
											<br/>
											<br/>
											
											<!--Longitud-->
											
											<div id="divLength${generators.size()}" index="${generators.size()}">
												<label for="genLength${generators.size()}"><g:message code="extractor.generatorLength"/></label>
												<input type="number" class="form-control" id="generatorLength${generators.size()}" min="1" max="150" index="${generators.size()}"/>
												<br/>
											</div>
											
											<!--Patrón-->
											
											<div id="divPattern${generators.size()}" style="display:none;" index="${generators.size()}">
												<label for="genPattern${generators.size()}"><g:message code="extractor.generatorPattern"/></label>
												<input type="text" class="form-control" id="generatorPattern${generators.size()}" index="${generators.size()}"/>
												<br/>
											</div>
											
											<!--Rango Inicial-->
											
											<div id="divRangeInit${generators.size()}" style="display:none;" index="${generators.size()}">
												<label for="genRangeInit${generators.size()}"><g:message code="extractor.generatorRangeInit"/></label>
												<input type="number" class="form-control" id="generatorRangeInit${generators.size()}" min="1" index="${generators.size()}"/>
												<br/>
											</div>
											
											<!--Rango Final-->
											
											<div id="divRangeEnd${generators.size()}" style="display:none;" index="${generators.size()}">
												<label for="genRangeEnd${generators.size()}"><g:message code="extractor.generatorRangeEnd"/></label>
												<input type="number" class="form-control" id="generatorRangeEnd${generators.size()}" min="1" index="${generators.size()}"/>
												<br/>
											</div>
											
											<!--Casos seleccionados-->
											
											<label for="genCases${generators.size()}">
												<g:message code="text.cases"/>
											</label>
											</br>
											<label style="margin-left:30px;">
												<g:message code="text.all" />
												<input id="genCasesSwitch${generators.size()}" class="ios-switch genCasesSwitch" index="${generators.size()}" type="checkbox"/>
												<div class="switch"></div>
											</label>
											<input type="text" class="form-control casesInput" id="genCases${generators.size()}" placeholder="e.g. 1-4"/>
											<br/>
											
											<!--Tabla con los Campos para dar generacion-->
											
											<div class="col-md-12" style="padding:0px" id="genTable${generators.size()}">
												<div class="col-md-6"  style="padding:0px">
													<table class="table table-bordered table-condensed table-hover" id="genFieldsMap${generators.size()}"> 
														<thead>
															<th><g:message code="text.object"/></th>													
															<th></th>
														</thead>
														<tbody>
															
														</tbody>
													</table>
												</div>
											</div>
											<br/>
											
											<!--Div Campos a Seleccionar-->
											
											<div class="col-md-12" style="padding:0px; margin-bottom: 20px">
												<div class="col-md-8"  style="padding:0px">
													<select id="genCasesSelect${generators.size()}" class="form-control">
														<g:each in="${steps.sort{it.execOrder}}" var="step">
															<g:if test="${step.object && step.principalAction.action.name!='genericAction.click'}">
																<option value="${step.id}"><g:message code="${step.object.name}" /></option>
															</g:if>
														</g:each>
													</select>
												</div>											
												<div class="col-md-3" style="margin-bottom:20px;">
													<button class="btn btn-primary gen-field-map-button" index="${generators.size()}">
														<g:message code="text.add"/>
													</button>
												</div>

											</div>
											<br/>
											<button class="btn btn-primary center-block generator-save-button"  index="${generators.size()}">
												<g:message code="general.text.save"/>
											</button>											
										</div>	
										<div class="box-footer">										
										</div>
									</div>
								</sec:ifAnyGranted>
							</div>							
						</div>
					</div>
				</div>
		<!-- /.col -->
			</div>
		</div>


	<!-- Modal de confirmación de borrado de Case -->
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
						<g:message code="general.text.confirmMessage" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="deleteCase()"> <g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->



<!-- Modal de confirmación de borrado de BDExtractor -->
	<div id="dbExtractorConfirmModal" class="modal fade " role="dialog">
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
						<g:message code="general.text.confirmMessage" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="deleteDBExtractor()"> <g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->




	<!-- Modal de confirmación de borrado de BDExtractor -->
	<div id="txtExtractorConfirmModal" class="modal fade " role="dialog">
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
						<g:message code="general.text.confirmMessage" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="deleteTxtExtractor()"> <g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->

	<!-- Modal de confirmación de borrado de Generador -->
	<div id="generatorConfirmModal" class="modal fade " role="dialog">
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
						<g:message code="general.text.confirmMessage" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="deleteGenerator()"> <g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->

	<!-- Modal de error de registro de case -->
	<div id="newCaseErrorModal" class="modal fade " role="dialog">
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
					<p id="newCaseErrorMessage"></p>
				</div>
			</div>
		</div>
	</div>
	<!-- Fin del modal de error de registro de case -->










	<!-- Modal de edición de case -->
	<div id="editCaseModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-info">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.edit" /> <g:message code="text.case" />
					</h4>
				</div>
				<div class="modal-body">
					<div>
						<label><g:message code="text.orientation"/></label><br/>
						<label class="radio-inline label label-danger" style="margin-left:20px">
					      <input type="radio" id="orientationRadioError" name="optradio" ><g:message code="general.error"/>
					    </label>
					    <label class="radio-inline label label-success" style="margin-left:20px">
					      <input type="radio" id="orientationRadioSuccess" name="optradio" checked><g:message code="general.success"/>
					    </label>
						</br>
						</br>
						<label id="editStepErrorLabel" style="display:none"><g:message code="text.stepError"/></label>
						<div class="btn-group open" style="width:100%; display:none" id="editStepError">
							<button aria-expanded="true" class="btn btn-default select-dropdown-principal-button" data-toggle="dropdown" onclick="$('.dropdown-toggle').dropdown('steperrordropdown')" style="border-color: rgb(210, 214, 222) rgb(173, 173, 173) rgb(210, 214, 222) rgb(210, 214, 222); height:34px" type="button"><label id="firstEditStepErrorLabel" style="width:80%">${associatedScenario.steps.size()>0? associatedScenario.steps.sort{it.execOrder}[0].object?.name:""}</label><label class="label label-info" id="lastEditStepErrorLabel" style="width:12%">${associatedScenario.steps.size()>0? message(code:associatedScenario.steps.sort{it.execOrder}[0].principalAction.action?.name):""}</label></button> <button aria-expanded="false" aria-haspopup="true" class="btn btn-default dropdown-toggle" data-toggle="dropdown" id="editActionsDropdownBtn" style="width:3%; padding-right:2px; padding-left:2px; background-color: #E1E1E1; border-color:#ADADAD;" type="button"><span class="caret"></span></button>
							<ul class="dropdown-menu select-dropdown-ul" id="steperrordropdown">
								<g:each in="${associatedScenario.steps.sort{it.execOrder}}" var="step">
									<li class="select-dropdown-li" stepid="${step.id}" object="${step.object?.name}" action="${message(code:step.principalAction.action.name)}">
										<a href="#" onclick="changeStepError(this); return false"><label class="select-dropdown-li-first">${step.object?.name}</label><small class="label label-primary select-dropdown-li-last">${message(code:step.principalAction.action.name)}</small></a>
									</li>
								</g:each>
							</ul>
						</div>
						<label for="editName" >ID</label>
						<input class="form-control editInput" id="editName" type="text"/>
						<br/>
						<label for="editDescription"><g:message code='text.description'/></label>
						<textarea class="form-control editInput" id="editDescription" style="resize:vertical"></textarea>
						<br/>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Fin del modal de edición de case -->



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
					<p id="expiredSessionAlert">
						<g:message code="general.text.expiredSessionText" />
					</p>
				</div> 
			</div>
		</div>
	</div>
	<!-- Fin del modal de expiración de sesión-->





	<!-- Modal de exito para ejecucion -->
	<div id="executionSuccessModal" class="modal fade " role="dialog">
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
					<p id="executionSuccessMessage"></p>
				</div>
			</div>
		</div>
	</div>
	<!-- Fin del modal de exito para ejecuciones -->





	<!-- Modal de error para ejecuciones -->
	<div id="executionErrorModal" class="modal fade " role="dialog">
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
					<p id="executionErrorMessage"></p>
				</div>
			</div>
		</div>
	</div>
	<!-- Fin del modal de error para ejecuciones -->






	<!-- Modal de selección de navegador  -->

	<div id="browserSelectionModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-info">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					
					<h4 class="modal-title">
						<g:message code="text.browserSelection" />
					</h4>
				</div>
				<div class="modal-body">
						<div class="row col-md-12">
								<div class="col-md-2 col-xs-4" id="divch">
									<asset:image src="browsers/ch.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkch" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
							
								<div class="col-md-2 col-xs-4" id="divff">
									<asset:image src="browsers/ff.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkff" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="divie">
									<asset:image src="browsers/ie.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkie" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="divsa">
									<asset:image src="browsers/sa.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checksa" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="dived">
									<asset:image src="browsers/ed.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checked" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="divop">
									<asset:image src="browsers/op.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkop" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
						</div>
						<br>
						<br>
						<br>
						<br>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-info"
						onclick="executeWebScenario()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>

		</div>
	</div>
	<!-- Fin del modal de selección de navegador-->




	<!-- Modal de confirmación de forzado de la ejecución -->
	<div id="forceExecutionModal" class="modal fade " role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header alert-warning">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.attention" />
					</h4>
				</div>
				<div class="modal-body">
					<p>
						<g:message code="text.forceExecution.message" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="forceExecution()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->

	<!-- Modal de confirmación de borrado masivo de Casos -->
	<div id="masiveDeleteConfirmModal" class="modal fade " role="dialog">
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
						<g:message code="general.text.confirmMessage" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
					onclick="masiveDeleteCases()">
					<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación de borrado masivo de Casos -->
	
	<!-- plantilla para modal de restricciones cuenta demo-->
	<g:render template="/user/restrictionsDemo"/>

	<script id="testScript">
		var editingId=null;
		var deletingId = null;
		var currentPage = 0;
		var numPerPage = 10;
		var editPrincipalHtml=""
		var userBrowsers = "${browsers}"
		var dbConectionRequestId = null
		var labelDbConection = null
		var processingConection = false
		var currentDbConectionButton = null
		var responseInterval = null
		var executionResponseInterval = null
		var bdGenerators = ${bdExtractors.size()}
		var generatorSize = ${generators.size()}
		var curDBExtractorDeleteId =null
		var curDBExtractorDeleteIndex = null
		var curTxtExtractorDeleteId =null
		var curTxtExtractorDeleteIndex = null
		var curGeneratorDeleteId =null
		var curGeneratorDeleteIndex = null

		var curExecutionRequestId = null
		var executionType =""
		var casesToDelete = ""
		var currentStepError = ${associatedScenario.steps.sort{it.execOrder}[0]?.id}
		


		$(window).load( function(){

			//$('#listTab').removeClass('active')
			if("${additionalJS}" !=''){
				${additionalJS.replaceAll('mmm','\\$')}
			}
			
			notificationsInterval = setInterval(getNotifications, 8000);
			enableSearch()
			makeTablePaginated()
			$("#casesTable tbody").sortable({
				stop: function(event,ui) {
					saveOrder()
				}
			}).disableSelection();
			$('[data-toggle="popover"]').popover();  
			$('.duplicateCell').popover(); 
			runDBExtractorScripts();  

		})


		function changeStepError(element){
			var object = $(element).closest('li').attr('object')
			var action = $(element).closest('li').attr('action')
			var id = $(element).closest('li').attr('stepid')
			currentStepError = id
			$('#errorOriented'+editingId).attr('steperrorid',currentStepError)
			$('#errorOriented'+editingId).attr('action',action)
			$('#errorOriented'+editingId).attr('action',object)
			$("#firstEditStepErrorLabel").text(object)
			$("#lastEditStepErrorLabel").text(action)
			updateCase()
		}

		$("#orientationRadioSuccess").change(function(){
			if($(this).prop("checked")){
				$('#editStepError').hide()
				$('#editStepErrorLabel').hide()
				$('#errorOriented'+editingId).html($("<small class='label label-success'>${message(code:'general.success')}</small>"))
			}
			$("#errorOriented"+editingId).attr('errororiented','false')
			updateCase()
		})
		$("#orientationRadioError").change(function(){
			if($(this).prop("checked")){
				$('#editStepError').show()
				$('#editStepErrorLabel').show()
				$('#errorOriented'+editingId).html($("<small class='label label-danger'>${message(code:'general.error')}</small>"))
			}
			$("#errorOriented"+editingId).attr('errororiented','true')
			updateCase()

		})


		function saveOrder(){
			var text = $('#casesTable tbody').find('tr')
			var order = ""
			for(var i=0;i<text.length;i++){
				order+=text[i].id
				if(i<text.length-1)
					order+=","
		  	}	
	        	
	       	 $.ajax({
	            method: 'POST',
	            url: "${createLink(action:'saveOrder', controller:'case')}",
	            data:{
	                order: order,
	                id: ${scenarioId},
	                },
	             success: function(dataCheck) {
	             },
	             error: function(status, text, result, xhr) {
	                  	$('#newCaseErrorMessage').html("Unexpected error")
						$('#newCaseErrorModal').modal('show');
	             }
	         });	
			}


		$('#expiredSessionModal').on('hidden.bs.modal', function () {
			location.reload()
		})
		$('.modal').on('hidden.bs.modal', function() {
			$("body").css('padding-right','0px')
		})

		$('#selectAllObjects').change(function(){
			if(this.checked) {
				$('.trSelectable').each(function(i, obj) {
					$(this).css('background-color','#ccd9ff')
					$(this).attr('select','1')
				});
			}
			else{
				$('.trSelectable').each(function(i, obj) {
					$(this).css('background-color','')
					$(this).attr('select','0')
				});
			}
		})
		
	$(".duplicateCell").on('show.bs.popover', function(){
		$('td').filter(
	    		function() 
	    		{ 
	    			return $(this).is("[aria-describedby]") 
	    		}
	    	).not(this).popover('hide');
	})


		$("[data-toggle='popover']").on('show.bs.popover', function(){
			$('td').filter(
	    		function() 
	    		{ 
	    			return $(this).is("[aria-describedby]") 
	    		}
	    	).not(this).popover('hide');
		})



		 $(document).keyup(function(e) {

		    var code = e.keyCode || e.which;
		    if (e.shiftKey) {
		    	if(($('.popover').size())==1){
		    		 switch(e.which) {
					        case 37: 

					        		$('[aria-describedby="'+$('.popover').first().attr('id')+'"]').prev('td').click()
					        	
					        	
					        break;

					        case 39: 
						        	$('[aria-describedby="'+$('.popover').first().attr('id')+'"]').next('td').click()

					        break;

					        default: return; // exit this handler for other keys
					    }
		    	}
		    
		    }
		 });

		
		$("[data-toggle='popover']").on('shown.bs.popover', function(){
			
	    var tdId=$(this).attr('id').substring(2)
		if($('#action'+$(this).attr('principal')).prop('tagName')=='INPUT' || $('#action'+$(this).attr('principal')).prop('tagName')=='SELECT' )
	    	
	    	var value =""
	    console.log($('#small'+tdId).html())
	    	var index=$('#small'+tdId).html().indexOf('<span')
	    	if(index>-1){
	    		value=$('#small'+tdId).html().substring(0,index)	
	    	}else{
	    		value = $('#small'+tdId).text()
	    	}
			if($('#action'+$(this).attr('principal')).prop('tagName')=='SELECT'){
				$('#action'+$(this).attr('principal')+" option").filter(function() {
	    			return $(this).text() == value.trim(); 
				}).prop('selected', true);
			}	
			if($('#action'+$(this).attr('principal')).prop('type')=='checkbox'){
				if(value.indexOf('OFF')>-1){
					$('#action'+$(this).attr('principal')).prop('checked', false)
				}
			}
			$('.actionInput').first().focus()


			$('.principalCheck').change(function(){
				if($(this).prop('checked')){
					$('#small'+$(this).attr('step')).removeClass()
					$('#small'+$(this).attr('step')).addClass('label label-primary')
				}
				else{
					$('#small'+$(this).attr('step')).removeClass()
					$('#small'+$(this).attr('step')).addClass('label label-default')
				}
			})
	    });


	   	$("[data-toggle='popover']").on('hide.bs.popover', function(){

	    	var tdId=$(this).attr('id').substring(2)
	    	var value = $('#action'+$(this).attr('principal')).val()

	    	if($('#action'+$(this).attr('principal')).prop('tagName')=='INPUT' || $('#action'+$(this).attr('principal')).prop('tagName')=='SELECT'  ){
	    		if($('#action'+$(this).attr('principal')).attr('type')=="checkbox"){
	    			if($('#action'+$(this).attr('principal')).prop('checked')){
	    				value="ON"
	    			}
	    			else{
	    				value="OFF"
	    			}
	    		}

	    		var index=$('#small'+tdId).html().indexOf('<span')
	    		if(index>-1){
	    			var badgeHtml=$('#small'+tdId).html().substring(index)
	    			$('#small'+tdId).html(value+" "+badgeHtml)	
	    		}else{
	    			$('#small'+tdId).text(value+" ")	
	    		}
	    	}
	    	
	    		var ids=""
	    		var values=""
	    		var stateIds =""
	    		var states =""
				$('.actionInput').each(function(){
					var curId = $(this).attr('id').substring(6)
					if(stateIds.indexOf(curId+"#;#")==-1){
						stateIds+=curId+"#;#"
					}
					else{
						stateIds+="R"+curId+"#;#"
					}
					if($('#check'+curId).prop('checked')){

						states+="true#;#"
					}
					else
					{
						states+="false#;#"
					}

					if($(this).prop('tagName')=='INPUT' || $(this).prop('tagName')=='SELECT' || $(this).prop('tagName')=='SMALL'){
						if(ids.indexOf($(this).attr('id').substring(6)+"#;#")==-1)
							ids+=$(this).attr('id').substring(6)+"#;#"
						else
							ids+="R"+$(this).attr('id').substring(6)+"#;#"
						if($(this).attr('type')=="checkbox"){
							if($(this).prop('checked')){
								values+="ON"+'#;#'
							}
							else{
								values+="OFF"+'#;#'
							}
						}
						else
							values+=$(this).val()+'#;#'
					}
				})
				if(ids!=""){
						$.ajax({
						method: 'POST',
						url: "${createLink(action:'changeValue', controller:'case')}",
						data:{
							ids:ids,
							values:values,
							stateIds:stateIds,
							states:states

						},
						success: function(result) {
							$('#'+result.idTd).attr('data-content',result.text)
						},
						error: function(status, text, result, xhr) {
							alert(status.responseText)
						}
					}); 
				}
		   	
	    })

		$("[data-toggle='tab']").click(function(){
				hideAllPops()
		})

		function hideAllPops(){
	    	$('td').filter(
	    		function() 
	    		{ 
	    			return $(this).is("[aria-describedby]") 
	    		}
	    	).popover('hide');
	    }

	    $(document).click(function(event){
	    	if(!($(event.target).hasClass('label') && ($(event.target).prop('tagName')=="SMALL" || $(event.target).prop('tagName')=="TD" )) && $(event.target).parents('.popover').size()==0){
	    		$('td').filter(
		    		function() 
		    		{ 
		    			return $(this).is("[aria-describedby]") 
		    		}
		    	).not($(event.target).closest('td')).popover('hide');
		    	}
	    })

		$('.trSelectable').click(function(){
			var selected = $(this).attr('select')
			if(selected =="0"){
				$(this).css('background-color','#ccd9ff')
				$(this).attr('select','1')
			}
			else{
				$(this).css('background-color','')
				$(this).attr('select','0')
			}
		})


		function setDeletingId(newId){
			deletingId = newId
			$('#confirmModal').modal('show');
		}



		function deleteCase() {
			$.ajax({
				method: "POST",
				url: "${createLink(action:'delete', controller:'case', )}",
				data: { 
					id: deletingId, 
					scenarioId: ${scenarioId}, 
				}, 
				success: function(result) {
					location.reload()
				},
				error: function(status, text, result, xhr) {
					showDeleteErrorModal(status.responseText);
				}
			});
		}


		function showDeleteErrorModal(error) {
			$('#confirmModal').modal('hide');
			$('#newCaseErrorMessage').html(error)
			$('#newCaseErrorModal').modal('show');
		}


	    function duplicate(id){
	    	var cantidad = parseInt($('#duplicateText'+id).val()) || 0
	    	if(cantidad < 1){
	    		$('#duplicateText'+id).val(1)
	    	}
	    	else{
	    		$.ajax({
					method: 'POST',
					url: "${createLink(action:'duplicate', controller:'case')}",
					data:{
						id: id,
						qty:cantidad,
					},
					success: function(dataCheck) {
						location.reload()
					},
					error: function(status, text, result, xhr) {
						console.log(text);
						$('#newCaseErrorMessage').html("${message(code:'text.noRecord')}")
						$('#newCaseErrorModal').modal('show');
					}
				});
	 			
	   				
	   		}
	    		
	    }


		$("#selectAllSwitch").change(function() {


			if(this.checked) {
				$('.enabledcheck').each(function(i, obj) {
					$(this).prop('checked',true)
					$(this).change()
				});


			}
			else{
				$('.enabledcheck').each(function(i, obj) {
					$(this).prop('checked',false)
					$(this).change()
				});
			}
		})


	$('.enabledcheck').change(function(){
		var id=$(this).attr('id')
		var active = $(this).prop('checked')
		$.ajax({
			method: 'POST',
			url: "${createLink(action:'changeEnabled', controller:'case')}",
			data:{
				id: id,
				active:active,
			},
			success: function(dataCheck) {
			
			},
			error: function(status, text, result, xhr) {
				alert("error")
			}
		});
	})





	$('#formNewCaseButton').click(function() {
		var button = $(this)
		$(button).prop("disabled", true)
		$(button).html("<i class='fa fa-spinner fa-spin'></i>");
		var description = $('#newCaseDescription').val()
		
		$.ajax({
			method: 'POST',
			url: "${createLink(action:'create', controller:'case')}",
			data:{
				id: ${scenarioId},
				description:description,
			},
			success: function(dataCheck) {
				location.reload()
			},
			error: function(status, text, result, xhr) {
				$(button).html("${message(code:'general.text.save')}")
				$(button).prop("disabled", false)
				$('#newCaseErrorMessage').html(status.responseText)
				$('#newCaseErrorModal').modal('show');
			}
		});

	});


	function showEditCaseModal(id){
		editingId=id
		$('#editName').val($('#name'+editingId).text().trim())
		$('#editDescription').val($('#description'+editingId).attr('description'))
		$('#editCaseModal').modal('show')
		if($("#errorOriented"+id).attr('errororiented')=="true"){
			$('#orientationRadioError').prop('checked', true)
			$('#orientationRadioSuccess').prop('checked', false)
			$('#editStepError').show()
			$('#editStepErrorLabel').show()
			currentStepError = $("#errorOriented"+id).attr('steperrorid')
			$('#firstEditStepErrorLabel').text($("#errorOriented"+id).attr('object'))
			$('#lastEditStepErrorLabel').text($("#errorOriented"+id).attr('action'))

		}
		else{
			$('#orientationRadioError').prop('checked', false)
			$('#orientationRadioSuccess').prop('checked', true)
			$('#editStepError').hide()
			$('#editStepErrorLabel').hide()

		}
	}





	$('.editInput').keyup(function(){
		if(editingId!=null)
			updateCase()
	})

	function updateCase(){
		
		$.ajax({
			method: 'POST',
			url: "${createLink(action:'update', controller:'case')}",
			data:{
				id: editingId,
				description:$('#editDescription').val(),
				name:$('#editName').val(),
				errorOriented:""+$('#orientationRadioError').prop('checked')+"",
				stepErrorId: currentStepError
			},
			success: function(dataCheck, result) {
				$('#name'+editingId).text($('#editName').val())
				$('#description'+editingId).attr('description',$('#editDescription').val())
				var description = $('#editDescription').val()
				if(description.length>40)
					$('#description'+editingId).text(description.substring(0,40)+"...")
				else{
					$('#description'+editingId).text(description)
				}
			}, error: function(status){

			}
			
		});
	}


		function getBrowsers(id){
			$.ajax({
				method: 'POST',
				url: "${createLink(action:'getBrowsers', controller:'user')}",
				data:{
					id:id
				},
				
				success: function(result) {
					console.log('success: '+result)

					userBrowsers = result
					console.log('userBrowsers: '+userBrowsers)
					if(result.indexOf('CH')==-1){
						$('#divch').css('display', 'none')
					}
					if(result.indexOf('FF')==-1){
						$('#divff').css('display', 'none')
					}
					if(result.indexOf('IE')==-1){
						$('#divie').css('display', 'none')
					}
					if(result.indexOf('ED')==-1){
						$('#dived').css('display', 'none')
					}
					if(result.indexOf('SA')==-1){
						$('#divsa').css('display', 'none')
					}
					if(result.indexOf('OP')==-1){
						$('#divop').css('display', 'none')
					}
					$("#checkch").prop("checked", false);
					$("#checkff").prop("checked", false);
					$("#checkie").prop("checked", false);
					$("#checksa").prop("checked", false);
					$("#checked").prop("checked", false);
					$("#checkop").prop("checked", false);
					webScenario = id
					console.log('browsers: '+userBrowsers)
					$('#browserSelectionModal').modal('show')
				},
				error: function(status, text, result, xhr) {
						$("#executionErrorMessage").html(status.responseText)
						$("#executionErrorModal").modal('show')
				}
			});

		}



		function showBrowsers(id){
			getBrowsers(id)
			
			
		}

		function executeWebScenario(){
				
				var browsers =""
				if($('#checkch').prop('checked')){
					browsers+='CH,'}
				if($('#checkff').prop('checked')){
					browsers+='FF,'}
				if($('#checkie').prop('checked')){
					browsers+='IE,'}
				if($('#checksa').prop('checked')){
					browsers+='SA,'}
				if($('#checked').prop('checked')){
					browsers+='ED,'}
				if($('#checkop').prop('checked')){
					browsers+='OP,'}
				if(browsers!=""){
					$('#browserSelectionModal').modal('hide')
					$.ajax({
					   url: "${createLink(action:'executeWebScenario', controller:'execution')}",
					   method:"POST",
						data:{  id: webScenario,
								browsers: browsers,
								forced: false,
							},
						success : function(result, status) {
							
							if(result=="queue"){
								$('#executionSuccessMessage').html("${message(code:'scenario.execution.queued')}")
								$('#executionSuccessModal').modal('show');
								setTimeout(function(){
	  								$('#executionSuccessModal').modal('hide')
								}, 3400)
							}
							else if(result=="direct") {
								$('#executionSuccessMessage').html("${message(code:'scenario.execution.direct')}")
								$('#executionSuccessModal').modal('show');
								setTimeout(function(){
	  								$('#executionSuccessModal').modal('hide')
								}, 3400)
							}
							else if(result=="confirm"){
								oldBrowsers = browsers
								oldExecutingId=webScenario
								oldExecutionType=1
								$('#forceExecutionModal').modal('show')
							}
							else if(result.indexOf("directWithExtractors")>-1){
								executionType = "direct"
								$('#executionSuccessMessage').html("${message(code:'execution.extractingData')}")
								$('#executionSuccessModal').modal('show');

								curExecutionRequestId = result.substring(result.indexOf(":")+1)
								executionResponseInterval = setInterval(checkExecutionResponse, 600);
							}
							else if(result.indexOf("queueWithExtractors")>-1){
								executionType = "queue"
								$('#executionSuccessMessage').html("${message(code:'execution.extractingData')}")
								$('#executionSuccessModal').modal('show');

								curExecutionRequestId = result.substring(result.indexOf(":")+1)
								executionResponseInterval = setInterval(checkExecutionResponse, 600);
							}


						},error: function(status, text, result, xhr){

								$("#executionErrorMessage").html(status.responseText)
								$("#executionErrorModal").modal('show')
								}
					});
				}
				 
			}


			function forceExecution(){
				$('#forceExecutionModal').modal('hide')
				if(oldExecutionType==1){
					$.ajax({
					   url: "${createLink(action:'executeWebScenario', controller:'execution')}",
					   method:"POST",
					data:{ id: oldExecutingId,
							browsers: browsers,
							forced: true,
						},
						success : function(result, status) {
							if(result=="queue"){
								$('#executionSuccessMessage').html("${message(code:'scenario.execution.queued')}")
								$('#executionSuccessModal').modal('show');
							}
							else if(result=="direct") {
								$('#executionSuccessMessage').html("${message(code:'scenario.execution.direct')}")
								$('#executionSuccessModal').modal('show');
							}
						},
						error: function(status, text, result, xhr){
							$("#executionErrorMessage").html(status.responseText)
							$("#executionErrorModal").modal('show')
							}
					});
				}
				if(oldExecutionType==2){
					$.ajax({
					   url: "${createLink(action:'executeScenario', controller:'execution')}",
					   method:"POST",
					data:{ id: oldExecutingId,
							forced: true,
						},
						success : function(result, status) {
							if(result=="queue"){
								$('#executionSuccessMessage').html("${message(code:'scenario.execution.queued')}")
								$('#executionSuccessModal').modal('show');
							}
							else if(result=="direct") {
								$('#executionSuccessMessage').html("${message(code:'scenario.execution.direct')}")
								$('#executionSuccessModal').modal('show');
							}
						},
						error: function(status, text, result, xhr){
							$("#executionErrorMessage").html(status.responseText)
							$("#executionErrorModal").modal('show')
							}
					});

				}
				
			}

		
			function executeScenario(id){
				 $.ajax({
					   url: "${createLink(action:'executeScenario', controller:'execution')}",
					   method:"POST",
					data:{ id: id,
						forced:false},
					success : function(result, status) {
						if(result=="queue"){
							('#executionSuccessMessage').html("${message(code:'scenario.execution.queued')}")
							$('#executionSuccessModal').modal('show');
						}
						else if(result=="direct") {
							$('#executionSuccessMessage').html("${message(code:'scenario.execution.direct')}")
							$('#executionSuccessModal').modal('show');
						}
						else if(result=="confirm"){
							oldExecutingId=webScenario
							oldExecutionType=2
							$('#forceExecutionModal').modal('show')
						}
					},
					error: function(status, text, result, xhr){
						$("#executionErrorMessage").html(status.responseText)
						$("#executionErrorModal").modal('show')
						}
				});
			}	



function changeSmallColor(element){
	if($(element).prop('checked')){
		$('#small'+$(element).attr('step')).removeClass()
		$('#small'+$(element).attr('step')).addClass('label label-primary')
	}
	else{
		$('#small'+$(element).attr('step')).removeClass()
		$('#small'+$(element).attr('step')).addClass('label label-default')
	}

	changeActionState(element)

}


function changeActionState(element){
	var id=$(element).attr('id').substring($(element).attr('id').indexOf('k')+1)
	var state = $(element).prop('checked')?"true":"false"
	 $.ajax({
			url: "${createLink(action:'changeActionState', controller:'case')}",
			method:"POST",
			data:{
				id: id,
				state:state
			},
			success : function(result, status) {
				
			},
			error: function(status, text, result, xhr){
						alert("Unexpected error")
			}
	})
}


function runDBExtractorScripts(){
	
	//Cases switch
	$(".dbCasesSwitch").change(function(){
		if(this.checked){
			$('#dbCases'+$(this).attr('index')).hide()
		}
		else{
			$('#dbCases'+$(this).attr('index')).show()
		}
	})

	
	//Cases switch
	$(".txtCasesSwitch").change(function(){
		if(this.checked){
			$('#txtCases'+$(this).attr('index')).hide()
		}
		else{
			$('#txtCases'+$(this).attr('index')).show()
		}
	})

	//Cases switch
	$(".genCasesSwitch").change(function(){
		if(this.checked){
			$('#genCases'+$(this).attr('index')).hide()
		}
		else{
			$('#genCases'+$(this).attr('index')).show()
		}
	})

	//Header of the extractor
	$('.extractorName').keyup(function(){
		$('#dbExtractorHeader'+$(this).attr('index')).text($(this).val())
	})

	//Header of the txtExtractor
	$('.txtExtractorName').keyup(function(){
		$('#txtExtractorHeader'+$(this).attr('index')).text($(this).val())
	})

	//Header of the Generator
	$('.generatorName').keyup(function(){
		$('#generatorHeader'+$(this).attr('index')).text($(this).val())
	})

	//Field map
	$('.db-field-map-button').click(function(){
		if($('#dbCasesSelect'+$(this).attr('index')).val()!=null){
				var text=$('#dbCasesSelect'+$(this).attr('index')+' option:selected').text()
				var newRow = $('<tr index="'+$(this).attr('index')+'" stepname="'+text+'" stepId="'+$('#dbCasesSelect'+$(this).attr('index')).val()+'" class="maptr"> <td> <small class="label label-primary" style="margin-top:2px">'+text+'</small></td><td><input class="form-control dbFieldInput" type="text"></input></td><td style="text-align:center"><i stepid="'+$('#dbCasesSelect'+$(this).attr('index')).val()+'" id="dbi'+$('#dbCasesSelect'+$(this).attr('index')).val()+'"  onclick='+"'"+'deleteMap("'+'dbi'+$('#dbCasesSelect'+$(this).attr('index')).val()+'", '+$(this).attr('index')+', "db")'+"'"+' class="fa fa-trash maptrash" style="color:red; cursor:pointer" index="'+$(this).attr('index')+'"></i></td></tr>')
				$('#dbFieldsMap'+$(this).attr('index')+" tbody").append(newRow)
				$('#dbCasesSelect'+$(this).attr('index')+' option:selected').remove()	
		}
	})



	//Fields map txt
	$('.txt-field-map-button').click(function(){
		if($('#txtCasesSelect'+$(this).attr('index')).val()!=null){
				var text=$('#txtCasesSelect'+$(this).attr('index')+' option:selected').text()
				var newRow = $('<tr index="'+$(this).attr('index')+'" stepname="'+text+'" stepId="'+$('#txtCasesSelect'+$(this).attr('index')).val()+'" class="maptr"> <td> <small class="label label-primary" style="margin-top:2px">'+text+'</small></td><td><input class="form-control txtFieldInput" type="text"></input></td><td style="text-align:center"><i stepid="'+$('#txtCasesSelect'+$(this).attr('index')).val()+'" id="txti'+$('#txtCasesSelect'+$(this).attr('index')).val()+'"  onclick='+"'"+'deleteMap("'+'txti'+$('#txtCasesSelect'+$(this).attr('index')).val()+'", '+$(this).attr('index')+', "txt")'+"'"+' class="fa fa-trash maptrash" style="color:red; cursor:pointer" index="'+$(this).attr('index')+'"></i></td></tr>')
				$('#txtFieldsMap'+$(this).attr('index')+" tbody").append(newRow)
				$('#txtCasesSelect'+$(this).attr('index')+' option:selected').remove()	
		}
		return false;
	})

	//Field Generator
	$('.gen-field-map-button').click(function(){
		if($('#genCasesSelect'+$(this).attr('index')).val()!=null){
				var text=$('#genCasesSelect'+$(this).attr('index')+' option:selected').text()
				var newRow = $('<tr index="'+$(this).attr('index')+'" stepname="'+text+'" stepId="'+$('#genCasesSelect'+$(this).attr('index')).val()+'" class="maptr"> <td> <small class="label label-primary" style="margin-top:2px">'+text+'</small></td><td style="text-align:center"><i stepid="'+$('#genCasesSelect'+$(this).attr('index')).val()+'" id="geni'+$('#genCasesSelect'+$(this).attr('index')).val()+'"  onclick='+"'"+'deleteMap("'+'geni'+$('#genCasesSelect'+$(this).attr('index')).val()+'", '+$(this).attr('index')+', "gen")'+"'"+' class="fa fa-trash maptrash" style="color:red; cursor:pointer" index="'+$(this).attr('index')+'"></i></td></tr>')
				$('#genFieldsMap'+$(this).attr('index')+" tbody").append(newRow)
				$('#genCasesSelect'+$(this).attr('index')+' option:selected').remove()	
		}
	})


	//Collapse button
	$('.btn-collapse').click(function() {
      element =$(this)
      //Find the box parent
      var box = element.parents(".box").first();
      //Find the body and the footer
      var box_content = box.find("> .box-body, > .box-footer");
      if (!box.hasClass("collapsed-box")) {
        //Convert minus into plus
        element.children(":first")
                .removeClass("fa fa-minus")
                .addClass("fa fa-plus");
        //Hide the content
        box_content.slideUp(300, function () {
          box.addClass("collapsed-box");
        });
      } else {
        //Convert plus into minus
        element.children(":first")
                .removeClass("fa fa-plus")
                .addClass("fa fa-minus");
        //Show the content
        box_content.slideDown(300, function () {
          box.removeClass("collapsed-box");
        });
      }
    })



    //Ajax to test the connection
    $('.btn-db-conection').click(function(){
		if(processingConection){
			alert("no es posible en este momento ")
			return
		}
		var index = $(this).attr('index')
		var manager = $('#dbManager'+index).val()
		var ip = $("#ip"+index).val()
		var port = $('#port'+index).val()
		var name = $('#dbname'+index).val()
		var user = $('#user'+index).val()
		var pass = $('#pass'+index).val()
		currentDbConectionButton  = $(this)
	 	$.ajax({
				url: "${createLink(action:'testDbConection', controller:'extractor')}",
				method:"POST",
				data:{
					manager: manager,
					ip:ip,
					port:port,
					name:name,
					user:user,
					pass:pass,
				},
				success : function(result, status) {
					currentDbConectionButton.prop("disabled",true)
					currentDbConectionButton.html("<i class='fa fa-spinner fa-spin'></i>")
					dbConectionRequestId = result
					processingConection = true
					labelDbConection = $('#dbConectionP'+currentDbConectionButton.attr('index'))
					labelDbConection.html("")
					responseInterval = setInterval(checkConectionResponse, 600);
					processingConection = true
					
				},
				error: function(status, text, result, xhr){
							$('#newCaseErrorMessage').html(status.responseText)
							$('#newCaseErrorModal').modal('show');
				}
		})
	})


	//Ajax to save the extractor
	$('.db-extractor-save-button').click(function(){
		var index = $(this).attr('index')
		var enabled = $('#dbExtractorSwitch'+index).prop('checked')
		var name = $('#dbExtractorName'+index).val()
		var manager = $('#dbManager'+index).val()
		var ip = $('#ip'+index).val()
		var port = $('#port'+index).val()
		var dbName = $('#dbname'+index).val()
		var dbUser = $('#user'+index).val()
		var dbPass = $('#pass'+index).val()
		var query = $('#query'+index).val()
		var clueField = $('#clueField'+index).val()
		var cases = "ALL"
		var fieldMap =""
		if(!$('#dbCasesSwitch'+index).prop('checked')){
			cases = $('#dbCases'+index).val()
		}
		var fieldsMap =""
		$('#dbFieldsMap'+index+ ' > tbody > tr').each(function(){
			if(fieldMap=="")
			{
				fieldMap+=$(this).attr('stepId')+":"
			}
			else{
				fieldMap+=";"+$(this).attr('stepId')+":"
			}
			fieldMap+=$(this).find('.dbFieldInput').val().trim()
		})
		var thisButton = $(this)
		$.ajax({
				url: "${createLink(action:'saveDbExtractor', controller:'extractor')}",
				method:"POST",
				data:{
					id: ${associatedScenario.id},
					name:name,
					manager:manager, 
					ip:ip,
					port:port,
					dbName:dbName,
					dbUser: dbUser,
					dbPass:dbPass,
					query:query,
					clueField:clueField,
					cases:cases,
					fieldsMap:fieldMap,
					enabled:enabled
				},
				success : function(result, status) {
					$('#collapse'+index).trigger('click')
					bdGenerators++;
					var newGenerator = '<div class="box box-info" style="background-color:rgb(249,249,249); border-bottom: 1px solid rgb(220,220,220);  border-right: 1px solid rgb(220,220,220); border-left:1px solid rgb(220,220,220)"><div class="box-header" ><button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="collapse'+bdGenerators+'"><i class="fa fa-minus"></i></button><label class="pull-right" style="margin-left:30px;">'+"${message(code:'text.isEnabled')}"+'<input id="dbExtractorSwitch'+bdGenerators+'" class="ios-switch dbExtractorSwitch"  type="checkbox" checked><div class="switch"></div></label><label id="dbExtractorHeader'+bdGenerators+'" style="font-family: '+"'Source Sans Pro'"+', sans-serif; font-size:18px; font-weight: 500;"></label></div><div class="box-body"><label for="dbExtractorName'+bdGenerators+'">'+'${message(code:"extractor.extratorName")}'+'</label><input type="text" class="form-control extractorName" id="dbExtractorName'+bdGenerators+'" index="'+bdGenerators+'"/><br/><label for="dbManager'+bdGenerators+'">'+'${message(code:"extractor.dbManager")}'+'</label><select class="form-control" id="dbManager'+bdGenerators+'"><option value="MySQL">MySQL</option><option value="Oracle">Oracle</option><option value="Postgres">PostgreSQL</option><option value="DB2">DB2</option><option value="SQL">SQL-Server</option></select><br/><label for="ip'+bdGenerators+'">IP</label><input type="text" class="form-control" id="ip'+bdGenerators+'" placeholder="e.g. 127.0.0.1"/><br/><label for="port'+bdGenerators+'">'+'${message(code:"extractor.port")}'+'</label><input type="text" class="form-control" id="port'+bdGenerators+'" placeholder="e.g. 5432"/><br/><label for="dbname'+bdGenerators+'">'+'${message(code:"extractor.dbName")}'+'</label><input type="text" class="form-control" id="dbname'+bdGenerators+'" placeholder="e.g. mydatabase"></input><br/><label for="user'+bdGenerators+'">'+'${message(code:"extractor.dbUser")}'+'</label><input type="text" class="form-control" id="user'+bdGenerators+'" placeholder="e.g. root"/><br/><label for="pass'+bdGenerators+'">'+'${message(code:"extractor.dbPass")}'+'</label><input type="password" class="form-control" id="pass'+bdGenerators+'" placeholder=""/></br><button class="btn btn-primary btn-db-conection" id="testConection'+bdGenerators+'" index="'+bdGenerators+'" style="margin-bottom:10px"><g:message code="extractor.testConection"/></button><label class="dbConectionP " id="dbConectionP'+bdGenerators+'" style="margin-left:15px;"></label><br/><label for="query'+bdGenerators+'">'+'${message(code:"extractor.query")}'+'</label><textarea class="form-control" id="query'+bdGenerators+'"  style="resize:vertical"></textarea><br/><label for="dbCases'+bdGenerators+'">'+'${message(code:"text.cases")}'+'</label></br><label style="margin-left:30px;">'+'${message(code:"text.all" )}'+'<input id="dbCasesSwitch'+bdGenerators+'" index="'+bdGenerators+'" class="ios-switch dbCasesSwitch"  type="checkbox"/><div class="switch"></div></label><input type="text" class="form-control casesInput" id="dbCases'+bdGenerators+'" placeholder="e.g. 1-4"/><br/><label for="dbTable'+bdGenerators+'">'+'${message(code:"extractor.fieldMap")}'+'</label><div class="col-md-12" style="padding:0px" id="dbTable'+bdGenerators+'"><div class="col-md-8"  style="padding:0px"><table class="table table-bordered table-condensed table-hover" id="dbFieldsMap'+bdGenerators+'"><thead><th>'+'${message(code:"text.object")}'+'</th><th>'+'${message(code:"extractor.dbField")}'+'</th><th></th></thead><tbody></tbody></table></div></div><div class="col-md-12" style="padding:0px; margin-bottom: 20px"><div class="col-md-8"  style="padding:0px"><select id="dbCasesSelect'+bdGenerators+'" class="form-control">'
					<g:each in="${steps.sort{it.execOrder}}" var="step">
						<g:if test="${step.object && step.principalAction.action.name!='genericAction.click'}">
							newGenerator+='<option value="${step.id}">'+'${message(code:"${step.object.name}")}'+'</option>'
						</g:if>
					</g:each>
					newGenerator+='</select></div><div class="col-md-3" style="margin-bottom:20px;"><button class="btn btn-primary db-field-map-button " index="'+bdGenerators+'">'+'${message(code:"text.add")}'+'</button></div><div class="col-md-8" style="padding:0px"><label for="clueField'+bdGenerators+'">'+'${message(code:"extractor.clueField")}'+'</label><input type="text" class="form-control" id="clueField'+bdGenerators+'" placeholder="'+'${message(code:"extractor.placeholder.document")}'+'"/><br/></div></div><button class="btn btn-primary db-extractor-save-button center-block"  index="'+bdGenerators+'">${message(code:"general.text.save")}</button></div></div>'

					$("#bdGeneratorsDiv").append($(newGenerator))
					var oldHtml = $('#dbExtractorHeader'+index).parents('.box-header').first().html()
					$('#dbExtractorHeader'+index).parents('.box-header').first().html(oldHtml+"  <i class='fa fa-floppy-o'></i><i class='fa fa-trash' style='color:red; cursor:pointer' onclick='confirmDBExtractorDelete("+result+","+index+" )'>")
					$(thisButton).text('${message(code:"default.button.update.label")}')
					$(thisButton).removeClass('db-extractor-save-button')
					$(thisButton).addClass('db-extractor-update-button')
					$(thisButton).attr('id', result)
					$(thisButton).off("click");
					$('#dbExtractorSwitch'+index).attr('savedId', result)
					runDBExtractorScripts();
					$('#collapse'+index).trigger('click')
				},
				error: function(status, text, result, xhr){
						$('#executionErrorMessage').html(status.responseText)
						$('#executionErrorModal').modal('show')
				}
		})
	})


	$('.dbExtractorSwitch').change(function(){
		if($(this).attr('savedId')!='none' && $(this).attr('savedId')){
				var	id = $(this).attr('savedId');
				var checked = $(this).prop("checked")
				$.ajax({
					url: "${createLink(action:'updateDBenabled', controller:'extractor')}",
					method:"POST",
					data:{
						id: id,
						checked:checked,
						scenarioId:${associatedScenario.id},
						
					},
					success : function(result, status) {

					},
					error: function(status, text, result, xhr){
								$('#executionErrorMessage').html(status.responseText)
								$('#executionErrorModal').modal('show')
					}
				})
		}
	})

	$('.txtExtractorSwitch').change(function(){		
		if($(this).attr('savedId')!='none' && $(this).attr('savedId')){
			var	id = $(this).attr('savedId');
			var checked = $(this).prop("checked")			
			$.ajax({
				url: "${createLink(action:'updateTxtEnabled', controller:'extractor')}",
				method:"POST",
				data:{
					id: id,
					checked:checked,
					scenarioId:${associatedScenario.id}					
				},
				success : function(result, status) {
				},
				error: function(status, text, result, xhr){
					$('#executionErrorMessage').html(status.responseText)
					$('#executionErrorModal').modal('show')
				}
			})
		}
	})
	
	//Ajax to update the extractor
	$('.db-extractor-update-button').click(function(){
		var index = $(this).attr('index')
		var id = $(this).attr('id')
		var enabled = $('#dbExtractorSwitch'+index).prop('checked')
		var name = $('#dbExtractorName'+index).val()
		var manager = $('#dbManager'+index).val()
		var ip = $('#ip'+index).val()
		var port = $('#port'+index).val()
		var dbName = $('#dbname'+index).val()
		var dbUser = $('#user'+index).val()
		var dbPass = $('#pass'+index).val()
		var query = $('#query'+index).val()
		var clueField = $('#clueField'+index).val()
		var cases = "ALL"
		var fieldMap =""
		if(!$('#dbCasesSwitch'+index).prop('checked')){
			cases = $('#dbCases'+index).val()
		}
		var fieldsMap =""
		$('#dbFieldsMap'+index+ ' > tbody > tr').each(function(){
			if(fieldMap=="")
			{
				fieldMap+=$(this).attr('stepId')+":"
			}
			else{
				fieldMap+=";"+$(this).attr('stepId')+":"
			}
			fieldMap+=$(this).find('.dbFieldInput').val()
		})
		var thisButton = $(this)
		$.ajax({
				url: "${createLink(action:'updateDbExtractor', controller:'extractor')}",
				method:"POST",
				data:{
					id: id,
					name:name,
					manager:manager, 
					ip:ip,
					port:port,
					dbName:dbName,
					dbUser: dbUser,
					dbPass:dbPass,
					query:query,
					clueField:clueField,
					cases:cases,
					fieldsMap:fieldMap,
					enabled:enabled
				},
				success : function(result, status) {
					$('#collapse'+index).trigger('click')
					
					runDBExtractorScripts();
				},
				error: function(status, text, result, xhr){
							$('#executionErrorMessage').html(status.responseText)
							$('#executionErrorModal').modal('show')
				}
		})
	})

	//Guardar una nueva generación
	$('.generator-save-button').click(function(){
		var index = $(this).attr('index')
		var name = $('#generatorName'+ index).val()
		var type = $('#genType' + index).val()
		var radioSelect = $('input[name=length'+index+']:checked').val()
		var length = ''
		var pattern = ''
		var rangeInit = ''
		var rangeEnd = ''
		if(radioSelect == 'genLength'){
			length = $('#generatorLength'+ index).val()
		}
		switch(type){
			case '1':
				if(radioSelect == 'genPattern'){
					pattern = $('#generatorPattern'+ index).val()
				}
				break
			case '2':
				if(radioSelect == 'genPattern'){
					rangeInit = $('#generatorRangeInit'+ index).val()
					rangeEnd = $('#generatorRangeEnd'+ index).val()
				}
				break
			case '3':
				break
		}		
		var cases = 'ALL'
		if(!$('#genCasesSwitch'+index).prop('checked')){
			cases = $('#genCases'+index).val()
		}
		var fieldMap =""
		$('#genFieldsMap'+index+ ' > tbody > tr').each(function(){
			if(fieldMap=="")
			{
				fieldMap+=$(this).attr('stepId')
			}
			else{
				fieldMap+=";"+$(this).attr('stepId')
			}
			
		})
		var base = radioSelect
		var enabled = $('#generatorSwitch'+index).is(":checked")		
		var button = $(this)
		$.ajax({
			url: "${createLink(action:'saveGenerator', controller:'extractor')}",
			method:"POST",
			data:{
				id:${associatedScenario.id},
				name:name,
				fieldMap:fieldMap,
				cases:cases,
				type:type,
				length:length,
				pattern:pattern,
				rangeInit:rangeInit,
				rangeEnd:rangeEnd,
				base:base,
				enabled:enabled
			},
			success : function(result, status) {
				$('#collapseGen'+index).trigger('click')
				generatorSize++;
				var newGenerator = '<div class="box box-success"><div class="box-header"><button type="button" class="btn btn-box-tool pull-right btn-collapse" data-widget="collapse" id="collapseGen'+generatorSize+'"><i class="fa fa-minus"></i></button><label class="pull-right" style="margin-left:30px;"><g:message code="text.isEnabled"/><input id="generatorSwitch'+generatorSize+'" class="ios-switch generatorSwitch" type="checkbox" checked><div class="switch"></div></label><label id="generatorHeader'+generatorSize+'" style="font-family: '+'Source Sans Pro'+', sans-serif; font-size:18px; font-weight: 500;"> </label> </div><div class="box-body">	<!--Nombre--><label for="genName'+generatorSize+'"><g:message code="extractor.generatorName"/></label><input type="text" class="form-control generatorName" id="generatorName'+generatorSize+'" index="'+generatorSize+'"/><br/>	<!--Tipo de Generación--><label for="genType'+generatorSize+'"><g:message code="extractor.generatorType"/></label><select class="form-control genType" id="genType'+generatorSize+'" index="'+generatorSize+'"><option value="1"><g:message code="extractor.generatorTypeString"/></option><option value="2"><g:message code="extractor.generatorTypeNumeric"/></option><!--<option value="3"><g:message code="extractor.generatorTypeFormat"/></option>--></select><br/><!--Radio Seleccion-->	<div class="col-md-12" style="padding:0px" id="genRadios'+generatorSize+'"><div class="col-md-8" style="padding:0px"><input type="radio" id="genLength'+generatorSize+'" name="length'+generatorSize+'" class="genLength" index="'+generatorSize+'" value="genLength" checked> <g:message code="extractor.generatorLength"/> <input type="radio" id="genPattern'+generatorSize+'" name="length'+generatorSize+'" class="genPattern" index="'+generatorSize+'" value="genPattern"> <g:message code="extractor.generatorCompound"/></div></div><br/><br/><!--Longitud--><div id="divLength'+generatorSize+'" index="'+generatorSize+'"><label for="genLength'+generatorSize+'"><g:message code="extractor.generatorLength"/></label><input type="number" class="form-control" id="generatorLength'+generatorSize+'" min="1" max="150" index="'+generatorSize+'"/><br/>	</div><!--Patrón--><div id="divPattern'+generatorSize+'" style="display:none;" index="'+generatorSize+'"><label for="genPattern'+generatorSize+'"><g:message code="extractor.generatorPattern"/></label><input type="text" class="form-control" id="generatorPattern'+generatorSize+'" index="'+generatorSize+'"/><br/></div><!--Rango Inicial--><div id="divRangeInit'+generatorSize+'" style="display:none;" index="'+generatorSize+'"><label for="genRangeInit'+generatorSize+'"><g:message code="extractor.generatorRangeInit"/></label><input type="number" class="form-control" id="generatorRangeInit'+generatorSize+'" min="1" index="'+generatorSize+'"/><br/></div><!--Rango Final--><div id="divRangeEnd'+generatorSize+'" style="display:none;" index="'+generatorSize+'"><label for="genRangeEnd'+generatorSize+'"><g:message code="extractor.generatorRangeEnd"/></label>	<input type="number" class="form-control" id="generatorRangeEnd'+generatorSize+'" min="1" index="'+generatorSize+'"/><br/></div><!--Casos seleccionados--><label for="genCases'+generatorSize+'"><g:message code="text.cases"/></label></br><label style="margin-left:30px;"><g:message code="text.all" /><input id="genCasesSwitch'+generatorSize+'" class="ios-switch genCasesSwitch" index="'+generatorSize+'" type="checkbox"/><div class="switch"></div></label><input type="text" class="form-control casesInput" id="genCases'+generatorSize+'" placeholder="e.g. 1-4"/><br/><!--Tabla con los Campos para dar generacion--><div class="col-md-12" style="padding:0px" id="genTable'+generatorSize+'"><div class="col-md-6"  style="padding:0px"><table class="table table-bordered table-condensed table-hover" id="genFieldsMap'+generatorSize+'"> <thead>	<th><g:message code="text.object"/></th><th></th></thead><tbody></tbody></table></div></div><br/><!--Div Campos a Seleccionar--><div class="col-md-12" style="padding:0px; margin-bottom: 20px"><div class="col-md-8"  style="padding:0px"><select id="genCasesSelect'+generatorSize+'" class="form-control">'
				<g:each in="${steps.sort{it.execOrder}}" var="step">
					<g:if test="${step.object && step.principalAction.action.name!='genericAction.click'}">
						newGenerator+='<option value="${step.id}">'+'${message(code:"${step.object.name}")}'+'</option>'
					</g:if>
				</g:each>
				newGenerator+= '</select></div><div class="col-md-3" style="margin-bottom:20px;"><button class="btn btn-primary gen-field-map-button" index="'+generatorSize+'"><g:message code="text.add"/></button></div></div><br/><button class="btn btn-primary center-block generator-save-button" index="'+generatorSize+'"><g:message code="general.text.save"/></button></div><div class="box-footer"></div></div>'
				//Se agrega al div de Generador el formulario para crear una nueva generación de datos
				$('#generatorDiv').append($(newGenerator))
				//
				var oldHtml = $('#generatorHeader'+index).parents('.box-header').first().html()
				$('#generatorHeader'+index).parents('.box-header').first().html(oldHtml+"  <i class='fa fa-floppy-o'></i><i class='fa fa-trash' style='color:red; cursor:pointer' onclick='confirmGeneratorDelete("+result+","+index+" )'>")
				$(button).text('${message(code:"default.button.update.label")}')
				$(button).removeClass('generator-save-button')
				$(button).addClass('generator-update-button')
				$(button).attr('id', result)
				$(button).off("click");
				$('#generatorSwitch'+index).attr('savedId', result)
				//Minimizar el formulario creado
				$('#collapseGen'+index).trigger('click')
				runDBExtractorScripts()
			},
			error: function(status, text, result, xhr){
				$('#executionErrorMessage').html(status.responseText)
				$('#executionErrorModal').modal('show')
			}
		})
	})

	//Actualizar todo el generador
	$('.generator-update-button').click(function(){
		var id = $(this).attr('id')
		var index = $(this).attr('index')
		var name = $('#generatorName'+ index).val()
		var type = $('#genType' + index).val()
		var radioSelect = $('input[name=length'+index+']:checked').val()
		var length = ''
		var pattern = ''
		var rangeInit = ''
		var rangeEnd = ''
		if(radioSelect == 'genLength'){
			length = $('#generatorLength'+ index).val()
		}
		switch(type){
			case '1':
				if(radioSelect == 'genPattern'){
					pattern = $('#generatorPattern'+ index).val()
				}
				break
			case '2':
				if(radioSelect == 'genPattern'){
					rangeInit = $('#generatorRangeInit'+ index).val()
					rangeEnd = $('#generatorRangeEnd'+ index).val()
				}
				break
			case '3':
				break
		}		
		var cases = 'ALL'
		if(!$('#genCasesSwitch'+index).prop('checked')){
			cases = $('#genCases'+index).val()
		}
		var fieldMap =""
		$('#genFieldsMap'+index+ ' > tbody > tr').each(function(){
			if(fieldMap=="")
			{
				fieldMap+=$(this).attr('stepId')
			}
			else{
				fieldMap+=";"+$(this).attr('stepId')
			}
			
		})
		var base = radioSelect
		var enabled = $('#generatorSwitch'+index).is(":checked")		
		var button = $(this)
		$.ajax({
			url: "${createLink(action:'updateGenerator', controller:'extractor')}",
			method:"POST",
			data:{
				id:id,
				name:name,
				fieldMap:fieldMap,
				cases:cases,
				type:type,
				length:length,
				pattern:pattern,
				rangeInit:rangeInit,
				rangeEnd:rangeEnd,
				base:base,
				enabled:enabled
			},
			success : function(result, status) {
				$('#collapseGen'+index).trigger('click')				
				runDBExtractorScripts()
			},
			error: function(status, text, result, xhr){
				$('#executionErrorMessage').html(status.responseText)
				$('#executionErrorModal').modal('show')
			}
		})
	})

	//Actualizar estado generador
	$('.generatorSwitch').change(function(){		
		if($(this).attr('savedId')!='none' && $(this).attr('savedId')){
			var	id = $(this).attr('savedId');
			var checked = $(this).prop("checked")			
			$.ajax({
				url: "${createLink(action:'updateGeneratorEnabled', controller:'extractor')}",
				method:"POST",
				data:{
					id: id,
					checked:checked,
					scenarioId:${associatedScenario.id}					
				},
				success : function(result, status) {
				},
				error: function(status, text, result, xhr){
					$('#executionErrorMessage').html(status.responseText)
					$('#executionErrorModal').modal('show')
				}
			})
		}
	})

	//Generator Data
	$(".genType").change(function(){
		var index = $(this).attr('index')
		switch($(this).find(":selected").val()){
			case '1':
				//String
				$("#divLength"+index).show()
				$("#divPattern"+index).hide()
				$("#divRangeInit"+index).hide()
				$("#divRangeEnd"+index).hide()
				$("#genLength"+index).prop('checked', true)
				break
			case '2':
				//Numerico
				$("#divLength"+index).show()
				$("#divPattern"+index).hide()
				$("#divRangeInit"+index).hide()
				$("#divRangeEnd"+index).hide()
				$("#genLength"+index).prop('checked', true)
				break
			case '3':
				//Por Formato
				break
		}
	})
	$(".genLength").click(function(){
		var index = $(this).attr('index')		
		$("#divLength"+index).show()
		$("#divPattern"+index).hide()
		$("#divRangeInit"+index).hide()
		$("#divRangeEnd"+index).hide()				
	})
	$(".genPattern").click(function(){
		var index = $(this).attr('index')		
		switch($('#genType'+index).find(':selected').val()){
			case '1':
				$("#divLength"+index).hide()
				$("#divPattern"+index).show()
				$("#divRangeInit"+index).hide()
				$("#divRangeEnd"+index).hide()
				break
			case '2':
				$("#divLength"+index).hide()
				$("#divPattern"+index).hide()
				$("#divRangeInit"+index).show()
				$("#divRangeEnd"+index).show()
				break				
			case '3':
				break							
		}
	})

}





function checkExecutionResponse(){
	$.ajax({
			url: "${createLink(action:'checkExecutionResponse', controller:'extractor')}",
			method:"POST",
			data:{
				id: curExecutionRequestId,
			},
			success : function(result, status) {
				if(result=="true"){
					clearInterval(executionResponseInterval)
					if(executionType=="queue"){
						$('#executionSuccessMessage').html("${message(code:'scenario.execution.queued')}")
						$('#executionSuccessModal').modal('show');
					}
					else if(executionType=="direct") {

						$('#executionSuccessMessage').html("${message(code:'scenario.execution.direct')}")
					}

				}
				else if(result.indexOf("ERROR")>-1)
				{
					$('#executionSuccessModal').modal('hide');
					clearInterval(executionResponseInterval)
					$('#executionErrorMessage').html(result)
					$('#executionErrorModal').modal('show')
				}
			},
			error: function(status, text, result, xhr){
						alert("Unexpected error")
			}
	})
}




function checkConectionResponse(){
	$.ajax({
			url: "${createLink(action:'checkConectionResponse', controller:'extractor')}",
			method:"POST",
			data:{
				id: dbConectionRequestId,
			},
			success : function(result, status) {
				if(result=="true"){
					currentDbConectionButton.prop('disabled', false)
					currentDbConectionButton.html('${message(code:"extractor.testConection")}')
					
					labelDbConection.html("  <i class='fa fa-check' style='color:green'></i> ${message(code:'extractor.dbconection.success')}")
					clearInterval(responseInterval)
					processingConection = false
				}
				else if(result=="false")
				{
					currentDbConectionButton.prop('disabled', false)
					currentDbConectionButton.html("${message(code:'extractor.testConection')}")
					labelDbConection.html("  <i class='fa fa-times' style='color:red'></i> ${message(code:'extractor.dbconection.error')}")
					clearInterval(responseInterval)
					processingConection = false
				}
				
			},
			error: function(status, text, result, xhr){
						alert("Unexpected error")
			}
	})
}



function deleteMap(id, index, pref){
	var obj =$("[id='"+id+"'][index='"+index+"']")
	var text = $(obj).parent().parent().attr('stepname')
	var id = $(obj).parent().parent().attr('stepid')
	$(obj).parent().parent().remove()
	$('#'+pref+'CasesSelect'+index.toString()).append($("<option value='"+id+"' >"+text+"</option>"))	
}

function deleteDBExtractor(){
	var id = curDBExtractorDeleteId
	var index = curDBExtractorDeleteIndex
	$.ajax({
			url: "${createLink(action:'deleteDBExtractor', controller:'extractor')}",
			method:"POST",
			data:{
				id: id,
			},
			success : function(result, status) {
				$('#dbExtractorConfirmModal').modal('hide')
				$( "#dbCollapse"+index ).parent().parent().slideUp(600, function(){ $(this).remove();});
			},
			error: function(status, text, result, xhr){
						alert("Unexpected error")
			}
	})
}


function deleteTxtExtractor(){
	var id = curTxtExtractorDeleteId
	var index = curTxtExtractorDeleteIndex
	$.ajax({
			url: "${createLink(action:'deleteTXTExtractor', controller:'extractor')}",
			method:"POST",
			data:{
				id: id,
			},
			success : function(result, status) {
				$('#txtExtractorConfirmModal').modal('hide')
				$( "#txtCollapse"+index ).parent().parent().slideUp(600, function(){ $(this).remove();});
			},
			error: function(status, text, result, xhr){
						alert("Unexpected error")
			}
	})
}

function deleteGenerator(){
	var id = curGeneratorDeleteId
	var index = curGeneratorDeleteIndex
	$.ajax({
			url: "${createLink(action:'deleteGenerator', controller:'extractor')}",
			method:"POST",
			data:{
				id: id,
			},
			success : function(result, status) {
				$('#generatorConfirmModal').modal('hide')
				$("#collapseGen"+index ).parent().parent().slideUp(600, function(){ $(this).remove();});
			},
			error: function(status, text, result, xhr){
				alert("Unexpected error")
			}
	})
}


function confirmDBExtractorDelete(id, index){
	curDBExtractorDeleteIndex = index
	curDBExtractorDeleteId = id
	$('#dbExtractorConfirmModal').modal('show')

}


function confirmTXTExtractorDelete(id, index){
	curTxtExtractorDeleteIndex = index
	curTxtExtractorDeleteId = id
	$('#txtExtractorConfirmModal').modal('show')

}

function confirmGeneratorDelete(id, index){
	curGeneratorDeleteIndex = index
	curGeneratorDeleteId = id
	$('#generatorConfirmModal').modal('show')
}


  $(".formTxt").submit( function(eventObj) {
  		var index = $(this).attr('index')  		
		var cases = "ALL"
		var fieldMap =""
		if(!$('#txtCasesSwitch'+index).prop('checked')){
			cases = $('#txtCases'+index).val()
		}		
		$('#txtFieldsMap'+index+ ' > tbody > tr').each(function(){
			if(fieldMap=="")
			{
				fieldMap+=$(this).attr('stepId')+":"
			}
			else{
				fieldMap+=";"+$(this).attr('stepId')+":"
			}
			fieldMap+=$(this).find('.txtFieldInput').val().trim()
		})
      	$('<input />').attr('type', 'hidden')
          .attr('name', "realCases")
          .attr('value', cases)
          .appendTo($(this));

		var enabled =  $('#txtExtractorSwitch'+index).prop('checked')
	    $('<input />').attr('type', 'hidden')
	          .attr('name', "isEnabled")
	          .attr('value', enabled)
	          .appendTo($(this));

      	$('<input />').attr('type', 'hidden')
          .attr('name', "fieldMap")
          .attr('value', fieldMap)
          .appendTo($(this));
	return true;
  });

$('#selectAllRowsSwitch').change(function(){
	if(this.checked) {
		$('.trSelectableCases').each(function(i, obj) {
			$(this).css('background-color','#ccd9ff')
			$(this).attr('select','1')
		});
	}
	else{				
		$('.trSelectableCases').each(function(i, obj) {			
			$(this).css('background-color','')
			$(this).attr('select','0')			
		});				
	}
})

$('.trSelectableCases').click(function(){
	var selected = $(this).attr('select')
	if(selected =="0"){
		$(this).css('background-color','#ccd9ff')
		$(this).attr('select','1')
	}
	else{
		$(this).css('background-color','')
		$(this).attr('select','0')
	}
})

$("#deleteSelection").click(function() {			
	$("#casesTable > tbody > .trSelectableCases").each(function() {
		if($(this).attr('select')=='1'){
			casesToDelete+=$(this).attr('id')+","
		}
	});
	if(casesToDelete!=""){
		$("#masiveDeleteConfirmModal").modal('show')
	}	
})

function masiveDeleteCases(){
	$.ajax({
		method: "POST",
		url: "${createLink(action:'masiveDelete', controller:'case')}",
		data: { 
			casesToDelete: casesToDelete, 
			scenarioId: ${scenarioId}
		}, 
		success: function(result) {
			location.reload()
		},
		error: function(status, text, result, xhr) {
			showDeleteErrorModal(status.responseText);
		}
	});	
}

</script>
	



		
<!-- /.row -->
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



<div id='modalAndJsSection'>

</div>
