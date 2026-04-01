<template>
    <!-- 页脚组件 -->
    <el-footer class="footer">
        <div class="footer-container">
            <!-- 酒店信息区域 -->
            <div class="footer-section">
                <h3>关于我们</h3>
                <p>我们致力于为您提供舒适、便捷的住宿体验</p>
                <p>酒店地址：中国某省某市某区某街123号</p>
            </div>

            <!-- 联系方式区域 -->
            <div class="footer-section">
                <h3>联系我们</h3>
                <p><i class="el-icon-phone"></i> 电话：400-123-4567</p>
                <p><i class="el-icon-message"></i> 邮箱：contact@hotel.com</p>
            </div>

            <!-- 快速链接区域 -->
            <div class="footer-section">
                <h3>快速链接</h3>
                <ul class="quick-links">
                    <li><router-link to="/">首页</router-link></li>
                    <li><router-link to="/about">关于我们</router-link></li>
                    <li><router-link to="/rooms">客房预订</router-link></li>
                    <li><router-link to="/service">酒店服务</router-link></li>
                </ul>
            </div>

            <!-- 社交媒体区域 -->
            <div class="footer-section">
                <h3>关注我们</h3>
                <div class="social-icons">
                    <a href="#" class="social-icon"><i class="el-icon-s-platform"></i></a>
                    <a href="#" class="social-icon"><i class="el-icon-s-marketing"></i></a>
                    <a href="#" class="social-icon"><i class="el-icon-s-promotion"></i></a>
                    <a href="#" class="social-icon"><i class="el-icon-s-cooperation"></i></a>
                </div>
            </div>
        </div>

        <!-- 版权信息 -->
        <div class="copyright">
            <p>版权归字母哥基础框架系统SpringBoot4+Vue3系统所有 © {{ currentYear }}</p>
        </div>
    </el-footer>
</template>
  
<script setup>
// 使用setup语法糖，无需手动返回
import { ref, onMounted } from 'vue';

// 获取当前年份
const currentYear = ref(new Date().getFullYear());
</script>
  
<style scoped lang="scss">
/* 页脚容器样式 */
.footer {
    background-color: #222222;
    padding: 20px 0;
    color: white;
    min-height: 320px;
}

/* 页脚内容容器样式 */
.footer-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

/* 页脚区块样式 */
.footer-section {
    flex: 1;
    min-width: 200px;
    margin: 10px;

    h3 {
        font-size: 18px;
        margin-bottom: 15px;
        position: relative;
        padding-bottom: 10px;

        &:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 40px;
            height: 2px;
            background-color: #e2c285;
            /* 金色装饰线 */
        }
    }

    p {
        margin: 8px 0;
        font-size: 14px;
        color: #cccccc;
    }
}

/* 快速链接样式 */
.quick-links {
    list-style: none;
    padding: 0;

    li {
        margin: 8px 0;

        a {
            color: #cccccc;
            text-decoration: none;
            transition: color 0.3s;

            &:hover {
                color: #e2c285;
                /* 金色悬停效果 */
            }
        }
    }
}

/* 社交图标样式 */
.social-icons {
    display: flex;
    gap: 15px;

    .social-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        background-color: #333333;
        border-radius: 50%;
        color: white;
        text-decoration: none;
        transition: all 0.3s;

        &:hover {
            background-color: #e2c285;
            /* 金色悬停效果 */
            transform: translateY(-3px);
        }

        i {
            font-size: 18px;
        }
    }
}

/* 版权信息样式 */
.copyright {
    text-align: center;
    padding-top: 20px;
    margin-top: 20px;
    border-top: 1px solid #333333;

    p {
        margin: 0;
        font-size: 14px;
        color: #999999;
    }
}
</style>
