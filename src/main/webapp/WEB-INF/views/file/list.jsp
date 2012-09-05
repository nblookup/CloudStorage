<%--
  User: zhangnan
  Date: 12-8-26
  Time: 下午4:32
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>文件管理</title>
    <%--目录树--%>
    <link rel="stylesheet" href="${ctx}/static/js/filetree/jquery.treeview.css"/>
    <script src="${ctx}/static/js/filetree/jquery.treeview.js" type="text/javascript"></script>
    <script src="${ctx}/static/js/filetree/jquery.treeview.edit.js" type="text/javascript"></script>
    <%--文件上传--%>
    <link rel="stylesheet" href="${ctx}/static/js/fileupload/jquery.fileupload-ui.css"/>
    <%--图片展示--%>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/js/fancyBox/helpers/jquery.fancybox-thumbs.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/js/fancyBox/jquery.fancybox.css">
    <script type="text/javascript" src="${ctx}/static/js/fancyBox/helpers/jquery.fancybox-thumbs.js"></script>
    <script type="text/javascript" src="${ctx}/static/js/fancyBox/jquery.mousewheel-3.0.6.pack.js"></script>
    <script type="text/javascript" src="${ctx}/static/js/fancyBox/jquery.fancybox.js"></script>
</head>
<body>
<div class="page">
    <div class="page-header">
        <h2>
            文件管理
            <small>欢迎进入文件管理</small>
        </h2>
    </div>
    <div class="row">
        <div class="span2 columns">
            <div class="well" id="parent" style="padding: 8px 0;">
                <%--目录树--%>
                <ul id="browser" class="filetree treeview">
                    <c:forEach items="${nodes}" var="node" begin="0" step="1">
                        <li class="closed expandable"><div class="hitarea closed-hitarea expandable-hitarea"></div><span id="${node.id}" class="folder <c:if test="${empty node.nodeList}">leafnode</c:if>">${node.name}</span>
                        <c:if test="${not empty node.nodeList}">
                        <ul class="filetree treeview">
                            <c:forEach items="${node.nodeList}" var="node2" begin="0" step="1">
                                <li class="closed expandable"><div class="hitarea closed-hitarea expandable-hitarea"></div><span id="${node2.id}" class="folder <c:if test="${empty node2.nodeList}">leafnode</c:if>" style="cursor: pointer">${node2.name}</span>
                                    <c:if test="${not empty node2.nodeList}">
                                        <ul class="filetree treeview">
                                            <c:forEach items="${node2.nodeList}" var="node3" begin="0" step="1">
                                                <li class="closed expandable"><div class="hitarea closed-hitarea expandable-hitarea"></div><span id="${node3.id}" class="folder <c:if test="${empty node3.nodeList}">leafnode</c:if>" style="cursor: pointer">${node3.name}</span></li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
                        </c:if>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        <div class="span9 columns">
            <div class="hero-unit">
            <%--文件上传--%>
            <%--<form id="fileupload" action="file/save" method="post" enctype="multipart/form-data" style="height: 40px;">--%>
            <div class="row fileupload-buttonbar">
                <div class="span9">
                    <!-- The fileinput-button span is used to style the file input field as button -->
                        <span class="btn btn-success fileinput-button">
                            <i class="icon-plus icon-white"></i>
                            <span>选择文件...</span>
                            <input type="file" name="files[]" multiple="" id="choosefile"/>
                        </span>
                    <button type="submit" class="btn btn-primary start">
                        <i class="icon-upload icon-white"></i>
                        <span>开始上传</span>
                    </button>
                    <button type="reset" class="btn btn-warning cancel">
                        <i class="icon-ban-circle icon-white"></i>
                        <span>取消上传</span>
                    </button>
                    <button type="button" class="btn btn-danger delete">
                        <i class="icon-trash icon-white"></i>
                        <span>删除</span>
                    </button>
                    <input type="checkbox" class="toggle"/> 全选
                </div>
                <!-- The global progress information -->
                <div id="gp_information" class="span5 fileupload-progress fade" style="display: none">
                    <!-- The global progress bar -->
                    <div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                        <div class="bar" style="width: 0%; "></div>
                    </div>
                    <!-- The extended global progress information -->
                    <div class="progress-extended">&nbsp;</div>
                </div>
            </div>
            <!-- The loading indicator is shown during file processing -->
            <div class="fileupload-loading"></div>
            <!-- The table listing the files available for upload/download -->
            <table role="presentation" class="table table-striped">
                <tbody id="hasfile" class="files" data-toggle="modal-gallery" data-target="#modal-gallery"></tbody>
            </table>
            <%--</form>--%>
                <div class="bs-docs-example hide">
                      <%--//文件信息列表--%>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th><label class="checkbox"><input id="checkedAll" type="checkbox" value=""></label></th>
                            <th>#</th>
                            <th>名称</th>
                            <th>日期</th>
                            <th>类型</th>
                            <th>大小</th>
                            <th>时长</th>
                            <th>修改</th>
                            <th>删除</th>
                            <th>更多操作</th>
                        </tr>
                        </thead>
                        <tbody id="file-list"></tbody>
                        <p class="bs-docs-example">
                            <button type="button" class="btn btn-mini">下载</button>
                        </p>
                    </table>
                </div>
                <%--分页--%>
                <div class="pagination pagination-right">
                    <ul id="pager">
                        <li id="prior"><a>上一页</a></li>
                        <c:choose>
                            <c:when test="${total <= 50}">
                                <c:forEach begin="1" end="${pageCount>1?pageCount:1}" step="1" varStatus="var">
                                    <li><a>${var.index}</a></li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:forEach begin="1" end="5" step="1" varStatus="var">
                                    <li><a>${var.index}</a></li>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        <li id="next"><a>下一页</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function() {
        /*目录树*/
        $("#browser").treeview();
        $(".leafnode").click(function(){
            $(this).addClass("rightlist");
            $(".rightlist").css("color","#f00");
            $(".bs-docs-example").show();
            var nodeId = $(this).attr("id");
            alert(nodeId);
            $.ajax({
                url:"${ctx}/api/file/list/" + nodeId + "?offset=0&limit=5",
                success:function(data){
                    $("#file-list").html("");
                    $.each(data,function(nodeId,item){
                        var row="<tr><th><label class='checkbox'><input type='checkbox' name='subBox' value=''></label></th><td>2</td><td>Jacob</td><td>Thornton</td><td>@fat</td><th>大小</th><th>时长</th><th><a href='#'><i class='icon-tags' title='修改'></i></a></th><th><a href='#'><i class='icon-remove' title='删除'></i></a></th><th><a href='#'><i class='icon-hand-right' title='分享'></i></a> <a href='#'><i class='icon-star' title='重点标记'></i></a> <a href='#'><i class='icon-download-alt' title='下载'></i></a></th></tr>";
                        $("#file-list").append(row);
                    });
                }
            });
        });
         //分页
        var articles = $("#file-list");
        //pager.find("span:first").css('background-color', '#e4e4e4').css('color', '#ff4e00').css('cursor', 'default');
        PageClick = function (pageIndex, total, spanInterval) {
            //索引从1开始
            //将当前页索引转为int类型
            var intPageIndex = parseInt(pageIndex);
            var limit = 5;//每页显示文章数量

            $.ajax({
                url: "${ctx}/api/file/list/"+pageIndex+"?offset=" + (intPageIndex - 1) * limit + "&limit=" + limit,

                timeout:3000,
                success:function (data) {
                    articles.html("");

                    //加载文章
                    $.each(data, function (index, content) {
                        articles.append($("<tr><th><label class='checkbox'><input type='checkbox' name='subBox' value=''></label> </th><td>2</td><td>Jacob</td><td>Thornton</td><td>@fat</td> <th>大小</th><th>时长</th><th><a href='#'><i class='icon-tags' title='修改'></i></a></th><th><a href='#'><i class='icon-remove' title='删除'></i></a></th><th><a href='#'><i class='icon-hand-right' title='分享'></i></a> <a href='#'><i class='icon-star' title='重点标记'></i></a> <a href='#'><i class='icon-download-alt' title='下载'></i></a></th></tr>"));
                    });

                    //将总记录数结果 得到 总页码数
                    var pageS = total;
                    if (pageS % limit == 0) pageS = pageS / limit;
                    else pageS = parseInt(total / limit) + 1;

                    //设置分页的格式  这里可以根据需求完成自己想要的结果
                    var interval = parseInt(spanInterval); //设置间隔
                    var start = Math.max(1, intPageIndex - interval); //设置起始页
                    var end = Math.min(intPageIndex + interval, pageS);//设置末页

                    if (intPageIndex < interval + 1) {
                        end = (2 * interval + 1) > pageS ? pageS : (2 * interval + 1);
                    }

                    if ((intPageIndex + interval) > pageS) {
                        start = (pageS - 2 * interval) < 1 ? 1 : (pageS - 2 * interval);
                    }

                    articles.append($("<div class='pagination pagination-right'><ul id='pagination'></ul></div>"));
                    var pager = $("#pagination");

                    //上一页
                    var prior = $("<li><a>上一页</a></li>").click(function() {
                        if(intPageIndex - 1 >= 0) {
                            intPageIndex = intPageIndex - 1;
                        }
                        PageClick(intPageIndex, total, spanInterval);
                    });
                    pager.append(prior);
                    //生成页码
                    for (var j = start; j < end + 1; j++) {
                        if (j == intPageIndex) {
                            var spanSelectd = $("<li class='active'><a>" + j + "</a></li>");
                            pager.append(spanSelectd);
                        } else {
                            var a = $("<li><a>" + j + "</a></li>").click(function () {
                                PageClick($(this).text(), total, spanInterval);
                            });
                            pager.append(a);
                        } //else
                    } //for

                    //下一页
                    var next = $("<li><a>下一页</a></li>").click(function() {
                        if(intPageIndex + 1 <= end) {
                            intPageIndex = intPageIndex + 1;
                        }
                        PageClick(intPageIndex, total, spanInterval);
                    });
                    pager.append(next);
                }
            });
        };
        /*$("#pager li:eq(1)").addClass("active");
        $(".pagination ul li").click(function() {
            PageClick($(this).text(), ${total}, 5);
        });
        $("#next").click(function() {
            PageClick(2, ${total}, 5);
        });*/
        <!-- 分页结束 -->

        /*checkbox全选与取消*/
        $("#checkedAll").click(function(){
            if($(this).attr("checked")==undefined){
                $("input[name='subBox']").each(function(){
                    $(this).attr("checked",false);
                });
            }
            else{
                $("input[name='subBox']").each(function(){
                    $(this).attr("checked",true);
                });
            }
        });
        /*图片展示控制 */
        $(".fancybox").fancybox();
        /*
         *  Thumbnail helper. Disable animations, hide close button, arrows and slide to next gallery item if clicked
         */
        $(".thumbnail").click(function() {
            $.fancybox.open([
                {
                    href : '${ctx}/static/images/psb.jpg',
                    title : 'My title'
                }, {
                    href : '${ctx}/static/images/psb1.jpg',
                    title : '1st title'
                }, {
                    href : '${ctx}/static/images/psb2.jpg',
                    title : '2nd title'
                }, {
                    href : '${ctx}/static/images/psb3.jpg',
                    title:'3td title'
                }
            ], {
                helpers : {
                    thumbs : {
                        width: 75,
                        height: 50
                    }
                }
            });
        });

        <!-- 文件上传fileupload -->
        $("#choosefile").change(function(){
            $("#gp_information").show();
            var filePath=$("#choosefile").val();
            var pre = filePath.substr(filePath.lastIndexOf('\\')+1);
            var realName =pre.substr(0,10);

            if(node.type==null) {
                var upload="<tr class='template-upload fade in'><td class='preview'><span class='fade' style='width: 6px'></span></td><td class='name'><span id='realName' title='"+pre+"'>" + realName + "</span></td><td class='size'><span id='size'></span></td><td><div class='progress progress-success progress-striped active' role='progressbar' aria-valuemin='0' aria-valuemax='100' aria-valuenow='0'><div class='bar' style='width:0%;'></div></div></td><td class='start'><button class='btn btn-primary'><i class='icon-upload icon-white'></i><span>开始上传</span></button></td><td class='cancel'><button class='btn btn-warning'><i class='icon-ban-circle icon-white'></i><span>取消</span></button></td></tr>";
                $("#hasfile").append(upload);
            }else{
                newAlert("block","请选择正确分类");
            }


        });
    })
</script>
</body>
</html>