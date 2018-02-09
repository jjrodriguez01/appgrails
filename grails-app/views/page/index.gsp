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
			<g:render template="/user/leader/boxes-0"/>
		</sec:ifAllGranted>
		<sec:ifNotGranted  roles="ROLE_USER_LEADER">
			<g:render template="/user/user/boxes-0"/>
		</sec:ifNotGranted>
<!-- /.row -->
<!-- Main row -->
		<div class="row">
			<div class="col-xs-12">
				<div class="nav-tabs-custom">
					<!-- Tabs within a box -->
					<ul class="nav nav-tabs pull-right">
						<li class="active">
							<a href="#revenue-chart" data-toggle="tab">
								<i class="fa fa-list-alt" style="color: blue"> </i>
								<g:message code="text.pages" />
							</a>
						</li>
						<sec:ifAnyGranted roles="${functionality5.roles}">
							<li>
								<a href="#newPage-chart" data-toggle="tab">
								<i class="fa fa-plus" style="color: green"> </i> 
								<g:message code="text.new" /> </a>
							</li>
						</sec:ifAnyGranted>
						<li class="pull-left header"><i class="fa fa-inbox"> </i> 
							<g:message code="text.pages" />
						</li>
					</ul>


					<div class="tab-content no-padding">
						<!-- Morris chart - Sales -->
						<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
							<div class="box">

								<!-- /.box-header -->
								<div class="box-body">
									<div class="col-md-6">
											
									</div>
									<div class="col-md-6">
										<ol class="breadcrumb pull-right" style="background-color:white">
											<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
								        	<li><g:link controller='project' action='index'>${associatedProject.name}</g:link></li>
								       		<li class="active"><g:message code="text.pages"/></li>
								    	</ol>
									</div>

									<label> 
										<g:message code="datatable.showing"/>
									</label> 
									<select id="rowsPerPageSelect" >
										<option value="10">10</option>
										<option value="25">25</option>
										<option value="50">50</option>
										<option value="100">100</option>
									</select>
									<label style="margin-right:50px"> 
										<g:message code="datatable.entries"/>
									</label>
									<label for="search">
											<g:message code="datatable.search"/>: 
										</label>
									<input id="datatablesearch" table="pagesTable"  name="search" type="text" />
									<div class="pull-right">																				
										<button class="btn btn-danger pull-right" id="deleteSelection" ><g:message code="text.delete" /> <i class="fa fa-trash"></i></button>
										<label style="padding-top: 6px; margin-left:100px;" class="pull-right">
											<g:message code="general.text.selectAll" />
											<input id="selectAllRowsSwitch" class="ios-switch"  type="checkbox">
											<div class="switch"></div>
										</label>
									</div>
											<table id="pagesTable"
												class="table table-bordered table-striped sortable paginated">
												<thead>
													<tr>
														<th></th>
														<th><g:message code="text.name" /></th>
														<th><g:message code="text.description" /></th>
														<th><g:message code="text.typeOfPage"/></th>
														<th><g:message code="text.objects" /></th>
														<th><g:message code="text.messages" /></th>
														<sec:ifAnyGranted roles="${functionality6.roles}">
															<th><g:message code="text.edit" />/<g:message code="text.delete" /></th>
														</sec:ifAnyGranted>
													</tr>
												</thead>
												<tbody>
													<g:each in="${pages}">
														<tr class="trSelectablePage" select="0" id="${it.id}">
															<sec:ifAnyGranted roles="${functionality7.roles}">
																<td id="${it.id}" style="cursor: pointer;" class="duplicateCell">
																	<span>
																		<i class="fa fa-copy"></i>
																	</span>
																</td>
															</sec:ifAnyGranted>
															<sec:ifNotGranted roles="${functionality7.roles}">
																<td>
																	<a href="#" onclick="showDemoRestrictionModal()">
																		<i class="fa fa-copy" style="color:black"> </i>
																	</a>
																</td>
															</sec:ifNotGranted>
															<td>
																<a href="${createLink(controller:'object', action:'index', id:it.id, params:[projectId:projectId])}"  id="name${it.id}" class="navLink editInput">
																	${it.name}
																</a>
															</td>
															<td id="description${it.id}">
																${it.description}
															</td>
															<td>
																<g:if test="${it.isPrivate}">
																	<span class="label label-warning" id="span${it.id}">
																		<g:message code="text.private" />
																	</span>
																</g:if> 
																<g:else>
																	<span class="label label-success" id="span${it.id}">
																		<g:message code="text.public" />
																	</span>
																</g:else>
															</td>
															<td>
																<g:link controller="object" action="index" id="${it.id}"  params="[projectId:projectId]" class="navLink">
																	<g:message code="text.viewObjects" />
																</g:link>
															</td>
															<td>
															<sec:ifAnyGranted roles="${functionality29.roles}">
																<g:link controller="message" action="index" id="${it.id}"  params="[projectId:projectId]" class="navLink">
																	<g:message code="text.viewMessages" />
																</g:link>
															</sec:ifAnyGranted>
															<sec:ifNotGranted roles="${functionality29.roles}">
																<a href="#" onclick="showDemoRestrictionModal()">
																	<g:message code="text.viewMessages" />
																</a>
															</sec:ifNotGranted>
															</td>
															
															<sec:ifAllGranted roles="ROLE_USER_LEADER">
																<td>
																	<a href="#" onclick="showEditPageModal(${it.id}, '${it.creator.id}'); return false;">
																		<i class="fa fa-edit"> </i>
																	</a>
																
																	<a href="#" onclick="setDeletingId(${it.id}); return false;" style="color:red">
																		<i class="fa fa-trash-o"> </i>
																	</a>
																</td>
															</sec:ifAllGranted>
														</tr>
													</g:each>
												</tbody>
											</table>
									</div>
										<!-- /.box-body -->
								</div>
								<!-- /.box -->
							</div>
							<sec:ifAnyGranted roles="${functionality5.roles}">
								<div class="chart tab-pane" id="newPage-chart"
									style="position: relative; height: 300px;">
									<form id="formNewPage"
										style="margin-left: 20px; padding-right: 20px;">
										<br/>
										<label for="name"><g:message code="text.name" /></label> <input
											class="form-control" type="text" name="name" id="name"><br>
										<label for="description"><g:message
												code="text.description" /></label> <input class="form-control"
												type="text" name="description" id="description"><br>
										<label>
											<g:message code="text.privatePage" />
											<input id="isPrivatePage" type="checkbox" class="ios-switch objectSwitch" />
											<div class="switch"></div>
										</label>
										<button type="button" id="formNewPageButton" class="btn btn-info pull-right"
												 onclick="createPage(this)"><g:message code="general.text.save"/>
										</button>

									</form>
								</div>
							</sec:ifAnyGranted>
						
						</div>
					</div>
			</div>
			<!-- /.col -->
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

