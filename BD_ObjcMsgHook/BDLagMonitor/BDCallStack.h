//
//  BDCallStack.h
//  BD_ObjcMsgHook
//
//  Created by wangyang on 2021/3/21.
//  Copyright © 2021 BDShare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDCallLib.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BDCallStackType) {
    BDCallStackTypeAll,     //全部线程
    BDCallStackTypeMain,    //主线程
    BDCallStackTypeCurrent  //当前线程
};


@interface BDCallStack : NSObject

+ (NSString *)callStackWithType:(BDCallStackType)type;

extern NSString *BDStackOfThread(thread_t thread);

@end

NS_ASSUME_NONNULL_END
