//
//  PopController.m
//  DnpPop_Example
//
//  Created by Zomfice on 2019/9/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "PopController.h"
#import "DnpPop-Swift.h"

@interface PopController ()
@property (nonatomic,strong) DnpPop * tip;
@end

@implementation PopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tip = [[DnpPop alloc]init];
    self.tip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tip.edgeMargin = 10;
    self.tip.shouldDismissOnTap = NO;
    self.tip.shouldDismissOnTapOutside = NO;
    self.tip.shouldDismissOnSwipeOutside = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)rightClick:(UIButton *)sender {
    UIView * custom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 80)];
    custom.backgroundColor = UIColor.redColor;
    
    //[self.tip showWithCustomView:custom direction:DnpPopDirectionDown in:self.view from:sender.frame];
    self.tip.arrowRadius = 2;
    self.tip.cornerRadius = 10;
    [self.tip showWithText:@"I have a offset to move the bubble down or left side." direction:DnpPopDirectionLeft maxWidth:150 in:self.view from:sender.frame];
}

@end
