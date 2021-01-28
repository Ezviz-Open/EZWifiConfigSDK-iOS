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


#define SSID          @"hbj044"  //ezvz_test
#define PWD           @"123456789"  //test123+
#define DeviceSeiral  @"759612082" //759612082 C37988520
#define VerifyCode    @"WAFDZJ" //ZALAQX WAFDZJ
#define AccessToken   @"at.6qmsx56v8yyuiyum2o61cgnu07tl5ada-67vwenjlu9-0bj7rdz-uynfozxlb"  //at.d4ruomhfduevc70say0cm5kj6hn1blzl-86s34gejzm-1ftsqzp-dskra0qvg  at.6qmsx56v8yyuiyum2o61cgnu07tl5ada-67vwenjlu9-0bj7rdz-uynfozxlb
#define ApiUrl        @"https://open.ys7.com"  //https://iusopen.ezvizlife.com  https://open.ys7.com


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ssid;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *deviceSerial;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode;
@property (weak, nonatomic) IBOutlet UITextField *accessToken;
@property (weak, nonatomic) IBOutlet UITextField *configToken;
@property (weak, nonatomic) IBOutlet UIButton *smartConfgBtn;
@property (weak, nonatomic) IBOutlet UIButton *apConfigBtn;
@property (weak, nonatomic) IBOutlet UIButton *soundWaveConfigBtn;
@property (weak, nonatomic) IBOutlet UITextField *apiUrl;

@property (nonatomic, strong) CLLocationManager *locationmanager;
@property (nonatomic, strong) EZConfigTokenInfo *tokenInfo;

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
    NSLog(@"Wi-Fi连接中...");
    [self.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
    
    [[EZWiFiConfigManager sharedInstance] setApiUrl:self.apiUrl.text.length > 0 ? self.apiUrl.text : ApiUrl];
    [[EZWiFiConfigManager sharedInstance] setAccessToken:self.accessToken.text.length > 0 ? self.accessToken.text : AccessToken];
    
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] startAPWifiConfigWithWifiName:self.ssid.text.length>0?self.ssid.text:SSID
                                                                wifiPwd:self.password.text.length>0?self.password.text:PWD
                                                           deviceSerial:self.deviceSerial.text.length>0?self.deviceSerial.text:DeviceSeiral
                                                             verifyCode:self.verifyCode.text.length>0?self.verifyCode.text:VerifyCode
                                                                 reuslt:^(EZWifiConfigStatus status,NSError *error) {
        
        if (error)
        {
            NSLog(@"AP config 配网失败，error:%@", error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"AP config 配网失败, error:%@", error] duration:3.0 position:CSToastPositionCenter];
            [[EZWiFiConfigManager sharedInstance] stopAPWifiConfig];
            return;
        }
        
        switch (status) {
            case EZWifiConfigConnecting:
            {
                NSLog(@"Wi-Fi连接中...");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
            }
                break;
            case EZWifiConfigRegistered:
            {
                NSLog(@"注册平台成功");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"注册平台成功"] duration:2.0 position:CSToastPositionCenter];
                [[EZWiFiConfigManager sharedInstance] stopAPWifiConfig];
            }
                break;
            default:
                break;
        }
    }];
}

