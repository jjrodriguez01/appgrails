<sec:ifAllGranted roles="ROLE_USER_LEADER">
<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>

<div class="content-wrapper">
	<!-- Main content -->
	<section class="content"  id="principalSection">
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
					<div class="box">
								<div class="box-header">
									<div class="col-md-6">
											<h3>
												<i class="fa  fa-envelope-o"> </i>
												<g:message code="text.messages"/>
											</h3>
									</div>
									<div class="col-md-6">
										<ol class="breadcrumb pull-right" style="background-color:white">
											<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
									        <li><g:link controller='project' action='index'>${associatedScenario.project.name}</g:link></li>
									       	<li><g:link controller='scenario' action='index' id='${associatedScenario.project.id}'>${associatedScenario.name}</g:link></li>
									       	<li class="active"><g:message code="text.messages"/></li>
									    </ol>
									</div>
								</div>
								<!-- /.box-header -->
								<div class="box-body row">

									<sec:ifAnyGranted roles="${functionality31.roles}">
										<div class="col-md-3">
											<label for="pagesSelect"><g:message code="text.page"/>:</label>
											<select class="form-control" id="pagesSelect">
												<g:each status="i" var="page" in="${pages}">
													<option  value="${page.id}">
														${page.name}
													</option>
												</g:each>
											</select>
											<br/>
											<label class="form-control ">
												<g:message	code="general.text.selectAll" />
												<input	id="selectAllObjects" type="checkbox" class="ios-switch objectSwitch " />
												<div class="switch pull-right"></div>
											</label>

											<g:if test="${pages.size()>0}">
												<table class="table table-bordered table-condensed table-hover  paginated" id="sMessagesTable">
													<tbody  id="selectable">
														<g:each in="${pages.getAt(0).getMessages().sort{it.dateCreated}}" var="message">
															<tr idObj="${message.id}" class="trSelectable" select="0">
																<td>
																<img  class="zoomImage " style="max-height:50px; max-width:150px" src="${createLink(controller: 'stage', action:'renderImage', params:[idOb:message.object.imageUrl])}" />
															</td>
															<td>
																<g:if test="${message.type==1}">
																	<span class="label bg-blue"><g:message code="general.pending"/></span>
																</g:if>
																<g:elseif test="${message.type==2}">
																	<span class="label label-danger"><g:message code="general.error"/></span>
																</g:elseif>
																<g:elseif test="${message.type==3}">
																	<span class="label label-success"><g:message code="general.success"/></span>
																</g:elseif>
															</td>
															
															</tr>
														</g:each>
													</tbody>
												</table>
											</g:if>
										</div>
										<div class="col-md-1">
											<br><br><br>
											<g:each  var="i" in="${ (0..<messages.size()/2) }">
												<br>
											</g:each>
											<div  class="icon caretButton" style="color:green; margin-left:45%; cursor:pointer;">
												<i class="fa  fa-angle-double-right fa-5x"></i>
												<br/>
											</div>
										</div>
										<div class="col-md-8 row">
									</sec:ifAnyGranted>
									<sec:ifNotGranted roles="${functionality31.roles}">
										<div class="col-md-12">
									</sec:ifNotGranted>
										<button class="btn btn-danger pull-right" id="deleteSelection" ><g:message code="text.delete" /> <i class="fa fa-trash"></i></button>
										<label style="padding-top: 3px; margin-right:10px;" class="pull-right">
											<g:message code="general.text.selectAll" />
											<input id="selectAllRowsSwitch" class="ios-switch"  type="checkbox">
											<div class="switch"></div>
										</label>
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
										<input id="datatablesearch" table="messagesTable" name="search" type="text"/>
										<table id="messagesTable" class="table table-bordered table-condensed table-hover sortable paginated">
											<thead>
												<tr>
													<th><g:message code="text.object" /></th>
													<th><g:message code="text.referenceImage"/></th>
													<th><g:message code="text.type" /></th>
													<th><g:message code="text.message" /></th>													
													<th style="max-width: 100px; text-align:center;">
														<label style="" class="pull-right">
															<g:message code="text.byClueWords" />
															<input id="selectAllSwitch" class="ios-switch"  type="checkbox">
															<div class="switch"></div>
														</label>
													</th>
													<th><g:message code="text.scope" /></th>
													<sec:ifAnyGranted roles="${functionality32.roles}">
														<th><g:message code="text.edit" />/<g:message code="text.delete" /></th>
													</sec:ifAnyGranted>
												</tr>
											</thead>
											<tbody>
												<g:each status="i" in="${messages.sort{it.dateCreated}}" var="message">
													<tr class="trSelectableMessage" select="0" id="${message.id}">
														<td>
															${message.object.name} 
														</td>
														<td>
															<img  class="zoomImage " style="max-height:50px; max-width:150px" src="${createLink(controller: 'stage', action:'renderImage', params:[idOb:message.object.imageUrl])}" />
														</td>
														<td>
															<g:if test="${message.type==1}">
																<span class="label bg-blue"><g:message code="general.pending"/></span>
															</g:if>
															<g:elseif test="${message.type==2}">
																<span class="label label-danger"><g:message code="general.error"/></span>
															</g:elseif>
															<g:elseif test="${message.type==3}">
																<span class="label label-success"><g:message code="general.success"/></span>
															</g:elseif>
														</td>
														<td id="td${message.id}" original="${message.message}">
															
																	${message.message}						
														</td>
														<td style="text-align:center;">
															<g:if test="${message.byClueWords}">
																<label>
																	<input id="${message.id}" type="checkbox" class="ios-switch enabledcheck" checked/>
																	<div class="switch"></div>
																</label>
															</g:if>
															<g:else>
																<label>
																	<input id="${message.id}" type="checkbox" class="ios-switch enabledcheck" />
																	<div class="switch"></div>
																</label>
															</g:else>
														</td>
														<td>
															<g:if test="${message.scope=='ALL'}">
																<g:message code="text.all"/>
															</g:if>
															<g:elseif test="${message.scope.contains('#')}">
																${message.scope.split('#')[0]} <g:message code="text.to"/>  ${message.scope.split('#')[1]}
															</g:elseif>
														</td>
														<sec:ifAnyGranted roles="${functionality32.roles}">
															<td style="text-align:center;">
																<a href="#" onclick='showEditMessageModal(${message.id},${message.type},${message.byClueWords},"${message.message}","${message.scope}"); return false;' >
																<i class="fa fa-pencil-square-o "> </i></a>

																<a style="color:red;" href="#" onclick="setDeletingId(${message.id}); return false;">
																<i class="fa fa-trash-o"> </i></a>
															</td>
														</sec:ifAnyGranted>
													</tr>	
												</g:each>
											</tbody>
										</table>
									</div>
								</div>
		<!-- /.box-body -->
							</div>
		<!-- /.box -->
						</div>
					
		<!-- /.col -->
			</div>
		</div>
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


