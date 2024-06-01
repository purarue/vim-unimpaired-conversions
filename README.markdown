This removes most of the plugin functionality, just keeping the `[]u` (url
encoding/decoding), `[]C` (C-style string escaping), `[]x` (XML/HTML
encoding/decoding) functionality. It maps those to the same keys as before.

Those are the only mappings that I used from unimpaired which had no obvious
replacement in Lua (as they're custom logic using a bunch of
`substitute`/pattern-replace calls).

To get nicer [`which-key`](https://github.com/folke/which-key.nvim)
descriptions, I put the following in my `key_mappings.lua` file:

```lua
local visualMaps = {
    ["[u"] = "url encode",
    ["[x"] = "xml encode",
    ["[y"] = "c-string encode",
    ["[C"] = "c-string-encode",
    ["]u"] = "url decode",
    ["]x"] = "xml decode",
    ["]y"] = "c-string decode",
    ["]C"] = "c-string-decode"

}
wk.register(visualMaps, {mode = "v"})

local normalMaps = vim.tbl_extend("keep", visualMaps, {
    ["[uu"] = "url encode line",
    ["[xx"] = "xml encode line",
    ["[yy"] = "c-string encode line",
    ["[CC"] = "c-string-encode line",
    ["]uu"] = "url decode line",
    ["]xx"] = "xml decode line",
    ["]yy"] = "c-string decode line",
    ["]CC"] = "c-string-decode line"
})
wk.register(normalMaps, {mode = "n"})
```

These `register` calls does not actually bind anything, it just gives it
nicer descriptions. The keys are mapped by the vimscript plugin, like normal

Then, for example to load with [`lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
    "seanbreckenridge/vim-unimpaired-conversions",
    keys = {"[", "]"} -- only load plugin when I press '[' or ']'
}
```

---

# unimpaired.vim

Much of unimpaired.vim was extracted from my vimrc when I noticed a
pattern: complementary pairs of mappings.  They mostly fall into four
categories.

There are mappings which are simply short normal mode aliases for
commonly used ex commands. `]q` is :cnext. `[q` is :cprevious. `]a` is
:next.  `[b` is :bprevious.  See the documentation for the full set of
20 mappings and mnemonics.  All of them take a count.

There are linewise mappings. `[<Space>` and `]<Space>` add newlines
before and after the cursor line. `[e` and `]e` exchange the current
line with the one above or below it.

There are mappings for toggling options. `[os`, `]os`, and `yos` perform
`:set spell`, `:set nospell`, and `:set invspell`, respectively.  There's also
`l` (`list`), `n` (`number`), `w` (`wrap`), `x` (`cursorline cursorcolumn`),
and several others, plus mappings to help alleviate the `set paste` dance.
Consult the documentation.

There are mappings for encoding and decoding. `[x` and `]x` encode and
decode XML (and HTML). `[u` and `]u` encode and decode URLs. `[y` and
`]y` do C String style escaping.

And in the miscellaneous category, there's `[f` and `]f` to go to the
next/previous file in the directory, and `[n` and `]n` to jump between
SCM conflict markers.

The `.` command works with all operator mappings, and will work with the
linewise mappings as well if you install
[repeat.vim](https://github.com/tpope/vim-repeat).

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/unimpaired.git
    vim -u NONE -c "helptags unimpaired/doc" -c q

## FAQ

> My non-US keyboard makes it hard to type `[` and `]`.  Can I configure
> different prefix characters?

The easiest solution is to map to `[` and `]` directly:

    nmap < [
    nmap > ]
    omap < [
    omap > ]
    xmap < [
    xmap > ]

Note we're not using the `noremap` family because we *do* want to recursively
invoke unimpaired.vim's maps.

## Contributing

See the contribution guidelines for
[pathogen.vim](https://github.com/tpope/vim-pathogen#readme).

## Self-Promotion

Like unimpaired.vim? Follow the repository on
[GitHub](https://github.com/tpope/vim-unimpaired) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=1590).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

## License

Copyright (c) Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
