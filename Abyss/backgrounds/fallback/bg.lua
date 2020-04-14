local delayedOperations = {
  u={},
  speed=nil
}

-- backgroundTextures
local bt = {
  _={"_.png"},
  cyberspace={"cyberspace.jpg", "cyberspace-c.jpg"},
  watervault={"watervault.jpg", "watervault-c.jpg"},
  underwater={"underwater.jpg", "underwater-c.jpg"},
  ocean={"ocean.jpg", "ocean-c.jpg",bright=true},
  grass={"grass.jpg", "grass-c.jpg"},
  deepsea={"deepsea.jpg", "deepsea-c.jpg"},
  cyber={"cyber.jpg", "cyber-c.jpg"},
  desert={"desert.jpg", "desert-c.jpg"},
  desertYellowClear={"desert.jpg", "desert-c2.jpg",bright=true},
  sky={"sky.jpg", "sky-c.jpg",bright=true},
  skyIv={"sky-iv.jpg", "sky-iv-c.jpg",bright=true},
  skyIv2={"sky_iv_2.png", "sky_iv_2-c.png",bright=true},
  skyIvDark={"sky-iv-dark.jpg"},
  sunset={"sunset.jpg", "sunset-c.jpg",bright=true},
  redgradient={"redgradient.jpg", "redblur.jpg"},
  cloudy={"cloudy.jpg", "cloudy-c.jpg"},
  redblur={"redblur.jpg", "redblur-c.jpg"},
  galaxy={"galaxy.jpg", "galaxy-c.jpg"},
  fantasy={"fantasy.jpg", "fantasy-c.jpg"},
  bedroom={"bedroom.jpg", "bedroom-c.jpg",bright=true},
  flame={"flame.jpg", "flame-c.jpg"},
  game={"game.png",bright=true},
  beach={"beach.png"},
  night={"night.jpg", "night-c.jpg"},
  prettygalaxy={"prettygalaxy.jpg", "prettygalaxy-c.jpg"},
  sakura={"sakura.jpg", "sakura-c.jpg"},
  cyberspaceNight={"cyberspace_night.png", "cyberspace_night_starburst.png"},
  moonBlue={"moon_blue.jpg", "moon_blue-c.jpg"},
  moonPurple={"moon_purple.jpg", "moon_purple-c.jpg"},
  redDusk={"red_dusk.jpg", "red_dusk-c.jpg"},
  star={"star.png", "star-c.png",bright=true},
  twilight={"twilight.png", "twilight-c.png"},
  undersea={"undersea.png", "undersea-c.png"},
}

-- backgroundComposition
local function bc(bt, opts)
	local out = {}
	for k,v in pairs(bt) do out[k] = v end
	for k,v in pairs(opts) do out[k] = v end
	return out
end

local btCollections = {
  blue={bt.watervault,bc(bt.underwater,{u={TunnelDodgeBlend=true}}),bt.cyberspace,bt.ocean,bt.grass,bt.deepsea,bt.cyber,bt.desert,bt.sky,bt.skyIv,bt.skyIv2,bt.moonBlue,{"city.png"},bt.cyberspaceNight,bt.undersea,bc(bt._,{weight=6})},
  red={bc(bt.flame,{u={TunnelDodgeBlend=true}}),bt.sunset,bt.redgradient,bt.mars,bt.cloudy,bt.redDusk,bt.moonPurple,bc(bt._,{weight=4})},
}

local pt = {
  lights={"lights_default.png", "lights_default-c.png"},
  lightsMoonblue={"lights_moonblue.png", "lights_moonblue-c.png"},
  lightsPurplish={"lights_purplish.png"},
  lightsOrangePink={"lights_orangepink.png"},
  lightsPink={"lights_pink.png", "lights_pink-c.png"},
  lightsSea={"lights_sea.png", "lights_sea-c.png"},
  lightsYellow={"lights_yellow.png"},
  lightsYellowPurple={"lights_yellow.png", "lights_purplish.png"},
  lightsYellowGreen={"lights_yellowgreen.png"},
  twilight={"twilight.png", "twilight-c.png"},
  streetLanterns={"street_lanterns.png", "street_lanterns-c.png"},
  starParticles={"star_particles.png", "star_particles-c.png"},
  squares={"squares.png", "squares-c.png"},
}


