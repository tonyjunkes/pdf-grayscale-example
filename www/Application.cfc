component
	output=false
{
	this.applicationTimeout = createTimeSpan( 0, 2, 0, 0 );
	this.mappings = { "/app": expandPath( "../app" ) };
	this.javaSettings.loadPaths = directoryList( expandPath( "../app/lib" ), true, "path", "*.jar" );

	// Newer versions of Lucee 5 (5.3.x) have conflicts with the versions of PDFBox used in this example
	// so we must load the main JAR (and any others supported) as an OSGi bundle
	function onApplicationStart() {
		// Create CFML/OSGi instances
		var CFMLEngine = createObject( "java", "lucee.loader.engine.CFMLEngineFactory" ).getInstance();
		var OSGiUtil = createObject( "java", "lucee.runtime.osgi.OSGiUtil" );

		// Iterate through each JAR and read its manifest for OSGi bundle references
		// If it is a bundle, we need to load it up for Lucee to identify without a conflict
		this.javaSettings.loadPaths
			.filter(( path ) => {
				cfzip( action = "read", file = arguments.path, entrypath = "META-INF/MANIFEST.MF", variable = "mfData");
				return reFindNoCase( "Bundle-SymbolicName", arguments.path );
			})
			.each(( path ) => {
				var resource = CFMLEngine.getResourceUtil().toResourceExisting( getPageContext(), arguments.path );
				OSGiUtil.installBundle( CFMLEngine.getBundleContext(), resource, true );
			});
	}
}