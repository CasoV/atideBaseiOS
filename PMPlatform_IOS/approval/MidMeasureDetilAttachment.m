//
//  MidMeasureDetilAttachment.m
//  TrafficMs
//
//  Created by apple on 2015/11/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import "MidMeasureDetilAttachment.h"
#import "MidMeasureDetilAttachmentCell.h"
#import "FileBrowsingController.h"
#import "VxgUIUtils.h"
#import "FileItem.h"
#import "UserInfo.h"

@interface MidMeasureDetilAttachment (){

    NSString        *m_bizFlag;
    NSMutableArray  *m_tbArray;
    MidMeasureInfo  *m_info;

}

@end

@implementation MidMeasureDetilAttachment

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_tbArray = [[NSMutableArray alloc]init];
    self.tableView.tableFooterView = [UIView new];
    [self getWebData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWebData{
    if(m_info == nil || m_info.compId == nil){
        return;
    }
    
    NSString *method = nil;
    if ([m_bizFlag isEqual:BIZFLAG_AFFIX_MIDPAY]) {
        method = [UrlConfig MeteringURL:getCompAffix];
    }else if([m_bizFlag isEqual:BIZFLAG_AFFIX_SUPERVISION]) {
        method = [UrlConfig MeteringURL:getSupervisingCompAffix];
    }else{
        return;
    }
    
    [[HttpManager manager] paramsGet:method param:@{
                                                    @"MainId":[NSString stringWithFormat:@"%@",m_info.compId]
                                                   }
                                        success:^(NSData *data) {
                                            if ([ResponseUtils success:data]) {
                                                if ([[ResponseUtils getData:@"data"] isKindOfClass:[NSDictionary class]]) {
                                                    NSMutableArray *dataArray = [[ResponseUtils getData:@"data"] objectForKey:@"rows"];
                                                    
                                                    if (dataArray!=nil && dataArray.count>0) {
                                                        _tableView.hidden = NO;
                                                        [self setDatas:dataArray];
                                                    }else{
                                                        [self setNullDataView];
                                                    }
                                                }
                                            } else {
                                                [MBManager showBriefAlert:[ResponseUtils getMsg]];
                                            }
                                        } faild:^(NSString *msg) {
                                            [MBManager showBriefAlert:msg];
                                        }];
}

-(void)setDatas:(NSMutableArray *)datas{
    for (NSDictionary *nsd in datas) {
        FileItem *fileItem = [[FileItem alloc]init];
        [fileItem setData:nsd];
        [m_tbArray addObject:fileItem];
    }
    
    [_tableView reloadData];
}

#pragma mark table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_tbArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MidMeasureDetilAttachmentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"midMeasureDetilAttachmentCell" forIndexPath:indexPath];
    FileItem *data = [m_tbArray objectAtIndex:[indexPath row]];
    cell.text1.text = data.affixName;
    cell.text2.text = data.affixLen;
    
    NSString *suffix = [data.fileExt stringByReplacingOccurrencesOfString:@"." withString:@""];
    suffix = [suffix lowercaseString];
    NSString *imgName = nil;
    if ([suffix isEqual:@"png"]) {
        imgName = @"png";
    }else if ([suffix isEqual:@"jpg"]) {
        imgName = @"jpg";
    }else if ([suffix isEqual:@"doc"]) {
        imgName = @"doc";
    }else if ([suffix isEqual:@"dwg"]) {
        imgName = @"dwg";
    }else if ([suffix isEqual:@"xls"] || [suffix isEqual:@"xlsx"]) {
        imgName = @"xls";
    }else if ([suffix isEqual:@"pdf"]) {
        imgName = @"pdf";
    }else{
        imgName = @"unknow";
    }
    [cell.image1 setImage:[UIImage imageNamed:imgName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileItem *item = m_tbArray[indexPath.row];
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [NSString stringWithFormat:@"%@%@", item.affixName, item.fileExt]];
    if ([self checkDownload:[NSString stringWithFormat:@"%@%@", item.affixName, item.fileExt]]) {
        FileBrowsingController *vc = [[FileBrowsingController alloc] init];
        vc.filePath = path;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [MBManager showLoading];
        [[HttpManager manager] post:[UrlConfig MeteringURL:getFileContent] param:@{
                                                                                   @"filePath":@"",
                                                                                   @"params":[NSString stringWithFormat:@"{\"MainId\":\"%@\",\"BussinessFlag\":\"3\"}", item.compAffixID],
                                                                                   @"fileType":@"0"
                                                                                   } success:^(NSData *data) {
            [MBManager hideAlert];
            if ([data writeToFile:path atomically:YES]) {
                FileBrowsingController *vc = [[FileBrowsingController alloc] init];
                vc.filePath = path;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } faild:^(NSString *msg) {
            [MBManager hideAlert];
            [MBManager showBriefAlert:msg];
        }];
    }
}

-(void)setNullDataView{
    _tableView.hidden = YES;
    CGPoint center = self.view.center;
    CGRect rect = CGRectMake(0, 0, 250, 250);
    UIView *content = [[UIView alloc]initWithFrame:rect];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 0, content.frame.size.width-50, content.frame.size.height-50)];
    [imgView setImage:[UIImage imageNamed:@"none"]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(content.frame.origin.x, content.frame.size.height-50, content.frame.size.width, 50)];
    label.text = @"暂时没有数据！";
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [content setCenter:center];
    [content addSubview:imgView];
    [content addSubview:label];
    
    [self.view addSubview:content];
}

-(void)setParams:(MidMeasureInfo *)info bizFlag:(NSString *)bizFlag{
    m_info = info;
    m_bizFlag = bizFlag;
}

#pragma mark - 判断文件是否已经下载
- (BOOL)checkDownload:(NSString *)filePath {
    for (NSString *item in [[NSFileManager defaultManager] subpathsAtPath:[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()]]) {
        if ([item isEqualToString:filePath]) {
            return YES;
        }
    }
    
    return NO;
}

@end
