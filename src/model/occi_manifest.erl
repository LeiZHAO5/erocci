%%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%%% @copyright (C) 2013, Jean Parpaillon
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
%%% @doc
%%%
%%% @end
%%% Created : 19 Aug 2013 by Jean Parpaillon <jean.parpaillon@free.fr>
-module(occi_manifest).
-compile([{parse_transform, lager_transform}]).

-include("occi.hrl").

-export([new/0,
	 get_resources/1,
	 add_resource/2,
	 get_links/1,
	 add_link/2]).

new() ->
    #occi_manifest{resources=[],
		   links=[]}.

get_resources(#occi_manifest{resources=R}) ->
    R.

add_resource(#occi_manifest{resources=R}=M, Res) ->
    M#occi_manifest{resources=[Res|R]}.

get_links(#occi_manifest{links=L}) ->
    L.

add_link(#occi_manifest{links=L}=M, Link) ->
    M#occi_manifest{links=[Link|L]}.