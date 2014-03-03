$(window).load(function() {
	$('#spinner').fadeOut();
	$('#preloader').delay(300).fadeOut('slow');
	setTimeout(function(){$('.first-slide div:first-child').addClass('fadeInDown');},100);
	setTimeout(function(){$('.first-slide div:last-child').addClass('fadeInRight');},100);
	setTimeout(function(){$('#top-navi').addClass('bounceInDown');},100);
	setTimeout(function(){$('.side-navi').addClass('slideInRight');},100);
});

/*Checking if it's touch device we disable some functionality due to inconsistency*/
if (Modernizr.touch) {
	$('*').removeClass('animated');
}

$(document).ready(function(e) {
	$('#features-hero-slider').bxSlider({
		mode: 'fade',
		adaptiveHeight: true,
		controls: false,
		video: true,
		touchEnabled: false
	});
	////////////////////////////////////////////////////////////////////

	//Enable Touch / swipe events for carousel
	$(".carousel-inner").swipe( {
		//Generic swipe handler for all directions
		swipeRight:function(event, direction, distance, duration, fingerCount) {
			$(this).parent().carousel('prev');
		},
		swipeLeft: function() {
			$(this).parent().carousel('next');
		},
		//Default is 75px, set to 0 for demo so any distance triggers swipe
		threshold:0
	});

	/*Adding Placeholder Support in Older Browsers*/
	$('input, textarea').placeholder();

	$('#sign-form').submit(function(event) {
		$.ajax({
			type: 'POST',
			url: '/sign',
			data: {
				email: $('#email').val(),
				university: $('#university').val()
			},
			success: function(data) {
				$('#sign-button').attr("disabled", "disabled");
				$('#sign-button').text("Thanks!");
			}
		});
		return false;
	});

});


