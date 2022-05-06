//
//  ORBTagList.m
//  ORBTagListDemo
//
//  Created by 0xNSHuman on 07/12/2016.
//  Copyright © 2016 0xNSHuman (hello@vladaverin.me). All rights reserved.
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/0xNSHuman/ORBTagList
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.

#import "ORBTagList.h"
#import "ORBTagListPrivate.h"

#define kORBTagListDefaultItemHeight 30.0f
#define kORBTagListDefaultSpaceBetweenItems 10.0f

@interface ORBTagList () <ORBTagListItemDelegate> {
    
}

@property (nonatomic, strong) NSMutableArray *tagItems;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dataContainer;

@end

@implementation ORBTagList

#pragma mark - View life cycle

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self reloadData];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.superview && self.dataSource && self.delegate) {
        [self reloadData];
    }
}

#pragma mark - Data Control

- (ORBTagListItem *)tagItemAtIndex:(NSUInteger)tagIndex {
    if (!self.tagItems || tagIndex >= self.tagItems.count) {
        return nil;
    }
    
    ORBTagListItem *item = [self.tagItems objectAtIndex:tagIndex];
    return item;
}

- (void)reloadData {
    NSAssert(self.dataSource, @"Warning: DataSource protocol must be implemented for %@ object", NSStringFromClass([self class]));
    
    /* Clean up previous views*/
    [self.scrollView removeFromSuperview];
    
    /* Pull data from DataSource */
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInTagList:)]) {
        self.tagItems = [[NSMutableArray alloc] initWithCapacity:
                         [self.dataSource numberOfItemsInTagList:self]];
    } else {
        self.tagItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    if ([self.dataSource respondsToSelector:@selector(tagList:tagItemAtIndex:)]) {
        for (NSUInteger index = 0; index < [self.dataSource numberOfItemsInTagList:self]; index++) {
            [self.tagItems insertObject:[self.dataSource tagList:self tagItemAtIndex:index] atIndex:index];
        }
    }
    
    CGFloat tagHeight;
    if ([self.dataSource respondsToSelector:@selector(heightForAllItemsInTagList:)]) {
        tagHeight = [self.dataSource heightForAllItemsInTagList:self];
    } else {
        tagHeight = kORBTagListDefaultItemHeight;
    }
    
    CGFloat horizontalMargin;
    if ([self.dataSource respondsToSelector:@selector(horizontalSpaceBetweenItemsInTagList:)]) {
        horizontalMargin = [self.dataSource horizontalSpaceBetweenItemsInTagList:self];
    } else {
        horizontalMargin = kORBTagListDefaultSpaceBetweenItems;
    }
    
    CGFloat verticalMargin;
    if ([self.dataSource respondsToSelector:@selector(verticalSpaceBetweenItemsInTagList:)]) {
        verticalMargin = [self.dataSource verticalSpaceBetweenItemsInTagList:self];
    } else {
        verticalMargin = kORBTagListDefaultSpaceBetweenItems;
    }
    
    /* Build view structure */
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    } else {
        for (UIView *subview in self.scrollView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    self.dataContainer = [[UIView alloc]
                          initWithFrame:CGRectMake(_leftEdgeInset, 0,
                                                   self.scrollView.bounds.size.width - (_leftEdgeInset + _rightEdgeInset),
                                                   self.scrollView.bounds.size.height)];
    
    int numOfFilledTagLines = 0;
    CGFloat curX = self.dataContainer.bounds.origin.x;
    
    for (ORBTagListItem *item in self.tagItems) {
        item.frame = CGRectMake(0, 0,
                                1, tagHeight);
        [item performSelector:@selector(constructViewWithMaximumWidth:)
                   withObject:@(self.dataContainer.bounds.size.width)];
        
        CGFloat spaceToTrailingMargin = self.dataContainer.bounds.size.width - curX;
        
        if (spaceToTrailingMargin - item.bounds.size.width < 0) {
            numOfFilledTagLines++;
            curX = self.dataContainer.bounds.origin.x;
        }
        
        [item setFrame:CGRectMake(curX,
                                   self.dataContainer.bounds.origin.y +
                                   (numOfFilledTagLines * (verticalMargin + tagHeight))
                                   + verticalMargin,
                                   item.bounds.size.width,
                                   tagHeight)];
        
        item.privateDelegate = self;
        [self.dataContainer addSubview:item];
        
        curX += item.bounds.size.width + horizontalMargin;
    }
    
    numOfFilledTagLines++;
    
    self.dataContainer.frame = CGRectMake(_leftEdgeInset, 0,
                                          self.dataContainer.frame.size.width,
                                          (numOfFilledTagLines * (verticalMargin + tagHeight) + verticalMargin));
    
    /* Layout Scroll View */
    [self layoutScrollView];
    [self addSubview:self.scrollView];
}

#pragma mark - UI Layout

- (void)layoutScrollView {
    CGSize newSize = CGSizeMake(self.dataContainer.bounds.size.width,
                                self.dataContainer.bounds.size.height);
    
    if (_tagListHeaderView) {
        newSize.height += _tagListHeaderView.bounds.size.height;
        [self.scrollView addSubview:_tagListHeaderView];
        
        self.dataContainer.frame = CGRectMake(self.dataContainer.frame.origin.x, _tagListHeaderView.bounds.size.height,
                                              self.dataContainer.frame.size.width,
                                              self.dataContainer.frame.size.height);
    } else {
        self.dataContainer.frame = CGRectMake(self.dataContainer.frame.origin.x, 0,
                                              self.dataContainer.frame.size.width,
                                              self.dataContainer.frame.size.height);
    }
    
    if (_tagListFooterView) {
        newSize.height += _tagListFooterView.bounds.size.height;
        
        _tagListFooterView.frame = CGRectMake(0, newSize.height - _tagListFooterView.bounds.size.height,
                                              _tagListFooterView.bounds.size.width,
                                              _tagListFooterView.bounds.size.height);
        [self.scrollView addSubview:_tagListFooterView];
    }
    
    [self.scrollView addSubview:self.dataContainer];
    [self.scrollView setContentSize:newSize];
}

#pragma mark - ORBTagListItemProtocol

- (void)tagListItemTapped:(ORBTagListItem *)item {
    if ([self.delegate respondsToSelector:@selector(tagList:itemTappedAtIndex:)]) {
        [self.delegate tagList:self itemTappedAtIndex:[self.tagItems indexOfObject:item]];
    }
}

- (void)tagListAccessoryButtonTapped:(ORBTagListItem *)item {
    switch (item.accessoryView) {
        case ORBTagListItemAccessoryViewRemoveItem:
            if ([self.delegate
                 respondsToSelector:@selector(tagList:requestedTagListItemRemovalAtIndex:)]) {
                
                [self.delegate tagList:self requestedTagListItemRemovalAtIndex:[self.tagItems indexOfObject:item]];
            }
            
            break;
            
        case ORBTagListItemAccessoryViewCustom:
            if ([self.delegate
                 respondsToSelector:@selector(tagList:itemAccessoryButtonTappedAtIndex:)]) {
                
                [self.delegate tagList:self itemAccessoryButtonTappedAtIndex:[self.tagItems indexOfObject:item]];
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - Custom Assessors

- (void)setTagListHeaderView:(UIView *)tagListHeaderView {
    if (tagListHeaderView && self.scrollView) {
        tagListHeaderView.frame = CGRectMake(0, 0,
                                              tagListHeaderView.bounds.size.width,
                                              tagListHeaderView.bounds.size.height);
    } else {
        [tagListHeaderView removeFromSuperview];
    }
    
    _tagListHeaderView = tagListHeaderView;
    
    [self layoutScrollView];
}

- (void)setTagListFooterView:(UIView *)tagListFooterView {
    if (tagListFooterView && self.scrollView) {
        tagListFooterView.frame = CGRectMake(0, 0,
                                              tagListFooterView.bounds.size.width,
                                              tagListFooterView.bounds.size.height);
    } else {
        [tagListFooterView removeFromSuperview];
    }
    
    _tagListFooterView = tagListFooterView;
    
    [self layoutScrollView];
}

- (void)setLeftEdgeInset:(CGFloat)leftEdgeInset {
    _leftEdgeInset = leftEdgeInset;
    [self reloadData];
}

- (void)setRightEdgeInset:(CGFloat)rightEdgeInset {
    _rightEdgeInset = rightEdgeInset;
    [self reloadData];
}

@end
