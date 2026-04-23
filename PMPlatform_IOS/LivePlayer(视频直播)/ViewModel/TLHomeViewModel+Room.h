//
//  TLHomeViewModel+Room.h
//  ZegoRoomkitDemo
//
//  Created by xia on 2021/6/9.
//  Copyright © 2021 zego. All rights reserved.
//

#import "TLHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLHomeViewModel (Room)

- (NSDictionary *)createRoomDictWithData:(NSDictionary *)data;

- (NSDictionary *)listRoomDict;

- (NSDictionary *)deleteRoomDictOfRoomID:(NSString *)roomID;

- (NSDictionary *)queryRoomDictWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
