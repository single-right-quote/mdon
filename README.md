# [INCOMPLETE] mdon: basically [madonctl](https://github.com/McKael/madonctl) but with [cURL](https://curl.haxx.se)

in other words, this is a series of scripts for interacting with Mastodon from
the command line. it amounts to a *very* thin wrapper around its REST API; i see
this more as a tool to make playing with Mastodon possible more than a
full-featured client in and of itself  
—the idea being, if you can play with
Mastodon from your shell, you could theoretically write your own client. hint:
[`jq`](http://stedolan.github.io/jq/) (or maybe
[`jp`](https://github.com/jmespath/jp) or [`jj`](https://github.com/tidwall/jj)
or [`jshon`](http://kmkeen.com/jshon/) or
[`json.sh`](https://github.com/dominictarr/JSON.sh) or
[`json.awk`](https://github.com/step-/JSON.awk) or whatever other command line
JSON manipulation thing you like. maybe even use a your preferred scripting
language with JSON parsing libraries of choice.)

here's some example usage:

```
% # rc(1) syntax
% fedi_account=main
%
% # post a status with CW "test" and status text "test post please ignore"
% mdon post -stest -m'test post please ignore'
% # this emits a JSON blob of the posted status if successful
%
% # delete that status
% mdon st -s$status_id_from_above rm
%
% # check notifications
% c mdon nt cat | jq .
```

(i would not recommend actually trying to read notifs this way. either use a
full blown client, or maybe use `madonctl -oplain account notifications --list`,
or maybe just write your own, better JSON to notification-viewer formatter
script thing.)

the subcommands are terse because i find long names irritating to type.

here is an  interesting example:

```
% # rc(1) syntax
% fedi_account=main
% post -r `{post -r `{post -vdirect -stest -m'this is the head' | jq .id} \
	-m'this is the first reply' | jq .id} \
	-m'and this is the second reply'
% # the replies, like the head, will be DMs with no mentions and content warning "test"
```

anyway: why?

i don't like keeping a browser open all the time but i also want to be extremely
queer with friends on the fediverse. having a command line client allows me to
make one-off interactions without having to open a browser, and also write
scripts to do cool things like change my desktop background color when i get
notifications. (the fact that command line usage is well suited to one-off
interactions is, in fact, largely the point.)

`madonctl` is pretty good, but is sometimes verbose to type (hence the short name
of this script), and uses "too much" memory in the sense that you could use less
if you didn't write it in Go. that said, `madonctl` is much better
suited toward reading multiple statuses at once (`-oplain`), and it knows how to
silently make additional HTTP requests to grab more results (say, for the home
timeline) than Mastodon provides by default. also, `madonctl` has websockets,
allowing for proper server-side events (real-time notifications)

note: `mdon` is *not* exactly self-contained; it expects to be able to add a folder
of subscripts to its path (it defaults to looking in `$HOME/bin`), and expects to find other subscripts in its `PATH`, which i’d created for more general purposes, and included in
`./helper_scripts`. the contents of that folder should be made available in your `PATH`.
