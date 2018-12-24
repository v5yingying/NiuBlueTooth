//
//  NiuBlueToothTool.m
//  NiuBlueTooth
//
//  Created by niu on 2018/12/11.
//  Copyright © 2018年 niu. All rights reserved.
//

#import "NiuBlueToothTool.h"

@implementation NiuBlueToothTool

//校验密码
-(void)checkoutPassword{
    
    NSString *key1 = @"1123445543aaaddd";
    //    NSString *key1 = @"1123445543aaaddd1123445543aaad1123445543aaaddd1123445543aaad";
    //写数据
    NSString *resultStr = [self writeMultiFrameDataWithFirstFrameHeader:@"0121" nextFrameHeader:@"0101" willWriteData:key1];
    //转换成data
    NSData *passwordKey1 = [self strToDataWithString:resultStr];
    //读数据
//    NSString *resultStr = [self readMultiFrameDataWithFirstFrameHeader:@"0121" nextFrameHeader:@"0101" willWriteData:key1];
    
    NSLog(@"resultStr = %@",resultStr);
    
}

//多帧写入
-(NSString *)writeMultiFrameDataWithFirstFrameHeader:(NSString *)firstFrameHeader nextFrameHeader:(NSString *)nextFrameHeader willWriteData:(NSString *)data{
    
    //用于保存处理后的数据
    NSMutableString *finalDataStr = [NSMutableString string];
    
    //剩余帧数 以十六进制保存
    NSString *remainFrameNum = @"00";
    
    NSInteger dataLenth = data.length;
    
    //计算数据需要分几帧发送 一个字节 是两个十六进制位 数据域最多16个字节
    NSInteger frameLenth = dataLenth / 32 + (dataLenth % 32 > 0 ? 1 : 0);
    
    //拼接数据
    for (NSInteger i = 0; i < frameLenth; i++) {
        
        //用来拼接每一帧的内容
        NSMutableString *string = [NSMutableString string];
        //将十进制转化为16进制
        remainFrameNum = [self stringWithHexNumber:(frameLenth - i - 1)];
        
        //如果remainFrameNum是一位数 那么补0
        if (remainFrameNum.length < 2) {
            remainFrameNum = [NSString stringWithFormat:@"0%@",remainFrameNum];
        }
        
        //第一帧时
        if (i == 0) {
            [string appendString:firstFrameHeader];
            [string appendString:remainFrameNum];
            
            if (frameLenth == 1) {
                //如果只有一帧 那么直接拼接
                [string appendString:[self addZeroWithStr:data]];
            }else{
                
                //如果有多帧
                [string appendString: [data substringWithRange:NSMakeRange(0, 32)]];
            }
        }else if (i == frameLenth - 1){
            //最后一帧时
            [string appendString:nextFrameHeader];
            [string appendString:remainFrameNum];
            [string appendString: [self addZeroWithStr:[data substringWithRange:NSMakeRange(i*32,dataLenth - i * 32)]]];
        }else{
            
            //除去第一帧和最后一帧时
            [string appendString:nextFrameHeader];
            [string appendString:remainFrameNum];
            [string appendString: [data substringWithRange:NSMakeRange(i*32,32)]];
            
        }
        
        //拼接校验码
        NSString *CSStr = [self checkOutCS:string];
        //完整的一帧拼接完成 将数据添加到finalDataStr
        [finalDataStr appendString:string];
        [finalDataStr appendString:CSStr];
    }
    
    return finalDataStr;
}

//求校验和
-(NSString *)checkOutCS:(NSString *)str{
    
    
    return @"ee";
}

//补零
-(NSString *)addZeroWithStr:(NSString *)str{
    
    NSMutableString *strM = [NSMutableString stringWithString:str];
    
    if (str.length < 32) {
        for (NSInteger i = str.length; i < 32; i++) {
            [strM appendString:@"0"];
        }
    }
    
    return strM.copy;
}

//数字转十六进制字符串
- (NSString *)stringWithHexNumber:(NSUInteger)hexNumber{
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    return hexString;
}


