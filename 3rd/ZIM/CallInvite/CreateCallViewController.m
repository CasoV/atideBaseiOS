//
//  CreateCallViewController.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import "CreateCallViewController.h"
#import "CreateCallTableViewCell.h"
#import "ZGZIMManager.h"
#import "CallInviteDetailsViewController.h"
@interface CreateCallViewController()<UITableViewDelegate,UITableViewDataSource,CallMemberListDelegate,ZIMEventDelegate>


@end
@implementation CreateCallViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.createCallModel = [[CallinviteModel alloc] init];
    [self.createCallModel addMemberListDelegate:self];
    [self.addMemberButton setTitle:NSLocalizedString(@"add", nil) forState:UIControlStateNormal];
    self.navigationItem.title = self.viewTitle;
    [self.okButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
}

- (IBAction)OKButtonClicked:(UIButton *)sender {
    if(self.callID != nil || [self.callID isEqual:@""]){
        ZIMCallingInviteConfig *config = [[ZIMCallingInviteConfig alloc] init];

        [[ZGZIMManager shared] callingInviteWithInvitees:self.createCallModel.memberList callID:self.callID config:config callback:^(NSString * _Nonnull callID, ZIMCallingInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
            if(errorInfo.code == ZIMErrorCodeSuccess){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        ZIMCallInviteConfig *config = [[ZIMCallInviteConfig alloc] init];
        config.mode = ZIMCallInvitationModeAdvanced;
        config.timeout = 90;
        [[ZGZIMManager shared] callInviteWithInvitees:self.createCallModel.memberList config:config callback:^(NSString * _Nonnull callID, ZIMCallInvitationSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
            if(errorInfo.code == ZIMErrorCodeSuccess){
                CallInviteDetailsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CallInviteDetailsViewController"];
                vc.callID = callID;
                vc.caller = [ZGZIMManager shared].myUserID;
                [[ZGZIMManager shared] addZIMEventDelegate:vc];
                [self.navigationController pushViewController:vc animated:YES];
                NSMutableArray *newViewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                [newViewControllers removeObjectAtIndex:newViewControllers.count-2];
                self.navigationController.viewControllers = newViewControllers;
            }
        }];
    }
}
//MARK: - TableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.createCallModel.memberList.count;
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CreateCallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateCallTableViewCell"];
    [cell.userNameLabel setText:self.createCallModel.memberList[indexPath.row]];
    cell.vc = self;
    return cell;
}
- (IBAction)addMemberButtonClicked:(id)sender {
    if(self.memberIDTextField.text == nil || [self.memberIDTextField.text isEqual:@""]){
        return;
    }
    [self.createCallModel addMemberList:self.memberIDTextField.text];
    self.memberIDTextField.text = @"";
}


//MARK: - groupMemberListDelegate
-(void)callMemberListupdate:(NSArray *)groupMmemberList{
   [self.memberTableView reloadData];
}


@end
