//
//
//  Created by zego on 2021/10/9.
//

#import <Foundation/Foundation.h>
#import <ZIM/ZIM.h>
NS_ASSUME_NONNULL_BEGIN

@interface KeyCenter : NSObject

@property (class, assign) unsigned int appID;

@property (class, assign,nonnull) NSString *appSign;

@property (class, assign) bool isUseToken;

@property (class, assign,nonnull) NSString *resourceID;


@end

NS_ASSUME_NONNULL_END
