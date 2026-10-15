import { http } from '@kit.NetworkKit';

/**
 * 溪云谷园区环境卡数据（演示）
 * 数据源：外部天气接口（仅作演示）；失败或离线时回退内置 Mock，保证展示完整。
 */
interface WeatherData {
  city: string;
  temp: string;
  weather: string;
  humidity: string;
  wind: string;
}

/**
 * 英文风向 → 中文风向映射
 */
const windDirMap: Record<string, string> = {
  'N': '北风', 'NNE': '东北偏北', 'NE': '东北风', 'ENE': '东北偏东',
  'E': '东风', 'ESE': '东南偏东', 'SE': '东南风', 'SSE': '东南偏南',
  'S': '南风', 'SSW': '西南偏南', 'SW': '西南风', 'WSW': '西南偏西',
  'W': '西风', 'WNW': '西北偏西', 'NW': '西北风', 'NNW': '西北偏北'
};

@Component
export struct WeatherCard {
  @State weather: WeatherData = {
    city: '溪云谷',
    temp: '--',
    weather: '加载中...',
    humidity: '--',
    wind: '--'
  };
  @State isLoading: boolean = true;
  @State loadError: boolean = false;

  aboutToAppear(): void {
    this.fetchWeather();
  }

  /** 离线 / 接口失败时回退的演示环境数据 */
  applyMockWeather(): void {
    this.weather = {
      city: '溪云谷',
      temp: '27',
      weather: '多云',
      humidity: '65',
      wind: '东南风 12km/h'
    };
    this.isLoading = false;
    this.loadError = false;
  }

  fetchWeather(): void {
    let httpRequest = http.createHttp();
    // 演示数据源：取气候相近的南方城市；可替换为景区气象站 / 环境传感器聚合接口
    let url: string = 'https://wttr.in/Dongguan?format=j1&lang=zh';

    httpRequest.request(url, {
      method: http.RequestMethod.GET,
      connectTimeout: 10000,
      readTimeout: 10000,
    }).then((response) => {
      if (response.responseCode === 200) {
        let result: string = response.result as string;
        let data: Record<string, Object> = JSON.parse(result);
        this.parseWeatherData(data);
        this.isLoading = false;
      } else {
        this.applyMockWeather();
      }
    }).catch(() => {
      this.applyMockWeather();
    }).finally(() => {
      httpRequest.destroy();
    });
  }

  parseWeatherData(data: Record<string, Object>): void {
    try {
      let currentCondition: Record<string, Object>[] = data['current_condition'] as Record<string, Object>[];
      let condition: Record<string, Object> = currentCondition[0];

      // 天气描述（lang=zh 时 API 返回中文）
      let weatherDesc: string = '--';
      if (condition['weatherDesc']) {
        weatherDesc = (condition['weatherDesc'] as Record<string, Object>[])[0]['value'] as string;
      }

      // 风向翻译为中文
      let windDirEN: string = condition['winddir16Point'] as string;
      let windDirCN: string = windDirMap[windDirEN] ? windDirMap[windDirEN] : windDirEN;
      let windSpeed: string = condition['windspeedKmph'] as string;

      // 展示名为景区名（溪云谷），不展示第三方城市名
      this.weather = {
        city: '溪云谷',
        temp: condition['temp_C'] as string,
        weather: weatherDesc,
        humidity: condition['humidity'] as string,
        wind: windDirCN + ' ' + windSpeed + 'km/h'
      };
    } catch (e) {
      this.applyMockWeather();
    }
  }

  build() {
    Row() {
      // ── 温度和天气 ──
      Column() {
        Text(this.weather.temp + '°C')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        Text(this.weather.weather)
          .fontSize(12)
          .fontColor('rgba(255,255,255,0.85)')
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Start)

      // ── 景区名 ──
      Text(this.weather.city)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')

      // ── 详细信息 ──
      Column() {
        Text('湿度 ' + this.weather.humidity + '%')
          .fontSize(12)
          .fontColor('rgba(255,255,255,0.85)')
        Text('风向 ' + this.weather.wind)
          .fontSize(12)
          .fontColor('rgba(255,255,255,0.85)')
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.End)
    }
    .width('90%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 14, right: 14, top: 10, bottom: 10 })
    .borderRadius(12)
    .backgroundColor('rgba(0,0,0,0.35)')
  }
}