-module(owl).

-export([add/1, get/1, has/1, like/1, find/1, prefix/2, import/1]).


%%
%%
add({S, P, O}) ->
   true = ets:insert(owl, {owl_node(S), owl_node(P), owl_node(O)}),
   ok;
add(List) ->
   lists:foreach(fun add/1, List).

%%
%%
get(S) ->
   ets:lookup(owl, S).

%%
%%
has(Pat) ->
   case like(Pat) of
      [Pat] -> true;
      _     -> false
   end.

%%
%%
like(Pat) ->
   ets:match_object(owl, Pat).

%%
%%
find(Pat) ->
   ets:match(owl, Pat).

%%
%%
prefix(Local, Ns)
 when is_atom(Local), is_binary(Ns) ->
   ets:insert(owl, {prefix, Local, Ns}).

%%
%%
import(File) ->
   {ok, List} = file:consult(File),
   lists:foreach(fun add/1, List).

%%
%%
owl_node({Ns, Node})
 when is_atom(Ns), is_atom(Node) ->
   [[Uri]] = owl:find({prefix, Ns, '$1'}),
   <<Uri/binary, (atom_to_binary(Node, utf8))/binary>>;

owl_node({Ns, Node})
 when is_atom(Ns), is_binary(Node) ->
   [[Uri]] = owl:find({prefix, Ns, '$1'}),
   <<Uri/binary, Node/binary>>;

owl_node(X)
 when is_atom(X) ->
   X;

owl_node(X)
 when is_binary(X) ->
   X;

owl_node(X)
 when is_integer(X) ->
   X;

owl_node(_) ->
   throw(badarg).


