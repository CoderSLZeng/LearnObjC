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
    
    NSString *string = self.rows[indexPath.row];
    [SLRACManager performSelector:NSSelectorFromString(string)];
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
             @"useRACCommandWithExecutionSignalsSwitchToLatest"
             ];
}




@end