<!-- Modal de edición de page -->
<div id="editPageModal" class="modal fade" role="dialog">
	<div class="modal-dialog">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h3>
					<g:message code="text.edit" />
					<g:message code="text.page" />
				</h3>
			</div>
			<div class="modal-body">
				<form id="formEditPage"
					style="margin-left: 20px; margin-right: 20px;">

					<label for="name"><g:message code="text.name" /></label> <input
						class="form-control editInput" type="text" name="name" id="editName"><br>
					<label for="description"><g:message code="text.description" /></label>
					<input class="form-control editInput" type="text" name="description"
						id="editDescription"><br> <label
						id="labelEditPrivate"><g:message code="text.privatePage" /><input
						id="editIsPrivatePage" type="checkbox"
						class="ios-switch objectSwitch" />
					<div class="switch"></div></label> <br>
					
				</form>
			</div>
		</div>
	</div>
</div>

<!-- fin del modal de edición de page -->



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


<!-- Modal de exito de registro de page -->

<div id="newPageSuccessModal" class="modal fade " role="dialog">
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
				<p>
					<g:message code="text.successCreatePage" />
				</p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de exito de registro de page -->


<!-- Modal de exito de edición de page -->

<div id="editPageSuccessModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-success">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="text.success" />
				</h4>
			</div>
			<div class="modal-body">
				<p>
					<g:message code="text.successEditPage" />
				</p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de exito de edición de page -->




