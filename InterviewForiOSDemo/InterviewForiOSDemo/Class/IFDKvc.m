//
//  IFDKvc.m
//  InterviewForiOSDemo
//
//  Created by jipengfei on 2023/3/4.
//

#import "IFDKvc.h"

@interface IFDKvc() {
//    NSString *_instanceString;
//    NSString *_isInstanceString;
//    NSString *instanceString;
    NSString *isInstanceString;
    NSArray *_testArray;
}
@end

@implementation IFDKvc

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        _instanceString = @"I am an instance string.";
//        _isInstanceString = @"I am an is instance string.";
//        instanceString = @"I am an instance string without _.";
        isInstanceString = @"I am an is instance string without _.";
        
        _testArray = @[@(1), @(2), @(3), @(4)];
        
    }
    return self;
}

- (IFDPropertyClass *)propertyClass {
    if (!_propertyClass) {
        _propertyClass = [[IFDPropertyClass alloc] init];
    }
    return _propertyClass;
}

//** accessInstanceVariablesDirectly 默认返回YES */
+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

- (id)valueForUndefinedKey:(NSString *)key {
//    return nil;
    return [super valueForUndefinedKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [super setValue:value forUndefinedKey:key];
}

- (NSDictionary<NSString *,id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys {
    return [super dictionaryWithValuesForKeys:keys];
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    [super setValuesForKeysWithDictionary:keyedValues];
}

//- (void)_setInstanceString:(NSString*)instanceString {
//    NSLog(@"instanceString:%@.", instanceString);
//    isInstanceString = instanceString;
//}

- (void)setIsInstanceString:(NSString*)instanceString {
    NSLog(@"instanceString:%@.", instanceString);
    isInstanceString = instanceString;
}

//- (void)setInstanceString:(NSString*)instanceString {
//    NSLog(@"instanceString:%@.", instanceString);
//    isInstanceString = instanceString;
//}

- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing  _Nullable *)outError {
    return NO;
}

#pragma mark -
#pragma mark export method
- (void)testKeyValueMethod {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark -
#pragma mark array property
//- (NSArray*)testArray {
//    return @[@(4), @(5), @(6), @(7)];
//}

- (NSUInteger)countOfTestArray{
    return 3;
}

//** testArrayAtIndexes 和 objectInTestArrayAtIndex 二选一i
//- (id)objectInTestArrayAtIndex:(NSUInteger)index{
//    return @(index+1);
//}

- (id)testArrayAtIndexes:(NSIndexSet *)indexs {
    return @[@[@(5), @(6)], @(4), @(6)];
}


@end
