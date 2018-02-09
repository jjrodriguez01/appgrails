package thunder
import com.model.*

class ExecutionProgrammerJob {
    static triggers = {
      cron name: 'myTrigger', cronExpression: "0 0 0 * * ?"
    }

    def execute() {
        // execute job
        def c  = Calendar.getInstance();
        def dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        def executions = ExecutionExpression.list()
        for(ExecutionExpression ee in executions){
        	if(isToday(ee.initialDate) || ee.initialDate < new Date()){
        		def execCalendar = Calendar.getInstance()
        		execCalendar.setTime(ee.initialDate)
 				def targetsSplitted = ee.targets.split(',')
 				if(ee.type==1){
 					if(isToday(ee.initialDate)){
 						for(def i=0;i<targetsSplitted.size();i++)
						{
							def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
							if(cTarget){
								def execution = new Execution(cTarget, ee.creator, true, initialDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
							}

						}
						ee.delete(flush:true, failOnError:true)
 					}
 				}
 				else if(ee.type==2){
 					def todayDate = Calendar.getInstance()
 					todayDate.set(Calendar.HOUR_OF_DAY, execCalendar.HOUR_OF_DAY)
 					todayDate.set(Calendar.MINUTE, execCalendar.MINUTE)
 					todayDate.set(Calendar.SECOND, 0)

 					switch(todayDate.DAY_OF_WEEK){
 						case 1:
 							if(ee.sunday){

 								for(def i=0;i<targetsSplitted.size();i++)
								{
									def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
									if(cTarget){
										def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
									}
								}

 							}
 						break;
 						case 2:
 							if(ee.monday){
 								for(def i=0;i<targetsSplitted.size();i++)
								{
									def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
									if(cTarget){
										def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
									}
								}
 									
 							}
 						break;
 						case 3:
 							if(ee.tuesday){
 								for(def i=0;i<targetsSplitted.size();i++)
								{
									def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
									if(cTarget){
										def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
									}
								}
 								
 							}
 						break;
 						case 4:
 							if(ee.wednesday){
 								for(def i=0;i<targetsSplitted.size();i++)
								{
									def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
									if(cTarget){
										def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
									}
								}
 							}
 						break;
 						case 5:
 							if(ee.thursday){
 								for(def i=0;i<targetsSplitted.size();i++)
								{
									def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
									if(cTarget){
										def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
									}
								}
 							}
 						break;
 						case 6:
 							if(ee.friday){
 								for(def i=0;i<targetsSplitted.size();i++)
								{
									def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
									if(cTarget){
										def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
									}
								}
 							}
 						break;
 						case 7:
 							if(ee.saturday){
 								for(def i=0;i<targetsSplitted.size();i++)
								{
									def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
									if(cTarget){
										def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
									}
								}
 							}
 						break;

 					}



 				}
 				else if(ee.type==3){
 					def todayDate = Calendar.getInstance()
 					todayDate.set(Calendar.HOUR_OF_DAY, execCalendar.HOUR_OF_DAY)
 					todayDate.set(Calendar.MINUTE, execCalendar.MINUTE)
 					todayDate.set(Calendar.SECOND, 0)

 					for(def i=0;i<targetsSplitted.size();i++)
						{
							def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
							if(cTarget){
								def execution = new Execution(cTarget, ee.creator, true, todayDate, 1,  ee.scenario, ee.cases, ee.browsers).save(flush:true,failOnError:true)
							}

						}
 				}
        	}
        }
    }

        private static boolean isSameDay(Calendar cal1, Calendar cal2) {
	        if (cal1 == null || cal2 == null) {
	            throw new IllegalArgumentException("The dates must not be null");
	        }
	        return (cal1.get(Calendar.ERA) == cal2.get(Calendar.ERA) &&
	                cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
	                cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR));
	    }
    
    
	    private static boolean isToday(Date date) {
	    	Calendar cal = Calendar.getInstance();
        	cal.setTime(date);
	        return isSameDay(cal, Calendar.getInstance());
	    }

}
