$(document).ready(function() {
	var i = 0;
	var target = $('#tweet-card')
	// $( '#tweet-card' )
	// 	.mouseover(function() {
	// 		i += 1;
	// 		$( this ).find( "miniprofile" ).text( "mouse over x " + i );
	// 	})
	// 	.mouseout(function() {
	// 		$( this ).find( "miniprofile" ).text( "mouse out " );
	// 	});
	 
	// var n = 0;
	// $( "#tweet-card" )
	// 	.mouseenter(function() {
	// 		n += 1;
	// 		$( this ).find( ".miniprofile" ).stop(true, true).fadeIn()
	// 	})
	// 	.mouseleave(function() {
	// 		$( this ).find( ".miniprofile" ).stop(true, true).fadeOut()
	// 	});

$("#tweet-card").hover(function() {
    $(this).find(".miniprofile").stop(true, true).fadeIn();
}, function() {
    $(this).find(".miniprofile").stop(true, true).fadeOut();
});

});
