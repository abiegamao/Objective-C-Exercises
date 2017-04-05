//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by Abz Maxey on 18/02/2017.
//  Copyright © 2017 Abz Maxey. All rights reserved.
//

#import "BNRHypnosisView.h"

// You can add a property inside a class extension
@interface BNRHypnosisView ()
@property (strong, atomic) UIColor *circleColor;
@end


@implementation BNRHypnosisView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // ALL BNRHypnosisView starts with a clear bg color
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect{

    CGRect bounds = self.bounds;
    CGPoint center;
    
    //figure out the center of the bounds
    center.x = self.bounds.origin.x + bounds.size.width / 2.0 ; // center horizontally
    center.y = bounds.origin.y + bounds.size.height / 2.0; //vertically
    
    // the circle will be the largest that will fit the view
    

    //float radius = (MIN(bounds.size.width, bounds.size.height)/2.0);
 

    // largest circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    path.lineWidth = 10;
    
    //set Color
    //[[UIColor grayColor] setStroke];
    [self.circleColor setStroke];
/*
    // add an arc to the path at center, radius at radius
    [path addArcWithCenter:center radius:radius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
 */
    for (float currentRadius = maxRadius; currentRadius > 0 ; currentRadius -= 20){
        // remove the line of the pencil
        [path moveToPoint:CGPointMake(center.x + currentRadius , center.y)];
        [path addArcWithCenter:center radius:currentRadius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    }

    
    
    [path stroke];
    
    // BRONZE CHALLENGE
   // UIImageView *imageView;
    
    UIImage *logoImage = [UIImage imageNamed:@"myImage.png"];

    //[imageView drawRect:logoRect];
    
/*
    // GRADIENT

    

    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {0, 1, 0, 1,// start color - red
        1, 1, 0, 1  }; // end color green
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(logoRect.origin.x / 2 , logoRect.origin.y);
    CGPoint endPoint = CGPointMake(logoRect.origin.x / 2, logoRect.origin.y + logoRect.size.height);*/
    
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect imageRect = CGRectMake(bounds.origin.x + 60, bounds.origin.y + 160, bounds.size.width / 1.5, bounds.size.height / 2.3);
    
    //////// GOLD - START DRAW A GRADIENT //////////
    /*  Define a Gradient  - Gradients, like shadows, require CoreGraphics API directly */
    // Gradients allow you to do shading that moves smoothly through a list of colors.
    // Build parameters for gradient function
    CGFloat locations[2] = { 0.0, 1.0 }; // array of floats for location parameter
    CGFloat components[8] = { 0.0, 1.0, 0.0, 1.0, // Start Color is Green    // array of floats for components parameter
        1.0, 1.0, 0.0, 1.0 }; // End color is Yellow
    // Encapsulates color space info - for colorSpace parameter
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Build gradient
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    
    /*  Define a Starting and Endpoints for gradient (required parameter for gradient draw function */
    CGPoint startPoint = { imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y };
    CGPoint endPoint = { imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y + imageRect.size.height };
    
    /*  Define Triangle-Shaped Clipping Area for Gradient (by default they draw entire view frame) */
/* USING CoreGraphics API in favor of Bezier object to build and draw the clipping path (good CG Practice) */
    // Start at the tip of the triangle
    [path moveToPoint:startPoint];
    // Bottom Right Point
    [path addLineToPoint:CGPointMake(imageRect.origin.x + imageRect.size.width, imageRect.origin.y
                                     + imageRect.size.height)];
    // Bottom left point
    [path addLineToPoint:CGPointMake(imageRect.origin.x, imageRect.origin.y + imageRect.size.height)];
    [path closePath];
    
    // Draw the lines for clipping
    path.lineWidth = 1;
    [[UIColor clearColor] setStroke];
    // draw the line
    [path stroke];
    // making the path a clipping for the gradient via addclip method
    [path addClip];
    
    // define the triangle path
    // center so /2
    CGPoint trianTop = { imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y };
    // extra width
    CGPoint trianLeft = { imageRect.origin.x + imageRect.size.width , imageRect.origin.y + imageRect.size.height};
    // origin
    CGPoint trianRight = { imageRect.origin.x , imageRect.origin.y + imageRect.size.height};
    
    
    CGPoint lines[] = {trianTop, trianLeft, trianRight};
    CGContextAddLines(currentContext, lines, 3);
    // make clipping on existing context
    // save current context first
    CGContextSaveGState(currentContext);
    // add clipping path to current context
    CGContextClip(currentContext);
    
    // draw gradient on current
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation & kCGGradientDrawsAfterEndLocation);
    // bitwised-AND last 2 constants together to form last argument
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    // restore current context
    CGContextRestoreGState(currentContext);
    
    
   
    
  // GOLD CHALLENGE - SHADOW

    CGContextSaveGState(currentContext);
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
    
    
    //[logoImage drawInRect:logoRect];
    //CGContextRestoreGState(currentContext);
    [logoImage drawInRect:imageRect];



    
   
    

}

@end
