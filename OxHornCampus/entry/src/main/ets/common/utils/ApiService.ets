import CryptoJS from '@ohos/crypto-js'
import axios, { AxiosResponse } from '@ohos/axios'

const BASE = 'http://192.168.100.1';

/**
 * 演示模式开关：当景区网关不可达时，自动回退到内置 Mock 数据。
 * - true：无网关也能完整体验（简历 / 演示推荐，默认开启）
 * - false：仅连接真实网关，失败时返回空
 */
const DEMO_MODE_FALLBACK: boolean = true;

export class DevSnapshot {
  ieee: string = '';
  rname: string = '';
  maintype: string = '';
  battery: string = '';
  rssi: string = '';
  updateTime: string = '';
  status: string = '';
  power: string = '';
  props: DevProp[] = [];
}

export class DevProp {
  name: string = '';
  value: string = '';
  keyValue: string = '';
}

interface LoginUser { username: string; password: string }
interface Param { ieee: string }
interface SockCtrl { ieee: string; status: number }

// —— 演示用模拟开关状态（离线演示时记录本地状态）——
const mockSockStatus: Record<string, string> = {};

function pad2(n: number): string {
  return n < 10 ? '0' + n.toString() : n.toString();
}

function nowText(): string {
  let d = new Date();
  return d.getFullYear().toString() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate()) +
    ' ' + pad2(d.getHours()) + ':' + pad2(d.getMinutes());
}

/**
 * 内置演示设备（IEEE 与 viewmodel/ZonesViewModel.ets 一一对应）
 */
function buildMockDevices(): DevSnapshot[] {
  let list: DevSnapshot[] = [];

  // 1. 智能插座（可控）
  let sock: DevSnapshot = new DevSnapshot();
  sock.ieee = '1c1cfd001dba1ac2';
  sock.rname = '智能插座';
  sock.maintype = 'sock';
  sock.battery = '86';
  sock.rssi = '-52';
  sock.updateTime = nowText();
  sock.status = mockSockStatus[sock.ieee] ?? '1';
  sock.power = sock.status === '1' ? '86.5' : '0.0';
  list.push(sock);

  // 2. 标准 SOS
  let sos: DevSnapshot = new DevSnapshot();
  sos.ieee = '0c4314fffe26a437';
  sos.rname = '标准 SOS';
  sos.maintype = 'sos';
  sos.battery = '90';
  sos.rssi = '-58';
  sos.updateTime = nowText();
  sos.status = '1';
  let sosProp: DevProp = new DevProp();
  sosProp.name = '求救状态';
  sosProp.value = '正常';
  sos.props = [sosProp];
  list.push(sos);

  // 3. 标准人体活动传感器
  let human: DevSnapshot = new DevSnapshot();
  human.ieee = '00158d000448fe59';
  human.rname = '标准人体活动传感器';
  human.maintype = 'env';
  human.battery = '72';
  human.rssi = '-64';
  human.updateTime = nowText();
  human.status = '1';
  let humanProp: DevProp = new DevProp();
  humanProp.name = '人体活动';
  humanProp.value = '无人';
  human.props = [humanProp];
  list.push(human);

  // 4. 标准水浸传感器
  let water: DevSnapshot = new DevSnapshot();
  water.ieee = '5c0272fffef084db';
  water.rname = '标准水浸传感器';
  water.maintype = 'env';
  water.battery = '81';
  water.rssi = '-61';
  water.updateTime = nowText();
  water.status = '1';
  let waterProp: DevProp = new DevProp();
  waterProp.name = '水浸状态';
  waterProp.value = '正常';
  water.props = [waterProp];
  list.push(water);

  // 5. 标准温湿度传感器
  let env: DevSnapshot = new DevSnapshot();
  env.ieee = 'b4e3f9fffe3264cb';
  env.rname = '标准温湿度传感器';
  env.maintype = 'env';
  env.battery = '95';
  env.rssi = '-48';
  env.updateTime = nowText();
  env.status = '1';
  let tempProp: DevProp = new DevProp();
  tempProp.name = '温度';
  tempProp.value = '26.5 ℃';
  let humiProp: DevProp = new DevProp();
  humiProp.name = '湿度';
  humiProp.value = '62 %';
  let pmProp: DevProp = new DevProp();
  pmProp.name = 'PM2.5';
  pmProp.value = '18 μg/m³';
  env.props = [tempProp, humiProp, pmProp];
  list.push(env);

  // 6. 标准门磁传感器
  let door: DevSnapshot = new DevSnapshot();
  door.ieee = 'a46dd4fffeed955a';
  door.rname = '标准门磁传感器';
  door.maintype = 'env';
  door.battery = '77';
  door.rssi = '-66';
  door.updateTime = nowText();
  door.status = '1';
  let doorProp: DevProp = new DevProp();
  doorProp.name = '门窗状态';
  doorProp.value = '已关闭';
  door.props = [doorProp];
  list.push(door);

  return list;
}

