//
//  XSMXViewController.m
//  UMobile
//
//  Created by mocha on 15/5/4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "XSMXViewController.h"
#import "CangKuViewController.h"
#import "SaleViewController.h"
#import "CustomerListViewController.h"
#import "StockViewController.h"
#import "RCDateView.h"
#import "XSMXDetailViewController.h"
#import "RCLeftNavigationController.h"

@interface XSMXViewController ()

@end

@implementation XSMXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetData];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)resetData{
    [self setText:[self GetCurrentDate] forView:self.view withTag:1];
    [self setText:[self GetCurrentDate] forView:self.view withTag:2];
    self.salesType = [NSMutableArray array];
    self.customerType = [NSMutableArray array];
    self.stockType = [NSMutableArray array];
}

-(void)loadData{
    
    [self setText:@"" forView:self.view withTag:4];
    [self setText:[self.salesType ingoreObjectAtIndex:1] forView:self.view withTag:5];
    [self setText:[self.customerType ingoreObjectAtIndex:1] forView:self.view withTag:6];
    [self setText:[self.stockType ingoreObjectAtIndex:1] forView:self.view withTag:7];
    [self setText:[self.checkType ingoreObjectAtIndex:1] forView:self.view withTag:8];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag != 1 && textField.tag != 2 && textField.tag != 4 ){
        //        CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
        if (textField.tag != 5 && textField.tag != 6 && textField.tag != 7) {
            CangKuViewController *vc = (CangKuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CangKuViewController"];
            switch (textField.tag) {
                case 3:
                    vc.info = self.orderType;
                    vc.title = @"单据类型";
                    vc.result = @[@[@"5",@"进货订单"],@[@"6",@"销售订单"]];
                    break;
                case 8:
                    vc.info = self.checkType;
                    vc.title = @"审核状态";
                    if ([self.setting intForKey:@"ISBS"] == 1) {
                        vc.result = @[@[@"0",@"所有"],@[@"1",@"已审"],@[@"2",@"未审"],@[@"3",@"审核中"]];
                    }else{
                        vc.result = @[@[@"0",@"所有"],@[@"1",@"已审"],@[@"2",@"未审"]];
                    }
                    
                default:
                    break;
            }
            
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (textField.tag == 5){
            SaleViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SaleViewController"];
            if ([[self.orderType objectAtIndex:0] integerValue] == 5)//销售订单
                vc.CustomerType = 4;
            else//进货订单
                vc.CustomerType = 3;
            vc.info = self.salesType;
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (textField.tag == 6){
            CustomerListViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
            if ([[self.orderType objectAtIndex:0] integerValue] == 5)//销售订单
                vc.CustomerType = 4;
            else//进货订单
                vc.CustomerType = 3;
            vc.customerInfo = self.customerType;
            vc.bSelect = YES;
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(textField.tag == 7){
            StockViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StockViewController"];
            vc.info = self.stockType;
            vc.parentVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return NO;
    }else if (textField.tag == 1 || textField.tag == 2){
        RCDateView *dateView =  [[[RCDateView alloc]init] autorelease];
        [dateView ShowViewInObject:self.view withMsg:nil];
        while(dateView.isVisiable) {
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        }
        if (dateView.isOk){
            textField.text = dateView.strDate;
        }
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)sortMenuClick:(KxMenuItem *)item{
    NSDictionary *dates = @{@"本日":@"Today",@"本周":@"thisWeek",@"本月":@"thisMonth"};
    NSDictionary *info = [[self GetOM] getFlowDate];
    [self setText:[info strForKey:[dates strForKey:item.title]] forView:self.view withTag:1];
    [self setText:[info strForKey:@"Today"] forView:self.view withTag:2];
}

- (IBAction)sortClick:(id)sender {
    if ([KxMenu sharedMenu].isVisiable) {
        [KxMenu dismissMenu];
        return;
    }
    NSArray *menus = @[
                       [KxMenuItem menuItem:@"本日" image:[UIImage imageNamed:@"popup_icon_approve_date"] target:self action:@selector(sortMenuClick:)],
                       [KxMenuItem menuItem:@"本周" image:[UIImage imageNamed:@"popup_icon_approve_curweek"] target:self action:@selector(sortMenuClick:)],
                       [KxMenuItem menuItem:@"本月" image:[UIImage imageNamed:@"popup_icon_approve_curmonth"] target:self action:@selector(sortMenuClick:)],
                       ];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(160, 0, 10, 1) menuItems:menus];
}


- (IBAction)resetClick:(id)sender {
    [self resetData];
    [self loadData];
}

- (IBAction)searchClick:(id)sender {
    NSString *param =  [NSString stringWithFormat:@"'%@','%@',%d,%d,%d,'%@','%@',%@,20,1",
                        [self getTextFromView:self.view withTag:4],
                        [self getTextFromView:self.view withTag:3],
                        [[self.customerType ingoreObjectAtIndex:0] intValue],
                        [[self.stockType ingoreObjectAtIndex:0] intValue],
                        [[self.salesType ingoreObjectAtIndex:0] intValue],
                        [self getTextFromView:self.view withTag:1],
                        [self getTextFromView:self.view withTag:2],
                        [self GetUserID]
                        ];
    NSString *link = [self GetLinkWithFunction:93 andParam:param];
    
    NSMutableArray *paramArray = [NSMutableArray arrayWithObjects:
                                  [self getTextFromView:self.view withTag:4],
                                  [self getTextFromView:self.view withTag:3],
                                  [self.customerType ingoreObjectAtIndex:1],
                                  [self.stockType ingoreObjectAtIndex:1],
                                  [self.salesType ingoreObjectAtIndex:1],
                                  [self getTextFromView:self.view withTag:1],
                                  [self getTextFromView:self.view withTag:2],
                                  [NSNumber numberWithInt:[[self GetUserID] intValue]],
                                  [NSNumber numberWithInt:20],
                                  [NSNumber numberWithInt:1], nil];
    
//
//    DDGLViewController *vc = (DDGLViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DDGLViewController"];
//    vc.link = link;
//    vc.param = param;
//    vc.callFunction = [[self.orderType ingoreObjectAtIndex:0] intValue];// 值为 5 或 6 判断是进货订单或销售订单
//    [self.navigationController pushViewController:vc animated:YES];
//    //    NSString *link =  []
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SecondaryStoryboard" bundle:nil];
    XSMXDetailViewController *detail = [storyBoard instantiateViewControllerWithIdentifier:@"XSMXDetailViewController"];
    detail.parma = param;
    detail.link = link;
    detail.paramArray = paramArray;
    RCLeftNavigationController *navi = [[RCLeftNavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:navi animated:YES completion:^{
    }];
    [navi release];
    
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
