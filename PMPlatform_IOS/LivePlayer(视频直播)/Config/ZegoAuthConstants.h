//
//  ZegoAuthConstants.h
//  ZegoWhiteboardViewDemo
//
//  Created by zego on 2020/4/28.
//  Copyright © 2020 zego. All rights reserved.
//

#ifndef ZegoAuthConstants_h
#define ZegoAuthConstants_h

// ZEGO鉴权信息，通过联系ZEGO工作人员申请获取
// secret_id 鉴权使用
#define kSecretID 1808034
// secret_sign 鉴权使用
#define kSecretSign @"4ff7daab3639c5c04edc4834eee4be605f5aa581e1299b40cb68fc5bfbac77831"
// 房间项目ID
#define kProductID 1532 //1437 1532

// 本地应用设置
// 应用程序的group ID, 用于屏幕共享Extension和主进程之间的数据共享
static NSString *kZegoRPAppGroup = @"";
// 应用Extension ID, 用于屏幕共享
static NSString *kAppExtensionBundleID = @"";

#endif /* ZegoAuthConstants_h */
