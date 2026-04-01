<template>
    <div class="weChat-container">
        <!-- 位置导航 -->
        <div class="location-nav">
            <el-breadcrumb separator-class="el-icon-arrow-right">
                <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
                <el-breadcrumb-item>我的聊天消息</el-breadcrumb-item>
            </el-breadcrumb>
        </div>

        <div class="chat-main">
            <!-- 左侧栏 -->
            <div class="sidebar">
                <div class="user-profile">
                    <img :src="UserInfo.ImageUrls || defaultAvatar" class="avatar" alt="用户头像">
                </div>
                <div class="nav-icons">
                    <div class="nav-icon" :class="{ active: activeTab === 0 }" @click="switchTab(0)">
                        <el-icon>
                            <ChatDotRound />
                        </el-icon>
                    </div>
                </div>
            </div>

            <!-- 联系人列表 -->
            <div class="contact-list">
                <div v-for="(chat, index) in chatList" :key="index" class="contact-item"
                    :class="{ active: selectedChat && selectedChat.OtherUserId === chat.OtherUserId }"
                    @click="selectChat(chat)">
                    <img :src="chat.OtherUserDto.ImageUrls || defaultAvatar" class="contact-avatar" alt="联系人头像">
                    <div class="contact-info">
                        <div class="contact-header">
                            <span class="contact-name">{{ chat.OtherUserDto.Name }}</span>
                            <div class="unread-badge" v-if="chat.WaitReadMsgCount > 0">
                                {{ chat.WaitReadMsgCount }}
                            </div>
                        </div>
                        <div class="contact-preview">{{ chat.LastMessage }}</div>
                    </div>
                </div>
            </div>

            <!-- 聊天窗口 -->
            <div class="chat-window">
                <template v-if="selectedChat">
                    <!-- 聊天头部 -->
                    <div class="chat-header">
                        <span class="chat-title">{{ selectedChat.OtherUserDto.Name }}</span>
                        <span class="chat-status" v-if="isLoading">加载中...</span>
                    </div>

                    <!-- 聊天内容区 -->
                    <div class="chat-content" ref="chatContentRef" @scroll="handleScroll">
                        <!-- 加载更多按钮 -->
                        <div class="load-more-wrapper" v-if="hasMoreMessages && !isLoading">
                            <el-button size="small" @click="loadMoreMessages" type="text">加载更多消息</el-button>
                        </div>

                        <!-- 加载中提示 -->
                        <div class="loading-indicator" v-if="isLoading">
                            <el-icon class="is-loading">
                                <Loading />
                            </el-icon>
                        </div>

                        <template v-for="(message, index) in messageList" :key="index">
                            <div class="message-group">
                                <!-- 显示日期分割线，如果是当天第一条消息或与上一条消息日期不同 -->
                                <div class="date-divider" v-if="shouldShowDateDivider(message, index)">
                                    {{ formatMessageDate(message.SendTime) }}
                                </div>

                                <!-- 对方发送的消息 -->
                                <div v-if="UserId != message.SelfUserId" class="message-item other">
                                    <img :src="message.SelfUserDto.ImageUrls || defaultAvatar" class="message-avatar"
                                        alt="发送者头像">
                                    <div class="message-content">
                                        <div class="message-name">{{ message.SelfUserDto.Name }}</div>
                                        <!-- 消息内容 -->
                                        <div class="message-bubble">
                                            <!-- 文本内容 -->
                                            <div v-if="message.Content && message.Content.trim()" class="message-text">
                                                {{ message.Content }}
                                            </div>

                                            <!-- 媒体内容 -->
                                            <div v-if="message.FilePath" class="message-attachment">
                                                <!-- 图片消息 -->
                                                <template v-if="message.WechatMessageType === 2">
                                                    <img :src="message.FilePath || NoImage" class="message-image"
                                                        @click="previewImage(message.FilePath)" />
                                                </template>
                                                <!-- 视频消息 -->
                                                <template v-else-if="message.WechatMessageType === 4">
                                                    <div>
                                                        <video :src="message.FilePath" class="message-video"
                                                            controls></video>
                                                        <!-- 添加一个用于仅播放视频音频的按钮 -->
                                                        <div class="video-audio-control" @click.stop="playAudio(message)">
                                                            <el-icon class="audio-icon" v-if="!isPlayingAudio[message.Id]">
                                                                <Headset />
                                                            </el-icon>
                                                            <el-icon class="audio-icon playing" v-else>
                                                                <Mute />
                                                            </el-icon>
                                                            <span>仅播放音频</span>
                                                        </div>
                                                    </div>
                                                </template>
                                                <!-- 音频消息 -->
                                                <template v-else-if="message.WechatMessageType === 3">
                                                    <div class="audio-message" @click="playAudio(message)">
                                                        <el-icon class="audio-icon" v-if="!isPlayingAudio[message.Id]">
                                                            <Microphone />
                                                        </el-icon>
                                                        <el-icon class="audio-icon playing" v-else>
                                                            <VideoPlay />
                                                        </el-icon>
                                                        <div class="audio-waveform"></div>
                                                        <audio :src="message.FilePath" :id="`audio-${message.Id}`"
                                                            class="audio-player"></audio>
                                                    </div>
                                                </template>
                                                <!-- 文件消息 -->
                                                <template v-else-if="message.WechatMessageType === 5">
                                                    <div class="file-message" @click="downloadFile(message.FilePath)">
                                                        <el-icon class="file-icon">
                                                            <Document />
                                                        </el-icon>
                                                        <span>{{ getFileNameFromPath(message.FilePath) }}</span>
                                                    </div>
                                                </template>
                                            </div>
                                        </div>
                                        <!-- 显示消息时间 -->
                                        <div class="message-time-bubble">{{ formatMessageTime(message.SendTime) }}</div>
                                    </div>
                                </div>

                                <!-- 自己发送的消息 -->
                                <div v-else class="message-item self">
                                    <div class="message-content">
                                        <div class="message-name">{{ message.SelfUserDto.Name }}</div>
                                        <div class="message-bubble">
                                            <!-- 文本内容 -->
                                            <div v-if="message.Content && message.Content.trim()" class="message-text">
                                                {{ message.Content }}
                                            </div>

                                            <!-- 媒体内容 -->
                                            <div v-if="message.FilePath" class="message-attachment">
                                                <!-- 图片消息 -->
                                                <template v-if="message.WechatMessageType === 2">
                                                    <img :src="message.FilePath || NoImage" class="message-image"
                                                        @click="previewImage(message.FilePath)" />
                                                </template>
                                                <!-- 视频消息 -->
                                                <template v-else-if="message.WechatMessageType === 4">
                                                    <div>
                                                        <video :src="message.FilePath" class="message-video"
                                                            controls></video>
                                                        <!-- 添加一个用于仅播放视频音频的按钮 -->
                                                        <div class="video-audio-control" @click.stop="playAudio(message)">
                                                            <el-icon class="audio-icon" v-if="!isPlayingAudio[message.Id]">
                                                                <Headset />
                                                            </el-icon>
                                                            <el-icon class="audio-icon playing" v-else>
                                                                <Mute />
                                                            </el-icon>
                                                            <span>仅播放音频</span>
                                                        </div>
                                                    </div>
                                                </template>
                                                <!-- 音频消息 -->
                                                <template v-else-if="message.WechatMessageType === 3">
                                                    <div class="audio-message" @click="playAudio(message)">
                                                        <el-icon class="audio-icon" v-if="!isPlayingAudio[message.Id]">
                                                            <Microphone />
                                                        </el-icon>
                                                        <el-icon class="audio-icon playing" v-else>
                                                            <VideoPlay />
                                                        </el-icon>
                                                        <div class="audio-waveform"></div>
                                                        <audio :src="message.FilePath" :id="`audio-${message.Id}`"
                                                            class="audio-player"></audio>
                                                    </div>
                                                </template>
                                                <!-- 文件消息 -->
                                                <template v-else-if="message.WechatMessageType === 5">
                                                    <div class="file-message" @click="downloadFile(message.FilePath)">
                                                        <el-icon class="file-icon">
                                                            <Document />
                                                        </el-icon>
                                                        <span>{{ getFileNameFromPath(message.FilePath) }}</span>
                                                    </div>
                                                </template>
                                            </div>
                                        </div>
                                        <!-- 显示消息时间 -->
                                        <div class="message-time-bubble self">{{ formatMessageTime(message.SendTime) }}
                                        </div>
                                    </div>
                                    <img :src="message.SelfUserDto.ImageUrls || defaultAvatar" class="message-avatar"
                                        alt="用户头像">
                                </div>
                            </div>
                        </template>
                    </div>

                    <!-- 发送消息区域 -->
                    <div class="message-input">
                        <!-- 移除顶部类型选择器 -->

                        <!-- 文本消息输入框 -->
                        <el-input type="textarea" v-model="messageContent" resize="none" rows="3" placeholder="请输入消息..."
                            class="input-area"></el-input>

                        <!-- 图片/视频/文件上传 -->
                        <div v-if="messageType !== 1" class="file-upload-area">
                            <el-upload class="upload-component" action="#" :auto-upload="false"
                                :on-change="handleFileChange" :show-file-list="false" :limit="1" :accept="getAcceptType()">
                                <template v-if="messageType === 2">
                                    <div v-if="!selectedFile" class="upload-placeholder">
                                        <el-icon class="upload-icon">
                                            <Plus />
                                        </el-icon>
                                        <span>点击上传图片</span>
                                    </div>
                                    <div v-else class="preview-container">
                                        <img :src="previewUrl" class="preview-image" />
                                        <div class="preview-close" @click.stop="clearSelectedFile">
                                            <el-icon>
                                                <Close />
                                            </el-icon>
                                        </div>
                                    </div>
                                </template>
                                <template v-else-if="messageType === 4">
                                    <div v-if="!selectedFile" class="upload-placeholder">
                                        <el-icon class="upload-icon">
                                            <Plus />
                                        </el-icon>
                                        <span>点击上传视频</span>
                                    </div>
                                    <div v-else class="preview-container">
                                        <video :src="previewUrl" class="preview-video" controls></video>
                                        <div class="preview-close" @click.stop="clearSelectedFile">
                                            <el-icon>
                                                <Close />
                                            </el-icon>
                                        </div>
                                    </div>
                                </template>
                                <template v-else-if="messageType === 3">
                                    <div v-if="!selectedFile" class="upload-placeholder">
                                        <el-icon class="upload-icon">
                                            <Plus />
                                        </el-icon>
                                        <span>点击上传音频</span>
                                    </div>
                                    <div v-else class="preview-container audio-preview">
                                        <div class="audio-preview-content">
                                            <el-icon class="audio-preview-icon">
                                                <Microphone />
                                            </el-icon>
                                            <span>{{ selectedFile.name }}</span>
                                            <audio :src="previewUrl" class="preview-audio" controls></audio>
                                        </div>
                                        <div class="preview-close" @click.stop="clearSelectedFile">
                                            <el-icon>
                                                <Close />
                                            </el-icon>
                                        </div>
                                    </div>
                                </template>
                                <template v-else>
                                    <div v-if="!selectedFile" class="upload-placeholder">
                                        <el-icon class="upload-icon">
                                            <Plus />
                                        </el-icon>
                                        <span>点击上传文件</span>
                                    </div>
                                    <div v-else class="selected-file">
                                        <el-icon class="file-icon">
                                            <Document />
                                        </el-icon>
                                        <span>{{ selectedFile.name }}</span>
                                        <div class="preview-close" @click.stop="clearSelectedFile">
                                            <el-icon>
                                                <Close />
                                            </el-icon>
                                        </div>
                                    </div>
                                </template>
                            </el-upload>
                        </div>

                        <div class="input-actions">
                            <!-- 消息类型按钮 -->
                            <div class="message-type-buttons">
                                <el-button size="small" type="text" :class="{ 'active-type': messageType === 2 }"
                                    @click="switchMessageType(2)">
                                    <el-icon>
                                        <Picture />
                                    </el-icon>
                                </el-button>
                                <el-button size="small" type="text" :class="{ 'active-type': messageType === 3 }"
                                    @click="switchMessageType(3)">
                                    <el-icon>
                                        <Microphone />
                                    </el-icon>
                                </el-button>
                                <el-button size="small" type="text" :class="{ 'active-type': messageType === 4 }"
                                    @click="switchMessageType(4)">
                                    <el-icon>
                                        <VideoCamera />
                                    </el-icon>
                                </el-button>
                                <el-button size="small" type="text" :class="{ 'active-type': messageType === 5 }"
                                    @click="switchMessageType(5)">
                                    <el-icon>
                                        <Document />
                                    </el-icon>
                                </el-button>
                            </div>
                            <div class="action-buttons">
                                <el-button size="small" @click="clearMessage">清空</el-button>
                                <el-button size="small" type="primary" :disabled="!canSendMessage"
                                    @click="sendMessage">发送</el-button>
                            </div>
                        </div>
                    </div>
                </template>

                <!-- 未选择聊天时显示的提示 -->
                <div v-else class="no-chat-selected">
                    <i class="el-icon-chat-dot-round"></i>
                    <p>请选择一个联系人开始聊天</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import defaultAvatar from '@/assets/默认头像.png';
