{#
 # Copyright (c) 2024 Deciso B.V.
 # All rights reserved.
 #
 # Redistribution and use in source and binary forms, with or without modification,
 # are permitted provided that the following conditions are met:
 #
 # 1. Redistributions of source code must retain the above copyright notice,
 #    this list of conditions and the following disclaimer.
 #
 # 2. Redistributions in binary form must reproduce the above copyright notice,
 #    this list of conditions and the following disclaimer in the documentation
 #    and/or other materials provided with the distribution.
 #
 # THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 # AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 # AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 # OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 # SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 # INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 # CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 # ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 # POSSIBILITY OF SUCH DAMAGE.
 #}

<script>
    'use strict';

    $( document ).ready(function () {
        let grid_user = $("#grid-user").UIBootgrid({
            search:'/api/auth/user/search/',
            get:'/api/auth/user/get/',
            add:'/api/auth/user/add/',
            set:'/api/auth/user/set/',
            del:'/api/auth/user/del/',
        });

        let grid_apikey = $("#grid-apikey").UIBootgrid({
            search:'/api/auth/user/search_api_key/',
            del:'/api/auth/user/del_api_key/',
            datakey: 'id'
        });

        $(".otp_seed").each(function(){
            let that = $(this);
            let new_container = $("<div/>");
            new_container.append(
                '<input id="user.otp_uri" class="hidden"/>',
                '<div id="otp_qrcode" class="otp_default_hidden">',
                '<button class="btn btn-primary" id="otp_unhide_seed">show</button>'
            );

            let target = that.closest('td');
            new_container.append(that.detach());
            target.append(new_container);
            $(".otp_default_hidden").hide();
            $("#otp_unhide_seed").click(function(){
                $("#otp_unhide_seed").hide();
                $(".otp_default_hidden").show();
            });
        });

        $("#user\\.otp_uri").change(function(){
            $("#otp_unhide_seed").show();
            $(".otp_default_hidden").hide();
            $('#otp_qrcode').empty();
            if ($("#user\\.otp_uri").val()) {
                $('#otp_qrcode').qrcode($("#user\\.otp_uri").val());
            }
        });

    });

</script>


<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#user">{{ lang._('Users') }}</a></li>
    <li><a data-toggle="tab" href="#apikeys" id="tab_apikeys"> {{ lang._('ApiKeys') }} </a></li>
</ul>
<div class="tab-content content-box">
    <div id="user" class="tab-pane fade in active">
        <table id="grid-user" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogUser">
            <thead>
                <tr>
                    <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                    <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
                    <th data-column-id="descr" data-width="15em" data-type="string">{{ lang._('Description') }}</th>
                    <th data-column-id="commands" data-width="11em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="apikeys" class="tab-pane fade in">
        <table id="grid-apikey" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogUser">
            <thead>
                <tr>
                    <th data-column-id="id" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                    <th data-column-id="username" data-width="15em" data-type="string">{{ lang._('Username') }}</th>
                    <th data-column-id="key" data-type="string">{{ lang._('Api key') }}</th>
                    <th data-column-id="commands" data-width="11em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
</div>

{{ partial("layout_partials/base_dialog",['fields':formDialogEditUser,'id':'DialogUser','label':lang._('Edit User')])}}
