//
//  ProAndSectChoosePopView.m
//  ycxm
//
//  Created by 末末班车 on 2022/3/8.
//  Copyright © 2022 末末班车. All rights reserved.
//

#import "ProAndSectChoosePopView.h"
#import "NewChooseProjectHeaderView.h"
#import "NewChooseProjectCell.h"
#import "ChooseProjectInfo.h"
#import "UIView+STPicker.h"

#define cellId @"NewChooseProjectCell"
#define headerViewId @"NewChooseProjectHeaderView"

#define ButtonSystemHeight 40
#define DefaultFont [UIFont systemFontOfSize:14]
#define DefaultBorderButtonColor [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1]

@interface ProAndSectChoosePopView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** 1.内部视图 */
@property (nonatomic, strong) UIView *contentView;
/** 2.标题label */
@property (nonatomic, strong) UILabel *labelTitle;
/** 3.分界线 */
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;
/** 4.btnView */
@property (nonatomic, strong) UIView *btnView;
/** 5.确定的按钮 */
@property (nonatomic, strong) UIButton *buttonLeft;
/** 6.重置的按钮 */
@property (nonatomic, strong) UIButton *buttonRight;
/** 7.项目/标段主页面 */
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) PermissionModel *permission;
@property (nonatomic, strong) NSMutableArray <ChooseProjectInfo *>*dataSource;

@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *sectionId;

@end

@implementation ProAndSectChoosePopView

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefault];
    }
    return self;
}

- (instancetype)initWithPermission:(PermissionModel *)permission {
    if (self = [super init]) {
        _permission = permission;
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault {
    // 1.设置数据的默认值
    self.projectId = [UserAgent DefaultAgent].projectId;
    self.sectionId = [UserAgent DefaultAgent].sectionId;
    
    // 2.设置自身的属性
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
    self.layer.opacity = 0.0;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    // 3.添加子视图
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.btnView];
    [self.contentView addSubview:self.collectionView];
    [self.btnView addSubview:self.buttonLeft];
    [self.btnView addSubview:self.buttonRight];
    [self makeDataSource];
}

#pragma mark - 懒加载
- (UIView *)contentView {
    if (!_contentView) {
        CGFloat contentX = SCREEN_WIDTH * 0.05;
        CGFloat contentY = SCREEN_HEIGHT / 5;
        CGFloat contentW = SCREEN_WIDTH * 0.9;
        CGFloat contentH = SCREEN_HEIGHT / 5 * 3;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.clipsToBounds = YES;
        _contentView.layer.opacity = 0.0;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _contentView;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        CGFloat titleX = 0;
        CGFloat titleY = 0;
        CGFloat titleW = self.contentView.st_width;
        CGFloat titleH = ButtonSystemHeight - 1;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setTextColor:[UIColor blackColor]];
        [_labelTitle setText:@"项目/标段选择"];
        [_labelTitle setFont:DefaultFont];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _labelTitle;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        CGFloat lineX = 0;
        CGFloat lineY = ButtonSystemHeight - 1;
        CGFloat lineW = self.contentView.st_width;
        CGFloat lineH = 1;
        _lineView1 = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineView1 setBackgroundColor:DefaultBorderButtonColor];
        _lineView1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        CGFloat lineX = 0;
        CGFloat lineY = self.contentView.st_height - ButtonSystemHeight - 20 - 1;
        CGFloat lineW = self.contentView.st_width;
        CGFloat lineH = 1;
        _lineView2 = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineView2 setBackgroundColor:DefaultBorderButtonColor];
        _lineView2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _lineView2;
}

- (UIView *)btnView {
    if (!_btnView) {
        CGFloat lineX = 20;
        CGFloat lineY = self.contentView.st_height - ButtonSystemHeight - 10;
        CGFloat lineW = self.contentView.st_width - 40;
        CGFloat lineH = ButtonSystemHeight;
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
    }
    return _btnView;
}

