//
//  SLDouBanFMTVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

/**
需求：请求豆瓣FM频道列表数据，url:http://www.douban.com/j/app/radio/channels

分析：请求一样，交给VM模型管理

步骤:
1.控制器提供一个视图模型（bookInfoVM），处理界面的业务逻辑
2.VM提供一个命令，处理请求业务逻辑
3.在创建命令的block中，会把请求包装成一个信号，等请求成功的时候，就会把数据传递出去。
4.请求数据成功，应该把字典转换成模型，保存到视图模型中，控制器想用就直接从视图模型中获取。
5.假设控制器想展示内容到tableView，直接让视图模型成为tableView的数据源，把所有的业务逻辑交给视图模型去做，这样控制器的代码就非常少了。
*/


#import "SLDouBanFMTVC.h"

#pragma mark - ViewModels
#import "SLDouBanFMViewModel.h"

@interface SLDouBanFMTVC ()

@property (strong, nonatomic) SLDouBanFMViewModel *FMVM;
@end

@implementation SLDouBanFMTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 请求豆瓣FM频道列表数据
    @weakify(self);
    [[self.FMVM.loadFMChannelDataCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"%@", x);
        // 刷新表格
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
    
    // 绑定视图模型，对控件的设置
    [self.FMVM bindView:self.tableView];
}


#pragma mark - Getter
- (SLDouBanFMViewModel *)FMVM {
    if (!_FMVM) _FMVM = [[SLDouBanFMViewModel alloc] init];
    
    return _FMVM;
}


@end
