<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>도서검색 목록 페이지 입니다.</title>
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/css/ui.jqgrid.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/i18n/grid.locale-kr.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.jqGrid.min.js"></script>
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
        });

        function aladinCallBack(success, data) {
            if (data.item.length > 0) {
                makeTable('dataGrid', data.item);
            } else {
                alert("검색 결과가 없습니다.");
            }
        }

        function makeTable(id, array){
            $("#dataGrid").jqGrid("GridUnload");
            $("#"+id).jqGrid({
                data: array,
                datatype: "local",
                height: 250,
                width : 1000,
                colNames:['제목','저자', '비고'],
                colModel:[
                    {name:'title', align:'left', width: 200},
                    {name:'author', align:'left', width: 100},
                    {name:'description', align:'left', width: 300}
                ],
                caption: "도서 검색",
                rowNum: 10,
                rowList: [5, 10, 15],
                pager: '#GridPager'
            });
        }

        function search() {
            //$("#dataGrid").jqGrid("GridUnload");
            var seletedQueryType = $("#QueryType option:selected").val();
            var keyword = $("#inKeyword").val();


            $.ajax({
                method: "get",
                dataType: "jsonp",
                url:"http://www.aladin.co.kr/ttb/api/ItemSearch.aspx",
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

    </script>
</head>
<body>

<p style="width:50%;font-size:25px;text-align:center">알라딘 도서 검색 화면</p>
<fieldset style="width:973px">
    <legend>검색 조건</legend>
    <label>구분 : </label>
    <select id="QueryType">
        <option value="Keyword" selected>제목+저자</option>
        <option value="Title">제목검색</option>
        <option value="Author">저자검색</option>
        <option value="Publisher">출판사검색</option>
    </select>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <label>검색어 : </label>
    <input type="text" id="inKeyword"/>
    <button id="searchBtn">검색</button>
</fieldset>
<br>
<br>
<table id="dataGrid"></table>
<div id="GridPager"></div>
</body>
</html>