; 左のAltキーとwinがデフォルトで反対なので、入れ替え ;
#ifwinnotactive ahk_class FFXIVGAME

;sc15B::sc038
;sc038::sc15B

Ins::Del

sc03A & 1::F1
sc03A & 2::F2
sc03A & 3::F3
sc03A & 4::F4
sc03A & 5::F5
sc03A & 6::F6
sc03A & 7::F7
sc03A & 8::F8
sc03A & 9::F9
sc03A & 0::F10
sc03A & -::F11
sc03A & =::F12


;ctrlショートカットキー
sc03A & a::^a
sc03A & b::^b
sc03A & c::^c
sc03A & d::^d
;sc03A & e::^e
sc03A & f::^f
;sc03A & g::^g
sc03A & h::^h
sc03A & i::^i

;sc03A & j::^j
sc03A & j::
 return
;無効
;sc03A & k::^k

sc03A & l::^l
sc03A & m::^m
sc03A & n::^n
sc03A & o::^o
sc03A & p::^p
sc03A & q::!F4
sc03A & r::^r
sc03A & s::^s
sc03A & t::^t
sc03A & u::^u
sc03A & v::^v
sc03A & w::^w
sc03A & x::^x
sc03A & y::^y
sc03A & z::^z

;;fenrir
sc03A & sc027::^sc027

;;sc039=space
sc03A & sc039::vkF3

#ifwinnotactive
