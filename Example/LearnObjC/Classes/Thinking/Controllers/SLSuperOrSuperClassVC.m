//
//  SLSuperOrSuperClassVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLSuperOrSuperClassVC.h"
#import "SLSon.h"

@interface SLSuperOrSuperClassVC ()

@end

@implementation SLSuperOrSuperClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SLSon *son = [[SLSon alloc] init];
    [son printSuperOfSuperClass];
}


@end
