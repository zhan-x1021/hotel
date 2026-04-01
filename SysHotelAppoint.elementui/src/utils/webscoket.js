import { useCommonStore } from "@/store";
import { ElNotification } from "element-plus";
let wsObj = null;

let wbSocket = {
  isConnectState: false,
  onMessageMonitorList: [],
};

/**
 * 添加消息监听
 * @param {Object} id 唯一标识
 * @param {Object} callback 回调方法
 */
export function AddSocketMessageMonitor(id, callback) {
  console.log("添加消息监听id:" + id);
  wbSocket.onMessageMonitorList.push({
    id: id,
    callback: callback,
  });
}
/**
 * 移除消息监听
 * @param {Object} id 唯一标识
 */
export function RemoveSocketMessageMonitor(id) {
  console.log("移除消息监听id:" + id);
  wbSocket.onMessageMonitorList = wbSocket.onMessageMonitorList.filter(
    (x) => x.id != id
  );
}

//初始化websocket
export async function RetryConnect(timeout = 2000) {
  const commonStore = useCommonStore();

  setTimeout(async () => {
    if (commonStore.UserId && wbSocket.isConnectState == false) {
      const wsUrl =
        import.meta.env.VITE_WS_BASE_URL + "/webscoket/" + commonStore.UserId;
      wsObj = new WebSocket(wsUrl);

      wsObj.onmessage = (res) => {
        wbSocket.onMessageMonitorList.forEach((monitor) => {
          let socketMessage = JSON.parse(res.data);

          monitor.callback({
            Type: socketMessage.Type,
            Data: JSON.parse(socketMessage.Data),
          });
        });
      };
      wsObj.onopen = (event) => {
        wbSocket.isConnectState = true;

        ElNotification.success({
          title: "webscoket提示",
          message: "wb连接成功",
          duration: 500,
        });
      };
      wsObj.onclose = (event) => {
        wbSocket.isConnectState = false;
        ElNotification.error({
          title: "webscoket提示",
          message: "wb连接关闭",
          duration: 500,
        });

        // 销毁 WebSocket 对象
        wsObj.onmessage = null;
        wsObj.onopen = null;
        wsObj.onclose = null;
        wsObj.onerror = null;
        wsObj = null;
      };
    } else if (!commonStore.UserId && wbSocket.isConnectState) {
      wsObj.close();
      wbSocket.isConnectState = false;
      wbSocket.onMessageMonitorList = [];
    } else {
    }
    //保持检测
    RetryConnect();
  }, timeout);
}

//发送消息
export async function SendMessage(type, data) {
  let message = {
    Type: type,
    Data: JSON.stringify(data),
  };
  wsObj.send(JSON.stringify(message));
}
//手动关闭websocket
export async function CloseWebScoket(type, data) {
  if (wsObj) {
    wsObj.close();
  }
}

export default {
  AddSocketMessageMonitor,
  RetryConnect,
  SendMessage,
  CloseWebScoket,
  RemoveSocketMessageMonitor,
};
