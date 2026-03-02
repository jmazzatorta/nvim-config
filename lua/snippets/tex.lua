-- LaTeX snippets for LuaSnip
-- Place this file in: ~/.config/nvim/lua/snippets/tex.lua
-- Then require it from your config (see bottom of file)

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
    -- === DOCUMENT ===

    s("doc", fmt([[
\documentclass[{}]{{{}}}
\usepackage[utf8]{{inputenc}}
\usepackage{{amsmath, amssymb}}
\usepackage{{geometry}}
\usepackage{{pgfplots}}
\pgfplotsset{{compat=1.18}}

\title{{{}}}
\author{{{}}}
\date{{\today}}

\begin{{document}}
\maketitle

{}

\end{{document}}
]], { i(1, "a4paper,12pt"), i(2, "article"), i(3, "Title"), i(4, "Author"), i(0) })),

    s("min", fmt([[
\documentclass{{article}}
\begin{{document}}
{}
\end{{document}}
]], { i(0) })),

    -- === ENVIRONMENTS ===

    s("beg", fmt([[
\begin{{{}}}
    {}
\end{{{}}}
]], { i(1, "env"), i(0), rep(1) })),

    s("eq", fmt([[
\begin{{equation}}
    {}
\end{{equation}}
]], { i(0) })),

    s("eq*", fmt([[
\begin{{equation*}}
    {}
\end{{equation*}}
]], { i(0) })),

    s("al", fmt([[
\begin{{align}}
    {} &= {} \\
    {}
\end{{align}}
]], { i(1), i(2), i(0) })),

    s("it", fmt([[
\begin{{itemize}}
    \item {}
\end{{itemize}}
]], { i(0) })),

    s("en", fmt([[
\begin{{enumerate}}
    \item {}
\end{{enumerate}}
]], { i(0) })),

    -- === MATH ===

    s("fr", fmt([[\frac{{{}}}{{{}}}]], { i(1), i(2) })),
    s("sq", fmt([[\sqrt{{{}}}]], { i(1) })),
    s("sum", fmt([[\sum_{{{}}}^{{{}}} {}]], { i(1, "i=1"), i(2, "n"), i(0) })),
    s("int", fmt([[\int_{{{}}}^{{{}}} {} \, d{}]], { i(1, "a"), i(2, "b"), i(3, "f(x)"), i(4, "x") })),
    s("lim", fmt([[\lim_{{{}}} {}]], { i(1, "n \\to \\infty"), i(0) })),
    s("inf", t("\\infty")),
    s("lrp", fmt([[\left( {} \right)]], { i(0) })),
    s("lrb", fmt("\\left[ {} \\right]", { i(0) })),
    s("lrc", fmt("\\left\\{{ {} \\right\\}}", { i(0) })),
    s("vec", fmt([[\vec{{{}}}]], { i(1) })),
    s("hat", fmt([[\hat{{{}}}]], { i(1) })),
    s("bar", fmt([[\bar{{{}}}]], { i(1) })),
    s("dot", fmt([[\dot{{{}}}]], { i(1) })),
    s("mat", fmt([[
\begin{{pmatrix}}
    {} & {} \\
    {} & {}
\end{{pmatrix}}
]], { i(1), i(2), i(3), i(4) })),

    -- === FIGURES & TABLES ===

    s("fig", fmt([[
\begin{{figure}}[{}]
    \centering
    \includegraphics[width={}]{{{}}}
    \caption{{{}}}
    \label{{fig:{}}}
\end{{figure}}
]], { i(1, "htbp"), i(2, "0.8\\textwidth"), i(3, "path"), i(4, "caption"), i(5, "label") })),

    s("tab", fmt([[
\begin{{table}}[{}]
    \centering
    \begin{{tabular}}{{{}}}
        \hline
        {} \\
        \hline
        {} \\
        \hline
    \end{{tabular}}
    \caption{{{}}}
    \label{{tab:{}}}
\end{{table}}
]], { i(1, "htbp"), i(2, "c c c"), i(3, "H1 & H2 & H3"), i(4, "a & b & c"), i(5, "caption"), i(6, "label") })),

    -- === PGFPLOTS ===

    s("plot", fmt([[
\begin{{figure}}[htbp]
    \centering
    \begin{{tikzpicture}}
        \begin{{axis}}[
            title={{{}}},
            xlabel={{{}}},
            ylabel={{{}}},
            grid=major,
        ]
        \addplot {{{}}} ;
        \end{{axis}}
    \end{{tikzpicture}}
    \caption{{{}}}
\end{{figure}}
]], { i(1, "Title"), i(2, "x"), i(3, "y"), i(4, "x^2"), i(5, "caption") })),

    s("plotdata", fmt([[
\begin{{figure}}[htbp]
    \centering
    \begin{{tikzpicture}}
        \begin{{axis}}[
            title={{{}}},
            xlabel={{{}}},
            ylabel={{{}}},
            grid=major,
        ]
        \addplot table [col sep=comma] {{{}}};
        \end{{axis}}
    \end{{tikzpicture}}
    \caption{{{}}}
\end{{figure}}
]], { i(1, "Title"), i(2, "x"), i(3, "y"), i(4, "data.csv"), i(5, "caption") })),

    -- === SECTIONS ===

    s("sec", fmt([[\section{{{}}}]], { i(1) })),
    s("ssec", fmt([[\subsection{{{}}}]], { i(1) })),
    s("sssec", fmt([[\subsubsection{{{}}}]], { i(1) })),

    -- === REFERENCES ===

    s("ref", fmt([[\ref{{{}}}]], { i(1) })),
    s("eqref", fmt([[\eqref{{{}}}]], { i(1) })),
    s("cite", fmt([[\cite{{{}}}]], { i(1) })),
    s("lab", fmt([[\label{{{}}}]], { i(1) })),

    -- === PACKAGES (quick add) ===

    s("pkg", fmt([[\usepackage{{{}}}]], { i(1) })),
    s("pkgo", fmt([[\usepackage[{}]{{{}}}]], { i(1, "options"), i(2, "package") })),
}