import NoImage from '@/assets/图片失效.png';
import { Post, PostUpload } from '@/api/http';
import { ref, reactive, nextTick, computed, onMounted, onBeforeMount, onBeforeUnmount } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useCommonStore } from "@/store";
import { ElMessage, ElImageViewer } from 'element-plus';
import { Loading, Document, Picture, Microphone, VideoCamera, Plus, Close, VideoPlay, Headset, Mute } from '@element-plus/icons-vue';

// 引入websocket相关功能
import { AddSocketMessageMonitor, RemoveSocketMessageMonitor, SendMessage } from '@/utils/webscoket';

const router = useRouter();
const route = useRoute();
const commonStore = useCommonStore();

// 获取用户信息
const Token = computed(() => commonStore.Token);
const UserInfo = computed(() => commonStore.UserInfo);
const RoleType = computed(() => commonStore.RoleType);
const UserId = computed(() => commonStore.UserId);
const Name = ref(null);

// 聊天相关数据
const activeTab = ref(0);
const chatList = ref([]);
const selectedChat = ref(null);
const messageList = ref([]);
const messageContent = ref('');
const chatContentRef = ref(null);
const msgId = ref(new Date().getTime());
const isPlayingAudio = ref({});  // 跟踪音频播放状态

// 分页和加载状态
const currentPage = ref(1);
const pageSize = ref(20);
const total = ref(0);
const isLoading = ref(false);
const hasMoreMessages = ref(false);
const isFirstLoad = ref(true);

