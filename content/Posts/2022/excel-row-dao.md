---
title: "Sample DAO to Read & Write Excel Rows in C Sharp"
date: "2022-12-04T00:00:00-00:00"
draft: false
tags: ["Excel", "Code"]
summary: "A sample implementation of an Excel worksheet row data access object."
hasMermaid: true
---

I recently had to reimplement a simple method of editing/inserting row data into Excel in an Inventor addin and decided to make a note of it for future reference. This is very basic example, but the direct simplicity is refreshing. It struck me as an opportunity to show a real-world example of class inheritance and a simple method of getting data in/out of Excel.

This particular method utilizes the Excel row as the domain object. In this sample I've made it a list of countries and related properties. At the heart of this is the following:

- Row: a plain data object that is the base class that defines a row.
- RowDao: a static class that defines how the row is read and written to the Excel sheet.
- Additional classes derived from Row let us manipulate and transform row data.

### Class Diagram

{{<mermaid>}}
classDiagram
Row <|.. RowTransformer
Row : string Id
Row : string Name
Row : string Population
Row : string LandArea
Row : string GDP
Row : string SystemOfGovernment
RowTransformer : 
RowTransformer : +ctor()
RowTransformer : -Transform()
Row <|.. ExternalRow
ExternalRow : +ctor()
ExternalRow : -Validate()
RowDao --> Row : use
RowDao : +Read(sheet, rowNumber)
RowDao : +Write(sheet, rowNumber, Row)
RowDao : -WriteRow(sheet, rowNumber, Row)
RowDao --> Excel_Worksheet : use
{{</mermaid>}}

### Classes

#### Row

This is the domain-specific Row object. It's the base data structure that represents a row's data. This data can be manipulated in various ways by derived classes.

```csharp
public class Row
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Population { get; set; }
    public string LandArea { get; set; }
    public string GDP { get; set; }
}
```

#### Excel data

We'll imagine the Excel worksheet looks like this:

{{<table "table table-striped table-bordered">}}
| Id | Name | Population | Land Area | GDP |
|:--:|:-----|:----------:|:---------:|:---:|
| 1  | USA  | 328.2M     | 3.8M mi^2 | 23T |
| 2  | China| 1.4B       | 3.7M mi^2 | 13.7T |
| 3  | India| 1.3B       | 1.2M mi^2 | 3.1T|
| 4  | Japan| 126.5M     | 0.14M mi^2| 4.9T|
| 5  | Germany| 83.2M    | 0.14M mi^2| 4.2T|
{{</table>}}

#### RowDao

The RowDao static object reads and writes from the Worksheet's rows to the domain-specific Row object.

```csharp
public static class RowDao
{
//This reads the excel row into a new domain-specific row object.
    public static Row Read(Worksheet ws, long rowNumber)
    {
        var row = new Row();
        row.Id = ws.Cells[i, 1].Value?.ToString();
        row.Name = ws.Cells[i, 2].Value?.ToString();
        row.Population = ws.Cells[i, 3].Value?.ToString();
        row.LandArea = ws.Cells[i, 4].Value?.ToString();
        row.GDP = ws.Cells[i, 5].Value?.ToString();
        return row;
    }

//This writes the domain-specific row data structure into the excel worksheet row...
    public static void Write(Worksheet ws, long i, Row row)
    {
        WriteRow(ws.Cells[i, 1], row.Id);
        WriteRow(ws.Cells[i, 2], row.Name);
        WriteRow(ws.Cells[i, 3], row.Population);
        WriteRow(ws.Cells[i, 4], row.LandArea);
        WriteRow(ws.Cells[i, 5], row.GDP);
    }

// This is the cell-level writer that writes each cell from source data. It checks for null and formula types (R1C1 or A1 style) in the source data.   
	private static void WriteRow(Range range, string value)
	{
	    if(value is null)
	        return;

	    if (value.Contains("R[") && value.Contains("]C["))
	    {
            range.FormulaR1C1Local = value;
            return;
        }

        if (value.StartsWith("="))
        {
            range.Formula.Value = value;
            return;
        }

        range.Value = value;
	}
}
```

#### RowTransformer

Below is one of the classes derived from row.  This particular class performs a transformation on row data based on options passed in from the calling code.

```csharp
public class RowTransformer : Row
{
    private Options options {get;set;}
	    
    public RowTransformer(Row row, Options options)
    {
		Options = options;
		//Pre-transform checks
		this.Id = row.Id;
        this.Name = row.Name;
        this.Population = row.Population;
        this.LandArea = row.LandArea;
        this.GDP = row.GDP;

		Transform(Row row);
	}

    private void Transform(Row row)
    {
		//Logic to transform the input row as needed
    }
}
```

#### Client Code Example #1

Here we'll look at how to use the above classes in client code... in the fist case we'll read the selected rows from the excel worksheet, modify them, and then write them back into the worksheet.

```csharp
public static void ProcessRows(Workbook wb, Options options)
{
	Worksheet ws = workbook.ActiveSheet;

	foreach (var cell in workbook.Application.Selection.Cells)
	{
		//get the selected cell's row number
		long rowNumber = cell.Row;

		//RowDao will extract data from the excel row
        Row row = RowDao.Read(ws, rowNumber);
	
        //perform a transformation on the row data we just read
        var transformedRow = new RowTransformer(row, options);

        //RowDao will write the transformed data back into the excel row
        RowDao.Write(ws, rowNumber, transformedRow);
    }
}
```

#### ExternalRow

In this following case we'll insert external data (say from a user form or database) into the Excel sheet by deriving a new class from Row. This class takes external data and validates it. Since this is derived from a Row object, it can be written to an Excel worksheet row by calling RowDao.Write().

```csharp
public class ExternalRow : Row
{
    public ExternalRow(Model model)
    {
        this.Id = model.Id;
        this.Name = model.Name;
        this.Population = model.Population;
        this.LandArea = model.LandArea;
        this.GDP = model.GDP;

		Validate();
	}

	private void Validate()
	{
        //Validation logic goes here
	}
}
```

#### Client Code Example #2

Client code to insert data from our custom data model into Excel; we'll write the data at the currently selected Excel worksheet cells.

```csharp
private static void Insert(Workbook wb, Model model)
{
	//Create our row with the external data
	var externalRow = new ExternalRow(Model);
	Workbook ws = wb.ActiveSheet;

	//get the selected cells' row number (in real world run once per row, the following will run for every selected row)
    Range range;
    try { range = wb.Application.Selection; }
    catch { return; }

    if (range is null)
        return;

	foreach (Range element in range.Rows)
    {
        long bomRowNumber = element.Row;

	    //Put our data into excel row...
	    RowDao.Write(workbook.ActiveSheet, bomRowNumber, externalRow);
    }
}
```