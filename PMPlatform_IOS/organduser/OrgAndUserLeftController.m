//
//  OrgAndUserLeftController.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "OrgAndUserLeftController.h"
#import "TreeTableView.h"
#import "SlideMenuController.h"
#import "EnumDictionary.h"

@interface OrgAndUserLeftController ()

@property (weak, nonatomic) IBOutlet UILabel *tipUI;

@property (nonatomic, strong) TreeTableView *tableView;
@property (nonatomic, strong) NSMutableArray <TreeNode *>*selectedNodes;


@end

@implementation OrgAndUserLeftController {
    BOOL _isSure;
    NSString *_orgId;
    NSMutableArray <TreeNode *>*_otherNodes;
    
    NSArray<TreeNode *> *_datas;
    void (^_callback)(NSArray<TreeNode *> *nodes);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isSure = NO;
    _orgId = @"100";
    _otherNodes = [NSMutableArray array];
    
    __weak typeof(self) weakself = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.callback = ^(NSInteger count, TreeNode *node) {
        weakself.tipUI.text = [NSString stringWithFormat:@"已选择%ld项", count];
    };
    
    if (_datas && _callback) {
        self.tableView.frame = CGRectMake(0, 64, ScreenWidth, self.view.frame.size.height - 40);
        [self.tableView refresh:_datas mode:TreeNodePickerModeSINGLE];
    }
}

#pragma mark - 懒加载
- (TreeTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40) data:@[] pickerMode:TreeNodePickerModeSINGLE];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray<TreeNode *> *)selectedNodes {
    if (!_selectedNodes) {
        _selectedNodes = [NSMutableArray array];
    }
    return _selectedNodes;
}

- (IBAction)sure:(id)sender {
    self.selectedNodes = [[self.tableView getSelectedNodes] mutableCopy];
    for (TreeNode *item in self.selectedNodes) {
        item.pId = _orgId;
    }
    
    [self.selectedNodes addObjectsFromArray:_otherNodes];
    _isSure = YES;
    
    if (_datas && _callback) {
        _callback([self getNodes]);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self closeRight];
    }
}

- (NSArray<TreeNode *> *)getNodes {
    if (_isSure) {
        return self.selectedNodes;
    }
    return nil;
}

- (void)reloadData:(NSString *)url nodes:(NSArray<TreeNode *> *)tmps {
    [self.selectedNodes removeAllObjects];
    [_otherNodes removeAllObjects];
    _isSure = NO;
    _orgId = url;
    
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    if ([url isEqualToString:@"0"]) {
        [self.tableView refresh:tmps mode:TreeNodePickerModeSINGLE];
    } else {
        [EnumDictionary getOrgUsers:url callback:^(NSString *str, NSArray<TreeNode *> *nodes) {
            if (tmps.count > 0) {
                for (TreeNode *item in tmps) {
                    NSInteger index = [nodes indexOfObject:item];
                    
                    if (index < nodes.count) {
                        nodes[index].isSelected = YES;
                    }else {
                        [_otherNodes addObject:item];
                    }
                }
            }
            [self.tableView refresh:nodes mode:TreeNodePickerModeSINGLE];
        }];
    }
}

- (void)loadNodes:(NSArray<TreeNode *> *)datas callback:(void (^)(NSArray<TreeNode *> *))callback {
    _datas = datas;
    for (TreeNode *node in datas) {
    }
    _callback = callback;
}

@end
