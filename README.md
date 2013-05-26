# `run_tags` by Toby Crawley (@tobias)

## Original code

https://gist.github.com/tobias/42308

## Reason for forking

I'm a Vim user (other text editors are available) and
[Ctags](http://ctags.sourceforge.net/) isn't installed at
`/opt/local/bin/ctags` on any of my machines.

## Configuration

The following options are now configurable via
[`${HOME}/.run_tags.yml`](https://github.com/johnsyweb/run_tags/blob/master/.run_tags.yml):

 - `ctags_flags` (default `-e`)
 - `ctags` (default: result of `which ctags`)
 - `debug` (default: `false`)
 - `hooks_file` (default: `.git/hooks`)
 - `hooks` (default: `post-merge`, `post-commit`, `post-checkout`)
 - `tags_file` (default: `TAGS`)

## Contributing

Your contributions are welcome

1. Fork it
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

## Thanks

If you find this stuff useful, please follow this repository on
[GitHub](https://github.com/johnsyweb/run_tags). If you have something to say,
you can contact [johnsyweb](http://johnsy.com/about/) on
[Twitter](http://twitter.com/johnsyweb/) and
[GitHub](https://github.com/johnsyweb/).

