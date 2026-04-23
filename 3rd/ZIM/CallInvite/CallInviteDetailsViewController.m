//
//  CallInviteDetailsViewController.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import "CallInviteDetailsViewController.h"
#import "CreateCallViewController.h"
#import "CallDetailsMemberTableViewCell.h"
#import <ZIM/ZIM.h>
#import "ZGZIMManager.h"
#import "CallEndViewController.h"

@interface CallInviteDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,ZIMEventDelegate>

@property NSMutableArray<ZIMCallUserInfo *> *callMemberList;

@property NSMutableDictionary<NSString *, NSNumber *> *memberRowMap;

@property (weak, nonatomic) IBOutlet UITableView *memberTableView;

@end

@implementation CallInviteDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-3"] style:UIBarButtonItemStyleDone target:self action:@selector(addMembersButtonClicked)];
    [[ZGZIMManager shared] addZIMEventDelegate:self];
    if(_callMemberList == nil){
        self.callMemberList = [[NSMutableArray alloc] init];
    }
    if(_memberRowMap == nil){
        _memberRowMap = [[NSMutableDictionary alloc] init];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 的会议",_caller];
    // Do any additional setup after loading the view.
}

-(void)addMembersButtonClicked{
    CreateCallViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateCallViewController"];
    vc.viewTitle = @"邀请他人";
    vc.callID = self.callID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)quitButtonClicked:(id)sender {
    ZIMCallQuitConfig *config = [[ZIMCallQuitConfig alloc] init];
    [[ZGZIMManager shared] callQuit:self.callID config:config callback:^(NSString * _Nonnull callID, ZIMCallQuitSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == ZIMErrorCodeSuccess){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
//            [ZGHUDHelper showMessage:[NSString stringWithFormat:@"code:%d,message:%@",errorInfo.code,errorInfo.message]];
        }
    }];
}
- (IBAction)dismissButtonClicked:(id)sender {
    ZIMCallEndConfig *config = [[ZIMCallEndConfig alloc] init];
    [[ZGZIMManager shared] callEnd:self.callID config:config callback:^(NSString * _Nonnull callID, ZIMCallEndedSentInfo * _Nonnull info, ZIMError * _Nonnull errorInfo) {
        if(errorInfo.code == ZIMErrorCodeSuccess){
            CallEndViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CalllEndViewController"];
            NSString *endTimeMinusCreateTime = [NSString stringWithFormat:@"%d",(int)((info.endTime - info.createTime)/1000)];
            NSString *endTimeMinusAcceptTime = [NSString stringWithFormat:@"%d",(int)((info.endTime - info.acceptTime)/1000)];
            vc.endTimeMinusCreateTime = endTimeMinusCreateTime;
            vc.endTimeMinusAcceptTime = endTimeMinusAcceptTime;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
//            [ZGHUDHelper showMessage:[NSString stringWithFormat:@"code:%d,message:%@",errorInfo.code,errorInfo.message]];
        }
    }];
}
//MARK: - TableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.callMemberList.count;
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CallDetailsMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallDetailsMemberTableViewCell"];
    ZIMCallUserInfo *userInfo = [self.callMemberList objectAtIndex:indexPath.row];
    cell.callMemberIDLabel.text = userInfo.userID;
    switch (userInfo.state) {
        case ZIMCallUserStateUnknown:
            cell.userStateLabel.text = @"未知";
            break;
        case ZIMCallUserStateInviting:
            cell.userStateLabel.text = @"邀请中";
            break;
        case ZIMCallUserStateAccepted:
            cell.userStateLabel.text = @"已接受";
            break;
        case ZIMCallUserStateRejected:
            cell.userStateLabel.text = @"已拒绝";
            break;
        case ZIMCallUserStateCancelled:
            cell.userStateLabel.text = @"已取消";
            break;
        case ZIMCallUserStateReceived:
            cell.userStateLabel.text = @"已收到邀请";
            break;
        case ZIMCallUserStateTimeout:
            cell.userStateLabel.text = @"已超时";
            break;
        case ZIMCallUserStateQuit:
            cell.userStateLabel.text = @"已退出";
            break;
        default:
            break;
    }
    return cell;
}


-(void)zim:(ZIM *)zim callUserStateChanged:(ZIMCallUserStateChangeInfo *)info callID:(nonnull NSString *)callID{
    if(![callID isEqual:self.callID]){
        return;
    }
    
    [self addCallMembers:info.callUserList];
    [self.memberTableView reloadData];
}

-(void)zim:(ZIM *)zim callInvitationEnded:(ZIMCallInvitationEndedInfo *)info callID:(NSString *)callID{
    CallEndViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CalllEndViewController"];
//    NSString *endTimeMinusCreateTime = [NSString stringWithFormat:@"%d",(int)((info.endTime - info.createTime)/1000)];
//    NSString *endTimeMinusAcceptTime = [NSString stringWithFormat:@"%d",(int)((info.endTime - info.acceptTime)/1000)];
//    vc.endTimeMinusCreateTime = endTimeMinusCreateTime;
//    vc.endTimeMinusAcceptTime = endTimeMinusAcceptTime;
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addCallMembers:(NSArray<ZIMCallUserInfo *> *)callUserList{
    if(_callMemberList == nil){
        self.callMemberList = [[NSMutableArray alloc] init];
    }
    if(_memberRowMap == nil){
        _memberRowMap = [[NSMutableDictionary alloc] init];
    }
    for (ZIMCallUserInfo *updateInfo in callUserList) {
        if([self.memberRowMap objectForKey:updateInfo.userID]){
            [self.callMemberList replaceObjectAtIndex:[[self.memberRowMap objectForKey:updateInfo.userID] unsignedIntValue] withObject:updateInfo];
        }else{
            [self.callMemberList addObject:updateInfo];
            [self.memberRowMap setObject:[NSNumber numberWithUnsignedLong:self.callMemberList.count - 1] forKey:updateInfo.userID];
        }
    }
}

@end
