package com.model

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON
import com.helpers.Token
import org.apache.poi.xssf.usermodel.*
import org.apache.poi.ss.usermodel.*
import org.apache.poi.ss.util.*

class ReportsController {

    def index() { }

	@Secured(['permitAll'])
	def reportGenerate() {	
		if(params.reportType== "excelReport"){
			redirect action:"downloadExcel", params:params
		}
				
		def report = params.reportType
		def idProject = params.projecId
		def project = Project.findById(idProject)
		if(!report || !project){
			redirect controller:"project", action:"index"
			return	
		}
		
		def scenarios = []

		for(scenario in project.scenarios.sort{it.dateCreated}){
			def executionsByCycle = project.logs.findAll{it.scenario==scenario.name}.groupBy{it.cycle}
			def executedCases = project.logs.findAll{it.scenario==scenario.name}.flatten()*.logs.flatten().unique{it.caseName}.size()
			def executedCasesPercentage = scenario.cases.size() > 0 ? executedCases * 100 / scenario.cases.size():0
			def nonExecutedCases = scenario.cases.size() - executedCases
			def nonExecutedCasesPercentage = scenario.cases.size() > 0 ?nonExecutedCases * 100 / scenario.cases.size():0
			def successCases = project.logs.findAll{it.scenario==scenario.name}*.logs.flatten().count{it.isSuccess}
			def errorCases = project.logs.findAll{it.scenario==scenario.name}*.logs.flatten().count{!it.isSuccess}
			def successCasesPercentage = project.logs.findAll{it.scenario==scenario.name}*.logs.flatten().size() > 0 ? (successCases * 100 / project.logs.findAll{it.scenario==scenario.name}*.logs.flatten().size()).setScale(2, BigDecimal.ROUND_DOWN):0
			def errorCasesPercentage = project.logs.findAll{it.scenario==scenario.name}*.logs.flatten().size() > 0 ? (errorCases * 100 / project.logs.findAll{it.scenario==scenario.name}*.logs.flatten().size()).setScale(2, BigDecimal.ROUND_DOWN):0

			def currentScenario = [name: scenario.name, executedCases:executedCases,nonExecutedCases:nonExecutedCases, executedPercentage: executedCasesPercentage==0?0:executedCasesPercentage.setScale(2, BigDecimal.ROUND_DOWN), nonExecutedCasesPercentage:nonExecutedCasesPercentage ==0?0:nonExecutedCasesPercentage.setScale(2, BigDecimal.ROUND_DOWN), id:scenario.id, cycles:[], successCases:successCases, errorCases:errorCases, successCasesPercentage:successCasesPercentage, errorCasesPercentage:errorCasesPercentage]
			for(cycle in executionsByCycle.keySet().sort()){
				def byVersion =  executionsByCycle.get(cycle).groupBy{it.appVersion}
				def currentCycle = [name:cycle, versions:[]]
				for(version in byVersion.keySet().sort()){
					int totalExecutionsSeconds = byVersion.get(version)*.duration.sum{Integer.parseInt(it.split(':')[2])}
					int totalExecutionsMinutes = byVersion.get(version)*.duration.sum{Integer.parseInt(it.split(':')[1])}
					int totalExecutionsHours = byVersion.get(version)*.duration.sum{Integer.parseInt(it.split(':')[0])}
					
					totalExecutionsMinutes+=Math.floor(totalExecutionsSeconds/60)
					totalExecutionsSeconds =  totalExecutionsSeconds % 60

					totalExecutionsHours+=Math.floor(totalExecutionsMinutes/60)
					totalExecutionsMinutes =  totalExecutionsMinutes % 60

					int allInSeconds = totalExecutionsHours*3600 + totalExecutionsMinutes*60 +  totalExecutionsSeconds
					def meanInSeconds = allInSeconds/byVersion.get(version)*.logs.flatten().size()
					println "TOtal seconds:   "+totalExecutionsSeconds
					currentCycle.versions.push([version:version, logs:byVersion.get(version)*.logs.flatten(), totalExecutionTime:totalExecutionsHours+":"+totalExecutionsMinutes+":"+totalExecutionsSeconds, meanTimeByCase: meanInSeconds])
					
				}
				currentScenario.cycles.push(currentCycle)
			}
			scenarios.push(currentScenario)
		}
		params.remove('action')
		switch(report) {
			case "reportGeneral":
				render view:"reportGeneral", model:[project: project, params:params, scenarios:scenarios]
			break
			
		}		
		return
	}

