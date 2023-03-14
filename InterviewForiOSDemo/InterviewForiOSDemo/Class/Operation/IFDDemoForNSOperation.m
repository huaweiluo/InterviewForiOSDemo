//
//  IFDDemoForNSOperation.m
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/11.
//

#import "IFDDemoForNSOperation.h"
#import "IDFOperation.h"

@interface IFDDemoForNSOperation()
@property (nonatomic, assign) NSInteger ticketSurplusCount;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) dispatch_semaphore_t semaphoreLock;
@end

@implementation IFDDemoForNSOperation

#pragma mark -
#pragma mark 使用子类 NSInvocationOperation
/**
 * 使用子类 NSInvocationOperation
 */
- (void)useInvocationOperation {

    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(optTask1) object:nil];

    // 2.调用 start 方法开始执行操作
    [op start];
}

/**
 * 任务1
 */
- (void)optTask1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"addOperationToQueue - optTask1 - %d---%@", i, [NSThread currentThread]); // 打印当前线程
    }
}

- (void)optTask2 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"addOperationToQueue - optTask2 - %d---%@", i, [NSThread currentThread]); // 打印当前线程
    }
}

#pragma mark -
#pragma mark 使用子类 NSBlockOperation
/**
 * 使用子类 NSBlockOperation
 */
- (void)useBlockOperation {

    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperation - %d ---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 2.调用 start 方法开始执行操作
    [op start];
}

/**
 * 使用子类 NSBlockOperation
 * 调用方法 AddExecutionBlock:
 */
- (void)useBlockOperationAddExecutionBlock {

    NSLog(@"useBlockOperationAddExecutionBlock - begin ---%@", [NSThread currentThread]); // 打印当前线程
    
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 1.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 2.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 3.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 4.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 5.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 6.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 7.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"useBlockOperationAddExecutionBlock - 8.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.调用 start 方法开始执行操作
    [op start];
    
    NSLog(@"useBlockOperationAddExecutionBlock - end ---%@", [NSThread currentThread]); // 打印当前线程
}

#pragma mark -
#pragma mark custom operation
- (void)testCustomOpt {
    IDFOperation *myselfOperation = [[IDFOperation alloc] init];
    [myselfOperation start];
}

#pragma mark -
#pragma mark 使用 addOperation: 将操作加入到操作队列中
/**
 * 使用 addOperation: 将操作加入到操作队列中
 */
- (void)addOperationToQueue {

    // 1.创建队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];// [[NSOperationQueue alloc] init];

    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(optTask1) object:nil];

    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(optTask2) object:nil];

    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addOperationToQueue - 3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addOperationToQueue - 4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
}

#pragma mark -
#pragma mark block 中添加操作
/**
 * 使用 addOperationWithBlock: 将操作加入到操作队列中
 */

- (void)addOperationWithBlockToQueue {
    NSLog(@"addOperationWithBlockToQueue - begin ---%@", [NSThread currentThread]); // 打印当前线程
    
    // 1.创建队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];//[[NSOperationQueue alloc] init];

    // 2.使用 addOperationWithBlock: 添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addOperationWithBlockToQueue - 1.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addOperationWithBlockToQueue - 2.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addOperationWithBlockToQueue - 3.%d---%@", i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSLog(@"addOperationWithBlockToQueue - end ---%@", [NSThread currentThread]); // 打印当前线程
}

#pragma mark -
#pragma mark NSOperationQueue 控制串行执行、并发执行
/**
 * 设置 MaxConcurrentOperationCount（最大并发操作数）
 */
- (void)setMaxConcurrentOperationCount {
    NSLog(@"setMaxConcurrentOperationCount - begin ---%@", [NSThread currentThread]); // 打印当前线程
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.设置最大并发操作数
    queue.maxConcurrentOperationCount = 1; // 串行队列
// queue.maxConcurrentOperationCount = 2; // 并发队列
// queue.maxConcurrentOperationCount = 8; // 并发队列

    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"setMaxConcurrentOperationCount - 1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"setMaxConcurrentOperationCount - 2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"setMaxConcurrentOperationCount - 3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"setMaxConcurrentOperationCount - 4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSLog(@"setMaxConcurrentOperationCount - end ---%@", [NSThread currentThread]); // 打印当前线程
}

#pragma mark -
#pragma mark NSOperation 操作依赖
/**
 * 操作依赖
 * 使用方法：addDependency:
 */
