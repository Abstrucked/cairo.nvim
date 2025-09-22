" Vim syntax file for Cairo

if exists("b:current_syntax")

  finish

endif

" Keywords

syn keyword cairoKeyword fn let mod use struct enum impl trait type pub const mut ref

syn keyword cairoConditional if else match

syn keyword cairoRepeat loop while for

syn keyword cairoOperator as

syn keyword cairoType u8 u16 u32 u64 u128 u256 usize felt252 bool

syn keyword cairoBoolean true false

syn keyword cairoStatement return break continue

" Comments

syn region cairoCommentLine start="//" end="$" contains=cairoTodo

syn region cairoCommentBlock start="/\*" end="\*/" contains=cairoTodo

syn keyword cairoTodo contained TODO FIXME XXX

" Strings

syn region cairoString start='"' end='"'

syn region cairoString start="'" end="'"

" Numbers

syn match cairoNumber "\<\d\+\>"

syn match cairoNumber "\<\d\+\.\d*\>"

" Functions

syn match cairoFunction "\<\h\w*\>(\@="

" Operators

syn match cairoOperator "[=!<>+\-\*\/%&|~^:;,{}()\[\]]"

" Set highlights

hi def link cairoKeyword Keyword

hi def link cairoConditional Conditional

hi def link cairoRepeat Repeat

hi def link cairoOperator Operator

hi def link cairoType Type

hi def link cairoBoolean Boolean

hi def link cairoStatement Statement

hi def link cairoCommentLine Comment

hi def link cairoCommentBlock Comment

hi def link cairoTodo Todo

hi def link cairoString String

hi def link cairoNumber Number

hi def link cairoFunction Function

let b:current_syntax = "cairo"

