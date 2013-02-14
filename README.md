# Crisco

## The Story

I'm a big fan of [Tapbot's](http://tapbots.com/) Twitter client
[Tweetbot](http://tapbots.com/software/tweetbot/) because it gives me a
consistent Twitter experience across my electronic devices.  As I was
investigating the various settings in the application, I noticed that
the URL Shortening service had a selection for a custom shortening
endpoint that meets [these](http://tapbots.net/tweetbot/custom_url/)
specifications.

So, I decided to whip up a little Rails application so that I can run my
own URL shortening service, and thus crisco was born.  It runs easily on
for free on [Heroku](http://heroku.com).  

You will need to set the CRISCO_SECRET environment variable.

Crisco uses the indispensable
[devise](https://github.com/plataformatec/devise) authentication
library, and it should be multi-user ready, though I have only used it
in a single user enviroment.  Feel free to expand on that if you have a
need for it, I would be happy to get pull requests to make crisco a
better piece of software.

## The Details

[I](http://ndfine.com) have released crisco under the
[zlib/libpng](http://opensource.org/licenses/zlib-license.php) license,
so go nuts.



