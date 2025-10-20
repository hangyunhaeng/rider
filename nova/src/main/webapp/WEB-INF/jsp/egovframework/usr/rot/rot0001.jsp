<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../inc/header.jsp" />



<script type="text/javascript"	src="<c:url value='/js/echarts.min.js' />"></script>
    <script type="text/javascript"	src="<c:url value='/js/lodash.min.js' />"></script>
    <script type="text/javascript"	src="<c:url value='/js/phoenix.js' />"></script>
    <script type="text/javascript"	src="<c:url value='/js/anchor.min.js' />"></script>
    <script type="text/javascript"	src="<c:url value='/js/is.min.js' />"></script>


<%--     <script type="text/javascript"	src="<c:url value='/js/popper.min.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/all.min.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/list.min.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/feather.min.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/dayjs.min.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/leaflet.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/leaflet.markercluster.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/leaflet-tilelayer-colorfilter.min.js.다운로드' />"></script> --%>
<%--     <script type="text/javascript"	src="<c:url value='/js/ecommerce-dashboard.js' />"></script> --%>

</head>
<script type="text/javaScript">

	var colorArray = ["primary", "primary-lighter", "purple", "info-dark", "teal", "success-lighte", "danger-text-emphasis"];
	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		loadNotice();
		loadCooperatorList();
		loadCooperatorProfitList();
