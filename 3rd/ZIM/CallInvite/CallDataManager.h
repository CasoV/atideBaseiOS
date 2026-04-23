//
//  CallDataManager.h
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/6/2.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>
NS_ASSUME_NONNULL_BEGIN

@interface CallDataManager : NSObject

+(CallDataManager *)shared;

-(NSArray<ZIMCallUserInfo *> *)takeCurrentCallList:(NSString *)callID;

@end

NS_ASSUME_NONNULL_END
