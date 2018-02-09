<!DOCTYPE html>
<html lang="sp">
<head>
	<asset:stylesheet src="bootstrap.min.css" />
	<asset:stylesheet src="hover.min.css" />
	<asset:stylesheet src='font-awesome/css/font-awesome.css'/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>ThunderTest</title>
	<script>
		function go(form){
			var http = "http://";
			var url = document.forms[0].elements[0].value;
			var isUrlValid = isHttp(url);
			if(isUrlValid == false){
				location.href="http://"+url;
			}else{
				location.href=url;
			}
			
		}
		function isHttp(url){
			var urlValid = url.substring(0,7);
			if("http://" == urlValid){
				return true;
			}else{
				return isHttps(url);
			}
		}
		function isHttps(url){
			var validUrlSecure = url.substring(0,8);
			if("https://" == validUrlSecure){
				return true;
			}else{
				return false;
			}
		}
		function barFocus(){
			document.getElementById("body").focus();
		}
		document.ready(function(){
			barFocus()
		})
	</script>
	<style>
		html,body {
			height: 100%;
		}

		#wrap {
			min-height: 100%;
			height: 100%;
		}
		#wrap > .center-container {
			margin:0;
		}
		
		.center-container {
			height:100%;
			display: table;
			width:100%;
			margin:0;
		}

		.center-row {
			height:50%;
			width:100%;
			display: table-row;
		}
		  
		.center-row > div {
			height:100%;
			display: table-cell;
			border:0 solid #eee;
			color:red;
			vertical-align:middle;
		}

		#thunder-img {
			display: block;
			margin-left: auto;
			margin-right: auto;
			margin-top: 120px;
			padding-right: 8px;
		}
	</style>
</head>
<body onload="barFocus()">

	<!-- Wrap all page content here -->
<div id="wrap">

  <!-- Begin page content -->
  <div class="center-container">
    <div class="center-row">
      <div class="col-md-3"></div>
			<div class="col-md-6">
				<asset:image src="logos/logo_mapper.png" alt="Thunder Test" id="thunder-img" />
			</div>
			<div class="col-md-3"></div>
    </div>
    <div class="center-row">
      <div class="col-md-3"></div>
			<div class="col-md-6">
				<form method="get" name="goToUrl" onsubmit="javascript:go(this); return false;">
					<div class="input-group">
					  <input id="txtGo" type="text" class="form-control" placeholder="https://">
					  <span class="input-group-btn">
						<button class="btn btn-primary hvr-pulse-grow" type="submit">
							<span class="fa fa-arrow-right" aria-hidden="true"></span>
						</button>
					  </span>
					</div>
				</form>
				<div>
					<h2>
					<small>
						<p class="text-center">
							<g:message code="mapper.pressKeys"/>
								<asset:image src="logos/gear_mapper.png" alt="Mapper" height="32px" width="32px" />
							<g:message code="mapper.toOpenMapper"/>
						</p>
					</small>
					</h2>
				</div>
				<div class="text-center">
					<a href="?lang=es"> <asset:image src="languages/Spain_flag.png" />
					</a>
					<a href="?lang=en">  <asset:image src="languages/USA_flag.png" /> 
					</a>
				</div>
					
			</div>
			<div class="col-md-3">
			
			</div>
    </div>
  </div>
</div>
</body>
</html>