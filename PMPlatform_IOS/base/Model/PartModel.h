//
//  PartModel.h
//  ycxm
//
//  Created by 末末班车 on 2020/3/13.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * projectTypeCode;
@property (nonatomic, copy) NSString * sedId;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSString * attributes;
@property (nonatomic, copy) NSArray<PartModel *> * children;
@property (nonatomic, strong) NSDictionary * otherInfo;
@property (nonatomic, assign) NSInteger doc;
@property (nonatomic, copy) NSString * docself;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;




@end
