//
//  ViewController.m
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/4.
//

#import "ViewController.h"
#import "IFDKvc.h"
#import "IFDDemoForGCD.h"
#import "IFDDemoForNSOperation.h"
#import "IFDRunLoopDemo.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) IFDKvc *kvcObject;
@property (nonatomic, strong) IFDDemoForGCD *demoForGCD;
@property (nonatomic, strong) IFDDemoForNSOperation *demoForNSOperation;
@property (nonatomic, strong) IFDRunLoopDemo *runLoopDemo;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameString = @"I am a string.";
    self.kvcObject = [[IFDKvc alloc] init];
    
    [self test];
    [self testKVO];
    [self.demoForNSOperation testNSOperation];
    [self.runLoopDemo testRunLoop];
//    [self startResidentThreadTest];
    
    for (int i=0;i<150;i++) {
        NSString *textString = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%d\n", i]];
        self.textView.text = textString;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.textView.frame = CGRectMake(20.f, 200.f, 300.f, 200.f);
}

#pragma mark -
#pragma mark test
- (void)test {
    
    id ioValue;
    NSError *outError = [[NSError alloc] init];
    
    //** key-value */
    id objProperty = nil;
    if ([self validateValue:&ioValue forKey:@"nameString" error:&outError]) {
        objProperty = [self valueForKey:@"nameString"];
    }
    
    if ([objProperty isKindOfClass:[NSString class]]) {
        
        NSLog(@"objProperty:%@.", objProperty);
    }
    
    [self setValue:@"I am a new string." forKey:@"nameString"];
    
    NSLog(@"objProperty:%@.", self.nameString);
    
    //** keyPath-value */
    NSString *keyPathString = @"kvcObject.propertyClass.propertyClassString";
    id objPropertyByPath = [self valueForKeyPath:keyPathString];
    
    if ([objPropertyByPath isKindOfClass:[NSString class]]) {
        NSLog(@"objPropertyByPath:%@.", objPropertyByPath);
    }
    
    [self setValue:@"I am a new IFDPropertyClass property." forKeyPath:keyPathString];
    
    objPropertyByPath = [self valueForKeyPath:keyPathString];
    NSLog(@"objPropertyByPath:%@.", objPropertyByPath);
    
    //** getter test */
    NSString *undefinedObjKeyPathString = @"kvcObject.instanceString";
    NSString *undefinedObj = [self valueForKeyPath:undefinedObjKeyPathString];
    
    if ([undefinedObj isKindOfClass:[NSString class]]) {
        
        NSLog(@"undefinedObj:%@.", undefinedObj);
    }
    
    [self setValue:@"I am an new is instance string without _." forKeyPath:undefinedObjKeyPathString];
    
    undefinedObj = [self valueForKeyPath:undefinedObjKeyPathString];
    NSLog(@"undefinedObj:%@.", undefinedObj);
    
    //** array keys */
    NSDictionary *dic = [self dictionaryWithValuesForKeys:@[@"nameString", @"kvcObject"]];
    NSLog(@"dic:%@", dic);
    
    //** array property */
    NSString *arrayObjKeyPathString = @"kvcObject.testArray";
    id arrayProperty = nil;
    if ([self validateValue:&ioValue forKeyPath:arrayObjKeyPathString error:&outError]) {
        arrayProperty = [self valueForKeyPath:arrayObjKeyPathString];
    } else {
        arrayProperty = [self valueForKeyPath:arrayObjKeyPathString];
    }
    
    if ([arrayProperty isKindOfClass:[NSArray class]]) {
        NSLog(@"arrayProperty:%@.", arrayProperty);
    }
    
    [self transmitMsg];
    
    [self.demoForGCD testMainQueue];
}

#pragma mark -
#pragma mark 高阶消息传递
//** KVC实现高阶消息传递 */
- (void)transmitMsg {
    NSArray *arrStr = @[@"china", @"england", @"franch"];
    NSArray *arrCapStr = [arrStr valueForKey:@"uppercaseString"];
    
    for (NSString *str in arrCapStr) {
        NSLog(@"%@", str);
    }
    
    NSArray *arrCapStrLength = [arrCapStr valueForKeyPath:@"uppercaseString.length"];
    for (NSNumber *length in arrCapStrLength) {
        NSLog(@"%ld", (long)length.integerValue);
    }
    
    id ioValue;
    if ([self.kvcObject validateValue:&ioValue forKey:@"testKeyValueMethod" error:nil]) {
        [self.kvcObject valueForKey:@"testKeyValueMethod"];
    } else {
        [self.kvcObject valueForKey:@"testKeyValueMethod"];
    }
}

#pragma mark -
#pragma mark KVO
- (void)testKVO {
    [self.kvcObject addObserver:self forKeyPath:@"propertyClass" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    NSLog(@"self.kvcObject:%@.", [self.kvcObject class]);
    NSLog(@"self.kvcObject:%s.", object_getClassName(self.kvcObject));
}

#pragma mark -
#pragma mark resident thread
- (void)startResidentThreadTest {
    [self.runLoopDemo startResidentThread];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /// 利用performSelector，在self.thread的线程中调用run2方法执行任务
    [self performSelector:@selector(run2) onThread:self.runLoopDemo.thread withObject:nil waitUntilDone:NO];
}

- (void)run2 {
    
    NSLog(@"runResidentMethod - running on self.thread:%@, [NSThread currentThread]:%@.", self.runLoopDemo.thread, [NSThread currentThread]);
}

#pragma mark -
#pragma mark property method
- (IFDDemoForGCD *)demoForGCD {
    if (!_demoForGCD) {
        _demoForGCD = [[IFDDemoForGCD alloc] init];
    }
    return _demoForGCD;
}

- (IFDDemoForNSOperation*)demoForNSOperation {
    if (!_demoForNSOperation)  {
        _demoForNSOperation = [[IFDDemoForNSOperation alloc] init];
    }
    return _demoForNSOperation;
}

- (IFDRunLoopDemo *)runLoopDemo {
    if (!_runLoopDemo) {
        _runLoopDemo = [[IFDRunLoopDemo alloc] init];
    }
    return _runLoopDemo;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_textView];
    }
    return _textView;
}

@end