// 		newCustomersChartsInit();

	});
	function loadNotice(){

		const params = new URLSearchParams();
        axios.post('${pageContext.request.contextPath}/usr/rot0001_0001.do',params).then(function(response) {

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){

				drawNotice(response.data.list);
				drawInq(response.data.inqList);
        	}
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {

        });
	}
	function drawNotice(list){

		if(list.length > 0){
			for(var i = 0 ; i < list.length ; i++){

				$('#notList').append(
		         '<div class="d-flex hover-actions-trigger py-3 border-translucent border-top" onclick="notView(this)">'
		         +'   <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal">'
		         +'     <div class="col-12 col-md-auto col-xl-12 col-xxl-auto">'
		         +'       <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">'
		         +'       	<input type="hidden" name="notId" value="'+list[i].notId+'">'
		         +'			<label class="form-check-label mb-1 mb-md-0 my-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer">'+list[i].title+'</label></div>'
		         +'     </div>'
		         +'   </div>'
		         +'</div>'
		         );

			}
		} else {
			noNotice.append("공지사항이 없습니다")
		}
	}
	function notView(obj){


		const params = new URLSearchParams();
		params.append("notId", $(obj).find("input").val());

        axios.post('${pageContext.request.contextPath}/usr/not0002_0003.do',params).then(function(response) {

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
        		$('#title').text('');
        		$('#longtxt').text('');
         		$('#title').append(response.data.one.title);
         		$('#longtxt').append(replaceRevTag(response.data.one.longtxt));

         		$('#notList').find('img').attr("width", "100%");
        	}
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {

        });
	}

	function drawInq(list){

		if(list.length > 0){
			for(var i = 0 ; i < list.length ; i++){

				$('#inqList').append(
		         '<div class="d-flex hover-actions-trigger py-3 border-translucent border-top" onclick="inqView(this)">'
		         +'   <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal0">'
		         +'     <div class="col-12 col-md-auto col-xl-12 col-xxl-auto">'
		         +'       <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">'
		         +'       	<input type="hidden" name="inqId" value="'+list[i].inqId+'">'
		         +'			<label class="form-check-label mb-1 mb-md-0 my-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer">'+list[i].title+'</label></div>'
		         +'     </div>'
		         +'   </div>'
		         +'</div>'
		         );

			}
		} else {
			noInq.append("1:1문의가 없습니다")
		}
	}

	function inqView(obj){
		const params = new URLSearchParams();
		params.append("inqId", $(obj).find("input").val());

        axios.post('${pageContext.request.contextPath}/usr/inq0001_0002.do',params).then(function(response) {

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
				//보이는 내역 모두 삭제
				$('#inq반복부 > div').not(':eq(0)').remove();

        		response.data.list.forEach(function(dataInfo, idx){


        			if(dataInfo.gubun == "Q"){
    	        		$('#title0').text('');
    	        		$('#longtxt0').text('');
    	         		$('#title0').append(dataInfo.title);
    	         		$('#longtxt0').append(replaceRevN(dataInfo.longtxt));

        			} else {
		    			var 내역 = $('#inq반복부').find('[repeatObj=true]:hidden:eq(0)').clone();
		    			$('#inq반복부').append(내역);
		    			내역.find('[name=title]').text(dataInfo.title);
		    			내역.find('[name=longtxt]').html(replaceRevN(dataInfo.longtxt));
		    			내역.show();
        			}

        		});
        	}
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {

        });
	}

	function loadCooperatorList(){
		const params = new URLSearchParams();
		params.append('searchGubun', "MAIN");

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/mem0001_0000.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){

        		var data = [];
        		var allCnt = 0;
        		for(var i = 0 ; i < response.data.list.length ; i++){
        			data.push({value: response.data.list[i].rdcnt, name:response.data.list[i].cooperatorNm});
        			allCnt += Number(response.data.list[i].rdcnt, 10);

        			if(i < 3){
	        			var 내역 = $('#반복부').find('[repeatObj=true]:hidden:eq(0)').clone();
	        			$('#반복부').append(내역);
	        			내역.find('[name=name]').text(response.data.list[i].cooperatorNm);
	        			내역.find('[name=cnt]').text(response.data.list[i].rdcnt+"명");
	        			내역.find('.bullet-item').addClass("bg-"+colorArray[i%colorArray.length]);
	        			내역.show();
        			}
        		}


      	  		topCouponsChartInit(data, allCnt);
        	}


        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });
	}


	function loadCooperatorProfitList(){
		const params = new URLSearchParams();

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/rot0001_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){

        		var data = [];
        		var date = [];
        		var idxColor = 0;
        		for(var i = 0 ; i < response.data.profitList.length ; i++){
        			var oneData = response.data.profitList[i];
        			//data.push({value: response.data.list[i].rdcnt, name:response.data.list[i].cooperatorNm});
        			var bFindData = false;
        			var bFindDate = false;
        			for (var j = 0 ; j < data.length; j++){
        				if(data[j].cooperatorId == oneData.cooperatorId){
        					profitArr = data[j].data;
        					profitArr.push(oneData.cost);
        					data[j].data = profitArr;
        					bFindData = true;
        				}
        			}
        			if(!bFindData){
    					data.push({cooperatorId: oneData.cooperatorId
    						, yLabelName: oneData.cooperatorNm
    						, type:"line"
    						, data: [oneData.cost]
	                        , showSymbol: !1
	                        , symbol: "circle"
	                        , lineStyle: {
	                             width: 2,
	                             color: window.phoenix.utils.getColor(colorArray[(idxColor++)%colorArray.length])
	                        }
	                        , emphasis: {
	                             lineStyle: {
	                                 color: window.phoenix.utils.getColor(colorArray[(idxColor++)%colorArray.length])
	                             }
	                        }
	                        , zlevel: 2}
    					);
        			}

        			for (var j = 0 ; j < date.length; j++){
        				if(date[j] == oneData.day){
        					bFindDate = true;
        				}
        			}

        			if(!bFindDate){
        				date.push(oneData.day);
        			}
        		}


        		newCustomersChartsInit(data, date);
        	}


        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });
	}



    const {merge: merge} = window._;
    const echartSetOption = (t, e, s, n) => {
        const {breakpoints: o, resize: a} = window.phoenix.utils
          , l = e => {
            Object.keys(e).forEach((s => {
                window.innerWidth > o[s] && t.setOption(e[s]);
            }
            ));
        }
          , r = document.body;
        t.setOption(merge(s(), e));
        const i = document.querySelector(".navbar-vertical-toggle");
        i && i.addEventListener("navbar.vertical.toggle", ( () => {
            t.resize(),
            n && l(n);
        }
        )),
        a(( () => {
            t.resize(),
            n && l(n);
        }
        )),
        n && l(n),
        r.addEventListener("clickControl", ( ({detail: {control: o}}) => {
            "phoenixTheme" === o && t.setOption(window._.merge(s(), e)),
            n && l(n);
        }
        ));
    }
    ;

    const {echarts: echarts} = window
    , topCouponsChartInit = (data, allCnt) => {
      const {getData: t, getColor: e} = window.phoenix.utils
        , o = document.querySelector(".echart-top-coupons0");
      if (o) {
          const r = t(o, "options")
            , i = echarts.init(o);
          echartSetOption(i, r, ( () => ({
              color: [e(colorArray[0]), e(colorArray[1]), e(colorArray[2])],
              tooltip: {
                  trigger: "item",
                  padding: [7, 10],
                  backgroundColor: e("body-highlight-bg"),
                  borderColor: e("border-color"),
                  textStyle: {
                      color: e("light-text-emphasis")
                  },
                  borderWidth: 1,
                  transitionDuration: 0,
                  position(t, e, o, r, i) {
                      const n = {
                          top: t[1] - 35
                      };
                      return window.innerWidth > 540 ? t[0] <= i.viewSize[0] / 2 ? n.left = t[0] + 20 : n.left = t[0] - i.contentSize[0] - 20 : n[t[0] < i.viewSize[0] / 2 ? "left" : "right"] = 0,
                      n
                  },
                  formatter: t => '<strong>'+t.data.name+' : </strong>'+t.data.value+'명',
                  extraCssText: "z-index: 1000"
              },
              legend: {
                  show: !1
              },
              series: [{
                  name: allCnt+"명",
                  type: "pie",
                  radius: ["100%", "87%"],
                  avoidLabelOverlap: !1,
                  emphasis: {
                      scale: !1,
                      itemStyle: {
                          color: "inherit"
                      }
                  },
                  itemStyle: {
                      borderWidth: 2,
                      borderColor: e("body-bg")
                  },
                  label: {
                      show: !0,
                      position: "center",
                      formatter: "{a}",
                      fontSize: 23,
                      color: e("light-text-emphasis")
                  },
                  data: data
              }],
              grid: {
                  containLabel: !0
              }
          })));
      }
  };


