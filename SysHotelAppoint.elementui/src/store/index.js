import { Post } from "@/api/http.js";

import { defineStore } from "pinia";

//  状态管理
export const useCommonStore = defineStore("common", {
  state: () => ({
    // 初始状态
    Token: null,
    GlobalAddress: {
      province: "全国",
      city: "",
      area: "",
    },
    UserInfo: null,
    RoleType: undefined,
    HasUserInfo: false,
    HotelDto: null,
  }),
  getters: {
    UserId: (state) => state.UserInfo && state.UserInfo.Id,
  },
  actions: {
    async Login(UserInfo) {
      let res = await Post("/User/SignIn", UserInfo);

      if (res.Success) {
        this.$patch({ Token: res.Data });
      }

      return res;
    },
    async GetInfo() {
      let res = await Post("/User/GetByToken", {});

      this.$patch({
        UserInfo: res.Data,
        HotelDto: res.Data.HotelDto,
        HasUserInfo: res.Data != null,
        RoleType: res.Data.RoleTypeFormat,
      });
      return res;
    },
    async Logout() {
      this.$patch({
        Token: null,
        UserInfo: null,
        RoleType: null,
        HasUserInfo: false,
        HotelDto: null,
      });
    },
    resetState() {
      this.$patch({
        Token: null,
        UserInfo: null,
        RoleType: undefined,
        HasUserInfo: false,
        HotelDto: null,
      });
    },
    async SetGlobalAddress(address) {
      this.$patch({
        GlobalAddress: address,
      });
    },
  },

  persist: {
    key: "common-store",
    storage: localStorage,
    paths: ["Token", "GlobalAddress"],
  },
});