	@Secured(['permitAll'])
	def downloadPdf() {
		params.pdf = true
		def config = grailsApplication.config		
		String pathToPhantomJS = config.pathToPhantomJS
		String pathToRasterizeJS = config.pathToRasterizeJS
		String paperSize = config.paperSize
		String url = "$request.scheme://$request.serverName:$request.serverPort"+createLink(controller:'reports', action:'reportGenerate', params: params)
		println url
		//String url = "https://www.google.com.co"
		File outputFile = File.createTempFile("sample", ".pdf")
		//TODO: also do exception handling stuff . i am not doing this for simplicity
		Process process = Runtime.getRuntime().exec(pathToPhantomJS + " " + pathToRasterizeJS + " " + url + " " + outputFile.absolutePath + " " + paperSize);
		int exitStatus = process.waitFor(); //do a wait here to prevent it running for ever
		if (exitStatus != 0) {
			println "EXIT-STATUS - " + process.toString();
		}
		response.contentType = "application/pdf"
		response.setHeader("Content-Disposition", "attachment; filename=sample.pdf");
		response.outputStream << outputFile.bytes
		response.outputStream.flush()
		response.outputStream.close()
	}

	@Secured(['permitAll'])
	def downloadExcel(){
		try{
			def project = Project.findById(params.projecId)
			if(!project){
				render view:"/login/denied"
				return
			}
			def scenarios = []
			for(Scenario scenario in project.scenarios.sort{it.dateCreated}){
				def scenarioLogs = project.logs.findAll{it.associatedScenario == scenario}
				def successCases = scenarioLogs*.logs.flatten().findAll{it.isSuccess}.size()
				def totalCases = scenarioLogs*.logs.flatten().size()
				def successPercentage = totalCases > 0?(successCases * 100 / totalCases).setScale(2, BigDecimal.ROUND_DOWN):0
				
				println scenarioLogs.size() + "*******************"
				int totalExecutionsSeconds = scenarioLogs.size() > 0?scenarioLogs*.duration.flatten().sum{Integer.parseInt(it.split(':')[2])}:0
				int totalExecutionsMinutes = scenarioLogs.size() > 0?scenarioLogs*.duration.flatten().sum{Integer.parseInt(it.split(':')[1])}:0
				int totalExecutionsHours = scenarioLogs.size() > 0?scenarioLogs*.duration.flatten().sum{Integer.parseInt(it.split(':')[0])}:0

				println totalExecutionsSeconds
				println totalExecutionsMinutes
				println totalExecutionsHours


				totalExecutionsMinutes+=Math.floor(totalExecutionsSeconds/60)
				totalExecutionsSeconds =  totalExecutionsSeconds % 60

				totalExecutionsHours+=Math.floor(totalExecutionsMinutes/60)
				totalExecutionsMinutes =  totalExecutionsMinutes % 60

				int allInSeconds = totalExecutionsHours*3600 + totalExecutionsMinutes*60 +  totalExecutionsSeconds
				def meanExecTime = scenarioLogs.size() > 0 ? (allInSeconds/scenarioLogs.size()).setScale(1, BigDecimal.ROUND_DOWN) : 0.0
				def executionsByCycle = project.logs.findAll{it.scenario==scenario.name}.groupBy{it.cycle}
				def currentScenario = [name:scenario.name, dateCreated:scenario.dateCreated, version:scenario.appVersion, cycle:scenario.cycle, caseCount:scenario.cases.size(), executionsCount:project.logs.findAll{it.associatedScenario == scenario}.size(), successPercentage:successPercentage+"%", meanExecTime:meanExecTime, cycles:[]]
				for(cycle in executionsByCycle.keySet().sort()){
					def byVersion =  executionsByCycle.get(cycle).groupBy{it.appVersion}
					def currentCycle = [name:cycle, versions:[]]
					for(version in byVersion.keySet().sort()){
						int totalExecutionsSecondsVersion = byVersion.get(version)*.duration.sum{Integer.parseInt(it.split(':')[2])}
						int totalExecutionsMinutesVersion = byVersion.get(version)*.duration.sum{Integer.parseInt(it.split(':')[1])}
						int totalExecutionsHoursVersion = byVersion.get(version)*.duration.sum{Integer.parseInt(it.split(':')[0])}
						
						totalExecutionsMinutesVersion+=Math.floor(totalExecutionsSecondsVersion/60)
						totalExecutionsSecondsVersion =  totalExecutionsSecondsVersion % 60

						totalExecutionsHoursVersion+=Math.floor(totalExecutionsMinutesVersion/60)
						totalExecutionsMinutesVersion =  totalExecutionsMinutesVersion % 60

						int allInSecondsVersion = totalExecutionsHoursVersion*3600 + totalExecutionsMinutesVersion*60 +  totalExecutionsSecondsVersion
						def meanInSecondsVersion = allInSecondsVersion/byVersion.get(version)*.logs.flatten().size()
						println "TOtal seconds:   "+totalExecutionsSecondsVersion
						currentCycle.versions.push([version:version, logs:byVersion.get(version)*.logs.flatten(), totalExecutionTime:totalExecutionsHoursVersion+":"+totalExecutionsMinutesVersion+":"+totalExecutionsSecondsVersion, meanTimeByCase: meanInSecondsVersion])
					}
					currentScenario.cycles.push(currentCycle)
				}
				scenarios.push(currentScenario)
			}
			
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader("Content-Disposition", "attachment; filename=testxls.xlsx");

			def baseReport = new File('myReportFile.xlsx')
			XSSFWorkbook workbook = new XSSFWorkbook(baseReport);
			XSSFSheet hojaResumen = workbook.getSheetAt(0);
			for(Scenario scenario in scenarios){
				workbook.cloneSheet(0, scenario.name)
			}
			setProjectHeaders(hojaResumen)
			putCellValue(2, 1, hojaResumen, project.name, 4)
			putCellValue(3, 1, hojaResumen, project.dateCreated.format('yyyy-MM-dd HH:mm'), 4)
			putCellValue(4, 1, hojaResumen, new Date().format('yyyy-MM-dd HH:mm'), 4)
			def curRow = 8
			for(scenario in scenarios){
				putCellValue(curRow, 0, hojaResumen, scenario.name, 1)
				putCellValue(curRow, 1, hojaResumen, scenario.dateCreated.format('yyyy-MM-dd HH:mm'), 1)
				putCellValue(curRow, 2, hojaResumen, scenario.version, 1)
				putCellValue(curRow, 3, hojaResumen, scenario.cycle, 1)
				putCellValue(curRow, 4, hojaResumen, scenario.caseCount, 1)
				putCellValue(curRow, 5, hojaResumen, scenario.executionsCount, 1)
				putCellValue(curRow, 6, hojaResumen, scenario.successPercentage,1 )
				putCellValue(curRow, 7, hojaResumen, String.valueOf(scenario.meanExecTime)+" "+message(code:'report.seconds'), 1)
				curRow++
				def scenarioSheet = workbook.getSheet(scenario.name)
				setScenarioHeaders(scenarioSheet)
				putCellValue(2, 1, scenarioSheet, scenario.name, 7)
				putCellValue(3, 1, scenarioSheet, scenario.dateCreated.format('yyyy-MM-dd HH:mm'), 7)
				
				def curCycleRow = 8
				for(cycle in scenario.cycles){
					for(version in cycle.versions){
						putCellValue(curCycleRow, 0, scenarioSheet, cycle.name, 1)
						putCellValue(curCycleRow, 1, scenarioSheet, version.version, 1)
						putCellValue(curCycleRow, 2, scenarioSheet, version.totalExecutionTime, 1)
						putCellValue(curCycleRow, 3, scenarioSheet, version.meanTimeByCase+" "+message(code:'report.seconds'), 1)
						curCycleRow++
					}
				}
				deleteGuideCells(scenarioSheet)
			}
			hojaResumen.setAutoFilter(new CellRangeAddress(7, curRow-1, 0, 7));
			deleteGuideCells(hojaResumen)
			workbook.write(response.getOutputStream());
			response.outputStream.flush()
			response.outputStream.close()
		}
		catch(Exception e){
			println e.getMessage()
		}
	}

