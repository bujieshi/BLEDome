//
//  ViewController.m
//  BLEDome
//
//  Created by zhoujian on 15/12/14.
//  Copyright © 2015年 zhoujian. All rights reserved.
//

#import "ViewController.h"
#import "CDSideBarController.h"

@interface ViewController ()<CDSideBarControllerDelegate>


@property(nonatomic,strong)BabyBluetooth*babyBlue;
@property(nonatomic,strong)CDSideBarController*sideBar;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化BabyBluetooth 蓝牙库
//    UIButton*button=[[UIButton alloc] initWithFrame:CGRectMake(5, 25, 30, 30)];
//    [button setBackgroundImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
//    
//    
//    [button addTarget:self action:@selector(meauAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [self.view addSubview:button];
    
    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"], [UIImage imageNamed:@"menuMap.png"], [UIImage imageNamed:@"menuClose.png"]];
    _sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    _sideBar.delegate = self;
    

    UIImage*image=[UIImage imageNamed:@"background"];
    self.view.layer.contents=(id) image.CGImage;
    
    
    


    
//    _babyBlue = [BabyBluetooth shareBabyBluetooth];
//    //设置蓝牙代理方法
//    [self babyDelegate];
//    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
//    _babyBlue.scanForPeripherals().begin();

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(10, 30)];
}

//弹出视图
-(void)meauAction:(id)sender
{

}

//代理方法
#pragma CDSideBarControllerDelegate

-(void)menuButtonClicked:(int)index
{
    NSLog(@"index====%d",index);
}

//设置蓝牙委托
-(void)babyDelegate{
    
    //设置扫描到设备的委托
    [_babyBlue setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    //设置设备连接成功的委托
    [_babyBlue setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    //设置发现设备的Services的委托
    [_babyBlue setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
    }];
    //设置发现设service的Characteristics的委托
    [_babyBlue setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [_babyBlue setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [_babyBlue setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [_babyBlue setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //过滤器
    //设置查找设备的过滤器
    
    
    //过滤器
    //设置查找设备的过滤器
    [_babyBlue setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
    
    //设置连接的设备的过滤器
    __block BOOL isFirst = YES;
    [_babyBlue setFilterOnConnetToPeripherals:^BOOL(NSString *peripheralName) {
        //这里的规则是：连接第一个AAA打头的设备
        if(isFirst && [peripheralName hasPrefix:@"AAA"]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
