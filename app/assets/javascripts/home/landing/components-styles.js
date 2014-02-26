//Ultima HTML5 Landing Page v1.0
//Copyright 2014 8Guild.com
//All scripts for Ultima Components and Styles Page


/*Document Ready*/
$(document).ready(function(e) {
	
	/*Vertically Center Side Navigation*/
	var sideNav = $('.side-navi');
	var sideNavH = sideNav.innerHeight();
	var sideNavMT = -sideNavH/2;
	$('.side-navi').css('margin-top', sideNavMT);
	
	////////////////////////////////////////////////////////////
	//INTERNAL ANCHOR LINKS SCROLLING (NAVIGATION)
	$(".scroll").click(function(event){		
		event.preventDefault();
		$('html, body').animate({scrollTop:$(this.hash).offset().top}, 1000, 'easeInOutQuart');
	});
	
	/*Scroll Up*/
	$('.scroll-up').click(function(){
    $("html, body").animate({ scrollTop: 0 }, 1000, 'easeInOutQuart');
    return false;
	});
	
	//SCROLL-SPY
	// Cache selectors
	var lastId,
		topMenu = $(".side-navi"),
		topMenuHeight = topMenu.outerHeight(),
		// All list items
		menuItems = topMenu.find("a"),
		// Anchors corresponding to menu items
		scrollItems = menuItems.map(function(){
		  var item = $($(this).attr("href"));
		  if (item.length) { return item; }
		});
	
	// Bind to scroll
	$(window).scroll(function(){
	   // Get container scroll position
	   var fromTop = $(this).scrollTop()+topMenuHeight-150;
	   
	   // Get id of current scroll item
	   var cur = scrollItems.map(function(){
		 if ($(this).offset().top < fromTop)
		   return this;
	   });
	   // Get the id of the current element
	   cur = cur[cur.length-1];
	   var id = cur && cur.length ? cur[0].id : "";
	   
	   if (lastId !== id) {
		   lastId = id;
		   // Set/remove active class
		   menuItems
			 .parent().removeClass("current")
			 .end().filter("[href=#"+id+"]").parent().addClass("current");
	   }
	});
	// Bind to load
	$(window).load(function(){
	   // Get container scroll position
	   var fromTop = $(this).scrollTop()+topMenuHeight-150;
	   
	   // Get id of current scroll item
	   var cur = scrollItems.map(function(){
		 if ($(this).offset().top < fromTop)
		   return this;
	   });
	   // Get the id of the current element
	   cur = cur[cur.length-1];
	   var id = cur && cur.length ? cur[0].id : "";
	   
	   if (lastId !== id) {
		   lastId = id;
		   // Set/remove active class
		   menuItems
			 .parent().removeClass("current")
			 .end().filter("[href=#"+id+"]").parent().addClass("current");
	   }
	});
	////////////////////////////////////////////////////////////////////
	
	/*Custom Style Checkboxes and Radios*/
	$('input').iCheck({
    checkboxClass: 'icheckbox',
    radioClass: 'iradio'
  });	
	
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
	
	/*Gallery Plugin Initializing*/
	Grid.init();
	
	/*Tooltips*/
	$('.tooltipped').tooltip();
	
	/*Countdown*/
	$('.countdown').countdown('2014/05/02', function(event) {
    $(this).html(event.strftime('%D:%H:%M:%S'));
  });

	/*Form Validation*/
	$("#form-validation").validate();
		
	/*Components & Styles Page Link Prevent Default Behavior*/
	if($('.buttons-demo a').length > 0){
		$('.buttons-demo a').click(function(e){
			e.preventDefault();
		});	
	}
	
});/*/Document ready*/


