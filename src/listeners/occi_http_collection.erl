%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%% @copyright 2013 Jean Parpaillon.
%%% 
%%% This file is provided to you under the Apache License,
%%% Version 2.0 (the "License"); you may not use this file
%%% except in compliance with the License.  You may obtain
%%% a copy of the License at
%%% 
%%%   http://www.apache.org/licenses/LICENSE-2.0
%%% 
%%% Unless required by applicable law or agreed to in writing,
%%% software distributed under the License is distributed on an
%%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%%% KIND, either express or implied.  See the License for the
%%% specific language governing permissions and limitations
%%% under the License.
%%% 
%% @doc Example webmachine_resource.

-module(occi_http_collection).
-compile({parse_transform, lager_transform}).

%% REST Callbacks
-export([init/3, 
	 rest_init/2,
	 allow_missing_post/2,
	 allowed_methods/2,
	 content_types_provided/2,
	 content_types_accepted/2]).

%% Callback callbacks
-export([to_plain/2,
	 from_json/2]).

-include("occi.hrl").

-record(state, {category     :: occi_category()}).

init(_Transport, _Req, _) -> 
    {upgrade, protocol, cowboy_rest}.

rest_init(Req, Cat) ->
    Req1 = occi_http:set_cors(Req),
    {ok, Req1, #state{category=Cat}}.

allow_missing_post(_Req, _State) ->
    false.

allowed_methods(Req, State) ->
    {[<<"HEAD">>, <<"GET">>, <<"PUT">>, <<"DELETE">>, <<"POST">>], Req, State}.

content_types_provided(Req, State) ->
    {[
      {{<<"text">>,          <<"plain">>,     []}, to_plain}
     ],
     Req, State}.

content_types_accepted(Req, State) ->
    {[
      {{<<"application">>,     <<"json">>,      []}, from_json},
      {{<<"application">>,     <<"occi+json">>, []}, from_json}
     ],
     Req, State}.

to_plain(Req, #state{category=Cat}=State) ->
    Entities = occi_store:get_collection(Cat#occi_category.ref),
    {occi_renderer_plain:render(Entities), Req, State}.

from_json(Req, #state{category=_Cat}=State) ->
    {ok, Body, Req2} = cowboy_req:body(Req),
    Obj = occi_parser_json:parse(Body),
    %Req3 = cowboy_req:set_resp_header(<<"location">>, Obj#occi_resource.id, Req2),
    lager:info("Create resource: ~p~n", [Obj]),
    {true, Req2, State}.