pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--goals
-- 4. levels
-- 5. diffrent bricks
-- 6. (powerups)
-- 7. juicyness 
--     arrow anim
--     text blinking
--     particles
--     screenshake
-- 8. high score

function _init()
 cls()
 mode="start"
 level="bxbxbxbx"
 debug=""
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
 buildbricks(level)
 --brick_y=20

 lives=3
 points=0
 
 sticky=true
  
 chain=1 
  
 serveball()
end

function buildbricks(lvl)
 local i,j,chr,last
 brick_x={}
 brick_y={}
 brick_v={}
 
 sub(str,start,ending)
 j=0
 --brick_x={5,16,27,38,49,60,71,82,93,104,115}
 for i=1,#lvl do
  j+=1
  chr=sub(lvl,i,i)
  if chr=="b" then
   last="b"
	  add(brick_x,4+((j-1)%11)*(brick_w+2))
	  add(brick_y,20+flr((j-1)/11)*(brick_h+2))
	  add(brick_v,true)
	 elseif chr=="x" then
	  last="x"
	 elseif chr=="/" then
	  j=(flr((j-1)/11)+1)*11
	 elseif chr>="0" and chr<="9" then 
	  for o=1,chr+0 do
	   if last=="b" then
	   	add(brick_x,4+((j-1)%11)*(brick_w+2))
	    add(brick_y,20+flr((j-1)/11)*(brick_h+2))
	    add(brick_v,true)
	   elseif last=="x" then
	   
	   end
	   j+=1
	  end
	  j-=1
	 end
 end 
end

function serveball()
 ball_x=pad_x+flr(pad_w/2)
 ball_y=pad_y-ball_r
 ball_dx=1
 ball_dy=-1
 ball_ang=1
 
 sticky=true
 chain=1
 --0.50
 --1.30
end

function setang(ang)
 ball_ang=ang
 if ang==2 then
  ball_dx=0.50*sign(ball_dx)
  ball_dy=1.30*sign(ball_dy)  
 elseif ang==0 then
  ball_dx=1.30*sign(ball_dx)
  ball_dy=0.50*sign(ball_dy) 
 else
  ball_dx=1*sign(ball_dx)
  ball_dy=1*sign(ball_dy)
 end
end

function sign(n)
 if n<0 then
  return -1
 elseif n>0 then
  return 1
 else
  return 0
 end
end

function gameover()
 mode="gameover"
end

function update_gameover()
 if btn(4) then
  startgame()
 end 
end

