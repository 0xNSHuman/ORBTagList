//
//  ViewController.m
//  ORBTagListDemo
//
//  Created by 0xNSHuman on 07/12/2016.
//  Copyright © 2016 0xNSHuman (hello@vladaverin.me). All rights reserved.
//

#import "ViewController.h"
#import "ORBTagList.h"

@interface ViewController () <ORBTagListDataSource, ORBTagListDelegate> {
    ORBTagList *_tags1, *_tags2, *_tags3;
}

@property (nonatomic, strong) NSMutableDictionary *sampleTags;
@property (nonatomic, strong) NSMutableDictionary *sampleCheckmarks1;
@property (nonatomic, strong) NSMutableDictionary *sampleCheckmarks2;

@property (nonatomic, strong) NSMutableArray *randomColorset1;
@property (nonatomic, strong) NSMutableArray *randomColorset2;

@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    [self buildMinumalUI];
}

#pragma mark - Minimal Demo

- (void)buildMinumalUI {
    self.sampleCheckmarks1 = [NSMutableDictionary new];
    self.sampleCheckmarks2 = [NSMutableDictionary new];
    
    self.sampleTags = [@{
                        @"1" : [self randomTagsWithLengthFrom:4 to:12],
                        @"2" : [self randomTagsWithLengthFrom:2 to:7],
                        @"3" : [self randomTagsWithLengthFrom:1 to:3]
                        } mutableCopy];
    
    self.randomColorset1 = [NSMutableArray new];
    for (int i = 0; i < [[self.sampleTags valueForKey:@"1"] count]; i++) {
        [self.randomColorset1 addObject:[self randomColor]];
    }
    
    self.randomColorset2 = [NSMutableArray new];
    for (int i = 0; i < [[self.sampleTags valueForKey:@"3"] count]; i++) {
        [self.randomColorset2 addObject:[self randomColor]];
    }
    
    /* Create */
    _tags1 = [[ORBTagList alloc]
                        initWithFrame:CGRectMake(0, 0,
                                                 self.view.bounds.size.width,
                                                 self.view.bounds.size.height / 2)];
    _tags1.dataSource = self;
    _tags1.delegate = self;
    
    /* Optionally customize */
    _tags1.tagListHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      _tags1.bounds.size.width,
                                                                      20)];
    _tags1.tagListFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      _tags1.bounds.size.width,
                                                                      20)];
    
    _tags1.leftEdgeInset = 20;
    _tags1.rightEdgeInset = 20;
    
    [self.view addSubview:_tags1];
    
    /* Create another one if you want! It's free! */
    _tags2 = [[ORBTagList alloc]
                         initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2,
                                                  self.view.bounds.size.width / 3,
                                                  self.view.bounds.size.height / 2)];
    _tags2.dataSource = self;
    _tags2.delegate = self;
    
    /* Optionally customize */
    
    _tags2.tagListHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                       _tags2.bounds.size.width,
                                                                       5)];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                             _tags2.bounds.size.width,
                                             40)];
    
    UILabel *footerLbl = [[UILabel alloc]
                          initWithFrame:CGRectMake(_tags2.bounds.size.width * 0.1, 10,
                                                   _tags2.bounds.size.width * 0.8f, 20)];
    footerLbl.text = @"Custom Footer";
    footerLbl.font = [UIFont systemFontOfSize:14.0f];
    footerLbl.textAlignment = NSTextAlignmentCenter;
    footerLbl.textColor = [UIColor orangeColor];
    [footer addSubview:footerLbl];
    
    _tags2.tagListFooterView = footer;
    
    _tags2.leftEdgeInset = 10;
    _tags2.rightEdgeInset = 10;
    
    [self.view addSubview:_tags2];
    
    /* Make yourself a true Xmas */
    _tags3 = [[ORBTagList alloc]
                         initWithFrame:CGRectMake(self.view.bounds.size.width / 3,
                                                  self.view.bounds.size.height / 2,
                                                  self.view.bounds.size.width / 3 * 2,
                                                  self.view.bounds.size.height / 2)];
    _tags3.dataSource = self;
    _tags3.delegate = self;
    
    /* Optionally customize */
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              _tags3.bounds.size.width,
                                                              40)];
    
    UILabel *headerLbl = [[UILabel alloc]
                          initWithFrame:CGRectMake(_tags3.bounds.size.width * 0.1, 10,
                                                   _tags3.bounds.size.width * 0.8f, 30)];
    headerLbl.text = @"Custom Header";
    headerLbl.font = [UIFont systemFontOfSize:30.0f];
    headerLbl.textAlignment = NSTextAlignmentCenter;
    headerLbl.textColor = [UIColor orangeColor];
    [header addSubview:headerLbl];
    
    _tags3.tagListHeaderView = header;
    _tags3.tagListFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                       _tags3.bounds.size.width,
                                                                       20)];
    
    _tags3.leftEdgeInset = 5;
    _tags3.rightEdgeInset = 5;
    
    [self.view addSubview:_tags3];
    
    /* Just a screen separators */
    UIView *hr = [[UIView alloc]
                  initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2,
                                           self.view.bounds.size.width, 1)];
    hr.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:hr];
    
    UIView *vt = [[UIView alloc]
                  initWithFrame:CGRectMake(self.view.bounds.size.width / 3,
                                           self.view.bounds.size.height / 2,
                                           1, self.view.bounds.size.height / 2)];
    vt.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vt];
}

