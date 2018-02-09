<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<g:set var="lang" value="${RequestContextUtils.getLocale(request)}" />
<!DOCTYPE html>
<html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta name="description" content="Thunder Test">
      <meta name="author" content="cosmic">
      <link rel="shortcut icon" href="${createLink(controller:'assets', action:'logos')}/favicon.ico" type="image/x-icon" />
      <title>
         <g:message code="general.title"/>
      </title>


      <!--Stylesheets Imports -->
      <asset:stylesheet src="bootstrap.min.css" />
      <asset:stylesheet src="theme.css" />
      <asset:stylesheet src="style.css" />
      <asset:stylesheet src='font-awesome/css/font-awesome.css'/>
      <asset:stylesheet src='animate.css'/>


        <!--JavaScript Imports -->
      <asset:javascript src="jquery-2.1.4.js"/>
      <asset:javascript src="jquery.validate.min.js" />
      <g:if test="${lang.getLanguage() == 'es'}"><asset:javascript src="/localization/messages_es.min.js" /></g:if>
      <asset:javascript src="tweecool.js"/>
      <asset:javascript src="bootstrap.min.js" />
      <asset:javascript src="hover-dropdown.js" />
      <asset:javascript src="wow.min.js" />

  <script>
  $(document).ready(function() {
      $('#tweecool').tweecool({
      	 username : 'ThunderTestSoft', 
         limit : 3	
      });
  });


  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-78462000-1', 'auto');
  ga('send', 'pageview');


  </script>
 
   </head>
   <body>
      <!--header start-->
      <header class="head-section">
	  <nav class="navbar navbar-default" role="navigation">
         <div class="navbar navbar-default navbar-static-top container">
            <div class="navbar-header">
               <button type="button" class="navbar-toggle" data-toggle="collapse"
            data-target=".navbar-ex1-collapse">
			  <span class="sr-only">Desplegar navegación</span>
			  <span class="icon-bar"></span>
			  <span class="icon-bar"></span>
			  <span class="icon-bar"></span>
			</button>
			
			<div style="padding-top: 2%;">
			<g:link controller="user" action="renderIndex">
      <asset:image src="logos/logo.png" alt="Logo" style="margin-top:20px;" />
       </g:link>
			</div>

            </div>
            <div class="collapse navbar-collapse navbar-ex1-collapse">
               <ul class="nav navbar-nav">
                  <li>
                     <a id="brand1" style="margin-top:0px;" href="${createLink(controller:'redirect', action:'principal')}"><g:message code="commercial.navbar.home"/> 
                     </a>
                  </li>
                  
                  <li>
                     <a href="${createLink(controller:'redirect', action:'commercialFeatures')}"><g:message code="commercial.navbar.features"/>
                	</a>
                 </li>

                 <li>
                     <a href="${createLink(controller:'redirect', action:'commercialLicense')}"> <g:message code="commercial.navbar.license"/>
                  </a>
                 </li>
                 
                 <li id="demoLi"><g:link controller="redirect" action="commercialDemo" style="background-color: #ff8000; color: #fff">
                  <g:message code="commercial.navbar.demo" />
                  </g:link>
                </li>
                  
                  <li>
                	<a href="${createLink(controller:'redirect', action:'commercialBlog')}"><g:message code="commercial.navbar.blog"/>
                	</a>
                 </li>
                  
                  <li>
                     <a href="${createLink(controller:'redirect', action:'commercialContact')}"><g:message code="commercial.navbar.contactUs"/> 
                     </a>
                  </li>
                  
                  <li class="dropdown">
                     <a class="dropdown-toggle" data-close-others="false" data-delay="0" data-hover=
                        "dropdown" data-toggle="dropdown" href="#"><g:message code="commercial.navbar.language"/>  <i class="fa fa-angle-down"> </i>
                     </a>
                     <ul class="dropdown-menu">
                        <li>
                           <a id="spanishLang" href="?lang=es"><asset:image src="languages/Spain_flag.png" /> <g:message code="commercial.navbar.language.spanish" /></a>
                        </li>
                        <li>
                          <a id="englishLang" href="?lang=en"><asset:image src="languages/USA_flag.png" /> <g:message code="commercial.navbar.language.english" /></a>
                        </li>
                       
                     </ul>
                  </li>

                <li id="registerLi">
                  <g:link  controller="register" action="index" >
                    <g:message code='commercial.navbar.register'/>
                  </g:link>
                </li>    

      					<li>
                  <g:link  controller="login" action="auth" style="background-color: #0080c0; color: #fff">
      						  <g:message code="commercial.navbar.login" />
      					   </g:link>
      					</li>
                  
                 
               </ul>
            </div>
         </div>
		 </nav>
      </header>

      <script type="text/javascript">
        $('#registerLi').click(function(){
          ga('send', 'event', 'Button', 'click', 'Registro directo');
        })

         $('#demoLi').click(function(){
          ga('send', 'event', 'Button', 'click', 'Prueba gratuita');
        })
      </script>

      <!--header end-->