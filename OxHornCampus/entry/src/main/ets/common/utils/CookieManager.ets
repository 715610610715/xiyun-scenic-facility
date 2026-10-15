export class CookieManager {
  static cookie: string = '';

  static getCookie(): string {
    return CookieManager.cookie;
  }

  static hasCookie(): boolean {
    return CookieManager.cookie.length > 0;
  }
}
