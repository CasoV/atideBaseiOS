//
//  ZegoSuperBoardCursorTitleStyle.h
//  ZegoSuperBoard
//
//  Created by liquan on 2023/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//Detailed description: The interface parameter construction class uses the parameters required by the incoming cursor style.
//
//Business scenario: It needs to be passed when calling the [setCustomCursorAttribute:cursorAttribute:complete:] interface.
@interface ZegoSuperBoardCursorTitleStyle : NSObject

//Description:Cursor custom text content
//
//Required: NO
//
//Default value:""
//
//Recommended value:User login name display
//
//Value range:15 characters or less
@property (nonatomic, copy) NSString *title;

//Description:Whether the cursor custom text is bold
//
//Required: NO
//
//Default value:false
@property (nonatomic, assign) BOOL bold;

//Description:Whether the cursor custom text is italic
//
//Required: NO
//
//Default value: false
@property (nonatomic, assign) BOOL italic;

//Description:Cursor custom text font size
//
//Required: NO
//
//Default value:16
//
//Value range:12-20
@property (nonatomic, assign) CGFloat size;

//Description:Cursor custom text font color
//
//Required: NO
//
//Default value: white
@property (nonatomic, strong) UIColor *color;

//Description:Cursor custom text font background color
//
//Required: NO
//
//Default value: black
@property (nonatomic, strong) UIColor *backgroundColor;

//Description:Customize the position of the text relative to the cursor
//
//Required: NO
//
//Default value:ZegoSuperBoardCursorPositionRightTop
@property (nonatomic, assign) ZegoSuperBoardCursorTitlePosition position;//位置

@end

NS_ASSUME_NONNULL_END
