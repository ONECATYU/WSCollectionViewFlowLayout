//
//  ViewController.m
//  FlowLayoutDemo
//
//  Created by 余汪送 on 2017/6/10.
//  Copyright © 2017年 capsule. All rights reserved.
//

#import "ViewController.h"
#import "FlowCollectionView.h"

@interface ViewController ()
@property (nonatomic, strong) FlowCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;

@property (nonatomic, assign) NSInteger multiple;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _multiple = 1;
    _addBtn.selected = YES;
    [self initViewSubviews];
}

- (void)initViewSubviews
{
    CGRect frame = self.view.bounds;
    frame.size.height -= 108;
    _collectionView = [FlowCollectionView collectionViewWithFrame:frame];
    [self.view addSubview:_collectionView];
}

- (IBAction)add:(id)sender {
    _multiple = 1;
    _addBtn.selected = YES;
    _subtractBtn.selected = NO;
}

- (IBAction)subtract:(id)sender {
    _multiple = -1;
    _addBtn.selected = NO;
    _subtractBtn.selected = YES;
}

- (IBAction)headerSize:(id)sender {
    CGSize headerSize = _collectionView.headerSize;
    headerSize.width += [self value];
    headerSize.height += [self value];
    _collectionView.headerSize = headerSize;
    [_collectionView reloadData];
}

#pragma mark --- section_0
- (IBAction)hspacingSection_0:(id)sender {
    _collectionView.section0_InteritemSpacing += [self value];
    [_collectionView reloadData];
}

- (IBAction)vspacingSection_0:(id)sender {
    _collectionView.section0_LineSpacing += [self value];
    [_collectionView reloadData];
}

- (IBAction)insetSection_0:(id)sender {
    UIEdgeInsets sectionInset = _collectionView.section0_inset;
    sectionInset.top += [self value];
    sectionInset.bottom += [self value];
    sectionInset.left += [self value];
    sectionInset.right += [self value];
    _collectionView.section0_inset = sectionInset;
    [_collectionView reloadData];
}

#pragma mark --- section_1
- (IBAction)hspacingSection_1:(id)sender {
    _collectionView.section1_InteritemSpacing += [self value];
    [_collectionView reloadData];
}

- (IBAction)vspacingSection_1:(id)sender {
    _collectionView.section1_LineSpacing += [self value];
    [_collectionView reloadData];
}

- (IBAction)insetSection_1:(id)sender {
    UIEdgeInsets sectionInset = _collectionView.section1_inset;
    sectionInset.top += [self value];
    sectionInset.bottom += [self value];
    sectionInset.left += [self value];
    sectionInset.right += [self value];
    _collectionView.section1_inset = sectionInset;
    [_collectionView reloadData];
}

- (NSInteger)value
{
    return _multiple * 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