<div id="modalAndJsSection">


<!-- Modal de edición de message -->
<div id="editMessageModal" class="modal fade" role="dialog" >
	<div class="modal-dialog">
		<!-- Modal content-->
		<div class="modal-content" style="overflow-y: auto;">
			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h3>
					<g:message code="text.edit" />
					<g:message code="text.message" />
				</h3>
			</div>
			<div class="modal-body">
				<br>
				<div id="formEditMessage" style="margin-left: 20px; margin-right: 20px; margin-bottom:30px;">
					
					<label for="editTypeDropdown"><g:message code="text.type"/></label>
					<select class="form-control" id="editTypeDropdown">
						<option value="1"><g:message code="general.pending"/></option>
						<option value="2"><g:message code="general.error"/></option>
						<option value="3"><g:message code="general.success"/></option>
					</select>
					<br> 
					<label for="editMessageMessage">
						<g:message code="text.message"/>
					</label>
				
					<div id="editMessageClueDiv" style="display:none; margin-bottom:20px">
			
					</div>
					<br class="editCluebr" style="display:none"/>
					<input id="editMessageMessage" name="editMessageMessage" type="text" class="form-control"/>
					<button id="editMessageAddClue" class="btn btn-default pull-right" style="display:none; margin-top:10px;"><g:message code="text.add"/><i class="fa fa-plus"></i></button>
					<div id="editClueWordsBr">
						<br/>
						<br/>
					</div>
					<label class="form-control" style="margin-top:10px">
						<g:message code="text.byClueWords" />
						<input id="editByClueWords" type="checkbox" class="ios-switch " />
						<div class="switch"></div>
					</label>
					<label for="editMessageScopeSelect"><g:message code="text.scope"/></label>
					<select id="editMessageScopeSelect" class="form-control">
						<option value="1"><g:message code="text.all"/></option>
						<option value="2"><g:message code="text.scope"/></option>
					</select>
					<br/>
					<div class="form-inline" id="editMessageRangeDiv" style="display:none">
						<div class="form-group">
							<label for="editMessageFromRange"><g:message code="text.from"/></label>
							<input id="editMessageFromRange" type="number"/>
						</div>
						<div class="form-group">
							<label for="editMessageToRange"><g:message code="text.to"/></label>
							<input id="editMessageToRange" type="number"/>
						</div>
					</div>

					<div class="col-md-12">
						<button type="button" id="formEditMessageButton" style="margin-bottom: 30px"
						class="btn btn-info pull-right">
							<g:message code="general.text.save" />
						</button>
					</div>
	 				<br> 

				</div>
				<br> 
			</div >
		</div>
	</div>
