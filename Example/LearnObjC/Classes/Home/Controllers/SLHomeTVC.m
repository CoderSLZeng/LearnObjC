//
//  SLHomeTVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/14.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLHomeTVC.h"

@interface SLHomeTVC ()

/** 数据源 */
@property (strong, nonatomic) NSArray<NSString *> *rows;

@end

@implementation SLHomeTVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示
    static NSString *identifier = @"HomeCell";
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
    NSArray *texts = [text componentsSeparatedByString:@"-"];
    NSString *VCName = texts.lastObject;
    id cls = [[NSClassFromString(VCName) alloc] init];
    if ([cls isKindOfClass:[UIViewController class]]) {
        UIViewController *VC = (UIViewController *)cls;
        VC.navigationItem.title = texts.firstObject;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Getter
- (NSArray<NSString *> *)rows {
    return @[
             @"链式编程思想-SLChianVC",
             @"响应式编程思想-SLObserverVC",
             @"函数式编程思想-SLFunctionVC"
             ];
}
@end
