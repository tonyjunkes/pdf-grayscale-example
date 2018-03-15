component displayname="PDF Color Format Util"
    output=false
{
    public PDFColorFormatUtil function init() {
        // PDFBox
        variables.PDDocument = createObject( "java", "org.apache.pdfbox.pdmodel.PDDocument" );
        variables.PDPage = createObject( "java", "org.apache.pdfbox.pdmodel.PDPage" );
        variables.PDPageContentStream = createObject( "java", "org.apache.pdfbox.pdmodel.PDPageContentStream" );
        variables.PDRectangle = createObject( "java", "org.apache.pdfbox.pdmodel.common.PDRectangle" );
        variables.PDImageXObject = createObject( "java", "org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject" );
        variables.PDFRenderer = createObject( "java", "org.apache.pdfbox.rendering.PDFRenderer" );
        variables.ImageType = createObject( "java", "org.apache.pdfbox.rendering.ImageType" );
        // PDFBox Tools
        variables.ImageIOUtil = createObject( "java", "org.apache.pdfbox.tools.imageio.ImageIOUtil" );
        // io
        variables.JFile = createObject( "java", "java.io.File" );

        return this;
    }

    public void function pdfToImage( required string src, required string destination, numeric dpi = 300 ) {
        // Read in the PDF as a PDDocument object
        var document = variables.PDDocument.load( variables.JFile.init( src ) );
        // Pass the Document to a PDFRenderer, get the pages
        var renderer = variables.PDFRenderer.init( document );
        var pdPages = document.getDocumentCatalog().getPages();
        // Get the file name as a naming identifier for the image(s)
        var imageTitle = src.listLast( "\/" ).listFirst( "." );
        // Iterator counter
        var page = 0;
        // Iterate over each page, create a buffered image and write the image out
        for ( var pdPage in pdPages.iterator() ) {
            var bim = renderer.renderImageWithDPI( page, dpi, variables.ImageType.GRAY );
            variables.ImageIOUtil.writeImage( bim, destination & imageTitle & "-" & ++page & ".jpg", dpi );
        }
        document.close();
    }

    public void function imageToPDF( required string src, required string destination ) {
        // Define valid PDImageXObject content formats
        var formats = [ "png", "jpg", "jpeg", "gif", "bmp" ];
        // Create blank PDDocument as the new PDF shell
        var document = variables.PDDocument;
        // Read in the directory of images
        var dir = variables.JFile.init( src );
        // Iterate over each image and create a PDF page from it
        for ( var img in dir.listFiles() ) {
            if ( formats.find( img.getName().listLast( "." ) ) ) {
                var imgObj = variables.PDImageXObject.init( document ).createFromFileByContent( img, document );
                var width = imgObj.getWidth();
                var height = imgObj.getHeight();
                var page = variables.PDPage.init( variables.PDRectangle.init( width, height ) );
                document.addPage( page );
                var contentStream = variables.PDPageContentStream.init( document, page );
                contentStream.drawImage( imgObj, 0, 0 );
                contentStream.close();
            }
        }
        document.save( destination );
        document.close();
    }
}