/*
 Copyright (c) 2018, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSColor+LabelColor.h"

#import <objc/objc-class.h>

@interface NSColor (LabelColor_XGL)

+ (NSColor *)XGL_labelColor;

+ (NSColor *)XGL_secondaryLabelColor;

+ (NSColor *)XGL_tertiaryLabelColor;

+ (NSColor *)XGL_quaternaryLabelColor;

+ (NSColor *)XGL_containerBorderColor;

@end

@implementation NSColor (LabelColor_XGL)

+ (void)load
{
	Class tClass = object_getClass(self);
	
	if ([self respondsToSelector:@selector(labelColor)]==NO)
	{
		Method origMethod = class_getClassMethod(tClass, @selector(XGL_labelColor));
		
		class_addMethod(tClass, @selector(labelColor), method_getImplementation(origMethod),method_getTypeEncoding(origMethod));
	}
	
	if ([self respondsToSelector:@selector(secondaryLabelColor)]==NO)
	{
		Method origMethod = class_getClassMethod(tClass, @selector(XGL_secondaryLabelColor));
		
		class_addMethod(tClass, @selector(secondaryLabelColor), method_getImplementation(origMethod),method_getTypeEncoding(origMethod));
	}
	
	if ([self respondsToSelector:@selector(tertiaryLabelColor)]==NO)
	{
		Method origMethod = class_getClassMethod(tClass, @selector(XGL_tertiaryLabelColor));
		
		class_addMethod(tClass, @selector(tertiaryLabelColor), method_getImplementation(origMethod),method_getTypeEncoding(origMethod));
	}
	
	if ([self respondsToSelector:@selector(quaternaryLabelColor)]==NO)
	{
		Method origMethod = class_getClassMethod(tClass, @selector(XGL_quaternaryLabelColor));
		
		class_addMethod(tClass, @selector(quaternaryLabelColor), method_getImplementation(origMethod),method_getTypeEncoding(origMethod));
	}
	
	if ([self respondsToSelector:@selector(containerBorderColor)]==NO)
	{
		Method origMethod = class_getClassMethod(tClass, @selector(XGL_containerBorderColor));
		
		class_addMethod(tClass, @selector(containerBorderColor), method_getImplementation(origMethod),method_getTypeEncoding(origMethod));
	}
}

#pragma mark -

+ (NSColor *)XGL_labelColor
{
	return [NSColor colorWithDeviceWhite:0.0 alpha:0.85];
}

+ (NSColor *)XGL_secondaryLabelColor
{
	return [NSColor colorWithDeviceWhite:0.0 alpha:0.5];
}

+ (NSColor *)XGL_tertiaryLabelColor
{
	return [NSColor colorWithDeviceWhite:0.0 alpha:0.25];
}

+ (NSColor *)XGL_quaternaryLabelColor
{
	return [NSColor colorWithDeviceWhite:0.0 alpha:0.10];
}

+ (NSColor *)XGL_containerBorderColor
{
	if ([[NSColor class] respondsToSelector:@selector(tertiaryLabelColor)]==YES)
		return [[NSColor class] performSelector:@selector(tertiaryLabelColor) withObject:nil];
	
	return [NSColor colorWithDeviceWhite:0.0 alpha:0.25];
}

@end
