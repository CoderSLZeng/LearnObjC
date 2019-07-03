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
/** 头部数据 */
@property (strong, nonatomic) NSArray *sectionDatas;

/** 数据源 */
/** 常见类数据源 */
@property (strong, nonatomic) NSArray *classDatas;
/** 绑定数据源 */
@property (strong, nonatomic) NSArray *bindDatas;
/** 映射数据源 */
@property (strong, nonatomic) NSArray *mapDatas;
/** 绑定数据源 */
@property (strong, nonatomic) NSArray *combineDatas;
/** 过滤数据源 */
@property (strong, nonatomic) NSArray *filterDatas;
/** 秩序数据源 */
@property (strong, nonatomic) NSArray *orderDatas;
/** 线程数据源 */
@property (strong, nonatomic) NSArray *threadDatas;
/** 时间数据源 */
@property (strong, nonatomic) NSArray *timeDatas;
/** 重复数据源 */
@property (strong, nonatomic) NSArray *replayDatas;
/** 其他数据源 */
@property (strong, nonatomic) NSArray *otherDatas;
@end


@implementation SLUseRACTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = 0;
    switch (section) {
        case 0:
            count = self.classDatas.count;
            break;
        case 1:
            count = self.bindDatas.count;
            break;
        case 2:
            count = self.mapDatas.count;
            break;
        case 3:
            count = self.combineDatas.count;
            break;
        case 4:
            count = self.filterDatas.count;
            break;
        case 5:
            count = self.orderDatas.count;
            break;
        case 6:
            count = self.threadDatas.count;
            break;
        case 7:
            count = self.timeDatas.count;
            break;
        case 8:
            count = self.replayDatas.count;
            break;
        case 9:
            count = self.otherDatas.count;
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示
    static NSString *identifier = @"RACCell";
    // 2.从缓存池中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.classDatas[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.bindDatas[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = self.mapDatas[indexPath.row];
            break;
        case 3:
            cell.textLabel.text = self.combineDatas[indexPath.row];
            break;
        case 4:
            cell.textLabel.text = self.filterDatas[indexPath.row];
            break;
        case 5:
            cell.textLabel.text = self.orderDatas[indexPath.row];
            break;
        case 6:
            cell.textLabel.text = self.threadDatas[indexPath.row];
            break;
        case 7:
            cell.textLabel.text = self.timeDatas[indexPath.row];
            break;
        case 8:
            cell.textLabel.text = self.replayDatas[indexPath.row];
            break;
        case 9:
            cell.textLabel.text = self.otherDatas[indexPath.row];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text = @"";
    switch (indexPath.section) {
        case 0:
            text = self.classDatas[indexPath.row];
            break;
        case 1:
            text = self.bindDatas[indexPath.row];
            break;
        case 2:
            text = self.mapDatas[indexPath.row];
            break;
        case 3:
            text = self.combineDatas[indexPath.row];
            break;
        case 4:
            text = self.filterDatas[indexPath.row];
            break;
        case 5:
            text = self.orderDatas[indexPath.row];
            break;
        case 6:
            text = self.threadDatas[indexPath.row];
            break;
        case 7:
            text = self.timeDatas[indexPath.row];
            break;
        case 8:
           text = self.replayDatas[indexPath.row];
            break;
        case 9:
            text = self.otherDatas[indexPath.row];
            break;
        default:
            break;
    }

    if ([text hasPrefix:@"use"]) {
        [SLRACManager performSelector:NSSelectorFromString(text)];
    } else if ([text isEqualToString:@"ReactiveObjC使用场景"]) {
        SLRACExampleVC *vc = [[SLRACExampleVC alloc] init];
        vc.navigationItem.title = text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.sectionDatas[section];
}

#pragma mark - Getter
- (NSArray *)sectionDatas {
    return @[
             @"常见类",
             @"核心方法之绑定",
             @"操作方法之映射",
             @"操作方法之组合",
             @"操作方法之过滤",
             @"操作方法之秩序",
             @"操作方法之线程",
             @"操作方法之时间",
             @"操作方法之重复",
             @"基本应用"
             ];
}

- (NSArray *)classDatas {
    return @[
             @"use_RACSignal",
             @"use_RACSubject",
             @"use_RACReplaySubject",
             @"use_RACTuple",
             @"use_RACMulticastConnection",
             @"use_RACCommandWithExecute",
             @"use_RACCommandWithExecutionSignals",
             @"use_RACCommandWithExecuting",
             @"use_RACCommandWithExecutingSkip",
             @"use_RACCommandWithExecutionSignalsSwitchToLatest"
             ];
}

- (NSArray *)bindDatas {
    return @[@"use_rac_bind"];
}

- (NSArray *)mapDatas {
    return @[
             @"use_rac_flattenMap",
             @"use_rac_map",
             @"use_rac_flattenMap_map"
             ];
}

- (NSArray *)combineDatas {
    return @[
             @"use_rac_concat",
             @"use_rac_concat2",
             @"use_rac_concat3",
             @"use_rac_then",
             @"use_rac_then2",
             @"use_rac_merge",
             @"use_rac_zipWith",
             @"use_rac_combineLatest",
             @"use_rac_reduce",
             @"use_rac_combineLatest_reduce"
             ];
}

- (NSArray *)filterDatas {
    return @[
             @"use_rac_filter",
             @"use_rac_ignore",
             @"use_rac_distinctUntilChanged",
             @"use_rac_take",
             @"use_rac_takeLast",
             @"use_rac_takeUntil",
             @"use_rac_skip",
             @"use_rac_switchToLatest"
             ];
}

- (NSArray *)orderDatas {
    return @[@"use_rac_doNext_doCompleted"];
}

- (NSArray *)threadDatas {
    return @[@"use_rac_deliverOn_subscribeOn"];
}

- (NSArray *)timeDatas {
    return @[
             @"use_rac_timeout",
             @"use_rac_interval",
             @"use_rac_delay"
             ];
}

- (NSArray *)replayDatas {
    return @[
             @"use_rac_retry",
             @"use_rac_replay",
             @"use_rac_throttle"
             ];
}

- (NSArray *)otherDatas {
    return @[@"ReactiveObjC使用场景"];
}




@end
