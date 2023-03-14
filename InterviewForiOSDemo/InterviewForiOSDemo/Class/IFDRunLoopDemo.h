//
//  IFDRunLoopDemo.h
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IFDRunLoopDemo : NSObject
@property (nonatomic, strong, readonly) NSThread *thread;

- (void)startResidentThread;
- (void)testRunLoop;

@end

NS_ASSUME_NONNULL_END
