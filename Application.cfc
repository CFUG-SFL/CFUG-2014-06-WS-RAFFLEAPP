component{

    this.name                           = "cfug_raffle";
    this.sessionmanagement              = true;
    this.sessiontimeout                 = createTimeSpan(1,0,0,0);
    this.datasource                     = "cfug_raffle";

    // websockets
    this.wschannels=[{name="raffle"}];

    // mappings
    this.mappings       = {
        "/orm"            : ExpandPath("./orm")
    };

    this.ormEnabled     = true;
    this.ormSettings    = {
        automanageSession       : false,
        cfclocation             : "/orm/",
        dbcreate                : "dropcreate",
        flushatrequestend       : false,
        logSQL                  : false,
        useDBForMapping         : false,
        dialect                 : 'Derby'
    };


    public boolean function onApplicationStart(){
        application.registrationopen    = true;
        application.winnerselected      = false;
        application.winner              = {};
        return true;
    }

    function onError(exception,eventName){
        // requires setup
        if (arguments.exception.message.find("Datasource #this.datasource# could not be found")){
            var admin = createObject("component","cfide.adminapi.administrator").login('commandbox');
            var db = createObject("component","cfide.adminapi.datasource");
            if (!db.verifyDSN("cfug_raffle")){
                try{
                    db.setDerbyEmbedded(
                        name        : "cfug_raffle",
                        database    : expandPath("./db"),
                        isnewdb     : true
                    );
                    location("./",false);
                }
                catch(any e){
                    writeDump(e);
                }
            }
        }
        writeDump(arguments.exception);
    }

    public boolean function onRequestStart(targetPage){
        // reload orm
        if (structKeyExists(url,"reload")){
            application.ormtimestamp = getHttpTimeString();
            lock scope="application" type="exclusive" timeout="30"{ ormReload(); }
            applicationStop();
            location('./',false);
        }
        return true;
    }
}