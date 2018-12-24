//
//  NiuBlueToothTool.h
//  NiuBlueTooth
//
//  Created by niu on 2018/12/11.
//  Copyright © 2018年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NiuBlueToothTool : NSObject

//校验密码
-(void)checkoutPassword;

//多帧写数据
-(NSString *)writeMultiFrameDataWithFirstFrameHeader:(NSString *)firstFrameHeader nextFrameHeader:(NSString *)nextFrameHeader willWriteData:(NSString *)data;

//多帧读数据 注意多帧读数据 也是APP向中控写入指令 然后中控将APP想要读取的数据通过应答回复发送回来
-(NSString *)readMultiFrameDataWithFirstFrameHeader:(NSString *)firstFrameHeader nextFrameHeader:(NSString *)nextFrameHeader willWriteData:(NSString *)data;

/**
 处理中控回复数据

 @param originalData 接收到的中控回复数据
 @param block 处理后回调的block
                originalData：接收到的中控回复数据
                cmd：命令码
                leftFrame：剩余帧数
                data：中控发送回来的数据
                isCheck：是否校验通过
 */
-(void)receiveCenterControlData:(NSData *)originalData completeBlock:(void (^) (NSData *originalData,NSString *cmd,NSString *leftFrame,NSData *data,BOOL isCheck))completeBlock;

//将符合规定的字符串转换成符合规定的data
-(NSData*)strToDataWithString :(NSString *)string;
@end

NS_ASSUME_NONNULL_END
