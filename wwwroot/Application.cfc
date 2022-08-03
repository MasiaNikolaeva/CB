<cfcomponent>
	<cfsetting enablecfoutputonly="No">
		<cfscript>
			This.timezone = "Etc/GMT-0";
			This.sessionManagement="Yes";
			This.setClientCookies="Yes";
			This.name="TestCB";
			This.sesionTimeout=CreateTimeSpan(0,0,1,0);
			This.AplicationTimeout=CreateTimeSpan(0,0,2,0);
		</cfscript>
		<cffunction name="onApplicationStart" returnType="boolean" output="false">
			<cfreturn True/>
		</cffunction>
		<cffunction name="onApplicationEnd" returnType="void" output="false">
		</cffunction>
		<cffunction name="onSessionStart" returnType="void" output="false">
		</cffunction>
		<cffunction name="onSessionStart" returnType="void" output="false">
		</cffunction>
		<cffunction name="onRequestStart">	
		</cffunction>
	</cfsetting>
</cfcomponent>