%%%----------------------------------------------------------------------
%%%
%%% ejabberd, Copyright (C) 2002-2011   ProcessOne
%%%
%%% This program is free software; you can redistribute it and/or
%%% modify it under the terms of the GNU General Public License as
%%% published by the Free Software Foundation; either version 2 of the
%%% License, or (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%%% General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with this program; if not, write to the Free Software
%%% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
%%% 02111-1307 USA
%%%
%%%----------------------------------------------------------------------

-define(MAX_USERS_DEFAULT, 200).

-define(SETS, gb_sets).
-define(DICT, dict).

-record(lqueue, {queue,
                 len :: non_neg_integer(),
                 max :: non_neg_integer()
                }).

-record(config, {title = <<>>,
                 description = <<>>,
                 allow_change_subj = true       :: boolean(),
                 allow_query_users = true       :: boolean(),
                 allow_private_messages = true  :: boolean(),
                 allow_visitor_status = true    :: boolean(),
                 allow_visitor_nickchange = true  :: boolean(),
                 public = true                  :: boolean(),
                 public_list = true             :: boolean(),
                 persistent = false             :: boolean(),
                 moderated = true               :: boolean(),
                 members_by_default = true      :: boolean(),
                 members_only = false           :: boolean(),
                 allow_user_invites = false     :: boolean(),
                 allow_multiple_sessions = false  :: boolean(),
                 password_protected = false     :: boolean(),
                 password = <<>>,
                 anonymous = true               :: boolean(),
                 max_users = ?MAX_USERS_DEFAULT,
                 logging = false                :: boolean()
                }).

-record(user, {
    %% Full JID
    %% The `user@host/resource' by which an online user is identified
    %% outside the context of a room.
    jid     :: ejabberd:jid(),
    nick    :: mod_muc:nick(),
    role    :: mod_muc:role(),
    last_presence
   }).

-record(activity, {message_time = 0,
                   presence_time = 0,
                   message_shaper :: shaper:shaper(),
                   presence_shaper :: shaper:shaper(),
                   message,
                   presence
                  }).

-record(state, {room                :: mod_muc:room(),
                host                :: ejabberd:server(),
                server_host         :: ejabberd:server(),
                access              :: mod_muc:access(),
                jid                 :: ejabberd:jid(),
                config = #config{}  :: mod_muc_room:config(),
                users = ?DICT:new(),
                sessions = ?DICT:new(),
                robots = ?DICT:new(),
                affiliations = ?DICT:new(),
                history,
                subject = <<>>,
                subject_author = <<>>,
                just_created = false     :: boolean(),
                activity = treap:empty() :: treap:treap(),
                room_shaper              :: shaper:shaper(),
                room_queue = queue:new()
               }).

-record(muc_online_users, {us :: ejabberd:simple_bare_jid(),
                           room :: mod_muc:room(),
                           host :: ejabberd:server()
                          }).
