import router from '@ohos.router';
import alertsModel from '../viewmodel/AlertsModel';
import { AlertItem } from '../viewmodel/AlertsModel';

@Entry
@Component
struct AlertsPage {
  @State filterIndex: number = 0; // 0=待处理 1=全部
  @State alerts: AlertItem[] = [];

  aboutToAppear(): void {
    alertsModel.initDemoAlerts();
    this.refresh();
  }

  refresh(): void {
    if (this.filterIndex === 0) {
      this.alerts = alertsModel.getList().filter((it: AlertItem): boolean => it.status === 'unhandled');
    } else {
      this.alerts = alertsModel.getList();
    }
  }

  changeFilter(index: number): void {
    this.filterIndex = index;
    this.refresh();
  }

  doAction(id: number, status: string): void {
    alertsModel.setStatus(id, status);
    this.refresh();
    let msg: string = status === 'confirmed' ? '已确认' : '已忽略';
    this.getUIContext().getPromptAction().showToast({ message: msg });
  }

  levelColor(level: string): string {
    if (level === 'urgent') {
      return '#E90000';
    }
    if (level === 'normal') {
      return '#F5A623';
    }
    return '#007DFF';
  }

  levelText(level: string): string {
    if (level === 'urgent') {
      return '紧急';
    }
    if (level === 'normal') {
      return '一般';
    }
    return '提示';
  }

  statusText(status: string): string {
    if (status === 'confirmed') {
      return '已确认';
    }
    if (status === 'ignored') {
      return '已忽略';
    }
    return '待处理';
  }

  @Builder FilterChip(label: string, index: number) {
    Text(label)
      .fontSize(13)
      .fontColor(this.filterIndex === index ? '#FFFFFF' : '#666666')
      .backgroundColor(this.filterIndex === index ? '#007DFF' : '#F1F3F5')
      .padding({ left: 14, right: 14, top: 5, bottom: 5 })
      .borderRadius(12)
      .onClick(() => {
        this.changeFilter(index);
      })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_home_back'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        Text('告警中心')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 24 })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Row({ space: 12 }) {
        this.FilterChip('待处理', 0)
        this.FilterChip('全部', 1)
      }
      .width('100%')
      .padding({ left: 16, top: 8, bottom: 8 })
      .backgroundColor('#FFFFFF')

      if (this.alerts.length === 0) {
        Column() {
          Text('暂无告警')
            .fontSize(14)
            .fontColor('#999999')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 8 }) {
          ForEach(this.alerts, (item: AlertItem) => {
            ListItem() {
              Column() {
                Row() {
                  Text(this.levelText(item.level))
                    .fontSize(11)
                    .fontColor('#FFFFFF')
                    .backgroundColor(this.levelColor(item.level))
                    .borderRadius(4)
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  Text(item.title)
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                    .margin({ left: 8 })
                    .layoutWeight(1)
                  Text(item.time)
                    .fontSize(11)
                    .fontColor('#999999')
                }
                .width('100%')

                Text(item.area + ' · ' + item.device)
                  .fontSize(12)
                  .fontColor('#666666')
                  .width('100%')
                  .margin({ top: 6 })
                Text(item.desc)
                  .fontSize(12)
                  .fontColor('#888888')
                  .width('100%')
                  .margin({ top: 4 })
                  .lineHeight(18)

                if (item.status === 'unhandled') {
                  Row({ space: 12 }) {
                    Button('忽略')
                      .fontSize(13)
                      .height(32)
                      .layoutWeight(1)
                      .backgroundColor('#F1F3F5')
                      .fontColor('#666666')
                      .borderRadius(6)
                      .onClick(() => {
                        this.doAction(item.id, 'ignored');
                      })
                    Button('确认')
                      .fontSize(13)
                      .height(32)
                      .layoutWeight(1)
                      .backgroundColor('#007DFF')
                      .fontColor('#FFFFFF')
                      .borderRadius(6)
                      .onClick(() => {
                        this.doAction(item.id, 'confirmed');
                      })
                  }
                  .width('100%')
                  .margin({ top: 10 })
                } else {
                  Text(this.statusText(item.status))
                    .fontSize(11)
                    .fontColor('#999999')
                    .width('100%')
                    .textAlign(TextAlign.End)
                    .margin({ top: 8 })
                }
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#FFFFFF')
              .borderRadius(10)
            }
          }, (item: AlertItem) => item.id.toString())
        }
        .layoutWeight(1)
        .padding({ left: 12, right: 12, top: 4, bottom: 12 })
        .edgeEffect(EdgeEffect.None)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}