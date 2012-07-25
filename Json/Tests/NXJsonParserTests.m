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

#import "NXJsonParserTests.h"
#import "NXJsonParser.h"
#import "NXJsonSerializer.h"

@implementation NXJsonParserTests


- (id)parseValidJSON:(NSString* )json 
{
	NSError* error = nil;
	id result = [NXJsonParser parseString:json error:&error ignoreNulls:NO];
	STAssertNil(error, @"error should be nil for json: %@", json);

	return result;
}

- (void)testEmptyJSON {

	id result = [self parseValidJSON:@""];
	STAssertNil(result, nil, @"result should be nil");
}

- (void)testEmptyObject {

	NSDictionary *result = [self parseValidJSON:@"{}"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSDictionary class]], @"result should be a dictionary");
	STAssertEquals([result count], (NSUInteger)0, @"result should be empty");
}

- (void)testEmptyArray {

	NSArray *result = [self parseValidJSON:@"[]"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSArray class]], @"result should be an array");
	STAssertEquals([result count], (NSUInteger)0, @"result should be empty");
}

- (void)testEmptyString {

	NSString *result = [self parseValidJSON:@"\"\""];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSString class]], @"result should be a string");
	STAssertEquals([result length], (NSUInteger)0, @"result should be empty");
}

- (void)testSimpleStringValue {

	NSString *result = [self parseValidJSON:@"\"string\""];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSString class]], @"result should be a string");
	STAssertEqualObjects(result, @"string", @"result should be 'string'");
}

- (void)testSimpleNumberValue {

	NSNumber *result = [self parseValidJSON:@"1"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSNumber class]], @"result should be a number");
	STAssertEqualObjects(result, [NSNumber numberWithInt:1], @"result should be 1");
}

- (void)testTrueBooleanValue {

	NSNumber *result = [self parseValidJSON:@"true"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSNumber class]], @"result should be a number");
	STAssertEqualObjects(result, [NSNumber numberWithBool:YES], @"result should be YES");
}

- (void)testFalseBooleanValue {

	NSNumber *result = [self parseValidJSON:@"false"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSNumber class]], @"result should be a number");
	STAssertEqualObjects(result, [NSNumber numberWithBool:NO], @"result should be NO");
}

- (void)testNullValue {

	NSNull *result = [self parseValidJSON:@"null"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSNull class]], @"result should be a null");
	STAssertEqualObjects(result, [NSNull null], @"result should be null");
}

- (void)testOneMemberObject {

	NSDictionary *result = [self parseValidJSON:@"{\"key\":\"value\"}"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSDictionary class]], @"result should be a dictionary");
	STAssertEquals([result count], (NSUInteger)1, @"result should not be empty");
	STAssertEqualObjects([result objectForKey:@"key"], @"value", @"the value for the key 'key' should be 'value'");
}

- (void)testTwoMemberObject {

	NSDictionary *result = [self parseValidJSON:@"{\"key\":\"value\",\"key2\":\"value2\"}"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSDictionary class]], @"result should be a dictionary");
	STAssertEquals([result count], (NSUInteger)2, @"result should not be empty");
	STAssertEqualObjects([result objectForKey:@"key"], @"value", @"the value for the key 'key' should be 'value'");
	STAssertEqualObjects([result objectForKey:@"key2"], @"value2", @"the value for the key 'key2' should be 'value2'");
}

- (void)testOneElementArray 
{

	NSArray *result = [self parseValidJSON:@"[\"element\"]"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSArray class]], @"result should be an array");
	STAssertEquals([result count], (NSUInteger)1, @"result should not be empty");
	STAssertEqualObjects([result objectAtIndex:0], @"element", @"the first element should be 'element'");
}

- (void)testTwoElementArray 
{

	NSArray *result = [self parseValidJSON:@"[\"element\",\"element2\"]"];
	STAssertNotNil(result, nil, @"result should not be nil");
	STAssertTrue([result isKindOfClass:[NSArray class]], @"result should be an array");
	STAssertEquals([result count], (NSUInteger)2, @"result should not be empty");
	STAssertEqualObjects([result objectAtIndex:0], @"element", @"the first element should be 'element'");
	STAssertEqualObjects([result objectAtIndex:1], @"element2", @"the second element should be 'element2'");
}


-(void)testParserCreation
{
	NSData* data = [NSData data];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	[parser release];
}

