//
//  ZegoSuperBoardCursorAttribute.h
//  ZegoSuperBoard
//
//  Created by zego on 2021/8/10.
//

#import <Foundation/Foundation.h>

@class ZegoSuperBoardCursorTitleStyle;

NS_ASSUME_NONNULL_BEGIN


/// Description: This API parameter construction class is used to introduce the parameters required for the cursor style.
///
/// Business scenario: The [setCustomCursorAttribute:cursorAttribute:complete:] API is called.
///
@interface ZegoSuperBoardCursorAttribute : NSObject

/// Description: Path of the custom cursor image, which can be a local or network path. (Only images of the PNG format and network image URLs in the HTTPS format are supported.) For example, xxxxxxxxxx.png and https://xxxxxxxx.com/xxx.png.
///
/// Required: Yes
///
/// Supported version: 2.2.0
@property (nonatomic, copy) NSString *iconPath;

/// Description: Customize the offset of the cursor along the X-axis, which is 0 by default and cannot exceed the image width.
///
/// Required: Yes
///
/// Supported version: 2.2.0
@property (nonatomic, assign) CGFloat offsetX;

/// Description: Customize the offset of the cursor along the Y-axis, which is 0 by default and cannot exceed the image height.
///
/// Required: Yes
///
/// Supported version: 2.2.0
@property (nonatomic, assign) CGFloat offsetY;


/// Detailed description: Cursor custom text information
///
/// Required: NO
///
/// Default value: Refer to ZegoSuperBoardCursorTitleStyle class
/// 
/// Supported version: v2.4.0
@property (nonatomic, strong)ZegoSuperBoardCursorTitleStyle *titleStyle;

@end

NS_ASSUME_NONNULL_END
