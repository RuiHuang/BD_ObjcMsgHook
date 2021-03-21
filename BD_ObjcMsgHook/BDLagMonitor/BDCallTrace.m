//
//  BDCallTrace.m
//  BD_ObjcMsgHook
//
//  Created by wangyang on 2021/3/21.
//  Copyright © 2021 BDShare. All rights reserved.
//

#import "BDCallTrace.h"
#import "BDCallLib.h"
#import "BDCallTraceTimeCostModel.h"
#import "BDLagDB.h"

@implementation BDCallTrace

#pragma mark - Trace
#pragma mark - OC Interface

+ (void)start {
    BDCallTraceStart();
}

+ (void)startWithMaxDepth:(int)depth {
    BDCallConfigMaxDepth(depth);
    [BDCallTrace start];
}

+ (void)startWithMinCost:(double)ms {
    BDCallConfigMinTime(ms * 1000);
    [BDCallTrace start];
}

+ (void)startWithMaxDepth:(int)depth minCost:(double)ms {
    BDCallConfigMaxDepth(depth);
    BDCallConfigMinTime(ms * 1000);
    [BDCallTrace start];
}

+ (void)stop {
    BDCallTraceStop();
}

+ (void)save {
    NSMutableString *mStr = [NSMutableString new];
    NSArray<BDCallTraceTimeCostModel *> *arr = [self loadRecords];
    for (BDCallTraceTimeCostModel *model in arr) {
        //记录方法路径
        model.path = [NSString stringWithFormat:@"[%@ %@]",model.className, model.methodName];
        [self appendRecord:model to:mStr];
    }
    
    NSLog(@"\n%@",mStr);
}

+ (void)stopSaveAndClean {
    [BDCallTrace stop];
    [BDCallTrace save];
    BDClearCallRecords();
}

+ (void)appendRecord:(BDCallTraceTimeCostModel *)cost to:(NSMutableString *)mStr {
    [mStr appendFormat:@"%@\n", [cost des]];
//    [mStr appendFormat:@"%@\n path%@\n", [cost des], cost.path];
    if (cost.subCosts.count < 1) {
        cost.lastCall = YES;
        //记录到数据库中
        [[BDLagDB shareInstance] addWithClsCallModel:cost];
    } else {
        for (BDCallTraceTimeCostModel *model in cost.subCosts) {
            if ([model.className isEqualToString:@"BDCallTrace"]) {
                break;
            }
            //记录方法的子方法的路径
            model.path = [NSString stringWithFormat:@"%@ - [%@ %@]",cost.path,model.className,model.methodName];
            [self appendRecord:model to:mStr];
        }
    }
    
}

+ (NSArray<BDCallTraceTimeCostModel *>*)loadRecords {
    NSMutableArray<BDCallTraceTimeCostModel *> *arr = [NSMutableArray new];
    int num = 0;
    BDCallRecord *records = BDGetCallRecords(&num);
    for (int i = 0; i < num; i++) {
        BDCallRecord *rd = &records[i];
        BDCallTraceTimeCostModel *model = [BDCallTraceTimeCostModel new];
        model.className = NSStringFromClass(rd->cls);
        model.methodName = NSStringFromSelector(rd->sel);
        model.isClassMethod = class_isMetaClass(rd->cls);
        model.timeCost = (double)rd->time / 1000000.0;
        model.callDepth = rd->depth;
        [arr addObject:model];
    }
    NSUInteger count = arr.count;
    for (NSUInteger i = 0; i < count; i++) {
        BDCallTraceTimeCostModel *model = arr[i];
        if (model.callDepth > 0) {
            [arr removeObjectAtIndex:i];
            //Todo:不需要循环，直接设置下一个，然后判断好边界就行
            for (NSUInteger j = i; j < count - 1; j++) {
                //下一个深度小的话就开始将后面的递归的往 sub array 里添加
                if (arr[j].callDepth + 1 == model.callDepth) {
                    NSMutableArray *sub = (NSMutableArray *)arr[j].subCosts;
                    if (!sub) {
                        sub = [NSMutableArray new];
                        arr[j].subCosts = sub;
                    }
                    [sub insertObject:model atIndex:0];
                }
            }
            i--;
            count--;
        }
    }
    return arr;
}

@end
