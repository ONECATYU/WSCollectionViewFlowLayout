//
//  FlowCollectionView.m
//  FlowLayoutDemo
//
//  Created by 余汪送 on 2017/6/10.
//  Copyright © 2017年 capsule. All rights reserved.
//

#import "FlowCollectionView.h"

@interface LabelCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation LabelCollectionViewCell
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}
@end

@interface HeaderReusableView : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation HeaderReusableView
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}
@end

////////////////////////////////////////////////////////////////////////////////////

@interface FlowCollectionView ()
@property (nonatomic, strong) NSArray *numberArray;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation FlowCollectionView

+ (instancetype)collectionViewWithFrame:(CGRect)frame
{
    WSCollectionViewFlowLayout *layout = [[WSCollectionViewFlowLayout alloc]init];
    layout.contentInset = UIEdgeInsetsMake(20, 8, 20, 8);
    
    FlowCollectionView *collectionView = [[FlowCollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    return collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        CGSize size = frame.size;
        _headerSize = CGSizeMake(size.width - 16 , 40);
        _section0_InteritemSpacing = 1;
        _section0_LineSpacing = 1;
        _section0_inset = UIEdgeInsetsMake(1, 0, 1, 0);
        _section1_InteritemSpacing = 1;
        _section1_LineSpacing = 1;
        _section1_inset = UIEdgeInsetsMake(1, 0, 1, 0);
    
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        
        [self registerClass:[LabelCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    }
    return self;
}

#pragma mark - collectionview delegate -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *dataArray = [self dataArrayWith:section];
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    
    NSArray *dataArray = [self dataArrayWith:indexPath.section];
    NSString *str = dataArray[indexPath.item];
    cell.titleLabel.text = str;
    
    return cell;
}

#pragma mark - collectionview select cell -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArray = [self dataArrayWith:indexPath.section];
    NSString *str = dataArray[indexPath.item];
    NSLog(@" ------ didSelectItem: %@ ------", str);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        NSString *title = indexPath.section == 0? @"有规则布局":@"标签流布局";
        headerView.titleLabel.text = title;
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSCollectionViewFlowLayout *layout = (WSCollectionViewFlowLayout *)collectionViewLayout;
    CGFloat contentOffset = layout.contentInset.left + layout.contentInset.right;
    if (indexPath.section == 0) {
        CGFloat sectionOffset = _section0_inset.left + _section0_inset.right;
        CGFloat width = (CGRectGetWidth(collectionView.frame) - contentOffset - sectionOffset - 3 * _section0_InteritemSpacing) / 4;
        return CGSizeMake(width, 30);
    }
    NSArray *dataArray = [self dataArrayWith:indexPath.section];
    NSString *str = dataArray[indexPath.item];
    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    CGFloat sectionOffset = _section1_inset.left + _section1_inset.right;
    CGFloat maxWidth = CGRectGetWidth(collectionView.frame) - contentOffset - sectionOffset;
    return CGSizeMake(MIN(size.width + 28, maxWidth), 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return section == 0? _section0_LineSpacing:_section1_LineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return section == 0? _section0_InteritemSpacing:_section1_InteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return section == 0? _section0_inset:_section1_inset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return _headerSize;
}

#pragma mark --- helper
- (NSArray *)dataArrayWith:(NSInteger)section
{
    return section == 0? self.numberArray:self.titles;
}

#pragma mark --- getter
- (NSArray *)numberArray
{
    if (!_numberArray) {
        _numberArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];
    }
    return _numberArray;
}

- (NSArray *)titles
{
    if (!_titles) {
       _titles = @[@"无损音乐", @"iPhone6s", @"note5", @"耐克", @"网球运动鞋", @"耐克air max", @"阿迪达斯neo女鞋", @"红蜻蜓", @"WiFi扩展器"];
    }
    return _titles;
}

- (WSCollectionViewFlowLayout *)flowLayout
{
    return (WSCollectionViewFlowLayout *)self.collectionViewLayout;
}

@end
