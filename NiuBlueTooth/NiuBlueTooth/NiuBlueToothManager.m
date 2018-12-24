//
//  NiuBlueToothManager.m
//  NiuBlueTooth
//
//  Created by niu on 2018/12/12.
//  Copyright © 2018年 niu. All rights reserved.
//

#import "NiuBlueToothManager.h"
#import "NiuBlueToothConnect.h"
#import "NiuBlueToothTool.h"

@interface NiuBlueToothManager ()

@property (nonatomic) NiuBlueToothConnect *blueConnect;
@property (nonatomic) NiuBlueToothTool *blueTool;

@end

@implementation NiuBlueToothManager

+(instancetype)shareBlueToothManager{
    
    static NiuBlueToothManager *shareManager = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        shareManager = [[NiuBlueToothManager alloc]init];
    });
    return shareManager;
    
}

//开始扫描外设
-(void)scanPeripheralsWithDiscoverToPeripherals:(NiuDiscoverPeripheralsBlock)discoverPeripheralsBlock centralManagerDidUpdateState:(NiuCentralManagerDidUpdateState)centralDidUpdateStateBlock filterOnDiscoverPeripherals:(NiuFilterOnDiscoverPeripherals)filterBlock{
    
    [self.blueConnect setOnCentralManagerDidUpdateState:centralDidUpdateStateBlock];
    [self.blueConnect setOnDiscoverToPeripherals:discoverPeripheralsBlock];
    [self.blueConnect setFilterOnDiscoverPeripherals:filterBlock];
    
    //停止之前的链接
    [self.blueConnect cancelAllPeripheralsConnection];
    //开始扫描
    [self.blueConnect scanForPeripherals];
    [self.blueConnect begin];
    
}


-(void)connectPeripheralsWithChannel:(NSString *)chanel currentPeripheral:(CBPeripheral *)peripheral connectSuccessBlock:(NiuConnectPeripheralSuccessBlock)connectSuccessBlock connectFailer:(NiuConnectPeripheralFailerBlock)connectFailerBlock disConnectBlock:(NiuDisConnectPeripheralBlock)disConnectBlock discoverServicesBlock:(NiuDiscoverServicesBlock)discoverServicesBlock discoverCharacteristicsBlock:(NiuDiscoverCharacteristicsBlock)discoverCharacteristicsBlock readValueForCharacteristicBlock:(NiuReadValueForCharacteristicBlock)readValueForCharacteristicBlock didReadRSSIBlock:(NiuDidReadRSSIBlock)didReadRSSIBlock{
    
    [self.blueConnect setOnConnectedAtChannel:chanel block:connectSuccessBlock];
    [self.blueConnect setOnFailToConnectAtChannel:chanel block:connectFailerBlock];
    [self.blueConnect setOnDisconnectAtChannel:chanel block:disConnectBlock];
    [self.blueConnect setOnDiscoverServicesAtChannel:chanel block:discoverServicesBlock];
    [self.blueConnect setOnDiscoverCharacteristicsAtChannel:chanel block:discoverCharacteristicsBlock];
    [self.blueConnect setOnReadValueForCharacteristicAtChannel:chanel block:readValueForCharacteristicBlock];
    
    [self.blueConnect beginConnectPeripheral:peripheral chanel:chanel];
}


-(void)handleDataAtChanel:(NSString *)chanel Peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic readValueForCharacteristicBlock:(NiuReadValueForCharacteristicBlock)readValueForCharacteristicBlock didWriteValueForCharacteristic:(NiuDidWriteValueForCharacteristic)didWriteValueForCharacteristic{
    
    __weak typeof(self) weakSelf = self;
    [self.blueConnect setOnReadValueForCharacteristicAtChannel:chanel block:readValueForCharacteristicBlock];
    
    [self.blueConnect setOnDidWriteValueForCharacteristicAtChannel:chanel block:^(CBCharacteristic * _Nonnull characteristic, NSError * _Nonnull error) {
       
        //数据写入成功后 处理数据
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.blueTool receiveCenterControlData:characteristic.value completeBlock:^(NSData * _Nonnull originalData, NSString * _Nonnull cmd, NSString * _Nonnull leftFrame, NSData * _Nonnull data, BOOL isCheck) {
            
        }];
    }];
    
}

-(void)dealDifferentSituations:(NSString *)chanel Peripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic originalData:(NSData *)originalData cmd:(NSString *)cmd leftFrame:(NSString *)leftFrame data:(NSData *)data isCheck:(BOOL)isCheck error:(NSError *)error completBlock:(NiuDidWriteValueForCharacteristic)completBlock{
    
    //如果校验成功 根据不同的情形 处理不同的情况
    if (isCheck) {
        
        if ([cmd isEqualToString:@"23"] && [leftFrame isEqualToString:@"01"]) {
            //写入key2
        }else if ([cmd isEqualToString:@"83"] && [leftFrame isEqualToString:@"00"]){
            //此时密码校验完成
        }else{
            
            //其他情况处理成功 调用completBlock
            if (completBlock) {
                completBlock(characteristic,error);
            }
        }
        
    }
}

-(NiuBlueToothConnect *)blueConnect{
    
    if (_blueConnect == nil) {
        _blueConnect = [[NiuBlueToothConnect alloc]init];
        
        //设置默认的过滤行为
        //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
        NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
        //连接设备->
        [_blueConnect setOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    }
    
    return _blueConnect;
}

-(NiuBlueToothTool *)blueTool{
    
    if (_blueTool == nil) {
        _blueTool = [[NiuBlueToothTool alloc]init];
    }
    
    return _blueTool;
}

@end