</div>
<!-- fin del modal de edición de message -->



<!-- Modal de confirmación de borrado de Message -->
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
					onclick="deleteMessage()"> <g:message code="general.text.continue" />
				</button>
			</div>
		</div>
	</div>
</div>
<!-- Final del modal de confirmación -->


<!-- Modal de error de registro de message -->
<div id="newMessageErrorModal" class="modal fade " role="dialog">
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
				<p id="newMessageErrorMessage"></p>
			</div>
		</div>
	</div>
</div>
<!-- Fin del modal de error de registro de message -->



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

<!-- Modal de confirmación de borrado masivo de Mensajes -->
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
					onclick="masiveDeleteMessages()">
					<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación de borrado masivo de Mensajes -->

<asset:javascript src="zoom.js"/>


<script>
	var editingId=null;
	var deletingId = null;
	var currentPage = 0;
	var numPerPage = 10;
	var editPrincipalHtml=""
	var fullyLoaded = false
	var messagesToDelete = "" 


	$(window).load( function(){
		notificationsInterval = setInterval(getNotifications, 8000);
		enableSearch()
		makeTablePaginated()
		setZoomImages()
		executeSupportFunctions();
		$('.enabledcheck').each(function()
		{
			$(this).change()
		})
		fullyLoaded=true;
		executeSupportFunctions();
		
	})



	$('#expiredSessionModal').on('hidden.bs.modal', function () {
		location.reload()
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

	$('.caretButton').click(function (){
		var result = ""
		$( "#sMessagesTable > tbody > .trSelectable" ).each(function() {
			if($(this).attr('select')=='1'){
				var id = $(this).attr('idobj')
				result+=  ( id  )+"," ;
			}
		});
		if(result!=""){
			$.ajax({
				method: 'POST',
				url: "${createLink(action:'addMessageToScenario', controller:'message')}",
				data:{
					id: ${scenarioId},
					messages:result,
				},
				success: function(dataCheck) {
					location.reload()
				},
				error: function(status, text, result, xhr) {
					alert("error")
				}
			});

		}
	})

	function deleteMessage() {
		$.ajax({
			method: "POST",
			url: "${createLink(action:'deleteFromScenario', controller:'message', )}",
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
		$('#newStepErrorMessage').html(error)
		$('#newStepErrorModal').modal('show');
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



	$('.caretButton').mousedown(function (){
		$(this).css('color','orange')
	})
	$('.caretButton').mouseup(function (){
		$(this).css('color','green')
	})







	$('#pagesSelectNewMessage').change(function(){
		var index = $(this).prop('selectedIndex') 
		$('#objectsDropdown').empty()
		$('#objectsDropdown').append('<option value="null" ></option>')
		<g:each in="${pages}" status="i" var="page">
		if(${i}==index){
			<g:each in="${page.objects}" var="obj">
				$('#objectsDropdown').append('<option style="color:#555" id="${obj.id}" value="${obj.id}">${obj.name}</option>')
			</g:each>
		}
		</g:each>

	})

	$('#newMessageScopeSelect').change(function(){
		var index = $(this).prop('selectedIndex') 
		if(index==1){
			$('#newMessageRangeDiv').css('display', 'block')
		}
		else{
			$('#newMessageRangeDiv').css('display', 'none')
		}
	})











	$('#formEditMessageButton').click(function() {
		var byClueWords = $('#editByClueWords').prop('checked')
		var message = $('#editMessageMessage').val()
		if(byClueWords)
		 message = $('#editMessageMessage').attr('original')
		
		var type = $('#editTypeDropdown option:selected').val()
		var all = $('#editMessageScopeSelect').prop('selectedIndex') == 0?true:false
		var scope ='ALL'
		if(!all){

			scope=$('#editMessageFromRange').val()+"#"+$('#editMessageToRange').val()
		}

		$.ajax({
			method: 'POST',
			url: "${createLink(action:'updateFromScenario', controller:'message')}",
			data:{
				scenarioId: ${scenarioId},
				id: editingId,
				message:message,
				byClueWords:byClueWords,
				type:type,
				scope:scope,
			},
			success: function(dataCheck) {
				location.reload()
			},
			error: function(status, text, result, xhr) {
				
				$('#editMessageModal').modal('hide');
				$('#newMessageErrorMessage').html(status.responseText)
				$('#newMessageErrorModal').modal('show');
			}
		});

	});


	$('#editMessageScopeSelect').change(function(){
		$(this).val() == 2?$('#editMessageRangeDiv').show():$('#editMessageRangeDiv').hide()
	})

function showEditMessageModal(id,  type, byClueWords, message, scope)
{
	editingId=id
	$('#editMessageMessage').attr('original',message.split('#;#').join(' '))
	$('#editTypeDropdown option[value='+type+']').prop('selected', true);
	if(byClueWords){
		
		$('#editByClueWords').prop('checked',true)
		var splittedMessage = message.split('#;#')
		var html="";
		for(var i=0; i<splittedMessage.length;i++){
			html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+splittedMessage[i]+'</span>'
			if(i%3==0 && i!=0){
				html+="<br/>"
			}
		}
		$('#editMessageClueDiv').html(html)
		$('#editMessageClueDiv').css('display','block')
		$('#editMessageAddClue').css('display','block')
		$('.editCluebr').each(function(){
			$(this).css('display','block')
		})
		$('#editMessageMessage').val('')
	}
	else{
		$('#editByClueWords').prop('checked',false)
		$('#editMessageMessage').val(message)
		$('#editMessageClueDiv').css('display','none')
		$('#editMessageAddClue').css('display','none')
		$('.editCluebr').each(function(){
			$(this).css('display','none')
		})

	}

	if(scope!="ALL"){
		$('#editMessageScopeSelect').val('2')
		$('#editMessageRangeDiv').css('display', 'block')
		$('#editMessageFromRange').val(scope.split('#')[0])
		$('#editMessageToRange').val(scope.split('#')[1])
	}


	

	
	$('#editMessageModal').modal('show');
}

$('#byClueWords').change(function(){
	var currentMessage =""
	if(this.checked){
		currentMessage = $('#newMessageMessage').val().trim()
		$('#newMessageMessage').attr('original',currentMessage)
		var newMessages = currentMessage.split(' ')
		var html="" 
		for(var i=0;i<newMessages.length;i++){
			html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+newMessages[i]+'</span>'
		}
		$('#newMessageClueDiv').html(html)
		$('#newMessageClueDiv').css('display','block')
		$('#newMessageAddClue').css('display','block')
		$('#newMessageMessage').val("")
		$('.cluebr').each(function(){
			$(this).css('display','block')
		})

	}
	else{		
		currentMessage = $('#newMessageMessage').attr('original')
		$('#newMessageClueDiv').css('display','none')
		$('#newMessageAddClue').css('display','none')
		$('.cluebr').each(function(){
			$(this).css('display','none')
		})
		$('#newMessageMessage').val(currentMessage)

	}

})

$('#newMessageAddClue').click(function(){
	var newMessage = $('#newMessageMessage').val().trim()
	var splittedMessage = newMessage.split(' ')
	var curOriginal = $('#newMessageMessage').attr('original')

	$('#newMessageMessage').attr('original',curOriginal+" "+newMessage)
	var html = $('#newMessageClueDiv').html()
	for(var i=0;i<splittedMessage.length;i++){
			html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+splittedMessage[i]+'</span>'
		}
	$('#newMessageClueDiv').html(html)
})


$('#editByClueWords').change(function(){
	var currentMessage =""
	if(this.checked){
		currentMessage = $('#editMessageMessage').val().trim()
		$('#editMessageMessage').attr('original',currentMessage)
		var newMessages = currentMessage.split(' ')
		var html="" 
		for(var i=0;i<newMessages.length;i++){
			html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+newMessages[i]+'</span>'
		}
		$('#editMessageClueDiv').html(html)
		$('#editMessageClueDiv').css('display','block')
		$('#editMessageAddClue').css('display','block')
		$('#editMessageMessage').val("")
		$('.editCluebr').each(function(){
			$(this).css('display','block')
		})

	}
	else{		
		currentMessage = $('#editMessageMessage').attr('original')
		$('#editMessageClueDiv').css('display','none')
		$('#editMessageAddClue').css('display','none')
		$('.editCluebr').each(function(){
			$(this).css('display','none')
		})
		$('#editMessageMessage').val(currentMessage)

	}

})

$('#editMessageAddClue').click(function(){
	var newMessage = $('#editMessageMessage').val().trim()
	var splittedMessage = newMessage.split(' ')
	var curOriginal = $('#editMessageMessage').attr('original')

	$('#editMessageMessage').attr('original',curOriginal+" "+newMessage)
	var html = $('#editMessageClueDiv').html()
	for(var i=0;i<splittedMessage.length;i++){
			html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+splittedMessage[i]+'</span>'
		}
	$('#editMessageClueDiv').html(html)
})


$('#formNewMessageButton').click(function() {

	var object=$('#objectsDropdown option:selected').val()
	var byClueWords = $('#byClueWords').prop('checked')
	var type=$('#typeDropdown option:selected').val()
	var message = $('#newMessageMessage').attr('original')
	if(!byClueWords && message==null){
		var message = $('#newMessageMessage').val()
	}
	var all = $('#newMessageScopeSelect').prop('selectedIndex') == 0?true:false
	var scope ='ALL'
	if(!all){
		scope=$('#newMessageFromRange').val()+"#"+$('#newMessageToRange').val()
	}
	$.ajax({
		method: 'POST',
		url: "${createLink(action:'create', controller:'message')}",
		data:{
			id: ${scenarioId},
			object:object,
			type:type,
			message:message,
			byClueWords:byClueWords,
			scope:scope,
		},
		success: function(dataCheck) {
			location.reload()
		},
		error: function(status, text, result, xhr) {
			$('#newMessageErrorMessage').html(status.responseText)
			$('#newMessageErrorModal').modal('show');
		}
	});

});

$('#pagesSelect').on('change', function (e) {
		$('#sMessagesTable tbody').empty()
	    var optionSelected = $(this).val()
	    var valueSelected = this.value;
	    var index = $(this).prop('selectedIndex')
		<g:each in="${pages}" var="page" status="i">
			if(${page.id}==optionSelected){
					<g:each in ="${page.objects.sort{it.dateCreated}}" var="obj">
				
					
						$('#sMessagesTable').append('<tr class="trSelectable"  select="0" idobj="${obj.id}"><td class="notSelectable">${obj.name}</td><td><img class="zoomImage" style="max-height:50px; max-width:150px" original="" src="'+"${createLink(controller: 'stage', action:'renderImage', params:[idOb:obj.imageUrl])}"+'" /></td></tr>')
					</g:each>
				}
		</g:each>
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
		$('.pager').remove()
			makeTablePaginated()
		setZoomImages()
	});


	function executeSupportFunctions(){
		
		$('.messageChk').each(function(){
			$(this).off()
		})
		$('.enabledcheck').each(function(){
			$(this).off()
		})


		$('.messageChk').change(function(i, obj) {
			var curObj = $(this).attr('obj')
			if(this.checked){
				$('.messageChk').each(function(){
					if($(this).attr('obj')==curObj)
						$(this).prop('checked', true)
				})
				$('.objcheck').each(function(){
					if($(this).attr('id')==curObj)
						$(this).prop('checked', true)
				})


			}
			else{
				$('.messageChk').each(function(){
					if($(this).attr('obj')==curObj)
						$(this).prop('checked', false)
				})
				$('.objcheck').each(function(){
					if($(this).attr('id')==curObj)
						$(this).prop('checked', false)
				})

			}
		});


		$('.enabledcheck').change(function(){
			var currentMessage = $('#td'+$(this).attr('id')).attr('original')
			var byClueWords ="false"
			if(this.checked){
				var byClueWords ="true"
				var newMessages = []
				var newOriginal = currentMessage

				if(currentMessage.split('#;#').length>1){
					newMessages = currentMessage.split('#;#')	
				}
				else{
					newOriginal = currentMessage.split(' ').join('#;#')
					newMessages = currentMessage.split(' ')	
				}
				
				var html=""
				for(var i=0;i<newMessages.length;i++){
					if(i%3==0){
						html+="<div style='margin-bottom:2px'>"
					}
					html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+newMessages[i]+'</span>'
					if(i%3==2){
						html+="</div>"
					}
				}
				$('#td'+$(this).attr('id')).html(html)
				$('#td'+$(this).attr('id')).attr('original',newOriginal)
			}
			else{
				var newMessage = currentMessage.split('#;#').join(" ")
				$('#td'+$(this).attr('id')).html(newMessage)
				$('#td'+$(this).attr('id')).attr('original',newMessage)
			}

			if(fullyLoaded){
					$.ajax({
							method: 'POST',
							url: "${createLink(action:'changeByClueWords', controller:'message')}",
							data:{
								id: $(this).attr('id'),
								byClueWords: byClueWords,
							},
							success: function(dataCheck) {
							
							},
							error: function(status, text, result, xhr) {
								alert(status.responseText)
						}
					});
				}
		})

	}

	$('#selectAllRowsSwitch').change(function(){
		if(this.checked) {
			$('.trSelectableMessage').each(function(i, obj) {
				$(this).css('background-color','#ccd9ff')
				$(this).attr('select','1')
			});
		}
		else{				
			$('.trSelectableMessage').each(function(i, obj) {			
				$(this).css('background-color','')
				$(this).attr('select','0')			
			});				
		}
	})

	$('.trSelectableMessage').click(function(){
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
		$("#messagesTable > tbody > .trSelectableMessage").each(function() {
			if($(this).attr('select')=='1'){
				messagesToDelete+=$(this).attr('id')+","
			}
		});
		if(messagesToDelete!=""){
			$("#masiveDeleteConfirmModal").modal('show')
		}	
	})

	function masiveDeleteMessages(){
		$.ajax({
			method: "POST",
			url: "${createLink(action:'deleteMasiveFromScenario', controller:'message')}",
			data: { 
				messagesToDelete: messagesToDelete, 
				scenarioId: ${scenarioId}
			}, 
			success: function(result) {
				$("#masiveDeleteConfirmModal").modal('hide')
				location.reload()
			},
			error: function(status, text, result, xhr) {
				$("#masiveDeleteConfirmModal").modal('hide')
				messagesToDelete = ""
				showDeleteErrorModal(status.responseText);
			}
		});
	}

</script>
</div>















