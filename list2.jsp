<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8f">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>도서 검색 목록 페이지 입니다.</title>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" type="text/css" media="screen" href="./css/ui.jqgrid.css"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<style type="text/css">	
	.ui-jqgrid tr.jqgrow td {
	  white-space: normal;
	  word-break: break-all;
	}
</style>
<script type="text/javascript" src="./js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="./js/jquery.jqGrid.min.js"></script>
<script type="text/javascript" src="./js/i18n/grid.locale-kr.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#inKeyword").keyup(function(e) {
		if (e.keyCode == 13) {
			search();
		}
	});
	
	$("#searchBtn").on("click",function(){
        search();
    });

    $("#inKeyword").focus();
});

function aladinCallBack(success, data) {
	if (data.item.length > 0) {
		//console.log("data = " + JSON.stringify(data));
		makeTable('dataGrid', data.item);
	} else {
		alert("검색 결과가 없습니다.");
	}
}

function makeTable(id, array){
    $("#"+id).jqGrid({
    	data: array,
        datatype: "local",
        height: 500, 
        width : 1300,
        colNames:['이미지', '제목','저자', '출판사', '비고'],
        colModel:[
			{name:'Img', align:'center', width: 200, formatter: imageFormatter},
            {name:'title', align:'left', width: 300},
            {name:'author', align:'center', width: 100},
            {name:'publisher', align:'center', width: 100},
            {name:'description', align:'left', width: 400}  
        ],
        caption: "도서 검색",
        rowNum: 5,
        rowList: [5, 10, 15],
        pager: '#GridPager'
     });
}

function imageFormatter(cellvalue, options, rowObject)
{
	//console.log("rowObject = " + rowObject.cover);
    return '<img src="' + rowObject.cover + '" width="200" />';
}

function search() {
	$("#dataGrid").jqGrid("GridUnload");
	var seletedQueryType = $("#QueryType option:selected").val();
	var keyword = $("#inKeyword").val();
	
	$.ajax({
		method: "get",
		dataType: "jsonp",
		url:"https://www.aladin.co.kr/ttb/api/ItemSearch.aspx",
		data: {
			Query: keyword,
			TTBKey: "ttbminico821428001",
			QueryType: seletedQueryType,
			output: "JS",
			cover: "big",
			MaxResults: 100,
			callback: "aladinCallBack"
		}
	});
}

function init() {
	var keyword = "인플레이션";

    $.ajax({
        method: "get",
        dataType: "jsonp",
        url:"https://www.aladin.co.kr/ttb/api/ItemSearch.aspx",
        data: {
            Query: keyword,
            TTBKey: "ttbminico821428001",
            QueryType: "Title",
            output: "JS",
            cover: "big",
            MaxResults: 2,
            callback: "aladinCallBack"
        }
    });
}

</script>
</head>
<body onload="init();">
<!-- Header start -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container">
			<!-- <span class="navbar-brand" style="font-size:40px">MIRACOM</span> -->
			<span class="navbar-brand">
				<img src="https://www.miracom.co.kr/static_root/images/common/logo.png" alt="미라콤 로고" title="미라콤 로고" />
			</span>
			<button class="navbar-toggler navbar-toggler-right" type="button"
				data-toggle="collapse" data-target="#navbarResponsive"
				aria-controls="navbarResponsive" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item">
						<a class="nav-link" href="#">HOME</a>
					</li>
					<li class="nav-item">
						<a class="nav-link active" aria-current="page" href="#">도서검색</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="#">도서관소개</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="#">이용자마당</a>
					</li>
				</ul>
			</div>
		</div>
	</nav>
<!-- Header end -->	

<!-- Body start -->
	<br>
	<div class="container">
    	<div class="row g-3">
		  <div class="col">
		  	<div class="input-group mb-4">
		    	<label class="input-group-text" for="inputGroupSelect01">구분</label>
			    <select class="form-select" id="QueryType">
			        <option value="Keyword" selected>제목+저자</option>
			        <option value="Title">제목검색</option>
			        <option value="Author">저자검색</option>
			        <option value="Publisher">출판사검색</option>
			    </select>
			</div>
		  </div>
		  <div class="col">
		    <div class="input-group mb-4">    
			    <span class="input-group-text" id="basic-addon1">검색어</span>
	     			<input class="form-control me-2" type="text" placeholder="Search" id="inKeyword">
	     			<button class="btn btn-outline-success" id="searchBtn">Search</button>
	   		</div>
		  </div>
		</div>
	</div>	
	<div class="container">	
		<table id="dataGrid"></table>
		
		<div id="GridPager"></div>
	</div>	
	<br>
<!-- Body end -->

<!-- Footer start -->
<footer class="py-2 bg-dark">
	<div class="container">
		<p class="m-0 text-center text-white">Copyright &copy; 2022 Miracom 부제서, All rights reserved.</p>
	</div>
</footer>
<!-- Footer end -->
</body>
</html>
