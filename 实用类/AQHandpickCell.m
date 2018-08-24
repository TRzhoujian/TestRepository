//
//  AQHandpickCell.m
//  AoQuan
//
//  Created by MacBook on 2018/6/19.
//  Copyright © 2018年 来亿. All rights reserved.
//

#import "AQHandpickCell.h"
#import "SYNoticeBrowseLabel.h"
@interface AQHandpickCell ()<UICollectionViewDelegateFlowLayout>

@end
@implementation AQHandpickCell
{
    //collection 的布局
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet NSLayoutConstraint *collectionViewHeight;
    CGFloat interitemSpacing;
    CGFloat collectionBottonSpacing;
    __weak IBOutlet NSLayoutConstraint *TitleViewHeight;
    __weak IBOutlet UIView *kefuView;
    __weak IBOutlet SYNoticeBrowseLabel *NoticeView;
    float ItemWidth;
    __weak IBOutlet NSLayoutConstraint *CollectionTopWithHeaderView;
    float ItemHeight;
    BOOL IsHorizontal;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [collectionView registerNib:[UINib nibWithNibName:@"AQImageTitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImageAndTitleCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"AQCommodityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CommodityCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"AQImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"OnlyImageCell"];
}
- (void)setModel:(AQCellStyleModel *)model{
    _model = model;
    _HandPickView.model = model;
    if (_noticeArr.count>0) {
        [self setUpNoticeView];
    }
    [self setupCell];
}
-(void) setUpNoticeView{
    NSArray *array = @[@"汽车库存成灾！汽车下乡或将重启，优惠是真的很大，你买账吗？", @"纯粹的车评人", @"男子买到过期食品获索赔，刚出超市便遭围殴！店长：我不是第一次看见他了...", @"自定义跑马灯功能类标签。"];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i<_noticeArr.count; i++) {
        NSDictionary *dic = _noticeArr[i];
        [arr addObject:dic[@"title"]];
    }

    NoticeView.tag = 1000;
    NoticeView.backgroundColor = [UIColor whiteColor];
    //    NoticeView.title = @"纯粹的车评人";
    NoticeView.texts = arr;
    NoticeView.delayTime = 3.0;
    NoticeView.textFont = [UIFont systemFontOfSize:14];
    NoticeView.durationTime = 3.0;
    NoticeView.textClick = ^(NSInteger index){
        NSString *text = array[index];
    };
    NoticeView.browseMode = SYNoticeBrowseVerticalScrollWhileMore;
    [NoticeView reloadData];
}
- (void)setupCell{
    if (_model.CollectionInteritemSpacing) {
        interitemSpacing  = _model.CollectionInteritemSpacing;
    }else{
        interitemSpacing  = _model.CollectionLineSpacing;
    }

    if (_model.CollectionBottonSpacing) {
        collectionBottonSpacing = _model.CollectionBottonSpacing;
    }else{
        collectionBottonSpacing = _model.CollectionTopSpacing;
    }

    if (_model.CollectionColor == collectionWhiteColorType) {
        collectionView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else if (_model.CollectionColor == collectionGrayColorType){
        self.contentView.backgroundColor = [UIColor grayColor];
        collectionView.backgroundColor = [UIColor whiteColor];
    }

    //Collection布局
    ItemWidth = (ZN_SCREEN_WIDTH-(_model.CollectionItemRowNumber*interitemSpacing-interitemSpacing)- (2*_model.CollectionLeftAndRightSpacing))/_model.CollectionItemRowNumber;
    ItemHeight = ItemWidth * _model.CollectionItemHeightAboutScreedHeight;
    _model.ItemHeight = ItemHeight;
    CGFloat d = _model.CollectionColumns%_model.CollectionItemRowNumber;
    CGFloat f = _model.CollectionColumns/_model.CollectionItemRowNumber;
    CGFloat c = (d == 0 ? 0 : 1);
    CGFloat b = f + c;
    CGFloat a = (b -1 )*_model.CollectionLineSpacing /b;


    if (_model.CollectionCellType == ImageType) {
        if ([self.reuseIdentifier isEqualToString:HaveKefuCellID]) {
            kefuView.hidden = NO;
        }
    }else if (_model.CollectionCellType == ImageAndTitleType){
        [self setHeaderViewLayout];
    }


    if (![self.reuseIdentifier isEqualToString:@"AQHandpickHorizontalCell"]) {
           collectionView.scrollEnabled = NO;
    }

    CollectionTopWithHeaderView.constant = _model.CollectionTopWithHeaderView;
    CollectionTopWithHeaderView.priority = UILayoutPriorityDefaultHigh;


    if ([self.reuseIdentifier isEqualToString:@"AQHandpickHorizontalCell"]) {
        collectionViewHeight.constant = ItemHeight  + _model.CollectionTopSpacing + collectionBottonSpacing;
        collectionViewHeight.priority = UILayoutPriorityDefaultHigh;
    }else{
        collectionViewHeight.constant = (ItemHeight + a)*b + _model.CollectionTopSpacing + collectionBottonSpacing;
        collectionViewHeight.priority = UILayoutPriorityDefaultHigh;
    }
    [collectionView reloadData];
}
-(void)setHeaderViewLayout{
    TitleViewHeight.constant = ZN_SCREEN_WIDTH/12;
}
// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.TextArr.count >0? _model.TextArr.count :  _model.CollectionColumns;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (self.myBlock) {
        cell =  self.myBlock(collectionView, indexPath,_model);
    }else{
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:titleText:SelectInTableView:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath.row titleText:_model.TextArr[indexPath.row] SelectInTableView:_model.SelectInTableView];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ItemWidth, ItemHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(_model.CollectionTopSpacing, _model.CollectionLeftAndRightSpacing, collectionBottonSpacing, _model.CollectionLeftAndRightSpacing);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return _model.CollectionLineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return interitemSpacing;
}
@end