<!-- Modal de error de registro de page -->
<div id="newPageErrorModal" class="modal fade " role="dialog">
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
				<p id="newPageErrorMessage"></p>
			</div>
		</div>
	</div>
</div>
<!-- Fin del modal de error de registro de page -->


<!-- Modal de información de page -->
<div id="infoPageModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">

			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h3>
					<g:message code="text.pageInfo" />
				</h3>
			</div>
			<div class="modal-body">
				<h5>
					<b> <g:message code="text.name" /> :
					</b>
				</h5>
				<p id="infoNameField"></p>
				<h5>
					<b><g:message code="text.description" /> :</b>
				</h5>
				<p id="infoDescriptionField"></p>
				<h5>
					<b><g:message code="text.typeOfPage" /> :</b>
				</h5>
				<p id="infoIsPrivatePageField"></p>
				<h5>
					<b> <g:message code="text.createdDate" /> :
					</b>
				</h5>
				<p id="infoDateCreatedField"></p>
				<h5>
					<b> <g:message code="text.lastUpdatedDate" /> :
					</b>
				</h5>
				<p id="infoLastUpdatedField"></p>
				<h5>
					<b> <g:message code="text.lastUpdatedBy" /> :
					</b>
				</h5>
				<p id="infoLastUpdatedByField"></p>
			</div>
		</div>

	</div>
</div>

<!-- fin del modal de información de page -->


<!-- Modal de duplicacion de pagina -->
<div id="duplicatePageModal" class="modal fade" role="dialog">
	<div class="modal-dialog">
		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h3>
					<g:message code="text.duplicatePage" />
				</h3>
			</div>
			<div class="modal-body">
				<label for="duplicateProject"><g:message code="text.project"/></label>
				<select class="form-control" id="duplicateProject">
					<g:each in="${projects}" var="project">
						<option value="${project.id}">${project.name}</option>
					</g:each>
				</select>
				<br/>
				<label for="duplicateName"><g:message code="text.name"/></label>
				<input type="text" id="duplicateName" class="form-control"></input>
				<br/>
				<label for="duplicateDescription"><g:message code="text.description"/></label>
				<input type="text" id="duplicateDescription" class="form-control"></input>
				<br/>
				<label id="labelDuplicatePrivate"><g:message code="text.privatePage" />
					<input id="duplicateIsPrivatePage" type="checkbox" class="ios-switch objectSwitch" />
					<div class="switch"></div>
				</label> 
				<br/>
				<button class="btn btn-info pull-right" onclick="duplicatePage(); return false;"> 
					<g:message code="general.text.continue"/>
				</button>
				<br/>
				<br/>
			</div>
		</div>
	</div>
</div>
<!-- Fin del modal de duplicacion-->



<!-- Modal de confirmación de borrado de page -->
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
					onclick="deletePage()">
					<g:message code="general.text.continue" />
				</button>
			</div>
		</div>
	</div>
</div>
<!-- Final del modal de confirmación -->

<!-- Modal de confirmación de borrado masivo de Paginas -->
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
					onclick="masiveDeletePages()">
					<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación de borrado masivo de Paginas -->

	<!-- plantilla para modal de restricciones cuenta demo-->
	<g:render template="/user/restrictionsDemo"/>

