#include <Foundation/Foundation.h>

#include "FastCoder.h"

#ifndef ALog
#define ALog(format, ...)	NSLog((@"%s [Line %d] " format), __FUNCTION__, __LINE__, ## __VA_ARGS__)
#endif

#if TARGET_OS_WIN32
    #define PLATFORM_SUFFIX @"windows"
#elif TARGET_OS_OSX
    #define PLATFORM_SUFFIX @"macos"
#else
    #define PLATFORM_SUFFIX @"unsupported"
#endif

#define PLATFORMS @[@"windows", @"macos"]

@interface ModelObject1 : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *string1;
@property (nonatomic, copy) NSDate *date1;
@property (nonatomic, copy) NSNumber *number1;
@property (nonatomic, copy) NSData *data1;
@property (nonatomic, copy) NSURL *url1;

@property (nonatomic, assign) NSInteger integer1;
@property (nonatomic, assign) float float1;

+ (instancetype)testInstance;

@end

@implementation ModelObject1

+ (BOOL)supportsSecureCoding
{
    return YES;
}

+ (instancetype)testInstance
{
    char data[] = {0x1, 0x2, 0x3, 0x4};

    ModelObject1 *instance = [[ModelObject1 alloc] init];
    instance.string1 = NSUUID.UUID.UUIDString;
    instance.date1 = [NSDate date];
    instance.number1 = @(arc4random());
    instance.data1 = [NSData dataWithBytes:data length: 4];
    instance.url1 = [NSURL URLWithString:@"http://www.algoriddim.com"];
    instance.integer1 = arc4random();
    instance.float1 = 1.1;

    return instance;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.string1 = [decoder decodeObjectOfClass:NSString.class forKey: @"string1"];
        self.date1 = [decoder decodeObjectOfClass:NSDate.class forKey: @"date1"];
        self.number1 = [decoder decodeObjectOfClass:NSNumber.class forKey: @"number1"];
        self.data1 = [decoder decodeObjectOfClass:NSData.class forKey: @"data1"];
        self.url1 = [decoder decodeObjectOfClass:NSURL.class forKey: @"url1"];

        self.integer1 = [decoder decodeIntegerForKey: @"integer1"];
        self.float1 = [decoder decodeFloatForKey: @"float1"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.string1 forKey: @"string1"];
    [coder encodeObject:self.date1 forKey: @"date1"];
    [coder encodeObject:self.number1 forKey: @"number1"];
    [coder encodeObject:self.data1 forKey: @"data1"];
    [coder encodeObject:self.url1 forKey:@"url1"];
    [coder encodeInteger:self.integer1 forKey:@"integer1"];
    [coder encodeFloat:self.float1 forKey:@"float1"];
}

- (NSUInteger)hash
{
    return [self.string1 hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        ModelObject1 *model = object;
        
        return ((!self.string1 && !model.string1) || [self.string1 isEqual:model.string1]
        && ((!self.date1 && !model.date1) || [self.date1 isEqual:model.date1]) 
        && ((!self.number1 && !model.number1) || [self.number1 isEqual:model.number1]) 
        && ((!self.data1 && !model.data1) || [self.data1 isEqual:model.data1]) 
        && ((!self.url1 && !model.url1) || [self.url1 isEqual:model.url1]) 
            && self.integer1 == model.integer1 
            && self.float1 == model.float1
            );
    }

    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ string1: %@ date1: %@ number1: %@ data1: %@ url1: %@ integer1: %lld float1: %f", 
        [super description], self.string1, self.date1, self.number1, self.data1, self.url1, self.integer1, self.float1];
}

@end

@interface Model : NSObject <NSSecureCoding>

@property (nonatomic, strong) ModelObject1 *object1;
@property (nonatomic, copy) NSSet<ModelObject1 *> *objectSet;
@property (nonatomic, copy) NSOrderedSet<ModelObject1 *> *objectOrderedSet;
@property (nonatomic, copy) NSArray<ModelObject1 *> *objectArray;
@property (nonatomic, copy) NSDictionary<NSString *, ModelObject1 *> *objectDictionary;

+ (instancetype)testInstance;

@end

@implementation Model

+ (BOOL)supportsSecureCoding
{
    return YES;
}

