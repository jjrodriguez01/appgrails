<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<asset:javascript src="chart.js"/>
		<asset:javascript src="echarts-all.js"/>
		<asset:javascript src="jquery-2.1.4.js"/>
		<asset:javascript src="bootstrap.min.js"/>
		<asset:javascript src="adminlte.js"/>
		<asset:javascript src="application.js"/>
		<asset:javascript src="sorttable.js"/>
		<asset:javascript src="jquery-sortable.min.js"/>
		<asset:javascript src="jquery.base64.js"/>
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
<body>	
	<div class="row" style="padding-left: 100px; padding-right: 100px; padding-top: 50px;">
		<!--Logo-->
		<div class="wrapper" style="text-align: center; padding-bottom: 20px;">
   			<span style="padding-bottom:10px" class="logo-lg"><asset:image src="logos/logo_thunder_blanco.png" alt="" /></span>
		</div>
		<!--Tabla Datos Generales-->
		<div class="panel">
		    <div class="panel-body">
		    	<div class="box box-success"> 	        
			        <div class="box-header">
						<div class="have-tooltip" data-content="${message(code:'tooltip.myUsers.text')}" data-placement="top" style="cursor:pointer">
							<i class="fa fa-area-chart"> </i>
							<h3 class="box-title">Datos Generales del Proyecto '${project.name}'</h3>
						</div>
					</div>
					<div class="box-body">							    
						<div class="hide-columns" style="">					
							<table class="table table-bordered table-striped table-condensed">			    		
					            <tbody>
						            <tr>
						            	<th>Total de Ejecuciones</th>					                
							                <td class="numeric">${project.logs.size()}</td>					                
						            </tr>
						            <tr>
						            	<th>Total de Escenarios Creados</th>					                
							                <td>${project.scenarios.flatten().size()}</td>            				                
						            </tr>
						            <tr>
						            	<th>Total de Casos Creados</th>					                
							                <td>${project.scenarios.flatten().cases.flatten().size()}</td>                
						            </tr>				                              
								</tbody>
							</table>
						</div>
					</div>		
				</div>				
			</div>			
		</div>
		<div class="panel">
			<div class="panel-body" align="center">
				<div id="main" align="center" style="height:400px; width: 600px;"></div>
			</div>
		</div>
		<!--Tabla Datos Generales-->
		<div class="panel">
		    <div class="panel-body">
		        <h3 class="title-hero">
		        Metricas por Ciclos - Proyecto '${project.name}'
		        </h3>		        		    
				<div class="hide-columns" style="padding-top:30px;">
					<g:each status="i" in="${project.scenarios}" var="scenario">
						<div class="panel panel-info">
							<div class="panel-heading">
								<div class="have-tooltip"  title="${message(code:'tooltip.myUsers.title')}" data-content="${message(code:'tooltip.myUsers.text')}" data-placement="top" style="cursor:pointer">									
									<h3 class="box-title">Escenario '${scenario.name}'</h3>									
								</div>
							</div>						
							<g:each status="j" in="${cycles}" var="cycle">
								<div class="panel-body">
									<div class="box box-primary">
										<div class="box-header">
											<div class="have-tooltip"  title="${message(code:'tooltip.myUsers.title')}" data-content="${message(code:'tooltip.myUsers.text')}" data-placement="top" style="cursor:pointer">
												<i class="fa fa-info-circle"  > </i>
												<h3 class="box-title">Ciclo ${cycle.name}</h3>									
											</div>
										</div>
										<div class="box-body">
											<g:each status="k" in="${cycle.versions}" var="version">
												<div class="hide-columns" style="">					
													<table class="table table-bordered table-striped table-condensed">		    		
											            <tbody>
												            <tr>
												            	<th>Version</th>      
													            <td class="numeric">${version.version}</td>           
												            </tr>
												            <tr>
												            	<th>Casos Ejecutados</th>				
												            	<td>${version.logs.size()}</td>
												            </tr> 
												            <tr>
												            	<th>Casos Fallidos</th>				
												            	<td>${version.logs.count{it.isSuccess}}</td>
												            </tr>                              
														</tbody>
													</table>
												</div>											
											</g:each>
										</div>
									</div>
								</div>
							</g:each>
						</div>
					</g:each>
				</div>				
			</div>			
		</div>
	</div>	
</body>
<script type="text/javascript">
	var myChart = echarts.init(document.getElementById('main'));
	var option = {
	    title : {
	        text: 'Ejecuciones por Navegador',
	        subtext: '',
	        x:'center'
	    },
	    tooltip : {
	        trigger: 'item',
	        formatter: "{a} <br/>{b} : {c} ({d}%)"
	    },
	    legend: {
	        orient : 'vertical',
	        x : 'left',
	        y: '50',
	        data:['Chrome','Firefox','IE','Opera','Safari', 'Edge']
	    },
	    toolbox: {
	        show : false,
	        feature : {
	            mark : {show: true},
	            dataView : {show: true, readOnly: false},
	            magicType : {
	                show: true, 
	                type: ['pie', 'funnel'],
	                option: {
	                    funnel: {
	                        x: '25%',
	                        width: '50%',
	                        funnelAlign: 'left',
	                        max: 1548
	                    }
	                }
	            },
	            restore : {show: true},
	            saveAsImage : {show: true}
	        }
	    },
	    calculable : true,
	    series : [
	        {
	            name:'Series',
	            type:'pie',
	            radius : '70%',
	            center: ['50%', '60%'],
	            data:[
	                {value:${project.logs.logs.flatten().count{it.browser.toLowerCase().contains('chrome') && it.isSuccess}}, name:'Chrome'},
	                {value:${project.logs.logs.flatten().count{it.browser.toLowerCase().contains('firefox') && it.isSuccess}}, name:'Firefox'},
	                {value:${project.logs.logs.flatten().count{it.browser.toLowerCase().contains('explorer') && it.isSuccess}}, name:'IE'},
	                {value:${project.logs.logs.flatten().count{it.browser.toLowerCase().contains('opera') && it.isSuccess}}, name:'Opera'},
	                {value:${project.logs.logs.flatten().count{it.browser.toLowerCase().contains('safari') && it.isSuccess}}, name:'Safari'},
	                {value:${project.logs.logs.flatten().count{it.browser.toLowerCase().contains('edge') && it.isSuccess}}, name:'Edge'}
	            ]
	        }
	    ]
	};
	myChart.setOption(option);
</script>
</html>