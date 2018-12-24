//
//  NiuBlueToothConnect.m
//  NiuBlueTooth
//
//  Created by niu on 2018/12/11.
//  Copyright © 2018年 niu. All rights reserved.
//

#import "NiuBlueToothConnect.h"
#import "BabyBlueTooth/BabyBluetooth.h"

@interface NiuBlueToothConnect ()

@property (nonatomic) BabyBluetooth *blueTooth;

@end

@implementation NiuBlueToothConnect

-(instancetype)shareNiuBlueToothConnect{
    
    static NiuBlueToothConnect *shareConnect = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        shareConnect = [[NiuBlueToothConnect alloc]init];
    });
    return shareConnect;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        _blueTooth = [BabyBluetooth shareBabyBluetooth];
        
    }
    
    return self;
}

#pragma mark - 扫描相关

-(void)scanForPeripherals{
    
    if (_blueTooth) {
        [_blueTooth scanForPeripherals];
    }
}

-(void)cancleScan{
    
    if (_blueTooth) {
        [_blueTooth cancelScan];
    }
    
}

-(void)cancelAllPeripheralsConnection{
    
    if (_blueTooth) {
        [_blueTooth cancelAllPeripheralsConnection];
    }
}

-(void)connectToPeripherals{
    
    if (_blueTooth) {
        [_blueTooth connectToPeripherals];
    }
}

-(void)discoverServices{
    
    if (_blueTooth) {
        [_blueTooth discoverServices];
    }
}

-(void)begin{

    if (_blueTooth) {
        [_blueTooth begin];
    }
}

-(void)stop{
    
    if (_blueTooth) {
        [_blueTooth stop];
    }
}

-(void)beginConnectPeripheral:(CBPeripheral *)peripheral chanel:(NSString *)chanel{
    
    if (peripheral == nil) {
        return;
    }
    
    if (_blueTooth) {
        _blueTooth.having(peripheral).and.channel(chanel).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();

    }
    
}

-(void)beginHandleDataWithPeripheral:(CBPeripheral *)peripheral chanel:(NSString *)chanel characteristic:(CBCharacteristic *)characteristic{
    
    if (_blueTooth) {
        _blueTooth.channel(chanel).characteristicDetails(peripheral,characteristic);
    }
}

#pragma mark - 设置蓝牙的一些回调
-(void)setOnCentralManagerDidUpdateState:(void (^)(CBCentralManager * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnCentralManagerDidUpdateState:block];
    }
}

-(void)setOnDiscoverToPeripherals:(void (^)(CBCentralManager * _Nonnull, CBPeripheral * _Nonnull, NSDictionary * _Nonnull, NSNumber * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDiscoverToPeripherals:block];
    }
}

-(void)setOnDiscoverCharacteristics:(void (^)(CBPeripheral * _Nonnull, CBService * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDiscoverCharacteristics:block];
    }
}

-(void)setOnReadValueForCharacteristic:(void (^)(CBPeripheral * _Nonnull, CBCharacteristic * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnReadValueForCharacteristic:block];
    }
    
}

-(void)setOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral * _Nonnull, CBCharacteristic * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDiscoverDescriptorsForCharacteristic:block];
    }
}

-(void)setOnReadValueForDescriptors:(void (^)(CBPeripheral * _Nonnull, CBDescriptor * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnReadValueForDescriptors:block];
    }
}

-(void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString * _Nonnull, NSDictionary * _Nonnull, NSNumber * _Nonnull))filter{
    
    if (_blueTooth) {
        [_blueTooth setFilterOnDiscoverPeripherals:filter];
    }
}

-(void)setOptionsWithScanForPeripheralsWithOptions:(NSDictionary *)scanForPeripheralsWithOptions connectPeripheralWithOptions:(NSDictionary *)connectPeripheralWithOptions scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices discoverWithServices:(NSArray *)discoverWithServices discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics{
    
    if (_blueTooth) {
        [_blueTooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectPeripheralWithOptions scanForPeripheralsWithServices:scanForPeripheralsWithServices discoverWithServices:discoverWithServices discoverWithCharacteristics:discoverWithCharacteristics];
    }
    
}

-(void)setOnConnectedAtChannel:(NSString *)channel block:(void (^)(CBCentralManager * _Nonnull, CBPeripheral * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnConnectedAtChannel:channel block:block];
    }
    
}

-(void)setOnFailToConnectAtChannel:(NSString *)channel block:(void (^)(CBCentralManager * _Nonnull, CBPeripheral * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnFailToConnectAtChannel:channel block:block];
    }
}

-(void)setOnDisconnectAtChannel:(NSString *)channel block:(void (^)(CBCentralManager * _Nonnull, CBPeripheral * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDisconnectAtChannel:channel block:block];
    }
}

-(void)setOnDidReadRSSI:(void (^)(NSNumber * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDidReadRSSI:block];
    }
}

-(void)setOnDidWriteValueForCharacteristicAtChannel:(NSString *)channel block:(void (^)(CBCharacteristic * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDidWriteValueForCharacteristicAtChannel:channel block:block];
    }
    
}

-(void)setOnDiscoverServicesAtChannel:(NSString *)channel block:(void (^)(CBPeripheral * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDiscoverServicesAtChannel:channel block:block];
    }
}

-(void)setOnDiscoverCharacteristicsAtChannel:(NSString *)channel block:(void (^)(CBPeripheral * _Nonnull, CBService * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnDiscoverCharacteristicsAtChannel:channel block:block];
    }
}

-(void)setOnReadValueForCharacteristicAtChannel:(NSString *)channel block:(void (^)(CBPeripheral * _Nonnull, CBCharacteristic * _Nonnull, NSError * _Nonnull))block{
    
    if (_blueTooth) {
        [_blueTooth setBlockOnReadValueForCharacteristicAtChannel:channel block:block];
    }
}

@end
