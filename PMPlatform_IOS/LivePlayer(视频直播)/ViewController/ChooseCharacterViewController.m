//
//  ChooseCharacterViewController.m
//  ycxm
//
//  Created by 高小伟 on 2021/7/15.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "ChooseCharacterViewController.h"
#import "TLHomeViewController.h"

@interface ChooseCharacterViewController ()
@property (weak, nonatomic) IBOutlet UIView *typeView1;
@property (weak, nonatomic) IBOutlet UIView *typeView2;

@end

@implementation ChooseCharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"在线直播";
}
- (void)viewDidAppear:(BOOL)animated{
    self.typeView1.layer.cornerRadius = 10;
    self.typeView2.layer.cornerRadius = 10;
    
    CAShapeLayer *layer   = [[CAShapeLayer alloc] init];
    layer.frame            = CGRectMake(0, 0 ,self.typeView1.frame.size.width, self.typeView1.frame.size.height);
    layer.backgroundColor   = [UIColor clearColor].CGColor;

    UIBezierPath *path    = [UIBezierPath bezierPathWithRoundedRect:layer.frame cornerRadius:10.0f];
    layer.path             = path.CGPath;
    layer.lineWidth         = 2.0f;
    layer.lineDashPattern    = @[@5, @2];
    layer.fillColor          = [UIColor clearColor].CGColor;
    layer.strokeColor       = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
    [self.typeView1.layer addSublayer:layer];
    
    CAShapeLayer *layer2   = [[CAShapeLayer alloc] init];
    layer2.frame            = CGRectMake(0, 0 ,self.typeView1.frame.size.width, self.typeView1.frame.size.height);
    layer2.backgroundColor   = [UIColor clearColor].CGColor;

    UIBezierPath *path2    = [UIBezierPath bezierPathWithRoundedRect:layer2.frame cornerRadius:10.0f];
    layer2.path             = path2.CGPath;
    layer2.lineWidth         = 2.0f;
    layer2.lineDashPattern    = @[@5, @2];
    layer2.fillColor          = [UIColor clearColor].CGColor;
    layer2.strokeColor       = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0].CGColor;
    [self.typeView2.layer addSublayer:layer2];
}
- (IBAction)tapTypeView:(id)sender {
    TLHomeViewController *vc = [TLHomeViewController new];
    vc.isCreate = true;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)tapTypeView2:(id)sender {
    TLHomeViewController *vc = [TLHomeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
