//
//  CoursesInfo.m
//  AnyTimeClass
//
//  Created by Aman Goswami on 19/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "CoursesInfo.h"
#import "Header.h"

@implementation CoursesInfo


+(CoursesInfo *)parseSubjectList:(NSDictionary *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.array = [NSMutableArray array];
    obj.subjectID =  [user objectForKeyNotNull:ksubjectID expectedClass:[NSString class]];
    obj.subjectName = [user objectForKeyNotNull:@"subjectName" expectedClass:[NSString class]];
    obj.subjectPrice = [user objectForKeyNotNull:@"subjectPrice" expectedClass:[NSString class]];
    obj.subjectImage = [user objectForKeyNotNull:@"subjectImage" expectedClass:[NSString class]];
    obj.subjectMarks = [user objectForKeyNotNull:@"subjectMarks" expectedClass:[NSString class]];
    obj.subjectDescription = [user objectForKeyNotNull:@"subjectDescription" expectedClass:[NSString class]];
    obj.subjectsampleVideo = [user objectForKeyNotNull:@"subjectsampleVideo" expectedClass:[NSString class]];
    obj.totalLikes = [user objectForKeyNotNull:@"totalLikes" expectedClass:[NSString class]];
    obj.totalVideo = [user objectForKeyNotNull:@"totalVideo" expectedClass:[NSString class]];
    obj.totalTest = [user objectForKeyNotNull:@"totalTest" expectedClass:[NSString class]];
    obj.subjectPriceStatus =[user objectForKeyNotNull:@"subjectPriceStatus" expectedClass:[NSString class]];
    for (NSDictionary *subSubjectDict  in [user objectForKeyNotNull:@"subSubjects" expectedClass:[NSArray class]]) {
        [obj.array addObject:[CoursesInfo parseSubSubjectList:subSubjectDict]];
    }
    return obj;
}

+(CoursesInfo *)parseSubSubjectList:(NSDictionary *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.subjectID =  [user objectForKeyNotNull:ksubjectID expectedClass:[NSString class]];
    obj.subjectName = [user objectForKeyNotNull:@"subjectName" expectedClass:[NSString class]];
    obj.subjectPrice = [user objectForKeyNotNull:@"Price" expectedClass:[NSString class]];
    obj.subjectImage = [user objectForKeyNotNull:@"subjectImage" expectedClass:[NSString class]];
    obj.subjectMarks = [user objectForKeyNotNull:@"subjectMarks" expectedClass:[NSString class]];
    return obj;
}
+(CoursesInfo *)parseTestListWith:(NSArray *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.array = [NSMutableArray array];
    for (NSDictionary *dict in user) {
        [obj.array addObject:[CoursesInfo parseTestList:dict]];
    }
    return obj;
}
+(CoursesInfo *)parseTestList:(NSDictionary *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.filelink =  [user objectForKeyNotNull:@"filelink" expectedClass:[NSString class]];
    obj.testID = [user objectForKeyNotNull:@"testId" expectedClass:[NSString class]];
    obj.testName = [user objectForKeyNotNull:@"testName" expectedClass:[NSString class]];
    obj.testthumbnail = [user objectForKeyNotNull:@"testthumbnail" expectedClass:[NSString class]];
    obj.testfile = [user objectForKeyNotNull:@"testfile" expectedClass:[NSString class]];
    obj.testPurchaseStatus = [user objectForKeyNotNull:@"testPurchaseStatus" expectedClass:[NSString class]];
    obj.testPrice = [user objectForKeyNotNull:@"testPrice" expectedClass:[NSString class]];
    obj.testDescription = [user objectForKeyNotNull:@"testDescription" expectedClass:[NSString class]];
    obj.subjectImage = [user objectForKeyNotNull:@"subjectImage" expectedClass:[NSString class]];
    obj.subjectPriceStatus =[user objectForKeyNotNull:@"subjectPriceStatus" expectedClass:[NSString class]];
    obj.courseName = [user objectForKeyNotNull:@"courseName" expectedClass:[NSString class]];
    obj.subjectName = [user objectForKeyNotNull:@"subjectName" expectedClass:[NSString class]];
    return obj;
}

