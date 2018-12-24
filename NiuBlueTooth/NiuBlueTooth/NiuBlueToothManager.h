//
//  NiuBlueToothManager.h
//  NiuBlueTooth
//
//  Created by niu on 2018/12/12.
//  Copyright © 2018年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

//发现外设的block
typedef void(^NiuDiscoverPeripheralsBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI);

//中控状态改变的block
typedef void(^NiuCentralManagerDidUpdateState)(CBCentralManager *central);

//设置扫描设备的过滤规则
typedef BOOL(^NiuFilterOnDiscoverPeripherals)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI);

//链接外设成功
typedef void(^NiuConnectPeripheralSuccessBlock)(CBCentralManager *central,CBPeripheral *peripheral);
//链接外设失败
typedef void(^NiuConnectPeripheralFailerBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//断开链接外设
typedef void(^NiuDisConnectPeripheralBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//发现设备的Services
typedef void(^NiuDiscoverServicesBlock)(CBPeripheral *peripheral,NSError *error);
//发现service的Characteristics
typedef void(^NiuDiscoverCharacteristicsBlock)(CBPeripheral *peripheral,CBService *service,NSError *error);
//读取characteristics
typedef void(^NiuReadValueForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);
//发现characteristics的descriptors
//typedef void(^NiuDiscoverDescriptorsForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error);
////读取Descriptor的委托
//typedef void(^NiuReadValueForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error);

//读取characteristics的
typedef void(^NiuDidReadRSSIBlock)(NSNumber *RSSI,NSError *error);

//写数据成功的block
typedef void(^NiuDidWriteValueForCharacteristic)(CBCharacteristic *characteristic, NSError *error);

//发现characteristics的descriptors
//typedef void(^NiuDiscoverDescriptorsForCharacteristic)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error);
//
////读取Descriptor的委托
//typedef void(^NiuReadValueForDescriptors)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error);

@interface NiuBlueToothManager : NSObject

+(instancetype)shareBlueToothManager;


/**
 扫描设备

 @param discoverPeripheralsBlock 发现新外设的时候调用此block 每发现一个新外设都会调用这个block
 @param centralDidUpdateStateBlock 蓝牙状态改变的时候会调用
 @param filterBlock 过滤的block
 */
-(void)scanPeripheralsWithDiscoverToPeripherals:(NiuDiscoverPeripheralsBlock)discoverPeripheralsBlock centralManagerDidUpdateState:(NiuCentralManagerDidUpdateState)centralDidUpdateStateBlock filterOnDiscoverPeripherals:(NiuFilterOnDiscoverPeripherals)filterBlock;


/**
 链接外设的方法

 @param chanel 使用不同的channel切换相应的block
 @param peripheral 要链接的外设
 @param connectSuccessBlock 链接成功的回调
 @param connectFailerBlock 链接失败的回调
 @param disConnectBlock 断开链接的回调
 @param discoverServicesBlock 发现外设服务的回调
 @param discoverCharacteristicsBlock 发现服务特征的回调
 @param readValueForCharacteristicBlock 读取特征的回调
 @param didReadRSSIBlock 读取RSS信号的回调
 */
-(void)connectPeripheralsWithChannel:(NSString *)chanel currentPeripheral:(CBPeripheral *)peripheral connectSuccessBlock:(NiuConnectPeripheralSuccessBlock)connectSuccessBlock connectFailer:(NiuConnectPeripheralFailerBlock)connectFailerBlock disConnectBlock:(NiuDisConnectPeripheralBlock)disConnectBlock discoverServicesBlock:(NiuDiscoverServicesBlock)discoverServicesBlock discoverCharacteristicsBlock:(NiuDiscoverCharacteristicsBlock)discoverCharacteristicsBlock readValueForCharacteristicBlock:(NiuReadValueForCharacteristicBlock)readValueForCharacteristicBlock didReadRSSIBlock:(NiuDidReadRSSIBlock)didReadRSSIBlock;



/**
 处理数据

 @param chanel 使用不同的channel切换相应的block
 @param peripheral 链接的外设
 @param characteristic 要读写数据的characteristic
 @param readValueForCharacteristicBlock 读取到Characteristic的block
 @param didWriteValueForCharacteristic 写入完成的block
 */
-(void)handleDataAtChanel:(NSString *)chanel Peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic readValueForCharacteristicBlock:(NiuReadValueForCharacteristicBlock)readValueForCharacteristicBlock didWriteValueForCharacteristic:(NiuDidWriteValueForCharacteristic)didWriteValueForCharacteristic;

@end

NS_ASSUME_NONNULL_END
