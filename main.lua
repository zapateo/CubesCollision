-- MONDINI GIANLUCA
-- CUBE WAR
-- Lua with Love

-- Funzione che imposta la forza
function set_force( )
  for i=1, 4 do
    -- Copia la forza iniziale nella forza istantanea
    set.now_force[i] = set.force[i]
  end
end

-- Funzione che mostra l'aiuto
function help( )
  local text = "F5 attiva/disattiva le stelle\n"
  text=text.."F6 disattiva la rotazione dei cubi\n"
  text=text.."F7 mostra/nasconde l'aiuto\n"
  text=text.."F12 per resettare il gioco\n"
  love.graphics.setColor(200,200,200,200)
  love.graphics.print(text, 100, 100)
end

-- Funzione che genera le stelle
function draw_stars(number)
  -- Crea le stelle
  for i=1, number, 1 do
    -- Genera la posizione di una stella
    local x = math.floor(math.random( )*1000)
    local y = math.floor(math.random( )*1000)
    -- Genera le dimensioni di una stella
    local dimension = math.floor(math.random( )*4)
    -- Imposta il colore bianco della stella
    love.graphics.setColor(255,255,255,150)
    -- Disegna la stella sullo schermo
    love.graphics.circle( "fill", x, y, dimension )
  end
end

-- Funzione che resetta il gioco
function reset( )
  print(set.force[1])
  for p=1, #objects.player do
    local player = objects.player[p]
    -- Resetta la posizione del giocatore
    player.body:setPosition(
      player.pos[1]*0.01*window_width,
      player.pos[2]*0.01*window_height
    )
    -- Resetta la velocita' del giocatore
    player.body:setLinearVelocity(0,0)
    -- Applica una rotazione al giocatore
    player.body:setAngularVelocity(set.angular_velocity)
    -- Resetta la forza aumentata
    set_force( )
    -- Resetta la perdita dei giocatori
    player.lose = ""
  end
end

function love.load()
  -- Crea una tabella contenente le impostazioni
  set = {}
  -- Carica il modulo delle impostazioni
  require( "options.lua" )

  -- Crea una tabella contenente la forza istantanea
  set.now_force = {}
  for i=1, 4 do
    -- Copia la forza iniziale nella forza istantanea
    set.now_force[i] = set.force[i]
  end
  -- Imposta il metro della simulazione
  love.physics.setMeter(64)
  -- Crea un nuovo mondo
  world = love.physics.newWorld(set.gravity[1], set.gravity[2], true)
  -- Crea una tabella che conterra' gli oggetti
  objects = {}
  -- Crea una tabella contentente tutti i giocatori
  objects.player = set.players
  
  -- Cambia il colore dello sfondo
  love.graphics.setBackgroundColor(set.background)
  -- Ottiene le dimensioni dello schermo 1 (il primario)
  width, height = love.window.getDesktopDimensions(1)
  -- Calcola le dimensioni della finestra
  window_width  = width - set.margin[1]
  window_height = height - set.margin[2]
  -- Cambia le dimensioni della finestra
  love.window.setMode(window_width, window_height)

  -- Crea i giocatori
  for p=1, #objects.player, 1 do
    local player = objects.player[p]
    -- Crea il corpo dinamico del giocatore
    player.body = love.physics.newBody(world,
      player.pos[1]*0.01*window_width, -- x position of the player
      player.pos[2]*0.01*window_height, -- y position of the player
      "dynamic")
    -- Fa ruotare il cubo
    player.body:setAngularVelocity( set.angular_velocity )
    -- Crea la stringa che conterra' il testo della sconfitta
    player.lose=""
    -- Crea la forma del giocatore
    if player.shape.shape == "rect" then 
      player.shape = love.physics.newRectangleShape(0,0,set.rectangle[1],set.rectangle[2])
    end
    -- Crea il collegamento tra il corpo e la figura del giocatore
    player.fixture = love.physics.newFixture(player.body, player.shape, 5)
  end
end

function love.draw()
  -- Disegna le stelle (richiamando la funzione)
  if set.stars then draw_stars(set.stars_number) end
  for p=1, #objects.player, 1 do
    -- Imposta il colore del player p
    love.graphics.setColor(
      objects.player[p].color[1], -- red component
      objects.player[p].color[2], -- green component
      objects.player[p].color[3]) -- blue component
    -- Disegna il player p
    love.graphics.polygon("fill", objects.player[p].body:getWorldPoints(objects.player[p].shape:getPoints()))
    
    -- Crea una tabella contenente delle informazioni sul giocatore ricavate dalla tabella "player" e dalla simulazione in corso
    local info = {}
    -- Crea la tabella contenente la posizione del giocatore
    info.pos = {}
    -- Ottiene la posizione del giocatore
    info.pos.x, info.pos.y = objects.player[p].body:getWorldCenter()
    	-- Controlla se il giocatore ha perso
    -- Controlla la posizione del giocatore e procede se questo e' fuori dallo schermo
    if info.pos.x > window_width 
    or info.pos.x < 0 
    or info.pos.y > window_height 
    or info.pos.y < 0 
    then
       -- Verifica che il giocatore non abbia gia'  perso
      if objects.player[p].lose == "" then
      -- Ottiene il secondo in cui il giocatore e' morto
      local death_time = love.timer.getTime( )
      objects.player[p].lose = " ha perso a "..death_time
      end
    end
  -- Converte la posizione di tipo "float" in "int"
  info.pos.x, info.pos.y = math.floor(info.pos.x), math.floor(info.pos.y)
  -- Ottiene il nome del giocatore
  info.name = objects.player[p].name
  -- Ottiene la perdita del giocatore
  info.lose = objects.player[p].lose
  -- Crea una stringa contenente i tasti del giocatori
  info.keys = ""
  -- Itera i tasti del giocatore e li inserisce nella stringa
  for k=1, 4, 1 do
    info.keys = info.keys.." "..string.upper(objects.player[p].keys[k])
  end
  love.graphics.print(
    info.name.."\t\tPos: "..info.pos.x..", "..info.pos.y.." ("..info.keys.." )"..info.lose, 
	0, 12*(p-1) -- Coordinate del testo
	)
  end
  love.graphics.setColor(255,255,255)
  love.graphics.print("Gravity: "..set.gravity[1]..", "..set.gravity[2], 0, #objects.player*12)
  love.graphics.print("Force:   "..math.floor(set.now_force[1])..", "..math.floor(set.now_force[2])..", "..math.floor(set.now_force[3])..", "..math.floor(set.now_force[4]), 0, (#objects.player+1)*12)
  if set.stars then
    love.graphics.print("Stars:   "..set.stars_number, 0, (#objects.player+2)*12)
  end
  -- Mostra l'aiuto se questo e' abilitato
  if set.help == true then help ( ) end
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
  if love.keyboard.isDown( "escape" ) then love.event.quit( ) end
  -- Incrementa la forza su tutti gli assi
  set_force( )
end

function love.keypressed( key )
  -- TODO convertire in una tabella hash con le varie funzioni
  if key == "f5" then set.stars = not set.stars end
  if key == "f6" then set.angular_velocity = 0 end
  if key == "f7" then set.help = not set.help end
  if key == "f12"then reset( ) end
end
