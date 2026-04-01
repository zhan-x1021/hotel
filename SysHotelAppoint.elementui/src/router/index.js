import { useCommonStore } from "@/store";
import AdminLayout from "@/views/Admin/Layout/index.vue";
import FrontLayout from "@/views/Front/Layout/index.vue";
import NProgress from "nprogress";
import "nprogress/nprogress.css";
import { createRouter, createWebHashHistory } from "vue-router";

// 配置 NProgress
NProgress.configure({
  showSpinner: false, // 不显示加载圈
  speed: 1000,
  trickle: false,
});

// 路由配置
const routes = [
  {
    path: "/",
    redirect: "/Front",
  },
  {
    path: "/Login",
    name: "Login",
    component: () => import("../views/Login.vue"),
  },
  {
    path: "/LargeDataAnalysis",
    name: "LargeDataAnalysis",
    component: () => import("../views/LargeDataAnalysis.vue"),
  },
  {
    path: "/Register",
    name: "Register",
    component: () => import("../views/Register.vue"),
  },
  {
    path: "/ForgetPassword",
    name: "ForgetPassword",
    component: () => import("../views/ForgetPassword.vue"),
  },
  // 404页面
  {
    path: "/:pathMatch(.*)*",
    name: "NotFound",
    component: () => import("../views/NotFound.vue"),
  },
];

const frontRoutes = [
  {
    path: "/Front",
    redirect: "/Front/Home",
    component: FrontLayout,
    meta: {
      title: "前台",
      isAdmin: false,
    },
    children: [
      {
        path: "/Front/Home",
        name: "FrontHome",
        meta: {
          title: "前台",
          isAdmin: false,
        },
        component: () => import("../views/Front/Home.vue"),
      },
      {
        path: "/Front/UserCenter",
        name: "UserCenter",
        meta: {
          title: "个人中心",
          isAdmin: false,
        },
        component: () => import("../views/Front/Layout/UserCenter.vue"),
      },
      {
        path: "/Front/WeChat",
        name: "WeChat",
        meta: {
          title: "消息会话",
          isAdmin: false,
        },
        component: () => import("../views/Front/WeChat.vue"),
      },
      {
        path: "/Front/HotelList",
        name: "HotelList",
        meta: {
          title: "酒店列表",
          isAdmin: false,
        },
        component: () => import("../views/Front/HotelList.vue"),
      },
      {
        path: "/Front/HotelDetail",
        name: "HotelDetail",
        meta: {
          title: "酒店详情",
          isAdmin: false,
        },
        component: () => import("../views/Front/HotelDetail.vue"),
      },
      {
        path: "/Front/WeChat",
        name: "WeChat",
        meta: {
          title: "消息会话",
          isAdmin: false,
        },
        component: () => import("../views/Front/WeChat.vue"),
      },
      {
        path: "/Front/ToOrder",
        name: "ToOrder",
        meta: {
          title: "酒店预订",
          isAdmin: false,
        },
        component: () => import("../views/Front/ToOrder.vue"),
      },
      {
        path: "/Front/Payment",
        name: "Payment",
        meta: {
          title: "支付",
          isAdmin: false,
        },
        component: () => import("../views/Front/Payment.vue"),
      },
      {
        path: "/Front/MyAppointOrderList",
        name: "MyAppointOrderList",
        meta: {
          title: "我的预约订单",
          isAdmin: false,
        },
        component: () => import("../views/Front/MyAppointOrderList.vue"),
      },
      {
        path: "/Front/OrderDetail",
        name: "OrderDetail",
        meta: {
          title: "订单详情",
          isAdmin: false,
        },
        component: () => import("../views/Front/OrderDetail.vue"),
      },
      {
        path: "/Front/AddComment",
        name: "AddComment",
        meta: {
          title: "添加评价",
          isAdmin: false,
        },
        component: () => import("../views/Front/AddComment.vue"),
      },
      {
        path: "/Front/SysNoticeList",
        name: "SysNoticeList",
        meta: {
          title: "系统通知",
          isAdmin: false,
        },
        component: () => import("../views/Front/SysNoticeList.vue"),
      },
      {
        path: "/Front/SysNoticeDetail",
        name: "SysNoticeDetail",
        meta: {
          title: "通知详情",
          isAdmin: false,
        },
        component: () => import("../views/Front/SysNoticeDetail.vue"),
      },
      {
        path: "/Front/LeaveFeedbackAdd",
        name: "LeaveFeedbackAdd",
        meta: {
          title: "留言反馈",
          isAdmin: false,
        },
        component: () => import("../views/Front/LeaveFeedbackAdd.vue"),
      },
      {
        path: "/Front/MyHotelIntegralList",
        name: "MyHotelIntegralList",
        meta: {
          title: "我的酒店积分",
          isAdmin: false,
        },
        component: () => import("../views/Front/MyHotelIntegralList.vue"),
      },
      {
        path: "/Front/HotelIntegralDetList",
        name: "HotelIntegralDetList",
        meta: {
          title: "积分明细",
          isAdmin: false,
        },
        component: () => import("../views/Front/HotelIntegralDetList.vue"),
      },
      {
        path: "/Front/RoomSearch",
        name: "RoomSearch",
        meta: {
          title: "房间搜索",
          isAdmin: false,
        },
        component: () => import("../views/Front/RoomSearch.vue"),
      },
    ],
  },
];