/**
 * 登录，返回 Cookie 字符串
 */
export async function doLogin(): Promise<string> {
  let url: string = BASE + '/api/user/login';
  let body: LoginUser = {
    username: 'admin',
    password: CryptoJS.MD5('a').toString()
  };
  let resp: AxiosResponse = await axios.post(url, body, {
    timeout: 5000,
    headers: { 'Content-Type': 'application/json' }
  });
  if (resp.data.code !== '0000000') return '';
  let cookies: string[] = resp.headers['set-cookie'] as string[];
  return cookies[cookies.length - 1] ?? '';
}

/**
 * 获取所有设备（需传入 Cookie）。
 * 网关不可达时：演示模式回退 Mock，保证离线可完整体验。
 */
export async function fetchDevices(cookie: string): Promise<DevSnapshot[]> {
  try {
    let url: string = BASE + '/api/room/allDevAndProcess';
    let body: Param = { ieee: '' };
    let resp: AxiosResponse = await axios.post(url, body, {
      timeout: 5000,
      headers: { 'Content-Type': 'application/json', 'cookie': cookie }
    });
    let j: Record<string, Object> = resp.data as Record<string, Object>;
    if (j['code'] !== '0000000') {
      if (DEMO_MODE_FALLBACK) return buildMockDevices();
      return [];
    }

    let data: Record<string, Object> = j['data'] as Record<string, Object>;
    if (Array.isArray(data)) {
      if (DEMO_MODE_FALLBACK) return buildMockDevices();
      return [];
    }

    let di: Record<string, Object> = data['deviceInfos'] as Record<string, Object>;
    let socks: Record<string, Object>[] = (di['socks'] as Record<string, Object>[]) ?? [];
    let envs: Record<string, Object>[] = (di['envs'] as Record<string, Object>[]) ?? [];

    let result: DevSnapshot[] = [];

    for (let i = 0; i < socks.length; i++) {
      let raw: Record<string, Object> = socks[i];
      let d: DevSnapshot = new DevSnapshot();
      d.ieee = (raw['ieee'] as string) ?? '';
      d.rname = (raw['rname'] as string) ?? '';
      d.maintype = (raw['maintype'] as string) ?? '';
      d.battery = (raw['battery'] as string) ?? '';
      d.rssi = (raw['rssi'] as string) ?? '';
      d.updateTime = (raw['updateTime'] as string) ?? '';
      d.status = (raw['status'] as string) ?? '';
      d.power = (raw['power'] as string) ?? '';
      result.push(d);
    }

    for (let i = 0; i < envs.length; i++) {
      let raw: Record<string, Object> = envs[i];
      let d: DevSnapshot = new DevSnapshot();
      d.ieee = (raw['ieee'] as string) ?? '';
      d.rname = (raw['rname'] as string) ?? '';
      d.maintype = (raw['maintype'] as string) ?? '';
      d.battery = (raw['battery'] as string) ?? '';
      d.rssi = (raw['rssi'] as string) ?? '';
      d.updateTime = (raw['updateTime'] as string) ?? '';
      d.status = (raw['status'] as string) ?? '';
      d.power = (raw['power'] as string) ?? '';
      let ps: Record<string, Object>[] = (raw['properties'] as Record<string, Object>[]) ?? [];
      for (let j = 0; j < ps.length; j++) {
        let p: DevProp = new DevProp();
        p.name = (ps[j]['name'] as string) ?? '';
        p.value = (ps[j]['value'] as string) ?? '';
        p.keyValue = (ps[j]['keyValue'] as string) ?? '';
        d.props.push(p);
      }
      result.push(d);
    }

    return result;
  } catch (e) {
    // 网关不可达 / 网络异常：演示模式回退 Mock
    if (DEMO_MODE_FALLBACK) return buildMockDevices();
    return [];
  }
}

/**
 * 控制智能插座开关
 * @param cookie 登录 Cookie
 * @param ieee 插座 IEEE 地址
 * @param status 1=开, 0=关
 */
export async function toggleSocket(cookie: string, ieee: string, status: number): Promise<string> {
  try {
    let url: string = BASE + '/api/terminal/zigbee/sock/ctrl';
    let body: SockCtrl = { ieee: ieee, status: status };
    let resp: AxiosResponse = await axios.post(url, body, {
      timeout: 5000,
      headers: { 'Content-Type': 'application/json', 'cookie': cookie }
    });
    if (resp.data.code === '0000000') return 'OK';
    return resp.data.msg ?? '操作失败';
  } catch (e) {
    // 网关不可达：演示模式本地模拟成功，保证无网关也能演示控制链路
    if (DEMO_MODE_FALLBACK) {
      mockSockStatus[ieee] = status.toString();
      return 'OK';
    }
    return '控制失败';
  }
}