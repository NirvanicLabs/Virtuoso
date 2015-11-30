//
//  LazyPDFPopoverView.h
//
//  Created by Palanisamy Easwaramoorthy on 23/2/15.
//  Copyright (c) 2015 Lazyprogram. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum VZPDFPopoverArrowDirection: NSUInteger {
    VZPDFPopoverArrowDirectionUp = 1UL << 0,
    VZPDFPopoverArrowDirectionDown = 1UL << 1,
    VZPDFPopoverArrowDirectionLeft = 1UL << 2,
    VZPDFPopoverArrowDirectionRight = 1UL << 3,
    VZPDFPopoverNoArrow = 1UL << 4,
    
    VZPDFPopoverArrowDirectionVertical = VZPDFPopoverArrowDirectionUp | VZPDFPopoverArrowDirectionDown | VZPDFPopoverNoArrow,
    VZPDFPopoverArrowDirectionHorizontal = VZPDFPopoverArrowDirectionLeft | VZPDFPopoverArrowDirectionRight,
    
    VZPDFPopoverArrowDirectionAny = VZPDFPopoverArrowDirectionUp | VZPDFPopoverArrowDirectionDown |
    VZPDFPopoverArrowDirectionLeft | VZPDFPopoverArrowDirectionRight
    
} VZPDFPopoverArrowDirection;

#ifndef VZPDFPopoverArrowDirectionIsVertical
    #define VZPDFPopoverArrowDirectionIsVertical(direction)    ((direction) == VZPDFPopoverArrowDirectionVertical || (direction) == VZPDFPopoverArrowDirectionUp || (direction) == VZPDFPopoverArrowDirectionDown || (direction) == VZPDFPopoverNoArrow)
#endif

#ifndef VZPDFPopoverArrowDirectionIsHorizontal
#define VZPDFPopoverArrowDirectionIsHorizontal(direction)    ((direction) == VZPDFPopoverArrowDirectionHorizontal || (direction) == VZPDFPopoverArrowDirectionLeft || (direction) == VZPDFPopoverArrowDirectionRight)
#endif

typedef enum {
    VZPDFPopoverWhiteTint,
    VZPDFPopoverBlackTint,
    VZPDFPopoverLightGrayTint,
    VZPDFPopoverGreenTint,
    VZPDFPopoverRedTint,
    VZPDFPopoverDefaultTint = VZPDFPopoverBlackTint
} VZPDFPopoverTint;

@interface VZPDFPopoverView : UIView

@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) CGPoint relativeOrigin;
@property(nonatomic,assign) VZPDFPopoverTint tint;
@property(nonatomic,assign) BOOL draw3dBorder;
@property(nonatomic,assign) BOOL border; //default YES

-(void)setArrowDirection:(VZPDFPopoverArrowDirection)arrowDirection;
-(VZPDFPopoverArrowDirection)arrowDirection;

-(void)addContentView:(UIView*)contentView;

@end
