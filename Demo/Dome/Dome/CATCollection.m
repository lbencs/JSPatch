//
//  CATCollection.m
//  Dome
//
//  Created by lbencs on 8/4/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import "CATCollection.h"
#import <objc/runtime.h>

@interface CATCollection ()
@end

@implementation CATCollection
NSString * dynamicMethodIMP(id self, SEL _cmd)
{
    return @"string";
}
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"testDynamicResolue"]) {
        class_addMethod([self class],
                        sel,
                        (IMP)dynamicMethodIMP,
                        "@@:");
    }
    return [super resolveInstanceMethod:sel];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [self.array methodSignatureForSelector:aSelector];
        if (!signature) {
            signature = [self.dic methodSignatureForSelector:aSelector];
        }
    }
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.array respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.array];
    }else if ([self.dic respondsToSelector:anInvocation.selector]){
        [anInvocation invokeWithTarget:self.dic];
    }else{
        [super forwardInvocation:anInvocation];
    }
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}
- (NSMutableDictionary *)dic
{
    if (!_dic) {
        _dic = [[NSMutableDictionary alloc] init];
    }
    return _dic;
}
@end
