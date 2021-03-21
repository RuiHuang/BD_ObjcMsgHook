//
//  BDCallStackModel.h
//  BD_ObjcMsgHook
//
//  Created by wangyang on 2021/3/21.
//  Copyright © 2021 BDShare. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDCallStackModel : NSObject

@property (nonatomic, copy) NSString *stackStr;       //完整堆栈信息
@property (nonatomic) BOOL isStuck;                   //是否被卡住
@property (nonatomic, assign) NSTimeInterval dateString;   //可展示信息

@end

NS_ASSUME_NONNULL_END
