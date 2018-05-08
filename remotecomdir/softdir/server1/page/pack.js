var MyData;
var opt_str = '';
var cols1 = [
    {title:'文件路径', name:'filepath', align: 'center'},
    { title:'操作',name:'filepath',align:'center',width:200,renderer:function(val,item,rowIndex){
        var filepath = item.filepath;

        opt_str = '<a href="#" onclick="delFile('+rowIndex+')">排除</a>';
        return opt_str;
    }}
];
var cols2 = [
    {title:'文件路径', name:'filepath', align: 'center'},
    { title:'操作',name:'filepath',align:'center',width:200,renderer:function(val,item,rowIndex){
        var filepath = item.filepath;

        opt_str = '<a href="#" onclick="recoveryFile('+rowIndex+')">恢复</a>';
        return opt_str;
    }}
];
var grid1;
var grid2;

$(function(){
    $('#b_reset').click(function(){
        location.reload();
    });
    $('#b_getfiles').click(function(){
        getUpdatefiles();
    });
    $('#b_pack').click(function(){
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
                if(data=='success'){
                    layer.alert("打包成功");
                }else{
                    layer.alert("打包失败");
                }
            },
            error:function(){
                layer.alert("打包异常");
            }
        });
    });

    grid1 = $('#datagrid1').mmGrid({
        cols: cols1,
        items:[],
        checkCol:true,
        showBackboard:false,
        fullWidthRows:true,
        checkCol:false,
        height:'auto',
        noDataText:'没有数据。',
        indexCol:true
    });

    grid2 = $('#datagrid2').mmGrid({
        cols: cols2,
        items:[],
        checkCol:true,
        showBackboard:false,
        fullWidthRows:true,
        checkCol:false,
        height:'auto',
        noDataText:'没有数据。',
        indexCol:true
    });
});

function delFile(idx){
    var row = grid1.mmGrid("row",idx);


    grid2.mmGrid("addRow",row);
    grid1.mmGrid("removeRow",idx);
    var rows = grid1.mmGrid("rows");

    grid1.mmGrid("load",rows);


}

function recoveryFile(idx){
    var row = grid2.mmGrid("row",idx);
    grid1.mmGrid("addRow",row);
    grid2.mmGrid("removeRow",idx);
    var rows = grid2.mmGrid("rows");

    grid2.mmGrid("load",rows);

}

function getUpdatefiles(){
    var protype = $("#protype").val();
    var propath = $("#propath").val();
    var packtime = $("#packtime").val();

    $.ajax({
        async:false,
        url:'packController/getUpdatefiles.do',
        data:$("#mFrom").serialize(),
        dataType:'json',
        success:function(data){
            updateFiles = data;
            var items = [];
            for(var i=0;i<data.length;i++){
                var d = {};
                d.filepath=data[i];
                items.push(d);
            }
            grid1.mmGrid("load",items);
            layer.alert("获取更新文件成功");
        },
        error:function(){
            layer.alert("获取更新文件失败");
        }
    });
}


function chgProType(obj){
    var proType = $(obj).val();
    if(proType=='2'){
        $("#srcPath").val("\\src\\main\\java");
        $("#resourcesPath").val("\\src\\main\\resources");
        $("#wrPath").val("\\WebRoot");
        $("#compilePath").val("\\WebRoot\\WEB-INF\\classes");
    }else if(proType=='1'){
        $("#srcPath").val("\\src\\main\\java");
        $("#resourcesPath").val("\\src\\main\\resources");
        $("#wrPath").val("\\src\\main\\webapp");
        $("#compilePath").val("\\target\\classes");
    }
}

