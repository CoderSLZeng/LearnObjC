//
//  SLUseRACTVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/19.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLUseRACTVC.h"

#pragma mark - Tools
#import "SLRACManager.h"

#pragma mark - Controllers
#import "SLRACExampleVC.h"

@interface SLUseRACTVC ()
/** 数据源 */
@property (strong, nonatomic) NSArray *rows;
@end

@implementation SLUseRACTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.确定重用标示
    static NSString *identifier = @"RACCell";
    // 2.从缓存池中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.rows[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *text = self.rows[indexPath.row];
    if ([text hasPrefix:@"use"]) {
        [SLRACManager performSelector:NSSelectorFromString(text)];
    } else if ([text isEqualToString:@"ReactiveObjC使用场景"]) {
        SLRACExampleVC *vc = [[SLRACExampleVC alloc] init];
        vc.navigationItem.title = text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Getter
- (NSArray *)rows {
    return @[@"useRACSignal",
             @"useRACSubject",
             @"useRACReplaySubject",
             @"useRACTuple",
             @"useRACMulticastConnection",
             @"useRACCommandWithExecute",
             @"useRACCommandWithExecutionSignals",
             @"useRACCommandWithExecuting",
             @"useRACCommandWithExecutingSkip",
             @"useRACCommandWithExecutionSignalsSwitchToLatest",
             @"use_rac_flattenMap_map",
             @"use_rac_concat",
             @"use_rac_concat2",
             @"use_rac_concat3",
             @"use_rac_then",
             @"use_rac_then2",
             @"use_rac_merge",
             @"use_rac_zipWith",
             @"use_rac_combineLatest_reduce",
             @"use_rac_filter",
             @"use_rac_interval",
             @"ReactiveObjC使用场景"
             ];
}




@end
