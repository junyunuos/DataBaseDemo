//
//  NSObject+DBCDispose.h
//  YY_yijia
//
//  Created by guoqiang on 15-1-27.
//  Copyright (c) 2015年 com.yiyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface NSObject (AddressDBCDispose)
@property(nonatomic,strong)FMDatabase* db;

-(void)createDatabase;
-(NSMutableArray*)selectProvinceList;
-(NSMutableArray*)selectCityList:(NSString*)provinceId;
-(NSMutableArray*)selectDistrictList:(NSString*)cityId;
-(NSString*)findByCityId:(int)cityId;
-(NSString*)findByDistrictId:(int)districtId;

@end
