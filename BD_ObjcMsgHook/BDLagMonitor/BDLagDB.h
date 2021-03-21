//
//  BDLagDB.h
//  BD_ObjcMsgHook
//
//  Created by wangyang on 2021/3/21.
//  Copyright © 2021 BDShare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDB.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "BDCallTraceTimeCostModel.h"
#import "BDCallStackModel.h"

NS_ASSUME_NONNULL_BEGIN

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define CPUMONITORRATE 80
#define STUCKMONITORRATE 88

@interface BDLagDB : NSObject

+ (BDLagDB *)shareInstance;
/*------------卡顿和CPU超标堆栈---------------*/
- (RACSignal *)increaseWithStackModel:(BDCallStackModel *)model;
- (RACSignal *)selectStackWithPage:(NSUInteger)page;
- (void)clearStackData;
/*------------ClsCall方法调用频次-------------*/
//添加记录s
- (void)addWithClsCallModel:(BDCallTraceTimeCostModel *)model;
//分页查询
- (RACSignal *)selectClsCallWithPage:(NSUInteger)page;
//清除数据
- (void)clearClsCallData;

@end

NS_ASSUME_NONNULL_END
