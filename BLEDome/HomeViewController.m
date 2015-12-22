//
//  DEMOHomeViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"
#import "DEMONavigationController.h"

@interface DEMOHomeViewController ()
//@property(strong,nonatomic)IFlyISVRecognizer*iflysc;
@property(strong,nonatomic)BabyBluetooth*babyBluetooth;//蓝牙

@end

@implementation DEMOHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.title = @"Home Controller";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:(DEMONavigationController *)self.navigationController
//                                                                            action:@selector(showMenu)];
    self.navigationController.navigationBar.hidden=YES;
    
    
    //添加背景图
    UIImage*image=[UIImage imageNamed:@"background"];
    self.view.layer.contents=(id) image.CGImage;
    
    //添加按钮

    [self addleftButton];
    
    //添加开启蓝牙按钮
    [self addBluetoothButton];
    
    

    
}

//设置蓝牙委托
-(void)babyDelegate{
    
    //设置扫描到设备的委托
    [_babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [_babyBluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
    
    //.......
}

//添加主菜单按钮
-(void)addleftButton
{
    UIButton*button=[[UIButton alloc] initWithFrame:CGRectZero];
    button.translatesAutoresizingMaskIntoConstraints=NO;
    [button addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
//
    [button makeConstraints:^(MASConstraintMaker*maker){
        maker.top.equalTo(20);
        maker.left.equalTo(self.view.left).offset(5);
        maker.width.equalTo(30);
        maker.height.equalTo(30);

    }];
}

//添加开启蓝牙按钮
-(void)addBluetoothButton
{
    UIButton*blueButton=[[UIButton alloc] initWithFrame:CGRectZero];
    blueButton.translatesAutoresizingMaskIntoConstraints=NO;
    [blueButton addTarget:self action:@selector(searchBluetooth) forControlEvents:UIControlEventTouchUpInside];
    blueButton.layer.cornerRadius=6.0f;
    blueButton.layer.masksToBounds=YES;
    blueButton.layer.borderColor=[UIColor whiteColor].CGColor;
    blueButton.titleLabel.textColor=[UIColor whiteColor];
    blueButton.layer.borderWidth=.5;
    [blueButton setTitle:@"搜索设备" forState:UIControlStateNormal];
    
    [self.view addSubview:blueButton];
    
    //开始布局
    
    [blueButton makeConstraints:^(MASConstraintMaker*maker){
        
        maker.bottom.equalTo(self.view).offset(-20);
        maker.left.equalTo(self.view.left).offset(10);
        maker.right.equalTo(self.view.right).offset(-10);
        maker.height.equalTo(30);
        
    }];
}
//蓝牙按钮点击事件
-(void)searchBluetooth
{
    //讯飞 语音识别
//    _iflysc=[IFlyISVRecognizer sharedInstance];
//    _iflysc.delegate=self;
//    [_iflysc setParameter:[NSString stringWithFormat:@"%d",3] forKey:@"pwdt"];
    
    
    _babyBluetooth = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙代理方法
    [self babyDelegate];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
    _babyBluetooth.scanForPeripherals().begin();
}




@end
