//
//  SLDouBanBookInfoViewModel.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLDouBanFMViewModel.h"

#pragma mark Models
#import "SLDouBanFMChannelModel.h"
#import "SLDouBanFMChannelCellViewModel.h"

#pragma mark Views
#import "SLDouBanFMChannelCell.h"

#pragma mark Frameworks
#import <SLToolObjCKit/SLNetworkTool.h>
#import <MJExtension/MJExtension.h>

@interface SLDouBanFMViewModel () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray<SLDouBanFMChannelCellViewModel *> *channelCellVMs;

@end

@implementation SLDouBanFMViewModel

- (void)bindView:(UIView *)view {
    UITableView *tableView = (UITableView *)view;
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (RACCommand *)loadFMChannelDataCommand {
    if (!_loadFMChannelDataCommand) {
        // 请求数据
        @weakify(self)
        _loadFMChannelDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                @strongify(self)

                // 发送请求
                NSString *URL = @"http://www.douban.com/j/app/radio/channels";
               
                [[SLNetworkTool sharedNetworkTool] GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSArray *channels = [SLDouBanFMChannelModel mj_objectArrayWithKeyValuesArray:responseObject[@"channels"]];
                    
                    self.channelCellVMs = [[channels.rac_sequence map:^id _Nullable(id  _Nullable value) {
                        // 创建Cell视图模型
                        SLDouBanFMChannelCellViewModel *cellVM = [[SLDouBanFMChannelCellViewModel alloc] init];
                        cellVM.model = value;
                        return cellVM;
                    }] array];
                    
                    // 请求成功
                    [subscriber sendNext:channels];
                    [subscriber sendCompleted];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    // 请求失败
                    [subscriber sendError:error];
                }];
            
                return nil;
            }];
            
        }];
    }
    
    return _loadFMChannelDataCommand;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelCellVMs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.确定重用标示
    static NSString *identifier = @"DouBanFMChannelCell";
    // 2.从缓存池中取
    SLDouBanFMChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[SLDouBanFMChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // 视图模型
    SLDouBanFMChannelCellViewModel *cellVM = self.channelCellVMs[indexPath.row];
    
    // 绑定视图模型
    [cellVM bindView:cell];
    return cell;
}

#pragma mark - Table view data delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
