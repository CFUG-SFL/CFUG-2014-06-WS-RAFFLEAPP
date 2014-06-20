var cfws,
    holder   = $('#users'),
    frm      = $('#entryFrm'),
    users    = [];

// initialize websocket
_cf_websockets_init = function(){
    cfws = ColdFusion.WebSocket.init(   'cfws',
                                        'cfug_raffle_20140614', // application name
                                        '',                     // cflogin bs id - never use this crap
                                        'raffle',               // channel
                                        messageHandler,         // messageHandler
                                        null,                   // openHandler
                                        null,                   // closeHandler
                                        null,                   // errorHandler
                                        location.pathname);
};
ColdFusion.Event.registerOnLoad(_cf_websockets_init);

// registration closed
if (frm.data('open') === false)
    messageHandler({'data':{'process':'close-registration'}});

// functions
function messageHandler(messageobj){
    if (messageobj.data){
        if (messageobj.data.process === 'update-view')
            getUsers();
        else if (messageobj.data.process === 'delete-user')
            holder.find('#' + messageobj.data.id).remove();
        else if (messageobj.data.process === 'update-user')
            processUser(messageobj.data.user);
        else if (messageobj.data.process === 'close-registration')
            frm.find('input, button').attr('disabled','disabled').parents('.well').css('opacity','.5').find('.instructions').hide().after('<div class="alert alert-danger text-center">REGISTRATION IS CLOSED</div>');
        else if (messageobj.data.process === 'open-registration')
            frm.find('input, button').removeAttr('disabled').parents('.well').css('opacity','1').find('.alert-danger').remove().end().find('.instructions').show();
        else if (messageobj.data.process === 'choosing-winner')
            holder.find('.user').removeClass('selecting').addClass('off').end().find('#' + messageobj.data.user.hash + ' .user').addClass('selecting');
        else if (messageobj.data.process === 'winner'){
            holder.find('.user').removeClass('selecting').addClass('off');
            openDialog({noheader:true,noerror:true,message:'<h1>Winner!!!!!</h1><p>Congratulations to ...</p>' + formatUser(messageobj.data.user),nofooter:true,dostatic:true});
        }
    }

}

function processUser(user){
    // look for the user
    var u   = holder.find('#' + user.id),
        str = '';

    // just update
    if (u.length > 0){
        u.html(formatUser(user));
    }
    // load entire UI
    else {
        getUsers()
    }
}

function formatUser(user){
    return '<div class="user clearfix"><img src="' + user.gravatar + '" /><div> ' +
    '<span class="name">' + user.name + '</span>' +
    '<span class="email">' + user.email + '</span>' +
    '<span class="points">' + user.points + ' Point' + (parseInt(user.points) == 1 ? '' : 's')+ '</span></div></div>';
}

function getUsers(){
    $.ajax('./getusers/',{
        dataType    : 'json',
        success     : function(response){
            var str = '';
            for (row in response)
                str +=   '<div id="' + response[row].id + '" class="col-sm-6">' + formatUser(response[row]) + '</div>';
            holder.html(str);
            if (window.winner)
                 messageHandler({'data':{'process':'winner','user':winner}});
        }
    })
}


$(function(){

    // load users on init
    getUsers();

    // set up form
    frm.submit(function(){

        var o   = validateForm(this);

        if (o.err.length) {
            o.dofade = false;
            o.dostatic = true;
            openDialog(o);
        } else {
            $.ajax('./enter/',{
                type        : 'POST',
                dataType    : 'json',
                data        : frm.serialize(),
                success     : function(response){
                    if(parseInt(response) === 1)
                        openDialog({noheader:true,noerror:true,dofade:false,message:'<div class="lead text-success text-center">Thank you for signing up</div>'});
                    else if(parseInt(response) === -1)
                        openDialog({noheader:true,noerror:true,dofade:false,message:'<div class="lead text-danger text-center">Sorry but registration is now closed</div>'});
                    else
                        openDialog({noheader:true,noerror:true,dofade:false,message:'<div class="lead text-danger text-center">It appears you are already part of the drawing</div>'});
                    // clear form values
                    frm.find('input').val('');
                }
            });
        }
        return false;
    });
})