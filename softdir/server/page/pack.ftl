<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>增量编译</title>
    <link rel="stylesheet" type="text/css" href="${base}/css/lib/one.min.css" media="all" />
    <link rel="stylesheet" type="text/css" href="${base}/css/custom.css" />
    <link rel="stylesheet" type="text/css" href="${base}/js/plugin/bootstrap-3.3.5-dist/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="${base}/js/plugin/mmgrid/mmGrid.css" />
<#--<link rel="stylesheet" type="text/css" href="${base}/js/plugin/jquery-easyui-1.5/themes/default/easyui.css">-->
<#--<link rel="stylesheet" type="text/css" href="${base}/js/plugin/jquery-easyui-1.5/themes/icon.css">-->

    <script type="text/javascript" src="${base}/js/lib/jquery.min.js"></script>
</head>
<body class="lightgrayBg">
<!--tab切换-->
<div class="tabBox">
    <!-- 表单↓↓↓ -->
    <form class="form-horizontal" id="mFrom" name="mFrom" method="post" action="" role="form">
        <div class="panel panel-default">
            <div class="panel-heading">根据本地java文件增量编译</h4>
                <a href="${base}/page/doc.html" target="_blank" style="margin-left:100px">接口帮助文档</a>

            </div>
            <div class="panel-body">


                <div class="form-group">
                    <label for="" class="col-sm-3 control-label">第三方依赖库目录路径</label>
                    <span class="ui-form-required"> *</span>
                    <div class="col-sm-5">
                        <input  id="otherLib" name="otherLib" type="text" value="C:/Users/Administrator/Desktop/myProject/pack/project/src/cm/lib" class="form-control" placeholder="C:/Users/Administrator/Desktop/myProject/pack/project/src/cm/lib">
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-sm-3 control-label">源码目录路径(注意不要写错路径.这个路径下直接对应的包名)</label>
                    <span class="ui-form-required"> *</span>
                    <div class="col-sm-5">
                        <input  id="sourcePath" name="sourcePath" type="text" value="C:/Users/Administrator/Desktop/myProject/pack/project/src/cm/src/main/java" class="form-control" placeholder="C:/Users/Administrator/Desktop/myProject/pack/project/src/cm/src/main/java">
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-sm-3 control-label">输出代码目录路径</label>
                    <span class="ui-form-required"> *</span>
                    <div class="col-sm-5">
                        <input  id="outPath" name="outPath" type="text" value="C:/Users/Administrator/Desktop/myProject/pack/project/output/cm/WEB-INF/classes" class="form-control">
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-sm-3 control-label">java文件路径(多个以,作为分割)</label>
                    <span class="ui-form-required"> *</span>
                    <div class="col-sm-5">
                        <input  id="javaFiles" name="javaFiles" type="text" value="C:/Users/Administrator/Desktop/myProject/pack/project/src/cm/src/main/java/com/zzb/mobile/service/APPBorderService.java,C:/Users/Administrator/Desktop/myProject/pack/project/src/cm/src/main/java/com/zzb/mobile/service/AppPaymentyzfService.java" class="form-control" >
                    </div>
                </div>

                <div class="form-group">
                    <label for="" class="col-sm-3 control-label">tomcat lib目录路径</label>
                    <span class="ui-form-required"> *</span>
                    <div class="col-sm-5">
                        <input  id="tomcatLib" name="tomcatLib" type="text" value="C:/Users/Administrator/Desktop/Webserver/apache-tomcat-9.0.0.M4/lib" class="form-control" >
                    </div>
                </div>


            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-body" style="text-align:center;">
                <button class="btn btn-success btn-lg" id="addpack" type="button">增量打包</button>
            </div>
        </div>
    </form>
    <!-- 表单↑↑↑ -->
</div>
</body>
</html>
<script type="text/javascript">
    $(function(){
        $('#addpack').click(function(){
            var packList = [];
            var postData = {};
            postData.otherLib = $("#otherLib").val();
            postData.sourcePath = $("#sourcePath").val();
            postData.outPath = $("#outPath").val();
            postData.javaFiles = $("#javaFiles").val();
            postData.tomcatLib = $("#tomcatLib").val();
            $.ajax({
                url:'packController/JavaCompiler.do',
                type:'post',
                data:postData,
                traditional:true,
                success:function(data){
                    console.log(data);
                    layer.alert(data.result.msg);
                },
                error:function(){
                    layer.alert("打包异常");
                }
            });
        });
    });


</script>

<script type="text/javascript" src="${base}/js/plugin/jquery.validate.min.js"></script>
<script type="text/javascript" src="${base}/js/plugin/layer-v1.9.3/layer.js"></script>
<script type="text/javascript" src="${base}/js/plugin/bootstrap-3.3.5-dist/js/bootstrap.min.js"></script>
<#--<script type="text/javascript" src="${base}/js/plugin/jquery-easyui-1.5/jquery.easyui.min.js"></script>-->
<script type="text/javascript" src="${base}/js/plugin/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${base}/js/plugin/mmgrid/mmGrid.js"></script>
<script type="text/javascript" src="${base}/page/pack.js"></script>
