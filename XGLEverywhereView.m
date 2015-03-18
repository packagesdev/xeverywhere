#import "XGLEverywhereView.h"

#ifndef __XGLEVERYWHERE__
#include "XGLeverywhere.h"
#endif

#import "XGLConfigurationWindowController.h"

#import "XGLUserDefaults+Constants.h"

static unsigned long frameCount;

@interface XGLEverywhereView ()
{
    BOOL _preview;
    BOOL _mainScreen;
    
    BOOL _OpenGLIncompatibilityDetected;
    
    NSOpenGLView * _openGLView;
    
    gasketstruct _gs;
#if DEBUG
    NSTimer * _timer;
#endif
    
    // Preferences
    
    XGLConfigurationWindowController *_configurationWindowController;
}

- (void) frameLog:(id) inSender;

@end

@implementation XGLEverywhereView	

- (id)initWithFrame:(NSRect)frameRect isPreview:(BOOL)isPreview
{
    self=[super initWithFrame:frameRect isPreview:isPreview];
    
    if (self!=nil)
    {
        _preview=isPreview;
        
        if (_preview==YES)
            _mainScreen=YES;
        else
            _mainScreen= (NSMinX(frameRect)==0 && NSMinY(frameRect)==0);
        
        [self setAnimationTimeInterval:0.04];
    }
    
    return self;
}

#pragma mark -

- (void) setFrameSize:(NSSize)newSize
{
	[super setFrameSize:newSize];
    
	if (_openGLView!=nil)
        [_openGLView setFrameSize:newSize];
}

#pragma mark -

- (void) drawRect:(NSRect) inFrame
{
	[[NSColor blackColor] set];
            
    NSRectFill(inFrame);
    
    if (_OpenGLIncompatibilityDetected==YES)
    {    
        BOOL tShowErrorMessage=_mainScreen;
        
        if (tShowErrorMessage==NO)
        {
            NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
            ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
            
            tShowErrorMessage=![tDefaults boolForKey:XGLUserDefaultsMainDisplayOnly];
        }
        
        if (tShowErrorMessage==YES)
        {
            NSRect tFrame=[self frame];
            
            NSMutableParagraphStyle * tMutableParagraphStyle=[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [tMutableParagraphStyle setAlignment:NSCenterTextAlignment];
            
            NSDictionary * tAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:[NSFont systemFontSize]],NSFontAttributeName,
                                                                                    [NSColor whiteColor],NSForegroundColorAttributeName,
                                                                                    tMutableParagraphStyle,NSParagraphStyleAttributeName,nil];
            
            
            NSString * tString=NSLocalizedStringFromTableInBundle(@"Minimum OpenGL requirements\rfor this Screen Effect\rnot available\ron your graphic card.",@"Localizable",[NSBundle bundleForClass:[self class]],@"No comment");
            
            NSRect tStringFrame;
            
            tStringFrame.origin=NSZeroPoint;
            tStringFrame.size=[tString sizeWithAttributes:tAttributes];
            
            tStringFrame=SSCenteredRectInRect(tStringFrame,tFrame);
            
            [tString drawInRect:tStringFrame withAttributes:tAttributes];
        }
    }
}

#pragma mark -

- (void) startAnimation
{
    NSString *tIdentifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    ScreenSaverDefaults *tDefaults = [ScreenSaverDefaults defaultsForModuleWithName:tIdentifier];
    BOOL tBool;
    id tObject;
    NSInteger tSubdivisionsCount;
    
    _OpenGLIncompatibilityDetected=NO;
    
    [super startAnimation];
    
    tBool=[tDefaults boolForKey:XGLUserDefaultsMainDisplayOnly];
    
    if (tBool==YES && _mainScreen==NO)
        return;
    
    tObject=[tDefaults objectForKey:XGLUserDefaultsSubdivisionsCount];
    
    if (tObject!=nil)
        tSubdivisionsCount=[tDefaults integerForKey:XGLUserDefaultsSubdivisionsCount];
    else
        tSubdivisionsCount=XGLUserDefaultsSubdivisionsCountMinimumValue;
    
    // Add OpenGLView
    
    NSOpenGLPixelFormatAttribute attribs[] =
    {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize,(NSOpenGLPixelFormatAttribute)16,
        NSOpenGLPFAMinimumPolicy,
        (NSOpenGLPixelFormatAttribute)0
    };
    
    NSOpenGLPixelFormat *tFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
    
    if (tFormat==nil)
    {
        _OpenGLIncompatibilityDetected=YES;
        return;
    }
    _openGLView = [[NSOpenGLView alloc] initWithFrame:[self bounds] pixelFormat:tFormat];
    
    if (_openGLView!=nil)
    {
        [_openGLView setWantsBestResolutionOpenGLSurface:YES];
    
        [self addSubview:_openGLView];
    }
    else
    {
        _OpenGLIncompatibilityDetected=YES;
        return;
    }
    
#if DEBUG
    frameCount=0;
    
    _timer = [[NSTimer scheduledTimerWithTimeInterval:10
                                               target:self
                                             selector:@selector(frameLog:)
                                             userInfo:nil
                                              repeats:YES] retain];
#endif
    
    //

    
    [self lockFocus];
    
    [[_openGLView openGLContext] makeCurrentContext];
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [[_openGLView openGLContext] flushBuffer];

    NSRect tPixelBounds=[_openGLView convertRectToBacking:[_openGLView bounds]];
    NSSize tSize=tPixelBounds.size;
    
    reshape((int) tSize.width, (int) tSize.height);

    pinit(&_gs,200,tSubdivisionsCount);
    
    const GLint tSwapInterval=1;
    CGLSetParameter(CGLGetCurrentContext(), kCGLCPSwapInterval,&tSwapInterval);
    
    [self unlockFocus];
}

- (void)stopAnimation
{
	[super stopAnimation];
    
#if DEBUG
    if (_timer!=NULL)
	{
        [_timer invalidate];
        _timer=nil;
	}
#endif
    
	if (_openGLView!=nil)
    {
        [[_openGLView openGLContext] makeCurrentContext];
            
        if (glIsList(_gs.gasket1))
            glDeleteLists(_gs.gasket1, 1);
    
        [_openGLView removeFromSuperviewWithoutNeedingDisplay];
        _openGLView=nil;
    }
}

- (void) animateOneFrame
{
    if (_openGLView!=nil)
    {
        [[_openGLView openGLContext] makeCurrentContext];
        
        draw_gasket(&_gs);

#if DEBUG
        frameCount++;
#endif
            
        [[_openGLView openGLContext] flushBuffer];
    }
}

#pragma mark -

- (void) frameLog:(id) inSender
{
    fprintf(stderr,"%f frames/second\n",frameCount/10.0);
	frameCount=0;
}

#pragma mark - Configuration

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    if (_configurationWindowController==nil)
        _configurationWindowController=[[XGLConfigurationWindowController alloc] init];
    
    NSWindow * tWindow=_configurationWindowController.window;
    
    [_configurationWindowController refreshSettings];
    
    return tWindow;
}

@end
