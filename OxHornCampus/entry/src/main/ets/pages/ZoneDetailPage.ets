import router from '@ohos.router';
import ZonesItem from '../viewmodel/ZonesItem';
import zonesViewModel from '../viewmodel/ZonesViewModel';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { fetchDevices, toggleSocket, DevSnapshot, DevProp } from '../common/utils/ApiService';
import { preferences } from '@kit.ArkData';

@Entry
@Component
struct ZoneDetailPage {
  @State device: ZonesItem = new ZonesItem();
  @State loaded: boolean = false;
  @State loading: boolean = true;
  @State err: string = '';
  @State snap: DevSnapshot | null = null;
  @State toggling: boolean = false;

  pageTransition() {
    PageTransitionEnter({ duration: 300, curve: Curve.EaseOut }).slide(SlideEffect.Right)
    PageTransitionExit({ duration: 300, curve: Curve.EaseOut }).slide(SlideEffect.Right)
  }

  aboutToAppear(): void {
    let p = router.getParams() as Record<string, Object>;
    if (!p || p.id === undefined) return;
    let found = zonesViewModel.getZonesList().find((z: ZonesItem): boolean => z.id === (p.id as number));
    if (!found) return;
    this.device = found;
    this.loaded = true;
    this.loadData();
  }

  loadData(): void {
    this.loading = true;
    let pref = preferences.getPreferencesSync(getContext(this), { name: 'abox.xml' });
    let cookie: string = pref.getSync('cookie', '') as string;
    if (cookie.length === 0) { this.err = '未登录'; this.loading = false; return; }

    fetchDevices(cookie).then((devs: DevSnapshot[]) => {
      this.loading = false;
      let m = devs.find((d: DevSnapshot): boolean => d.ieee === this.device.ieee);
      if (m) this.snap = m;
      else this.err = '未找到设备\n期望:' + this.device.ieee + '\n共' + devs.length + '个设备';
    }).catch(() => { this.loading = false; this.err = '网络错误'; });
  }

  /** 控制插座开关 */
  switchSocket(newStatus: number): void {
    this.toggling = true;
    let pref = preferences.getPreferencesSync(getContext(this), { name: 'abox.xml' });
    let cookie: string = pref.getSync('cookie', '') as string;

    toggleSocket(cookie, this.device.ieee, newStatus).then((result: string) => {
      this.toggling = false;
      if (result === 'OK') {
        // 刷新数据
        this.loadData();
        this.getUIContext().getPromptAction().showToast({ message: newStatus === 1 ? '插座已开启' : '插座已关闭' });
      } else {
        this.getUIContext().getPromptAction().showToast({ message: result });
      }
    }).catch(() => {
      this.toggling = false;
      this.getUIContext().getPromptAction().showToast({ message: '控制失败' });
    });
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_home_back')).width(24).height(24).onClick(() => { router.back(); })
        Text(this.device.title as string).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
          .layoutWeight(1).textAlign(TextAlign.Center).margin({ right: 24 })
      }.width(Const.FULL_PERCENT).height(56).padding({ left: 16, right: 16 }).backgroundColor(this.device.backgroundColor as string)

      if (this.loading) {
        Column() { LoadingProgress().width(40).height(40).color('#007DFF') }.layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.snap) {
        Scroll() {
          Column() {
            if (this.device.area.length > 0) {
              Row() {
                Text('所属区域').fontSize(11).fontColor('#007DFF')
                Text(this.device.area).fontSize(13).fontWeight(FontWeight.Medium).fontColor('#333333').margin({ left: 8 })
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .margin({ left: 12, right: 12, top: 12, bottom: 4 })
            }
            // 智能插座：开关控制
            if (this.device.id === 0) {
              Column() {
                Text(this.snap!.status === '1' ? '当前状态：已开启' : '当前状态：已关闭')
                  .fontSize(16).fontWeight(FontWeight.Bold)
                  .fontColor(this.snap!.status === '1' ? '#35B83C' : '#E90000')
                  .margin({ bottom: 16 })

                Row({ space: 12 }) {
                  Button('关闭').fontSize(15).height(44).layoutWeight(1)
                    .backgroundColor('#E90000').borderRadius(8)
                    .enabled(this.snap!.status === '1' && !this.toggling)
                    .opacity(this.snap!.status === '1' ? 1 : 0.4)
                    .onClick(() => { this.switchSocket(0); })

                  Button('开启').fontSize(15).height(44).layoutWeight(1)
                    .backgroundColor('#35B83C').borderRadius(8)
                    .enabled(this.snap!.status !== '1' && !this.toggling)
                    .opacity(this.snap!.status !== '1' ? 1 : 0.4)
                    .onClick(() => { this.switchSocket(1); })
                }.width('100%')

                if (this.snap!.power.length > 0 && this.snap!.power !== '0.0') {
                  Text('功率：' + this.snap!.power + ' W').fontSize(13).fontColor('#999').margin({ top: 12 })
                }
              }
              .width('100%').padding(20).backgroundColor('#FFFFFF').borderRadius(8)
              .margin({ left: 12, right: 12, top: 12, bottom: 8 })
            }

            // 设备状态
            Column() {
              Text('● 在线').fontSize(16).fontWeight(FontWeight.Medium).fontColor('#35B83C')
              Row({ space: 20 }) {
                Column() { Text('电量').fontSize(12).fontColor('#999'); Text(this.snap!.battery + '%').fontSize(16).fontWeight(FontWeight.Bold).margin({ top: 4 }) }
                Column() { Text('信号').fontSize(12).fontColor('#999'); Text(this.snap!.rssi + 'dBm').fontSize(16).fontWeight(FontWeight.Bold).margin({ top: 4 }) }
              }.width('100%').margin({ top: 12 })
            }.width('100%').padding(16).backgroundColor('#FFFFFF').borderRadius(8).margin({ left: 12, right: 12, bottom: 8 })

            // 传感器属性
            if (this.snap!.props.length > 0) {
              Column() {
                Text('传感器属性').fontSize(16).fontWeight(FontWeight.Bold).margin({ bottom: 12 }).width('100%')
                ForEach(this.snap!.props, (p: DevProp) => {
                  Row() {
                    Text(p.name).fontSize(14).fontColor('#666').layoutWeight(1)
                    Text(p.value).fontSize(14).fontWeight(FontWeight.Medium).fontColor('#007DFF')
                  }.width('100%').margin({ bottom: 12 })
                }, (pp: DevProp) => pp.name)
              }.width('100%').padding(16).backgroundColor('#FFFFFF').borderRadius(8).margin({ left: 12, right: 12, bottom: 8 })
            }
          }
        }.layoutWeight(1).edgeEffect(EdgeEffect.None).backgroundColor('#F1F3F5')
      } else {
        Column() {
          Text(this.err).fontSize(13).fontColor('#E90000').padding(20).lineHeight(20)
          Button('重试').fontSize(14).width(120).height(40).backgroundColor('#007DFF').borderRadius(8).margin({ top: 12 })
            .onClick(() => { this.err = ''; this.loadData(); })
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      }
    }.height(Const.FULL_PERCENT).width(Const.FULL_PERCENT).backgroundColor('#F1F3F5')
  }
}