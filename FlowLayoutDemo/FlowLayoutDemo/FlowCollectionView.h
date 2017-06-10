//
//  FlowCollectionView.h
//  FlowLayoutDemo
//
//  Created by 余汪送 on 2017/6/10.
//  Copyright © 2017年 capsule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSCollectionViewFlowLayout.h"

@interface FlowCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) CGSize headerSize;

@property (nonatomic, assign) UIEdgeInsets section0_inset;
@property (nonatomic, assign) CGFloat section0_LineSpacing;
@property (nonatomic, assign) CGFloat section0_InteritemSpacing;

@property (nonatomic, assign) UIEdgeInsets section1_inset;
@property (nonatomic, assign) CGFloat section1_LineSpacing;
@property (nonatomic, assign) CGFloat section1_InteritemSpacing;

+ (instancetype)collectionViewWithFrame:(CGRect)frame;

@end
