$("#preview-card").hover(function() {
    $(this).find(".details").stop(true, true).fadeIn();
}, function() {
    $(this).find(".details").stop(true, true).fadeOut();
});

/* Hovercard CSS & jQuery

via: http://designwithpc.com/post/9627254593/simple-yet-sexy-hovercard-with-minimum-css
*/