local bgs = {
  
  technoEye={
    Bg={ Base={Tex=bt.cyberspace} },
    Center={
      Tex="techno-eye.png",
      u={Pulse=true, Float=true, Scale=2.8},
      LayerEffect={Tex="glowshine.png", Fade=true}
    },
    Tunnel={
      Tex={"electro-blue.png", "electro-c.png"},
      u={Sides=8, Stretch=0.3, ScaleY=0.9, Fog=10.0, ExtraRotation=-0.125}
    },
  },
  seaNight={
    Bg={Base={Tex="sea-night.png", OffsetY=-0.19, ScaleSoft=true}, Overlay={Tex="sea-night-f.png", Float=true, OffsetY=-0.17}},
    Center={ Tex="ship-night.png", u={Scale=2.5, Float=true, FloatFactor=0.5, SnapToTrack=false}, LayerEffect={Tex="kac-hikari-2.png"}},
    Particle={ Tex="shines2.png", u={Speed=1.8, Amount=9} },
    -- Tunnel={},
    luaParticleEffect = { particles = { {"star-particle.png", 32} } }
  },
  seaStorm={
    Bg={Base={Tex="sea-storm.png", OffsetY=-0.13, ScaleSoft=true}, Overlay={Tex="sea-storm-f.png", Float=true, OffsetY=-0.17}},
    Center={ Tex="ship-storm.png", u={Scale=2.5, Float=true, FloatFactor=0.5, SnapToTrack=false}, LayerEffect={Tex="kac-hikari.png"}},
    Particle={ Tex="shines2.png", u={Speed=1.8, Amount=9} },
    -- Tunnel={},
  },
  seaIce={
    Bg={Base={Tex="sea-ice.png", OffsetY=-0.1, ScaleSoft=true}, Overlay={Tex="sea-ice-f.png", Float=true, OffsetY=-0.15}},
    Center={ Tex="ship-ice.png", u={Scale=2.5, Float=true, FloatFactor=0.5, SnapToTrack=false}, LayerEffect={Tex="kac-hikari-2.png"}},
    Particle={ Tex="shines1.png", u={Scale=0.3, OffsetY=-0.3, Speed=1.8, Amount=9} },
    -- Tunnel={},
    luaParticleEffect = { particles = { {"star-particle.png", 32} } }
  },
  seaThunder={
    Bg={Base={Tex="sea-thunder.png", OffsetY=-0.15, ScaleSoft=true}, Overlay={Tex="sea-thunder-f.png", Float=true, OffsetY=-0.16}},
    Center={ Tex="ship-storm.png", u={Scale=2.5, Float=true, FloatFactor=0.5, SnapToTrack=false}, LayerEffect={Tex="kac-hikari.png"}},
    Particle={ Tex="shines2.png", u={Speed=1.8, Amount=9} },
  },
  sakuraRainbow={
    Bg={Base={Tex=bt.sakura}},
    Center={
      Tex="rainbow.png", u={Scale=1.5, FadeEffect=true},
      LayerEffect={Tex="kac_hikari_sakura.png"}
    },
    -- Tunnel: rainbow rings?! probably not xd
    Particle={Tex="shines1.png", u={Speed=1.6, OffsetY=-0.3, Amount=6, Scale=0.35}},
    luaParticleEffect={particles={{"petal1.png", 140},{"petal2.png", 40},{"petal3.png", 140}}}
  },

  goldleaves={
    Bg={Base={Tex={"anim/goldleaves.jpg", "anim/goldleaves-c.jpg"}}},
    Particle={ Tex=pt.lightsYellow, u={Speed=1.8, OffsetY=-0.1, Amount=9} },
    speed=0.6
  },
  technocircle={
    Bg={Base={Tex={"anim/technocircle.jpg", "anim/technocircle-c.jpg"}, ScaleSoft=true}, u={Pivot=0.37}},
    Particle={ Tex="shines2.png", u={Speed=1.8, OffsetY=-0.15, Amount=7} },
    speed=0.6, bright=true
  },

  hexagons={
    Tunnel={Tex={{"hexagons.png", "hexagons-c.png"},{"hexagons-gray.png","hexagons.png"}}, u={ExtraRotation=-0.125, Fog=30}},
    Particle={Tex="hexes.png", u={Amount=3, OffsetY=-0.2, Speed=1.9, Scale=0.7}},
    speed=1.2,weight=2
  },

  iseki={
    Tunnel={
      Tex={{"iseki.png","iseki-c.png",u={TunnelExtraRotation=-0.125/2}}},
      u={Sides=16, Stretch=0.1, FlashEffect=true, Fog=25.0}
    },
    Center={Tex={{"kac_maxima_gold.png"},{0,weight=4}}, u={Float=true, Scale=5, OffsetY=0.04}, LayerEffect={Tex="kac_hikari_iseki.png", Scale=0.7}},
    Particle={Tex=pt.lightsYellow, u={Amount=6, OffsetY=0, Speed=1.9}},
    speed=0.5,
  },
  idofront={
    Tunnel={
      Tex={{"idofront.png","idofront-c.png",u={TunnelExtraRotation=-0.125/2}}},
      u={Sides=16, Stretch=0.1, Fog=25.0}
    },
    Particle={Tex=pt.lightsPurplish, u={Amount=5, Scale=1.3, Speed=1.9}},
  },
  genom={
    Tunnel={
      Tex={{"genom.png","genom-c.png",u={TunnelExtraRotation=-0.125/2*0}}},
      u={Sides=16, Stretch=0.1, Fog=25.0}
    },
    Particle={Tex=pt.lightsOrangePink, u={Amount=5, Scale=1.3, Speed=1.9}},
    speed=0.7
  },
  sonar={
    Bg={ Base={Tex={bt.undersea,bt.watervault,bt.underwater}}},
    Center={ Tex={"magic_circle.png","magic_circle-c.png"}, u={Scale=2.6, Rotate=true}, LayerEffect={Tex="sonar.png", Rotate=true, RotateSpeed=-4, Scale=3} },
    Particle={ Tex=pt.lightsSea, u={OffsetY=-0.1, Amount=9, Speed=1.7} },
  },
  star={
    Bg={ Base={Tex=bt.star, ScaleSoft=true}},
    Center={ Tex="star_core.png", u={Scale=2.3, Tilt=false, SnapToTrack=false, OffsetY=0.04}, LayerEffect={Tex="star_core.png", Glow=true, DodgeBlend=true } },
    Particle={ Tex=pt.starParticles, u={OffsetY=-0.1, Amount=9, Speed=1.7} },
  }
}

