import { CommonConstants as Const } from '../common/constants/CommonConstants';
import ZonesItem from '../viewmodel/ZonesItem';
import ZonesViewModel from '../viewmodel/ZonesViewModel';
import alertsModel from '../viewmodel/AlertsModel';

@Component
export struct ProfilePage {
  @Consume('allZones') allZones: ZonesItem[];
  @State userName: string = 'admin';
  @StorageProp('alertUnread') alertUnread: number = 0;

  aboutToAppear(): void {
    alertsModel.initDemoAlerts();
  }

  build() {
    Column() {
      // ── 用户信息区域 ──
      Column() {
        Text(this.userName)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Text('欢迎使用景区设施管理')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .width(Const.FULL_PERCENT)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 20, top: 48, bottom: 16 })
      .backgroundColor('#FFFFFF')

      // ── 分隔线 ──
      Divider()
        .strokeWidth(8)
        .color('#F1F3F5')

      // ── 告警中心入口 ──
      Row() {
        Column() {
          Text('告警中心')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
          Text('离线 / 低电量 / 水浸 / SOS 处理')
            .fontSize(11)
            .fontColor('#999999')
            .margin({ top: 3 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        if (this.alertUnread > 0) {
          Text(this.alertUnread.toString())
            .fontSize(11)
            .fontColor('#FFFFFF')
            .backgroundColor('#E90000')
            .borderRadius(9)
            .width(18)
            .height(18)
            .textAlign(TextAlign.Center)
        } else {
          Text('无未处理')
            .fontSize(11)
            .fontColor('#BBBBBB')
        }
        Text('>')
          .fontSize(14)
          .fontColor('#CCCCCC')
          .margin({ left: 8 })
      }
      .width(Const.FULL_PERCENT)
      .padding({ left: 20, right: 20, top: 14, bottom: 14 })
      .backgroundColor('#FFFFFF')
      .onClick(() => {
        this.getUIContext().getRouter().pushUrl({ url: 'pages/AlertsPage' });
      })

      // ── 分隔线 ──
      Divider()
        .strokeWidth(8)
        .color('#F1F3F5')

      // ── 设备显示设置 ──
      Row() {
        Text('设备显示设置')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Blank()
        Text(`${this.getVisibleCount()} / ${this.allZones.length} 个显示`)
          .fontSize(12)
          .fontColor('#999999')
      }
      .width(Const.FULL_PERCENT)
      .padding({ left: 20, right: 20, top: 16, bottom: 12 })

      // ── 设备列表 + 显示开关 ──
      List({ space: 8 }) {
        ForEach(this.allZones, (item: ZonesItem, index: number) => {
          ListItem() {
            Row() {
              Image(item.thumbnail)
                .width(48)
                .height(48)
                .borderRadius(8)
                .objectFit(ImageFit.Cover)

              Column() {
                Text(item.title as string)
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                Text(item.subTitle as string)
                  .fontSize(11)
                  .fontColor('#999999')
                  .margin({ top: 2 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
              .layoutWeight(1)

              Toggle({ type: ToggleType.Switch, isOn: item.isVisible })
                .onChange((isOn: boolean) => {
                  this.allZones = ZonesViewModel.toggleZoneVisibility(this.allZones, item.id);
                })
            }
            .width(Const.FULL_PERCENT)
            .padding({ left: 16, right: 16, top: 10, bottom: 10 })
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
          }
        }, (item: ZonesItem) => item.id.toString())
      }
      .layoutWeight(1)
      .padding({ left: 12, right: 12, top: 8 })
      .edgeEffect(EdgeEffect.None)
    }
    .height(Const.FULL_PERCENT)
    .width(Const.FULL_PERCENT)
    .backgroundColor('#F1F3F5')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  getVisibleCount(): number {
    return this.allZones.filter((z: ZonesItem): boolean => z.isVisible).length;
  }
}