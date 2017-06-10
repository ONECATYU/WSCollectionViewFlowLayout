//
//  FlowLabelLayout.h
//  FlowLabelLayout
//
//  Created by 余汪送 on 2017/6/7.
//  Copyright © 2017年 capsule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSCollectionViewFlowLayout : UICollectionViewLayout

typedef void(^_WSLayoutCompletion)(WSCollectionViewFlowLayout *layout);

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGSize headerReferenceSize;
@property (nonatomic, assign) CGSize footerReferenceSize;

///Mark: 内容的偏移量(包括区头的左右)
@property (nonatomic, assign) UIEdgeInsets contentInset;
///Mark: section的偏移量
@property (nonatomic, assign) UIEdgeInsets sectionInset;
///Mark: 布局结束后,视图内容的高度
@property (nonatomic, readonly) CGFloat sumHeight;
///Mark: 布局结束后的block回调
@property (nonatomic, copy) _WSLayoutCompletion prepareLayoutCompletion;

- (void)setPrepareLayoutCompletion:(_WSLayoutCompletion)prepareLayoutCompletion;

@end
