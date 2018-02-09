
import java.util.Date;


import com.model.*

import com.security.Role
import com.security.User
import com.security.UserRole
import com.helpers.*


import grails.converters.JSON

import java.security.SecureRandom;
import java.math.BigInteger;


class BootStrap {

  def concurrentSessionControlStrategy
  def authenticationProcessingFilter
  def generatorService
  def cryptoService
  def messageSource

  def init = { servletContext ->    

      JSON.registerObjectMarshaller(Functionality){ Functionality functionality ->
        [
          id:functionality.id,
          internalId:functionality.internalId,
          functionality:functionality.asString(functionality.functionality),
          description:functionality.asString(functionality.description),
          roles:functionality.roles,
          client:functionality.client,
        ]
      }

  if(User.count()>0){
    /*
     println "Iniciando borrado de usuarios**"
      for(def i=0;i<300;i++){
        def curUser = User.findByUsername(""+i+"@leader.com")
        if(curUser){
          def projects = []
          
          for(relation in UserProject.findAllByUser(curUser)){
            //
            for(sc in relation.project.scenarios){
                println "escenario ->"+sc.name
                for(c in sc.cases){
                  println "caso->"+c.name
                  c.delete(flush:true, failOnError:true)
                }
                sc.delete(flush:true, failOnError:true)
            }
            relation.delete(flush:true, failOnError:true)
          }
          assert UserProject.countByUser(curUser)==0
          for(curProject in Project.findAllByCreator(curUser)){
            for(relation in UserProject.findAllByProject(curProject)){
              relation.delete(flush:true, failOnError:true)
            }
            assert UserProject.countByProject(curProject)==0
            curProject.delete(flush:true, failOnError:true)
          }
          assert Project.countByCreator(curUser)==0
          
          for(ur in UserRole.findAllByUser(curUser)){
            ur.delete(flush:true, failOnError:true)
          }
          assert UserRole.countByUser(curUser)==0
          curUser.delete(flush:true, failOnError:true)
        }
      }
      println "Finalizando borrado de usuarios"
      
      
      def superClientQvision1 =  User.findByUsername("superclient@qvision.com")
      def existingUserLeaderRole = Role.findByAuthority('ROLE_USER_LEADER')
      def existingDemoRole = Role.findByAuthority('ROLE_DEMO')
      
      println "iniciando creación de usuarios"

      for(def i=0;i<300;i++){
        def testLeaderUser1 = new User( ""+i+"@leader.com",  "1", "Usuario: "+i,"000000", "3130000000", "Calle 80 con algo", "Qvision", 0,null,false,null)
        testLeaderUser1.setAvatarFile('avatares-04.png')
        testLeaderUser1.setAccountLocked(false);
        testLeaderUser1.setAssociatedClient(superClientQvision1)
        testLeaderUser1.save(flush:true, failOnError:true)
        UserRole.create testLeaderUser1, existingUserLeaderRole, true
        UserRole.create testLeaderUser1, existingDemoRole, true
      }
      println "Finalizando creación de usuarios"*/
}



  if(User.count()==0)
    {
      def functionality = new Functionality(0,'Visualización de sub-ventana mis usuarios','Permite visualizar a los compañeros licenciados bajo el mismo cliente y su estado web y desktop (Especial, no funciona con DEMO)','ROLE_USER,ROLE_USER_LEADER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(1,'Creación de usuarios','Creación de usuarios asociados','ROLE_CLIENT,ROLE_USER_LEADER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(2,'Eliminación de usuarios','Eliminación de usuarios asociados (se reasignan tareas y se libera la licencia pero no cambia fechas de corte)','ROLE_CLIENT,ROLE_USER_LEADER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(3,'Creación de proyectos','Creación de proyectos en thundertest','ROLE_USER_LEADER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(4,'Edición de proyectos', 'Edición de proyectos ya creados dentro del scope del grupo de trabajo','ROLE_USER_LEADER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(5,'Creación de páginas', 'Crea páginas para almacenar los objetos','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(6,'Edición y eliminación de páginas', 'Permite modificar y eliminar páginas ya creadas (sólo si las condiciones se dan)','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(7,'Clonación de páginas', 'Evita tener que mapear nuevamente los objetos, clona la página con un nuevo nombre asignado y genera los objetos y mensajes de la original','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(8,'Creación de escenarios', 'Crea escenarios para parametrizar el proceso','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(9,'Edición y eliminación de escenarios', 'Elimina y edita la información de los escenarios (nombre y descripción)','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(10,'Creación de mensajes (stage)', 'Crea mensajes a partir de los objetos que se mapearon en el mismo stage para asignarlos posteriormente a una página','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(11,'Edición y eliminación de mensajes (Stage)', 'Edita y elimina los mensajes creados en el numeral anterior ','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(12,'Creación de pasos (manual)', ' Crear pasos de manera manual por medio de la interfaz web y no del drag and drop','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(13,'Edición y eliminación de pasos', 'Edita y elimina los pasos creados en el númeral anterior','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(14,'Creación de casos', 'Crear casos de prueba para la posterior ejecución (dentro de un escenario)','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(15,'Edición y eliminación de casos', 'Edita y elimina los casos creados anteriormente','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(16,'Clonación de casos', 'Similar a la clonación de páginas, en este caso se copian los valores de los pasos especificos de cada caso dentro de un mismo escenario (no aplica inter-escenarios, solo intra-escenarios)','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(17,'Ejecución propia', 'Ejecución directa desde pasos, casos, o escenarios','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)
     
      functionality = new Functionality(18,'Ejecución programada propia','Ejecución programada sobre mi propio perfil','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(19,'Ejecución programada en perfil diferente', 'Ejecución programada en un perfil ajeno al mio','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

       functionality = new Functionality(20,'Extractor DB', 'Extractor de base de datos para valores de paso de caso','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(21,' Extractor TXT', 'Extractor de TXT para paso de caso, en este caso se copian los valores de los pasos especificos de cada caso dentro de un mismo escenario (no aplica inter-escenarios, solo intra-escenarios)','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(22,'Generador', 'Genera valores dadas ciertas reglas para asignarle valores a pasos de casos','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)
     
      functionality = new Functionality(23,'Cambio de avatar',' Cambia el avatar del usuario','ROLE_USER_LEADER, ROLE_USER, ROLE_CLIENT',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(24,'Logs de ejecución', 'Muestra la información mas general de la ejecución', 'ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)




      functionality = new Functionality(25,'Logs por caso', 'Información mas especifica, pero a un nivel general aún, no muestra información por paso','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)
     
      functionality = new Functionality(26,'Logs por paso','Información especifica por cada paso, de cada caso del escenario ejecutado','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(27,'Creación de objeto (manual)', 'Permite crear un objeto de manera manual sin necesidad de recurrir al mapper','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

       functionality = new Functionality(28,'Edición y eliminación de objetos', 'Edita y elimina objetos ya existentes en páginas','ROLE_USER_LEADER, ROLE_USER',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(29,'Creación de mensajes (páginas)', 'Crea mensajes desde la vista de páginas','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(30,'Edición y eliminación de mensajes (páginas)', 'Edita y elimina los mensajes creados en el numeral anterior','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(31,'Creación de mensajes (escenario)', 'Crea mensajes desde la vista de escenario','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(32,'Edición y eliminación de mensajes (escenario)', 'Edita y elimina los mensajes creados en el numeral anterior','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(33,'Mostrar Pestaña de programar ejecuciones', 'Muestra la pestaña para programar ejecuciones (debe tenersen en cuenta los numerales 18 y 19)','ROLE_GOLD, ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)


      functionality = new Functionality(34,'Creación de proyectos de validador','Creación de proyectos  de validación en thundertest','ROLE_GOLD',"WEB").save(flush:true, failOnError:true)

      //NUEVAS

      functionality = new Functionality(35,'Eliminación de escenarios cuenta demo','Eliminacion de escenarios','ROLE_GOLD,ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(36,'Creacion escenarios RFT y UFT','UFT y RFT','ROLE_GOLD,ROLE_PLATINUM',"WEB").save(flush:true, failOnError:true)

      functionality = new Functionality(37,'permisos mapeador web','WEBMapper','ROLE_DEMO,ROLE_GOLD,ROLE_PLATINUM',"CLIENT").save(flush:true, failOnError:true)

      functionality = new Functionality(38,'permisos mapeador GUI','GUIMapper','ROLE_GOLD,ROLE_PLATINUM',"CLIENT").save(flush:true, failOnError:true)

      functionality = new Functionality(39,'permisos mapeador UFT','UFTMapper','ROLE_GOLD,ROLE_PLATINUM',"CLIENT").save(flush:true, failOnError:true)

      functionality = new Functionality(40,'permisos mapeador RFT','RFTMapper','ROLE_GOLD,ROLE_PLATINUM',"CLIENT").save(flush:true, failOnError:true)

      functionality = new Functionality(41,'permisos para sincronizador','Sincronizador','ROLE_DEMO,ROLE_GOLD,ROLE_PLATINUM',"CLIENT").save(flush:true, failOnError:true)

      functionality = new Functionality(42,'permisos para ver logs','Logs','ROLE_DEMO,ROLE_GOLD,ROLE_PLATINUM',"CLIENT").save(flush:true, failOnError:true)

      functionality = new Functionality(43,'permisos para ver estadisticas','Estadisticas','ROLE_DEMO,ROLE_GOLD,ROLE_PLATINUM',"CLIENT").save(flush:true, failOnError:true)

      //Restricciones cuenta demo
      def DemoAccount da = new DemoAccount("Proyectos",5,true).save(flush:true, failOnError:true)
      da = new DemoAccount("Escenarios",5,true).save(flush:true, failOnError:true)


      //Recursos de Descargas
      def downloader = new Resource("downloader", "1", "https://www.dropbox.com/s/b4cw3d6zk5ryv3r/WinThunderInstaller.exe?dl=1,https://doc-04-6k-docs.googleusercontent.com/docs/securesc/tjft0b4vana278qpepd2hibmrd0ijmp3/snt1696tu5lbfv9idbobllr9ldaege71/1464876000000/06380120997162430331/06380120997162430331/0B3i4OE3mwQ1eSm5LS3VvWWtMUHM?e=download", true, 2).save(flush:true)
      //Recursos de Actualizador
      def tool = new Resource("fw", "1", "", true,1).save(flush:true)
      tool = new Resource("client", "1", "", true,1).save(flush:true)
      tool = new Resource("GuiMapper", "1", "", true,1).save(flush:true)
      tool = new Resource("WebMapper", "1", "", true,1).save(flush:true)
      tool = new Resource("ThunderDB", "1", "", true,1).save(flush:true)
      tool = new Resource("LogFramework", "1", "", true,1).save(flush:true)
      tool = new Resource("chromedriver", "1", "", true,1).save(flush:true)
      tool = new Resource("operadriverx32", "1", "", true,1).save(flush:true)
      tool = new Resource("operadriverx64", "1", "", true,1).save(flush:true)
      tool = new Resource("IEDriverServerx32", "1", "", true,1).save(flush:true)
      tool = new Resource("IEDriverServerx64", "1", "", true,1).save(flush:true)
      tool = new Resource("MicrosoftWebDriver10240", "1", "", true,1).save(flush:true)
      tool = new Resource("MicrosoftWebDriver10586", "1", "", true,1).save(flush:true)
      tool = new Resource("updater", "1", "", true,1).save(flush:true)

      def tutorial1 = new Tutorial("Creación de proyectos y escenarios", "Project and scenario creation", "En este vídeo te mostramos cómo crear un proyecto y asociado a él crear un escenario.", "This video shows you how to create a projct, and then how to create an associated scenario", "https://www.youtube.com/embed/iFLqK2Vnl6w").save(flush:true, failOnError:true)

      def tutorial2 = new Tutorial("Mapeo de objetos", "Mapping objects", "Este corto vídeo te enseña a mapear los objetos de una aplicación web para que luego puedas usarlos en la construcción del guión y los casos de prueba.","This short video teach you how to map objects of a web page.", "https://www.youtube.com/embed/U5lK3CprCw0").save(flush:true, failOnError:true)

      def tutorial3 = new Tutorial("Creación del guión y de un caso", "Steps and case creation", "En este vídeo verás como crear un guión a partir de los objetos que mapeaste y como usar este guión para construir un caso de prueba.","In this video you will see how to create steps from mapped objects, and then with those steps create test cases", "https://www.youtube.com/embed/Ff-67TRaQ-4").save(flush:true, failOnError:true)

      def tutorial4 = new Tutorial("Ejecución de un escenario", "Scenario execution", "En este vídeo te mostramos como ejecutar un escenario una vez has creado el guión y los casos de prueba pertinentes.", "Once you have built the test cases you are ready to execute the scenario, here we teach you how to do it", "https://www.youtube.com/embed/i2OT7ANgEEM").save(flush:true, failOnError:true)



      def token = new Token("superclient@qvision.com", 5, "8cbece5a78cc4f75be5188644b3f28eb").save(flush:true, failOnError:true)
      def imagesPath = "objImages"; //<-- generic path on your SERVER!
      def File pathAsFile = new File(imagesPath)
      pathAsFile.mkdir()
      def imagesPath1 = "logImages"; //<-- generic path on your SERVER!
      def File pathAsFile1 = new File(imagesPath1)
      pathAsFile1.mkdir()

      if (pathAsFile.exists()){
        println("CREATED IMAGES DIRECTORY @ ${pathAsFile.absolutePath}");
      }else{
        println("FAILED TO CREATE REPORT DIRECTORY @ ${pathAsFile.absolutePath}");
      }

      def adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
      def clientRole = new Role(authority: 'ROLE_CLIENT').save(flush: true)
      def userRole = new Role(authority: 'ROLE_USER').save(flush: true)
      def userLeaderRole = new Role(authority: 'ROLE_USER_LEADER').save(flush: true, failOnError:true)
      def goldRole = new Role(authority:'ROLE_GOLD').save(flush: true, failOnError:true)
      def platinumRole = new Role(authority:'ROLE_PLATINUM').save(flush: true, failOnError:true)
      def demoRole = new Role(authority: 'ROLE_DEMO').save(flush: true, failOnError:true)




      def superClientQvision = new User( "superclient@qvision.com",  "admin123", "Super cliente Qvision","7447037", "3002550265", "Calle 133 # 19", "Qvision", 4,null,false,null)
      superClientQvision.setAvatarFile('avatares-10.png')
      superClientQvision.setAccountLocked(false);
      superClientQvision.save(flush:true, failOnError:true)

      


      def testClient = new User( "client@client.com",  "1", "Oscar Arturo Carrillo","000000", "3130000000", "Calle 80 con algo", "Qvision", 0,null,false,null)
      testClient.setAvatarFile('avatares-10.png')
      testClient.setAccountLocked(false);
      testClient.save(flush:true, failOnError:true)
     


      def testUser = new User( "user@user.com",  "1", "Gabriel Betancourt","000000", "3130000000", "Calle 80 con algo", "Qvision", 0,null,false,null)
      testUser.setAvatarFile('avatares-08.png')
      testUser.setAccountLocked(false);
      testUser.save(flush:true, failOnError:true)

      println "Iniciando creación de usuarios"
    



      def testLeaderUser = new User( "leader@leader.com",  "1", "Qvision","000000", "3130000000", "Calle 80 con algo", "Qvision", 3,null,false,null)
      testLeaderUser.setAvatarFile('avatares-04.png')
      testLeaderUser.setAccountLocked(false);
      testLeaderUser.setAssociatedClient(testClient)
      testLeaderUser.save(flush:true, failOnError:true)


      def testLeaderDiegoUser = new User( "oscar@carrillo.com",  "1", "Oscar Arturo Carrillo","000000", "3130000000", "Calle 80 con algo", "Q-vision", 0,null,false,null)
      testLeaderDiegoUser.setAvatarFile('avatares-14.png')
      testLeaderDiegoUser.setAccountLocked(false);
      testLeaderDiegoUser.setAssociatedClient(testClient)
      testLeaderDiegoUser.save(flush:true, failOnError:true)


       def testNico = new User( "nico@nico.com",  "1", "Nicolas Giussepe Contreras","000000", "3130000000", "Calle 80 con algo", "Qvision", 2,null,false,null)
      testNico.setAvatarFile('avatares-13.png')
      testNico.setAccountLocked(false);
      testNico.setAssociatedClient(testClient)
      testNico.save(flush:true, failOnError:true)



      testClient.addToUsers(testLeaderUser)
      testClient.addToUsers(testLeaderDiegoUser)
      testClient.addToUsers(testNico)
      testClient.save(flush:true, failOnError:true)

      def testAdmin = new User( "admin@admin.com",  "1", "Oscar Arturo Carrillo","000000", "3130000000", "Calle 80 con algo", "Qvision", 2,null,false,null)
      testAdmin.setAccountLocked(false);
      testAdmin.save(flush:true, failOnError:true)


      def  parameters = "Luis Gabriel Betancourt,btn_login,Login"

      def clientMessage = new Alert("alert.license.amostExpired", testClient, 2, 'fa-battery-empty', 'blue',"").save(flush:true, failOnError:true)
      def clientMessage1 = new Alert("alert.license.amostExpired", testUser, 2, 'fa-cab', 'green',"").save(flush:true, failOnError:true)
      def clientNotification = new Alert("alert.license.amostExpired", testClient, 3, 'fa-battery-empty', 'blue',"").save(flush:true, failOnError:true)
      def clientNotification1 = new Alert("alert.license.amostExpired", testClient, 3, 'fa-cab', 'green',"").save(flush:true, failOnError:true)
      def clientAlert = new Alert("alert.license.amostExpired", testClient, 1, 'fa-bolt', 'blue',"").save(flush:true, failOnError:true)
      def clientAlert1 = new Alert("alert.license.amostExpired", testClient, 1, 'fa-train', 'yellow',"").save(flush:true, failOnError:true)

      testClient.addToUsers(testUser);


      def GenericAction actionWaitForImage = new GenericAction("genericAction.waitForImage",'<input id="" class="form-control actionInput"  style="margin: 0px 15px 5px 5px" value="" type="text"></input>',"", true, "GUI").save(flush:true, failOnError:true)

      def GenericAction actionWaitForWebObject = new GenericAction("genericAction.waitForWebObject",'<input id="" class="form-control actionInput"  style="margin: 0px 15px 5px 5px" value="" type="text"></input>',"", true, "WEB").save(flush:true, failOnError:true)

      def GenericAction actionVerifyURL = new GenericAction("genericAction.verifyURL",'<input id="" class="form-control actionInput"  style="margin: 0px 15px 5px 5px" value="" type="text"></input>',"", false, "WEB").save(flush:true, failOnError:true)

      def GenericAction actionLaunchApp = new GenericAction("genericAction.open",'<input id="" class="form-control actionInput"  style="margin: 0px 15px 5px 5px" value="" type="text"></input>',"", false,"WEB,GUI,CLI,UFT,RFT").save(flush:true, failOnError:true)
      def GenericAction actionWrite = new GenericAction("genericAction.write",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px" value="" type="text"></input>',"",true,"WEB,GUI,CLI,UFT,RFT").save(flush:true, failOnError:true)
      def GenericAction actionClick = new GenericAction("genericAction.click",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> Click </small>',"Click",true,"WEB,GUI,CLI,UFT,RFT").save(flush:true, failOnError:true)
     
      def GenericAction actionWait = new GenericAction("genericAction.wait",'<input id="" class="form-control actionInput"  style="margin: 0px 15px 5px 5px" value="" type="text" placeholder="Segundos"></input>',"", false, "WEB,GUI,CLI,UFT").save(flush:true, failOnError:true)

      
      def GenericAction actionCheck = new GenericAction("genericAction.check",'<label><input id="" class="ios-switch actionInput" checked="" type="checkbox">  <div class="switch"></div></label>',"ON", true, "WEB, UFT").save(flush:true, failOnError:true)

      def GenericAction actionRightClick = new GenericAction("genericAction.rightClick",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> replaceForCode </small>',"replaceForCode",true, "WEB,GUI,CLI").save(flush:true)
    
      def GenericAction actionDoubleClick = new GenericAction("genericAction.doubleClick",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> replaceForCode </small>',"replaceForCode",true,"WEB,GUI,CLI").save(flush:true)

      def GenericAction actionGoBack = new GenericAction("genericAction.goBack",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> replaceForCode </small>',"replaceForCode", false,"WEB" ).save(flush:true, failOnError:true)


      def GenericAction actionAlert = new GenericAction("genericAction.alert",'<select class="form-control actionInput" id=""><option value="Ok">Ok</option><option value="Cancel">Cancel</option></select>',"", false,"WEB").save(flush:true, failOnError:true)

      def GenericAction actionHover = new GenericAction("genericAction.hover",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> replaceForCode </small>',"Hover",true,"WEB,GUI,CLI").save(flush:true)
      
      def GenericAction actionSelect = new GenericAction("genericAction.select",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px" value="" type="text"></input>',"",true, "WEB,UFT").save(flush:true, failOnError:true)
      
      def GenericAction actionDragAndDrop = new GenericAction("genericAction.dragAndDrop",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text" placeholder="X,Y"></input>',"",true, "WEB,GUI,CLI").save(flush:true, failOnError:true)
     
      def GenericAction actionVerifyValue = new GenericAction("genericAction.verifyValue",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text"></input>',"",true, "WEB").save(flush:true, failOnError:true)
      
      def GenericAction actionElementPresent = new GenericAction("genericAction.elementPresent",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> replaceForCode </small>',"replaceForCode",true, "WEB").save(flush:true, failOnError:true)
      
      def GenericAction actionVerifyImage = new GenericAction("genericAction.verifyImage",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> replaceForCode </small>',"replaceForCode",true, "GUI").save(flush:true)
      def GenericAction actionClosePopup = new GenericAction("genericAction.closePopup",'<small id="" class="label bg-blue actionInput"  style="margin: 0px 5px 0px 5px" value=""> replaceForCode </small>',"replaceForCode", false, "WEB").save(flush:true, failOnError:true)

      def GenericAction actionRefresh = new GenericAction("genericAction.refresh",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text"></input>',"",false, "WEB").save(flush:true, failOnError:true)

      def GenericAction actionVerifyAttribute = new GenericAction("genericAction.verifyAttribute",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text"></input>',"",false, "WEB").save(flush:true, failOnError:true)      
                  
                  
      def GenericAction actionKey = new GenericAction("genericAction.key",'<select class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" ><option value="F1">F1</option><option value="F2">F2</option><option value="F3">F3</option><option value="F4">F4</option><option value="F5">F5</option><option value="F6">F6</option><option value="F7">F7</option><option value="F8">F8</option><option value="F9">F9</option><option value="F10">F10</option><option value="F11">F11</option><option value="F12">F12</option><option value="F13">F13</option><option value="F14">F14</option><option value="F15">F15</option><option value="F16">F16</option><option value="F17">F17</option><option value="F18">F18</option><option value="F19">F19</option><option value="F20">F20</option><option value="0">0</option><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="ENTER">ENTER</option><option value="ESC">ESC</option><option value="TAB">TAB</option><option value="SUPR">SUPR</option><option value="AVPAG">AVPAG</option><option value="REPAG">REPAG</option></select>',"",false,"CLI" ).save(flush:true, failOnError:true)

      def GenericAction actionCtrlKey = new GenericAction("genericAction.ctrlKey",'<select class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" ><option value="F1">F1</option><option value="F2">F2</option><option value="F3">F3</option><option value="F4">F4</option><option value="F5">F5</option><option value="F6">F6</option><option value="F7">F7</option><option value="F8">F8</option><option value="F9">F9</option><option value="F10">F10</option><option value="F11">F11</option><option value="F12">F12</option><option value="F13">F13</option><option value="F14">F14</option><option value="F15">F15</option><option value="F16">F16</option><option value="F17">F17</option><option value="F18">F18</option><option value="F19">F19</option><option value="F20">F20</option><option value="Z">Z</option><option value="X">X</option><option value="V">V</option><option value="N">N</option></select>',"",false, "CLI").save(flush:true, failOnError:true)

      def GenericAction actionAltKey = new GenericAction("genericAction.altKey",'<select class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value=""><option value="0">0</option><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="derecha">→</option><option value="ENTER">ENTER</option><option value="F4">F4</option><option value="mas">+</option></select>',"",false, "CLI").save(flush:true, failOnError:true)
      
       def GenericAction actionShiftKey = new GenericAction("genericAction.shiftKey",'<select class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" ><option value="F1">F1</option><option value="F2">F2</option><option value="F3">F3</option><option value="F4">F4</option><option value="F5">F5</option><option value="F6">F6</option><option value="F7">F7</option><option value="F8">F8</option><option value="F9">F9</option><option value="F10">F10</option><option value="F11">F11</option><option value="F12">F12</option><option value="F13">F13</option><option value="F14">F14</option><option value="F15">F15</option><option value="F16">F16</option><option value="F17">F17</option><option value="F18">F18</option><option value="F19">F19</option><option value="F20">F20</option><option value="0">0</option><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="derecha">→</option><option value="coma">,</option></select>',"",false, "CLI").save(flush:true, failOnError:true)

      def GenericAction actionWheelUp = new GenericAction("genericAction.wheelUp",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="number" min="1" ></input>',"",false, "CLI").save(flush:true, failOnError:true)
      
      def GenericAction actionWheelDown = new GenericAction("genericAction.wheelDown",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="number" min="1"></input>',"",false, "CLI").save(flush:true, failOnError:true)
     
      def GenericAction actionMouseMove = new GenericAction("genericAction.mouseMove",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text" placeholder="X,Y"></input>',"",false,"CLI").save(flush:true, failOnError:true)
     
      def GenericAction actionClickCoordinates = new GenericAction("genericAction.clickCoordinates",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text" placeholder="X,Y"></input>',"",false, "CLI").save(flush:true, failOnError:true)
      
      def GenericAction actionWriteCoordinates = new GenericAction("genericAction.writeCoordinates",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text" placeholder="VAL"></input><input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text" placeholder="X,Y"></input>',"",false, "CLI").save(flush:true, failOnError:true)
      
      def GenericAction actionCopyDoubleClick = new GenericAction("genericAction.copyDoubleClick",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text" placeholder="X,Y"></input>',"",false, "WEB,GUI,CLI").save(flush:true, failOnError:true)

      def GenericAction closeApp = new GenericAction("genericAction.closeApp",'<input class="form-control actionInput"  id="" style="margin: 0px 15px 5px 5px"value="" type="text" placeholder="Browser"></input>',"",false, "UFT").save(flush:true, failOnError:true)
                  

      UserRole.create testAdmin, adminRole, true
      UserRole.create testUser, userRole, true
      UserRole.create testLeaderUser, userLeaderRole, true
      UserRole.create testLeaderUser, platinumRole, true
      UserRole.create testLeaderDiegoUser, userLeaderRole, true
      UserRole.create testNico, userLeaderRole, true
      UserRole.create testClient, clientRole, true
      UserRole.create superClientQvision, clientRole, true
      UserRole.create testLeaderDiegoUser, demoRole, true 
      UserRole.create testNico, platinumRole, true 
    }

    
      JSON.registerObjectMarshaller(User){ User user ->
        [
            id:user.id,
            username:user.username,
            password:"[PROTECTED]",
            enabled:user.enabled,
            accountExpired:user.accountExpired,
            accountLocked:user.accountLocked,
            passwordExpired:user.passwordExpired,
            offersChk:user.offersChk,
            fullname:user.fullname,
            phone:user.phone,
            mobile:user.mobile,
            numeroDeImagenesEvidenciaPorCaso:user.numeroDeImagenesEvidenciaPorCaso,
            numeroDeLicencias:user.numeroDeLicencias,
            address:user.address,
            organization:user.organization,
            plan:user.plan, 
            associatedClient:user.associatedClient,
            users:user.users,
            lastWebAction:user.lastWebAction,
            lastDesktopAction:user.lastDesktopAction,
            licenseExpirationDate:user.licenseExpirationDate,
            dateCreated:user.dateCreated,
            avatarFile:user.avatarFile
        ]
      }

      JSON.registerObjectMarshaller(Step){ Step step ->
        [
          id:step.id,
          object:step.object,
          execOrder:step.execOrder,
          principalAction:step.principalAction,
          supportActions:step.supportActions,
          mustTakeScreenShot:step.mustTakeScreenShot,
          isEnabled:step.isEnabled,
          creator:step.creator,
          lastUpdated:step.lastUpdated,
          dateCreated:step.dateCreated

        ]
      }

      JSON.registerObjectMarshaller(Execution){ Execution myExecution ->
        [
          id:myExecution.id,
          creator:myExecution.creator.fullname,
          host:myExecution.target.fullname,
          scenarioToExecute:myExecution.scenarioToExecute.name,
          progress:myExecution.progress,
          stateMessage: myExecution.stateMessage,
          executionDate:myExecution.executionDate
        ]
      }

      JSON.registerObjectMarshaller(Action){ Action myAction ->
        [
          id:myAction.id,
          action:myAction.action,
          execOrder:myAction.execOrder,
          lastUpdated:myAction.lastUpdated,
          dateCreated:myAction.dateCreated

        ]
      }
      JSON.registerObjectMarshaller(GenericAction){ GenericAction genericAction ->
        [
          id:genericAction.id,
          name:genericAction.name,
          html:genericAction.html,
          lastUpdated:genericAction.lastUpdated,
          dateCreated:genericAction.dateCreated,
          needsObject:genericAction.needsObject,
          defaultValue:genericAction.defaultValue,
          platform:genericAction.platform,
          englishMessage:Messagei18n.findByCodeAndLocale(genericAction.name,new Locale('en'))?Messagei18n.findByCodeAndLocale(genericAction.name,new Locale('en')).text:'',
          spanishMessage:Messagei18n.findByCodeAndLocale(genericAction.name,new Locale('es'))?Messagei18n.findByCodeAndLocale(genericAction.name,new Locale('es')).text:''
        ]
      }
      JSON.registerObjectMarshaller(Message){ Message message ->
        [
          object:message.object.name,
          key:message.object.allTargets,
          type:message.type,
          message:message.message,
          byClueWords:message.byClueWords,
        ]
      
    }

  }
  def destroy = {
  }
}