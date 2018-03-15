component
	output=false
{
	this.applicationTimeout = createTimeSpan( 0, 2, 0, 0 );
	this.mappings = { "/app": expandPath( "../app" ) };
	this.javaSettings.loadPaths = directoryList( expandPath( "../app/lib" ) );
}