// 消息类型选择
const messageType = ref(1); // 1: 文本, 2: 图片, 4: 视频, 5: 文件
const selectedFile = ref(null);
const previewUrl = ref(null);

// 切换标签页
const switchTab = (tabIndex) => {
    activeTab.value = tabIndex;
};

// 获取聊天列表
const getChatList = async () => {
    try {
        const { Data } = await Post("/WechatCollection/List", {
            SelfUserId: UserId.value
        });
        chatList.value = Data.Items || [];
    } catch (error) {
        ElMessage.error('获取聊天列表失败');
        console.error(error);
    }
};

// 选择聊天
const selectChat = async (chat) => {
    selectedChat.value = chat;
    currentPage.value = 1; // 重置页码
    isFirstLoad.value = true;
    messageList.value = []; // 清空现有消息
    await loadMessages();
};

// 加载消息
const loadMessages = async () => {
    if (!selectedChat.value) return;

    isLoading.value = true;
    try {
        const { Data } = await Post('/WechatMessage/List', {
            SelfUserId: selectedChat.value.SelfUserId,
            OtherUserId: selectedChat.value.OtherUserId,
            Page: currentPage.value,
            PageSize: pageSize.value
        });

        // 如果是首次加载，直接替换消息列表
        if (isFirstLoad.value) {
            messageList.value = Data.Items || [];
            isFirstLoad.value = false;
        } else {
            // 否则将新消息添加到列表前面
            messageList.value = [...Data.Items, ...messageList.value];
        }

        total.value = Data.Total || 0;
        hasMoreMessages.value = currentPage.value * pageSize.value < total.value;

        // 滚动到底部（仅首次加载）
        if (currentPage.value === 1) {
            nextTick(() => {
                scrollToBottom();
            });
        }
    } catch (error) {
        ElMessage.error('获取聊天记录失败');
        console.error(error);
    } finally {
        isLoading.value = false;
    }
};

