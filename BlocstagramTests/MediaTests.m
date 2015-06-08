//
//  MediaTests.m
//  Blocstagram
//
//  Created by Cynthia Whitlatch on 6/8/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Media.h"


@interface MediaTests : XCTestCase

@end

@implementation MediaTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testThatInitializationWorks
{
    NSDictionary *sourceDictionary = @{@"id": @"8675309",
                                       @"user" : @"Cody",
                                       @"mediaURL" : @" ",
                                       @"image" : @"http://www.example.com/example.jpg"};
    
    Media *testUser = [[Media alloc] initWithDictionary:sourceDictionary];
    
    XCTAssertEqualObjects(testUser.idNumber, sourceDictionary[@"id"], @"The ID number should be equal");
    XCTAssertEqualObjects(testUser.user, sourceDictionary[@"user"], @"The username should be equal");
    XCTAssertEqualObjects(testUser.mediaURL, sourceDictionary[@"mediaURL"], @"The mediaURL should be equal");
    XCTAssertEqualObjects(testUser.image, [NSURL URLWithString:sourceDictionary[@"image"]], @"The image should be equal");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
