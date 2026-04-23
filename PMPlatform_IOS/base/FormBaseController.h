//
//  FormBaseController.h
//  ycxm
//
//  Created by 高小伟 on 2020/7/2.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormBaseController : BaseViewController
@property(nonatomic,assign) Boolean attachment;
@property(nonatomic,copy) NSString *mId;
@property(nonatomic,copy) NSString *markId;
@property(nonatomic,copy) NSString *urlStr;
@property(nonatomic,copy) NSString *entityName;
@property(nonatomic,copy) NSString *tableName;
@property(nonatomic,copy) NSString *entityId;
@property (nonatomic, strong) WKWebView *webView;
@property(nonatomic,assign) Boolean hidenLoading;
@property(nonatomic,assign) Boolean hasReport;//是否可以查看报表
@property(nonatomic, assign)Boolean hasSubmit;//是否可以提交
@property(nonatomic, assign)Boolean justReport;//是否只查看报表(不保存不提交)
@property(nonatomic, assign)Boolean showComplete;//督查督办是否显示完成按钮
@property(nonatomic, copy)NSString *treeCode;
@property(nonatomic,strong)NSDictionary *otherInfo;
@property(nonatomic,assign)BOOL isReadOnly;
@property(nonatomic, copy) void (^saveSuccess)(void);//保存成功回调

@end

NS_ASSUME_NONNULL_END