const newCustomersChartsInit = (data, tmpDate) => {
      const {getColor: o, getData: t} = window.phoenix.utils
        , a = document.querySelector(".echarts-new-customers")
        , i = o => {
          const  a = o.map(( (o, a) => ({
              value: o.value,
              yLabelName:o.yLabelName,
              color: o.color
          })));
          let i = "";

          a.sort((a, b) => -(a.value - b.value));
          return a.forEach(( (o, t) => {
              i += '<h6 class="fs-9 text-body-tertiary '+(t>0?"mb-0":"")+'"><span class="fas fa-circle me-2" style="color:'+o.color+'"></span>\n'+o.yLabelName+' :  '+currencyFormatter(o.value)+'원\n    </h6>';
          }
          )),
          '<div class="ms-1">\n'+i+'\n</div>'
      }
      ;
      if (a) {
          const r = t(a, "echarts")
            , s = window.echarts.init(a);
          echartSetOption(s, r, ( () => ({
              tooltip: {
                  trigger: "axis",
                  padding: 10,
                  backgroundColor: o("body-highlight-bg"),
                  borderColor: o("border-color"),
                  textStyle: {
                      color: o("light-text-emphasis")
                  },
                  borderWidth: 1,
                  transitionDuration: 0,
                  axisPointer: {
                      type: "none"
                  },
                  formatter: i,
                  extraCssText: "z-index: 1000"
              },
              xAxis: [{
                  type: "category",
                  data: tmpDate,
                  show: !0,
                  boundaryGap: !1,
                  axisLine: {
                      show: !0,
                      lineStyle: {
                          color: o("secondary-bg")
                      }
                  },
                  axisTick: {
                      show: !1
                  },
                  axisLabel: {
                      formatter: o => o.substr(4,2)+'-'+o.substr(6,2),
                      showMinLabel: !0,
                      showMaxLabel: !1,
                      color: o("secondary-color"),
                      align: "left",
                      interval: 0,
                      fontFamily: "Nunito Sans",
                      fontWeight: 600,
                      fontSize: 12.8
                  }
              }, {
                  type: "category",
                  position: "bottom",
                  show: !0,
                  data: tmpDate,
                  axisLabel: {
                      formatter: o => o.substr(4,2)+'-'+o.substr(6,2),
                      interval: 130,
                      showMaxLabel: !0,
                      showMinLabel: !1,
                      color: o("secondary-color"),
                      align: "right",
                      fontFamily: "Nunito Sans",
                      fontWeight: 600,
                      fontSize: 12.8
                  },
                  axisLine: {
                      show: !1
                  },
                  axisTick: {
                      show: !1
                  },
                  splitLine: {
                      show: !1
                  },
                  boundaryGap: !1
              }],
              yAxis: {
                  show: !1,
                  type: "value",
                  boundaryGap: !1
              },
              series: data,
              grid: {
                  left: 0,
                  right: 0,
                  top: 5,
                  bottom: 20
              }
          })));
      }
  }
  ;
