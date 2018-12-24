//
//  NiuBlueToothConnect.h
//  NiuBlueTooth
//
//  Created by niu on 2018/12/11.
//  Copyright © 2018年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


NS_ASSUME_NONNULL_BEGIN

@interface NiuBlueToothConnect : NSObject

-(instancetype)shareNiuBlueToothConnect;

//查找外设
-(void)scanForPeripherals;

//取消扫描
-(void)cancleScan;
//取消所有链接
-(void)cancelAllPeripheralsConnection;

//链接外设
-(void)connectToPeripherals;

-(void)discoverServices;

/*
 开始执行
*/
- (void) begin;

/**
 sec秒后停止
 */
- (void) stop;

//开始链接设备
-(void)beginConnectPeripheral:(CBPeripheral *)peripheral chanel:(NSString *)chanel;

//开始链接设备
-(void)beginHandleDataWithPeripheral:(CBPeripheral *)peripheral chanel:(NSString *)chanel characteristic:(CBCharacteristic *)characteristic;

#pragma mark - 蓝牙回调的block

/**
 设备状态改变时 会调用在此设置的block
 */
-(void)setOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block;

/**
 找到Peripherals时 会调用在此设置的block
 每发现一个新外设都会调用此block 需要在这个block中处理包含Peripherals的数组
 */
-(void)setOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;

/**
 查找到Characteristics时 会调用在此设置的block
 */
-(void)setOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;

/**
 获取到最新Characteristics值时 会调用在此设置的block
 */
-(void)setOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;

/**
 查找到Descriptors名称时 会调用在此设置的block
 */
-(void)setOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;

/**
 读取到Descriptors值时 会调用在此设置的block
 */
-(void)setOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error))block;

/**
 设置查找Peripherals的规则
 */

-(void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter;

/**
 设置蓝牙运行时的参数
 */
-(void)setOptionsWithScanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
                      connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
                    scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                              discoverWithServices:(NSArray *)discoverWithServices
                       discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics;


/**
 连接Peripherals成功时 会调用在此设置的block
 */
- (void)setOnConnectedAtChannel:(NSString *)channel
                               block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;

/**
 连接Peripherals失败的block
 */
- (void)setOnFailToConnectAtChannel:(NSString *)channel
                                   block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

/**
 断开Peripherals的连接的block
 */
- (void)setOnDisconnectAtChannel:(NSString *)channel
                                block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

/**
 读取RSSI的委托
 */
- (void)setOnDidReadRSSI:(void (^)(NSNumber *RSSI,NSError *error))block;

/**
 写Characteristic成功后的block
 */
- (void)setOnDidWriteValueForCharacteristicAtChannel:(NSString *)channel
                                                    block:(void (^)(CBCharacteristic *characteristic,NSError *error))block;

/**
 设置查找服务的block

 */
- (void)setOnDiscoverServicesAtChannel:(NSString *)channel
                                      block:(void (^)(CBPeripheral *peripheral,NSError *error))block;


/**
 设置查找到Characteristics的block
 */
- (void)setOnDiscoverCharacteristicsAtChannel:(NSString *)channel
                                             block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;

/**
 设置获取到最新Characteristics值的block
 |  when read new characteristics value  or notiy a characteristics value
 */
- (void)setOnReadValueForCharacteristicAtChannel:(NSString *)channel
                                                block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
@end

NS_ASSUME_NONNULL_END
