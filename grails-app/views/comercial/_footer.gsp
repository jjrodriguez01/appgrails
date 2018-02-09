<!--footer start-->

<footer class="footer">
	<div class="container">
		<div class="row">
			<div class="col-lg-3 col-sm-3 address wow fadeInUp"
				data-wow-duration="2s" data-wow-delay=".1s">
				<h1><g:message code="footer.contact" /></h1>
				<address>
					<!--<p>
						<i class="fa fa-home pr-10"> </i><g:message code="footer.address" />: Calle 133 No. 19
					</p> -->
					<p>
						<i class="fa fa-globe pr-10"> </i>Bogotá, Colombia
					</p>
					<!--<p>
						<i class="fa fa-mobile pr-10"> </i><g:message code="footer.mobile" />: (57) 300 2550265 
					</p>
					<p>
						<i class="fa fa-phone pr-10"> </i><g:message code="footer.phone" />: (57) (1) 744 7037/38/39 
					</p> -->
					<p>
						<i class="fa fa-envelope pr-10"> </i>Email : <a
							href="acme/javascript:;">thundertestsoftware@gmail.com</a>
					</p>
				</address>
			</div>






			<div id="twitter_update_list" class="col-lg-3 col-sm-3 wow fadeInUp"
				data-wow-duration="2s" data-wow-delay=".3s">
				<h1>
					<g:message code="text.latestTweets" />
				</h1>
				<div>
					<div id="tweecool"></div>
				</div>

			</div>
			<div class="col-lg-3 col-sm-3">
				<div class="page-footer wow fadeInUp" data-wow-duration="2s"
					data-wow-delay=".5s">
					<h1>ThunderTest</h1>
					<ul class="page-footer-list">
						<li><i class="fa fa-angle-right"> </i> <a href="${createLink(controller:'redirect', action:'commercialFeatures')}"><g:message code="commercial.navbar.features"/> </a></li>
      					<li><i class="fa fa-angle-right"> </i> <a href="${createLink(controller:'redirect', action:'commercialDemo')}"><g:message code="commercial.navbar.demo"/> </a></li>
      					<li><i class="fa fa-angle-right"> </i> <a href="${createLink(controller:'redirect', action:'commercialBlog')}"><g:message code="commercial.navbar.blog"/> </a></li>
      					<li><i class="fa fa-angle-right"> </i> <a  href="${createLink(controller:'redirect', action:'commercialContact')}"><g:message code="commercial.navbar.contactUs"/> </a></li>
					</ul>
				</div>
			</div>
			<div class="col-lg-3 col-sm-3">
				<div class="text-footer wow fadeInUp" data-wow-duration="2s"
					data-wow-delay=".7s">
					<h1><g:message code="footer.titleWidget" /></h1>
					<p><g:message code="footer.textWidget" /></p>
				</div>
			</div>
		</div>
	</div>
</footer>
<!-- footer end -->
<!--small footer start -->
<footer class="footer-small">
	<div class="container">
		<div class="row">
			<div class="col-lg-6 col-sm-6 pull-right">
				<ul class="social-link-footer list-unstyled">
					<li class="wow flipInX" data-wow-duration="2s" data-wow-delay=".1s">
				          <a href="javascript:"
				          onclick="window.open('https://www.facebook.com/ThunderTest-200339143636305/', '_target');">
				           <i class="fa fa-facebook"> </i>
				     </a>
				     </li>

				     <li class="wow flipInX" data-wow-duration="2s" data-wow-delay=".5s">
				      <a href="javascript:"
				      onclick="window.open('https://twitter.com/ThunderTestSoft', '_target');">
				       <i class="fa fa-twitter"> </i>
				     </a>
				     </li>

				     <li class="wow flipInX" data-wow-duration="2s" data-wow-delay=".8s">
				      <a href="javascript:"
				      onclick="window.open('https://www.youtube.com/channel/UCJqUR9T-i7ctp16cOMsS5lg/', '_target');">
				       <i class="fa fa-youtube"> </i>
				     </a>
				     </li>
				</ul>
			</div>
			<div class="col-md-4">
				<div class="copyright">
					<p>&copy;Copyright ThunderTest </p>
				</div>
			</div>
		</div>
	</div>
</footer>
<script type="text/javascript">
	
  wow = new WOW(
          {
              
            boxClass:     'wow',      // default
            animateClass: 'animated', // default
            offset:       0          // default
          }
        )
        wow.init();
	
</script>
<asset:stylesheet src="style.css" />  
<!--small footer end-->

