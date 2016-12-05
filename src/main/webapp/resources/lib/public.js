$(function(){
	$("body").css("min-height",$(window).height());
	
	if($(".nav>ul>li:first-child").has(".allnav").length==0){
		$(".nav>ul>li:first-child").height("42px")
	}
	
	$(window).resize(function(){
		$("body").css("min-height",$(window).height());
	})
})