- (IBAction)getConfigToken:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] requestConfigToken:self.accessToken.text.length>0?self.accessToken.text:AccessToken
                                           completionHandler:^(EZConfigTokenInfo *tokenInfo, NSDictionary *msgInfo, NSError *error) {
        
        if (error) {
            NSLog(@"error:%@",error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"%@", error] duration:2.0 position:CSToastPositionCenter];
        }
        else{
            weakSelf.configToken.text = tokenInfo.token;
            weakSelf.tokenInfo = tokenInfo;
            NSLog(@"msg:%@\n%@", msgInfo, tokenInfo);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"msg:%@\ntoken:%@", msgInfo, tokenInfo] duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (IBAction)clickNewApConfig:(UIButton *)sender {
    
    NSLog(@"Wi-Fi连接中...");
    [self.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
    
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] startNewApConfigWithToken:self.configToken.text.length>0?self.configToken.text:self.tokenInfo.token
                                                               ssid:self.ssid.text.length>0?self.ssid.text:SSID
                                                           password:self.password.text.length>0?self.password.text:PWD
                                                          lbsDomain:self.tokenInfo.lbsDomain
                                                  completionHandler:^(EZNewAPConfigStatus status, NSError *error) {

        if (error) {
            NSLog(@"error:%@",error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"%@", error] duration:2.0 position:CSToastPositionCenter];
        }
        else{
            
            [weakSelf.view makeToast:[NSString stringWithFormat:@"New AP Config result: %d", (int)status] duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (IBAction)getNewApDeviceInfo:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] getAccessDeviceInfo:^(EZAPDevInfo *devInfo, NSError *error) {

        if (error) {
            NSLog(@"error:%@",error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"%@", error] duration:2.0 position:CSToastPositionCenter];
        }
        else {
            NSLog(@"devInfo:%@", devInfo);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"%@", devInfo] duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (IBAction)getNewApWifiList:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] getAccessDeviceWifiList:^(NSArray<EZWiFiItemInfo *> *wifiList, NSError *error) {

        if (error) {
            NSLog(@"error:%@",error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"%@", error] duration:2.0 position:CSToastPositionCenter];
        }
        else {
            NSLog(@"wifiList：%@", wifiList);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"%@", wifiList] duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (IBAction)clickSmartConfigBtn:(id)sender
{
    [[EZWiFiConfigManager sharedInstance]setApiUrl:self.apiUrl.text.length > 0 ? self.apiUrl.text : ApiUrl];
    [[EZWiFiConfigManager sharedInstance] setAccessToken:self.accessToken.text.length > 0 ? self.accessToken.text : AccessToken];
    __weak typeof(self) weakSelf = self;
    
    [[EZWiFiConfigManager sharedInstance] startWifiConfigWithWifiSsid:self.ssid.text.length>0?self.ssid.text:SSID
                                                              wifiPwd:self.password.text.length>0?self.password.text:PWD
                                                         deviceSerial:self.deviceSerial.text.length>0?self.deviceSerial.text:DeviceSeiral
                                                                 mode:EZWiFiConfigSmart
                                                               reuslt:^(EZWifiConfigStatus status, NSString *deviceSerial, NSError *error) {
       
        if (error)
        {
            NSLog(@"Smart config 配网失败，error:%@", error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"Smart config 配网失败, error:%@", error] duration:3.0 position:CSToastPositionCenter];
            [[EZWiFiConfigManager sharedInstance] stopWifiConfig];
            return;
        }
        
        switch (status) {
            case EZWifiConfigConnecting:
            {
                NSLog(@"Wi-Fi连接中...");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
            }
                break;
//            case EZWifiConfigConnected:
//            {
//                NSLog(@"Wi-Fi连接成功");
//                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
//            }
//                break;
            case EZWifiConfigRegistered:
            {
                NSLog(@"注册平台成功");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"注册平台成功"] duration:3.0 position:CSToastPositionCenter];
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
    [[EZWiFiConfigManager sharedInstance] setApiUrl:self.apiUrl.text.length > 0 ? self.apiUrl.text : ApiUrl];
    [[EZWiFiConfigManager sharedInstance] setAccessToken:self.accessToken.text.length > 0 ? self.accessToken.text : AccessToken];
    
    __weak typeof(self) weakSelf = self;
    [[EZWiFiConfigManager sharedInstance] startWifiConfigWithWifiSsid:self.ssid.text.length>0?self.ssid.text:SSID
                                                              wifiPwd:self.password.text.length>0?self.password.text:PWD
                                                         deviceSerial:self.deviceSerial.text.length>0?self.deviceSerial.text:DeviceSeiral
                                                                 mode:EZWiFiConfigSonic
                                                               reuslt:^(EZWifiConfigStatus status, NSString *deviceSerial, NSError *error) {
       
        if (error)
        {
            NSLog(@"Sonic config 配网失败，error:%@", error);
            [weakSelf.view makeToast:[NSString stringWithFormat:@"Sonic config 配网失败, error:%@", error] duration:3.0 position:CSToastPositionCenter];
            [[EZWiFiConfigManager sharedInstance] stopWifiConfig];
            return;
        }
        
        switch (status) {
            case EZWifiConfigConnecting:
            {
                NSLog(@"Wi-Fi连接中...");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
            }
                break;
//            case EZWifiConfigConnected:
//            {
//                NSLog(@"Wi-Fi连接成功");
//                [weakSelf.view makeToast:[NSString stringWithFormat:@"Wi-Fi连接中..."] duration:2.0 position:CSToastPositionCenter];
//            }
//                break;
            case EZWifiConfigRegistered:
            {
                NSLog(@"注册平台成功");
                [weakSelf.view makeToast:[NSString stringWithFormat:@"注册平台成功"] duration:3.0 position:CSToastPositionCenter];
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