//多帧读数据 注意多帧读数据 也是APP向中控写入指令 然后中控将APP想要读取的数据通过应答回复发送回来
-(NSString *)readMultiFrameDataWithFirstFrameHeader:(NSString *)firstFrameHeader nextFrameHeader:(NSString *)nextFrameHeader willWriteData:(NSString *)data{
    
    //最终拼接的数据
    NSMutableString *finalFrameData = [NSMutableString string];
    //剩余的帧数
    NSString *frameNum = @"00";
    //读取命令的数据长度
    NSInteger dataLenth = data.length;
    //计算剩余帧数 因为蓝牙文档中 读取数据时 地址和地址区块一共占用3个字节 而整个数据域最多16个字节 所以最多有5个地址和地址区块 其余位补零
    NSInteger frameLenth = dataLenth/30 + (dataLenth % 30 > 0 ? 1 : 0);
    //拼接读取指令数据
    for (NSInteger i = 0; i < frameLenth; i++) {
        
        //每一帧的数据
        NSMutableString *string = [NSMutableString string];
        //将剩余帧数转换为16进制
        frameNum = [self stringWithHexNumber:(frameLenth - i - 1)];
        if (frameNum.length < 2) {
            frameNum = [NSString stringWithFormat:@"0%@",frameNum];
        }
        
        //拼接数据域
        if (i == 0) {
            //首帧
            [string appendString:firstFrameHeader];
            [string appendString:frameNum];
            if (frameLenth == 1) {
                //如果只有一帧 则直接发送
                [string appendString: [self addZeroWithStr:data]];
            }else{
                
                //如果有一帧以上 则进行拼接
                NSString *dataStr = [data substringWithRange:NSMakeRange(0, 30)];
                [string appendString: [self addZeroWithStr:dataStr]];
            }
        }else if (i == frameLenth - 1){
            
            //最后一帧
            [string appendString:nextFrameHeader];
            [string appendString:frameNum];
            NSString *dataStr = [data substringWithRange:NSMakeRange(i*30, data.length - i*30)];
            [string appendString: [self addZeroWithStr:dataStr]];
            
        }else{
            
            [string appendString:nextFrameHeader];
            [string appendString:frameNum];
            NSString *dataStr = [data substringWithRange:NSMakeRange(i+30, 30)];
            [string appendString:[self addZeroWithStr:dataStr]];
            
        }
        
        //计算校验码
        NSString *CSStr = [self checkOutCS:string];
        [finalFrameData appendString:string];
        [finalFrameData appendString:CSStr];
    }
    
    return finalFrameData;
}

-(NSData*) strToDataWithString :(NSString *)string{
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        
        NSInteger lenth = string.length - idx;
        NSInteger len = lenth >= 2 ? 2 : lenth;
        NSRange range = NSMakeRange(idx, len);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        
        [data appendBytes:&intValue length:1];
    }
    return data;
}

-(void)receiveCenterControlData:(NSData *)originalData completeBlock:(void (^)(NSData * _Nonnull, NSString * _Nonnull, NSString * _Nonnull, NSData * _Nonnull, BOOL))completeBlock{
    
    
    //中控回复每次20字节
    if (originalData.length != 20) {
        return;
    }
    
    //读取命令码
    NSData *cmdCode = [originalData subdataWithRange:NSMakeRange(1, 1)];
    //读取剩余帧数
    NSData *leftFrame = [originalData subdataWithRange:NSMakeRange(2, 1)];
    //获取数据
    NSData *data = [originalData subdataWithRange:NSMakeRange(3, 16)];
    //获取校验码
    NSData *checkCSData = [originalData subdataWithRange:NSMakeRange(19, 1)];
    NSString *checkCSDataStr = [self hexStringWithData:checkCSData];
    //计算校验码
    NSString *checkCS = [self checkOutCS:[self hexStringWithData:originalData]];
    
    
    NSString *cmdCodeStr = [self hexStringWithData:cmdCode];
    NSString *leftFrameStr = [self hexStringWithData:leftFrame];
    
    if (completeBlock) {
        completeBlock(originalData,cmdCodeStr,leftFrameStr,data,[checkCSDataStr isEqualToString:checkCS]);
    }
}

#pragma mark - 将传入的NSData类型转换成NSString并返回
-(NSString *)hexStringWithData:(NSData *)data
{
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    NSString* result = [NSString stringWithString:hexString];
    return result;
    
}


@end
