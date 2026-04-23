//
//  ProjectInfo.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/06.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionInfo.h"
#import "AlowTypeBean.h"

//用于选择项目
@interface ProjectInfo : NSObject
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * label;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * state;
@property (nonatomic , assign) Boolean               checked;
@property (nonatomic , strong) NSDictionary        * attributes;
@property (nonatomic , strong) NSDictionary        * otherInfo;
@property (nonatomic , copy) NSString              * parentId;
@property (nonatomic, copy) NSArray <ProjectInfo *>* children;
@property (nonatomic, strong) NSMutableArray <ProjectInfo *>* tempChildren;
@property (nonatomic, copy) NSArray <AlowTypeBean *>* alowType;

@property(nonatomic, assign) Boolean                  selected;

@property(nonatomic, assign) Boolean   isExpanded;



@property (nonatomic , copy) NSString              * prjid;
@property (nonatomic , copy) NSString              * prjcode;
@property (nonatomic , copy) NSString              *prjname;
@end
