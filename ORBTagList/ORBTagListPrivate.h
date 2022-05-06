//
//  ORBTagListPrivate.h
//  ORBTagListDemo
//
//  Created by 0xNSHuman on 08/12/2016.
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

#ifndef ORBTagListPrivate_h
#define ORBTagListPrivate_h

@class ORBTagListItem;

/**
 \protocol ORBTagListItemDelegate
 \brief Private protocol for ORBTagList and ORBTagListItem communication.
 \discussion You can extend it for your needs but it's not supposed to be implemented elsewhere but in ORBTagList to get updates from ORBTagListItem.
 */
@protocol ORBTagListItemDelegate <NSObject>

@required
- (void)tagListItemTapped:(ORBTagListItem *)item;
- (void)tagListAccessoryButtonTapped:(ORBTagListItem *)item;

@end


/**
 \brief Private ORBTagListItem extension available only to ORBTagList related classes for intercommunication.
 */
@interface ORBTagListItem ()

@property (nonatomic, weak) id <ORBTagListItemDelegate> privateDelegate;

@end

#endif /* ORBTagListPrivate_h */
