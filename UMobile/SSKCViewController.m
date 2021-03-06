//
//  SSKCViewController.m
//  UMobile
//
//  Created by mocha on 15/5/4.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "SSKCViewController.h"
#import "StockViewController.h"
#import "KCCXViewController.h"

@interface SSKCViewController ()

@end

@implementation SSKCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetData];
    [self loadData];
    
}

-(void)resetData{
    self.stockType = [NSMutableArray array];
}

-(void)loadData{
    [self setText:[self.stockType ingoreObjectAtIndex:1] forView:self.view withTag:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 10){
        StockViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StockViewController"];
        vc.info = self.stockType;
        vc.parentVC = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

-(IBAction)restClick:(id)sender{
    [self resetData];
    [self loadData];
}

-(IBAction)searchClick:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecondaryStoryboard" bundle:nil];
    KCCXViewController *vc = (KCCXViewController *)[storyboard instantiateViewControllerWithIdentifier:@"KCCXViewController"];
    UITextField *tf = (UITextField *)[self.view viewWithTag:10];
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:9];
    vc.shangpinName = tf1.text;
    vc.cangkuName = tf.text;
    [self.navigationController pushViewController:vc animated:YES];
    
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
