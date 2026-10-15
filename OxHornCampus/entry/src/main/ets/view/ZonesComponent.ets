import router from '@ohos.router';
import ZonesItem from '../viewmodel/ZonesItem';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { ZonesConstants as ZoneConst } from '../common/constants/ZonesConstants';
import { fetchDevices, DevSnapshot, DevProp } from '../common/utils/ApiService';
import { preferences } from '@kit.ArkData';

@Component
export struct Zones {
  private changedIndex: boolean = true;
  @Consume('allZones') @Watch('onZoneListChange') zonesList: ZonesItem[];
  @State aheadIndex: number = ZoneConst.HALF_COUNT;
  @State marginBottom: number = 0;
  @State visibleZones: ZonesItem[] = [];
  @State snapshots: DevSnapshot[] = [];

  aboutToAppear(): void {
    this.refreshVisibleZones();
    this.loadData();
  }

  onZoneListChange(): void { this.refreshVisibleZones(); }

  refreshVisibleZones(): void {
    this.visibleZones = this.zonesList.filter((z: ZonesItem): boolean => z.isVisible);
    if (this.aheadIndex >= this.visibleZones.length) {
      this.aheadIndex = Math.max(0, this.visibleZones.length - 1);
    }
  }

  loadData(): void {
    let pref = preferences.getPreferencesSync(getContext(this), { name: 'abox.xml' });
    let cookie: string = pref.getSync('cookie', '') as string;
    if (cookie.length === 0) return;
    fetchDevices(cookie).then((devs: DevSnapshot[]) => { this.snapshots = devs; }).catch(() => {});
  }

  getLiveText(z: ZonesItem): string {
    let s: DevSnapshot | undefined = this.snapshots.find((d: DevSnapshot): boolean => d.ieee === z.ieee);
    if (!s) return '加载中...';
    if (s.props.length > 0) {
      let lines: string[] = [];
      for (let j = 0; j < s.props.length; j++) {
        lines.push(s.props[j].name + ': ' + s.props[j].value);
      }
      return lines.join('    ');
    }
    return '电量 ' + s.battery + '%    信号 ' + s.rssi + ' dBm';
  }

  getImgCoefficients(index?: number): number {
    if (index === undefined) return 0;
    let coefficient = this.aheadIndex - index;
    let tempCoefficient = Math.abs(coefficient);
    if (tempCoefficient <= ZoneConst.HALF_COUNT) return coefficient;
    let dataLength = this.visibleZones.length;
    let tempOffset = dataLength - tempCoefficient;
    if (tempOffset <= ZoneConst.HALF_COUNT) return coefficient > 0 ? -tempOffset : tempOffset;
    return 0;
  }

  getOffSetY(index?: number): number {
    if (index === undefined) return 0;
    let offsetIndex = this.getImgCoefficients(index);
    let tempOffset = Math.abs(offsetIndex);
    let offsetY = this.marginBottom / (tempOffset + 1);
    if (tempOffset === 1) offsetY += -offsetIndex * ZoneConst.MAX_OFFSET_Y;
    else if (tempOffset === ZoneConst.HALF_COUNT) offsetY += -offsetIndex * (ZoneConst.MAX_OFFSET_Y - ZoneConst.OFFSET_COEFFICIENTS);
    return offsetY;
  }

  startAnimation(isUp: boolean): void {
    animateTo({ duration: Const.SWIPER_DURATION }, () => {
      let dataLength = this.visibleZones.length;
      this.aheadIndex = (isUp ? this.aheadIndex + 1 : dataLength + this.aheadIndex - 1) % dataLength;
      this.marginBottom = 0;
    });
  }

  handlePanGesture(offsetY: number): void {
    if (Math.abs(offsetY) < ZoneConst.MAX_MOVE_OFFSET) { this.marginBottom = offsetY; }
    else { if (this.changedIndex) return; this.changedIndex = true; this.startAnimation(offsetY < 0); }
  }

