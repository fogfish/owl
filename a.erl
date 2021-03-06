-module(a).
-compile({parse_transform, category}).

-export([example/0]).

example() ->
   [m_http ||
      _ > "GET http://httpbin.org/json",
      _ > "Accept: application/json",

      _ < 200,
      _ < "Content-Type: application/json",
      _ < lens:c(lens:at(<<"slideshow">>), lens:at(<<"title">>), lens:defined()),
      _ < lens:c(lens:at(<<"slideshow">>), lens:at(<<"slides">>))
   ].

