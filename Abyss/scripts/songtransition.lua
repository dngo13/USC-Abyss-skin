local transitionTimer = 0
local resx, resy = game.GetResolution()
local outTimer = 1
local jacket = 0
local animTimer = 0
local bgImage = gfx.CreateSkinImage("transition.png",0)
local scale

local portrait
local desw, desh
local dividerLandscape = gfx.CreateSkinImage("divider_l.png", 0)

function ResetLayoutInformation()
    resx, resy = game.GetResolution()
    portrait = resy > resx
    desw = portrait and 720 or 1280 
    desh = desw * (resy / resx)
    scale = resx / desw
end

function render(deltaTime)
    render_screen(transitionTimer)
    transitionTimer = transitionTimer + deltaTime * 2
    transitionTimer = math.min(transitionTimer,1)
    if song.jacket == 0 and jacket == 0 then
        jacket = gfx.CreateSkinImage("song_select/loading.png", 0)
    elseif jacket == 0 then
        jacket = song.jacket
    end
    return transitionTimer >= 1
end

function render_out(deltaTime)
    outTimer = outTimer + deltaTime * 2
    outTimer = math.min(outTimer, 2)
    render_screen(outTimer)
    return outTimer >= 2
end

function sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

--largeFont = ImageFont.new("font-large", "0123456789")
local diffImages = {
    gfx.CreateSkinImage("level/novice.png", 0),
    gfx.CreateSkinImage("level/advanced.png", 0),
    gfx.CreateSkinImage("level/exhaust.png", 0),
    gfx.CreateSkinImage("level/gravity.png", 0)
}
 
function render_screen(progress)
ResetLayoutInformation()
  animTimer = transitionTimer * 2 - outTimer
  gfx.BeginPath()
    gfx.ImageRect(0,0,resx, resy, bgImage, 1, 0);

    local y = (resy/2 + 100) * (math.sin(0.5 * progress * math.pi)^7) - 200
    gfx.Save()
    
    gfx.BeginPath()
    local title = gfx.CreateLabel(song.title, math.floor(30 * scale), 0)
    local artist = gfx.CreateLabel(song.artist, math.floor(30 * scale), 0)
    local effector = gfx.CreateLabel(song.effector, math.floor(24 * scale), 0)
    local illustrator = gfx.CreateLabel(song.illustrator, math.floor(24 * scale), 0)
    gfx.ImageRect(0, 0, resx, resy, dividerLandscape, 1, 0)
    gfx.BeginPath()
    gfx.ImageRect((resx/2) - 250,resy/2 - 400,500,500,jacket,1,0)
    gfx.StrokeColor(0,128,255)
    gfx.StrokeWidth(5)
    gfx.Fill()
    gfx.Stroke()
    gfx.Restore()
    gfx.Translate(resx/2, resy - y - 50)
    gfx.FillColor(255,255,255)
    gfx.TextAlign(gfx.TEXT_ALIGN_CENTER + gfx.TEXT_ALIGN_TOP)
    gfx.LoadSkinFont("arial.ttf")
    gfx.BeginPath()
           
    gfx.FillColor(255, 255, 255)
    gfx.DrawLabel(title, 0, (80 * scale), (420 * scale))

    gfx.BeginPath()
    gfx.FillColor(255, 255, 255)
    gfx.DrawLabel(artist, 0, (130 * scale), (420 * scale))
    gfx.BeginPath()
    gfx.FillColor(255, 255, 255)
    gfx.DrawLabel(effector, 0, (205 * scale), (420 * scale))
    gfx.BeginPath()   
    gfx.FillColor(255, 255, 255)
    gfx.DrawLabel(illustrator, 0, (260 * scale), (420 * scale))

    gfx.Save()
   --gfx.Text("BPM: ", -50, 125)
   --gfx.Text(song.bpm,90,125)
end