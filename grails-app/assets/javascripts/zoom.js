

	function setZoomImages(){
		

		$('.zoomImage').hover(function() {
			var maxWidth = $(document).width()*60 /100
			var maxHeight = $(document).height()*38 /100
			if($(this).attr('src').indexOf('noImage')==-1){
				$(this).css('position', 'absolute')
				$(this).css('z-index','9999999')
				$(this).css('max-height',maxHeight+'px');
				$(this).css('max-width',maxWidth+'px');
				$(this).css('border','solid 1px black')
				
				var windowWidth = $(document).width()
				var rightPosition = $(this).width() +$(this).offset().left

				var windowHeight = $(document).height()
				var bottomPosition = $(this).height() +$(this).offset().top


				if(rightPosition>(windowWidth)){
					$(this).css('margin-left','-'+(rightPosition-windowWidth + 50)+"px")
				}

				if((bottomPosition+80)>(windowHeight)){
					$(this).css('margin-top','-'+(bottomPosition-windowHeight+ 200)+"px")
				}
			}
			

		})

		$('.zoomImage').mouseout(function() {
			$(this).css('z-index','1')
			$(this).css('position', 'relative')
			$(this).css('max-height','50px')
			$(this).css('max-width','150px');
			$(this).css('margin-top','0px')
			$(this).css('margin-left','0px')
			$(this).css('border','')
			
		})

	}