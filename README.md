# A Really Dumb Xcode 11 Build Issue

> Stick with Objective-C, and you'll get the fastest builds, EVER!

Yeah, maybe not.

When I build my app, Xcode appears to stall out completely (dropping from full core usage down to 10-20% CPU) during the Objective-C build phases.

In contrast, my *massive* Swift targets will happily peg my machine with *all* the cores/threads getting utilized. Swift doesn't get tripped up by this bug at all.

## Background

This project demonstrates a horrible bug in the Xcode 11 build system (which may be happening somewhere as deep as LLVM/clang).

The bug manifested for me like this:

1. Starting with a clean `DerivedData` folder, I can build my app, [Capo](https://supermegaultragroovy.com/products/capo) in about 60 seconds, flat.
2. Once I clean the build folder using command-shift-K, *all subsequent builds* will take anywhere from *180s* to *500s* (in the very worst case, which I've not seen for a while now.)

After some back & forth with Apple's engineers, I learned to turn on `clang`'s `-Rmodule-build` flag to see what's going on behind the scenes. It turns out that&mdash;for every Objective-C file that is built&mdash;framework modules are being re-built unnecessarily.

## Instructions

Download this Xcode project, and do the following: 

1. Choose the MainFramework target
2. Build the product. Everything will seem fine, and you'll see warnings in the output that indicate all the dependency modules are built once.
3. Command-Shift-K to clear the build folder
4. Build the product again. You'll now see warnings indicating that the SubFramework module is re-built for each source file.

Sometimes you may need to repeat steps 3 & 4, but once the condition occurs it _always_ repeats on subsequent clean-and-builds.

Crazy, right?! 

Imagine you have a number of private frameworks that you build, and there are inter-dependencies between them, _plus_ your main app target depends on those frameworks. If you have a lot of source files in your targets, this slow-down blows up a lot!!

For any Apple folks that might be following along, this specific issue is tracked by FB7046188.

What's especially frustrating is that I've been experiencing _terrible build performance_ since April 2018. See also FB5715747, and FB5642600.

## Affected Systems

I have only been able to test this on my iMac Pro, and a 2016 MacBook Pro. Both machines have experienced this bug on Mojave _and_ Catalina.
