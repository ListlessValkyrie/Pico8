pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
	cls()
	
	frame=0	
	col=0	

 mode="start"
end

function _update60()
 if mode=="game" then
  update_game()
 elseif mode=="start" then
  update_start()
 elseif mode=="gameover" then
  update_gameover()
 end
end

function _draw()

 if mode=="game" then
  draw_game()
 elseif mode=="start" then
  draw_start()
 elseif mode=="gameover" then
  draw_gameover()
 end
end

function draw_start()
 cls()
 print("pico hero breakout",30,40,7)
 print("press ❎ to start",30,80,11)
end

function draw_gameover()
 --cls()
 rectfill(0,60,128,75,0)
 print("game over",46,62,7)
 print("press ❎ to restart",27,68,7)
end

function update_start()
 if btn(4) then
  startgame()
 end
end

function startgame()
 mode="game"
	ball_r=2
	ball_dr=0.5
	
	pad_x=52
	pad_y=120
	pad_dx=0
	pad_w=24
	pad_h=3
	pad_c=7


 brick_w=9
 brick_h=4
 buildbricks()
	
	lives=3
	points=0	
	
	serveball()
end

function buildbricks()
 local i
 
 brick_x={}
 brick_y={}
 brick_v={}

 for i=1,66 do
  add(brick_x,4+((i-1)%11)*(brick_w+2))
  add(brick_y,20+flr((i-1)/11)*(brick_h+2))
  add(brick_v,true)
 end

end

function serveball()
 ball_x=5
 ball_y=60
	ball_dx=1
	ball_dy=-1
end


function gameover()
 mode="gameover"
end

function update_gameover()
  if btn(4) then
  startgame()
 end
end

function draw_game()
 cls(1)
 circfill(ball_x,ball_y,ball_r,10)
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)

 --draw bricks
 for i=1,#brick_x do
  if brick_v[i] then
   rectfill(brick_x[i],brick_y[i],brick_x[i]+brick_w,brick_y[i]+brick_h,12)
  end
 end
 


 rectfill(0,0,128,6,0)
 print("lives:"..lives,1 ,1,7)
 print("score:"..points,40,1,7)
end

function update_game()
 local buttpress=false
 local nextx
 local nexty 
 
 if btn(0) then
   --left
   pad_dx=-2.5
   butpress=true
 end
 if btn(1) then
   --right
   pad_dx=2.5
   buttpress=true
 end
 
 if not(buttpress) then
   pad_dx=pad_dx/1.3
 end

 pad_x+=pad_dx
 pad_x=mid(0,pad_x,127-pad_w) 
 -- frame=frame+1



 --ball_r=2+(sin(frame/10)*2)
 col=col+1
 
 nextx = ball_x+ball_dx
	nexty = ball_y-ball_dy
 
 if nextx >124 or nextx < 3 then
  nextx=mid(0,nextx,127)
  ball_dx = -ball_dx
  sfx(0)
 end
 
 if nexty < 10 then
  nexty=mid(0,nexty,127)
  ball_dy = -ball_dy
  sfx(0) 
 end
 
 pad_c=7
 -- check if ball hit pad
 if ball_box(nextx,nexty,pad_x,pad_y,pad_w,pad_h) then
  -- deal with collision 
  if deflx_ballbox(ball_x,ball_y,ball_dx,ball_dy,pad_x,pad_y,pad_w,pad_h) then
   ball_dx = -ball_dx
  else  
   ball_dy = -ball_dy
  end
  sfx(1) 
  points+=1
 end
 
 brickhit=false 
 for i=1,#brick_x do
  -- check if ball hit brick
	 if brick_v[i] and ball_box(nextx,nexty,brick_x[i],brick_y[i],brick_w,brick_h) then
	  -- deal with collision 
	  if not(brickhit) then
		  if deflx_ballbox(ball_x,ball_y,ball_dx,ball_dy,brick_x[i],brick_y[i],brick_w,brick_h) then
		   ball_dx = -ball_dx
		  else  
		   ball_dy = -ball_dy
		  end
		 end
	  brickhit=true
	  sfx(3) 
	  brick_v[i]=false
	  points+=10
	 end
	end
 
 --if ball_r >3 or ball_r < 2 then
 -- ball_dr=-ball_dr
 --end
 
 ball_x=nextx
	ball_y=nexty
	
	if nexty >127 then
  sfx(2) 
  lives-=1
  if lives < 0 then
   gameover()
  else
   serveball()
  end
 end
 
end

function ball_box(bx,by,box_x,box_y,box_w,box_h)
 if by-ball_r > box_y+box_h then   
  return false
 end 
 if by+ball_r < box_y then   
  return false
 end
 if bx-ball_r > box_x+box_w then   
  return false
 end 
 if bx+ball_r < box_x then   
  return false
 end
  
 return true
end

function deflx_ballbox(bx,by,bdx,bdy,tx,ty,tw,th)
 local slp = bdy / bdx
 local cx, cy

 -- calculate wether to deflect the ball
 -- horizontally or vertically when it hits a box
 if bdx == 0 then
  -- moving vertically
  return false
 elseif bdy == 0 then
  -- moving horizontally
  return true
 elseif slp > 0 and bdx > 0 then
  cx = tx-bx
  cy = ty-by
  return cx > 0 and cy/cx < slp
 elseif slp < 0 and bdx > 0 then
  cx = tx-bx
  cy = ty+th-by
  return cx > 0 and cy/cx >= slp   
 elseif slp > 0 and bdx < 0 then
  cx = tx+tw-bx
  cy = ty+th-by
  return cx<0 and cy/cx <= slp
 else
  cx = tx+tw-bx
  cy = ty-by
  return cx < 0 and cy/cx >= slp
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001d3501d3501d3501d3501d3501d3501d35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100002935029350293402933029320293102935000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000264501f45017450124500b450084500645003450024500045001450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003000038350333501f3501535002350013500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
