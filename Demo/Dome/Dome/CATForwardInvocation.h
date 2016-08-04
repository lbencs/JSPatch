//
//  CATForwardInvocation.h
//  Dome
//
//  Created by lben on 7/28/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CATForwardInvocation : NSObject

@property (nonatomic, strong) NSMutableArray *array;

- (void)swizzle;


- (void)testFunction;
- (BOOL)testFunction:(NSString *)message;
- (NSString *)testFunction:(NSString *)message from:(NSString *)from;



@end
