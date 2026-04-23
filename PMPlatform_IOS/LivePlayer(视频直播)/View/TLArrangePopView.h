//
//  TLArrangePopView.h
//  ZegoRoomkitDemo
//
//  Created by MrLQ  on 2020/5/28.
//  Copyright © 2020 Shenzhen Zego Technology Company Limited. All rights reserved.
//

#import "TLPopupBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLArrangePopView : ZegoPopupBaseView

@property (nonatomic, copy) NSArray *arrangeData;

@property (nonatomic, copy) void(^arrangeblock)(NSDictionary *selectedData);

//由于多语言内容的宽度需要根据文本内容的变化而变化
- (CGFloat)caculateTheBestWidth;

@end

@interface TLArrangePopViewCell : UITableViewCell

@end


NS_ASSUME_NONNULL_END
