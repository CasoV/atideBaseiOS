//
//  ModelViewModel.h
//  ConstructionApp
//
//  Created by 末末班车 on 2018/1/17.
//  Copyright © 2018年 atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelViewModel : NSObject

@property (nonatomic, copy) NSString * parentId;
@property (nonatomic, copy) NSString * remarks;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * relationship;
@property (nonatomic, copy) NSString * orderNum;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) BOOL checked;

@property (nonatomic, strong) NSMutableArray<ModelViewModel *> * children;

@end
