//
//  MidMeasureDetilPerformance.m
//  TrafficMs
//
//  Created by apple on 2015/11/15.
//  Copyright © 2015年 com. All rights reserved.
//

#import "MidMeasureDetilPerformance.h"
#import "MidMeasureDetilPerformanceCell.h"
#import "VxgCellData.h"

@interface MidMeasureDetilPerformance (){
    MidMeasureInfo *m_info;
    NSMutableArray *m_tbArray;
}

@end

@implementation MidMeasureDetilPerformance

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setData];
    [self setCellDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    MidMeasureDetilPerformanceCell *cell=[tableView dequeueReusableCellWithIdentifier:@"midMeasureDetilPerformanceCell" forIndexPath:indexPath];
    VxgCellData *data = [m_tbArray objectAtIndex:[indexPath row]];
    cell.text1.text = data.name;
    cell.text2.text = data.value;
    cell.text3.text = data.remark;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setPerformanceParams:(MidMeasureInfo*)info{
    m_info = info;
}

- (void)setData{
    _currentStaticsLedger.text = m_info.compQuantity;
    _totalLedger.text = m_info.totalCompQuantity;
    _leftLedger.text = m_info.remainQuantity;
    
    NSString *confirmQuantity = m_info.confirmQuantity;
    if (confirmQuantity == nil) {
        return;
    }
    
    CGFloat confirm = [[confirmQuantity stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]floatValue];
    if (confirm == 0) {
        return;
    }
    
    CGFloat current = [[_currentStaticsLedger.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    CGFloat total = [[_totalLedger.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    CGFloat left = [[_leftLedger.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue];
    
    _currentRate.text = [NSString stringWithFormat:@"%0.2f%@",(current/confirm)*100,@"%"];
    _totalRate.text = [NSString stringWithFormat:@"%0.2f%@",(total/confirm)*100,@"%"];
    _leftRate.text = [NSString stringWithFormat:@"%0.2f%@",(left/confirm)*100,@"%"];
}

- (void)setCellDatas{
    m_tbArray = [[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    for (int i=0; i<6; i++) {
        [self setVxgCellData:i];
    }

}

- (void)setVxgCellData:(NSInteger)type{
    NSMutableArray *names = [[NSMutableArray alloc]initWithObjects:@"设计数量",@"完善数量",@"变更数量",@"废置数量",@"水毁数量",@"合计数量", nil];
    NSString *name = [names objectAtIndex:type];
    VxgCellData *data = [[VxgCellData alloc]init];
    data.name = name;
    data.remark = @"0.00";
    if (0==type) {
        data.value = m_info.confirmQuantity;
    }else if(1==type){
        data.value = m_info.bargainQuantity;
    }else if(2==type){
        data.value = m_info.altQuantity;
    }else if(3==type){
        data.value = m_info.abandonQuantity;
    }else if(4==type){
        data.value = m_info.waterDestroyQuantity;
    }else if(5==type){
        data.value = m_info.totalCompQuantity;
    }
    [m_tbArray addObject:data];
}

@end
