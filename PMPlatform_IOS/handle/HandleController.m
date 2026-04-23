//
//  HandleController.m
//  ConstructionApp
//
//  Created by RedLi on 2018/1/19.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "HandleController.h"
#import "HandleModel.h"
#import "HandleCell.h"

#define KEY_CELL_HIGHT 80
#define KEY_EXPAND_CELL_HIGHT 25

@interface HandleController ()
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@end

@implementation HandleController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tabView registerNib:[UINib nibWithNibName:@"HandleCell" bundle:nil] forCellReuseIdentifier:@"TableSampleIdentifier"];
}

- (void)setData:(NSMutableArray *)data {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=='userTask'"];
    _data = [[data filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.tabView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HandleModel *model = _data[indexPath.row];
    if (model.isExpand) {
        return KEY_CELL_HIGHT + KEY_EXPAND_CELL_HIGHT * (2 + model.opinions.count);
    } else {
        return KEY_CELL_HIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    HandleCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier forIndexPath:indexPath];
    
    NSUInteger row = [indexPath row];
    
    HandleModel *model = [_data objectAtIndex:row];
    
    NSString *userName = model.taskAssignees.count == 0 ? @"" : model.taskAssignees[0].userName;
    NSString *orgName = model.taskAssignees.count == 0 ? @"" : model.taskAssignees[0].orgName;
    
    [cell.imgStatus setImage:[UIImage imageNamed:[cell getImageByStatus:model.status]]];
    [cell.name setText:model.name];
    [cell.userName setText:userName];
    [cell.orgName setText: orgName];
    [cell.status setText: [cell getStatusByInt:model.forwardStatus]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell updateTabCell:model.opinions == nil ? [NSArray array] : model.opinions];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HandleModel *model = _data[indexPath.row];
    
    NSArray *arr = model.opinions == nil ? [NSArray array] : model.opinions;
    if (arr.count == 0) {
        return;
    }
    
    if (self.selectIndex == nil) {
        model.isExpand = YES;
        self.selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        if (self.selectIndex == indexPath) {
            self.selectIndex = nil;
            model.isExpand = NO;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            HandleModel *oldTask = _data[self.selectIndex.row];
            oldTask.isExpand = NO;
            model.isExpand = YES;
            NSIndexPath *old = self.selectIndex;
            self.selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:@[indexPath, old] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
