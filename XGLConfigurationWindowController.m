/*
 Copyright (c) 2012-2015, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "XGLConfigurationWindowController.h"

#import <ScreenSaver/ScreenSaver.h>

#import "XGLAboutBoxWindowController.h"

#import "XGLUserDefaults+Constants.h"

@interface XGLConfigurationWindowController ()
{
    IBOutlet NSTextField * _messageLabel;
    
    IBOutlet NSSlider * _subdivisionSlider;
    
    IBOutlet NSButton * _mainScreenCheckBox;
    
    NSNumberFormatter * _numberFormatter;
}

- (IBAction)updateSubdivision:(id)sender;

- (IBAction)showAboutBox:(id)sender;

- (IBAction)closeDialog:(id)sender;

@end

@implementation XGLConfigurationWindowController

- (NSString *)windowNibName
{
    return @"XGLConfigurationWindowController";
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    _numberFormatter=[[NSNumberFormatter alloc] init];
    
    if (_numberFormatter!=nil)
    {
        _numberFormatter.hasThousandSeparators=YES;
        _numberFormatter.localizesFormat=YES;
    }
}

#pragma mark -

- (void)refreshSettings
{
    NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
    BOOL tBool;
    NSInteger tInteger;
    id tObject;
    
    // Subdivisions Count
    
    tObject=[tDefaults objectForKey:XGLUserDefaultsSubdivisionsCount];
    
    if (tObject!=nil)
        tInteger=[tDefaults integerForKey:XGLUserDefaultsSubdivisionsCount];
    else
        tInteger=XGLUserDefaultsSubdivisionsCountMinimumValue;
    
    [_subdivisionSlider setIntegerValue:tInteger];
    
    [self updateSubdivision:_subdivisionSlider];
    
    // Main Screen Only
    
    tBool=[tDefaults boolForKey:XGLUserDefaultsMainDisplayOnly];
    
    [_mainScreenCheckBox setState:(tBool==YES) ? NSOnState : NSOffState];
}

- (IBAction)updateSubdivision:(id)sender
{
    NSUInteger tFaces;
    
    tFaces=6*pow(9,[sender integerValue]);
    
    NSString * tFormattedString=[_numberFormatter stringFromNumber:[NSNumber numberWithUnsignedInteger:tFaces]];
    
    [_messageLabel setStringValue:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%@ faces",@"Localizable",[NSBundle bundleForClass:[self class]],@"No comment"),tFormattedString]];
}

- (IBAction)showAboutBox:(id)sender
{
    static XGLAboutBoxWindowController * sAboutBoxWindowController=nil;
    
    if (sAboutBoxWindowController==nil)
    {
        sAboutBoxWindowController=[XGLAboutBoxWindowController new];
    }
    
    if ([sAboutBoxWindowController.window isVisible]==NO)
    {
        [sAboutBoxWindowController.window center];
    }
    
    [sAboutBoxWindowController.window makeKeyAndOrderFront:nil];
}

- (IBAction)closeDialog:(id)sender
{
    if ([sender tag]==NSOKButton)
    {
        NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
        ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
        
        // Subdivisions Count
        
        [tDefaults setInteger:[_subdivisionSlider integerValue] forKey:XGLUserDefaultsSubdivisionsCount];
        
        // Main Screen Only
        
        [tDefaults setBool:([_mainScreenCheckBox state]==NSOnState) forKey:XGLUserDefaultsMainDisplayOnly];
        
        [tDefaults synchronize];
    }
    
    [NSApp endSheet:self.window];
}

@end
