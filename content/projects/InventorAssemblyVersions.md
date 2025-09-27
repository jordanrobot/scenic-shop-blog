---
title: Inventor Assembly Versions
description: A collection dll library versions used by Autodesk Inventor. Target these when building addins for maximum compatibility.
#repo: "InventorShims"
tags: ["Code", "Inventor", "VB.net", "C#"]
#weight: 0
draft: false
summary: A collection dll library versions used by Autodesk Inventor. Target these when building addins for maximum compatibility.

---

This is a list of the library versions used by Autodesk Inventor; these are located in Inventor's Program Files bin directory. A sometimes frustrating part of developing software that integrates with Autodesk Inventor is chasing down bugs that are caused by assembly mismatches. If your addin uses a different library version that Inventor has in memory, and you happen to hit an incompatible call, you'll often get some  unknown exceptions.

## 2026.1

### Target: dotnet 8

| Version        | Library                                               |
| -------------- | ----------------------------------------------------- |
| 30.10.23300.0  | Autodesk.Inventor.Interop                             |
| 30.10.23300.0  | Autodesk.iLogic                                       |
| 30.10.23300.0  | Autodesk.iLogic.Interfaces                            |
| 12.0.1         | Automapper                                            |
| 24.1.6.0       | DevExpress (Various)                                  |
| 2.13.2         | freetype                                              |
| 7.0.0          | Microsoft.Bcl.AsyncInterfaces                         |
| 9.0.2          | Microsoft.Data.Sqlite                                 |
| 6.0.0          | Microsoft.Extensions.DependencyInjection.Abstractions |
| 6.0.10         | Microsoft.Extensions.DependencyInjection              |
| 6.0.9          | Microsoft.Extensions.Logging.Abstractions             |
| 6.0.0          | Microsoft.Extensions.Logging                          |
| 6.0.16         | Microsoft.Extensions.ObjectPool                       |
| 6.0.0          | Microsoft.Extensions.Options                          |
| 6.0.0          | Microsoft.Extensions.Primitives                       |
| 14.0.4756.1000 | microsoft.office.interop.excel                        |
| 13.0.3         | Newtonsoft.Json                                       |
| 4.7.10         | nlog                                                  |
| 8.0.56.0       | pdftk                                                 |
| 7.2.3.0        | Polly                                                 |
| 6.8.0.0        | QT (Various)                                          |
| 19.2017.4.4    | razor                                                 |
| 7.00.9466      | stdole                                                |
| 4.2.0          | Serilog                                               |
| 6.0.0          | Serilog.Sinks.Console                                 |
| 6.0.0          | Serilog.Sinks.File                                    |
| 13.2.47        | System.IO.Abstractions                                |


