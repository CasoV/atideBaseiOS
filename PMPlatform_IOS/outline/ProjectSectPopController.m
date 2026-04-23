//
//  ProjectSectPopController.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/08.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ProjectSectPopController.h"
#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HIGHT                        [UIScreen mainScreen].bounds.size.height
#import "ProjectSectCell.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "WebServiceConfig.h"
#import "WebserviceManager.h"
#import "ProjectSect.h"
#import "SysConfig.h"
#import "XMLParser.h"
#import "ProjectSectTableCell.h"
@interface ProjectSectPopController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) UIView            *editingView;
@end

@implementation ProjectSectPopController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mSectsData = [[NSMutableArray alloc] init];
    for (ProjectSect *sect in [SysConfig getInstance].sectInfos) {
        ProjectSect *item = [[ProjectSect alloc] init];
        item.sectno = sect.sectno;
        item.sectname = sect.sectname;
        item.issect = sect.issect;
        [self.mSectsData addObject:item];
    }
    [self Adds];
    self.navigationItem.title = @"请选择标段";
    [self.tableView registerNib:[UINib nibWithNibName:@"ProjectSectTableCell" bundle:nil] forCellReuseIdentifier:@"tablecell"];
   // [self.tableView setEditing:YES animated:YES];
    [self showEitingView:YES];
    //[self fetchProjectSect];
}
- (void)fetchProjectSect{
    [MBManager showLoading];
    __weak typeof(self) weakSelf = self;
    NSDictionary *config = [WebServiceConfig config:WebServiceConfig.PrjectOverViewService];
    [WebserviceManager dataTaskWithSoapRequest:[@{@"projectKey":[SysConfig getInstance].projectId} mutableCopy] url:config[@"url"] method:config[@"GetSectDatas"] nameSpace:config[@"nameSpace"] completed:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBManager hideAlert];
                [MBManager showBriefAlert:[NSString stringWithFormat:@"%@", error]];
            });
        }else {
            
            [[[XMLParser alloc] init] analysisXMLData:data handleBlock:^(NSData *jsonData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBManager hideAlert];
                    if ([ResponseUtils success:jsonData]) {
                        weakSelf.mSectsData = [ProjectSect mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                        [weakSelf.tableView reloadData];
                        
                    } else {
                        [MBManager showBriefAlert:[ResponseUtils getMsg]];
                    }
                });
            }];
        }
    }];
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.editingView];
    
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.editingView.mas_top);
    }];
    
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view).offset(45);
    }];
}





#pragma mark -- event response

- (void)p__buttonClick:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"确定"]) {
        NSMutableArray *insets = [[NSMutableArray alloc] init];
        [self.mSectsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProjectSect *sect = obj;
            if (sect.issect) {
                [insets addObject:sect];
            }
        }];
        if (insets.count<1) {
            [MBManager showBriefAlert:@"请选择标段!"];
            return;
        }
        if (self.callback) {
            self.callback(insets);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.mSectsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProjectSect *sect = obj;
            sect.issect = YES;
        }];
        
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
        [self.tableView reloadData];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        [self.mSectsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProjectSect *sect = obj;
            sect.issect = NO;
        }];
        [self.tableView reloadData];
        
        
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        
    }
}


- (void)showEitingView:(BOOL)isShow{
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:45);
    }];
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    }];
}

#pragma mark -- UITabelViewDelegate And DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mSectsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectSectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tablecell" forIndexPath:indexPath];
    ProjectSect *item = self.mSectsData[indexPath.row];
    cell.textUI.text = item.sectname;
//    cell.textLabel.text = item.sectname;
    if(item.issect){
        cell.imageUI.image = [UIImage imageNamed:@"check_selected_label"];
    }else{
        cell.imageUI.image = [UIImage imageNamed:@"check_normal_label"];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectSect *item = self.mSectsData[indexPath.row];
    item.issect = !item.issect;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark -- getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-64)];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        //[_tableView registerClass:[ProjectSectCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

- (UIView *)editingView{
    if (!_editingView) {
        _editingView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(0.5);
        }];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor darkGrayColor];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(0.5);
        }];
    }
    return _editingView;
}


@end
