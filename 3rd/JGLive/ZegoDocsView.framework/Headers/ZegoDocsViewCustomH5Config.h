//
//  ZegoDocsViewCustomH5Config.h
//  ZegoDocsView
//
//  Created by zego on 2021/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 配置类，用于设置上传自定义H5课件的参数
///
@interface ZegoDocsViewCustomH5Config : NSObject

/// 自定义课件的宽
@property (nonatomic, assign) CGFloat width;

/// 自定义课件的高度
@property (nonatomic, assign) CGFloat height;

/// 自定义课件的页数
@property (nonatomic, assign) NSInteger pageCount;

/// 自定义H5课件缩略图相对路径数组
@property (nonatomic, strong) NSArray<NSString *> *thumbnailList;

@end

NS_ASSUME_NONNULL_END
