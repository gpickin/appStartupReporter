component extends="coldbox.system.Interceptor"{

	function afterConfigurationLoad( event, interceptData, buffer, rc, prc ){
		SystemOutput( "AppStartupReporter Module - Logging to Sentry" );
		SystemOutput( "Log to Sentry: Environment: #getEnvironment()#" );
		SystemOutput( "Log to Sentry: Hostname: #getHostName()#" );
		SystemOutput( "Log to Sentry: App Version: #getVersion()#" );
		SystemOutput( "Log to Sentry: Box.json: #getBoxInfo()#" );
		SystemOutput( "Log to Sentry: Box Dependencies: #getBoxDependencies()#" );
		SystemOutput( "Sending message to Sentry" );
		var sentryService = getWireBox().getInstance( 'SentryService@sentry' );
		sentryService.captureMessage(
			message="App Version #getVersion()# started on #getHostName()# - #getEnvironment()# environment",
			level="info",
			additionalData = {
				"environment"	:	getEnvironment(),
				"hostname"		:	getHostName(),
				"appVersion"	:	getVersion(),
				"boxFile"		:	getBoxInfo(),
				"boxDependencies":	getBoxDependencies()
			}
		);
		SystemOutput( "Message sent to Sentry" );
	}


	/**
	 * Helper function to get the Environment from the ColdBox Settings
	 */
	private function getEnvironment(){
		return getSetting( 'environment' );
	}


	/**
	 * Check for Box Dependencies in a .box.dependencies file
	 */
	private function getBoxDependencies(){
		var boxInfo = "";
        if( !len( boxInfo ) ){
            try {
                boxInfo = fileRead( '.box.dependencies' );
            } catch ( any e ){
                var boxInfoFileError = e.message;
            }
		}
		return boxInfo;
	}


	/**
	 * Check for Box info in a box.json file
	 */
	private function getBoxInfo(){
		var boxInfo = "";
        if( !len( boxInfo ) ){
            try {
                boxInfo = fileRead( 'box.json' );
            } catch ( any e ){
                var boxInfoFileError = e.message;
            }
		}
		return boxInfo;
	}

	/**
	 * Get the Version of the App from the .version file
	 */
	function getVersion(){
		var appVersion = "";
        if( structKeyExists( server, "x_version" ) and len( server.x_version ) ){
            appVersion = server.x_version;
        }
        if( !len( appVersion ) ){
            try {
                appVersion = fileRead( '.version' );
            } catch ( any e ){
                var appVersionFileError = e.message;
            }
		}
		server.x_version = appVersion;
		return appVersion;
	}

	/**
	 * Get the Hostname of the Server
	 */
	function getHostName(){

		var hostnameHeader = {};
		hostnameHeader.hostname = "";
        if( structKeyExists( server.os, "hostname" ) and len( server.os.hostname ) ){
            hostnameHeader.hostname = server.os.hostname;
        }
        if( structKeyExists( server, "x_hostname" ) and len( server.x_hostname ) ){
            hostnameHeader.hostname = server.x_hostname;
        }
		if( !len( hostnameHeader.hostname ) ){
			try {
				hostnameHeader.hostname = fileRead( '/etc/hostname' );
			} catch ( any e ){
				hostnameHeader.fileError = e.message;
			}
		}
		if( !len( hostnameHeader.hostname ) ){
			try {
				var inet = CreateObject("java", "java.net.InetAddress");
				hostnameHeader.hostname = inet.getLocalHost().getHostName();
			} catch ( any e ){
	    		// Log errors
				hostnameHeader.javaError = e.message;
			}
		}
		server.x_hostname = hostnameHeader.hostname;
		return hostnameHeader.hostname;
	}


}