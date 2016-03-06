-module(afile_server).
-export([start/1,loop/1]).
start(Dir)->spawn(afile_server, loop, [Dir]).
loop(Dir)->
  receive
    {Client, list_dir}->
      Client!{self(), file:list_dir(Dir)};
    {Client, {get_file, File}}->
      Full=filename:join(Dir, File),
      Client!{self(), file:read_file(full)};
    {Client, {put_file, File}}->
      NewFileName="new.txt",
      NewFull=filename::join(Dir, NewFileName),
      Origion=filename::join(Dir, File),
      {ok,binary}=file:read_file(Origion),
      {ok,S}=file:open(NewFull,[raw,write,binary]),
      Client!{self(), file:pwrite(S,0,Binary)}
  end,
  loop(Dir)