-(void)testOnlyComments
{
	NSData* data = [@"/* some ramdon comment*/" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertNil(retval, @"retval should be nil");
	[parser release];
}

-(void)testOnlyCommentsMultiple
{
	NSData* data = [@"   /* some ramdon comment*/     /* some more comments*//*even more*/" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertNil(retval, @"retval should be nil");
	[parser release];
}

-(void) testEmptyDictionary
{
	NSData* data = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");
	[parser release];
}

-(void) testMultipleValues
{
	NSData* data = [@"{\"stringElement\":\"im_a_string\",\"boolElement1\":false,\"boolElement2\":true}" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* dictionary = retval;
	STAssertEquals([dictionary count], 3u, @"element should be 3 elements");

	id stringElement = [dictionary objectForKey:@"stringElement"];
	STAssertTrue([stringElement isKindOfClass:[NSString class]], @"element should be NSString");

	id boolElement = [dictionary objectForKey:@"boolElement1"];
	STAssertTrue([boolElement isKindOfClass:[NSNumber class]], @"element should be NSNumber");
	NSNumber *valueOfBoolElement = boolElement;
	STAssertEquals([valueOfBoolElement boolValue], NO, @"element should be NO");

	boolElement = [dictionary objectForKey:@"boolElement2"];
	STAssertTrue([boolElement isKindOfClass:[NSNumber class]], @"element should be NSNumber");
	valueOfBoolElement = boolElement;
	STAssertEquals([valueOfBoolElement boolValue], YES, @"element should be YES");

	[parser release];
}

-(void) testIntValues
{
	NSData* data = [@"{\"intElement1\":123,\"intElement2\":456}" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* dictionary = retval;
	STAssertEquals([dictionary count], 2u, @"dictionary should have 2 elements");

	id intElement = [dictionary objectForKey:@"intElement1"];
	STAssertTrue([intElement isKindOfClass:[NSNumber class]], @"element should be NSNumber");
	NSNumber *valueOfIntElement = intElement;
	STAssertEquals([valueOfIntElement intValue], 123, @"element should be 123");

	intElement = [dictionary objectForKey:@"intElement2"];
	STAssertTrue([intElement isKindOfClass:[NSNumber class]], @"element should be NSNumber");
	valueOfIntElement = intElement;
	STAssertEquals([valueOfIntElement intValue], 456, @"element should be 456");


	[parser release];
}

-(void) testFloatValues
{
	NSData* data = [@"{\"intElement1\":12.3,\"intElement2\":-45.006}" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* dictionary = retval;
	STAssertEquals([dictionary count], 2u, @"dictionary should have 2 elements");

	id intElement = [dictionary objectForKey:@"intElement1"];
	STAssertTrue([intElement isKindOfClass:[NSNumber class]], @"element should be NSNumber");
	NSNumber *valueOfIntElement = intElement;
	STAssertEquals([valueOfIntElement doubleValue], 12.3, @"element should be 12.3");

	intElement = [dictionary objectForKey:@"intElement2"];
	STAssertTrue([intElement isKindOfClass:[NSNumber class]], @"element should be NSNumber");
	valueOfIntElement = intElement;
	STAssertEquals([valueOfIntElement doubleValue], -45.006, @"element should be -45.006");


	[parser release];
}

-(void) testDictionaryInDictionary
{
	NSData* data = [@"{\"dict\":{}}" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* dictionary = retval;
	STAssertEquals([dictionary count], 1u, @"element should have 1 elements");

	id dictElement = [dictionary objectForKey:@"dict"];
	STAssertTrue([dictElement isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	[parser release];
}

-(void) testNull
{
	NSData* data = [@"{\"nullObj\":null}" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* dictionary = retval;
	STAssertEquals([dictionary count], 1u, @"element should have 1 elements");

	id nullObjElement = [dictionary objectForKey:@"nullObj"];
	STAssertTrue(nullObjElement == [NSNull null], @"element should be null");

	[parser release];
}

-(void) testArray
{
	NSData* data = [@"[1.0,2,-3]" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSArray class]], @"element should be NSArray");

	NSArray* array = retval;
	STAssertEquals([array count], 3u, @"element should have 3 elements");

	STAssertTrue([[array objectAtIndex:0] floatValue] == 1.0f, @"element should be 1.0f");
	STAssertTrue([[array objectAtIndex:1] intValue] == 2, @"element should be 2");
	STAssertTrue([[array objectAtIndex:2] intValue] == -3, @"element should be -3");

	[parser release];
}
-(void) testHello
{
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"hello",@"en",@"你好",@"cn", nil];
	
	NXJsonSerializer *jsonWriter = [[NXJsonSerializer alloc] init];
	NSString* json = [jsonWriter serialize:dict];
	[jsonWriter release];
	
	NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	NSError* error = nil;
	NSDictionary* result = [parser parse:&error ignoreNulls:YES];
	[parser release];
	
	NSString* cn = [result objectForKey:@"cn"];
	STAssertTrue([cn isEqualToString:@"你好"], @"cn should be 你好");
	NSString* hello = [result objectForKey:@"en"];
	STAssertTrue([hello isEqualToString:@"hello"], @"cn should be hello");
	UNUSED(hello);
}

-(void) testUnicode
{
	
	NSData* data = [@"[\"\\u00ae\",\"\\u00bc\"]" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSArray class]], @"element should be NSArray");

	NSArray* array = retval;
	STAssertEquals([array count], 2u, @"element should have 3 elements");

	STAssertTrue([[array objectAtIndex:0] isEqualToString:@"®"], @"element should be ®");
	STAssertTrue([[array objectAtIndex:1] isEqualToString:@"¼"], @"element should be ¼");

	[parser release];
}

-(void) testString
{
	NSData* data = [@"\"/admin/*\"" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSString class]], @"element should be NSString");
	STAssertTrue([retval isEqualToString:@"/admin/*"], @"element should be \"/admin/*\"");

	[parser release];
}

-(void) testLongString
{
	NSMutableString* originalString = [NSMutableString string];
	for (NSUInteger charIndex = 0; charIndex < 10250; ++charIndex)
		[originalString appendString:@"c"];
	NSString *quotedString = [NSString stringWithFormat:@"\"%@\"", originalString];
	NSData* data = [quotedString dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	NSError* error = nil;
	id retVal = [parser parseData:data error:&error ignoreNulls:NO];
	STAssertNil(error, @"Error sholud be nil");
	STAssertTrue([retVal isKindOfClass:[NSString class]], @"element should be NSString");
	STAssertEqualObjects(retVal, originalString, @"Long strings do not match");

	[parser release];
}

-(void) testScientificNotation
{
	NSData* data = [@"[5.6e+5,2.3e-4,5.6E5]" dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSArray class]], @"element should be NSArray");

	NSArray* array = retval;
	STAssertEquals([array count], 3u, @"element should have 3 elements");
	static const float epsilon = 0.0000001f;
	STAssertTrue(fabsf([[array objectAtIndex:0] floatValue] - 5.6e+5f) < epsilon, @"element should be 5.6e+5");
	STAssertTrue(fabsf([[array objectAtIndex:1] floatValue] - 2.3e-4f) < epsilon, @"element should be 2.3e-4");
	STAssertTrue(fabsf([[array objectAtIndex:2] floatValue] - 5.6e+5f) < epsilon, @"element should be 5.6e+5");

	[parser release];
}

-(void) testDeep 
{
	NSString* str = @"{	\"menu\": {\
						\"id\": \"file\",\
						\"value\": \"File\",\
						\"popup\": {\
							\"menuitem\": [\
								{\"value\": \"New\", \"onclick\": \"CreateNewDoc()\"},\
								{\"value\": \"Open\", \"onclick\": \"OpenDoc()\"},\
								{\"value\": \"Close\", \"onclick\": \"CloseDoc()\"}\
							]\
						}\
						}}";
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	NXJsonParser* parser = [[NXJsonParser alloc] initWithData:data];
	STAssertNotNil(parser, @"Parser should not be nil");
	STAssertTrue([parser isKindOfClass:[NXJsonParser class]], @"Parser is of the wrong class");
	NSError* error = nil;
	id retval = [parser parse:&error ignoreNulls:NO];
	STAssertNil(error, @"Error should be nil");
	STAssertTrue([retval isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* dictionary = retval;
	STAssertEquals([dictionary count], 1u, @"element should have 1 elements");

	id menu = [dictionary objectForKey:@"menu"];
	STAssertTrue([menu isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* menuDictionary = menu;
	STAssertEquals([menuDictionary count], 3u, @"element should have 3 elements");

	id popup = [menuDictionary objectForKey:@"popup"];
	STAssertTrue([popup isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* popupDictionary = popup;
	STAssertEquals([popupDictionary count], 1u, @"element should have 1 elements");

	id menuItems = [popupDictionary objectForKey:@"menuitem"];
	STAssertTrue([menuItems isKindOfClass:[NSArray class]], @"element should be NSArray");

	NSArray* menuItemsArray = menuItems;
	STAssertEquals([menuItemsArray count], 3u, @"element should have 3 elements");
	[parser release];

	id item = [menuItemsArray objectAtIndex:0];
	STAssertTrue([item isKindOfClass:[NSDictionary class]], @"element should be NSDictionary");

	NSDictionary* itemDictionary = item;
	STAssertEquals([itemDictionary count], 2u, @"element should have 2 elements");

	id value = [itemDictionary objectForKey:@"value"];
	STAssertTrue([value isKindOfClass:[NSString class]], @"element should be NSString");

	NSString* valueString = value;
	STAssertTrue([valueString isEqualToString:@"New"], @"element should be \"New\"");
}



@end
