/*
 
 Copyright (c) 2011 Nextive LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial
 portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Created by Martin Adoue (martin@nextive.com) and Hernan Pelassini (hernan@nextive.com)
 
 */


#import "NXJsonSerializerTests.h"
#import "NXJsonSerializer.h"

@implementation NXJsonSerializerTests
@synthesize serializer;

-(void) setUp
{
	NXJsonSerializer* s = [[NXJsonSerializer alloc] init];
	STAssertNotNil(s, @"Serializer should not be nil");
	STAssertTrue([s isKindOfClass:[NXJsonSerializer class]], @"Serializer is of the wrong class");
	self.serializer = s;
	[s release];
}

-(void) tearDown
{
	[serializer release];
	serializer = nil;
}

-(void)testNil
{
	NSString* ret = [self.serializer serialize:nil];
	STAssertTrue([ret isEqualToString:@"null"], @"string should be null");
}

-(void)testNull
{
	NSString* ret = [self.serializer serialize:[NSNull null]];
	STAssertTrue([ret isEqualToString:@"null"], @"string should be null");
}

-(void)testString
{
	NSString* ret = [self.serializer serialize:@""];
	STAssertTrue([ret isEqualToString:@"\"\""], @"string should be \"\"");
}

-(void)testUnicode
{
	NSString* ret = [self.serializer serialize:@"¼"];
	STAssertTrue([ret isEqualToString:@"\"\\u00bc\""], @"string should be \"\\u00bc\"");
}

-(void)testNumber
{
	NSString* ret = [self.serializer serialize:[NSNumber numberWithInt:-23]];
	STAssertTrue([ret isEqualToString:@"-23"], @"string should be -23 and is '%@'", ret);
}

-(void)testDictionary
{
	NSString* ret = [self.serializer serialize:[NSDictionary dictionary]];
	STAssertTrue([ret isEqualToString:@"{}"], @"string should be {}");
}

-(void)testDictionaryWithObject
{
	NSDictionary* dic = [NSDictionary dictionaryWithObject:@"dog" forKey:@"key1"];
	NSString* ret = [self.serializer serialize:dic];
	STAssertTrue([ret isEqualToString:@"{\"key1\":\"dog\"}"], @"string should be {\"key1\":\"dog\"}");
}

-(void)testArray
{
	NSString* ret = [self.serializer serialize:[NSArray array]];
	STAssertTrue([ret isEqualToString:@"[]"], @"string should be []");
}

-(void)testArrayWithObject
{
	NSString* ret = [self.serializer serialize:[NSArray arrayWithObject:@"dog"]];
	STAssertTrue([ret isEqualToString:@"[\"dog\"]"], @"string should be [\"dog\"]");
}

-(void)testArrayWithArray
{
	NSString* ret = [self.serializer serialize:[NSArray arrayWithObject:[NSArray array]]];
	STAssertTrue([ret isEqualToString:@"[[]]"], @"string should be [[]]");
}

-(void)testDeep
{
	NSArray* innerArray = nil;
	for (int i=0; i<20; ++i)
	{
		NSArray* array = [NSArray arrayWithObjects:innerArray, nil];
		innerArray = array;
	}
	NSString* ret = [self.serializer serialize:innerArray];
	STAssertTrue([ret isEqualToString:@"[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]"], @"string should be [[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]");

	NSDictionary* innerDictionary = [NSDictionary dictionary];
	for (int i=0; i<9; ++i)
	{
		NSDictionary* dict = [NSDictionary dictionaryWithObject:innerDictionary forKey:@"x"];
		innerDictionary = dict;
	}
	ret = [self.serializer serialize:innerDictionary];
	STAssertTrue([ret isEqualToString:@"{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{}}}}}}}}}}"], @"string should be {\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{\"x\":{}}}}}}}}}}");
}

@end
