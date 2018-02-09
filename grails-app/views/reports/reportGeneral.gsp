<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<!-- Bootstrap -->
		<asset:stylesheet src="bootstrap.min.css" />
		<!-- FontAwesome -->
		<asset:stylesheet src='font-awesome/css/font-awesome.css'/>
		<!-- Ionicons -->
		<asset:stylesheet src='ionicons-master/css/ionicons.min.css'/>
		<!-- Skin style -->
		<asset:stylesheet src='skin-blue.css'/>
		<!-- Theme style -->
		<asset:stylesheet src='AdminLTE.css'/>
		<!-- Custom (css propio desarrollado en qv)-->
		<asset:stylesheet src='custom.css'/>
	</head>
	<body style="${params.pdf?'':'padding: 60px'}">
		<div class="row" style="/*padding-left: 100px; padding-right: 100px;*/ padding-top: 50px;">
			<!--Logo-->
			<div class="wrapper" style="text-align: center; padding-bottom: 20px;">
	   			<span style="padding-bottom:10px" class="logo-lg"><asset:image src="logos/logo_thunder_blanco.png" alt="" /></span>
			</div>
			<!--Encabezado Datos Generales-->
			<div class="row container-fluid" style="border: solid black 2px">
				<div class="col-lg-4 col-md-4 col-xs-4 col-sm-4" >
					<h5><b><g:message code="report.projectName"/>:</b> ${project.name} </h5>
					<h5><b><g:message code="report.dateCreated"/>:</b> ${project.dateCreated.format('yyyy/MM/dd')}</h5>
				</div>
				<div class="col-lg-4 col-md-4 col-xs-4 col-sm-4">
					<div align="center">
						<h5><b><g:message code="report.totalPages"/>:</b> ${project.getPages().size()}</h5>
						<h5><b><g:message code="report.totalObjects"/>:</b> ${project.getPages()*.objects.flatten().size()}</h5>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-xs-4 col-sm-4">
					<div class="pull-right">
						<h5><b><g:message code="report.totalScenarios"/>:</b> ${project.scenarios.size()}</h5>
						<h5><b><g:message code="report.totalCases"/>:</b> ${project.scenarios*.cases.flatten().size()}</h5>
					</div>
				</div>
			</div>	

			<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" style="margin-top:30px">
				<h3><g:message code="report.casesByBrowser"/></h3>

				<div class="chart ">
		            <canvas height="230" width="501" id="barChart" style="height: 230px; width: 501px;">
		            </canvas>
				</div>
				<div class="no-border">
					<div class="row" style="margin-right:1%; margin-left:4%; margin-top:-2%">
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
			<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12" style="margin-top:30px">
				<h3><g:message code="report.casesByMonth"/></h3>
		        <div class="chart">
		        	<canvas id="areaChart" height="300" width="600" style="height: 300px; width:100%"></canvas>
		        </div>
	        </div>
		</div>
		<br/>
		<h2 align="center"><label><g:message code="report.detailsByScenario"/>.<label></h2>


		<g:each in="${scenarios}" var="scenario">
			<div class="box box-success box-report">
				<div class="box-header"><label style="font-size:150%">${scenario.name}</label>
					<div class="pull-right box-tools">
						<button class="btn btn-default btn-sm pull-right" data-widget="collapse" style="margin-right: 5px; border:1px solid #e0e0eb">
						<i class="fa fa-minus"> </i>
						</button>
					</div>
				</div>
				<div class="box-body">
					<div class="row" style="margin-bottom:20px">
						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 " >
							<h3><label><g:message code="report.executedCasesPercentage"/></label></h3>
							<div class="row">
					            <div class="col-md-7">
					              <div class="chart-responsive">
					                <canvas style="width: 267px; height: 211px;" width="267" id="doughnutGeneral${scenario.id}" height="211"></canvas>
					              </div>
					              <!-- ./chart-responsive -->
					            </div>
					            <!-- /.col -->
					            <div class="col-md-5">
					              <ul class="chart-legend clearfix">
				                    <li><i class="fa fa-circle-o text-green" ></i> <g:message code="report.executedCases"/><b> ${scenario.executedPercentage}%</b></li>
				                    <li><i class="fa fa-circle-o text-orange"></i> <g:message code="report.nonExecutedCases"/><b> ${scenario.nonExecutedCasesPercentage}% </b></li>
				                  </ul>
					            </div>
					            <!-- /.col -->
					        </div>
						</div>

						<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
							<h3><label><g:message code="report.executedCasesDetail"/></label></h3>
					        <div class="row">
					            <div class="col-md-7">
					              <div class="chart-responsive">
					                <canvas style="width: 267px; height: 211px;" width="267" id="doughnutExecuted${scenario.id}" height="211"></canvas>
					              </div>
					              <!-- ./chart-responsive -->
					            </div>
					            <!-- /.col -->
					            <div class="col-md-5">
					              <ul class="chart-legend clearfix">
				                    <li><i class="fa fa-circle-o text-green"></i> <g:message code="general.success"/><b> ${scenario.successCasesPercentage}%</b></li>
				                    <li><i class="fa fa-circle-o text-red"></i> <g:message code="general.error"/><b> ${scenario.errorCasesPercentage}%</b></li>
				                  </ul>
					            </div>
					            <!-- /.col -->
					        </div>
				        </div>
					</div>
			        <g:each status="j" in="${scenario.cycles}" var="cycle">
						<div class="box box-primary">
							<div class="box-header">
								<div  data-placement="top">
									<b>
										<i class="fa fa-info-circle" style="font-size:150%">  </i>
										<label style="font-size:120%">Ciclo: ${cycle.name}</label>
									</b>
								</div>
								<div class="pull-right box-tools">
									<button class="btn btn-default btn-sm pull-right" data-widget="collapse" style="margin-right: 5px; border:1px solid #e0e0eb">
									<i class="fa fa-minus"> </i>
									</button>
								</div>
							</div>
							<div class="box-body">
								<g:each status="k" in="${cycle.versions}" var="version">
									<div class="row">
										<div class="hide-columns col-md-6 col-lg-6 col-sm-12 col-xs-12" style="">					
											<table class="table table-bordered table-striped table-condensed">		    		
									            <tbody>
										            <tr>
										            	<th><g:message code="report.version"/></th>      
											            <td class="numeric">${version.version}</td>           
										            </tr>
										            <tr>
										            	<th><g:message code="report.executedCases"/></th>
										            	<td>${version.logs.size()}</td>
										            </tr> 
										            <tr>
										            	<th><g:message code="report.failedCases"/></th>
										            	<td>${version.logs.count{it.isSuccess}}</td>
										            </tr>                              
												</tbody>
											</table>
										</div>
										<div class="hide-columns col-md-6 col-lg-6 col-sm-12 col-xs-12" style="">	
												<table class="table table-bordered table-striped table-condensed">		    		
									            <tbody>
										            <tr>
										            	<th><g:message code="report.acumlatedExecutionTime"/></th> 
											            <td class="numeric">${version.totalExecutionTime}</td>           
										            </tr>
										            <tr>
										            	<th><g:message code="report.meanExecutionTimeByCase"/></th>
										            	<td>${version.meanTimeByCase} <g:message code="report.seconds"/></td>
										            </tr> 
												</tbody>
											</table>		
										</div>
									</div>											
								</g:each>
							</div>
						</div>
					</g:each>

		        </div>
		    </div>
		</g:each>
		<g:if test="${!params.pdf}">
			<g:link action="downloadPdf" params="${params}" class="btn btn-primary" target="_blank"><g:message code="report.generatePDF"/></g:link>
		</g:if>			    
	</body>

	<asset:javascript src="jquery-2.1.4.js"/>
	<asset:javascript src="bootstrap.min.js"/>
	<asset:javascript src="adminlte.js"/>
	<asset:javascript src="application.js"/>
	<asset:javascript src="jquery.base64.js"/>
	<asset:javascript src="chart.js"/>