-- local bgTrumpcard=bgs.waveRed
-- local bgNestedIndices = {
  -- BgBase=2,
  -- Tunnel=1,
--   Center=1
-- }

local function stringToNumber(str)
  local number = 0
  for i = 1, string.len(str) do
    number = number + string.byte(str, i)
  end
  return number
end

local function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

local function setUniform(key, value)
  local valueType = type(value)
  if valueType == "number" then
    background.SetParamf(key, value)
  elseif valueType == "boolean" then
    background.SetParami(key, value and 1 or 0)
  else
    game.Log("Weird param type was passed to setUniform", 1)
  end
end

-----------------
-- PARTICLE STUFF
-----------------

local resx, resy = game.GetResolution()
local portrait = resy > resx
local desw = portrait and 720 or 1280
local desh = desw * (resy / resx)
local scale = resx / desw

local shouldRenderParticles = false
local particleTextures = {}
local particles = {}
local psizes = {}

local particleCount = 30
local particleSizeSpread = 0.5

local function initializeParticle(initial)
	local particle = {}
	particle.x = math.random()
	particle.y = math.random() * 1.2 - 0.1
	if not initial then particle.y = -0.1 end
	particle.r = math.random()
	particle.s = (math.random() - 0.5) * particleSizeSpread + 1.0
	particle.xv = 0
	particle.yv = 0.1
	particle.rv = math.random() * 2.0 - 1.0
  particle.p = math.random() * math.pi * 2
  particle.t = math.random(1, #psizes)
	return particle
end

local function renderParticles(deltaTime)
  local alpha = 0.3 + 0.5 * background.GetClearTransition()
  for i,p in ipairs(particles) do
		p.x = p.x + p.xv * deltaTime
		p.y = p.y + p.yv * deltaTime
		p.r = p.r + p.rv * deltaTime
		p.p = (p.p + deltaTime) % (math.pi * 2)
		
		p.xv = 0.5 - ((p.x * 2) % 1) + (0.5 * sign(p.x - 0.5))
		p.xv = math.max(math.abs(p.xv * 2) - 1, 0) * sign(p.xv)
		p.xv = p.xv * p.y
		p.xv = p.xv + math.sin(p.p) * 0.01
		
		gfx.Save()
		gfx.ResetTransform()
		gfx.Translate(p.x * resx, p.y * resy)
		gfx.Rotate(p.r)
		gfx.Scale(p.s * scale, p.s * scale)
		gfx.BeginPath()
		gfx.GlobalCompositeOperation(gfx.BLEND_OP_LIGHTER)
		gfx.ImageRect(-psizes[p.t]/2, -psizes[p.t]/2, psizes[p.t], psizes[p.t], particleTextures[p.t], alpha, 0)
		gfx.Restore()
		if p.y > 1.1 then 
			particles[i] = initializeParticle(false)
		end
	end
	gfx.ForceRender()
end

local function getRandomItemFromArray(array, seed)
  if #array == 1 then return array[1] end

  local weightedArray = {}
  for i, value in ipairs(array) do
    local weight = value.weight or 1
    for j = 1, weight do
      weightedArray[#weightedArray+1] = value
    end
  end

  math.randomseed(stringToNumber(seed))
  return weightedArray[math.random(#weightedArray)]
end

local function getImageDimensions(imagePath)
  return gfx.ImageSize( gfx.CreateImage(background.GetPath().."textures/"..imagePath, 0) )
end

local function filterArray(array, propertyToRemove)
  local newArray = {}
  for i, v in ipairs(array) do
    if not v[propertyToRemove] then newArray[#newArray+1] = v end
  end
  return newArray
end

local function filterTable(table, propertyToRemove)
  local newTable = {}
  for k, v in pairs(table) do
    if not v[propertyToRemove] then newTable[k] = v end
  end
  return newTable
end

local function loadTextures(prefix, tex, subFolder, checkAnim, noAnimCallback, setNormalVersion)
  local texture
  if type(tex) == "string" then
    texture = {tex}
  elseif type(tex[1]) == "string" then
    texture = tex
  else
    if not game.GetSkinSetting("show_h") or not game.GetSkinSetting("show_hh") then tex = filterArray(tex, "hh") end
    if not game.GetSkinSetting("show_h") then tex = filterArray(tex, "h") end
    if game.GetSkinSetting("dark_mode") then tex = filterArray(tex, "bright") end
    if bgNestedIndices and bgNestedIndices[prefix] then
      texture = tex[bgNestedIndices[prefix]]
    else
      texture = getRandomItemFromArray(tex, prefix..gameplay.title..gameplay.artist) -- todo: improve seeding
    end
  end

  if texture[1] == 0 then
    return false
  end

  if texture[1] then
    if setNormalVersion then
      setUniform(prefix.."NormalVersion", true)
    end
    background.LoadTexture(prefix.."Tex", "textures/"..subFolder.."/"..texture[1])
  end
  if texture[2] then
    setUniform(prefix.."ClearVersion", true)
    background.LoadTexture(prefix.."ClearTex", "textures/"..subFolder.."/"..texture[2])
  end
  if checkAnim and texture[1] then
    local w, h = getImageDimensions(subFolder.."/"..texture[1])
    if w / h > 2 then
      setUniform(prefix.."Anim", true)
      setUniform(prefix.."AnimFramesCount", math.floor(w / 600))
    elseif noAnimCallback then
      noAnimCallback(w, h)
    end
  end

  if texture.u then
    for k,v in pairs(texture.u) do
      delayedOperations.u[k] = v
    end
  end
  if texture.speed then delayedOperations.speed = texture.speed end
  return true
end

local function setUniformsRaw(uniforms)
  for k,v in pairs(uniforms) do setUniform(k, v) end
end

local function setUniforms(prefix, uniforms, subFolder, checkAnim, noAnimCallback)
  for k, v in pairs(uniforms) do
    if k == "Tex" then
      loadTextures(prefix, v, subFolder, checkAnim, noAnimCallback)
    else
      setUniform(prefix..k, v)
    end
  end
end

local function loadPart(prefix, part, subFolder, checkAnim, setNormalVersion)
  local loaded
  if part.Tex then
    loaded = loadTextures(prefix, part.Tex, subFolder, checkAnim, nil, setNormalVersion)
  else
    loaded = true
  end
  if loaded then
    setUniform(prefix, true)
  end
  if part.u then
    setUniforms(prefix, part.u, subFolder)
  end
end

local function randomItemFromTable(table)
  local keys = {}
  for key, value in pairs(table) do
    local weight = value.weight or 1
    for i = 1, weight do
      keys[#keys+1] = key
    end
  end
  local index = keys[math.random(#keys)]
  return table[index], index
end

local function processDelayedOperations()
  setUniformsRaw(delayedOperations.u)
  if delayedOperations.speed then background.SetSpeedMult(delayedOperations.speed) end
end

local function loadBackground(bg)
  if bg.Bg then
    local part = bg.Bg
    local prefix = "Bg"
    loadPart(prefix, part, "background")
    if part.Base then
      setUniform(prefix.."Base", true)
      setUniforms(prefix.."Base", part.Base, "background", true, function(w,h) setUniform(prefix.."Base".."AR", w / h) end)
    end
    if part.Overlay then
      setUniform(prefix.."Overlay", true)
      setUniforms(prefix.."Overlay", part.Overlay, "background")
    end
    if part.Layer then
      setUniform(prefix.."Layer", true)
      setUniforms(prefix.."Layer", part.Layer, "layer", true)
    end
  end
  if bg.Center then
    local part = bg.Center
    local prefix = "Center"
    loadPart(prefix, part, "center", true, true)
    if part.LayerEffect then
      setUniform(prefix.."LayerEffect", true)
      setUniforms(prefix.."LayerEffect", part.LayerEffect, "center")
    end
  end
  if bg.Tunnel then
    local part = bg.Tunnel
    local prefix = "Tunnel"
    loadPart(prefix, part, "tunnel")
  end
  if bg.Particle then
    local part = bg.Particle
    local prefix = "Particle"
    loadPart(prefix, part, "particle")
  end

  background.SetSpeedMult(bg.speed or 1.0)

  processDelayedOperations()

  if bg.luaParticleEffect then
    shouldRenderParticles = true
    for i, p in ipairs(bg.luaParticleEffect.particles) do
      particleTextures[i] = gfx.CreateImage(background.GetPath().."textures/luaparticle/" .. p[1], 0)
      psizes[i] = p[2]
    end
    for i=1,particleCount do
      particles[i] = initializeParticle(true)
    end
  end
end

if game.GetSkinSetting("dark_mode") then
  bgs = filterTable(bgs, "bright")
end

math.randomseed(stringToNumber(gameplay.title))
local bg, k = randomItemFromTable(bgs)
game.Log("bg:", 0)
game.Log(tostring(k), 0)
if bgTrumpcard then bg = bgTrumpcard end
loadBackground(bg)

function render_bg(deltaTime)
  background.DrawShader()
  if shouldRenderParticles then renderParticles(deltaTime) end
end
