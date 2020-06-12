//
//  ViewController.m
//  EZWiFiConfigDemo
//
//  Created by yuqian on 2020/4/26.
//  Copyright © 2020 com.hikvision.ezviz. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EZWiFiConfigManager.h"
#import "UIView+Toast.h"


#define SSID          @"test"
#define PWD           @"12345687"
#define DeviceSeiral  @"759612012"
#define VerifyCode    @"ZALAQX"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ssid;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *deviceSerial;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode;
@property (weak, nonatomic) IBOutlet UIButton *smartConfgBtn;
@property (weak, nonatomic) IBOutlet UIButton *apConfigBtn;
@property (weak, nonatomic) IBOutlet UIButton *soundWaveConfigBtn;

@property (nonatomic, strong) CLLocationManager *locationmanager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开启日志回调
    [EZWiFiConfigManager setDebugLogOpen:YES logCallBack:^(NSString *logStr) {
        NSLog(@"EZWiFiConfigSDK---%@", logStr);
    }];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ) {
        _locationmanager = [[CLLocationManager alloc]init];
        [_locationmanager requestWhenInUseAuthorization];
    }
}

- (IBAction)clickApConfig:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] startAPWifiConfigWithWifiName:self.ssid.text.length>0?self.ssid.text:SSID
                                                                wifiPwd:self.password.text.length>0?self.password.text:PWD
                                                           deviceSerial:self.deviceSerial.text.length>0?self.deviceSerial.text:DeviceSeiral
                                                             verifyCode:self.verifyCode.text.length>0?self.verifyCode.text:VerifyCode
                                                                 reuslt:^(BOOL ret) {
        NSLog(@"AP config result:%d", ret);
        [weakSelf.view makeToast:[NSString stringWithFormat:@"AP config result:%d", ret] duration:2.0 position:CSToastPositionCenter];
    }];
}

- (IBAction)clickSmartConfigBtn:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] startWifiConfigWithWifiSsid:self.ssid.text.length>0?self.ssid.text:SSID
                                                              wifiPwd:self.password.text.length>0?self.password.text:PWD
                                                         deviceSerial:self.deviceSerial.text.length>0?self.deviceSerial.text:DeviceSeiral
                                                                 mode:EZWiFiSmartConfig
                                                               reuslt:^(EZWifiConfigStatus status, NSString *deviceSerial, NSError *error) {
       
        if (error)
        {
            NSLog(@"Smart config 配网失败，error:%@", error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"Smart config 配网失败, error:%@", error] duration:3.0 position:CSToastPositionCenter];
            [[EZWiFiConfigManager sharedInstance] stopWifiConfig];
            return;
        }
        
        switch (status) {
            case DEVICE_WIFI_CONNECTING:
            {
                NSLog(@"Wi-Fi连接中...");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
            }
                break;
            case DEVICE_WIFI_CONNECTED:
            {
                NSLog(@"Wi-Fi连接成功");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
            }
                break;
            case DEVICE_PLATFORM_REGISTED:
            {
                NSLog(@"注册平台成功");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"注册平台成功"] duration:2.0 position:CSToastPositionCenter];
                [[EZWiFiConfigManager sharedInstance] stopWifiConfig];
            }
                break;
            default:
                break;
        }
    }];
}

- (IBAction)clickSoundWaveConfig:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] startWifiConfigWithWifiSsid:self.ssid.text.length>0?self.ssid.text:SSID
                                                              wifiPwd:self.password.text.length>0?self.password.text:PWD
                                                         deviceSerial:self.deviceSerial.text.length>0?self.deviceSerial.text:DeviceSeiral
                                                                 mode:EZWiFiSonicConfig
                                                               reuslt:^(EZWifiConfigStatus status, NSString *deviceSerial, NSError *error) {
       
        if (error)
        {
            NSLog(@"Smart config 配网失败，error:%@", error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"Smart config 配网失败, error:%@", error] duration:3.0 position:CSToastPositionCenter];
            [[EZWiFiConfigManager sharedInstance] stopWifiConfig];
            return;
        }
        
        switch (status) {
            case DEVICE_WIFI_CONNECTING:
            {
                NSLog(@"Wi-Fi连接中...");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
            }
                break;
            case DEVICE_WIFI_CONNECTED:
            {
                NSLog(@"Wi-Fi连接成功");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
            }
                break;
            case DEVICE_PLATFORM_REGISTED:
            {
                NSLog(@"注册平台成功");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"注册平台成功"] duration:2.0 position:CSToastPositionCenter];
                [[EZWiFiConfigManager sharedInstance] stopWifiConfig];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
