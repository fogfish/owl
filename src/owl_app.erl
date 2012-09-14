-module(owl_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) -> 
   def_ontology_cache(),
   case owl_sup:start_link() of
      {ok, Pid} -> {ok, Pid};
      Other     -> {error, Other}
   end. 

stop(_State) ->
        ok.

%%
%% define global status variables
def_ontology_cache() ->
   ets:new(owl, [
      named_table, public, bag,
      {read_concurrency, true}
   ]).