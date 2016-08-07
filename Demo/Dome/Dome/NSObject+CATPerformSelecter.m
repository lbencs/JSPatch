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

@interface CATIvar : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
- (NSString *)modelString;
@end

@implementation CATIvar
- (NSString *)modelString
{
    NSString *regex = @"\"([^\"]*)\"";//@"\"(.*?)\"";
    NSError *error = nil;
    NSRegularExpression *expression =
    [NSRegularExpression regularExpressionWithPattern:regex
                                              options:0
                                                error:&error];
    if (!error) {
        NSTextCheckingResult *match =
        [expression firstMatchInString:_type//@"{\"internal_1\": [{\"version\": 4,\"addr\": \"192.160.1.11\"}]}"//_type
                               options:0
                                 range:NSMakeRange(0, [_type length])];
        if (match) {
            // 截获特定的字符串
            NSString *result = [_type substringWithRange:match.range];
            result = [result substringFromIndex:1];
            result = [result substringToIndex:result.length -1];
            NSLog(@"%@",result);
            return result;
        }
    }
    return nil;
}
@end


BOOL _isArrayObjc(id objc)
{
    return [objc isKindOfClass:[NSArray class]];
}
BOOL _isDictionaryObjc(id objc)
{
    return [objc isKindOfClass:[NSDictionary class]];
}
BOOL _isJsonObject(id objc)
{
    return [objc isKindOfClass:[NSString class]] ||
    [objc isKindOfClass:[NSArray class]] ||
    [objc isKindOfClass:[NSDictionary class]] ||
    [objc isKindOfClass:[NSNumber class]] ||
    [objc isKindOfClass:[NSNull class]];
}

@implementation NSObject (CATExtentions)

- (NSDictionary *)at_classAtArrays
{
    return nil;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        [self swizzleMethods:@selector(setValue:forUndefinedKey:) withSelector:@selector(<#selector#>)]
    });
}
+ (NSArray *)at_allIvars
{
    NSMutableArray *ivars = [[NSMutableArray alloc] init];
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        CATIvar *model = [[CATIvar alloc] init];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        model.name = [name hasPrefix:@"_"] ? [name substringFromIndex:1] : name;
        model.type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        [ivars addObject:model];
    }
    return [ivars copy];
}
+ (NSArray<NSString *> *)at_allIvarNames
{
    NSMutableArray *ivars = [[NSMutableArray alloc] init];
    
    unsigned int count;
    
    Ivar *ivarList = class_copyIvarList([self class],&count);
    
    for (int i = 0; i < count; i ++) {
        
        Ivar ivar = ivarList[i];
        
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        if ([name hasPrefix:@"_"]) {
            name = [name substringFromIndex:1];
        }
        
        [ivars addObject:name];
    }
    
    free(ivarList);
    
    //    NSLog(@"ivars: %@",ivars);
    
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
    
    return [propertys copy];
}
+ (NSArray *)at_JSONObjcArrayToModelArray:(NSArray *)jsonArray
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id objc in jsonArray) {
        if (_isDictionaryObjc(objc)) {
            [arr addObject:[self at_JSONObjcToModel:objc]];
        }
    }
    return arr;
}
+ (instancetype)at_JSONObjcToModel:(NSDictionary *)jsonDic
{
    id model = [[self alloc] init];
 
    NSArray *ivars = [self at_allIvars];
    
    for (CATIvar *ivar in ivars) {
        
        id value = [jsonDic objectForKey:ivar.name];
        
        if (!value) {
            continue;
        }
        
        NSString *objcString = [ivar modelString];
        
        if (_isArrayObjc(value)) {
            
            NSArray *jsonArr = (NSArray *)value;
            
            [model setValue:[CATEncodeTestModel at_JSONObjcArrayToModelArray:jsonArr] forKey:ivar.name];
            
        }else if(_isDictionaryObjc(value)){
            
            if ([objcString isEqualToString:@"NSDictionary"]) {
                
                [model setValue:value forKey:ivar.name];
            
            }else{
                
                Class class = NSClassFromString(objcString);
                
                if (!model) {
                    NSAssert1(NO, @"Model %@ is not exists.", objcString);
                }else{
                    [model setValue:[class at_JSONObjcToModel:value] forKey:ivar.name] ;
                }
            }
        }else{
            [model setValue:value forKey:ivar.name];
        }
    }
    return model;
}


- (NSDictionary *)at_modelToJSONObjc
{
    NSAssert(![self isKindOfClass:[NSArray class]], @"use at_arrayModelToJSONObjc");
    
    NSArray *ivars = [[self class] at_allIvarNames];
    
    NSMutableDictionary *jsonObjc = [[NSMutableDictionary alloc] init];
    
    for (NSString *ivar in ivars) {
        
        id objc = [self valueForKey:ivar];
        if (!objc) {
            objc = [NSNull null];
        }
        
        if (_isJsonObject(objc)) {
            if ([objc isKindOfClass:[NSArray class]]) {
                [jsonObjc setObject:[objc at_arrayModelToJSONObjc] forKey:ivar];
            }else{
                [jsonObjc setObject:objc forKey:ivar];
            }
        }else{
            [jsonObjc setObject:[objc at_modelToJSONObjc] forKey:ivar];
        }
    }
    return [jsonObjc copy];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@interface NSArray ()
@end
@implementation NSArray (CATExtentions)
- (NSArray *)at_arrayModelToJSONObjc
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSArray *objcs = (NSArray *)self;
    
    for (id objc in objcs) {
        if (_isJsonObject(objc)) {
            if ([objc isKindOfClass:[NSArray class]]) {
                [arr addObject:[objc at_arrayModelToJSONObjc]];
            }
            [arr addObject:objc];
        }else{
            [arr addObject:[objc at_modelToJSONObjc]];
        }
    }
    return [arr copy];

}
@end


@implementation CATEncodeTestModel

- (NSDictionary *)at_classAtArrays
{
    return @{@"modelArray":[CATEncodeTestModel class]};
}

- (id)copyWithZone:(NSZone *)zone
{
    CATEncodeTestModel *model = [[[self class] allocWithZone:zone] init];
    model->_ivarName = @"sun";
    model.propertyBool = self.propertyBool;
    model.propertyFloat = self.propertyFloat;
    model.propertyDouble = self.propertyDouble;
    model.propertyName = [self.propertyName copy];
    model.propertyCaches = [self.propertyCaches copy];
    model.model = [self.model copy];
    model.modelArray = [self.modelArray copy];
    return model;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        NSArray *propertyNames = [[self class] at_allPropertyNames];
        for (NSString *name in propertyNames) {
            [self setValue:[coder decodeObjectForKey:name] forKey:name];
        }
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    NSArray *propertyNames = [[self class] at_allPropertyNames];
    NSArray *ivarNames = [[self class] at_allIvarNames];
    
    NSLog(@"%@'s propertys: %@",self, propertyNames);
    NSLog(@"%@'s ivars: %@",self, ivarNames);
    
    [self setValue:@(10) forKey:@"propertyInteger"];
    
    
    for (NSString *property in propertyNames) {
        id value = [self valueForKey:property];
        SEL getSel = NSSelectorFromString(property);
        [coder encodeObject:[self valueForKey:property] forKey:property];
    }
    
    //    [coder encodeObject:self.propertyName forKey:@"propertyName"];
    //    [coder encodeObject:self.propertyCaches forKey:@"propertyCaches"];
}

@end