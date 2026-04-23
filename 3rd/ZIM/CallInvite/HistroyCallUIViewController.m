//
//  HistroyCallUIViewController.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/22.
//

#import "HistroyCallUIViewController.h"
#import "HistroyCallTableViewCell.h"
@interface HistroyCallUIViewController ()

@end

@implementation HistroyCallUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会议历史";
    // Do any additional setup after loading the view.
}

//MARK: - TableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.callInfoList.count;
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    HistroyCallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistroyCallTableViewCell"];
    ZIMCallInfo *callInfo = [self.callInfoList objectAtIndex:indexPath.row];
    cell.callersCallLabel.text = [NSString stringWithFormat:@"%@'s meeting",callInfo.caller];
    cell.createTimeLabel.text = [self getDateDisplayString:callInfo.createTime];
    return cell;
}


-(NSString *)getDateDisplayString:(long long) miliSeconds{

    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            
            dateFmt.AMSymbol = NSLocalizedString(@"AM",nil);
            dateFmt.PMSymbol = NSLocalizedString(@"PM",nil);
            dateFmt.dateFormat = @"aaa hh:mm";
            
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = NSLocalizedString(@"yesterday",nil);;
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = NSLocalizedString(@"Weekday",nil);
                        break;
                    case 2:
                        dateFmt.dateFormat = NSLocalizedString(@"Monday",nil);
                        break;
                    case 3:
                        dateFmt.dateFormat = NSLocalizedString(@"Tuesday",nil);
                        break;
                    case 4:
                        dateFmt.dateFormat = NSLocalizedString(@"Wednesday",nil);
                        break;
                    case 5:
                        dateFmt.dateFormat = NSLocalizedString(@"Thursday",nil);
                        break;
                    case 6:
                        dateFmt.dateFormat = NSLocalizedString(@"Friday",nil);
                        break;
                    case 7:
                        dateFmt.dateFormat = NSLocalizedString(@"Saturday",nil);
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM-dd hh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}
@end
