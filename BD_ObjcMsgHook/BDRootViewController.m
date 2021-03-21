//
//  BDRootViewController.m
//  BD_ObjcMsgHook
//
//  Created by wangyang on 2021/3/21.
//  Copyright © 2021 BDShare. All rights reserved.
//

#import "BDRootViewController.h"

#import "BDCallTrace.h"
#import "BDLagMonitor.h"

@interface BDRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    //开始记录
//    [self p_ddd];

    [[BDLagMonitor shareInstance] beginMonitor];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if (indexPath.row == 1) {
        sleep(3);
    }
    
    return cell;
}

- (void)p_ddd
{
    [BDCallTrace start];
    
    [self p_test1];
    [self p_test2];
    [self p_test3];
    
    
    [BDCallTrace stop];
    [BDCallTrace save];
}

- (void)p_test1 {
    NSInteger i = 0;
    while (i<400000000) {
        i++;
    }
    NSLog(@"循环5亿次的时间结束%ld",i);
}


- (void)p_test2 {
    sleep(2);
    NSLog(@"睡眠秒结束");
}

- (void)p_test3 {
    
    int i = 0;
    while (i<200000000) {
        i++;
    }
    NSLog(@"循环100万次的时间结束");
}

@end
