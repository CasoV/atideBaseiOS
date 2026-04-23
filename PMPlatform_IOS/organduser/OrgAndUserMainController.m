//
//  OrgAndUserMainController.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "OrgAndUserMainController.h"
#import "OrgAndUserLeftController.h"
#import "EnumDictionary.h"

@interface OrgAndUserMainController ()

@property (nonatomic, strong) TreeTableView *tableView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) TreeNode *node;
@property (nonatomic, strong) NSMutableArray <TreeNode *>*selectedNodes;

@end

@implementation OrgAndUserMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0xf2/0xff green:0xf2/0xff blue:0xf2/0xff alpha:1];
    //获取资源
    if (self.dataSource == nil) {
        self.dataSource = [NSArray array];
    }
    // 初始化TreeNode数组
    NSArray <TreeNode *>*nodes = [[TreeNodeHelper sharedInstance] getSortedNodes:self.dataSource defaultExpandLevel:0];
    
    // 初始化自定义的tableView
    __weak typeof(self) weakself = self;
    self.tableView = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 104) data:nodes pickerMode:self.pickerMode];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.callback = ^(NSInteger count, TreeNode *node) {
        weakself.node = node;
        [weakself openRight];

        OrgAndUserLeftController *rightVc = (OrgAndUserLeftController *)[weakself slideMenuController].rightViewController;
        if (rightVc) {
            if (weakself.node) {
                [rightVc reloadData:weakself.node.ID  nodes:weakself.selectedNodes];
            }
        }
    };
    
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = [UIColor hex:@"E6E6E6"];
    [self addBottomView:bottomView];
    [self.view addSubview:bottomView];

    [self fetchUnit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self slideMenuController]) {
        if ([[self slideMenuController] isRightOpen] ) {
            [self closeRight];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray<TreeNode *> *)selectedNodes {
    if (!_selectedNodes) {
        _selectedNodes = [NSMutableArray array];
    }
    return _selectedNodes;
}

- (void)addBottomView:(UIView *)parent {
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, parent.frame.size.width - 80, 40)];
    self.tipLabel.numberOfLines = 1;
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor darkTextColor];
    self.tipLabel.text = @"已选择0项";
    [parent addSubview:self.tipLabel];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(parent.frame.size.width - 70, 5, 60, 30);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.backgroundColor = [UIColor navigationBgColor];
    [button addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:button];
}

- (void)sure {
    if (self.selectedNodes.count == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有选择人员，请选择后再提交" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    } else {
        if (self.callback) {
            self.callback(self.selectedNodes);
        }
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

//MARK: 获取组织机构
- (void)fetchUnit {
    if (!_orgId) {
        _orgId = @"";
    }
    
    [EnumDictionary getEasyUiTree:_orgId async:@"10" isSelf:@"1" callback:^(NSString *str, NSArray<TreeNode *> *nodes) {
        if (str) {
            [MBManager showBriefAlert:str];
        }else {
            [self.tableView refresh:nodes mode:TreeNodePickerModeSINGLE];
        }
    }];
}

#pragma mark - SlideMenuControllerDelegate
- (void)rightDidOpen {
    
}

- (void)rightDidClose {
    OrgAndUserLeftController *rightVc = (OrgAndUserLeftController *)[self slideMenuController].rightViewController;
    if (rightVc) {
        if ([rightVc getNodes]) {
            self.selectedNodes = [[rightVc getNodes] mutableCopy];
        }
        
        if (self.selectedNodes.count == 0) {
            return;
        }

        self.tipLabel.text = self.selectedNodes.firstObject.name;
        
        TreeNode *first = self.selectedNodes.firstObject;
        [self.selectedNodes removeAllObjects];
        [self.selectedNodes addObject:first];
    }
}

@end