</script>
<body class="index-page">

	<jsp:include page="../inc/nav.jsp" />

	<!-- 숨겨진 폼 -->
	<form id="myForm" action="/conv/conv02410.do" method="POST"
		style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>

	<div class="keit-header-body innerwrap clearfix">
		<p class="tit"></p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />





          <div class="row g-4">

            <div class="col-12 col-xxl-12">
              <div class="row g-3">


                <div class="col-12 col-md-6">
                  <div class="card h-100">
                    <div class="card-body">
                      <div class="d-flex justify-content-between">
                        <div>
                          <h5 class="mb-2">협력사별 라이더수</h5>
<!--                           <h6 class="text-body-tertiary">Last 7 days</h6> -->
                        </div>
                      </div>
                      <div class="pb-4 pt-3">
                        <div class="echart-top-coupons0" style="height: 115px; width: 100%; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); position: relative;" _echarts_instance_="ec_1758602219821">
                        	<div style="position: relative; width: 323px; height: 115px; padding: 0px; margin: 0px; border-width: 0px;">
                        		<canvas data-zr-dom-id="zr_0" width="323" height="115" style="position: absolute; left: 0px; top: 0px; width: 323px; height: 115px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); padding: 0px; margin: 0px; border-width: 0px;"></canvas>
                        	</div>
                        	<div class=""></div>
                        </div>
                      </div>
                      <div id="반복부">
                        <div class="d-flex align-items-center mb-2" repeatObj="true" style="display:none !important;">
                          <div class="bullet-item me-2"></div>
                          <h6 class="text-body fw-semibold flex-1 mb-0" name="name">Percentage discount</h6>
                          <h6 class="text-body fw-semibold mb-0" name="cnt">72%</h6>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>



                <div class="col-12 col-md-6">
                  <div class="card h-100">
                    <div class="card-body">
                      <div class="d-flex justify-content-between">
                        <div>
                          <h5 class="mb-1">주정산서별 수익현황(콜,기타,선지급수수료)<span class="badge badge-phoenix badge-phoenix-warning rounded-pill fs-9 ms-2"> <span class="badge-label"></span></span></h5>
                          <h6 class="text-body-tertiary">Last 7 times</h6>
                        </div>
