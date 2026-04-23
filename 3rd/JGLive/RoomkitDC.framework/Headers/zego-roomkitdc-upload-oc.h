//
//  zego-roomkitdc-upload-oc.h
//  RoomkitDC
//
//  Created by zego on 2019/12/11.
//

#import <Foundation/Foundation.h>
#import "zego-roomkitdc-constant-oc.h"

NS_ASSUME_NONNULL_BEGIN

/**
上传日志的通知

@param seq 请求序号
@param error_code 错误码，0为成功，负数位客户端逻辑错误，正数为服务器返回错误
*/
typedef void (^ZegoRoomkitDCUploadLogBlock)(ZegoSeq seq, int error_code);

@interface ZegoRoomkitDCUpload : NSObject

+ (id)sharedInstance;

/**
上传日志

@return 当次检查的序号
*/
- (ZegoSeq)uploadLogWithCompletion:(ZegoRoomkitDCUploadLogBlock)block uploadFileName:(NSString *)upload_filename;

@end

NS_ASSUME_NONNULL_END