function update_game()
 local buttpress=false
 local nextx,nexty,brickhit
 
 if btn(0) then
  --left
  pad_dx=-2.5
  buttpress=true
  --pad_x-=5
  if sticky then
   ball_dx=-1
  end
 end
 if btn(1) then
  --right
  pad_dx=2.5
  buttpress=true
  --pad_x+=5 
  if sticky then
   ball_dx=1
  end
 end
 if sticky and btn(4) then
  sticky=false
 end
 
 if not(buttpress) then
  pad_dx=pad_dx/1.3
 end
 pad_x+=pad_dx
 pad_x=mid(0,pad_x,127-pad_w)
 
 if sticky then
  ball_x=pad_x+flr(pad_w/2)
  ball_y=pad_y-ball_r-1
 else
  --regular ball physics
  nextx=ball_x+ball_dx
  nexty=ball_y+ball_dy

  if nextx > 124 or nextx < 3 then
   nextx=mid(0,nextx,127)
   ball_dx = -ball_dx
   sfx(0)
  end
  if nexty < 10 then
   nexty=mid(0,nexty,127) 
   ball_dy = -ball_dy
   sfx(0)
  end
 
  -- check if ball hit pad
  if ball_box(nextx,nexty,pad_x,pad_y,pad_w,pad_h) then
   -- deal with collision
   if deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,pad_x,pad_y,pad_w,pad_h) then
    --ball hit paddle on the side
    ball_dx = -ball_dx
    if ball_x < pad_x+pad_w/2 then
     nextx=pad_x-ball_r
    else
     nextx=pad_x+pad_w+ball_r
    end
   else
    --ball hit paddle on the top/bottom
    ball_dy = -ball_dy
    if ball_y > pad_y then
     --bottom
     nexty=pad_y+pad_h+ball_r
    else
     --top
     nexty=pad_y-ball_r
     if abs(pad_dx)>2 then
      --change angle
      if sign(pad_dx)==sign(ball_dx) then
       --flatten angle
       setang(mid(0,ball_ang-1,2))
      else
       --raise angle
       if ball_ang==2 then
        ball_dx=-ball_dx
       else
        setang(mid(0,ball_ang+1,2))
       end
      end
     end
    end
   end
   sfx(1)
   chain=1
  end

  brickhit=false
  for i=1,#brick_x do
   -- check if ball hit brick
   if brick_v[i] and ball_box(nextx,nexty,brick_x[i],brick_y[i],brick_w,brick_h) then
    -- deal with collision
    if not(brickhit) then
     if deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,brick_x[i],brick_y[i],brick_w,brick_h) then
      ball_dx = -ball_dx
     else
      ball_dy = -ball_dy
     end
    end
    brickhit=true
    sfx(2+chain)
    brick_v[i]=false
    points+=10*chain
    chain+=1
    chain=mid(1,chain,7)
   end
  end
  ball_x=nextx
  ball_y=nexty
 
  if nexty > 127 then
   sfx(2)
   lives-=1
   if lives<0 then
    gameover()
   else
    serveball()
   end
  end
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
 print("press ❎ to start",32,80,11)
end

function draw_gameover()
 --cls()
 rectfill(0,60,128,75,0)
 print("game over",46,62,7)
 print("press ヌ█⬆️ to restart",27,68,6)
end

function draw_game()
 local i
 
 cls(1)
 circfill(ball_x,ball_y,ball_r, 10)
 if sticky then
  -- serve preview
  line(ball_x+ball_dx*4,ball_y+ball_dy*4,ball_x+ball_dx*6,ball_y+ball_dy*6,10)
 end
 
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
 
 --draw bricks
 for i=1,#brick_x do
  if brick_v[i] then
   rectfill(brick_x[i],brick_y[i],brick_x[i]+brick_w,brick_y[i]+brick_h,14)
  end
 end 
 
 rectfill(0,0,128,6,0)
 if debug!="" then
  print(debug,1,6)
 else
  print("lives:"..lives,1,1,7)
  print("score:"..points,40,1,7)
  print("chain:"..chain,100,1,7)
 end 
end

function ball_box(bx,by,box_x,box_y,box_w,box_h)
 -- checks for a collion of the ball with a rectangle
 if by-ball_r > box_y+box_h then return false end
 if by+ball_r < box_y then return false end
 if bx-ball_r > box_x+box_w then return false end
 if bx+ball_r < box_x then return false end
 return true
end

function deflx_ball_box(bx,by,bdx,bdy,tx,ty,tw,th)
	local slp = bdy / bdx
	local cx, cy
	if bdx == 0 then
		return false
	elseif bdy == 0 then
		return true
	elseif slp > 0 and bdx > 0 then
		cx = tx - bx
		cy = ty - by
		return cx > 0 and cy/cx < slp
	elseif slp < 0 and bdx > 0 then
		cx = tx - bx
		cy = ty + th - by
		return cx > 0 and cy/cx >= slp
	elseif slp > 0 and bdx < 0 then
		cx = tx + tw - bx
		cy = ty + th - by
		return cx < 0 and cy/cx <= slp
	else
		cx = tx + tw - bx
		cy = ty - by
		return cx < 0 and cy/cx >= slp
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bb00bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bb00bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001d3501d3501d3501d3501d3501d3501d35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100002935029350293402933029320293102935000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000264501f45017450124500b450084500645003450024500045001450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002b3502c3502e3502f35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000303502f3502f3503335000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003235031350303503435000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003335033350323503535000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003435034350343503635000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003635035350363503835000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003635036350373503935000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