<!--                         <h4>0</h4> -->
                      </div>
                      <div class="pb-0 pt-4">
                        <div class="echarts-new-customers" style="height: 180px; width: 100%; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); position: relative;" _echarts_instance_="ec_1758602219820">
                        	<div style="position: relative; width: 323px; height: 180px; padding: 0px; margin: 0px; border-width: 0px; cursor: default;">
                        		<canvas data-zr-dom-id="zr_0" width="323" height="180" style="position: absolute; left: 0px; top: 0px; width: 323px; height: 180px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); padding: 0px; margin: 0px; border-width: 0px;"></canvas>
                        		<canvas data-zr-dom-id="zr_2" width="323" height="180" style="position: absolute; left: 0px; top: 0px; width: 323px; height: 180px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); padding: 0px; margin: 0px; border-width: 0px;"></canvas>
                        	</div>
                        	<div class="" style="position: absolute; display: block; border-style: solid; white-space: nowrap; box-shadow: rgba(0, 0, 0, 0.2) 1px 2px 10px; background-color: rgb(239, 242, 246); border-width: 1px; border-radius: 4px; color: rgb(20, 24, 36); font: 14px / 21px &quot;Microsoft YaHei&quot;; padding: 10px; top: 0px; left: 0px; transform: translate3d(158px, 70px, 0px); border-color: rgb(203, 208, 221); z-index: 1000; pointer-events: none; visibility: hidden; opacity: 0;">
	                        	<div class="ms-1">
<!-- 		              				<h6 class="fs-9 text-body-tertiary false"> -->
<!-- 			              				<svg class="svg-inline--fa fa-circle me-2" style="color: #5470c6;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="circle" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""> -->
<!-- 			              					<path fill="currentColor" d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512z"></path> -->
<!-- 			              				</svg><span class="fas fa-circle me-2" style="color:#5470c6"></span> Font Awesome fontawesome.com -->
<!-- 										May 04 : 200 -->
<!-- 									</h6> -->
<!-- 									<h6 class="fs-9 text-body-tertiary mb-0"> -->
<!-- 										<svg class="svg-inline--fa fa-circle me-2" style="color: #91cc75;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="circle" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""> -->
<!-- 											<path fill="currentColor" d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512z"></path> -->
<!-- 										</svg><span class="fas fa-circle me-2" style="color:#91cc75"></span> Font Awesome fontawesome.com -->
<!-- 										Apr 04 : 100 -->
<!-- 									</h6> -->
	            				</div>
            				</div>
            			</div>
                      </div>
                    </div>
                  </div>
                </div>


                <div class="col-12 col-md-6">
                  <div class="card h-100">
                    <div class="card-body">
                      <div class="d-flex justify-content-between">
                        <div>
                          <h5 class="mb-1">준비중<span class="badge badge-phoenix badge-phoenix-warning rounded-pill fs-9 ms-2"><span class="badge-label">-6.8%</span></span></h5>
                          <h6 class="text-body-tertiary">Last 7 days</h6>
                        </div>
                        <h4>0</h4>
                      </div>
                      <div class="d-flex justify-content-center px-4 py-6">
                        <div class="echart-total-orders" style="height: 85px; width: 115px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); position: relative;" _echarts_instance_="ec_1758602219825">
                        	<div style="position: relative; width: 115px; height: 85px; padding: 0px; margin: 0px; border-width: 0px;">
                        		<canvas data-zr-dom-id="zr_0" width="115" height="85" style="position: absolute; left: 0px; top: 0px; width: 115px; height: 85px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); padding: 0px; margin: 0px; border-width: 0px;"></canvas>
                        	</div>
                        	<div class=""></div>
                        </div>
                      </div>
                      <div class="mt-2">
                        <div class="d-flex align-items-center mb-2">
                          <div class="bullet-item bg-primary me-2"></div>
                          <h6 class="text-body fw-semibold flex-1 mb-0">Completed</h6>
                          <h6 class="text-body fw-semibold mb-0">52%</h6>
                        </div>
                        <div class="d-flex align-items-center">
                          <div class="bullet-item bg-primary-subtle me-2"></div>
                          <h6 class="text-body fw-semibold flex-1 mb-0">Pending payment</h6>
                          <h6 class="text-body fw-semibold mb-0">48%</h6>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>




                <div class="col-12 col-md-6">
                  <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                      <div class="d-flex justify-content-between">
                        <div>
                          <h5 class="mb-2">준비중</h5>
                          <h6 class="text-body-tertiary">Last 7 days</h6>
                        </div>
                      </div>
                      <div class="d-flex justify-content-center pt-3 flex-1">
                        <div class="echarts-paying-customer-chart" style="height: 100%; width: 100%; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); position: relative;" _echarts_instance_="ec_1758602219824"><div style="position: relative; width: 323px; height: 144px; padding: 0px; margin: 0px; border-width: 0px; cursor: default;"><canvas data-zr-dom-id="zr_0" width="323" height="144" style="position: absolute; left: 0px; top: 0px; width: 323px; height: 144px; user-select: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); padding: 0px; margin: 0px; border-width: 0px;"></canvas></div><div class=""></div></div>
                      </div>
                      <div class="mt-3">
                        <div class="d-flex align-items-center mb-2">
                          <div class="bullet-item bg-primary me-2"></div>
                          <h6 class="text-body fw-semibold flex-1 mb-0">Paying customer</h6>
                          <h6 class="text-body fw-semibold mb-0">30%</h6>
                        </div>
                        <div class="d-flex align-items-center">
                          <div class="bullet-item bg-primary-subtle me-2"></div>
                          <h6 class="text-body fw-semibold flex-1 mb-0">Non-paying customer</h6>
                          <h6 class="text-body fw-semibold mb-0">70%</h6>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>





				<!-- 공지사항 -->
                <div class="col-12 col-md-6">
                  <div class="card h-100">
                    <div class="card-body">





			<div class="d-flex flex-column search_box ty2">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-4">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">공지사항</h3>
                      <p class="mb-2 mb-md-0 mb-lg-2 text-body-tertiary" id="noNotice"></p>
                    </div>
                    <div class="col-auto w-100 w-md-auto">
                      <div class="row align-items-center g-0 justify-content-between">
                        <div class="col-12 col-sm-auto">
                          <div class="search-box w-100 mb-2 mb-sm-0" style="max-width:30rem;">
                          </div>
                        </div>
                        <div class="col-auto d-flex">
                          <p class="mb-0 ms-sm-3 fs-9 text-body-tertiary fw-bold">
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-body py-0 scrollbar to-do-list-body" id="notList">