<script type="text/javascript">

	Date.prototype.adjustDate = function() {
	    var now = new Date()
		var localOffset = now.getTimezoneOffset();
		var modifiedDate = new Date(this.getTime()-(${offset}+localOffset)*60000)
		var yyyy = modifiedDate.getFullYear().toString();
		var mm = (modifiedDate.getMonth()+1).toString(); // getMonth() is zero-based
	   	var dd  = modifiedDate.getDate().toString();
	   	var hh = modifiedDate.getHours().toString();
	   	var mi = modifiedDate.getMinutes().toString();
	   	var ss = modifiedDate.getSeconds().toString();
	   	return yyyy +"-"+ (mm[1]?mm:"0"+mm[0]) +"-"+ (dd[1]?dd:"0"+dd[0]) + " " + (hh[1]?hh:"0"+hh[0]) + ":" + (mi[1]?mi:"0"+mi[0]) + ":" + (ss[1]?ss:"0"+ss[0]); // padding
	};

	var editingId=null;
	var currentPage = 0;
	var numPerPage = 10;
	var pagesToDelete = ""


	
	$(window).load( function(){
		notificationsInterval= setInterval(getNotifications, 8000);
		enableSearch()

	})

	$('#newPageErrorModal').on('hidden.bs.modal', function() {
		$("body").css('padding-right','0px')
	})
	$('#editPageModal').on('hidden.bs.modal', function() {
		editingId=null
	})


	$('#rowsPerPageSelect').change(function(){
		numPerPage = $(this).val()
		$('.pager').remove()
		makeTablePaginated()
	}); 

	$('.duplicateCell').click(function() {
		duplicatingId=$(this).attr('id')
		$('#duplicateProject').val("${associatedProject.id}")
		$("#duplicatePageModal").modal('show')
		
	});
	

    function setDeletingId(newId) {
        deletingId = newId
        $('#confirmModal').modal('show');

    }


	makeTablePaginated()



	$('#newPageErrorModal').on('hidden.bs.modal', function() {
		$("body").css('padding-right','0px')
	})

	
	function createPage(button){
		$(button).prop("disabled", true)
		$(button).html("<i class='fa fa-spinner fa-spin'></i>");

		var description = $('#description').val()
		var name = $('#name').val()
		var isPrivate = $("#isPrivatePage").prop('checked')
		$.ajax({
			method: 'POST',
			url: "${createLink(action:'create', controller:'page')}",
			data:{
				description:description,
				name:name,
				isPrivate:isPrivate,
				projectId: ${projectId}
			},
			success: function(dataCheck) {
				location.reload(true)
			},
			error: function(status, text, result, xhr) {
				$(button).html("${message(code:'general.text.save')}")
				$(button).prop("disabled", false)
				$('#newPageErrorMessage').html(status.responseText)
				$('#newPageErrorModal').modal('show');
			}
		});

	}


	function savePage(){
		
		var description = $('#editDescription').val()
		var name = $('#editName').val()
		var isPrivate = $("#editIsPrivatePage").prop('checked')
		$.ajax({
			method: 'POST',
			url: "${createLink(action:'update', controller:'page')}",
			data:{
				id:editingId,
				description:description,
				name:name,
				isPrivate:isPrivate,
				projectId: ${projectId}
			},
			success: function(dataCheck) {
				$('#name'+editingId).text(name)
				$('#description'+editingId).text(description)
				if($('#editIsPrivatePage').is(":visible")){

					if($('#editIsPrivatePage').is(':checked')){
						$('#span'+editingId).removeClass('label-success')
						$('#span'+editingId).addClass('label-warning')
						$('#span'+editingId).text("${message(code:'text.private')}")
					}
					else{
						$('#span'+editingId).removeClass('label-warning')
						$('#span'+editingId).addClass('label-success')
						$('#span'+editingId).text("${message(code:'text.public')}")
					}
				}
				
			

				},
			error: function(status, text, result, xhr) {
				$('#newPageErrorMessage').html(status.responseText)
				$('#newPageErrorModal').modal('show');
			}
		});
	}



    function duplicatePage(){
    	$("#duplicatePageModal").modal('hide')
        var duplicateName = $("#duplicateName").val().replace(/\s+/, "") 
        var duplicateDescription = $("#duplicateDescription").val().replace(/\s+/, "") 
        var isPrivate = $("#duplicateIsPrivatePage").prop('checked')
        var duplicateProject = $("#duplicateProject").val()
    	 $.ajax({
             method: "POST",
             url: "${createLink(action:'duplicate', controller:'page')}",
             data: {
                 id: duplicatingId,
                 isPrivate:isPrivate,
                 projectId: ${projectId},
                 duplicateProject: duplicateProject,
                 description: duplicateDescription,
                 name:duplicateName
             },
             success: function(result) {
                 location.reload(true)
             },
             error: function(status, text, result, xhr) {
                 $('#newPageErrorMessage').html(status.responseText)
				 $('#newPageErrorModal').modal('show');
             }
         });
    }



    function deletePage() {
        $.ajax({
            method: "POST",
            url: "${createLink(action:'secureDelete', controller:'page')}",
            data: {
                id: deletingId,
                projectId: ${projectId},
            },
            success: function(result) {
                $('#confirmModal').modal('hide')
                location.reload()
            },
            error: function(status, text, result, xhr) {
                showDeleteErrorModal(status.responseText);
            }
        });
    }




	function showDeleteErrorModal(text){
		$('#confirmModal').modal('hide');
		$('#newPageErrorMessage').html(text)
		$('#newPageErrorModal').modal('show');
	}



	function showEditPageModal(id, creator)
	{
		var isPrivate = $('#span'+id).hasClass('label-warning')
		editingId=id
		var creatorId = "${sec.loggedInUserInfo(field: 'id')}"
		$('#editName').val($('#name'+id).text().trim())
		$('#editDescription').val($('#description'+id).text().trim())
		
		if(isPrivate){

			$('#editIsPrivatePage').prop('checked', true)
			if(creatorId==creator){
				$('#labelEditPrivate').css('display', 'block')
			}
			else{
				$('#labelEditPrivate').css('display', 'none')
			}

		}
		else{
			$('#labelEditPrivate').css('display', 'none')
		}
		

		$('#editPageModal').modal('show');
	}
	
	$('.editInput').keyup(function(){
		if(editingId!=null)
			savePage()

	})
	$('#editIsPrivatePage').change(function()
	{	
		savePage()

	})

	
	function showInfoPageModal(name, description, isPrivate, lastUpdated, dateCreated, updatedBy)
	{
		$('#infoNameField').html(name)
		$('#infoDescriptionField').html(description)
		if(isPrivate=="true")
			$('#infoIsPrivatePageField').html("${message(code:'text.private')}")
		else
			$('#infoIsPrivatePageField').html("${message(code:'text.public')}")

		$('#infoLastUpdatedField').html(new Date(lastUpdated).adjustDate())
		$('#infoDateCreatedField').html(new Date(dateCreated).adjustDate())
		$('#infoLastUpdatedByField').html(updatedBy)
		$('#infoPageModal').modal('show');
		$('#infoPageModal').modal('show');
	}
	
	var flag=false;


	$('#expiredSessionModal').on('hidden.bs.modal', function() {
		location.reload()
	})
	$('#newPageSuccessModal').on('hidden.bs.modal', function() {
		location.reload()
	})
	$('#editPageSuccessModal').on('hidden.bs.modal', function() {
		location.reload()
	})