- (UIButton *)buttonLeft {
    if (!_buttonLeft) {
        CGFloat leftW = (self.btnView.st_width - 10) / 2;
        CGFloat leftH = self.btnView.st_height;
        CGFloat leftX = 0;
        CGFloat leftY = 0;
        _buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
        _buttonLeft.layer.cornerRadius = 5.0f;
        _buttonLeft.clipsToBounds = YES;
        [_buttonLeft setTitle:@"确定" forState:UIControlStateNormal];
        [_buttonLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonLeft setBackgroundColor:UIColorTextBlue];
        [_buttonLeft.titleLabel setFont:DefaultFont];
        [_buttonLeft addTarget:self action:@selector(selectedOk) forControlEvents:UIControlEventTouchUpInside];
        _buttonLeft.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight {
    if (!_buttonRight) {
        CGFloat rightW = self.buttonLeft.st_width;
        CGFloat rightH = self.buttonLeft.st_height;
        CGFloat rightX = self.buttonLeft.st_width + 10;
        CGFloat rightY = self.buttonLeft.st_y;
        _buttonRight = [[UIButton alloc]initWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
        _buttonRight.layer.cornerRadius = 5.0f;
        _buttonRight.layer.borderWidth = 1.0f;
        _buttonRight.layer.borderColor = [UIColorTextBlue CGColor];
        _buttonRight.clipsToBounds = YES;
        [_buttonRight setTitle:@"重置" forState:UIControlStateNormal];
        [_buttonRight setTitleColor:UIColorTextBlue forState:UIControlStateNormal];
        [_buttonRight setBackgroundColor:[UIColor whiteColor]];
        [_buttonRight.titleLabel setFont:DefaultFont];
        [_buttonRight addTarget:self action:@selector(selectedReset) forControlEvents:UIControlEventTouchUpInside];
        _buttonRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return _buttonRight;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collectionX = 10;
        CGFloat collectionY = ButtonSystemHeight;
        CGFloat collectionW = self.contentView.st_width - 20;
        CGFloat collectionH = self.contentView.st_height - ButtonSystemHeight * 2 -20 - 1;
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((collectionW - 10) / 3, 30);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(collectionX, collectionY, collectionW, collectionH) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"NewChooseProjectCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
        [_collectionView registerNib:[UINib nibWithNibName:@"NewChooseProjectHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewId];
    }
    return _collectionView;
}

- (NSMutableArray<ChooseProjectInfo *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark - 显示/关闭
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        [self.contentView.layer setOpacity:1.0];
        self.contentView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    } completion:^(BOOL finished) {}];
}

- (void)remove {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0.0];
        [self.contentView.layer setOpacity:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 获取CollectionView数据
- (void)makeDataSource {
    NSMutableArray <ChooseProjectInfo *>*list = [NSMutableArray array];
    
    ProjectInfo *checkedPro = nil;
    ProjectInfo *checkedSect = nil;
    
    [list addObject:[[ChooseProjectInfo alloc] initWithTitle:@"项目"]];
    
    for (ProjectInfo *project in [UserAgent DefaultAgent].projectInfos) {
        if ([project.id isEqualToString:self.projectId]) {
            project.selected = YES;
            checkedPro = project;
            for (ProjectInfo *sect in project.children) {
                if ([sect.id isEqualToString:self.sectionId]) {
                    checkedSect = sect;
                    break;
                }
            }
        } else {
            project.selected = NO;
        }
        
        [list.lastObject.children addObject:[[ChooseProjectInfo alloc] initWithProjectInfo:project]];
    }
    
    NSMutableArray <ProjectInfo *>*zbbChild = nil;
    if (checkedPro && (!self.permission || !self.permission.linkType || ![self.permission.linkType isEqualToString:MENU_LINK_TYPE_PRO_ID])) {
        [list addObject:[[ChooseProjectInfo alloc] initWithTitle:@"总承包"]];
        for (ProjectInfo *zbbInfo in checkedPro.tempChildren) {
            ChooseProjectInfo *tempZbbInfo = [[ChooseProjectInfo alloc] initWithProjectInfo:zbbInfo];
            if (checkedSect) {
                if ([zbbInfo.id isEqualToString:checkedSect.id] || (!zbbChild && [zbbInfo.id containsString:checkedSect.parentId])) {
                    tempZbbInfo.selected = YES;
                    zbbChild = zbbInfo.tempChildren;
                } else {
                    tempZbbInfo.selected = NO;
                }
            } else {
                tempZbbInfo.selected = NO;
            }
            [list.lastObject.children addObject:tempZbbInfo];
        }
    }

    if (zbbChild) {
        [list addObject:[[ChooseProjectInfo alloc] initWithTitle:@"标段"]];
        for (ProjectInfo *sectInfo in zbbChild) {
            sectInfo.selected = NO;
            if (self.permission && self.permission.proType && !(sectInfo.otherInfo[@"sectMajor"] != nil && [[self.permission.proType componentsSeparatedByString:@","] containsObject:sectInfo.otherInfo[@"sectMajor"]])) {
                continue;
            }
            ChooseProjectInfo *tempSectInfo = [[ChooseProjectInfo alloc] initWithProjectInfo:sectInfo];
            if (checkedSect) {
                tempSectInfo.selected = [sectInfo.id isEqualToString:checkedSect.id];
            }
            [list.lastObject.children addObject:tempSectInfo];
        }
    }
    
    self.dataSource = [NSMutableArray arrayWithArray:list];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource[section].children.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewChooseProjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    ChooseProjectInfo *model = self.dataSource[indexPath.section].children[indexPath.row];
    cell.nameLabel.text = model.title;
    
    if (model.selected) {
        cell.nameLabel.layer.borderColor = [UIColorFromRGB(0x9CCBF7) CGColor];
        cell.nameLabel.backgroundColor = UIColorFromRGB(0xF1F7FF);
        cell.nameLabel.textColor = UIColorFromRGB(0x2F9BFF);
    } else {
        cell.nameLabel.layer.borderColor = [UIColorFromRGB(0xECECEC) CGColor];
        cell.nameLabel.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.textColor = UIColorFromRGB(0x5C636F);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseProjectInfo *data = self.dataSource[indexPath.section].children[indexPath.row];
    
    if (data.selected) {
        return;
    }
    
    if (data.projectInfo.attributes && data.projectInfo.attributes[@"key"]) {
        NSString *key = data.projectInfo.attributes[@"key"];
        if ([key containsString:@"project"]) {
            [self reloadDataByProjectId:data.projectInfo.id andSectionId:@""];
            return;
        }
    }
    
    NSString *sectionId = data.projectInfo.id;
    if ([sectionId containsString:@"_other"]) {
        for (ProjectInfo *sect in data.projectInfo.tempChildren) {
            if (!self.permission || !self.permission.proType || (sect.otherInfo[@"sectMajor"] != nil && [[self.permission.proType componentsSeparatedByString:@","] containsObject:sect.otherInfo[@"sectMajor"]])) {
                sectionId = sect.id;
                break;
            }
        }
    }
    [self reloadDataByProjectId:self.projectId andSectionId:sectionId];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewId forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader) {
        NewChooseProjectHeaderView *header = (NewChooseProjectHeaderView *)cell;
        header.nameLabel.text = self.dataSource[indexPath.section].title;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 40);
}

#pragma mark - 刷新collectionView
- (void)reloadDataByProjectId:(NSString *)projectId andSectionId:(NSString *)sectionId {
    self.projectId = projectId;
    self.sectionId = sectionId;
    [self makeDataSource];
    [self.collectionView reloadData];
}

#pragma mark - 按钮事件
- (void)selectedOk {
    ProjectInfo *projectInfo = nil;
    ProjectInfo *sectionInfo = nil;
    
    for (ProjectInfo *project in [UserAgent DefaultAgent].projectInfos) {
        if ([project.id isEqualToString:self.projectId]) {
            projectInfo = project;
            for (ProjectInfo *sect in project.children) {
                if ([sect.id isEqualToString:self.sectionId]) {
                    if (self.permission && self.permission.proType && !(sect.otherInfo[@"sectMajor"] != nil && [[self.permission.proType componentsSeparatedByString:@","] containsObject:sect.otherInfo[@"sectMajor"]])) {
                        
                        [MBManager showBriefAlert:@"请选择正确类型的项目/标段"];
                        return;
                    }
                    sectionInfo = sect;
                    break;
                }
            }
            if (self.permission && self.permission.proType && !sectionInfo) {
                [MBManager showBriefAlert:@"请选择标段"];
                return;
            }
            break;
        }
    }
    
    if (!projectInfo) {
        [MBManager showBriefAlert:@"请选择项目/标段"];;
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:projectInfo.id forKey:@"projectId"];
    [UserAgent DefaultAgent].projectId = projectInfo.id;
    [UserAgent DefaultAgent].typeKey =  projectInfo.attributes[@"key"];
    
    if (sectionInfo) {
        [[NSUserDefaults standardUserDefaults]setObject:sectionInfo.id forKey:@"sectId"];
        [UserAgent DefaultAgent].sectionId = sectionInfo.id;
        [UserAgent DefaultAgent].sectionName = sectionInfo.text;
        [UserAgent DefaultAgent].stdVersion = sectionInfo.otherInfo[@"stdVersion"];
        [UserAgent DefaultAgent].sectionMajor = sectionInfo.otherInfo[@"sectMajor"];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"sectId"];
        [UserAgent DefaultAgent].sectionId = @"";
        [UserAgent DefaultAgent].sectionName = @"";
        [UserAgent DefaultAgent].stdVersion = @"";
        [UserAgent DefaultAgent].sectionMajor = @"";
    }
    [UserAgent DefaultAgent].sectionInfos = projectInfo.children;
    [[UserAgent DefaultAgent] saveValuesToCache];
    
    //切换服务器项目
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{
        @"typeKey": projectInfo.attributes[@"key"],
        @"projectId": projectInfo.id,
        @"mainPrjName": projectInfo.text,
        @"mainPrjCode": projectInfo.otherInfo[@"projectCode"],
        @"projectPlanSn": projectInfo.otherInfo[@"projectPlanSn"]
    }];
    if (sectionInfo) {
        [param setObject:sectionInfo.id forKey:@"mainSectionId"];
        [param setObject:sectionInfo.text forKey:@"mainSectionName"];
        [param setObject:sectionInfo.otherInfo[@"sectCode"] forKey:@"mainSectionCode"];
        [param setObject:sectionInfo.otherInfo[@"stdVersion"] forKey:@"stdVersion"];
        [param setObject:sectionInfo.otherInfo[@"sectMajor"] forKey:@"sectionMajor"];
    }
    [[HttpManager manager] post:[UrlConfig URL:setPrjInfo] param:param success:^(NSData *data) {
        if (self.callBack) {
            self.callBack();
        }
        [self remove];
    } faild:^(NSString *msg) {}];
}

- (void)selectedReset {
    [self reloadDataByProjectId:@"" andSectionId:@""];
}

@end
