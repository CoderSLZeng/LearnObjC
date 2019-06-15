//
//  SLObserverVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/14.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLObserverVC.h"
#import "SLPerson.h"
#import "NSObject+KVO.h"

@interface SLObserverVC ()

@property (strong, nonatomic) SLPerson *person;

@end

@implementation SLObserverVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self testNormal];
    [self testKVO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.age += 1;
}

- (void)dealloc {
    [self.person removeObserver:self forKeyPath:@"age"];
}

#pragma mark - Test function
- (void)testNormal {
    // self.person.isa == SLPerson
    self.person = [[SLPerson alloc] init];
    self.person.age = 17;
    [self.person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"%@", self.person);
}

- (void)testKVO {
    // NSKVONotifying_SLPerson是使用Runtime动态创建的一个类，是SLPerson的子类
    // self.person.isa == NSKVONotifying_SLPerson
    self.person = [[SLPerson alloc] init];
    self.person.age = 18;
    [self.person sl_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"%@", self.person);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {

    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change[NSKeyValueChangeNewKey], context);
    NSLog(@"age = %ld", (long)self.person.age);
}



@end
