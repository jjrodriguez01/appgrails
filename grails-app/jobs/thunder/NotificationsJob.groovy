package thunder

import com.model.Alert

//Implementarlo por favor
class NotificationsJob {
    static triggers = {
    	cron name: 'license', cronExpression: "0 0 0 * * ?"
    }

    def execute() {
        // execute job

        //def notificaton= new Alert('execution.overdue.deleted.target', User.findByUsename(''), 3, "fa-trash","red","Admin").save(flush:true, failOnError:true)
    }
}
