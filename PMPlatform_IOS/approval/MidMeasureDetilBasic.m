//
//  MidMeasureDetilBasic.m
//  TrafficMs
//
//  Created by apple on 2015/11/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import "MidMeasureDetilBasic.h"
#import "MidMeasureDetilBasicCell.h"

@interface MidMeasureDetilBasic (){
    NSMutableArray *m_tbArray;
    MidMeasureInfo *m_info;
}

@end

@implementation MidMeasureDetilBasic

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_tbArray = [[NSMutableArray alloc]init];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 120;
    _tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//m_tbArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MidMeasureDetilBasicCell *cell=[tableView dequeueReusableCellWithIdentifier:@"midMeasureDetilBasicCell" forIndexPath:indexPath];
    if(m_info == nil){
        return cell;
    }
    cell.text1.text = m_info.codeNo;
    cell.text2.text = m_info.flowName;
    cell.text3.text = m_info.listCode;
    cell.text4.text = m_info.listName;
    cell.text5.text = m_info.monitPicket;
    cell.text6.text = m_info.compPile;
    cell.text7.text = m_info.partName;
    cell.text8.text = m_info.itemUnit;
    cell.text9.text = [m_info.compDate stringByReplacingOccurrencesOfString:@"00:00:00.0" withString:@""];
    cell.text10.text = m_info.formula;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *acell=@"cell";
//    TbCell *cell=[tableView dequeueReusableCellWithIdentifier:acell];
//    
//    return 0.0f;
//    
//}

-(void)setParams:(MidMeasureInfo *)info{
    m_info = info;
}

@end
