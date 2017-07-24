//
//  FlowLabelLayout.m
//  FlowLabelLayout
//
//  Created by 余汪送 on 2017/6/7.
//  Copyright © 2017年 capsule. All rights reserved.
//

#import "WSCollectionViewFlowLayout.h"

@interface WSCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableDictionary *itemLayoutAttributesDict;
@property (nonatomic, strong) NSMutableDictionary *headLayoutAttributesDict;
@property (nonatomic, strong) NSMutableDictionary *footLayoutAttributesDict;

@end

@implementation WSCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    _itemLayoutAttributesDict = [NSMutableDictionary dictionary];
    _headLayoutAttributesDict = [NSMutableDictionary dictionary];
    _footLayoutAttributesDict = [NSMutableDictionary dictionary];
    
    UICollectionView *collectionView = self.collectionView;
    
    CGFloat cellMaxX = collectionView.frame.size.width - _contentInset.right;
    CGFloat startY = _contentInset.top;
    
    NSInteger sectionCount = 1;
    if ([collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionCount = [collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSIndexPath *sectionPath = [NSIndexPath indexPathForRow:0 inSection:section];
        CGSize headerSize = [self referenceSizeForHeaderInSection:section];
        if (!CGSizeEqualToSize(headerSize, CGSizeZero)) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionPath];
            attribute.frame = CGRectMake(_contentInset.left, startY, headerSize.width, headerSize.height);
            
            _headLayoutAttributesDict[sectionPath] = attribute;
        }
        startY += headerSize.height;
        
        NSInteger itemCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
        CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingForSectionAtIndex:section];
        CGFloat minimumLineSpacing = [self minimumLineSpacingForSectionAtIndex:section];
        UIEdgeInsets sectionInset = [self insetForSectionAtIndex:section];
        CGFloat startX = _contentInset.left + sectionInset.left;
        startY += sectionInset.top;
        
        CGRect lastCellFrame = CGRectZero;
        lastCellFrame.origin = CGPointMake(startX, startY);
        
        for (NSInteger item = 0; item < itemCount; item++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:item inSection:section];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
            
            CGSize cellSize = [self sizeForItemAtIndexPath:cellIndexPath];
            CGRect cellFrame = CGRectZero;
            
            ///Mark: 如果超过了最大X值(换一行)
            if (CGRectGetMaxX(lastCellFrame) + minimumInteritemSpacing + cellSize.width > cellMaxX - sectionInset.right) {
                cellFrame.origin = CGPointMake(startX, CGRectGetMaxY(lastCellFrame) + minimumLineSpacing);
            }
            ///Mark: 否则接着后面布局
            else {
                CGFloat interitemSpacing = minimumInteritemSpacing;
                CGFloat lastCellMaxX = CGRectGetMaxX(lastCellFrame);
                ///Mark: 如果是从头开始布局,则第一个cell不需要加间隔
                if (lastCellMaxX == startX) interitemSpacing = 0;
                cellFrame.origin = CGPointMake(lastCellMaxX + interitemSpacing, CGRectGetMinY(lastCellFrame));
            }
            
            cellFrame.size = cellSize;
            attribute.frame = cellFrame;
            lastCellFrame = cellFrame;
            
            startY = CGRectGetMaxY(lastCellFrame);
            
            _itemLayoutAttributesDict[cellIndexPath] = attribute;
        }
        
        startY += sectionInset.bottom;
        CGSize footerSize = [self referenceSizeForFooterInSection:section];
        if (!CGSizeEqualToSize(footerSize, CGSizeZero)) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:sectionPath];
            attribute.frame = CGRectMake(_contentInset.left, startY, footerSize.width, footerSize.height);
            _footLayoutAttributesDict[sectionPath] = attribute;
        }
        
        startY += footerSize.height;
    }
    _sumHeight = startY + _contentInset.bottom;
    if (_prepareLayoutCompletion) {
        _prepareLayoutCompletion(self);
    }
}

- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.frame.size;
    return CGSizeMake(size.width, MAX(self.sumHeight, size.height));
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    [self.itemLayoutAttributesDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    [self.headLayoutAttributesDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    
    [self.footLayoutAttributesDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [allAttributes addObject:attribute];
        }
    }];
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemLayoutAttributesDict[indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return self.headLayoutAttributesDict[indexPath];
    }
    return self.footLayoutAttributesDict[indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark -- helper
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = _itemSize;
    if ([[self flowLayoutDelegate] respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        cellSize = [[self flowLayoutDelegate] collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return cellSize;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets inset = _sectionInset;
    if ([[self flowLayoutDelegate] respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        inset = [[self flowLayoutDelegate] collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return inset;
}

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    if ([[self flowLayoutDelegate] respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimumLineSpacing = [[self flowLayoutDelegate] collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return minimumLineSpacing;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    if ([[self flowLayoutDelegate] respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [[self flowLayoutDelegate] collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return minimumInteritemSpacing;
}

- (CGSize)referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerSize = _headerReferenceSize;
    if ([[self flowLayoutDelegate] respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        headerSize = [[self flowLayoutDelegate] collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    return headerSize;
}

- (CGSize)referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerSize = _footerReferenceSize;
    if ([[self flowLayoutDelegate] respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        footerSize = [[self flowLayoutDelegate] collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    return footerSize;
}

- (id<UICollectionViewDelegateFlowLayout>)flowLayoutDelegate
{
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    return delegate;
}

@end
