//
//  EZWiFiConfigManager.h
//  EZOpenSDK
//
//  Copyright © 2020年. All rights reserved.

#import <Foundation/Foundation.h>

/* 配网方式 */
typedef NS_ENUM(NSInteger, EZWiFiConfigMode)
{
    EZWiFiConfigSmart        = 1 << 0,   //smart config
    EZWiFiConfigSonic         = 1 << 1,  //声波配网
};

/* WiFi配置设备状态 */
typedef NS_ENUM(NSInteger, EZWifiConfigStatus)
{
    DEVICE_WIFI_CONNECTING = 1,   //设备正在连接WiFi
    DEVICE_WIFI_CONNECTED = 2,    //设备连接WiFi成功
    DEVICE_PLATFORM_REGISTED = 3, //设备注册平台成功
};

@interface EZWiFiConfigManager : NSObject

/**
 获取単例

 @return 単例
 */
+ (instancetype)sharedInstance;

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
                                reuslt:(void(^)(BOOL ret)) resultBlock;

/**
 停止AP配网，配网结束后需调用
 */
- (void) stopAPWifiConfig;


/// 设置debug log开关
/// @param on 开关
/// @param logCallback 日志回调
+ (void) setDebugLogOpen:(BOOL)on logCallBack:(void(^)(NSString *logStr))logCallback;

/// 获取sdk版本信息
+ (NSString *) getVersion;

@end
