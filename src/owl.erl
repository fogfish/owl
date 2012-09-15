%%
%%   @description
%%      Manages configuration in form of triples <s, p, o>
%%      <s>, <p> are nodes, <o> either node or literal
%%      node is atom() | {atom(), binary()} 
-module(owl).

-export([add/1, get/1, has/1, like/1, find/1, prefix/2, import/1]).


%-type node()    :: atom() | binary() | {atom(), binary()}.
%-type literal() :: any().
%-type triple()  :: {node(), node(), node() | literal()}.

%%
%%
add({S, P, O}) ->
   true = ets:insert(owl, {owl_node(S), owl_node(P), owl_val(O)}),
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
owl_node(X) ->
   case maybe_ns_node(X) of
      {node, Node} -> Node;
      Node when is_atom(Node)   -> Node;
      Node when is_binary(Node) -> Node
   end.

%%
%%
owl_val(X) ->
   case maybe_ns_node(X) of
      {node, Node} -> Node;
      Node -> Node
   end.

%%
%%
maybe_ns_node({Ns, Node})
 when is_atom(Ns), is_binary(Node) ->
   [[Uri]] = owl:find({prefix, Ns, '$1'}),
   {node, <<Uri/binary, Node/binary>>};

maybe_ns_node(X) ->
   X.