- (void)addDependency {
    NSLog(@"addDependency - begin ---%@", [NSThread currentThread]); // 打印当前线程
    
    // 1.创建队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];//[[NSOperationQueue alloc] init];

    NSBlockOperation *op0 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"addDependency - op0 begin ---%@", [NSThread currentThread]); // 打印当前线程
        
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addDependency - 0---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"addDependency - op1 begin ---%@", [NSThread currentThread]); // 打印当前线程
        
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addDependency - 1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"addDependency - op2 begin ---%@", [NSThread currentThread]); // 打印当前线程
        
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"addDependency - 2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.添加依赖
//    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，在执行op2
    [op1 setQueuePriority:NSOperationQueuePriorityNormal];
    [op2 setQueuePriority:NSOperationQueuePriorityHigh];

    // 4.添加操作到队列中
    [queue addOperation:op0];
    [queue addOperation:op1];
    [queue addOperation:op2];
    
    NSLog(@"addDependency - end ---%@", [NSThread currentThread]); // 打印当前线程
}

#pragma mark -
#pragma mark NSOperation 优先级
/// 在都是就绪状态的情况下, 优先级高的优先执行
/// 如果要控制操作间的启动顺序，则必须使用依赖关系。

#pragma mark -
#pragma mark NSOperation、NSOperationQueue 线程间的通信
/**
 * 线程间通信
 */
- (void)communication {

    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.添加操作
    [queue addOperationWithBlock:^{
        // 异步进行耗时操作
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }

        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些 UI 刷新等操作
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
}

#pragma mark -
#pragma mark NSOperation、NSOperationQueue 非线程安全
/**
 * 非线程安全：不使用 NSLock
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]); // 打印当前线程

    self.ticketSurplusCount = 50;

    // 1.创建 queue1,queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    // 2.创建 queue2,queue2 代表上海火车票售卖窗口
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;

    // 3.创建卖票操作 op1
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketNotSafe];
    }];

    // 4.创建卖票操作 op2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketNotSafe];
    }];

    // 5.添加操作，开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe {
    while (1) {

        if (self.ticketSurplusCount > 0) {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%ld 窗口:%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

#pragma mark -
#pragma mark NSOperation、NSOperationQueue 线程安全
/**
 * 线程安全：使用 NSLock 加锁
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */

- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]); // 打印当前线程

    self.ticketSurplusCount = 50;

    self.lock = [[NSLock alloc] init];  // 初始化 NSLock 对象
    self.semaphoreLock = dispatch_semaphore_create(1);

    // 1.创建 queue1,queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    // 2.创建 queue2,queue2 代表上海火车票售卖窗口
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;

    // 3.创建卖票操作 op1
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketSafe];
    }];

    // 4.创建卖票操作 op2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketSafe];
    }];

    // 5.添加操作，开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {

        // 加锁
//        [self.lock lock];
        dispatch_semaphore_wait(self.semaphoreLock, DISPATCH_TIME_FOREVER);

        if (self.ticketSurplusCount > 0) {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"saleTicketSafe - 剩余票数:%ld 窗口:%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }

        // 解锁
//        [self.lock unlock];

        if (self.ticketSurplusCount <= 0) {
            NSLog(@"所有火车票均已售完");
            dispatch_semaphore_signal(self.semaphoreLock);
            break;
        }
        
        dispatch_semaphore_signal(self.semaphoreLock);
    }
}

#pragma mark -
#pragma mark export method
- (void)testNSOperation {
    
//    [self useInvocationOperation];
    
    // 在其他线程使用子类 NSInvocationOperation
//    [NSThread detachNewThreadSelector:@selector(useInvocationOperation) toTarget:self withObject:nil];
    
//    [self useBlockOperation];
//    [NSThread detachNewThreadSelector:@selector(useBlockOperation) toTarget:self withObject:nil];
    
//    [self useBlockOperationAddExecutionBlock];
    
//    [self testCustomOpt];
//    [NSThread detachNewThreadSelector:@selector(testCustomOpt) toTarget:self withObject:nil];
    
//    [self addOperationToQueue];
//    [self addOperationWithBlockToQueue];
    
//    [self setMaxConcurrentOperationCount];
//    [NSThread detachNewThreadSelector:@selector(setMaxConcurrentOperationCount) toTarget:self withObject:nil];
    
//    [self addDependency];
//    [NSThread detachNewThreadSelector:@selector(addDependency) toTarget:self withObject:nil];
    
//    [self initTicketStatusSave];
    [NSThread detachNewThreadSelector:@selector(initTicketStatusSave) toTarget:self withObject:nil];
}

@end
