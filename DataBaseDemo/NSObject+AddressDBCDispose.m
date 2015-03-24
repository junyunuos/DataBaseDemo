//
//  NSObject+DBCDispose.m
//  YY_yijia
//
//  Created by guoqiang on 15-1-27.
//  Copyright (c) 2015年 com.yiyou. All rights reserved.
//

#import "NSObject+AddressDBCDispose.h"
#import "FMDB.h"

@implementation NSObject (AddressDBCDispose)//省份城市区域数据库操作

@dynamic db;

#pragma  创建数据库
-(void)createDatabase{
    
    //address.db 这是一个数据库文件、里面包含四表、province,City,Distict,
    
    NSString* fileName=[self searchDatabaseDir];
    //获得数据库
    FMDatabase* db=[FMDatabase databaseWithPath:fileName];
    [db open];//打开数据库
    
    self.db=db;
}
#pragma 查找本地数据库文件
-(NSString*)searchDatabaseDir{
    
    //查找本地数据库路径
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                               NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来， 这里用到了宏定义（目的是不易出错)
    NSString* dbFilePath= [documentFolderPath stringByAppendingPathComponent:@"address.db"];
    
    //通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbFilePath];
    
    if (!isExist)
    {
        //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:@"address"
                                  ofType:@"db"];
        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
        dbFilePath=backupDbPath;
    }
    return dbFilePath;
}

#pragma  查找Province数据
-(NSMutableArray*)selectProvinceList{
    
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM Province"];
    
    NSMutableArray* arr=[[NSMutableArray alloc] init];
    
    while ([resultSet next]) {
        int ids=[resultSet intForColumn:@"id"];
        NSString* provinceName=[resultSet stringForColumn:@"provinceName"];
        
        NSString* provinceId=[NSString stringWithFormat:@"%d",ids];
        
        NSDictionary* dic=[[NSDictionary alloc] initWithObjectsAndKeys:provinceId,@"provinceId",provinceName,@"provinceName",nil];
        [arr addObject:dic];
    }
    return arr;
}

#pragma 查找City数据
-(NSMutableArray*)selectCityList:(NSString*)provinceId{
    
   NSMutableArray* arr=[[NSMutableArray alloc] init];
   FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM City where provinceId=?",provinceId];
    
    while ([resultSet next]) {
        int c_id=[resultSet intForColumn:@"id"];
        NSString* cityName=[resultSet stringForColumn:@"cityName"];
        NSString* cityId=[NSString stringWithFormat:@"%d",c_id];
        NSString* domain=[resultSet stringForColumn:@"domain"];
        
        NSDictionary* dic=[[NSDictionary alloc] initWithObjectsAndKeys:cityId,@"cityId",cityName,@"cityName",domain,@"domain",nil];
        [arr addObject:dic];
    }
    return arr;
}

#pragma 查找District数据
-(NSMutableArray*)selectDistrictList:(NSString*)cityId{
    
    NSMutableArray* arr=[[NSMutableArray alloc] init];
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM District where cityId=?",cityId];
    
    while ([resultSet next]) {
        int d_id=[resultSet intForColumn:@"id"];
        NSString* districtName=[resultSet stringForColumn:@"districtName"];
        
        NSString* districtId=[NSString stringWithFormat:@"%d",d_id];
        NSString* latitude=[resultSet stringForColumn:@"latitude"];
        NSString* longitude=[resultSet stringForColumn:@"longitude"];
        
        NSDictionary* dic=[[NSDictionary alloc] initWithObjectsAndKeys:districtId,@"districtId",districtName,@"districtName",latitude,@"latitude",longitude,@"longitude",nil];
        [arr addObject:dic];
    }
    return arr;
}

#pragma 根据cityId查找数据
-(NSString*)findByCityId:(int)cityId{
    
    NSString* parameter=[NSString stringWithFormat:@"%d",cityId];
    
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM City where id=?",parameter];
    NSString* cityName=@"";
    while ([resultSet next]) {
         cityName=[resultSet stringForColumn:@"cityName"];
    }
    return cityName;
}

#pragma 根据districtId查找数据
-(NSString*)findByDistrictId:(int)districtId{
    
    NSString* parameter=[NSString stringWithFormat:@"%d",districtId];
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM District where id=?",parameter];
    NSString* disName=@"";
    while ([resultSet next]) {
       disName=[resultSet stringForColumn:@"districtName"];
    }
    return disName;
}
@end

