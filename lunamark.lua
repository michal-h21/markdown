-- (c) 2009-2011 John MacFarlane.  Released under MIT license.
-- See the file LICENSE in the source for details.

--- Copyright &copy; 2009-2011 John MacFarlane.
--
-- Released under the MIT license (see LICENSE in the source for details).
--
-- ## Description
--
-- Lunamark is a lua library for conversion of markdown to
-- other textual formats. Currently HTML, Docbook, ConTeXt,
-- LaTeX, and Groff man are the supported output formats,
-- but lunamark's modular architecture makes it easy to add
-- writers and modify the markdown parser (written with a PEG
-- grammar).
--
-- Lunamark's markdown parser currently supports the following
-- extensions (which can be turned on or off individually):
--
--   - Smart typography (fancy quotes, dashes, ellipses)
--   - Significant start numbers in ordered lists
--   - Footnotes
--   - Definition lists
--
-- More extensions will be supported in later versions.
--
-- The library is as portable as lua and has very good performance.
-- It is slightly faster than the author's own C library
-- [peg-markdown](http://github.com/jgm/peg-markdown).
--
-- ## Simple usage example
--
--     local lunamark = require("lunamark")
--     local options = { smart = true }
--     local writer = lunamark.writer.html.new(options)
--     local parse = lunamark.reader.markdown.new(writer, options)
--     local result, metadata = parse("Here's 'my *text*'...")
--     print(result)
--     assert(result == 'Here’s ‘my <em>text</em>’…')
--
-- ## Customizing the writer
--
-- Suppose we want emphasized text to be in ALL CAPS,
-- rather than italics:
--
--     local unicode = require("unicode")
--     local utf8 = unicode.utf8
--     function writer.emphasis(s)
--       return utf8.upper(s)
--     end
--     local parse = lunamark.reader.markdown.new(writer, options)
--     local result, metadata = parse("*Beiß* nicht in die Hand, die dich *füttert*.")
--     print(result)
--     assert(result == 'BEIß nicht in die Hand, die dich FÜTTERT.')
--
-- ## Customizing the parser
--
-- Suppose we want to make CamelCase words into wikilinks:
--
--     lpeg = require("lpeg")
--     function add_wikilinks(syntax)
--       local capword = lpeg.R("AZ")^1 * lpeg.R("az")^1
--       local parse_wikilink = lpeg.C(capword^2)
--                            / function(wikipage)
--                                return writer.link(writer.string(wikipage),
--                                                   "/" .. wikipage,
--                                                   "Go to " .. wikipage)
--                              end
--       syntax.Inline = parse_wikilink + syntax.Inline
--       return syntax
--     end
--     local parse = lunamark.reader.markdown.new(writer, { alter_syntax = add_wikilinks })
--     local result, metadata = parse("My text with WikiLinks.\n")
--     print(result)
--     assert(result == 'My text with <a href="/WikiLinks" title="Go to WikiLinks">WikiLinks</a>.')

local G = {}

setmetatable(G,{ __index = function(t,name)
                             local mod = require("lunamark." .. name)
                             rawset(t,name,mod)
                             return t[name]
                            end })

return G
