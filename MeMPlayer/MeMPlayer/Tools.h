//
//  Tools.h
//  MeMPlayer
//
//  Created by mellow on 16/1/21.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, NumKeyBoardVerification) {
    NumKeyBoardNotSet,
    NumKeyBoardNotOpenVerification,
    NumKeyBoardOpenVerification
};

typedef void(^executeFinishedBlock)(BOOL);
@interface Tools : NSObject


+ (Tools *)sharedManager;

-(BOOL)isLandscapeScreen;
-(BOOL)isOpenVolume;
-(BOOL)isOpenScreenbrightness;
-(NumKeyBoardVerification )isOpenNumKeyboard;
-(BOOL)isOpenTouchID;
-(BOOL)isOpenPlayerCircle;

-(void)openPlayerLandscape:(BOOL)isTrue;
-(void)openVolume:(BOOL)isTrue;
-(void)openScreenbrightness:(BOOL)isTrue;
-(void)openNumKeyboard:(BOOL)isTrue;
-(void)openTouchID:(BOOL)isTrue;
-(void)openPlayerCircle:(BOOL)isTrue;

-(void)triggerStorage:(NSString *)urlString;
-(NSArray *)getHistoryFromtriggerStorage;
-(void )deleteHistoryFromtriggerStorage;
-(void)deleteVideoWithFilePath:(NSString *)filePath;

@end
