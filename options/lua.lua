-- Colore di sfondo
set.background = {0,0,0}

-- Giocatori
set.players = {
{ name="G1", color={255,0,0}, keys = {"up","down","right","left"}, pos = {25, 25}, shape = {shape = "rect"}},
{ name="G2", color={0,255,0}, keys = {"w", "s",   "d",   "a"},     pos = {75, 75}, shape = {shape = "rect"}},
{ name="G3",    color={0,0,255}, keys = {"t", "g",   "h",   "f"},     pos = {25, 75}, shape = {shape = "rect"}},
{ name="G4",    color={0,255,255}, keys = {"i", "k",   "l",   "j"},     pos = {75, 25}, shape = {shape = "rect"}}
}
-- Imposta la gravita'
set.gravity = {0,0}

-- Imposta i margini della finestra rispetto allo schermo
set.margin = {100,100}

-- Imposta le dimensioni del giocatori
set.rectangle = {40,40}

-- Imposta la velocita' di rotazione iniziale
set.angular_velocity = 10

-- Imposta la spinta iniziale sui vari assi
set.force = {400, 400, 400, 400}

-- Imposta la variazione di spinta
set.force_increment = 0.05

-- Attiva (true) o disattiva (false) le stelle
set.stars = true

-- Imposta il numero di stelle
set.stars_number = 10

-- Mostra l'help all'avvio
set.help = false
