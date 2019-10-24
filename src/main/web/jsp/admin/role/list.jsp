<%--
  Created by IntelliJ IDEA.
  User: JQH
  Date: 2019/10/9
  Time: 16:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <title>角色列表</title>
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <style>
        body{
            padding: 0px;
            margin:0px ;
        }
        .avatar-uploader .el-upload {
            border: 1px dashed #d9d9d9;
            border-radius: 6px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .avatar-uploader .el-upload:hover {
            border-color: #409EFF;
        }
        .avatar-uploader-icon {
            font-size: 28px;
            color: #8c939d;
            width: 130px;
            height: 130px;
            line-height: 130px;
            text-align: center;
        }
        .avatar {
            width: 130px;
            height: 130px;
            display: block;
        }
    </style>
</head>
<body>
    <div id="app">


        <%--添加 或 更新 表单--%>
        <el-dialog title="添加/修改信息" :visible.sync="dialogFormVisible" width="430px">
            <div class="grid-content bg-purple">
                <el-form :model="role" :rules="rules" ref="ruleForm" label-width="100px" class="demo-ruleForm">
                    <el-form-item label="角色名称" prop="roleName">
                        <el-input v-model="role.roleName"></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <div slot="footer" class="dialog-footer">
                <el-button @click="dialogFormVisible = false">取 消</el-button>
                <el-button type="primary" @click="submitForm('ruleForm')">确 定</el-button>
            </div>
        </el-dialog>

            <el-dialog title="授权" :visible.sync="dialogPowerVisible" width="430px">
                <el-tree :data="data" ref="tree" :props="defaultProps"

                         @check="changepower"
                         :check-on-click-node="false"
                         :highlight-current="true"
                         :default-expand-all="true"
                         show-checkbox
                         node-key="menuId"
                         :default-checked-keys="ckarray"

                >

                </el-tree>

            </el-dialog>


            <el-row :gutter="20" style="margin-bottom: 10px;">
                <el-col :span="5">
                    <el-button-group>
                        <el-button type="primary" icon="el-icon-plus" @click="dialogFormVisible = true"></el-button>
                        <el-button type="primary" icon="el-icon-edit"></el-button>

                    </el-button-group>
                </el-col>


            </el-row>
        <template>
            <el-table
                    :data="list"
                    ref="tb1"
                    border
                    style="width: 100%"
            >
                <el-table-column
                        type="selection"
                        width="55">
                </el-table-column>
                <el-table-column
                        fixed
                        prop="roleId"
                        <%--排序--%>
                        label="ID"
                        width="60">
                </el-table-column>
                <el-table-column
                        prop="roleName"
                        label="角色名称"
                        width="100">
                </el-table-column>
                <el-table-column
                        prop="roleCreatetime"
                        label="创建时间"
                        width="200">
                </el-table-column>
                <el-table-column
                        prop="roleLastmodify"
                        label="最后修改时间"
                        width="200">
                </el-table-column>
                <el-table-column
                        fixed="right"
                        label="操作"
                       >

                    <template slot-scope="scope">
                        <el-button @click="power(scope.row.roleId)" type="text" size="small">授权</el-button>
                        <el-button @click="handleClick(scope.row)" type="text" size="small">编辑</el-button>
                        <el-button @click="deletex(scope.row.roleId)" type="text" size="small">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </template>
    </div>


<!-- import Vue before Element -->
<script src="<%=basePath%>static/element/js/vue.js"></script>
<!-- import JavaScript -->
<script src="<%=basePath%>static/element/js/elementui.js"></script>
<script src="<%=basePath%>static/element/js/axios.js"></script>
<script src="<%=basePath%>static/element/js/qs.js"></script>



    <script>
        new  Vue({
            el:'#app',
            data:function () {
                return{
                    //默认选中
                    ckarray:[],
                    list:[],
                    data:[],
                    dialogFormVisible : false,
                    role:{},
                    formLabelWidth:'75px',
                    rules: {
                        roleName: [
                            {required: true, message: '请输入角色名称', trigger: 'blur'},
                            {min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur'}
                        ],
                    },
                    dialogPowerVisible:false,
                    defaultProps: {
                        children: 'list',
                        label: 'menuTitle'
                    },
                    currentid:0

                }
            },
            created:function () {
                this.getdata();
            },
            methods:{
                changepower(){
                    this.savepower();
                },
                savepower(){
                    //当前树选中的节点3
                    var nodes=this.$refs.tree.getCheckedNodes(false,false);
                    var ids=[]
                    for(var i=0;i<nodes.length;i++){
                        ids.push(nodes[i].menuId)
                    }
                    var data={
                        roleid:this.currentid,
                        menuids:ids.join(",")
                    }
                    var self=this;
                    axios.get("<%=basePath%>admin/role/power",{params:data})
                        .then(function (response) {
                            if(response.data.code==10000){
                                self.$message({
                                    type: 'success',
                                    message: '保存成功!'
                                });
                            }else{
                                self.$message({
                                    type: 'error',
                                    message: '保存失败!'
                                });
                            }
                        })
                        .catch(function (error) {
                            console.log(error);
                            self.$message({
                                type: 'error',
                                message: '网络异常!'
                            });
                        });
                },
                power(id){
                    this.currentid=id
                    this.inittree();
                    var self=this
                    axios.get("<%=basePath%>admin/role/powerlist",{
                        params:{
                            roleid:id
                        }
                    }) .then(function (response) {
                        self.ckarray=[]
                            if(response.data.code==10000){
                                console.log("powerlist"+response)
                                var list=response.data.obj
                                console.log(list)
                                for(var i=0;i<list.length;i++){
                                    self.ckarray.push(list[i].rmrfMenuid);
                                }
                                console.log(self.ckarray)
                                self.inittree()
                                self.dialogPowerVisible=true;

                            }else{
                                self.$message({
                                    type: 'error',
                                    message: '权限加载失败!'
                                });
                            }
                        })
                        .catch(function (error) {
                            console.log(error);
                            self.$message({
                                type: 'error',
                                message: '网络异常!'
                            });
                        });
                },
                handleNodeClick(data,node,dom) {
                    // console.log(data);
                    // console.log(node);
                    this.savepower();


                },
                inittree(){
                    var self=this;
                    axios.get("<%=basePath%>admin/menu/list")
                        .then(function (response) {
                            if(response.data.code==10000){

                                self.data=response.data.obj
                                // console.log("tree data"+response.data.obj)
                            }else{
                                self.$message({
                                    type: 'error',
                                    message: '菜单加载失败!'
                                });
                            }
                        })
                        .catch(function (error) {
                            console.log(error);
                            self.$message({
                                type: 'error',
                                message: '网络异常!'
                            });
                        });
                },
                submitForm(formName) {
                    this.$refs[formName].validate((valid) => {
                        if (valid) {
                            this.save();
                        } else {
                            console.log('error submit!!');
                            return false;
                        }
                    });
                },
                resetForm(formName) {
                    this.$refs[formName].resetFields();
                },
                save(){
                    var self=this;
                    axios.post('<%=basePath%>admin/role/saveOrupdate',Qs.stringify(self.role))
                        .then(function(res){
                            if(res.data.code=='10000'){
                                self.$message({
                                    type: 'success',
                                    message: '保存成功!'
                                });
                                //隐藏
                                self.dialogFormVisible = false;
                                //重新加载数据
                                self.getdata();
                            }else{
                                self.$message({
                                    type: 'error',
                                    message: '保存失败!'
                                });
                            }

                        }).catch(()=>{
                        self.$message({
                            type: 'error',
                            message: '网络异常!'
                        });

                    })


                },

                deletex(id){
                    var self=this;
                    this.$confirm('此操作将永久删除该行数据, 是否继续?', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                        }).then(() => {

                            var data={
                                id:id
                            }
                            axios.get("<%=basePath%>admin/role/delete",{params:data})
                                .then(function (response) {
                                    if(response.data.code==10000){
                                        self.$message({
                                            type: 'success',
                                            message: '删除成功!'
                                        });
                                        self.getdata();
                                    }else{
                                        self.$message({
                                            type: 'error',
                                            message: '删除失败!'
                                        });
                                    }
                                    })
                                    .catch(function (error) {
                                    console.log(error);
                                    self.$message({
                                        type: 'error',
                                        message: '网络异常!'
                                    });
                                });
                        }).catch(() => {
                            self.$message({
                                type: 'info',
                                message: '已取消删除'
                            });
                        });

                     },

                getdata:function () {
                    var self=this;
                    axios.get("<%=basePath%>admin/role/list")
                        .then(function (response) {
                            if(response.data.code==10000){
                                console.log(response)
                                self.list=response.data.obj

                            }

                        })
                        .catch(function (error) {
                            console.log(error);
                        });
                }
            }
        });
    </script>


</body>
</html>
