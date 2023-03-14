//
//  IDFOperation.m
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/12.
//

#import "IDFOperation.h"

@interface IDFOperation()
@end

@implementation IDFOperation

- (void)main {
    NSLog(@"IDFOperation - main begin.");
    
    if (!self.isCancelled) {
        
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"IDFOperation - %d ---%@", i, [NSThread currentThread]);
        }
    }
    
    NSLog(@"IDFOperation - main end.");
}

@end
