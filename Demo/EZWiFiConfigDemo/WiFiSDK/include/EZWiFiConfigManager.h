//
//  EZWiFiConfigManager.h
//  EZOpenSDK
//
//  Copyright © 2020年. All rights reserved.

#import <Foundation/Foundation.h>
#import "EZWiFiItemInfo.h"
#import "EZAPDevInfo.h"
#import "EZConfigTokenInfo.h"

/* 配网方式 */
typedef NS_ENUM(NSInteger, EZWiFiConfigMode)
{
    EZWiFiConfigSmart = 1 << 0,     //smart config
    EZWiFiConfigSonic = 1 << 1,     //声波配网
};

/* WiFi配网设备状态 */
typedef NS_ENUM(NSInteger, EZWifiConfigStatus)
{
    EZWifiConfigConnecting,   //设备正在连接WiFi
    EZWifiConfigConnected,    //设备连接WiFi成功  （已废弃）
    EZWifiConfigRegistered,   //设备注册平台成功
    EZWifiConfigFailed,       //设备配网失败
};

/* New AP配网设备状态 */
typedef NS_ENUM(NSInteger, EZNewAPConfigStatus)
{
    EZNewAPConfigStatusConnectSuccess          = 104,    // 连接成功
    EZNewAPConfigStatusUnknow                  = 105,    // 未知错误
    EZNewAPConfigStatusPasswordError           = 106,    // 密码错误
    EZNewAPConfigStatusNoAPFound               = 201,    // 未找到wifi热点
};


@interface EZWiFiConfigManager : NSObject

/**
 获取単例

 @return 単例
 */
+ (instancetype)sharedInstance;


#pragma mark - Smart&Sonic Config

/**
 WiFi配网接口。
 请确保手机与设备处在同一网络环境下，声波配网时将音量调到最大，用以提高配网成功率

 @param wifiSsid WiFi的名称
 @param wifiPwd WiFi的密码
 @param deviceSerial 设备序列号，序列号为空则为批量配网
 @param mode 配网模式，可同时进行两种配网方式
 @param resultBlock 配网结果回调
 @return 开启wifi配网是否成功
 */
- (BOOL) startWifiConfigWithWifiSsid:(NSString *) wifiSsid
                             wifiPwd:(NSString *) wifiPwd
                        deviceSerial:(NSString *) deviceSerial
                                mode:(EZWiFiConfigMode) mode
                              reuslt:(void(^)(EZWifiConfigStatus status,NSString *deviceSerial,NSError *error)) resultBlock;

/**
 停止配网，配网结束后需调用
 */
- (void) stopWifiConfig;


#pragma mark - AP Config

/**
 AP配网接口，请确保已连接至设备热点

 @param wifiSsid WiFi的名称
 @param wifiPwd WiFi的密码
 @param deviceSerial 设备序列号
 @param verifyCode 设备验证码
 @param resultBlock 配网结果回调
 @return 方法执行结果
 */
- (BOOL) startAPWifiConfigWithWifiName:(NSString *) wifiSsid
                               wifiPwd:(NSString *) wifiPwd
                          deviceSerial:(NSString *) deviceSerial
                            verifyCode:(NSString *) verifyCode
                                reuslt:(void(^)(EZWifiConfigStatus status, NSError *error)) resultBlock;

/**
 停止AP配网，配网结束后需调用
 */
- (void) stopAPWifiConfig;


#pragma mark - New AP Config

/// 开始NewAP配网（需连接设备热点）
/// @param token 配网token
/// @param ssid WiFi ssid
/// @param password WiFi 密码
/// @param lbsDomain lbs 域名
/// @param handler 回调
- (BOOL) startNewApConfigWithToken:(NSString *)token
                              ssid:(NSString *)ssid
                          password:(NSString *)password
                         lbsDomain:(NSString *)lbsDomain
                 completionHandler:(void(^)(EZNewAPConfigStatus status, NSError *error))handler;

/// 获取设备状态（需连接设备热点）
/// @param handler 回调
- (void) getAccessDeviceInfo:(void(^)(EZAPDevInfo *devInfo, NSError *error))handler;

/// 获取设备当前周边WiFi列表，上限20个（需连接设备热点）
/// @param handler 回调
- (void) getAccessDeviceWifiList:(void(^)(NSArray<EZWiFiItemInfo*> *wifiList, NSError *error))handler;


#pragma mark - Common

/// 设置apiUrl（默认 https://open.ys7.com ）
/// @param url apirUrl
- (void) setApiUrl:(NSString *)url;

/// 设置开放平台accessToken，用于设备配网状态
/// @param accessToken accessToken
- (void) setAccessToken:(NSString *)accessToken;

/// 获取配网token
/// @param accessToken 开放平台token
/// @param handler 回调
- (BOOL) requestConfigToken:(NSString *)accessToken
          completionHandler:(void(^)(EZConfigTokenInfo *tokenInfo, NSDictionary *msgInfo, NSError *error))handler;


#pragma mark - Debug & Util

/// 设置debug log开关
/// @param on 开关
/// @param logCallback 日志回调
+ (void) setDebugLogOpen:(BOOL)on logCallBack:(void(^)(NSString *logStr))logCallback;


/// 获取sdk版本信息
+ (NSString *) getVersion;

@end
