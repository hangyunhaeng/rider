$(document).ready(function() {

/* ---------------------
	Variables Declaration
------------------------ */
	var
		$gnbItem = $('#gnb > li'),
		$gnbLink = $('#gnb > li > a'),
		$controllPrev = $('.gnb-slide-control .prev'), // 20180226 
		$controllNext = $('.gnb-slide-control .next'), // 20180226
		$controllClose = $('.gnb-slide-control .close'), // 20180226
		page = null;
	
	
	
	
	
/* --------------------
	Function Declaration
----------------------- */
	function makeHidden(href){
		var
			$target = $(href),
			$targetBody = $target.children('.layerWrap'),
			$targetController = $target.find('.slideLinks'),
			height = $target.height();
			
		$targetBody.stop().animate({
			top: '-' + height + 'px'
			}, function(){
				$target.hide();
				//$targetController.show();
				$(this).css({top:0});
		});
		
		page = null;
	}
	
	function toggle(href){
		var
			$target = $(href),
			$targetBody = $target.children('.layerWrap'),
			$targetController = $target.find('.slideLinks'),
			height = $target.height(),
			longestHeight = null,
			$longestElement = null;
	
		$target.show();
		$targetController.show();
		$targetBody.css('top', '-' + height + 'px').show().stop().animate({top: 0}, function(){
			$(this).addClass('view');
		});
	
		// 서브메뉴 1~4까지의 높이 설정
		$targetBody.find('.area:lt(4)').each(function(){
			var currentHeight = $(this).height();
			
			if(currentHeight > longestHeight) {
				longestHeight = currentHeight;
				$longestElement = $(this);
			}
		});
		longestHeight = $longestElement.height();
		$targetBody.find('.area:lt(4)').height(longestHeight);
		
		// 서브메뉴 5이상의 높이 설정
		longestHeight = null;
		$targetBody.find('.area:gt(3)').each(function(){
			var currentHeight = $(this).height();
			
			if(currentHeight > longestHeight) {
				longestHeight = currentHeight;
				$longestElement = $(this);
			}
		});
		longestHeight = $longestElement.height();
		$targetBody.find('.area:gt(3)').height(longestHeight);
		
		page = $target.parent().index();
	}
	
	function move(from, to, currentPage){
		var 
			$from = $(from),
			$fromSubWrap = $from.children('.layerWrap'),
			$fromSubSection = $from.find('.section'),
			$fromController = $from.find('.slideLinks'),
			fromHeight = $from.height(),
			
			$to = $(to),
			$toSubWrap = $to.children('.layerWrap'),
			$toSubSection = $to.find('.section'),
			$toController = $to.find('.slideLinks'),
			toHeight = $to.height(),
			
			longestHeight = null,
			$longestElement = null;
	
		$to.show();
	
		// 서브메뉴 1~4까지의 높이 설정
		$toSubWrap.find('.area:lt(4)').each(function(){
			var currentHeight = $(this).height();
			
			if(currentHeight > longestHeight) {
				longestHeight = currentHeight;
				$longestElement = $(this);
			}
		});
		longestHeight = $longestElement.height();
		$toSubWrap.find('.area:lt(4)').height(longestHeight);
		
		// 서브메뉴 5이상의 높이 설정
		longestHeight = null;
		$toSubWrap.find('.area:gt(3)').each(function(){
			var currentHeight = $(this).height();
			
			if(currentHeight > longestHeight) {
				longestHeight = currentHeight;
				$longestElement = $(this);
			}
		});
		longestHeight = $longestElement.height();
		$toSubWrap.find('.area:gt(3)').height(longestHeight);
		
		$fromSubWrap.removeClass('view');
		$toSubWrap.removeClass('view');
		$fromController.hide();
		$toController.hide();
	
		$toSubSection.css({
			top: '-' + toHeight + 'px',
			height: fromHeight + 'px'
		}).stop().animate({
			top: 0,
			height: toHeight + 'px'
		}, 300, function(){
			$(this).css('height', 'auto');
			$toSubWrap.addClass('view');
			$toController.show();
		});
		
		$fromSubSection.stop().animate({
			top: '-' + toHeight + 'px',
			height: toHeight + 'px'
		}, 300, function(){
			$(this).css('height', 'auto');
			$from.hide();
			$(this).css('top', 0);
		});
		
		page = $to.parent().index();
	}
	
	
	
	
	
/* --------------
	Event Handling
----------------- */
	$gnbLink.on('click', function(){
		var
			$clicked = $(this),
			$target = $clicked.attr('href'),
			$clickedParent = $clicked.parent(),
			parentIndex = $clickedParent.index(),
			$from = $gnbItem.eq(page).removeClass('on').children('a').attr('href');
			
		if(page === null) { // 메뉴가 열리지 않은 경우
			$clickedParent.addClass('on');
			toggle($target);
		} else {
			if(page === parentIndex) { // 열린 메뉴를 클릭한 경우
				$clickedParent.removeClass('on');
				makeHidden($target);
			} else if(page !== parentIndex) { // 열린 메뉴가 아닌 다른 메뉴 클릭한 경우
				$clickedParent.addClass('on');
				move($from, $target, parentIndex);
			}
		}
		
		if (event.preventDefault) {
			return event.preventDefault();
		} else {
			return false;
		}
	});
	
	$controllPrev.on('click', function(){
		var $from = $gnbItem.eq(page).removeClass('on').children('a').attr('href');
		
		page -= 1;
		
		var $to = $gnbItem.eq(page).addClass('on').children('a').attr('href');
		
		move($from, $to, page);
		
		if (event.preventDefault) {
			return event.preventDefault();
		} else {
			return false;
		}
	});
	
	$controllNext.on('click', function(){
		var $from = $gnbItem.eq(page).removeClass('on').children('a').attr('href');
		
		page += 1;
		
		var $to = $gnbItem.eq(page).addClass('on').children('a').attr('href');
		
		move($from, $to, page);
		
		if (event.preventDefault) {
			return event.preventDefault();
		} else {
			return false;
		}
	});
	
	$controllClose.on('click', function(){
		var 
			$active = $gnbItem.eq(page),
			$target = $active.children('a').attr('href');
			
			$active.removeClass('on');
			makeHidden($target);
	});

});