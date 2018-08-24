//
//  AQHandpickCell.h
//  AoQuan
//
//  Created by MacBook on 2018/6/19.
//  Copyright © 2018年 来亿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AQHandpickDelegate <NSObject>

- (void)didSelectItemAtIndexPath:(NSInteger)item titleText:(NSString *)title SelectInTableView:(NSInteger)SelectInTableView;

@end

@interface AQHandpickCell : UITableViewCell
@property (nonatomic, strong) NSArray *noticeArr;
@property (nonatomic , strong) AQCellStyleModel *model;
@property (weak, nonatomic) IBOutlet AQTitleHeaderView *HandPickView;
@property (nonatomic, weak) id<AQHandpickDelegate> delegate;
@property (nonatomic, copy) UICollectionViewCell *(^myBlock)(UICollectionView *collectionView,NSIndexPath *indexPath,AQCellStyleModel *model);

@end
