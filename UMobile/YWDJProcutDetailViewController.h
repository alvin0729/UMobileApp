//
//  YWDJProcutDetailViewController.h
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@interface YWDJProcutDetailViewController : RCViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *array;
@property (retain, nonatomic) IBOutlet UITableView *dataTableView;
@property(nonatomic , retain) NSMutableArray *dataArray;
@end