	private putCellValue(int rowNumber, int columnNumber, XSSFSheet sheet, value, int type){
		def newCell = sheet.getRow(rowNumber).createCell(columnNumber)
		newCell.setCellValue(value)
		setCellStyle(sheet, newCell, type)
	}
	
	//Cambia el estilo de la celda: type___ 1: Normal, 2: Header, 3:TableHeader, 4:info, 5: header scenario, 6: header table scenario, 7:info scenario
	private setCellStyle(XSSFSheet actualSheet, XSSFCell cell, int type){
		def style
		switch(type){
			case 1:
				style = actualSheet.getWorkbook().createCellStyle()
				style.setAlignment(cell.getColumnIndex() == 0 ? HorizontalAlignment.LEFT:HorizontalAlignment.RIGHT)
			break;
			case 2: 
				style = actualSheet.getRow(0).getCell(1).getCellStyle()
			break;
			case 3:
				style = actualSheet.getRow(0).getCell(2).getCellStyle()
			break;
			case 4: 
				style = actualSheet.getRow(0).getCell(3).getCellStyle()
			break;
			case 5: 
				style = actualSheet.getRow(0).getCell(4).getCellStyle()
			break;
			case 6: 
				style = actualSheet.getRow(0).getCell(5).getCellStyle()
			break;
			case 7: 
				style = actualSheet.getRow(0).getCell(6).getCellStyle()
			break;
		}
		cell.setCellStyle(style)
	}

