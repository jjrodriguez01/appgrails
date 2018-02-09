function enableSearch(){

	$('#datatablesearch').keyup(function() {
		var text=$(this).val()
		var $rows = $('#'+$(this).attr('table')+' tbody tr');
	    var val = '^(?=.*\\b' + $.trim($(this).val()).split(/\s+/).join('\\b)(?=.*\\b') + ').*$';
	    var reg = RegExp(val, 'i');
	    var text;
	    $rows.show().filter(function() {
	        text = $(this).text().replace(/\s+/g, ' ');
	        return !reg.test(text);
	    }).hide();
	});
}


function makeTablePaginated(){

	$('table.paginated').each(function() {
		$(this).css('margin-top','25px')
		var $table = $(this);
		$table.bind('repaginate', function() {
			$table.find('tbody tr').hide().slice(currentPage * numPerPage, (currentPage + 1) * numPerPage).show();
		});
		$table.trigger('repaginate');
		var numRows = $table.find('tbody tr').length;
		var numPages = Math.ceil(numRows / numPerPage);
		var $pager = $('<div class="pager" id="'+$(this).attr('id')+'"></div>');
		for (var page = 0; page < numPages; page++) {
			$('<button class="btn  btn-default page-number" style="margin-right:12px;"></button>').text(page + 1).bind('click', {
				newPage: page
			}, function(event) {
				currentPage = event.data['newPage'];
				$table.trigger('repaginate');
				$(this).addClass('active').siblings().removeClass('active');
			}).appendTo($pager).addClass('clickable');
		}
		$pager.insertAfter($table).find('button.page-number:first').addClass('active');
	});
} 