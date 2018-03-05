<cfscript>

    PDFColorFormatUtil = new app.model.PDFColorFormatUtil();
    PDFColorFormatUtil.pdfToImage( "resources/test.pdf", "resources/images/" );
    PDFColorFormatUtil.imageToPDF( "resources/images", "resources/output/result.pdf" );

    writeOutput( "<h2>PDF to Grayscale Example:</h2>" );
    writeOutput( "<h3>PDF conversion successful! You can find the grayscale image in [/resources/images] and the recompiled PDF in [/resources/results].</h3>" );

</cfscript>