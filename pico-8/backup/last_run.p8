pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
poo=1
pee=1
col=1
butt="♥"
awesome=true

function _init()
end

function _update()
 poo=poo+1
 pee=pee+1     
 col=col+1
end

function _draw()
  cls()
  print(butt,poo,pee,col)
end
  

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