$('#selectAllRowsSwitch').change(function(){
	if(this.checked) {
		$('.trSelectablePage').each(function(i, obj) {
			$(this).css('background-color','#ccd9ff')
			$(this).attr('select','1')
		});
	}
	else{				
		$('.trSelectablePage').each(function(i, obj) {			
			$(this).css('background-color','')
			$(this).attr('select','0')			
		});				
	}
})

$('.trSelectablePage').click(function(){
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
	$("#pagesTable > tbody > .trSelectablePage").each(function() {
		if($(this).attr('select')=='1'){
			pagesToDelete+=$(this).attr('id')+","
		}
	});
	if(pagesToDelete!=""){
		$("#masiveDeleteConfirmModal").modal('show')
	}	
})

function masiveDeletePages(){
	$.ajax({
        method: "POST",
        url: "${createLink(action:'secureMasiveDelete', controller:'page')}",
        data: {
            pagesToDelete: pagesToDelete,
            projectId: ${projectId}
        },
        success: function(result) {
        	$("#masiveDeleteConfirmModal").modal('hide')
        	location.reload()
        },
        error: function(status, text, result, xhr) {
        	$("#masiveDeleteConfirmModal").modal('hide')
        	pagesToDelete = ""
            showDeleteErrorModal(status.responseText);
        }
    });
}

</script>
</div>
</body>
</html>

