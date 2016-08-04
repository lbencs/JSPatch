//
//  CATForwardInvocation.m
//  Dome
//
//  Created by lben on 7/28/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import "CATForwardInvocation.h"
#import "Dome-swift.h"

#define ForwardBySwizzle (0)

@interface CATForwardInvocation ()
@end

@implementation CATForwardInvocation

- (void)testFunction
{
	NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (BOOL)testFunction:(NSString *)message
{
	return message.length <= 0;
}
- (BOOL)CATTestFunction:(NSString *)message
{
	return message.length > 0;
}
- (NSString *)testFunction:(NSString *)message from:(NSString *)from
{
	return [message stringByAppendingString:from];
}
- (NSString *)CATNotFundMethod:(NSString *)message
{
	return message;
}

#pragma mak -
- (void)swizzle
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
#if ForwardBySwizzle
		[[self class] swizzleMethods:@selector(forwardInvocation:) withSelector:@selector(CATForwardInvocation:)];
#endif
		[[self class] swizzleMethods:@selector(testFunction:) withSelector:@selector(CATTestFunction:)];
	});
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	NSLog(@"%@",NSStringFromSelector(aSelector));
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [self.array methodSignatureForSelector:aSelector];
    }
    return signature;
}

#if ForwardBySwizzle
- (void)CATForwardInvocation:(NSInvocation *)anInvocation
{
	NSLog(@"%@",anInvocation.description);
	
	NSLog(@"%@",anInvocation.description);
	id target = [self.array methodSignatureForSelector:[anInvocation selector]] ? _array : self;
	[anInvocation invokeWithTarget:target];
}
#else
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.array respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.array];
    }else{
        [super forwardInvocation:anInvocation];
    }
}
#endif


#pragma mark - getter&&setter

- (NSMutableArray *)array
{
	if (!_array) {
		_array = [[NSMutableArray alloc] init];
	}
	return _array;
}

@end
