-module(owl_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).


%%-----------------------------------------------------------------------------
%%
%% supervisor
%%
%%-----------------------------------------------------------------------------

start_link() ->
   supervisor:start_link({local, ?MODULE}, ?MODULE, []).
   
init([]) -> 
   {ok,
      {
         {one_for_one, 2, 3600},  % 2 failure in hour
         []
      }
   }.