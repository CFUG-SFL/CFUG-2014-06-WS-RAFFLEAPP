var BootstrapVersion = 3, FontAwesomeVersion = 4;

$(function(){
    $('button[data-role]').on('click',function(){

        var me = $(this),
            d = me.parents('tr').find('input[type=number]');

        switch (me.data('role')){

            case 'save':
                me.attr('disabled','disabled').html('<i class="fa fa-spin fa-spinner"></i>').next().attr('disabled','disabled');
                $.ajax('./',{
                    type        : 'POST',
                    dataType    : 'json',
                    data        : {id: d.data('id'), points: d.val(), process: me.data('role')},
                    success     : function(response){
                        me.removeAttr('disabled').html('<i class="fa fa-save"></i>').next().removeAttr('disabled');
                    }
                });
            break;

            case 'delete':
                openActionDialog({
                    dofade : false,
                    noerror : true,
                    message : 'Are you sure you want to delete ?',
                    callback : function(m){
                        $.ajax('./',{
                            type        : 'POST',
                            dataType    : 'json',
                            data        : {id: d.data('id'), process: me.data('role')},
                            success     : function(response){
                                m.find('.modal-footer div').removeClass('show hide');
                                m.modal('hide');
                                me.parents('tr').remove();
                            }
                        });
                    }
                });
            break;
        }

    });
});