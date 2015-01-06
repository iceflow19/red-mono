red-mono
========

Sandbox/experimental version of the **Red-Mono** bridge.

In the future the intent is for the bridge to be integrated into the [Red Repository](https://github.com/red/red).  Until then I thought it be best to have a separate repository, where I would not be afraid to experiment around with the code, and where it would not matter if the code was functional or not.

Vision
------------------------

The [Common Language Infrastructure](http://www.ecma-international.org/publications/standards/Ecma-335.htm) is a robust platform and the mono implementation of it even more so.  Mono enjoys the support of both Microsoft, Novell, and several other companies.  Through Xamarin/Mono, cross platform assemblies can be compiled for a variety of platforms including:

PC/Embedded: Windows, Mac, Linux, BSD

Mobile:      Android, Apple, Ubuntu Phone

The **Common Intermediate Language** on Mono is also supported by [several](http://www.mono-project.com/docs/about-mono/languages/) different programming languages: C#, F#, Scala, Boo, Nemerle, VB.NET, IronPython, IronJS, etc.  Another component of the mono package is IKVM.NET, which is a CLR implementation of the JVM.  As a result any languages targeting the JVM can be ran on the Mono Virtual Machine.

What does this mean for Red?

1. A single bridge can provide interop with a multitude of languages currently in existence, and many yet to be created languages as well.

2. As the Mono runtime is designed to be cross platform this model fits well with the cross platform mentallity of Red.

3. Xamarin users can leverage the power of Red in mobile apps.  Added benefit of Xamarin.Forms

4. Perhaps in the future Red/System could be compiled to CIL?

Design
------------------------

Structurally the bridge needs to support both simplex and duplex operation, with interop libraries on both sides to provide tighter integration.  Use of Red code is through the [P/Invoke](http://www.mono-project.com/docs/advanced/pinvoke/) interface while use of managed code is through the [Mono Embedding API](http://www.mono-project.com/docs/advanced/embedding/).  Due to the current lack of static linking and lack of exporting on non library binaries in Red, certain workarounds will need to be used in the meantime.  Primarily, encapsulating the native end of the bridge in a struct which may be passed freely to all Red participants, will be used.  Simplex operation will find prominent use in mobile applications where the managed assembly needs to control the relationship with unmanaged Red.

Building
------------------------

Currently the bridge has only been confirmed to build on windows, I'll work on other platforms once one is functional.  Configuring the bridge to build is fairly easy.

1. Clone the repository

2. [Install Mono](http://www.mono-project.com/download/) - Defaults are fine.

3. [Install Xamarin Studio](http://www.monodevelop.com/download/)

4. Build the test project in Xamarin Studio

5. [Download](http://www.red-lang.org/p/download.html) the most recent version of Red and place in project root.

6. red-050 -c -o bin\demo.exe src\DemoLauncher.reds