  build() {
    Column() {
      Row() { Text(Const.INTRODUCTION_TITLE).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#333333') }
      .width(Const.FULL_PERCENT).height(56).padding({ left: 16, top: 36 }).backgroundColor($r('app.color.common_background_color'))

      Stack() {
        ForEach(this.visibleZones, (item: ZonesItem, index?: number) => {
          Column() {
            // ── 实时数据区域 ──
            Column() {
              Text(this.getLiveText(item))
                .fontSize(18).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
                .maxLines(4).textOverflow({ overflow: TextOverflow.Ellipsis })
                .padding({ left: 20, right: 20, top: 16, bottom: 16 })
                .lineHeight(26)
                .width('100%')
            }
            .layoutWeight(1).width(Const.FULL_PERCENT).justifyContent(FlexAlign.Center)
            .backgroundColor(item.backgroundColor)
            .borderRadius({ topLeft: $r('app.float.common_border_radius'), topRight: $r('app.float.common_border_radius') })

            // ── 设备名称栏 ──
            Column() {
              Text(item.title as string)
                .fontSize(22).fontWeight(FontWeight.Bold).fontColor('#FFFFFF').maxLines(1)
                .letterSpacing(1)
                .textShadow({ radius: 6, color: 'rgba(0,0,0,0.4)', offsetX: 0, offsetY: 2 })
              Text(item.subTitle as string)
                .fontSize(16).fontColor('rgba(255,255,255,0.9)').maxLines(1).margin({ top: 8 })
                .fontWeight(FontWeight.Medium).letterSpacing(0.5)
            }
            .width(Const.FULL_PERCENT).padding({ left: 20, right: 20, top: 14, bottom: 18 })
            .backgroundColor(item.backgroundColor)
            .borderRadius({ bottomLeft: $r('app.float.common_border_radius'), bottomRight: $r('app.float.common_border_radius') })
          }
          .width(index !== this.aheadIndex && this.getImgCoefficients(index) === 0 ? Const.SWIPER_DEFAULT_WIDTH
            : `${ZoneConst.ITEM_WIDTH - ZoneConst.OFFSET_COEFFICIENTS * Math.abs(this.getImgCoefficients(index))}%`)
          .aspectRatio(Const.SWIPER_ASPECT_RATIO).borderRadius($r('app.float.common_border_radius'))
          .offset({ x: 0, y: this.getOffSetY(index) })
          .zIndex(index !== this.aheadIndex && this.getImgCoefficients(index) === 0 ? 0 : ZoneConst.HALF_COUNT - Math.abs(this.getImgCoefficients(index)))
          .shadow({ radius: Const.SHADOW_RADIUS, color: 'rgba(0,0,0,0.3)', offsetY: Const.SHADOW_RADIUS / Const.DOUBLE_NUM })
          .opacity(1 - Math.min(ZoneConst.HALF_COUNT, Math.abs(this.getImgCoefficients(index))) * ZoneConst.OPACITY_COEFFICIENTS)
          .blur(ZoneConst.OFFSET_COEFFICIENTS * Math.abs(this.getImgCoefficients(index)))
          .onClick(() => {
            router.pushUrl({ url: Const.INTRODUCTION_URL, params: { id: item.id } });
          })
        }, (item: ZonesItem) => item.id.toString())
      }
      .width(Const.FULL_PERCENT).layoutWeight(1).margin({ top: Const.SHADOW_RADIUS / Const.DOUBLE_NUM }).alignContent(Alignment.Center)
      .gesture(PanGesture({ direction: PanDirection.Vertical })
        .onActionStart((event: GestureEvent | undefined) => { if (!event) return; this.changedIndex = false; this.handlePanGesture(event.offsetY); })
        .onActionUpdate((event: GestureEvent | undefined) => { if (!event) return; this.handlePanGesture(event.offsetY); })
        .onActionEnd(() => { animateTo({ duration: Const.SWIPER_DURATION }, () => { this.marginBottom = 0; }); })
      )
    }
    .height(Const.FULL_PERCENT).width(Const.FULL_PERCENT).backgroundColor($r('app.color.common_background_color'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}