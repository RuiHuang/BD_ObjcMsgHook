//
//  BDCallTraceCore.h
//  BD_ObjcMsgHook
//
//  Created by wangyang on 2021/3/21.
//  Copyright © 2021 BDShare. All rights reserved.
//

#ifndef BDCallTraceCore_h
#define BDCallTraceCore_h

#include <stdio.h>
#include <objc/objc.h>

typedef struct {
    __unsafe_unretained Class cls;
    SEL sel;
    uint64_t time; // us (1/1000 ms)
    int depth;
} BDCallRecord;

extern void BDCallTraceStart(void);
extern void BDCallTraceStop(void);

extern void BDCallConfigMinTime(uint64_t us); //default 1000
extern void BDCallConfigMaxDepth(int depth);  //default 3

extern BDCallRecord *BDGetCallRecords(int *num);
extern void BDClearCallRecords(void);

#endif /* BDCallTraceCore_h */
