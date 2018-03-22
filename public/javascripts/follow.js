$(document).ready(function() {
	var orig_nfollowed = parseInt($('a#nfollowed').text());

	$("#follow-button").click(function(){
		var $nfollowed = $('a#nfollowed').text();
		var cur_nfollowed = parseInt($nfollowed);
		if ($("#follow-button").text() == "+ Follow"){
			// *** State Change: To Following ***      
			  $('a#nfollowed').text(cur_nfollowed + 1);
				$("#follow-button").text("Following");
		}else{
			// *** State Change: Unfollow ***     
				$('a#nfollowed').text(cur_nfollowed - 1);
				$("#follow-button").text("+ Follow");
		}
	}); 

	
	// check if nfollowed changed 
	// if so, post 
	// if not, do nothing
	$(window).on('unload', function() {
		var $nfollowed = parseInt($('a#nfollowed').text());
		if (orig_nfollowed !== $nfollowed) {
			$.ajax({
				type: 'POST',
				url: $('a#follow-direct').attr('href'),
				async: false,
				data: {targeted_id:$("#targeted-id").attr('value')}
			});
		}
	});
});