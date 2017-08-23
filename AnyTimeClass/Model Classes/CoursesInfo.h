//
//  CoursesInfo.h
//  AnyTimeClass
//
//  Created by Aman Goswami on 19/01/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursesInfo : NSObject
@property(strong,nonatomic) NSString *courseType;
@property(strong,nonatomic) NSString *selectSubject;
@property(strong,nonatomic) NSString *questionAsk;
@property(strong,nonatomic) NSString *UploadImage;
@property(strong,nonatomic) NSString *ImageStatus;
@property (assign,nonatomic) BOOL isTapped;
@property (assign,nonatomic) BOOL isParentTapped;
@property(nonatomic,strong)NSString *subjectDescription;
@property(nonatomic,strong)NSString *totalLikes;
@property(nonatomic,strong)NSString *totalVideo;
@property(nonatomic,strong)NSString *totalTest;
@property(nonatomic,strong)NSString *subjectID;
@property(nonatomic,strong)NSString *subjectName;
@property(nonatomic,strong)NSString *courseName;
@property(nonatomic,strong)NSString *subjectMarks;
@property(nonatomic,strong)NSString *subjectPrice;
@property(nonatomic,strong)NSString *subjectImage;
@property(nonatomic,strong)NSString *subjectsampleVideo;
@property(nonatomic,strong)NSString *subjectPriceStatus;
@property(nonatomic,strong)NSString *strTitle;
@property (assign,nonatomic) BOOL isSelected;
@property(strong,nonatomic) NSMutableArray  *array;

@property(nonatomic,strong)NSString *testName;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *testPurchaseStatus;
@property(nonatomic,strong)NSString *videoPurchaseStatus;
@property(nonatomic,strong)NSString *testthumbnail;
@property(nonatomic,strong)NSString *testPrice;
@property(nonatomic,strong)NSString *testfile;
@property(nonatomic,strong)NSString *videoPrice;
@property(nonatomic,strong)NSString *videothumbnail;
@property(nonatomic,strong)NSString *testID;
@property(nonatomic,strong)NSString *filelink;
@property(nonatomic,strong)NSString *testDescription;
@property(nonatomic,strong)NSString *videoDescription;

@property(nonatomic,strong)NSString *questionId;
@property(nonatomic,strong)NSString *question;
@property(nonatomic,strong)NSString *answer;


@property(nonatomic,strong)NSString *videoID;
@property(nonatomic,strong)NSString *videoName;
@property(nonatomic,strong)NSString *videolink;
@property(nonatomic,strong)NSString *purchaseId;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *created;

+(CoursesInfo *)parseSubjectList:(NSDictionary *)userInfo;
+(CoursesInfo *)parseTestList:(NSDictionary *)user;
+(CoursesInfo *)parseTestListWith:(NSArray *)user;
+(CoursesInfo *)parseVideoList:(NSDictionary *)user;
+(CoursesInfo *)parseVideoListWith:(NSArray *)array;
+(CoursesInfo *)parseQuestionList:(NSDictionary *)user;
+(CoursesInfo *)parsePurchaseList:(NSDictionary *)user ;
+(CoursesInfo *)parseSubSubjectList:(NSDictionary *)user;
+(CoursesInfo *)parseTestsList:(NSDictionary *)user ;
@end
