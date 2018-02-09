<g:render template="/user/user/navBar"/>
	<asset:javascript src="chart.js"/>
<!-- Content Wrapper. Contains page content -->
	<div class="content-wrapper">
		<!-- Main content -->
		<section class="content"  id="principalSection">
			<!-- Small boxes (Stat box) -->
			<g:render template="/user/user/boxes-0"/>
			<!-- /.row -->
			<!-- Main row -->
			<div class="row">

				<!-- Left col -->
				<section class="col-lg-7 connectedSortable">

					<!-- Projects weather -->
					<div class="box box-warning">
						<div class="box-header">
							<i class="ion ion-ios-partlysunny"> </i>
							<h3 class="box-title"><g:message code='text.projects'/>
							(<g:message code='text.projects.details'/>)</h3>
							<button class="btn btn-default btn-sm pull-right" data-widget='collapse' style="margin-right: 5px; border:1px solid #e0e0eb">
								<i class="fa fa-minus"> </i>
							</button>
						</div>
						<!-- /.box-header -->
						<div class="box-body">
							<ul style="padding-left:0px">
								<g:each in="${projects}" var='project'>
								
									<g:if test="${project.logs.size()==0}">
										<a href="${createLink(controller:'statistic', action:'chooseAProject',params:[pjDetailId:project.id])}">
											<li style="list-style-type:none; background-color:#f4f4f4; margin-bottom:4px" class="projectWeather"><asset:image src='weather/health-80plus.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">0%</span>
											</li>
										</a>
									</g:if>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=80}">
										<a href="${createLink(controller:'statistic', action:'chooseAProject',params:[pjDetailId:project.id])}">
											<li style="list-style-type:none; background-color:#f4f4f4;margin-bottom:4px " class="projectWeather"><asset:image src='weather/health-80plus.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=60}">
										<a href="${createLink(controller:'statistic', action:'chooseAProject',params:[pjDetailId:project.id])}">
											<li style="list-style-type:none; background-color:#f4f4f4;margin-bottom:4px " class="projectWeather"><asset:image src='weather/health-60to79.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=40}">
										<a href="${createLink(controller:'statistic', action:'chooseAProject',params:[pjDetailId:project.id])}">
											<li style="list-style-type:none; background-color:#f4f4f4; margin-bottom:4px" class="projectWeather"><asset:image src='weather/health-40to59.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:elseif test="${project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size()>=20}">
										<a href="${createLink(controller:'statistic', action:'chooseAProject',params:[pjDetailId:project.id])}">
											<li style="list-style-type:none; background-color:#f4f4f4; margin-bottom:4px" class="projectWeather"><asset:image src='weather/health-20to39.png' style="margin:1%"/>  ${project.name}
												<span class="label label-success pull-right" style="margin-top:1%; margin-right:1%">${Math.floor(project.logs*.logs.flatten().count{it.isSuccess}*100/project.logs*.logs.flatten().size())}%</span>
											</li>
										</a>
									</g:elseif>
									<g:else>
										<a href="${createLink(controller:'statistic', action:'chooseAProject',params:[pjDetailId:project.id])}">
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

				</section>

<!-- /.Left col -->
<!-- right col (We are only adding the ID to make the widgets sortable)-->
<section class="col-lg-5 connectedSortable">

	<!-- Map box -->
	<div class="box box-danger ">
		<div class="box-header">
			<!-- tools box -->
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
          <!-- /.info-box -->
          <div class="info-box bg-green">
            <span class="info-box-icon"><i class="ion ion-ios-list-outline"></i></span>

            <div class="info-box-content" id="scenariosInfo">
              <span class="info-box-text"><g:message code='text.scenarios'/></span>

              <span class="info-box-number"></span>

              <span class="info-box-number">0</span>
              
              <div class="progress">
                <div class="progress-bar" style="width: 0%"></div>
                <div class="progress-bar"></div>
              </div>
                  <span class="progress-description">
                      <g:message code="statistic.message.scenarios" args="[0]"/>
                  </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
          <div class="info-box bg-red">
            <span class="info-box-icon"><i class="ion ion-network"></i></span>

            <div class="info-box-content" id="casesInfo">
              <span class="info-box-text"><g:message code="text.cases"/></span>
              <span class="info-box-number">0</span>
              <span class="info-box-number"></span>

              <div class="progress">
                <div class="progress-bar" style="width: 0%"></div>
                <div class="progress-bar"></div>
              </div>
                  <span class="progress-description">
                    <g:message code="statistic.message.cases" args="[0]"/>
                  </span>
            </div>
            <!-- /.info-box-content -->
          </div>
          <!-- /.info-box -->
          <div class="info-box bg-aqua">
            <span class="info-box-icon"><i class="ion-ios-browsers-outline"></i></span>

            <div class="info-box-content">
              <span class="info-box-text"><g:message code='text.pages'/></span>
              <span class="info-box-number">0</span>

              <div class="progress">
                <div class="progress-bar" style="width: 0%"></div>
              </div>
                  <span class="progress-description">
                   <g:message code="statistic.message.pages" args="[0]"/>
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

		</section>
<!-- right col -->
</div>
<!-- /.row (main row) -->

</section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->
<g:render template="/user/user/footer"/>


</div>

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


<script type="text/javascript">
	var selectedAvatar="avatares-01.png"
	var currentPageNumber = 1
	var webLoggedInUsers
	var desktopLoggedInUsers
	var users = "${users.encodeAsJSON()}"
	var userDeletingId = null

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
	            data: [${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  &&  it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()   && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.issuccess}}]
	        },
	        {
	            label: "${message(code:'general.error')}",
	            fillColor: "rgba(221,75,57,0.2)",
	            strokeColor: "rgba(221,75,57,1)",
	            pointColor: "rgba(221,75,57,1)",
	            pointStrokeColor: "rgba(221,75,57,1)",
	            pointHighlightFill: "#rgba(151,187,205,0.2)",
	            pointHighlightStroke: "rgba(151,187,205,0.6)",
	            data: [${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}, ${projects*.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.issuccess}}]
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
	})

	$('#expiredSessionModal').on('hidden.bs.modal', function () {
		location.reload()
	})
	$('#newUserModal').on('hidden.bs.modal', function () {
		$('#loadingState').css("display","none");
	})


	$('.modal').on('hidden.bs.modal', function() {
		$("body").css('padding-right','0px')
	})

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