// 加载更多消息
const loadMoreMessages = async () => {
    if (isLoading.value) return;

    currentPage.value++;
    await loadMessages();
};

// 处理滚动事件，当用户滚动到顶部时自动加载更多消息
const handleScroll = (event) => {
    if (chatContentRef.value.scrollTop < 50 && hasMoreMessages.value && !isLoading.value) {
        loadMoreMessages();
    }
};

// 初始化选择聊天
const initSelectedChat = () => {
    const otherUserId = route.query.OtherUserId;
    if (otherUserId && chatList.value.length > 0) {
        const chat = chatList.value.find(item => item.OtherUserId == otherUserId);
        if (chat) {
            selectChat(chat);
        }
    }
};

// 发送消息
const sendMessage = async () => {
    if (!messageContent.value.trim() && !selectedFile.value) {
        ElMessage.warning('请输入消息内容或选择文件');
        return;
    }

    try {
        let filePath = null;

        // 如果有选择文件，直接使用已上传的文件路径
        if (selectedFile.value && selectedFile.value.serverPath) {
            filePath = selectedFile.value.serverPath;
        }

        // 构建消息对象
        const message = {
            SelfUserId: UserId.value,
            OtherUserId: selectedChat.value.OtherUserId,
            Content: messageContent.value,
            WechatMessageType: messageType.value,
            FilePath: filePath // 文件路径
        };

        // 发送消息
        SendMessage('Wechat_SendMessage', message);
        ElMessage.success('消息发送成功');
        messageContent.value = '';
        selectedFile.value = null;
        previewUrl.value = null;
        messageType.value = 1; // 发送后重置为文本消息
    } catch (error) {
        console.error('发送消息失败', error);
        ElMessage.error('发送消息失败，请重试');
    }
};

// 清空消息输入
const clearMessage = () => {
    messageContent.value = '';
    selectedFile.value = null;
    previewUrl.value = null;
    messageType.value = 1; // 清空后重置为文本消息
};

// 滚动到底部
const scrollToBottom = () => {
    if (chatContentRef.value) {
        chatContentRef.value.scrollTop = chatContentRef.value.scrollHeight;
    }
};

// 接收websocket消息
const onMessage = (res) => {
    if (res.Type === 'Wechat_SendMessage_Back') {
        messageList.value.push(res.Data);
        nextTick(() => {
            scrollToBottom();
        });
    }
};

// 判断是否显示日期分割线
const shouldShowDateDivider = (message, index) => {
    if (index === 0) return true;

    const currentDate = new Date(message.SendTime).toLocaleDateString();
    const prevDate = new Date(messageList.value[index - 1].SendTime).toLocaleDateString();

    return currentDate !== prevDate;
};

