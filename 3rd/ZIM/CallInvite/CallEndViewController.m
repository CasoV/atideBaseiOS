//
//  CallEndViewController.m
//  ZIMExampleDemo
//
//  Created by 武耀琳 on 2023/5/21.
//

#import "CallEndViewController.h"

@interface CallEndViewController ()

@end

@implementation CallEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    __weak typeof(self) weakSelf = self;
//    bool stop = NO;
//    NSThread *thread = [[NSThread alloc] initWithBlock:^{
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//        while (weakSelf &&!stop) {
//            <#statements#>
//        }
//    }];
    
    self.endTimeMinusCreateTimeLabel.text = self.endTimeMinusCreateTime;
    self.endTimeMinusAcceptTimeLabel.text = self.endTimeMinusAcceptTime;
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
