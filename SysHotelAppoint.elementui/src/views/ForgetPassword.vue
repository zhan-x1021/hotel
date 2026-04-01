<template>
    <div class="login-container">
        <!-- 左侧区域：背景图片和文案 -->
        <div class="login-left">
            <div class="left-content">
                <h1 class="system-name">酒店预约管理系统</h1>
                <p class="system-desc">Hotel Appointment Management System</p>
                <p class="system-slogan">便捷找回，安全可靠</p>
            </div>
        </div>

        <!-- 右侧区域：找回密码表单 -->
        <div class="login-right">
            <div class="login-form-container">
                <h2 class="login-title">找回密码</h2>
                <p class="login-subtitle">请填写您的账号信息进行密码找回</p>

                <el-form ref="loginFormRef" :model="formData" label-width="70px" label-position="top" :rules="rules"
                    class="login-form">
                    <!-- 账号输入框 -->
                    <el-form-item label="账号" prop="UserName">
                        <el-input v-model="formData.UserName" placeholder="请输入账号" :prefix-icon="User" />
                    </el-form-item>

                    <!-- 邮箱输入框 -->
                    <el-form-item label="邮箱" prop="Email">
                        <el-input v-model="formData.Email" placeholder="请输入邮箱" :prefix-icon="Message" />
                    </el-form-item>

                    <!-- 联系方式输入框 -->
                    <el-form-item label="联系方式" prop="PhoneNumber">
                        <el-input v-model="formData.PhoneNumber" placeholder="请输入联系方式" :prefix-icon="Phone" />
                    </el-form-item>

                    <!-- 新密码输入框 -->
                    <el-form-item label="新密码" prop="Password">
                        <el-input type="password" v-model="formData.Password" show-password placeholder="请输入新密码"
                            :prefix-icon="Lock" />
                    </el-form-item>

                    <!-- 验证码 -->
                    <el-form-item label="验证码" prop="Code">
                        <div class="code-container">
                            <el-input v-model="formData.Code" placeholder="请输入验证码" />
                            <div class="code-image">
                                <ValidCode ref="validCodeRef" />
                            </div>
                        </div>
                    </el-form-item>

                    <!-- 提交按钮 -->
                    <el-form-item>
                        <el-button type="primary" class="login-button" @click="handleForgetPassword">
                            确定提交
                        </el-button>
                    </el-form-item>
                </el-form>

                <!-- 其他选项 -->
                <div class="login-options">
                    <div class="register-link">
                        <span>如果有账号</span>
                        <RouterLink to="/Login">
                            <span class="link-text">立即登录</span>
                        </RouterLink>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Post } from '@/api/http';
import ValidCode from '@/components/Identifyingcode/ImageCode.vue';
import { User, Lock, Message, Phone } from '@element-plus/icons-vue';
import { ElMessage } from 'element-plus';
import { reactive, ref } from 'vue';
import { useRouter } from 'vue-router';

// 路由实例
const router = useRouter()

// 表单引用
const loginFormRef = ref(null)
const validCodeRef = ref(null)

// 表单数据
const formData = reactive({
    UserName: '',
    Password: '',
    Email: '',
    PhoneNumber: '',
    Code: ''
})

// 表单验证规则
const rules = {
    UserName: [
        { required: true, message: '请输入账号', trigger: 'blur' },
        { min: 3, max: 20, message: '账号长度应在3到20个字符之间', trigger: 'blur' }
    ],
    Password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { min: 6, message: '密码长度不能少于6个字符', trigger: 'blur' },
        {
            validator: (rule, value, callback) => {
                const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/
                if (!passwordRegex.test(value)) {
                    callback(new Error('密码必须包含大小写字母和数字'))
                } else {
                    callback()
                }
            },
            trigger: 'blur'
        }
    ],
    Email: [
        { required: true, message: '该项为必填项', trigger: 'blur' },
        {
            validator: (rule, value, callback) => {
                const reg = /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/
                if (!value || !reg.test(value)) {
                    callback(new Error('请输入正确邮箱'))
                } else {
                    callback()
                }
            },
            trigger: 'blur'
        }
    ],
    PhoneNumber: [
        { required: true, message: '该项为必填项', trigger: 'blur' },
        {
            validator: (rule, value, callback) => {
                const reg = /^1[123456789]\d{9}$/
                if (!value || !reg.test(value)) {
                    callback(new Error('请输入正确的手机号'))
                } else {
                    callback()
                }
            },
            trigger: 'blur'
        }
    ],
    Code: [
        { required: true, message: '请输入验证码', trigger: 'blur' },
        {
            validator: (rule, value, callback) => {
                const identifyCode = validCodeRef.value.getCode()
                if (value !== identifyCode) {
                    callback(new Error('请输入正确的验证码'))
                } else {
                    callback()
                }
            },
            trigger: 'blur'
        }
    ]
}