const adminRoutes = [
  {
    path: "/Admin",
    name: "Admin",
    redirect: "/Admin/Home",
    component: AdminLayout,
    meta: {
      title: "控制台",
      isAdmin: true,
    },
    children: [
      {
        path: "/Admin/Home",
        name: "AdminHome",
        meta: {
          title: "控制台",
          isAdmin: true,
        },
        component: () => import("../views/Admin/Home.vue"),
      },
      {
        path: "/Admin/UserPerson",
        name: "AdminUserPerson",
        meta: {
          title: "账号信息",
          isAdmin: true,
        },
        component: () => import("../views/Admin/UserPerson.vue"),
      },
      {
        path: "/Admin/PasswordEdit",
        name: "PasswordEdit",
        meta: {
          title: "修改密码",
          isAdmin: true,
        },
        component: () => import("../views/Admin/PasswordEdit.vue"),
      },
      {
        path: "/Admin/UserList",
        name: "AdminUserList",
        meta: {
          title: "账号列表",
          isAdmin: true,
        },
        component: () => import("../views/Admin/UserList.vue"),
      },
      {
        path: "/Admin/WeChat",
        meta: {
          title: "消息会话",
          isAdmin: true,
        },
        component: () => import("../views/Admin/WeChat.vue"),
      },
      {
        path: "/Admin/AppointList",
        meta: {
          title: "预约记录",
          isAdmin: true,
        },
        component: () => import("../views/Admin/AppointList.vue"),
      },

      {
        path: "/Admin/AppointDetList",
        meta: {
          title: "预约明细",
          isAdmin: true,
        },
        component: () => import("../views/Admin/AppointDetList.vue"),
      },

      {
        path: "/Admin/BannerList",
        meta: {
          title: "封面",
          isAdmin: true,
        },
        component: () => import("../views/Admin/BannerList.vue"),
      },

      {
        path: "/Admin/EmployeeList",
        meta: {
          title: "员工",
          isAdmin: true,
        },
        component: () => import("../views/Admin/EmployeeList.vue"),
      },

      {
        path: "/Admin/EquipmentInfoList",
        meta: {
          title: "设备信息",
          isAdmin: true,
        },
        component: () => import("../views/Admin/EquipmentInfoList.vue"),
      },

      {
        path: "/Admin/FavourableSettingList",
        meta: {
          title: "优惠设置",
          isAdmin: true,
        },
        component: () => import("../views/Admin/FavourableSettingList.vue"),
      },

      {
        path: "/Admin/GuestInfoList",
        meta: {
          title: "旅客信息",
          isAdmin: true,
        },
        component: () => import("../views/Admin/GuestInfoList.vue"),
      },

      {
        path: "/Admin/HotelList",
        meta: {
          title: "酒店",
          isAdmin: true,
        },
        component: () => import("../views/Admin/HotelList.vue"),
      },

      {
        path: "/Admin/HotelIntegralList",
        meta: {
          title: "酒店积分",
          isAdmin: true,
        },
        component: () => import("../views/Admin/HotelIntegralList.vue"),
      },

      {
        path: "/Admin/LeaveFeedbackList",
        meta: {
          title: "留言反馈",
          isAdmin: true,
        },
        component: () => import("../views/Admin/LeaveFeedbackList.vue"),
      },

      {
        path: "/Admin/MessageNoticeList",
        meta: {
          title: "消息通知",
          isAdmin: true,
        },
        component: () => import("../views/Admin/MessageNoticeList.vue"),
      },

      {
        path: "/Admin/RoomList",
        meta: {
          title: "房间",
          isAdmin: true,
        },
        component: () => import("../views/Admin/RoomList.vue"),
      },

      {
        path: "/Admin/RoomDetList",
        meta: {
          title: "房间明细",
          isAdmin: true,
        },
        component: () => import("../views/Admin/RoomDetList.vue"),
      },

      {
        path: "/Admin/RoomMatchList",
        meta: {
          title: "分配房间",
          isAdmin: true,
        },
        component: () => import("../views/Admin/RoomMatchList.vue"),
      },

      {
        path: "/Admin/RoomPriceList",
        meta: {
          title: "房间价格",
          isAdmin: true,
        },
        component: () => import("../views/Admin/RoomPriceList.vue"),
      },

      {
        path: "/Admin/StorageRecordList",
        meta: {
          title: "寄存记录",
          isAdmin: true,
        },
        component: () => import("../views/Admin/StorageRecordList.vue"),
      },

      {
        path: "/Admin/SysNoticeList",
        meta: {
          title: "系统通知",
          isAdmin: true,
        },
        component: () => import("../views/Admin/SysNoticeList.vue"),
      },
      {
        path: "/Admin/HotelEdit",
        meta: {
          title: "酒店",
          isAdmin: true,
        },
        component: () => import("../views/Admin/HotelEdit.vue"),
      },
      {
        path: "/Admin/RoomEquipmentInfoSetting",
        meta: {
          title: "房间设施配置",
          isAdmin: true,
        },
        component: () => import("../views/Admin/RoomEquipmentInfoSetting.vue"),
      },
      {
        path: "/Admin/AssignRoom",
        meta: {
          title: "房间分配",
          isAdmin: true,
        },
        component: () => import("../views/Admin/AssignRoom.vue"),
      },
      {
        path: "/Admin/AppointDetail",
        meta: {
          title: "预约详情",
          isAdmin: true,
        },
        component: () => import("../views/Admin/AppointDetail.vue"),
      },
      {
        path: "/Admin/HotelDataAnalysis",
        meta: {
          title: "酒店数据分析",
          isAdmin: true,
        },
        component: () => import("../views/Admin/HotelDataAnalysis.vue"),
      },
    ],
  },
];

