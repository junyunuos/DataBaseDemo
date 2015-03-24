//
//  ViewController.m
//  DataBaseDemo
//
//  Created by guoqiang on 15-2-3.
//  Copyright (c) 2015年 guoqiang. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "NSObject+AddressDBCDispose.h"
@interface ViewController ()

@property(nonatomic,strong)FMDatabase* db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
        [self createDatabase];
        NSMutableArray* addressArr=[[NSMutableArray alloc] init];
        [addressArr addObject:[self selectProvinceList]];
        [addressArr addObject:[self selectCityList:@"1"]];
        [addressArr addObject:[self selectCityList:@"1"]];
    
    NSLog(@"%@",addressArr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
