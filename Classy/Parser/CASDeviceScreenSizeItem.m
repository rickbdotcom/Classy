//
//  Created by Ole Gammelgaard Poulsen on 05/04/14.
//  Copyright (c) 2014 SHAPE A/S. All rights reserved.
//

#import "CASDeviceScreenSizeItem.h"

@implementation CASDeviceScreenSizeItem

- (BOOL)isValid {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    BOOL isPad = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
    CGFloat minDimension = MIN(screenSize.width, screenSize.height);
    CGFloat maxDimension = MAX(screenSize.width, screenSize.height);
    CGFloat width = isPad ?  maxDimension : minDimension;
    CGFloat height = isPad ? minDimension : maxDimension;

    CGFloat sizeInDimension = self.dimension == CASDeviceSelectorScreenDimensionWidth ? width : height;

    switch (self.relation) {
        case CASRelationLessThan:
            return  sizeInDimension < self.value;
        case CASRelationLessThanOrEqual:
            return sizeInDimension <= self.value;
        case CASRelationEqual:
            return fabs(self.value - sizeInDimension) < 0.001;
        case CASRelationGreaterThanOrEqual:
            return sizeInDimension >= self.value;
        case CASRelationGreaterThan:
            return sizeInDimension > self.value;
        default:
            NSAssert(NO, @"There should not be undefined relations");
            return NO;
    }
}

- (NSString *)stringValue {
    NSString *dimensionString = self.dimension == CASDeviceSelectorScreenDimensionWidth ? @"width" : @"height";
    return [NSString stringWithFormat:@"(screen-%@:%@%.0f)", dimensionString, [CASDeviceSelector stringFromRelation:self.relation], self.value];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (nil != self) {
        self.relation = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(relation))];
        self.value = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(value))];
        self.dimension = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(dimension))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.relation forKey:NSStringFromSelector(@selector(relation))];
    [aCoder encodeFloat:self.value forKey:NSStringFromSelector(@selector(value))];
    [aCoder encodeInteger:self.dimension forKey:NSStringFromSelector(@selector(dimension))];
}

@end
