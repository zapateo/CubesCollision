-- Gianluca Mondini - Cubes Collision

function set_force()
   for i=1, 4 do
      set.now_force[i] = set.force[i]
   end
end

function print_help()
   local text = "F5 show/hide stars\n"
   text=text.."F6 disable cubes rotation\n"
   text=text.."F7 show/hide help message\n"
   text=text.."F12 reset game\n"
   love.graphics.setColor(200,200,200,200)
   love.graphics.print(text, 100, 100)
end

function draw_stars(number)
   for i=1, number, 1 do
      local x = math.floor(math.random( )*width)
      local y = math.floor(math.random( )*height)
      local star_size = math.floor(math.random( )*4)
      love.graphics.setColor(255,255,255,150)
      love.graphics.circle( "fill", x, y, star_size )
   end
end

function reset()
   print(set.force[1])
   for p=1, #objects.player do
      local player = objects.player[p]
      player.body:setPosition( --> reset player position
      player.pos[1] * 0.01 * window_width,
      player.pos[2] * 0.01 * window_height
   )
   player.body:setLinearVelocity(0,0)
   player.body:setAngularVelocity(set.angular_velocity)
   set_force( )
   player.lose = ""
end
end

function love.load()
   set = {} --> a table containing settings
   require("options.lua")

   set.now_force = {}
   for i=1, 4 do
      set.now_force[i] = set.force[i]
   end
   love.physics.setMeter(64)
   world = love.physics.newWorld(set.gravity[1], set.gravity[2], true)
   objects = {}
   objects.player = set.players

   love.graphics.setBackgroundColor(set.background)
   width, height = love.window.getDesktopDimensions(1)
   window_width  = width - set.margin[1]
   window_height = height - set.margin[2]
   love.window.setMode(window_width, window_height)

   for p=1, #objects.player, 1 do
      local player = objects.player[p]
      player.body = love.physics.newBody(
      world,
      player.pos[1]*0.01*window_width,
      player.pos[2]*0.01*window_height,
      "dynamic"
   )
   player.body:setAngularVelocity( set.angular_velocity )
   player.lose = ""
   if player.shape.shape == "rect" then
      player.shape = love.physics.newRectangleShape(0,0,set.rectangle[1],set.rectangle[2])
   end
   player.fixture = love.physics.newFixture(player.body, player.shape, 5)
end
end

function love.draw()

   if set.stars then
      draw_stars(set.stars_number)
   end

   for p=1, #objects.player, 1 do
      love.graphics.setColor(
      objects.player[p].color[1],
      objects.player[p].color[2],
      objects.player[p].color[3]
   )
   love.graphics.polygon("fill", objects.player[p].body:getWorldPoints(objects.player[p].shape:getPoints()))

   local info = {} --> infos about current player
   info.pos = {}
   info.pos.x, info.pos.y = objects.player[p].body:getWorldCenter()
   if info.pos.x > window_width  or info.pos.x < 0  or info.pos.y > window_height or info.pos.y < 0 then
      if objects.player[p].lose == "" then
         local death_time = love.timer.getTime( )
         objects.player[p].lose = " ha perso a "..death_time
      end
   end

   info.pos.x, info.pos.y = math.floor(info.pos.x), math.floor(info.pos.y)
   info.name = objects.player[p].name
   info.lose = objects.player[p].lose
   info.keys = ""

   for k=1, 4, 1 do
      info.keys = info.keys.." "..string.upper(objects.player[p].keys[k])
   end

   love.graphics.print(
   info.name.."\t\tPos: "..info.pos.x..", "..info.pos.y.." ("..info.keys.." )"..info.lose,
   0, 12*(p-1)
)
end
love.graphics.setColor(255,255,255)
love.graphics.print("Gravity: "..set.gravity[1]..", "..set.gravity[2], 0, #objects.player*12)
love.graphics.print("Force:   "..math.floor(set.now_force[1])..", "..math.floor(set.now_force[2])..", "..math.floor(set.now_force[3])..", "..math.floor(set.now_force[4]), 0, (#objects.player+1)*12)
if set.stars then
   love.graphics.print("Stars:   "..set.stars_number, 0, (#objects.player+2)*12)
end

if set.help then
   print_help( )
end

love.graphics.print("Mondini Gianluca - 2014", window_width-170, window_height-15)
end

function love.update(dt)
   world:update(dt)

   for p = 1, #objects.player, 1 do
      if love.keyboard.isDown(objects.player[p].keys[1]) then objects.player[p].body:applyForce(0, -set.now_force[1]) end
      if love.keyboard.isDown(objects.player[p].keys[2]) then objects.player[p].body:applyForce(0, set.now_force[2]) end
      if love.keyboard.isDown(objects.player[p].keys[3]) then objects.player[p].body:applyForce(set.now_force[3], 0) end
      if love.keyboard.isDown(objects.player[p].keys[4]) then objects.player[p].body:applyForce(-set.now_force[4], 0) end
   end

   if love.keyboard.isDown( "escape" ) then
      love.event.quit()
   end

   set_force( )
end

function love.keypressed(key)
   local functions = {
      ["f5"] = function() set.stars = not set.stars end,
      ["f6"] = function() set.angular_velocity = 0 end,
      ["f7"] = function() set.help = not set.help end,
      ["f12"] = reset,
   }
   if functions[key] then
      functions[key]()
   end
end
