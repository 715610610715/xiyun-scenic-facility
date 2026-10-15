/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ZonesItem from './ZonesItem';

class ZonesViewModel {
  getZonesList(): ZonesItem[] {
    return defaultList;
  }

  getZonesByIndex(index: number): ZonesItem {
    return defaultList[index];
  }

  toggleZoneVisibility(zones: ZonesItem[], id: number): ZonesItem[] {
    return zones.map((z: ZonesItem): ZonesItem => {
      if (z.id === id) {
        let updated: ZonesItem = new ZonesItem();
        updated.id = z.id;
        updated.title = z.title;
        updated.subTitle = z.subTitle;
        updated.createTime = z.createTime;
        updated.content = z.content;
        updated.thumbnail = z.thumbnail;
        updated.swiperPic = z.swiperPic;
        updated.subPicTop = z.subPicTop;
        updated.subPicBottom = z.subPicBottom;
        updated.titleIcon = z.titleIcon;
        updated.imageList = z.imageList;
        updated.buildingInformation = z.buildingInformation;
        updated.buildingPic = z.buildingPic;
        updated.geographyPic = z.geographyPic;
        updated.geographyPicLight = z.geographyPicLight;
        updated.backgroundColor = z.backgroundColor;
        updated.starLinePic = z.starLinePic;
        updated.isVisible = !z.isVisible;
        updated.ieee = z.ieee;
        return updated;
      }
      return z;
    });
  }
}

let zonesViewModel = new ZonesViewModel();

export default zonesViewModel as ZonesViewModel;

const defaultList: ZonesItem[] = [
  {
    id: 0,
    title: '智能插座',
    subTitle: '电源控制设备',
    area: 'A区 · 游客中心',
    thumbnail: $r('app.media.ic_thumbnail_a'),
    swiperPic: $r('app.media.ic_A'),
    createTime: '2024',
    content: ['智能插座，支持远程开关控制、定时任务和电量统计功能。'],
    subPicTop: $r('app.media.ic_A_photo_top'),
    subPicBottom: $r('app.media.ic_A_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_A'),
    imageList: [$r('app.media.ic_A_1')],
    buildingInformation: 'IEEE: 1c1cfd001dba1ac2',
    buildingPic: $r('app.media.ic_building_A'),
    geographyPic: $r('app.media.ic_geography_dark_A'),
    geographyPicLight: $r('app.media.ic_geography_lighter_A'),
    backgroundColor: '#346B41',
    starLinePic: [$r('app.media.ic_starLine_A_light')],
    isVisible: true,
    ieee: '1c1cfd001dba1ac2',
  },
  {
    id: 1,
    title: '标准 SOS',
    subTitle: '紧急求救设备',
    area: 'A区 · 游客中心',
    thumbnail: $r('app.media.ic_thumbnail_b'),
    swiperPic: $r('app.media.ic_B'),
    createTime: '2024',
    content: ['标准SOS紧急按钮，一键触发报警。'],
    subPicTop: $r('app.media.ic_B_photo_top'),
    subPicBottom: $r('app.media.ic_B_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_B'),
    imageList: [$r('app.media.ic_B_1')],
    buildingInformation: 'IEEE: 0c4314fffe26a437',
    buildingPic: $r('app.media.ic_building_B'),
    geographyPic: $r('app.media.ic_geography_dark_B'),
    geographyPicLight: $r('app.media.ic_geography_lighter_B'),
    backgroundColor: '#82B9FB',
    starLinePic: [$r('app.media.ic_starLine_B_light')],
    isVisible: true,
    ieee: '0c4314fffe26a437',
  },
  {
    id: 2,
    title: '标准人体活动传感器',
    subTitle: '人体检测设备',
    area: 'B区 · 湖畔餐厅',
    thumbnail: $r('app.media.ic_thumbnail_c'),
    swiperPic: $r('app.media.ic_C'),
    createTime: '2024',
    content: ['实时检测人体移动，支持联动场景触发。'],
    subPicTop: $r('app.media.ic_C_photo_top'),
    subPicBottom: $r('app.media.ic_C_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_C'),
    imageList: [$r('app.media.ic_C_1')],
    buildingInformation: 'IEEE: 00158d000448fe59',
    buildingPic: $r('app.media.ic_building_C'),
    geographyPic: $r('app.media.ic_geography_dark_C'),
    geographyPicLight: $r('app.media.ic_geography_lighter_C'),
    backgroundColor: '#84C6E2',
    starLinePic: [$r('app.media.ic_starLine_C_light')],
    isVisible: true,
    ieee: '00158d000448fe59',
  },
  {
    id: 3,
    title: '标准水浸传感器',
    subTitle: '漏水检测设备',
    area: 'C区 · 地下车库',
    thumbnail: $r('app.media.ic_thumbnail_d'),
    swiperPic: $r('app.media.ic_D'),
    createTime: '2024',
    content: ['实时监测漏水情况，及时预警防止水患损失。'],
    subPicTop: $r('app.media.ic_D_photo_top'),
    subPicBottom: $r('app.media.ic_D_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_D'),
    imageList: [$r('app.media.ic_D_1')],
    buildingInformation: 'IEEE: 5c0272fffef084db',
    buildingPic: $r('app.media.ic_building_D'),
    geographyPic: $r('app.media.ic_geography_dark_D'),
    geographyPicLight: $r('app.media.ic_geography_lighter_D'),
    backgroundColor: '#8EA9D2',
    starLinePic: [$r('app.media.ic_starLine_D_light')],
    isVisible: true,
    ieee: '5c0272fffef084db',
  },
  {
    id: 4,
    title: '标准温湿度传感器',
    subTitle: '环境监测设备',
    area: 'D区 · 温室花园',
    thumbnail: $r('app.media.ic_thumbnail_e'),
    swiperPic: $r('app.media.ic_E'),
    createTime: '2024',
    content: ['实时采集环境温湿度数据，支持阈值报警。'],
    subPicTop: $r('app.media.ic_E_photo_top'),
    subPicBottom: $r('app.media.ic_E_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_E'),
    imageList: [$r('app.media.ic_E_1')],
    buildingInformation: 'IEEE: b4e3f9fffe3264cb',
    buildingPic: $r('app.media.ic_building_E'),
    geographyPic: $r('app.media.ic_geography_dark_E'),
    geographyPicLight: $r('app.media.ic_geography_lighter_E'),
    backgroundColor: '#B88668',
    starLinePic: [$r('app.media.ic_starLine_E_lighter')],
    isVisible: true,
    ieee: 'b4e3f9fffe3264cb',
  },
  {
    id: 5,
    title: '标准门磁传感器',
    subTitle: '门窗检测设备',
    area: 'E区 · 设备仓库',
    thumbnail: $r('app.media.ic_thumbnail_f'),
    swiperPic: $r('app.media.ic_F'),
    createTime: '2024',
    content: ['实时检测门窗开关状态，适用于安防场景。'],
    subPicTop: $r('app.media.ic_F_photo_top'),
    subPicBottom: $r('app.media.ic_F_photo_bottom'),
    titleIcon: $r('app.media.ic_title_top_F'),
    imageList: [$r('app.media.ic_F_1')],
    buildingInformation: 'IEEE: a46dd4fffeed955a',
    buildingPic: $r('app.media.ic_building_F'),
    geographyPic: $r('app.media.ic_geography_lighter_F'),
    geographyPicLight: $r('app.media.ic_geography_lighter_F'),
    backgroundColor: '#E5A77D',
    starLinePic: [$r('app.media.ic_starLine_F_lighter')],
    isVisible: true,
    ieee: 'a46dd4fffeed955a',
  }
];