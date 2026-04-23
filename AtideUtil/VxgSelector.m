//
//  VxgSelector.m
//  TrafficMs
//
//  Created by apple on 2015/11/05.
//  Copyright © 2015年 com. All rights reserved.
//

#import "VxgSelector.h"
#import "VxgColor.h"
#import "VxgCellData.h"

@interface VxgSelector()<UITableViewDelegate,UITableViewDataSource>{
    UITableView             *m_tableView;
    NSMutableArray          *m_tbArray;
    NSMutableArray          *m_retArray;
    NSMutableDictionary     *m_showDic;
    NSMutableDictionary     *m_selectedDic;
}

@end

@implementation VxgSelector

- (instancetype)initVxgSelector:(id)delegate title:(NSString*)title btnName:(NSString*)btnName datas:(NSMutableArray *)datas{
    if (self == [super initWithTitle:title message:nil delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:btnName, nil]) {
        
        CGRect rect = CGRectMake(0,0, __VXGDATE_SELECTOR_WIDTH_, __VXGDATE_SELECTOR_HEIGHT_);
        m_tableView = [[UITableView alloc]initWithFrame:rect];
        m_tableView.dataSource = self;
        m_tableView.delegate = self;
        m_retArray = [[NSMutableArray alloc]init];
        m_selectedDic = [[NSMutableDictionary alloc]init];
        m_tbArray = datas;
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_tbArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger didSection = [indexPath row];
    
    if (!m_showDic) {
        m_showDic = [[NSMutableDictionary alloc]init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",didSection];
    if (![m_showDic objectForKey:key]) {
        [m_showDic setObject:@"1" forKey:key];
    }else{
        [m_showDic removeObjectForKey:key];
    }
    
    [m_retArray addObject:[m_tbArray objectAtIndex:didSection]];
    
    [m_tableView reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    NSInteger didSection = [indexPath row];
    VxgCellData *data = [m_tbArray objectAtIndex:didSection];

    CGFloat sectLabel2x = cell.frame.size.width - 80;
    CGFloat y = cell.frame.origin.y ;
    CGFloat height = cell.frame.size.height*0.8f;
    CGRect rect = CGRectMake(20, cell.frame.origin.y, 100, height);
    UILabel *sectName = [[UILabel alloc]initWithFrame:rect];
    sectName.text = data.name;
    sectName.textColor = UUTwitterColor;
    sectName.font = [UIFont systemFontOfSize:12.0f];
    CGPoint cellCenter = cell.center;
    cellCenter.x = 100;
    [sectName setCenter:cellCenter];
    
    CGRect sessionRect = CGRectMake(sectLabel2x, y, 60, height);
    UILabel *session = [[UILabel alloc]initWithFrame:sessionRect];
    session.text = data.remark;
    session.textColor = VXG_COLOR_ORANGE_RED;
    session.font = [UIFont systemFontOfSize:10.0f];
    cellCenter.x = sectLabel2x;
    [session setCenter:cellCenter];
    
    
    if ([m_showDic objectForKey:[NSString stringWithFormat:@"%ld",didSection]]) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        [imgV setImage:[UIImage imageNamed:@"an_file_star_icon"]];
        cellCenter.x = 20;
        [imgV setCenter:cellCenter];
        [cell addSubview:imgV];
        [m_selectedDic setObject:data forKey:data.remark1];
//        [m_retArray addObject:data];
    }else{
        [m_selectedDic removeObjectForKey:data.remark1];
    }
    
    [cell addSubview:sectName];
    [cell addSubview:session];

    return cell;
}

- (void)setValue;
{
    [self setValue:m_tableView forKey:@"accessoryView"];
}

- (NSMutableArray *)getData{
    [m_retArray removeAllObjects];
    for(NSString *key in m_selectedDic.allKeys){
        [m_retArray addObject:[m_selectedDic objectForKey:key]];
    }
    return m_retArray;
}
@end
