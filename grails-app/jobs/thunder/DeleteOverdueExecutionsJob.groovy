package thunder

import com.model.Alert
import com.model.Execution

class DeleteOverdueExecutionsJob {
    static triggers = {
      simple repeatInterval: 20000l // execute job once in 8 seconds
    }

    def execute() {
        try{
			def criteria = Execution.createCriteria()
			def Calendar calendar = Calendar.getInstance();
			//calendar.add(Calendar.MINUTE,-1)
			calendar.add(Calendar.SECOND,-20)
			def dueTimeActual= calendar.getTime()
			calendar.add(Calendar.MINUTE,-20)
			def dueTimeOld= calendar.getTime()

			def executions = criteria.list{
				between("executionDate",dueTimeOld,dueTimeActual)
				eq("state",1)
				eq("isProgrammed",true)
			}
			
			for(Execution execution in executions){
				println "Deleting from job"
				def notificaton= new Alert('execution.overdue.deleted.target', execution.target, 3, "fa-trash", "red", ""+execution.executionDate.toString().substring(0,16)+","+execution.creator.fullname ).save(flush:true, failOnError:true)
				if(!execution.target.equals(execution.creator))
				notificaton= new Alert('execution.overdue.deleted.creator', execution.creator, 3, "fa-trash", "red", ""+execution.executionDate.toString().substring(0,16)+","+execution.target.fullname).save(flush:true, failOnError:true)
		
				execution.delete(flush:true, failOnError:true)
			}
		}catch(Exception e){
			println "Error"
			e.printStackTrace()
		}
    }
}
