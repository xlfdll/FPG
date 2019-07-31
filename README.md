# Fkulc's Password Generator
A hash-based password generator with 3-level Keyword-Personal Salt-Random Salt architecture

<p align="center">
  <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Windows/FPG-Main.png"
       alt="Fkulc's Password Generator - Main Window">
</p>

An extended version of the architecture description can be found in [Docs/A Hash-Based Password Management System.pdf](https://github.com/xlfdll/FPG/blob/master/Docs/A%20Hash-Based%20Password%20Management%20System.pdf).

## System Requirements
* .NET Framework 4.7.2

[Runtime configuration](https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-configure-an-app-to-support-net-framework-4-or-4-5) is needed for running on other versions of .NET Framework.

## Usage
1. A random salt will be generated automatically when program runs at the first time
2. To generate a password, enter a keyword and a personal salt phrase, select desired password length, then click **Generate** button
3. In default, the generated password will be automatically copied to the clipboard. This can be turned off in **Options**
4. Random salt can be saved to FPG_Salt.dat for backup. This file can be restored later in another FPG instance, or can be used in FPG iOS and Android versions

   <p align="center">
       <img src="https://github.com/xlfdll/xlfdll.github.io/raw/master/images/projects/FPG/Windows/FPG-Options.png"
            alt="Fkulc's Password Generator - Options">
   </p>

## Development Prerequisites
* Visual Studio 2015+

Before the build, generate-build-number.sh needs to be executed in a Git / Bash shell to generate build information code file (BuildInfo.cs).