+(CoursesInfo *)parseTestsList:(NSDictionary *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.filelink =  [user objectForKeyNotNull:@"filelink" expectedClass:[NSString class]];
    obj.testID = [user objectForKeyNotNull:@"testID" expectedClass:[NSString class]];
    obj.testName = [user objectForKeyNotNull:@"testName" expectedClass:[NSString class]];
    obj.subjectName = [user objectForKeyNotNull:@"subjectName" expectedClass:[NSString class]];
    obj.name = [user objectForKeyNotNull:@"name" expectedClass:[NSString class]];
    obj.testthumbnail = [user objectForKeyNotNull:@"testthumbnail" expectedClass:[NSString class]];
    obj.testfile = [user objectForKeyNotNull:@"testfile" expectedClass:[NSString class]];
    obj.testPrice = [user objectForKeyNotNull:@"testPrice" expectedClass:[NSString class]];
    obj.testDescription = [user objectForKeyNotNull:@"testDescription" expectedClass:[NSString class]];
    obj.subjectImage = [user objectForKeyNotNull:@"subjectImage" expectedClass:[NSString class]];
    obj.subjectPriceStatus =[user objectForKeyNotNull:@"subjectPriceStatus" expectedClass:[NSString class]];
    return obj;
}

+(CoursesInfo *)parseVideoListWith:(NSArray *)array {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.array = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [obj.array addObject:[CoursesInfo parseVideoList:dict]];
    }
    return obj;
}

+(CoursesInfo *)parseVideoList:(NSDictionary *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.videolink =  [user objectForKeyNotNull:@"videolink" expectedClass:[NSString class]];
    obj.videoID = [user objectForKeyNotNull:kvideoId expectedClass:[NSString class]];
    obj.videoName = [user objectForKeyNotNull:@"videoName" expectedClass:[NSString class]];
    obj.videoPurchaseStatus = [user objectForKeyNotNull:@"videoPurchaseStatus" expectedClass:[NSString class]];
    obj.videoDescription = [user objectForKeyNotNull:@"videoDescription" expectedClass:[NSString class]];
    obj.videoPrice = [user objectForKeyNotNull:@"videoPrice" expectedClass:[NSString class]];
    obj.subjectName = [user objectForKeyNotNull:@"subjectName" expectedClass:[NSString class]];
    obj.courseName = [user objectForKeyNotNull:@"courseName" expectedClass:[NSString class]];
    obj.videothumbnail = [user objectForKeyNotNull:@"videothumbnail" expectedClass:[NSString class]];
    obj.subjectImage = [user objectForKeyNotNull:@"subjectImage" expectedClass:[NSString class]];
    obj.subjectPriceStatus =[user objectForKeyNotNull:@"subjectPriceStatus" expectedClass:[NSString class]];
    obj.price =[user objectForKeyNotNull:@"price" expectedClass:[NSString class]];
    return obj;
}

+(CoursesInfo *)parseQuestionList:(NSDictionary *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.questionId =  [user objectForKeyNotNull:@"questionId" expectedClass:[NSString class]];
    obj.question = [user objectForKeyNotNull:@"question" expectedClass:[NSString class]];
    obj.answer = [user objectForKeyNotNull:@"answer" expectedClass:[NSString class]];
    return obj;
}


+(CoursesInfo *)parsePurchaseList:(NSDictionary *)user {
    CoursesInfo *obj = [[CoursesInfo alloc] init];
    obj.purchaseId =  [user objectForKeyNotNull:@"purchaseId" expectedClass:[NSString class]];
    obj.orderId = [user objectForKeyNotNull:@"orderId" expectedClass:[NSString class]];
    obj.price = [user objectForKeyNotNull:@"price" expectedClass:[NSString class]];
    obj.created = [user objectForKeyNotNull:@"created" expectedClass:[NSString class]];
    return obj;
}



@end
