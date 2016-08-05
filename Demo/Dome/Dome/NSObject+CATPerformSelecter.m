//
//  NSObject+CATPerformSelecter.m
//  Dome
//
//  Created by lbencs on 7/23/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import "NSObject+CATPerformSelecter.h"
#import "Dome-swift.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>

@implementation NSObject (CATRuntime)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleMethods:@selector(at_testSwizzleMethod) withSelector:@selector(CATTestSwizzleMethod)];
        [[self class] replaceMethod:@selector(at_testReplaceMethod) replaceSelector:@selector(CATTestReplaceMethod)];
    });
}

- (BOOL)at_testMethodForSelector
{
    void (*setter)(id, SEL, id, id);
    int i;
    id target = [NSMutableDictionary new];
    
    setter = (void (*)(id, SEL, id, id))[target methodForSelector:@selector(setObject:forKey:)];
    for ( i = 0 ; i < 1000 ; i++ )
        setter(target, @selector(setObject:forKey:), @(i).stringValue, @(i).stringValue);
    return [target count] == 1000;
}

- (BOOL)at_testSwizzleMethod
{
    return NO;
}
- (BOOL)CATTestSwizzleMethod
{
    return YES;
}

- (BOOL)at_testReplaceMethod
{
    return NO;
}
- (BOOL)CATTestReplaceMethod
{
    return YES;
}




@end


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
- (id)at_performSelector:(SEL)aSelector args:(va_list)args
{
	return [self at_performSelector:aSelector withObjects:nil orVAList:args hasArgument:YES];
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
		
		int index = 2;
		if (aObject) {
			[invocation setArgument:&aObject atIndex:index++];
		}
        
        if ([arguments count] > 0) {
            [arguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [invocation setArgument:&obj atIndex:idx+index];
            }];
        }
        [invocation retainArguments];
    }
    [invocation invoke];
    
    return __formatReturnValueToObectObject(invocation);

}

#pragma mark - private

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


@implementation NSObject (CATExtentions)

+ (NSArray<NSString *> *)at_allIvarNames
{
    NSMutableArray *ivars = [[NSMutableArray alloc] init];
    
    unsigned int count;
    
    Ivar *ivarList = class_copyIvarList([self class],&count);
    
    for (int i = 0; i < count; i ++) {
        
        Ivar ivar = ivarList[i];
        
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        [ivars addObject:name];
    }
    
    free(ivarList);
    
    NSLog(@"ivars: %@",ivars);
    
    return [ivars copy];
}
+ (NSArray <NSString *> *)at_allPropertyNames
{
    NSMutableArray *propertys = [[NSMutableArray alloc] init];
    
    unsigned int count = 0;
    
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i ++) {
        
        objc_property_t property = propertyList[i];
        
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        
        [propertys addObject:name];
    }
    
    free(propertyList);
    
    NSLog(@"propertys: %@",propertys);
    
    return [propertys copy];
}


//- (void)encodeWithCoder:(NSCoder *)coder
//{
//    [super encodeWithCoder:coder];
//    
//}

@end


@implementation CATEncodeTestModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        NSArray *propertyNames = [[self class] at_allPropertyNames];
        for (NSString *name in propertyNames) {
            [self setValue:[coder decodeObjectForKey:name] forKey:name];
        }
//        self.propertyName = [coder decodeObjectForKey:@"propertyName"];
//        self.propertyCaches = [coder decodeObjectForKey:@"propertyCaches"];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    NSArray *propertyNames = [[self class] at_allPropertyNames];
    NSArray *ivarNames = [[self class] at_allIvarNames];
    
    NSLog(@"%@'s propertys: %@",self, propertyNames);
    NSLog(@"%@'s ivars: %@",self, ivarNames);
    
    
    for (NSString *property in propertyNames) {
        SEL getSel = NSSelectorFromString(property);
        [coder encodeObject:[self performSelector:getSel] forKey:property];
    }
    
//    [coder encodeObject:self.propertyName forKey:@"propertyName"];
//    [coder encodeObject:self.propertyCaches forKey:@"propertyCaches"];
}

@end