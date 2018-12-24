//
//  NiuBlueToothServe.m
//  NiuBlueTooth
//
//  Created by niu on 2018/12/13.
//  Copyright © 2018年 niu. All rights reserved.
//

#import "NiuBlueToothServe.h"
#import "NiuBlueToothConnect.h"
#import "NiuBlueToothTool.h"

//蓝牙的chanel
static NSString *niuBlueToothChanel = @"niuBlueToothChanel";

@interface NiuBlueToothServe ()

//用于蓝牙的扫描 链接等操作
@property (nonatomic) NiuBlueToothConnect *blueTooth;

//用于蓝牙的写入读取数据处理
@property (nonatomic) NiuBlueToothTool *blueToothDataTool;

@end

@implementation NiuBlueToothServe

-(instancetype)initWithDelegate:(id<NiuBlueToothServeDelegate>)delegate{
    
    if (self = [super init]) {
    
        _delegate = delegate;
        [self setupServes];
    }
    
    return self;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self setupServes];
    }
    
    return self;
}

-(void)setupServes{
    
    _blueToothDataTool = [[NiuBlueToothTool alloc]init];
    _blueTooth = [[NiuBlueToothConnect alloc]init];
    [self setBlueToothConnectCallBack];
    
}

-(void)startScanPeripheral{
    
    [self.blueTooth scanForPeripherals];
    [self.blueTooth begin];
    
}

-(void)cancleScan{
    
    [self.blueTooth cancleScan];
}

-(void)stopConnect{
    
    [self.blueTooth stop];
}

-(void)writeMessage:(NSString *)message toPeripheral:(CBPeripheral *)peripheral{
    
    if (peripheral == nil || message == nil || message.length == 0 || [message isEqualToString:@""]) {
        return;
    }
    
    //找到外设中可写入的特征
    CBCharacteristic *writeCharacter = nil;
    
    for (CBService *service in peripheral.services) {
        
        for (CBCharacteristic *character in service.characteristics) {
            
            if ((character.properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
                writeCharacter = character;
                break;
            }
        }
    }
    
    if (writeCharacter != nil) {
        
        //将传进来的消息 处理成符合规定的消息
       NSString *frameStr = [self.blueToothDataTool writeMultiFrameDataWithFirstFrameHeader:@"0101" nextFrameHeader:@"0121" willWriteData:message];
       NSData *frameData = [self.blueToothDataTool strToDataWithString:frameStr];
        
        //多帧发送
        for (NSInteger dataIndex = 0; dataIndex < frameData.length; dataIndex += 20) {
            
            NSInteger len = (frameData.length - dataIndex*20) > 20 ? 20:(frameData.length - dataIndex*20);
            NSData *data = [frameData subdataWithRange:NSMakeRange(dataIndex, len)];
            
            [peripheral writeValue:data forCharacteristic:writeCharacter type:CBCharacteristicWriteWithResponse];
        }
        
    }

}

-(void)connectToPeripheral:(CBPeripheral *)peripheral{
    
    //取消扫描
    [self.blueTooth cancleScan];
    //链接到指定设备
    [self.blueTooth beginConnectPeripheral:peripheral chanel:niuBlueToothChanel];
    
}



//设置NiuBlueToothConnect的一些回调
-(void)setBlueToothConnectCallBack{
    
    __weak typeof(self) weakSelf = self;
    
    //蓝牙状态改变
    [self.blueTooth setOnCentralManagerDidUpdateState:^(CBCentralManager * _Nonnull central) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(NiuBlueToothServeCentralManagerDidUpdateState:)]) {
            
            [strongSelf.delegate NiuBlueToothServeCentralManagerDidUpdateState:central];
        }
        
    }];
   
    //蓝牙发现新设备的回调
    [self.blueTooth setOnDiscoverToPeripherals:^(CBCentralManager * _Nonnull central, CBPeripheral * _Nonnull peripheral, NSDictionary * _Nonnull advertisementData, NSNumber * _Nonnull RSSI) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(NiuBlueToothServeDiscoverToPeripherals:peripheral:RSSI:)]) {
            
            [strongSelf.delegate NiuBlueToothServeDiscoverToPeripherals:central peripheral:peripheral RSSI:RSSI];
        }
        
    }];
    
    //过滤外设
    [self.blueTooth setFilterOnDiscoverPeripherals:^BOOL(NSString *  peripheralName, NSDictionary * _Nonnull advertisementData, NSNumber * _Nonnull RSSI) {
        
        BOOL flag = NO;
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(NiuBlueToothServeFilterOnDiscoverPeripherals:RSSI:)]) {
            
           flag = [strongSelf.delegate NiuBlueToothServeFilterOnDiscoverPeripherals:peripheralName RSSI:RSSI];
        }
        
        return flag;
    }];
}

//设置蓝牙运行时的一些配置
-(void)setBlueToothOption{
    
    NSDictionary *scanForPeripheralsWithOptions = @ {CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(NiuBlueToothServeScanForPeripheralsWithOptions)]) {
        scanForPeripheralsWithOptions = [self.delegate NiuBlueToothServeScanForPeripheralsWithOptions];
    }
    
    NSDictionary *connectOptions = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(NiuBlueToothServeConnectPeripheralWithOptions)]) {
        connectOptions = [self.delegate NiuBlueToothServeConnectPeripheralWithOptions];
    }
    
    NSArray *peripheralsWithServices = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(NiuBlueToothServeScanForPeripheralsWithServices)]) {
        peripheralsWithServices = [self.delegate NiuBlueToothServeScanForPeripheralsWithServices];
    }
    
    NSArray *discoverWithServices = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(NiuBlueToothServeDiscoverWithServices)]) {
        discoverWithServices = [self.delegate NiuBlueToothServeDiscoverWithServices];
    }
    
    NSArray *discoverWithCharacteristics = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(NiuBlueToothServeDiscoverWithCharacteristics)]) {
        discoverWithCharacteristics = [self.delegate NiuBlueToothServeDiscoverWithCharacteristics];
    }
    
    [self.blueTooth setOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:peripheralsWithServices discoverWithServices:discoverWithServices discoverWithCharacteristics:discoverWithCharacteristics];
}

@end