+ (instancetype)testInstance
{
    Model *instance = [[Model alloc] init];
    instance.object1 = [ModelObject1 testInstance];
    instance.objectSet = [NSSet setWithArray:@[[ModelObject1 testInstance], [ModelObject1 testInstance], [ModelObject1 testInstance]]];
    instance.objectOrderedSet = [NSOrderedSet orderedSetWithArray:@[[ModelObject1 testInstance], [ModelObject1 testInstance], [ModelObject1 testInstance]]];
    instance.objectArray = @[[ModelObject1 testInstance], [ModelObject1 testInstance], [ModelObject1 testInstance]];
    instance.objectDictionary = @{@"object1" : [ModelObject1 testInstance], @"object2" : [ModelObject1 testInstance]};

    return instance;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        Model *model = object;

        BOOL isEqualArray = [self.objectArray isEqual:model.objectArray];
        
        return ((!self.object1 && !model.object1) || [self.object1 isEqual:model.object1]) 
        && ((!self.objectSet && !model.objectSet) || [self.objectSet isEqual:model.objectSet]) 
        && ((!self.objectOrderedSet && !model.objectOrderedSet) || [self.objectOrderedSet isEqual:model.objectOrderedSet]) 
        && ((!self.objectArray && !model.objectArray) || [self.objectArray isEqual:model.objectArray]) 
        && ((!self.objectDictionary && !model.objectDictionary) || [self.objectDictionary isEqual:model.objectDictionary]);
    }

    return NO;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.object1 = [decoder decodeObjectOfClass:ModelObject1.class forKey: @"object1"];
        self.objectSet = [decoder decodeObjectOfClasses:[NSSet setWithArray:@[NSSet.class, ModelObject1.class]] forKey: @"objectSet"];
        self.objectOrderedSet = [decoder decodeObjectOfClasses:[NSSet setWithArray:@[NSOrderedSet.class, ModelObject1.class]] forKey: @"objectOrderedSet"];
        self.objectArray =  [decoder decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, ModelObject1.class]] forKey: @"objectArray"];
        self.objectDictionary = [decoder decodeObjectOfClasses:[NSSet setWithArray:@[NSDictionary.class, NSString.class, ModelObject1.class]] forKey: @"objectDictionary"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.object1 forKey: @"object1"];
    [coder encodeObject:self.objectSet forKey: @"objectSet"];
    [coder encodeObject:self.objectOrderedSet forKey: @"objectOrderedSet"];
    [coder encodeObject:self.objectArray forKey: @"objectArray"];
    [coder encodeObject:self.objectDictionary forKey: @"objectDictionary"];
}

@end

@interface FastCodingTest : NSObject

- (void)runTests;

@end

@implementation FastCodingTest

- (void)runTests
{
    [self testNSCoding];  
    [self testDictionary];
    [self testMutableDictionary];
    [self testArray];
    [self testMutableArray];
    [self testSet];
    [self testMutableSet];
    [self testOrderedSet];
    [self testMutableOrderedSet];
    [self testURL];
    [self testArchivedData];
    
    // This types have been disabled due to compatibility concerns/issues with GNUstep
    // [self testIndexSet];
    // [self testMutableIndexSet];
    // [self testPointValue];
    // [self testSizeValue];
    // [self testRangeValue];
    // [self testRectValue];
}

- (void)testDictionary
{
    ALog(@"Running test");

    NSDictionary *input = @{@"object1" : [ModelObject1 testInstance], @"object2" : [ModelObject1 testInstance]};

    NSData *data = [FastCoder dataWithRootObject:input];
    NSDictionary *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual: output]);
}

- (void)testMutableDictionary
{
    ALog(@"Running test");

    NSMutableDictionary *input = [@{@"object1" : [ModelObject1 testInstance], @"object2" : [ModelObject1 testInstance]} mutableCopy];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSDictionary *output = [FastCoder objectWithData:data];

    assert([input isEqual: output]);
}

- (void)testArray
{
    ALog(@"Running test");

    NSArray *input = @[[ModelObject1 testInstance], [ModelObject1 testInstance]];
    
    NSData *data = [FastCoder dataWithRootObject:input];
    NSArray *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual: output]);
}

- (void)testMutableArray
{
    ALog(@"Running test");

    NSMutableArray *input = [@[[ModelObject1 testInstance], [ModelObject1 testInstance]] mutableCopy];
    
    NSData *data = [FastCoder dataWithRootObject:input];
    NSArray *output = [FastCoder objectWithData:data];

    assert([input isEqual: output]);
}

- (void)testSet
{
    ALog(@"Running test");

    NSSet *input = [NSSet setWithArray:@[[ModelObject1 testInstance], [ModelObject1 testInstance]]];
    
    NSData *data = [FastCoder dataWithRootObject:input];
    NSMutableSet *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual: output]);
}

- (void)testMutableSet
{
    ALog(@"Running test");

    NSMutableSet *input = [[NSSet setWithArray:@[[ModelObject1 testInstance], [ModelObject1 testInstance]]] mutableCopy];
    
    NSData *data = [FastCoder dataWithRootObject:input];
    NSSet *output = [FastCoder objectWithData:data];

    assert([input isEqual: output]);
}

- (void)testOrderedSet
{
    ALog(@"Running test");

    NSOrderedSet *input = [NSOrderedSet orderedSetWithArray:@[[ModelObject1 testInstance], [ModelObject1 testInstance]]];
    
    NSData *data = [FastCoder dataWithRootObject:input];
    NSOrderedSet *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual: output]);
}

- (void)testMutableOrderedSet
{
    ALog(@"Running test");

    NSMutableOrderedSet *input = [[NSOrderedSet orderedSetWithArray:@[[ModelObject1 testInstance], [ModelObject1 testInstance]]] mutableCopy];
    
    NSData *data = [FastCoder dataWithRootObject:input];
    NSOrderedSet *output = [FastCoder objectWithData:data];

    assert([input isEqual: output]);
}