#pragma mark - ORBTagListDataSource

- (NSUInteger)numberOfItemsInTagList:(ORBTagList *)tagList {
    if (tagList == _tags1) {
        return [[self.sampleTags valueForKey:@"1"] count];
    } else if (tagList == _tags2) {
        return [[self.sampleTags valueForKey:@"2"] count];
    } else {
        return [[self.sampleTags valueForKey:@"3"] count];
    }
}

- (ORBTagListItem *)tagList:(ORBTagList *)tagList tagItemAtIndex:(NSUInteger)tagItemIndex {
    
    /* Use default class */
    ORBTagListItem *tag;
    
    if (tagList == _tags1) {
        tag = [[ORBTagListItem alloc]
                               initWithText:[self.sampleTags valueForKey:@"1"][tagItemIndex]];
        
        tag.tagFont = [UIFont fontWithName:@"Courier-Bold" size: 17.0f];
        tag.tagNameColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        tag.tagBackgroundColor = [self.randomColorset1 objectAtIndex:tagItemIndex];
        tag.tagCornerRadius = 20;
        tag.horizontalPadding = 10;
        
        tag.layer.borderColor = [UIColor darkGrayColor].CGColor;
        tag.layer.borderWidth = ([self.sampleCheckmarks2 valueForKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]]) ? 3.0f : 0;
        
        tag.accessoryView = ORBTagListItemAccessoryViewRemoveItem;
    } else if (tagList == _tags2) {
        tag = [[ORBTagListItem alloc]
                               initWithText:[self.sampleTags valueForKey:@"2"][tagItemIndex]];
        
        tag.tagFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
        tag.tagNameColor = [UIColor whiteColor];
        tag.tagBackgroundColor = [UIColor colorWithWhite:0.4f alpha:0.4f];
        tag.tagCornerRadius = 8.0f;
        tag.horizontalPadding = 4;
    } else {
        tag = [[ORBTagListItem alloc]
                               initWithText:[self.sampleTags valueForKey:@"3"][tagItemIndex]];
        
        tag.tagFont = [UIFont fontWithName:@"Futura-Medium" size:18.0f];
        tag.tagNameColor = [UIColor darkGrayColor];
        tag.tagBackgroundColor = self.view.backgroundColor;
        tag.tagCornerRadius = 0;
        tag.horizontalPadding = 12;
        
        tag.accessoryView = ORBTagListItemAccessoryViewCustom;
        
        tag.layer.borderWidth =  2;
        tag.layer.borderColor = [[self.randomColorset2 objectAtIndex:tagItemIndex] CGColor];
        
        UIImageView *accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:([self.sampleCheckmarks1 valueForKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]]) ? @"checkbox_on" : @"checkbox_off"]];
        accessoryImage.frame = CGRectMake(0, 0,
                                          28, 28);
        
        tag.customAccessoryView = accessoryImage;
        tag.customAccessoryViewPadding = 5;
    }
    
    /* Or whatever subclass you want */
    
    return tag;
}