// 处理找回密码
const handleForgetPassword = async () => {
    if (!loginFormRef.value) return

    await loginFormRef.value.validate(async (valid) => {
        if (valid) {
            try {
                const res = await Post('/User/ForgetPassword', formData)
                if (res.Success) {
                    ElMessage.success('修改密码成功!')
                    router.push('/Login')
                } else {
                    validCodeRef.value.refreshCode()
                }
            } catch (error) {
                console.error(error)
                validCodeRef.value.refreshCode()
            }
        } else {
            ElMessage.error('验证不通过')
            validCodeRef.value.refreshCode()
        }
    })
}
</script>

<style scoped lang="scss">
/* 登录页面容器 */
.login-container {
    display: flex;
    width: 100%;
    height: 100vh;
    overflow: hidden;
}

/* 左侧区域 */
.login-left {
    width: 55%;
    height: 100%;
    position: relative;
    background: url('@/assets/loginbg.png') center center no-repeat;
    background-size: cover;
    display: flex;
    align-items: center;
    justify-content: center;

    &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(135deg, rgba(0, 0, 0, 0.6) 0%, rgba(0, 0, 0, 0.3) 100%);
    }
}

/* 左侧内容 */
.left-content {
    position: relative;
    z-index: 2;
    text-align: center;
    color: #fff;
    max-width: 80%;
    padding: 20px;
}

.system-name {
    font-size: 3.5rem;
    font-weight: 700;
    margin-bottom: 1rem;
    text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
    letter-spacing: 2px;
}

.system-desc {
    font-size: 1.5rem;
    font-weight: 300;
    margin-bottom: 2rem;
    letter-spacing: 3px;
    text-transform: uppercase;
    opacity: 0.9;
}

.system-slogan {
    font-size: 1.8rem;
    font-weight: 500;
    padding: 15px 30px;
    border-top: 1px solid rgba(255, 255, 255, 0.3);
    border-bottom: 1px solid rgba(255, 255, 255, 0.3);
    display: inline-block;
    margin-top: 30px;
}

/* 右侧表单区域 */
.login-right {
    width: 45%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f5f7fa;
    padding: 20px;
}

.login-form-container {
    width: 100%;
    max-width: 450px;
    padding: 40px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
}

/* 登录标题 */
.login-title {
    font-size: 28px;
    color: #303133;
    text-align: center;
    font-weight: 600;
    margin-bottom: 10px;
}

/* 登录副标题 */
.login-subtitle {
    font-size: 16px;
    color: #909399;
    text-align: center;
    margin-bottom: 30px;
}

/* 登录表单 */
.login-form {
    margin-top: 20px;

    :deep(.el-form-item) {
        margin-bottom: 22px;
    }

    :deep(.el-form-item__label) {
        padding-bottom: 8px;
        font-weight: 500;
        color: #606266;
    }

    :deep(.el-input__inner) {
        border-radius: 6px;
        height: 42px;
    }
}

/* 验证码容器 */
.code-container {
    display: flex;
    align-items: center;
    gap: 10px;
}

.code-image {
    flex-shrink: 0;
    border-radius: 4px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

/* 登录按钮 */
.login-button {
    width: 100%;
    height: 45px;
    font-size: 16px;
    font-weight: 500;
    letter-spacing: 2px;
    margin-top: 10px;
    border-radius: 6px;
    transition: all 0.3s;

    &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
    }
}

/* 登录选项区域 */
.login-options {
    display: flex;
    justify-content: center;
    margin-top: 25px;
    font-size: 14px;
    color: #606266;
}

/* 链接文本 */
.link-text {
    color: #409EFF;
    margin-left: 5px;
    cursor: pointer;
    transition: all 0.3s;

    &:hover {
        color: #66b1ff;
        text-decoration: underline;
    }
}

/* 响应式调整 */
@media (max-width: 992px) {
    .login-container {
        flex-direction: column;
    }

    .login-left,
    .login-right {
        width: 100%;
    }

    .login-left {
        height: 250px;
    }

    .system-name {
        font-size: 2.5rem;
    }

    .system-desc {
        font-size: 1.2rem;
        margin-bottom: 1rem;
    }

    .system-slogan {
        font-size: 1.4rem;
        margin-top: 15px;
        padding: 10px 20px;
    }

    .login-form-container {
        padding: 30px 20px;
    }
}

@media (max-width: 576px) {
    .login-left {
        height: 200px;
    }

    .system-name {
        font-size: 2rem;
    }

    .system-desc {
        font-size: 1rem;
    }

    .system-slogan {
        font-size: 1.2rem;
        padding: 8px 15px;
    }
}
</style>

