//
//  BPFormCell.m
//
//  Copyright (c) 2014 Bogdan Poplauschi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "BPFormCell.h"
#import "Masonry.h"
#import "BPFormInfoCell.h"
#import "BPAppearance.h"


// static vars that hold image names, if those were set. Used to override the default images
static NSString *BPMandatoryImageName = nil;
static NSString *BPValidImageName = nil;
static NSString *BPInvalidImageName = nil;
static NSString *BPHelpImageName = nil;

@implementation BPFormCell {
    CGFloat _originalHeight;
}

+ (void)setMandatoryImageName:(NSString *)inMandatoryImageName {
    BPMandatoryImageName = inMandatoryImageName;
}

+ (void)setValidImageName:(NSString *)inValidImageName invalidImageName:(NSString *)inInvalidImageName {
    BPValidImageName = inValidImageName;
    BPInvalidImageName = inInvalidImageName;
}

+ (void)setHelpImageName:(NSString *)inHelpImageName {
    BPHelpImageName = inHelpImageName;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.mandatory = NO;
        self.shouldShowInfoCell = NO;
        self.shouldShowValidation = YES;
        self.validationState = BPFormValidationStateValid;
        self.spaceToNextCell = [BPAppearance sharedInstance].spaceBetweenCells;

        [self setupMandatoryImageView];
        [self setupHelpButton];
        [self setupValidationImageView];
        [self setupInfoCell];
    }
    return self;
}

static UIImage *asterixImage = nil;
- (void)setupMandatoryImageView {
    if (!asterixImage) {
        if (BPMandatoryImageName.length) {
            asterixImage = [UIImage imageNamed:BPMandatoryImageName];
        } else {
            asterixImage = [UIImage imageNamed:@"asterix"];
        }
    }

    if (!self.mandatoryImageView) {
        self.mandatoryImageView = [[UIImageView alloc] initWithImage:asterixImage];
        self.mandatoryImageView.hidden = YES;
        [self.contentView addSubview:self.mandatoryImageView];
    }
}

static UIImage *helpImage = nil;
- (void)setupHelpButton {
    if (!helpImage) {
        if (BPHelpImageName.length) {
            helpImage = [UIImage imageNamed:BPHelpImageName];
        }
        else {
            helpImage = [UIImage imageNamed:@"help"];
        }
    }

    if (!self.helpButton) {
        self.helpButton = [[UIButton alloc] init];
        [self.helpButton setImage:helpImage forState:UIControlStateNormal];
        self.helpButton.hidden = YES;
        [self.contentView addSubview:self.helpButton];
    }
}

static UIImage *checkmarkImage = nil;
static UIImage *exclamationMarkImage = nil;

- (void)setupValidationImageView {
    if (!checkmarkImage) {
        if (BPValidImageName.length) {
            checkmarkImage = [UIImage imageNamed:BPValidImageName];
        } else {
            checkmarkImage = [UIImage imageNamed:@"checkmark"];
        }
    }

    if (!exclamationMarkImage) {
        if (BPInvalidImageName.length) {
            exclamationMarkImage = [UIImage imageNamed:BPInvalidImageName];
        } else {
            exclamationMarkImage = [UIImage imageNamed:@"exclamationMark"];
        }
    }

    if (!self.validationImageView) {
        self.validationImageView = [[UIImageView alloc] init];
        self.validationImageView.hidden = YES;
        self.validationImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.validationImageView];
    }
}

- (void)setupInfoCell {
    if (!self.infoCell) {
        self.infoCell = [[BPFormInfoCell alloc] init];
    }
}

- (CGFloat)cellHeight {
    if (_originalHeight == 0.0f) {
        _originalHeight = self.bounds.size.height;
    }

    CGFloat cellHeight = (self.customCellHeight ?: _originalHeight) + self.spaceToNextCell;
    return cellHeight;
}

#pragma mark - Property Overrides
- (void)setMandatory:(BOOL)mandatory {
    if (mandatory != _mandatory) {
        [self willChangeValueForKey:@"mandatory"];
        _mandatory = mandatory;
        [self setNeedsLayout];
        [self didChangeValueForKey:@"mandatory"];
    }
}

- (void)setShouldShowValidation:(BOOL)shouldShowValidation {
    if (shouldShowValidation != _shouldShowValidation) {
        [self willChangeValueForKey:@"shouldShowValidation"];
        _shouldShowValidation = shouldShowValidation;
        [self setNeedsLayout];
        [self didChangeValueForKey:@"shouldShowValidation"];
    }
}

- (void)setShouldShowFieldHelp:(BOOL)shouldShowFieldHelp {
    if (shouldShowFieldHelp != _shouldShowFieldHelp) {
        [self willChangeValueForKey:@"shouldShowFieldHelp"];
        _shouldShowFieldHelp = shouldShowFieldHelp;
        [self setNeedsLayout];
        [self didChangeValueForKey:@"shouldShowFieldHelp"];
    }
}

#pragma mark - View Overrides
- (void)layoutSubviews {
    [super layoutSubviews];

    self.mandatoryImageView.hidden = !self.mandatory;
    [self.mandatoryImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(asterixImage.size.width));
        make.top.equalTo(@4);
        make.left.equalTo(self.mas_left).offset(2).priorityLow();
        make.height.equalTo(@(asterixImage.size.height));
    }];

    self.validationImageView.hidden = !self.shouldShowValidation;
    [self.validationImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(checkmarkImage.size.width));
        if (self.shouldShowFieldHelp) {
            make.right.equalTo(self.helpButton.mas_left).priorityLow();
        }
        else {
            make.right.equalTo(self.mas_right).priorityLow();
        }
        make.centerY.equalTo(self.mas_centerY).priorityLow();
        make.height.equalTo(@(checkmarkImage.size.height));
    }];

    self.helpButton.hidden = !self.shouldShowFieldHelp;
    [self.helpButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(helpImage.size.width));
        make.right.equalTo(self.mas_right).priorityLow();
        make.centerY.equalTo(self.mas_centerY).priorityLow();
        make.height.equalTo(@(helpImage.size.height));
    }];

    self.infoCell.hidden = !self.shouldShowInfoCell;
}

#pragma mark - Public Methods
- (void)refreshMandatoryState {
    self.mandatoryImageView.hidden = !self.mandatory;
}

- (void)updateAccordingToValidationState {
    if (!self.shouldShowValidation) {
        return;
    }
    
    switch (self.validationState) {
        case BPFormValidationStateValid:
            self.validationImageView.image = checkmarkImage;
            self.validationImageView.hidden = NO;
            break;
        case BPFormValidationStateInvalid:
            self.validationImageView.image = exclamationMarkImage;
            self.validationImageView.hidden = NO;
            break;
        case BPFormValidationStateNone:
            self.validationImageView.image = nil;
            self.validationImageView.hidden = YES;
            break;
    }
}

@end