	private setProjectHeaders(sheet){
		putCellValue(2, 0, sheet, message(code:'report.excel.projectName'),2)
		putCellValue(3, 0, sheet, message(code:'report.excel.dateCreated'),2)
		putCellValue(4, 0, sheet, message(code:'report.excel.generationDate'),2)
		putCellValue(6, 0, sheet, message(code:'report.excel.scenariosTable'),2)

		putCellValue(7, 0, sheet, message(code:'report.excel.name'),3)
		putCellValue(7, 1, sheet, message(code:'report.excel.dateCreated'),3)
		putCellValue(7, 2, sheet, message(code:'report.excel.actualVersion'),3)
		putCellValue(7, 3, sheet, message(code:'report.excel.actualCycle'),3)
		putCellValue(7, 4, sheet, message(code:'report.excel.casesNumber'),3)
		putCellValue(7, 5, sheet, message(code:'report.excel.execNumber'),3)
		putCellValue(7, 6, sheet, message(code:'report.excel.successPercentage'),3)
		putCellValue(7, 7, sheet, message(code:'report.excel.meanTimeExecution'),3)
		
	}

	private setScenarioHeaders(sheet){
		putCellValue(2, 0, sheet, message(code:'report.excel.projectName'),5)
		putCellValue(3, 0, sheet, message(code:'report.excel.dateCreated'),5)
		putCellValue(6, 0, sheet, message(code:'report.excel.cyclesTable'),5)

		putCellValue(7, 0, sheet, message(code:'report.excel.cycle'),6)
		putCellValue(7, 1, sheet, message(code:'report.excel.version'),6)
		putCellValue(7, 2, sheet, message(code:'report.excel.totalExecTime'),6)
		putCellValue(7, 3, sheet, message(code:'report.excel.meanTimeExecution'),6)
	}

	private deleteGuideCells(sheet){
		def style = sheet.getWorkbook().createCellStyle()
		for(i in 0..6)
			sheet.getRow(0).getCell(i).setCellStyle(style)
	}
}

