---
title: "Inventor Add-ins from the Ground Up"
date: "2021-05-08T18:18:33-04:00"
draft: false
tags: ["Inventor", "Code"]
summary: "An introduction to Inventor Add-ins."
---

I've decided to learn the Inventor Add-in system in earnest. In the past I've cobbled together some working add-ins, but I've never taken the time to really dig under the hood. I'm on a mission to fully understand the how and why of Inventor's add-in system. As I progress - taking notes, creating examples, and mastering the concepts - I'll note the juicy bits for future reference.

### Templates & resources

Autodesk provides an Inventor SDK with basic C# and VB add-in templates.  There are also other templates floating about with bolted-on functionality and extra utilities. It can be difficult to determine the bare minimum required to create an add-in and load it into into inventor, especially if you're looking at the extra functionality baked into templates you'll find online. Besides the stock templates provided with the Inventor's SDK, a few of the other templates are listed below...

* [Brian Elkins Nifty Inventor Add-In template](https://ekinssolutions.com/nifty_addin_template/)
* [JHurdle/CShare-Inventor-Add-in-Template](https://github.com/JHurdle91/CSharp-Inventor-Add-in-Template) which is based on Elkin's template.
* [Futemire's WPF addin template](https://github.com/Futemire/Autodesk-Inventor-WPF-Add-in-Template) I haven't actually gotten this to compile, but there is some good utility classes and methods in there.

That said, I don't mean to imply that there is a dearth of good training material out there -- far from it. [Inventor's Help Pages](https://help.autodesk.com/view/INVNTOR/2021/ENU/?guid=GUID-52422162-1784-4E8F-B495-CDB7BE9987AB) are the authoritative source, and have ever-improving documentation on working with the Inventor API and creating add-ins. The guys over at [Mod the Machine](https://modthemachine.typepad.com/my_weblog/) are Autodesk employees generating boatloads of posts on how to the use the API, tips and tricks, and other goodies. 

The [ADN DevTech](https://github.com/ADN-DevTech/ github page is full of samples as well (the same guys that run the Mod the Machine blog). If you're starting out on Inventor Add-Ins, one good resource is the [DotNet AddIns](https://github.com/ADN-DevTech/Inventor-Training-Material/tree/master/Module%2008%20-%20DotNet%20AddIns) module of the Inventor-Training-Material repo. Of particular note is this [powerpoint presentation on Add-Ins](https://github.com/ADN-DevTech/Inventor-Training-Material/raw/master/Module%2008%20-%20DotNet%20AddIns/Creating%20a%20.Net%20Addin.pptx) from this repo. This AU talk by Brian Elkins [Creating-Add-Ins-Inventor-2018](https://www.autodesk.com/autodesk-university/class/Creating-Add-Ins-Inventor-2018) is a good crash course as well.


One of the things that I've seen around for a while but didn't really understand is how the add-ins are discovered and loaded by inventor. So I did some reading and took some notes...

### How Inventor finds your add-in (.addin files)

Inventor add-in are COM components that can be created in a variety of languages.  Pre-Inventor 2012 these components were registered in the user's registry; this is how Inventor would discover add-ins and load the ones it could find.

Modern Inventor (post 2012) now uses a registry-free method of finding add-ins. Instead of looking in the registry, Inventor can now check in a number of specific directories for an .addin file. These .addin files contain the same information that used to be in the registry; they define the meta-data used to load your custom add-in into Inventor.

You create an .addin file as part of your custom add-in. An .addin filename may look something like `ACME.SuperDuperTool.addin`, where ACME is the company name and SuperDuperTool is the name of the add-in.

When your add-in is compiled into a dll file, it can be installed in any location on the user's computer. The .addin file will then point to the installed location of the dlls, and Inventor knows where to go to load the dll.  However, it is recommended to keep the .addin and dll file together within a single directory. This will make management (installs, upgrades, uninstalls) much simpler for the developer.

For clarification, the implementation of registry-free activation is provided by Microsoft, you can read about it [here for .net components](https://docs.microsoft.com/en-us/previous-versions/dotnet/articles/ms973915(v=msdn.10)) and [here for COM components](https://docs.microsoft.com/en-us/previous-versions/dotnet/articles/ms973913(v=msdn.10)). 

### Manifest files

A manifest file is an xml file that defines metadata for a group of files. Technically the .addin file detailed above is actually a manifest file.  Inventor add-ins utilize a second manifest file (ending in the extension .manifest).  This .manifest file includes data such as:

- Name of the add-in
- Version of the add-in
- class id
- program id (entry point of the add-in)
- main dll file name

This manifest file is customized for each add-in and must be embedded into the addin.dll after the dll file is compiled. A typical manifest file has the format of `AddinName.X.manifest` (where "AddinName" is the name of your add-in).  This embedding is typically performed as part of a post-build process. This process can be found in the Inventor SDK Add-in template project's post-build events.

### Loading the add-in

When Inventor starts it searches the add-in directories. For every .addin file found Inventor attempts to load the add-in. If the add-in dll (and embedded manifest file) are properly formed, the add-in is loaded into Inventor. The mechanism for loading is by implementing the interface [Inventor.ApplicationAddInServer](https://help.autodesk.com/view/INVNTOR/2021/ENU/?guid=GUID-B5DB9836-B8AD-4C73-9CD2-F46309AB7E46).  The members of this interface that your code must implement are:

- Activate( AddInSiteObject As ApplicationAddInSite, FirstTime As Boolean )
    - This is the method that is called when the add-in is loaded.  It is the entry point for your code.
- Deactivate()
    - This is called when inventor is shutting the add-in down.  Any inventor-specific reference held by the top-level class should be emptied so that Inventor can be shut down properly.
- ExecuteCommand( CommandID As Long )
    - Mostly for legacy use
- and a property Automation() As Object
    - This is if you are exposing an external API for your add-in.

The class that implements this interface must also have a GUID attribute.  Let's look at the basic implementation of this interface as an example.  This won't actually do anything of use in Inventor, because we haven't put any actionable code in the Activate method.

    using System;
    using System.Runtime.InteropServices;
    using Inventor;
    using System.Windows.Interop;

    namespace MyAddIn
    {
        [GuidAttribute("91ba0b06-1c68-4098-bc99-34987fd4c3e3")]
        public class StandardAddInServer : Inventor.ApplicationAddInServer
        {
            // Inventor application object.
            private Inventor.Application m_inventorApplication;

            public void Activate(Inventor.ApplicationAddInSite addInSiteObject, bool firstTime)
            {
                m_inventorApplication = addInSiteObject.Application;

                //entry point to load your add-in
            }

            public void Deactivate()
            {
                // Release objects.
                m_inventorApplication = null;

                GC.Collect();
                GC.WaitForPendingFinalizers();
            }

            public void ExecuteCommand(int commandID) {}

            public object Automation { get => null;}
        }
    }

And that's the bare minimum you need to create an Inventor add-in.  Unfortunately there is all that other non-code stuff that needs to happen as well, and that's where it's easy to get tripped up before you even begin.

### Summary

A quick summary of these possible tripwires...

1. Ensure you have consistent GUIDs, assembly names, file names, entry class name across...
    1. entry class
    1. addin file
    1. manifest file
    1. project properties
    1. compiled dll assembly
1. Add a reference to the Inventor.Interop COM assembly
1. (Write your add-in code)
1. Compile the add-in assembly
1. Merge the .manifest file into the assembly dll
1. Place the .addin and dll files into one of the proper Inventor Add-in directories.

Thankfully the Inventor SDK add-in template will set up most of those for you. But if you change anything related to these in your project, you'll have to update everything accordingly.