<script type="text/javascript">
	var data = {
	    labels: ["", "", "","", "", ""],
	    datasets: [
	        {
	            label: "${message(code:'general.error')}",
	            fillColor: "rgba(230,33,23,0.7)",
	            strokeColor: "rgba(255,0,0,0.9)",
	            highlightFill: "rgba(255,0,0,0.3)",
	            highlightStroke: "rgba(255,0,0,0.4)",
	            data: [${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome') && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox') && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge') && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari') && !it.isSuccess}},${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer') && !it.isSuccess}},${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera') && !it.isSuccess}}]
	        },
	        {
	            label: "${message(code:'general.success')}",
	            fillColor: "rgba(151,187,205,0.5)",
	            strokeColor: "rgba(151,187,205,0.8)",
	            highlightFill: "rgba(151,187,205,0.3)",
	            highlightStroke: "rgba(151,187,205,0.4)",
	            data: [${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome') && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox') && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge') && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari') && it.isSuccess}},${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer') && it.isSuccess}},${project.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera') && it.isSuccess}}]
	        }
	    ]
	};

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
	            data: [${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  &&  it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()   && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}]
	        },
	        {
	            label: "${message(code:'general.error')}",
	            fillColor: "rgba(221,75,57,0.2)",
	            strokeColor: "rgba(221,75,57,1)",
	            pointColor: "rgba(221,75,57,1)",
	            pointStrokeColor: "rgba(221,75,57,1)",
	            pointHighlightFill: "#rgba(151,187,205,0.2)",
	            pointHighlightStroke: "rgba(151,187,205,0.6)",
	            data: [${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${project.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}]
	        }
	    ]
	};

	$(window).load(function(){
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

		var lineChartCanvas = $("#areaChart").get(0).getContext("2d");
		var myLineChart = new Chart(lineChartCanvas).Line(lineData,{
			datasetFill : true,
		});

		<g:each in="${scenarios}" var="scenario">
			var doughnutData${scenario.id} = [
	    
			    {
			        value: ${scenario.executedCases},
			        color: "#00a65a",
			        highlight: "#3DD991",
			        label: "${message(code:'report.executedCases')}"
			    },
			    {
			        value: ${scenario.nonExecutedCases},
			        color: "#f39c12",
			        highlight: "#F5BB5F",
			        label: "${message(code:'report.nonExecutedCases')}"
			    },
			]
			var ctx = $("#doughnutGeneral${scenario.id}").get(0).getContext("2d");
			var doughtnutOptions = {
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

		    doughtnutOptions.datasetFill = false;
			var doughnutchart${scenario.id} = new Chart(ctx);
			doughnutchart${scenario.id}.Doughnut(doughnutData${scenario.id},doughtnutOptions)


			var doughnutDataExecuted${scenario.id} = [
			    {
			        value: ${scenario.successCases},
			        color: "#00a65a",
			        highlight: "#3DD991",
			        label: "${message(code:'general.success')}"
			    },
			    {
			        value: ${scenario.errorCases},
			        color: "rgb(221,75,57)",
			        highlight: "#F5BB5F",
			        label: "${message(code:'general.error')}"
			    },
			]
			var ctx = $("#doughnutExecuted${scenario.id}").get(0).getContext("2d");
			
			var doughnutchartExecuted${scenario.id} = new Chart(ctx);
			doughnutchartExecuted${scenario.id}.Doughnut(doughnutDataExecuted${scenario.id},doughtnutOptions)


	
		</g:each>
	})


</script>
</html>