// 格式化消息日期 (年月日)
const formatMessageDate = (dateString) => {
    const date = new Date(dateString);
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    // 如果是今天
    if (date.toLocaleDateString() === today.toLocaleDateString()) {
        return '今天';
    }

    // 如果是昨天
    if (date.toLocaleDateString() === yesterday.toLocaleDateString()) {
        return '昨天';
    }

    // 其他日期显示完整日期
    return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日`;
};

// 格式化消息时间 (时分)
const formatMessageTime = (dateString) => {
    const date = new Date(dateString);
    let hours = date.getHours();
    const minutes = date.getMinutes().toString().padStart(2, '0');

    // 12小时制
    const amPm = hours >= 12 ? '下午' : '上午';
    hours = hours % 12;
    hours = hours ? hours : 12; // 0点显示为12点

    return `${amPm} ${hours}:${minutes}`;
};

// 预览图片
const previewImage = (url) => {
    if (!url) return;

    const imageUrl = url;
    const imgViewer = new ElImageViewer({
        urlList: [imageUrl],
    });

    imgViewer.show();
};

// 预览视频
const previewVideo = (url) => {
    previewUrl.value = url;
};

// 处理音频/视频消息播放
const handleMediaPlay = (messageId, mediaType) => {
    // 如果是音频或视频，调用播放函数
    if (mediaType === 3 || mediaType === 4) {
        const message = messageList.value.find(m => m.Id === messageId);
        if (message) {
            playAudio(message);
        }
    }
};

// 下载文件
const downloadFile = (url) => {
    const link = document.createElement('a');
    link.href = url;
    link.download = getFileNameFromPath(url); // 使用文件名作为下载名
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
};

// 获取文件名
const getFileNameFromPath = (path) => {
    if (!path) return '未知文件';
    const lastSlash = path.lastIndexOf('/');
    if (lastSlash === -1) return path;
    return path.substring(lastSlash + 1);
};

// 文件上传变化
const handleFileChange = async (file) => {
    // 验证文件类型
    let isValidType = true;
    let errorMessage = '';

    const isMP4 = file.raw.name.toLowerCase().endsWith('.mp4');

    if (messageType.value === 2 && !file.raw.type.startsWith('image/')) {
        isValidType = false;
        errorMessage = '请选择图片文件!';
    } else if (messageType.value === 3 && !file.raw.type.startsWith('audio/') && !isMP4) {
        isValidType = false;
        errorMessage = '请选择音频文件!';
    } else if (messageType.value === 4 && !file.raw.type.startsWith('video/')) {
        isValidType = false;
        errorMessage = '请选择视频文件!';
    }

    if (!isValidType) {
        ElMessage.error(errorMessage);
        return;
    }

    selectedFile.value = file;
    previewUrl.value = URL.createObjectURL(file.raw);

    // 立即上传文件
    try {
        const formData = new FormData();
        formData.append('file', file.raw);

        // 调用文件上传接口
        const response = await PostUpload('/File/BatchUpload', formData);

        if (response.Success && response.Data && response.Data.length > 0) {
            // 保存服务器返回的文件URL
            selectedFile.value.serverPath = response.Data[0].Url;
            ElMessage.success('文件上传成功');
        } else {
            ElMessage.error('文件上传失败：' + response.Msg);
            clearSelectedFile();
        }
    } catch (error) {
        console.error('文件上传失败', error);
        ElMessage.error('文件上传失败，请重试');
        clearSelectedFile();
    }
};

// 清除已选择的文件
const clearSelectedFile = (event) => {
    if (event) {
        event.stopPropagation();
    }
    selectedFile.value = null;
    previewUrl.value = null;
};

// 切换消息类型
const switchMessageType = (type) => {
    messageType.value = type;
    selectedFile.value = null; // 切换类型时清空文件
    previewUrl.value = null;
};

// 获取文件上传accept属性
const getAcceptType = () => {
    let accept = '';
    switch (messageType.value) {
        case 2: // 图片
            accept = 'image/*';
            break;
        case 3: // 音频
            accept = 'audio/*,.mp4'; // 添加对MP4的支持
            break;
        case 4: // 视频
            accept = 'video/*';
            break;
        case 5: // 文件
            accept = '*'; // 允许所有文件类型
            break;
        default:
            accept = '';
            break;
    }
    return accept;
};

// 判断是否可以发送消息
const canSendMessage = computed(() => {
    return messageContent.value.trim() || selectedFile.value;
});

// 播放音频
const playAudio = (message) => {
    if (!message.Id || !message.FilePath) return;

    const audioId = `audio-${message.Id}`;
    const audioElement = document.getElementById(audioId);

    if (!audioElement) {
        console.error('找不到音频元素:', audioId);
        return;
    }

    console.log('尝试播放音频:', message.FilePath);

    // 停止所有其他正在播放的音频
    Object.keys(isPlayingAudio.value).forEach(key => {
        if (key !== message.Id.toString() && isPlayingAudio.value[key]) {
            const otherAudio = document.getElementById(`audio-${key}`);
            if (otherAudio) {
                otherAudio.pause();
                otherAudio.currentTime = 0;
            }
            isPlayingAudio.value[key] = false;
        }
    });

    // 播放或暂停当前音频
    if (isPlayingAudio.value[message.Id]) {
        audioElement.pause();
        isPlayingAudio.value[message.Id] = false;
    } else {
        audioElement.play().catch(error => {
            console.error('音频播放失败:', error);
            ElMessage.error('音频播放失败，请重试');
        });

        // 监听播放结束事件
        audioElement.onended = () => {
            isPlayingAudio.value[message.Id] = false;
        };

        isPlayingAudio.value[message.Id] = true;
    }
};


// 生命周期钩子
onBeforeMount(async () => {

});

onMounted(async () => {
    // 添加websocket消息监听
    AddSocketMessageMonitor(msgId.value, onMessage);

    // 获取聊天列表
    await getChatList();

    // 初始化选择聊天
    initSelectedChat();
});

onBeforeUnmount(() => {
    // 移除websocket消息监听
    RemoveSocketMessageMonitor(msgId.value);
});
</script>

<style scoped lang="scss">
/* 整体容器样式 */
.weChat-container {
    width: 100%;
    margin: 0 auto;
}

/* 位置导航样式 */
.location-nav {
    margin-bottom: 20px;
}

/* 主体聊天区域 */
.chat-main {
    display: flex;
    height: 650px;
    /* 增加聊天区域高度 */
    border-radius: 12px;
    /* 增大圆角 */
    overflow: hidden;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    /* 增强阴影效果 */
}

/* 左侧栏样式 */
.sidebar {
    width: 60px;
    background-color: #2c3e50;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 15px 0;
}

.user-profile {
    margin-bottom: 20px;
}

.avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid rgba(255, 255, 255, 0.2);
    /* 添加头像边框 */
}

.nav-icons {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.nav-icon {
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #909399;
    border-radius: 8px;
    margin-bottom: 10px;
    cursor: pointer;
    transition: all 0.3s;
}

.nav-icon.active {
    color: #67c23a;
    background-color: rgba(255, 255, 255, 0.1);
}

/* 联系人列表样式 */
.contact-list {
    width: 280px;
    /* 增加联系人列表宽度 */
    background-color: #f5f7fa;
    overflow-y: auto;
    border-right: 1px solid #ebeef5;
}

.contact-item {
    display: flex;
    padding: 15px;
    /* 增加内边距 */
    cursor: pointer;
    border-bottom: 1px solid #ebeef5;
    transition: all 0.3s;
}

.contact-item:hover {
    background-color: #ecf5ff;
}

.contact-item.active {
    background-color: #e6f2ff;
}

.contact-avatar {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 12px;
    border: 1px solid #ebeef5;
    /* 添加头像边框 */
}

.contact-info {
    flex: 1;
    overflow: hidden;
}

.contact-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 5px;
}

.contact-name {
    font-weight: 500;
    font-size: 15px;
    /* 增大字号 */
}

.unread-badge {
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f56c6c;
    color: #fff;
    border-radius: 50%;
    width: 20px;
    /* 增大徽章尺寸 */
    height: 20px;
    /* 增大徽章尺寸 */
    font-size: 12px;
    font-weight: bold;
    /* 加粗数字 */
}

.contact-preview {
    font-size: 12px;
    color: #909399;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* 聊天窗口样式 */
.chat-window {
    flex: 1;
    display: flex;
    flex-direction: column;
    background-color: #f0f2f5;
    /* 更改背景色，增加对比度 */
}

.chat-header {
    height: 65px;
    /* 增加高度 */
    display: flex;
    align-items: center;
    justify-content: space-between;
    /* 两端对齐 */
    padding: 0 20px;
    border-bottom: 1px solid #ebeef5;
    background-color: #fff;
    /* 设置白色背景 */
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    /* 添加微妙阴影 */
}

.chat-title {
    font-size: 17px;
    /* 增大字号 */
    font-weight: 600;
    /* 加粗 */
    color: #303133;
    /* 设置更深的颜色 */
}

.chat-status {
    font-size: 14px;
    color: #909399;
}

.chat-content {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
    background-color: #f8f9fa;
    scrollbar-width: thin;
    /* 细滚动条 */
    scrollbar-color: #c0c4cc #f2f3f5;
    /* 自定义滚动条颜色 */
}

/* 自定义滚动条样式 */
.chat-content::-webkit-scrollbar {
    width: 6px;
}

.chat-content::-webkit-scrollbar-track {
    background: #f2f3f5;
}

.chat-content::-webkit-scrollbar-thumb {
    background-color: #c0c4cc;
    border-radius: 6px;
}

/* 加载更多按钮 */
.load-more-wrapper {
    display: flex;
    justify-content: center;
    margin-bottom: 15px;
}

/* 加载指示器 */
.loading-indicator {
    display: flex;
    justify-content: center;
    padding: 10px;
    color: #909399;
}

/* 日期分割线 */
.date-divider {
    text-align: center;
    margin: 15px 0;
    position: relative;
    color: #909399;
    font-size: 14px;
    background-color: rgba(220, 222, 224, 0.5);
    padding: 5px 15px;
    border-radius: 16px;
    display: inline-block;
    left: 50%;
    transform: translateX(-50%);
}

.message-group {
    margin-bottom: 22px;
    /* 增加消息组间距 */
}

.message-item {
    display: flex;
    margin-bottom: 3px;
    position: relative;
    /* 添加定位上下文 */
}

.message-avatar {
    width: 42px;
    /* 增大头像 */
    height: 42px;
    /* 增大头像 */
    border-radius: 50%;
    object-fit: cover;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    /* 添加头像阴影 */
    border: 2px solid #fff;
    /* 添加头像边框 */
}

.message-content {
    max-width: 65%;
    /* 增加最大宽度 */
}

.message-name {
    font-size: 12px;
    margin-bottom: 4px;
    color: #909399;
    font-weight: 500;
    /* 加粗名称 */
}

/* 消息内容样式 */
.message-bubble {
    padding: 12px 16px;
    /* 增加内边距 */
    border-radius: 18px;
    word-break: break-word;
    line-height: 1.5;
    /* 增加行高 */
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    /* 添加轻微阴影 */

    /* 文本消息样式 */
    .message-text {
        margin-bottom: 8px;
        font-size: 15px;
        /* 增大字号 */
    }

    /* 最后一个元素不需要底部间距 */
    .message-text:last-child {
        margin-bottom: 0;
    }

    /* 附件容器 */
    .message-attachment {
        margin-top: 8px;
    }

    /* 当只有附件没有文本时不需要顶部间距 */
    .message-attachment:first-child {
        margin-top: 0;
    }

    /* 图片消息样式 */
    .message-image {
        max-width: 220px;
        /* 增大图片尺寸 */
        max-height: 220px;
        /* 增大图片尺寸 */
        border-radius: 10px;
        /* 增大图片圆角 */
        cursor: pointer;
        transition: transform 0.3s;
        border: 1px solid rgba(0, 0, 0, 0.05);
        /* 添加图片边框 */

        &:hover {
            transform: scale(1.03);
        }
    }

    /* 视频消息样式 */
    .message-video {
        max-width: 250px;
        /* 增大视频尺寸 */
        max-height: 190px;
        /* 增大视频尺寸 */
        border-radius: 10px;
        /* 增大视频圆角 */
        border: 1px solid rgba(0, 0, 0, 0.05);
        /* 添加视频边框 */
    }

    /* 文件消息样式 */
    .file-message {
        display: flex;
        align-items: center;
        padding: 10px 12px;
        /* 增加内边距 */
        background-color: rgba(255, 255, 255, 0.9);
        border-radius: 10px;
        /* 增大圆角 */
        cursor: pointer;
        transition: background-color 0.3s, transform 0.2s;
        border: 1px solid rgba(0, 0, 0, 0.05);
        /* 添加边框 */

        &:hover {
            background-color: rgba(255, 255, 255, 1);
            transform: translateY(-2px);
            /* 悬停时轻微上浮 */
        }

        i {
            margin-right: 10px;
            font-size: 20px;
        }

        span {
            font-size: 14px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            max-width: 180px;
            /* 增加最大宽度 */
        }
    }
}

/* 消息时间气泡 */
.message-time-bubble {
    font-size: 11px;
    color: #909399;
    margin-top: 4px;
    opacity: 0.8;
}

.message-time-bubble.self {
    text-align: right;
}

/* 对方消息样式 */
.other {
    align-items: flex-start;
}

.other .message-avatar {
    margin-right: 12px;
    /* 增加间距 */
}

.other .message-bubble {
    background-color: #fff;
    border: 1px solid #ebeef5;
    position: relative;

    /* 添加消息气泡尖角 */
    &:before {
        content: "";
        position: absolute;
        top: 15px;
        left: -8px;
        width: 0;
        height: 0;
        border-top: 6px solid transparent;
        border-bottom: 6px solid transparent;
        border-right: 8px solid #fff;
        z-index: 1;
    }

    /* 添加消息气泡边框尖角 */
    &:after {
        content: "";
        position: absolute;
        top: 15px;
        left: -9px;
        width: 0;
        height: 0;
        border-top: 6px solid transparent;
        border-bottom: 6px solid transparent;
        border-right: 8px solid #ebeef5;
        z-index: 0;
    }
}

/* 自己消息样式 */
.self {
    align-items: flex-start;
    justify-content: flex-end;
}

.self .message-content {
    margin-right: 12px;
    /* 增加间距 */
}

.self .message-name {
    text-align: right;
}

.self .message-bubble {
    background-color: #95ec69;
    color: #333;
    position: relative;

    /* 添加消息气泡尖角 */
    &:before {
        content: "";
        position: absolute;
        top: 15px;
        right: -8px;
        width: 0;
        height: 0;
        border-top: 6px solid transparent;
        border-bottom: 6px solid transparent;
        border-left: 8px solid #95ec69;
    }
}

/* 消息输入区域 */
.message-input {
    padding: 15px;
    border-top: 1px solid #ebeef5;
    background-color: #fff;
    /* 设置白色背景 */
}

/* 消息类型按钮样式 */
.message-type-buttons {
    display: flex;
    justify-content: space-around;
    margin-bottom: 10px;
}

.message-type-buttons .el-button {
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #909399;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s;
    padding: 0;
    /* Remove default padding */
}

.message-type-buttons .el-button.active-type {
    color: #67c23a;
    background-color: #f0f9eb;
    /* 更明显的背景色 */
}

/* 增大图标尺寸 */
.message-type-buttons .el-icon {
    font-size: 20px;
    /* 增大图标尺寸 */
}

.file-upload-area {
    margin-top: 10px;
}

.upload-component {
    width: 100%;
}

.upload-placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px 0;
    border: 1px dashed #d9d9d9;
    border-radius: 8px;
    text-align: center;
    color: #909399;
    cursor: pointer;
    transition: border-color 0.3s;
}

.upload-placeholder:hover {
    border-color: #409eff;
}

.preview-container {
    position: relative;
    width: 100%;
    height: 150px;
    /* 固定高度 */
    border: 1px solid #ebeef5;
    border-radius: 8px;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f8f9fa;
}

.preview-image {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

.preview-video {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

.preview-close {
    position: absolute;
    top: 5px;
    right: 5px;
    background-color: rgba(0, 0, 0, 0.5);
    color: #fff;
    border-radius: 50%;
    width: 24px;
    /* 增大关闭按钮尺寸 */
    height: 24px;
    /* 增大关闭按钮尺寸 */
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 10;
}

.preview-close .el-icon {
    font-size: 16px;
    /* 增大关闭图标尺寸 */
}

.preview-audio {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

.audio-preview {
    position: relative;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f8f9fa;
    border: 1px solid #ebeef5;
    border-radius: 8px;
    overflow: hidden;
}

.audio-preview-content {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    padding: 10px;
}

.audio-preview-icon {
    font-size: 30px;
    color: #67c23a;
    margin-bottom: 5px;
}

.selected-file {
    display: flex;
    align-items: center;
    padding: 12px 15px;
    /* 增加内边距 */
    background-color: #f0f9eb;
    border: 1px solid #e1f3d8;
    border-radius: 8px;
    color: #67c23a;
    font-size: 14px;
}

.selected-file i {
    margin-right: 10px;
    /* 增加间距 */
}

.selected-file span {
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.input-area {
    margin-bottom: 10px;

    /* 美化输入框样式 */
    .el-textarea__inner {
        border-radius: 8px;
        padding: 10px 15px;
        font-size: 15px;
        /* 增大字号 */
        resize: none;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        /* 轻微阴影 */
        transition: border-color 0.3s, box-shadow 0.3s;

        &:focus {
            box-shadow: 0 1px 5px rgba(64, 158, 255, 0.2);
            /* 聚焦时阴影效果 */
        }
    }
}

.input-actions {
    display: flex;
    justify-content: space-between;
    /* Changed to space-between */
    align-items: center;
    /* Added to align items vertically */
    gap: 10px;
}

.action-buttons {
    display: flex;
    gap: 10px;
}

/* 无选择聊天提示 */
.no-chat-selected {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #909399;
    background-color: #f8f9fa;
    /* 设置背景色 */
}

.no-chat-selected i {
    font-size: 60px;
    /* 增大图标尺寸 */
    margin-bottom: 20px;
    color: #c0c4cc;
    /* 改变图标颜色 */
}

.no-chat-selected p {
    font-size: 16px;
    color: #606266;
    /* 改变文字颜色 */
}

/* 样式更新 */
.upload-icon {
    font-size: 32px;
    /* 增大上传图标尺寸 */
    margin-bottom: 10px;
}

.file-icon {
    font-size: 22px;
    /* 增大文件图标尺寸 */
    margin-right: 8px;
}

.preview-close {
    position: absolute;
    top: 5px;
    right: 5px;
    background-color: rgba(0, 0, 0, 0.5);
    color: #fff;
    border-radius: 50%;
    width: 24px;
    /* 增大关闭按钮尺寸 */
    height: 24px;
    /* 增大关闭按钮尺寸 */
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 10;
}

.preview-close .el-icon {
    font-size: 16px;
    /* 增大关闭图标尺寸 */
}

/* 文件消息中的图标 */
.file-message .el-icon {
    font-size: 22px;
    /* 增大文件消息中的图标尺寸 */
}

/* 音频消息样式 */
.audio-message {
    display: flex;
    align-items: center;
    padding: 8px 12px;
    background-color: rgba(255, 255, 255, 0.9);
    border-radius: 16px;
    cursor: pointer;
    transition: background-color 0.3s;
    position: relative;
    width: 160px;
    min-height: 40px;
    border: 1px solid rgba(0, 0, 0, 0.05);
}

.audio-message:hover {
    background-color: rgba(255, 255, 255, 1);
}

.audio-icon {
    font-size: 18px;
    color: #67c23a;
    margin-right: 10px;
}

.audio-icon.playing {
    color: #f56c6c;
}

.audio-waveform {
    flex: 1;
    height: 20px;
    background: linear-gradient(90deg, #67c23a 0%, #95ec69 100%);
    border-radius: 10px;
    position: relative;
    overflow: hidden;
}

.audio-waveform::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: repeating-linear-gradient(to right,
            transparent,
            transparent 3px,
            rgba(255, 255, 255, 0.5) 3px,
            rgba(255, 255, 255, 0.5) 5px);
}

.audio-player {
    display: none;
}

/* 视频音频控制样式 */
.video-audio-control {
    display: flex;
    align-items: center;
    margin-top: 8px;
    padding: 5px 10px;
    background-color: rgba(103, 194, 58, 0.1);
    border-radius: 16px;
    cursor: pointer;
    transition: all 0.3s;
    max-width: fit-content;
}

.video-audio-control:hover {
    background-color: rgba(103, 194, 58, 0.2);
}

.video-audio-control .audio-icon {
    font-size: 16px;
    margin-right: 5px;
}

.video-audio-control span {
    font-size: 12px;
    color: #67c23a;
}
</style>