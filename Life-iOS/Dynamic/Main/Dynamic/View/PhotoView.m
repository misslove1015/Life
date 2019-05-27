//
//  PhotoView.m
//  Dynamic
//
//  Created by 郭明亮 on 2019/5/14.
//  Copyright © 2019 郭明亮. All rights reserved.
//

#import "PhotoView.h"
#import "PhotoViewCell.h"

@interface PhotoView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, assign) BOOL isImage;
@property (nonatomic, assign) PhotoViewType type;

@end

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void)setPhotoViewType:(PhotoViewType)photoViewType {
    self.type = photoViewType;
    [self.collectionView reloadData];
}

- (void)setImageArray:(NSArray<UIImage *> *)imageArray {
    self.array = imageArray;
    self.isImage = YES;
    [self.collectionView reloadData];
}

- (void)setImageURLArray:(NSArray<NSString *> *)imageURLArray {
    self.array = imageURLArray;
    self.isImage = NO;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == PhotoViewType_Normal) {
        return self.array.count;
    }else {
        if (self.array.count < 9) {
            return self.array.count+1;
        }else {
            return self.array.count;
        }
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.deleteButton.tag = indexPath.item;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.hidden = self.type == PhotoViewType_Normal;
    
    if (self.type == PhotoViewType_Add && indexPath.item == self.array.count && self.array.count < 9) {
        cell.imageView.image = [UIImage imageNamed:@"add"];
        cell.deleteButton.hidden = YES;
    }else {
        if (self.isImage) {
            cell.imageView.image = self.array[indexPath.item];
        }else {
            UIImage *image = [UIImage imageWithContentsOfFile:self.array[indexPath.item]];
            if (image) {
                cell.imageView.image = image;
            }else {
                NSString *url = [NSString stringWithFormat:@"%@?imageView2/2/w/300", self.array[indexPath.item]];
                [cell.imageView setWebImageWithURL:url];
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == PhotoViewType_Add && indexPath.item == self.array.count && self.array.count < 9) {
        if (self.addBlock) {
            self.addBlock();
        }
    }else {
        if (self.selectImageBlock) {
            self.selectImageBlock(indexPath.item);
        }
    }
}

- (void)deleteButtonClick:(UIButton *)button {
    if (self.deleteBlock) {
        self.deleteBlock(button.tag);
    }
}

- (void)configSubviews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-24-10)/3, (SCREEN_WIDTH-24-10)/3);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:PhotoViewCell.class forCellWithReuseIdentifier:@"cell"];
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.collectionView = collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
