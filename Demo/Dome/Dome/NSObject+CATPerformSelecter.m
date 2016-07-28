//
//  NSObject+CATPerformSelecter.m
//  Dome
//
//  Created by lbencs on 7/23/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import "NSObject+CATPerformSelecter.h"

@implementation NSObject (CATPerformSelecter)

- (id)at_performSelector:(SEL)aSelector
{
    return [self at_performSelector:aSelector withObjects:nil orVAList:NULL hasArgument:NO];
}
- (id)at_performSelector:(SEL)aSelector withObject:(id)aObject
{
    return [self at_performSelector:aSelector withObjects:aObject,nil];
}
- (id)at_performSelector:(SEL)aSelector
             withObjects:(id)aObject,...
{
    va_list args;
    va_start(args, aObject);
    return [self at_performSelector:aSelector
                        withObjects:aObject
                           orVAList:args];
    va_end(args);
}
- (id)at_performSelector:(SEL)aSelector withObjects:(id)object orVAList:(va_list)args
{
    return [self at_performSelector:aSelector withObjects:object orVAList:args hasArgument:YES];
}
- (id)at_performSelector:(SEL)aSelector
             withObjects:(id)aObject
                orVAList:(va_list)args
             hasArgument:(BOOL)hasArguments
{
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setSelector:aSelector];
    [invocation setTarget:self];
    
    if (hasArguments) {
        NSArray *arguments = __argumentsFromValist(args);
        
        [invocation setArgument:&aObject atIndex:2];
        
        if ([arguments count] > 0) {
            [arguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [invocation setArgument:&obj atIndex:idx+3];
            }];
        }
        [invocation retainArguments];
    }
    [invocation invoke];
    
    return __formatReturnValueToObectObject(invocation);

}

NSArray * __argumentsFromValist(va_list args)
{
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    while (YES) {
        id parameter = va_arg(args, id);
        if (!parameter) {
            break;
        }
        [arguments addObject:parameter];
    }
    return arguments;
}

id __formatReturnValueToObectObject(NSInvocation *invocation)
{
    const char *returnType = invocation.methodSignature.methodReturnType;
    
    __unsafe_unretained id result;
    
    if (!strcmp(returnType, @encode(void))) {
        
        result = nil;
        
    }else if (!strcmp(returnType, @encode(id))){
        
        [invocation getReturnValue:&result];
        
    }else{
        // NSIngeter BOOL
        NSUInteger length = [invocation.methodSignature methodReturnLength];
        
        void *buffer = (void *)malloc(length);
        
        [invocation getReturnValue:buffer];
        
        if (!strcmp(returnType, @encode(BOOL))) {
            
            result = [NSNumber numberWithBool:*((BOOL *)buffer)];
            
        }else if (!strcmp(returnType, @encode(NSInteger))){
            
            result = [NSNumber numberWithInteger:*((NSInteger *)buffer)];
            
        }else{
            result = [NSValue valueWithBytes:buffer objCType:returnType];
        }
    }
    return result;
}

@end
