/**
 * 告警数据模型（演示版）。
 * 真实场景下告警来自网关/平台推送；当前为内置演示数据，保存在内存 + AppStorage 未读数。
 */

export class AlertItem {
  id: number = 0;
  level: string = 'info';        // urgent | normal | info
  title: string = '';
  area: string = '';
  device: string = '';
  time: string = '';
  desc: string = '';
  status: string = 'unhandled';  // unhandled | confirmed | ignored
}

class AlertsModel {
  private list: AlertItem[] = [];
  private initialized: boolean = false;

  initDemoAlerts(): void {
    if (this.initialized) {
      return;
    }
    this.initialized = true;
    this.list = [
      {
        id: 1,
        level: 'urgent',
        title: '水浸告警',
        area: 'C区 · 地下车库',
        device: '标准水浸传感器',
        time: '今日 02:14',
        desc: '触发水浸报警，请尽快到现场核查排水，避免积水扩散。',
        status: 'unhandled'
      },
      {
        id: 2,
        level: 'normal',
        title: '设备离线',
        area: 'A区 · 游客中心',
        device: '智能插座',
        time: '今日 08:02',
        desc: '设备已 15 分钟未上报数据，请检查供电与网络。',
        status: 'unhandled'
      },
      {
        id: 3,
        level: 'normal',
        title: '低电量提醒',
        area: 'E区 · 设备仓库',
        device: '标准门磁传感器',
        time: '昨日 21:40',
        desc: '电池电量低于 20%，建议本周内更换电池。',
        status: 'unhandled'
      },
      {
        id: 4,
        level: 'info',
        title: '环境告警已恢复',
        area: 'D区 · 温室花园',
        device: '标准温湿度传感器',
        time: '今日 07:15',
        desc: '凌晨高温告警已自动恢复，当前温湿度正常。',
        status: 'confirmed'
      },
      {
        id: 5,
        level: 'info',
        title: 'SOS 巡检正常',
        area: 'A区 · 游客中心',
        device: '标准 SOS',
        time: '昨日 16:00',
        desc: 'SOS 一键巡检完成，设备响应正常。',
        status: 'ignored'
      }
    ];
    this.syncCount();
  }

  getList(): AlertItem[] {
    return this.list;
  }

  unhandledCount(): number {
    let n: number = 0;
    this.list.forEach((it: AlertItem) => {
      if (it.status === 'unhandled') {
        n++;
      }
    });
    return n;
  }

  setStatus(id: number, status: string): void {
    this.list.forEach((it: AlertItem) => {
      if (it.id === id) {
        it.status = status;
      }
    });
    this.syncCount();
  }

  syncCount(): void {
    AppStorage.setOrCreate<number>('alertUnread', this.unhandledCount());
  }
}

let alertsModel = new AlertsModel();
export default alertsModel as AlertsModel;