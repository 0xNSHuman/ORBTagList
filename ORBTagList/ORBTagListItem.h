//
//  ORBTagListItem.h
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

#import <UIKit/UIKit.h>

/**
 Type of accessory shown in Tag List Item.
 */
typedef NS_ENUM(NSUInteger) {
    ORBTagListItemAccessoryViewNone = 0,
    ORBTagListItemAccessoryViewRemoveItem,
    ORBTagListItemAccessoryViewCustom
} ORBTagListItemAccessoryView;


/**
 \class ORBTagListItem
 \brief Tag List Item is a single visual data unit repsesenting one tag in Tag List.
 */
@interface ORBTagListItem : UIView

#pragma mark - Properties

/**
 Tag name to display.
 */
@property (nonatomic, strong) NSString *tagName;

/**
 Font to display. Tag Item's size is automatically calculated considering this property.
 */
@property (nonatomic, strong) UIFont *tagFont;

/**
 Color of the text to display.
 */
@property (nonatomic, strong) UIColor *tagNameColor;

/**
 Background color of the tag.
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;

/**
 Corner radius of the tag's containing view.
 */
@property (nonatomic, assign) CGFloat tagCornerRadius;

/**
 Padding to apply on left and right sides of tag text. Tag Item's size is automatically calculated considering this property.
 */
@property (nonatomic, assign) CGFloat horizontalPadding;

/**
 Type of the accessory view to display. Tag Item's size is automatically calculated considering this property.
 */
@property (nonatomic, assign) ORBTagListItemAccessoryView accessoryView;

/**
 Custom accessory view to display. Tag Item's size is automatically calculated considering this property.
 */
@property (nonatomic, strong) UIView *customAccessoryView;

/**
 Horizontal padding applied to custom accessory view. Tag Item's size is automatically calculated considering this property.
 */
@property (nonatomic, assign) CGFloat customAccessoryViewPadding;

#pragma mark - Methods

/**
 \brief Instantiates new Tag List Item with given text.
 \param text Text to display.
 \returns Tag List Item instance.
 */
- (instancetype)initWithText:(NSString *)text;

@end
