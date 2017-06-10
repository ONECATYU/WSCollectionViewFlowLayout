### WSCollectionViewFlowLayout

* 实现了UICollectionViewDelegateFlowLayout协议方法.使用形式和系统Flowlayout相同.
* 支持多个section, 不同section标签流布局和固定有规则布局混合

<img src="https://github.com/ONECATYU/WSCollectionViewFlowLayout/blob/master/Demo.gif" width="200">

#### 使用
* 您可以通过实现UICollectionViewDelegateFlowLayout协议方法,来设置cell/header/footer.
* 也可以通过下面这种方式来设置
```objective-c
    WSCollectionViewFlowLayout *layout = [[WSCollectionViewFlowLayout alloc]init];
    layout.contentInset = UIEdgeInsetsMake(20, 8, 20, 8);
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    layout.itemSize = CGSizeMake(100, 100);
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 16, 40);
    layout.footerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 16, 40);

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
```
