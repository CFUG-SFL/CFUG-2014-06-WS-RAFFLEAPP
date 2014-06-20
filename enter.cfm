<cfscript>
    if (cgi.REQUEST_METHOD == "POST"){

        rtn = application.registrationopen ? 0 : -1;

        if (application.registrationopen){

            // look up user
            rec = entityLoad("User",{email:form.email},true);

            // insert
            if (isNull(rec)){
                rec = entityNew("User",{email:form.email,fullname:form.fullname});
                transaction { entitySave(rec); }
                rtn = 1;
            }
            thread name="run" action="run" {
                WSPublish("raffle",{"process":"update-view"});
            }
        }

        writeOutput(rtn);
    } else {
        location ("../",false);
    }
</cfscript>