<!--                   <div class="d-flex hover-actions-trigger py-3 border-translucent border-top"> -->
<!--                     <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal"> -->
<!--                       <div class="col-12 col-md-auto col-xl-12 col-xxl-auto"> -->
<!--                         <div class="mb-1 mb-md-0 d-flex align-items-center lh-1"><label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer">Designing the dungeon</label></div> -->
<!--                       </div> -->
<!--                     </div> -->
<!--                   </div> -->

				<!-- 팝업 -->
                  <div class="modal fade" id="exampleModal" tabindex="-1" style="display: none;" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                      <div class="modal-content bg-body overflow-hidden">
                        <div class="modal-header justify-content-between px-6 py-5 pe-sm-5 px-md-6 dark__bg-gray-1100">
                          <h3 class="text-body-highlight fw-bolder mb-0" id="title">Designing the Dungeon Blueprint</h3>
                          <button style="min-width:50px!important; min-height:50px!important;" class="btn btn-phoenix-secondary btn-icon btn-icon-xl flex-shrink-0" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg=""><path fill="currentColor" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"></path></svg></button>
                        </div>
                        <div class="modal-body bg-body-highlight px-6 py-0">
                          <div class="row gx-14">
                            <div class="col-12 border-end-lg">
                              <div class="py-6">
                                <div class="mb-7">
