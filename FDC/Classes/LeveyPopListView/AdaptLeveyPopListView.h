//
//  AdaptLeveyPopListView.h
//  AdaptLeveyPopListView.h
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol AdaptLeveyPopListViewDelegate;
@interface AdaptLeveyPopListView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<AdaptLeveyPopListViewDelegate> delegate;
@property (copy, nonatomic) void(^handlerBlock)(NSInteger anIndex);

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions;
- (id)initWithTitle:(NSString *)aTitle
            options:(NSArray *)aOptions
            handler:(void (^)(NSInteger))aHandlerBlock;

// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end

@protocol AdaptLeveyPopListViewDelegate <NSObject>
- (void)AdaptLeveyPopListView:(AdaptLeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex;
@optional
- (void)AdaptLeveyPopListViewDidCancel;
@end