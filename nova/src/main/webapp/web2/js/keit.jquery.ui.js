// Function declaration which is handling the quick menu
function quickEvt(){
  var
    maxPos = $(document).height() - 800,
    //quickT = $(".quick").offset().top, // kaia 20180307: remove the unused variable
    scrollT = $(document).scrollTop(); // kaia 20180307: merge var keyword section

  if(!$('.quick')) { return false; } // kaia 20180307: use shortcut
  if(maxPos < scrollT){ return false; }
  else{ $(".quick").stop().animate({ "top": scrollT + 47 + "px" }, 300 ); } // inno20180518: edit top, kaia 20180308: use shortcut, 20180222: editing number(from 175 into 60)
}


// Function declaration which is floating the bottom-fixed area : kaia 20180307
function floatBottomFixed(){
  var
    pageHeight = $(document).height(),
    viewHeight = $(window).height(),
    scrollTop = $(document).scrollTop();

  if((viewHeight + scrollTop) >= pageHeight){
    $('.bottom-fixed').css('bottom', '95px');
  } else {
    $('.bottom-fixed').css('bottom', 0);
  }
}


// Function declaration which is toggling the bottom notice area : kaia 20180308
function toggleBottomFixed(){
  var
    $this = $(this),
    getClass = $this.attr('class').split(' ')
    firstClass = getClass[0]
    state = firstClass.split('__')[1],
    forResetClass = state.split('-'),
    resultClass = '',
    $parent = $this.parents('.bottom-fixed'),
    pageHeight = $(document).height(),
    viewHeight = $(window).height(),
    scrollTop = $(document).scrollTop(),
    bottomAnchor = '';

  if(forResetClass.length != 1){
    resultClass += forResetClass[1] + '-';
  }
  resultClass += forResetClass[0] + 'ed';

  if(pageHeight > (scrollTop + viewHeight)){
    bottomAnchor = 0;
  }else if(pageHeight === (scrollTop + viewHeight) && resultClass === 'folded'){
    bottomAnchor = '95px';
  }

  $parent.stop().animate({bottom: bottomAnchor}, 200, function(){
    $(this).removeClass('folded all-unfolded part-unfolded').addClass(resultClass);
  });
}

// Function declaration which is adjsuting height of table in a div.flex-vertical : 20180314(moved from then)
function adjust(){
  var wh = $(window).height();
  var targetH = wh - 400;

  $('.flex-vertical').css('height', targetH + 'px');
}

$(document).ready(function(){
  // Close layers (kaia 20180308)
  $('#sitemap .btn_close').click(function(){
    $('#sitemap').hide();
  });
  $('[id^=layerpop] .close').click(function(){
    $(this).parents('[id^=layerpop]').hide();
  });

  // Handle sitemap
  $(".keit-sitemap").click(function(){ // keit 180516: edit selector, kaia 20180227: edit selector
    $("#sitemap").show();

    $('.allmenu_box dl').each(function(){
      var longH = null; // kaia 20180307: Adding var keyword for standardization

      $(this).find('.area:lt(4) .areain').each(function(){
        var currH = $(this).height();
        if(currH > longH){ longH = currH; }
      });
      $(this).find('.area:lt(4) .areain').css('height', longH + 'px'); // Adding unit in the code (kaia 20180307)

      longH = null;
      $(this).find('.area:gt(3) .areain').each(function(){
        var currH = $(this).height();
        if(currH > longH){ longH = currH; }
      });
      $(this).find('.area:gt(3) .areain').css('height', longH + 'px'); // Adding unit in the code (kaia 20180307)

      $(this).find('.area:nth-child(4n) .areain').css('border-right', 0); // Editing value into number (kaia 20180307)
    });
  });

  // Handle FAQ accordion
  $( ".faq dt" ).click(function() {
    $(this).next().slideToggle(200);
    $(this).children("span").toggleClass("close");
  });

  // Message alerting that the user has to log in (inno 180529: newly added)
  $('nav.loggedout').click(function(){
    alert('로그인 후 사용가능합니다');
  });

  // Toggling summary of a task (inno 180523: commenting for using cookies, kaia 20180321:moving into a jsp file, 20180125)
  //$('.btn--toggle-summary').click(function(){
//    $(this).parents('.slide_box').find('.viewbox').slideToggle(300);
//    $(this).toggleClass('open');
//  });

  // Setting the height of the box of the image (inno 180523: using css instead of js, kaia 20180307)
  //$('.tutor-item').each(function(){
//    var imgHeight = $(this).find('.tutor-img').height();
//    console.log(imgHeight);
//    $(this).css('height', imgHeight + 'px');
//  });

  // Toggling the bottom-fixed notice area (kaia 20180308)
  $('.bottom-fixed-control > button').click(toggleBottomFixed);

  // Handle quick menu
  quickEvt();

  // Dynamically setting the height of the table inside a div.flex-vertical : kaia 20180314
  adjust();

  // Float bottom-fixed area (kaia 20180307)
  floatBottomFixed();
});

$(window).on('scroll resize',function(){ // kaia 20180307: applying the function as to resizing the window
  quickEvt();
  floatBottomFixed(); // kaia 20180307
  adjust(); // kaia 20180314
});