- (void)testIndexSet
{
    NSIndexSet *input = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 10)];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSIndexSet *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual:output]);
}

- (void)testMutableIndexSet
{
    NSMutableIndexSet *input = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 10)] mutableCopy];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSIndexSet *output = [FastCoder objectWithData:data];

    assert([input isEqual:output]);
}

- (void)testURL
{
    ALog(@"Running test");

    NSURL *input = [NSURL URLWithString:@"https://www.google.com"];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSURL *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual:output]);
}

- (void)testPointValue
{
    ALog(@"Running test");

    NSValue *input = [NSValue valueWithPoint:NSMakePoint(1.0, 2.0)];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSValue *output = [FastCoder objectWithData:data];

    NSLog(@"INPUT %@ OUTPUT %@", NSStringFromClass([input class]), NSStringFromClass([output class]));

    assert([input class] == [output class]);
    assert([input isEqual:output]);
}

- (void)testSizeValue
{
    ALog(@"Running test");

    NSValue *input = [NSValue valueWithSize:NSMakeSize(1.0, 2.0)];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSValue *output = [FastCoder objectWithData:data];

    NSLog(@"INPUT %@ OUTPUT %@", NSStringFromClass([input class]), NSStringFromClass([output class]));

    assert([input class] == [output class]);
    assert([input isEqual:output]);
}

- (void)testRectValue
{
    ALog(@"Running test");

    NSValue *input = [NSValue valueWithRect:NSMakeRect(1.0, 2.0, 3.0, 4.0)];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSValue *output = [FastCoder objectWithData:data];

    NSLog(@"INPUT %@ OUTPUT %@", NSStringFromClass([input class]), NSStringFromClass([output class]));

    assert([input class] == [output class]);
    assert([input isEqual:output]);
}

- (void)testRangeValue
{
    ALog(@"Running test");

    NSValue *input = [NSValue valueWithRange:NSMakeRange(1, 2)];

    NSData *data = [FastCoder dataWithRootObject:input];
    NSValue *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual:output]);
}

- (void)testNSCoding
{
    ALog(@"Running test");

    Model *input = [Model testInstance];
    
    NSData *data = [FastCoder dataWithRootObject:input];
    Model *output = [FastCoder objectWithData:data];

    assert([input class] == [output class]);
    assert([input isEqual: output]);
}

- (void)testArchivedData
{
    ALog(@"Running test");

    NSString *dataDirectoryPath = [NSUserDefaults.standardUserDefaults stringForKey:@"data"];

    for (NSString *platform in PLATFORMS) {
        NSData *nsCodedData = [NSData dataWithContentsOfFile:[dataDirectoryPath stringByAppendingPathComponent:[@"nscoded." stringByAppendingString:platform]]];
        Model *nsCodedModel = [NSKeyedUnarchiver unarchivedObjectOfClass:Model.class fromData:nsCodedData error:NULL];
        
        NSData *fastCodedData = [NSData dataWithContentsOfFile:[dataDirectoryPath stringByAppendingPathComponent:[@"fastcoded." stringByAppendingString:platform]]];
        Model *fastCodedModel = [FastCoder objectWithData:fastCodedData];

        assert([nsCodedModel class] == [fastCodedModel class]);
        assert([nsCodedModel isEqual:fastCodedModel]);
    }
}

@end

void printUsage()
{
    NSLog(@"FastCodingTest -data <path to test data directory> [-generate <true | false>]");
}

int main(int argc, char *argv[])
{
    if (![NSUserDefaults.standardUserDefaults stringForKey:@"data"]) {
        NSLog(@"Missing path to test data directory.");
        printUsage();
        return 1;
    }

    if ([[NSUserDefaults.standardUserDefaults stringForKey:@"generate"] isEqual:@"true"]) {
        NSString *outputDirPath = [NSUserDefaults.standardUserDefaults stringForKey:@"data"];
        if (outputDirPath.length == 0) {
            NSLog(@"Invalid output directory path");
            return 1;
        }

        if (![NSFileManager.defaultManager fileExistsAtPath:outputDirPath]) {
            NSError *error;

            if (![NSFileManager.defaultManager createDirectoryAtPath:outputDirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSLog(@"Failed to create output directory: %@", error);
                return 1;
            }
        }

        NSString *nsCodedFilePath = [outputDirPath stringByAppendingPathComponent:[@"nscoded." stringByAppendingString:PLATFORM_SUFFIX]];
        NSString *fastCodedFilePath = [outputDirPath stringByAppendingPathComponent:[@"fastcoded." stringByAppendingString:PLATFORM_SUFFIX]];

        Model *input = [Model testInstance];

        NSLog(@"Writing NSCoder data to %@", nsCodedFilePath);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:input];
        [data writeToFile:nsCodedFilePath atomically: YES];

        NSLog(@"Writing FastCoder data to %@", fastCodedFilePath);
        data = [FastCoder dataWithRootObject:input];
        [data writeToFile:fastCodedFilePath atomically: YES];
    } else {
        FastCodingTest *tests = [[FastCodingTest alloc] init];
        [tests runTests];
    } 

    return 0;
}