<!--                                   <div class="d-flex align-items-center mb-3"> -->
<!--                                     <h4 class="text-body me-3">Description</h4> -->
<!--                                   </div> -->
                                  <p class="text-body-highlight mb-0" id="longtxt">The female circus horse-rider is a recurring subject in Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus. They visited Paris’s historic Cirque d’Hiver Bouglione together; Vollard lent Chagall his private box seats. Chagall completed 19 gouaches Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus.</p>
                                </div>
<!--                                 <div class="mb-3"> -->
<!--                                   <div> -->
<!--                                     <h4 class="mb-3">Files</h4> -->
<!--                                   </div> -->
<!--                                 </div> -->
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>



              </div>
            </div>
            </div>





				<!-- 1:1문의 -->
                <div class="col-12 col-md-6">
                  <div class="card h-100">
                    <div class="card-body">





			<div class="d-flex flex-column search_box ty2">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-4">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">1:1문의</h3>
                      <p class="mb-2 mb-md-0 mb-lg-2 text-body-tertiary" id="noInq"></p>
                    </div>
                    <div class="col-auto w-100 w-md-auto">
                      <div class="row align-items-center g-0 justify-content-between">
                        <div class="col-12 col-sm-auto">
                          <div class="search-box w-100 mb-2 mb-sm-0" style="max-width:30rem;">
                          </div>
                        </div>
                        <div class="col-auto d-flex">
                          <p class="mb-0 ms-sm-3 fs-9 text-body-tertiary fw-bold">
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-body py-0 scrollbar to-do-list-body" id="inqList">

<!--                   <div class="d-flex hover-actions-trigger py-3 border-translucent border-top"> -->
<!--                     <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal0"> -->
<!--                       <div class="col-12 col-md-auto col-xl-12 col-xxl-auto"> -->
<!--                         <div class="mb-1 mb-md-0 d-flex align-items-center lh-1"><label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer">Designing the dungeon</label></div> -->
<!--                       </div> -->
<!--                     </div> -->
<!--                   </div> -->

				<!-- 팝업 -->
                  <div class="modal fade" id="exampleModal0" tabindex="-1" style="display: none;" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                      <div class="modal-content bg-body overflow-hidden">
                        <div class="modal-header justify-content-between px-6 py-5 pe-sm-5 px-md-6 dark__bg-gray-1100">
                          <h3 class="text-body-highlight fw-bolder mb-0" id="title0">Designing the Dungeon Blueprint</h3>
                          <button style="min-width:50px!important; min-height:50px!important;" class="btn btn-phoenix-secondary btn-icon btn-icon-xl flex-shrink-0" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg=""><path fill="currentColor" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"></path></svg></button>
                        </div>
                        <div class="modal-body bg-body-highlight px-6 py-0">
                          <div class="row gx-14">
                            <div class="col-12 border-end-lg">
                              <div class="py-6">
                                <div class="mb-7">
                                  <p class="text-body-highlight mb-0" id="longtxt0">The female circus horse-rider is a recurring subject in Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus. They visited Paris’s historic Cirque d’Hiver Bouglione together; Vollard lent Chagall his private box seats. Chagall completed 19 gouaches Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus.</p>
                                </div>

								<div id="inq반복부">
									<div repeatObj="true" style="display:none;">
		                                <div class="mb-3">
		                                  <div>
		                                    <h4 class="mb-3" name='title'>Files</h4>
		                                  </div>
		                                </div>
		                                <div class="mb-3">
		                                  <div>
		                                    <p class="text-body-highlight mb-0" name='longtxt'>Files</p>
		                                  </div>
		                                </div>
		                        	</div>
								</div>

                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>



              </div>
            </div>
            </div>


	</div>


  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>



  <!-- Vendor JS Files -->
  <script src="<c:url value='/vendor/admin/aos/aos.js' />"></script>
  <script src="<c:url value='/vendor/admin/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/vendor/admin/glightbox/js/glightbox.min.js' />"></script>

  <!-- Main JS File -->
  <script src="<c:url value='/js/admin/main.js' />"></script>
</body>
</html>