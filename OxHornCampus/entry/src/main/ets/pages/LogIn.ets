import { preferences } from '@kit.ArkData';

@Entry
@Component
struct LogIn {
  @State username: string = 'admin';
  @State password: string = 'a';
  @State loading: boolean = false;

  doLogin(): void {
    this.loading = true;
    // 演示模式：跳过网关网络请求，直接模拟登录成功。
    // 接入真实网关时，可改为调用 ApiService.doLogin() 并保存返回的 Cookie。
    let pref = preferences.getPreferencesSync(
      this.getUIContext().getHostContext(), { name: 'abox.xml' }
    );
    pref.clearSync();
    pref.putSync('cookie', 'mock-cookie-for-demo');
    pref.flushSync();

    this.loading = false;
    this.getUIContext().getPromptAction().showToast({ message: '登录成功' });
    this.getUIContext().getRouter().replaceUrl({ url: 'pages/MainPage' });
  }

  build() {
    Column({ space: 20 }) {
      Blank()
      Text('溪云智管').fontSize(32).fontWeight(FontWeight.Bold).fontColor('#333333').margin({ top: 60 })
      Text('欢迎使用景区设施管理系统').fontSize(15).fontColor('#999999').margin({ bottom: 20 })
      TextInput({ placeholder: '用户名', text: $$this.username }).width('80%')
      TextInput({ placeholder: '密码', text: $$this.password }).type(InputType.Password).width('80%')
      Row() {
        Checkbox().select(true).shape(CheckBoxShape.ROUNDED_SQUARE)
        Text('请同意信息安全使用协议').fontColor(Color.Blue)
      }
      Button(this.loading ? '登录中...' : '登录').width('80%').onClick(() => { this.doLogin(); })
      Text('演示版：默认免网关登录，可直接体验').fontSize(12).fontColor('#BBBBBB').margin({ top: 4 })
      Blank()
    }
    .height('100%').width('100%').backgroundColor('#F5F5F5').expandSafeArea([SafeAreaType.SYSTEM])
  }
}