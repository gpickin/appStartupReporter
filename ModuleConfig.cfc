/**
 * I report the App Startup information to Sentry during ColdBox startup
 */
component {

	this.name = "appStartupReporter";
    this.author = "Gavin Pickin";
    this.webUrl = "https://github.com/gpickin/appStartupReporter";

	// Module Entry Point
	//this.entryPoint			= "appStartupReporter";
	// Model Namespace
	this.modelNamespace		= "appStartupReporter";
	// CF Mapping
	this.cfmapping			= "appStartupReporter";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies
	this.dependencies 		= [];
    function configure() {

    }

	interceptors = [
		{ class="appStartupReporter.interceptors.afterConfigurationLoad" },
	];

}