// 创建路由实例
const router = createRouter({
  history: createWebHashHistory(),
  routes: [...routes, ...adminRoutes, ...frontRoutes],
});

// 路由前置守卫
router.beforeEach(async (to, from, next) => {
  // 开启进度条
  NProgress.start();

  // 获取 store 实例
  const commonStore = useCommonStore();

  // 可以在这里处理路由权限等逻辑
  if (commonStore.Token) {
    //判断是否有用户信息
    if (commonStore.HasUserInfo == false) {
      //获取账号信息
      await commonStore.GetInfo();
      //获取的账号id为空或者为0
      if (commonStore.UserId == null || commonStore.UserId == 0) {
        commonStore.Logout();
      }
    }

    //如果去往的页面是后台
    if (to.meta && to.meta.isAdmin) {
      if (commonStore.RoleType == "管理员" || commonStore.RoleType == "酒店") {
        next();
      } else {
        next({ path: "/" });
      }
    } else if (to.meta && to.meta.isAdmin == false) {
      if (commonStore.RoleType == "管理员" || commonStore.RoleType == "酒店") {
        next({ path: "/Admin" });
      } else {
        next();
      }
    } else {
      next();
    }
  } else {
    if (to.meta && to.meta.isAdmin) {
      next({ path: "/Login" });
    } else {
      next();
    }
  }
});

// 路由后置守卫
router.afterEach(() => {
  window.scrollTo({ top: 0 });
  // 关闭进度条
  NProgress.done();
});

export default router;