- (CGFloat)heightForAllItemsInTagList:(ORBTagList *)tagList {
    if (tagList == _tags1) {
        return 40;
    } else if (tagList == _tags2) {
        return 20;
    } else {
        return 50;
    }
}

- (CGFloat)horizontalSpaceBetweenItemsInTagList:(ORBTagList *)tagList {
    if (tagList == _tags1) {
        return 15;
    } else if (tagList == _tags2) {
        return 5;
    } else {
        return 3;
    }
}

- (CGFloat)verticalSpaceBetweenItemsInTagList:(ORBTagList *)tagList {
    if (tagList == _tags1) {
        return 10;
    } else if (tagList == _tags2) {
        return 5;
    } else {
        return 15;
    }
}

#pragma mark - ORBTagListDelegate

- (void)tagList:(ORBTagList *)tagList itemTappedAtIndex:(NSUInteger)tagItemIndex {
    NSLog(@"Tapped tag #%lu", (unsigned long)tagItemIndex);
    
    if (tagList != _tags1) {
        return;
    }
        
    if ([self.sampleCheckmarks2 valueForKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]]) {
        [self.sampleCheckmarks2
         removeObjectForKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]];
    } else {
        [self.sampleCheckmarks2 setValue:@(1)
                                  forKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]];
    }
    
    [tagList reloadData];
}

- (void)tagList:(ORBTagList *)tagList itemAccessoryButtonTappedAtIndex:(NSUInteger)tagItemIndex {
    NSLog(@"Tapped tag accessory #%lu", (unsigned long)tagItemIndex);
    
    if ([self.sampleCheckmarks1 valueForKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]]) {
        [self.sampleCheckmarks1
         removeObjectForKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]];
    } else {
        [self.sampleCheckmarks1 setValue:@(1)
                                 forKey:[NSString stringWithFormat:@"%i", (int)tagItemIndex]];
    }
    
    [tagList reloadData];
}

- (void)tagList:(ORBTagList *)tagList requestedTagListItemRemovalAtIndex:(NSUInteger)tagItemIndex {
    NSLog(@"Asked to remove tag #%lu", (unsigned long)tagItemIndex);
    
    
    NSMutableArray *edited = [[self.sampleTags valueForKey:@"1"] mutableCopy];
    [edited removeObjectAtIndex:tagItemIndex];
    
    [self.sampleTags setValue:edited forKey:@"1"];
    [self.randomColorset1 removeObjectAtIndex:tagItemIndex];
    
    [tagList reloadData];
}

#pragma mark - Sample Data

- (NSArray *)randomTagsWithLengthFrom:(NSUInteger)min to:(NSUInteger)max {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableArray *tags = [NSMutableArray new];
    NSUInteger numberOfTags = 100;
    NSUInteger maxTagLength = max;
    NSUInteger minTagLength = min;
    
    for (NSUInteger i = 0; i < numberOfTags; i++) {
        int randomLength = (int)((arc4random() % (maxTagLength - minTagLength)) + minTagLength);
        NSMutableString *randomString = [NSMutableString stringWithCapacity:randomLength];
        
        for (int j = 0; j < randomLength; j++) {
            [randomString appendFormat: @"%C",
             [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
        }
        
        [tags addObject:randomString];
    }
    
    return tags;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue
                                saturation:saturation
                                brightness:brightness alpha:0.7];
}

@end
