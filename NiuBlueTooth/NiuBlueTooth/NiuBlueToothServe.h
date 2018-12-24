//
//  NiuBlueToothServe.h
//  NiuBlueTooth
//
//  Created by niu on 2018/12/13.
//  Copyright © 2018年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBCentralManager,CBPeripheral;

NS_ASSUME_NONNULL_BEGIN

@protocol NiuBlueToothServeDelegate <NSObject>

@optional

//蓝牙连接状态改变的代理
-(void)NiuBlueToothServeCentralManagerDidUpdateState:(CBCentralManager * _Nonnull )central;

/**
 发现新设备 每次发现新设备 都会调用此方法

 @param central 中心设备
 @param peripheral 外设
 @param RSSI 信号强度
 */
-(void)NiuBlueToothServeDiscoverToPeripherals:(CBCentralManager *)central peripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI;

/**
 设置扫描蓝牙的过滤规则

 @param peripheralName 外设名称 如可以设置只扫描外设名称大于1的
 @param RSSI 外设信号强度
 */
-(BOOL)NiuBlueToothServeFilterOnDiscoverPeripherals:(NSString *)peripheralName RSSI:(NSNumber *)RSSI;

//设置蓝牙运行参数的代理
//若不实现此代理 则自动去重
-(NSDictionary *)NiuBlueToothServeScanForPeripheralsWithOptions;
-(NSDictionary *)NiuBlueToothServeConnectPeripheralWithOptions;
-(NSArray *)NiuBlueToothServeScanForPeripheralsWithServices;
-(NSArray *)NiuBlueToothServeDiscoverWithServices;
-(NSArray *)NiuBlueToothServeDiscoverWithCharacteristics;

@end

@interface NiuBlueToothServe : NSObject

@property (nonatomic,weak) id<NiuBlueToothServeDelegate> delegate;


-(instancetype)initWithDelegate:(id<NiuBlueToothServeDelegate>)delegate;

//开始扫描
-(void)startScanPeripheral;
//取消扫描
-(void)cancleScan;

//断开链接
-(void)stopConnect;

/**
 链接到外设

 @param peripheral 要链接到的外设
 */
-(void)connectToPeripheral:(CBPeripheral *)peripheral;

//向蓝牙写入数据
-(void)writeMessage:(NSString *)message toPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
