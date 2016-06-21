$(document).ready(function() {

	$('.loading-page').hide();

	// parallax effect 
	$('.parallax').parallax();
	$('.carousel').slick({
		dots: true,
		infinite: true,
		slidesToShow: 3,
  		slidesToScroll: 1,
  		lazyLoad: 'ondemand',
  		responsive: [
	    {
	      breakpoint: 550,
	      settings: {
	        slidesToShow: 1,
	        slidesToScroll: 1,
	      }
	    }]
	});

	// Add New Card Form
	$('#card-add-new').hide();
	$('#card-add-button').click(function() {
		$('#card-add-new').show();
		$('#card-add-new').addClass("animated slideInUp");
	});

	// change profile-photo 
	$('.change-photo-button').click(function() {
		$('input[id="user_avatar"]').click();
	});

	// click to restaurant
	// bug: when waitlist is clicked it also goes to the restaurant page
	$('.card-view').click(function() {
		// var ln = $('.card-header').attr("href")
		// window.location.href = ln;
	});

	// shopping cart
	$('.shopping-cart-title').click(function() {
		$('.shopping-cart-wrapper').toggle();
		$('.shopping-cart svg').toggle();
	});

	// payment detail toggle
	$('.payment-summary').click(function() {
		console.log($(this).parent().parent().find('payment-detail'));
		$(this).parent().parent().find('.payment-detail').toggle();
		// $(this).parent().children('.payment-detail').toggle();
	});

	// typed.js for landing page
	$('#typed').typed({
        strings: ["Fettuccine", "Lasagna", "Pad Thai", "Fried Rice"],
        typeSpeed: 0,
        backDelay: 1000,
        loop: true
    });

    $('div[toggle="advanced-search"]').click(function(){
    	$('.advanced-search-wrapper').show();
    	$('.advanced-search-wrapper').addClass("animated slideInUp");
    });
});


// Youtube API

var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
	player = new YT.Player('yt-player', {
	    height: '500px',
	    width: '100%',
	    videoId: 'frubRK86fb4',
	    playerVars: {
	      'controls': 0,
	      'rel': 0,
	      'showinfo': 0,
	      'modestbranding': 1,
	    },
	});
}