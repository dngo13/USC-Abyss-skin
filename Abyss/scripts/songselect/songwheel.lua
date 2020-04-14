--Horizontal alignment
TEXT_ALIGN_LEFT 	= 1
TEXT_ALIGN_CENTER 	= 2
TEXT_ALIGN_RIGHT 	= 4
--Vertical alignment
TEXT_ALIGN_TOP 		= 8
TEXT_ALIGN_MIDDLE	= 16
TEXT_ALIGN_BOTTOM	= 32
TEXT_ALIGN_BASELINE	= 64

local jacket = nil;
local selectedIndex = 1
local selectedDiff = 1
local songCache = {}
local ioffset = 0
local doffset = 0
local soffset = 0
local diffColors = {{0,0,255}, {0,255,0}, {255,0,0}, {255, 0, 255}}
local timer = 0
local effector = 0
local searchText = gfx.CreateLabel("",5,0)
local searchIndex = 1
local jacketFallback = gfx.CreateSkinImage("song_select/loading.png", 0)
local showGuide = game.GetSkinSetting("show_guide")
local legendTable = {
  {["labelSingleLine"] =  gfx.CreateLabel("DIFFICULTY SELECT",16, 0), ["labelMultiLine"] =  gfx.CreateLabel("DIFFICULTY\nSELECT",16, 0), ["image"] = gfx.CreateSkinImage("legend/knob-left.png", 0)},
  {["labelSingleLine"] =  gfx.CreateLabel("MUSIC SELECT",16, 0),      ["labelMultiLine"] =  gfx.CreateLabel("MUSIC\nSELECT",16, 0),      ["image"] = gfx.CreateSkinImage("legend/knob-right.png", 0)},
  {["labelSingleLine"] =  gfx.CreateLabel("FILTER MUSIC",16, 0),      ["labelMultiLine"] =  gfx.CreateLabel("FILTER\nMUSIC",16, 0),      ["image"] = gfx.CreateSkinImage("legend/FX-L.png", 0)},
  {["labelSingleLine"] =  gfx.CreateLabel("MUSIC MODS",16, 0),        ["labelMultiLine"] =  gfx.CreateLabel("MUSIC\nMODS",16, 0),        ["image"] = gfx.CreateSkinImage("legend/FX-LR.png", 0)},
  {["labelSingleLine"] =  gfx.CreateLabel("PLAY",16, 0),              ["labelMultiLine"] =  gfx.CreateLabel("PLAY",16, 0),               ["image"] = gfx.CreateSkinImage("legend/start.png", 0)}
}
--Grades
local grades = {
  {["max"] = 6999999, ["image"] = gfx.CreateSkinImage("score/D.png", 0)},
  {["max"] = 7999999, ["image"] = gfx.CreateSkinImage("score/C.png", 0)},
  {["max"] = 8699999, ["image"] = gfx.CreateSkinImage("score/B.png", 0)},
  {["max"] = 8999999, ["image"] = gfx.CreateSkinImage("score/A.png", 0)},
  {["max"] = 9299999, ["image"] = gfx.CreateSkinImage("score/A+.png", 0)},
  {["max"] = 9499999, ["image"] = gfx.CreateSkinImage("score/AA.png", 0)},
  {["max"] = 9699999, ["image"] = gfx.CreateSkinImage("score/AA+.png", 0)},
  {["max"] = 9799999, ["image"] = gfx.CreateSkinImage("score/AAA.png", 0)},
  {["max"] = 9899999, ["image"] = gfx.CreateSkinImage("score/AAA+.png", 0)},
  {["max"] = 99999999, ["image"] = gfx.CreateSkinImage("score/S.png", 0)}
}
local iNoScore = gfx.CreateSkinImage("score/no_grade.png", 0)
--Badges
local badges = {
    gfx.CreateSkinImage("badges/played.png", 0),
    gfx.CreateSkinImage("badges/clear.png", 0),
    gfx.CreateSkinImage("badges/hard-clear.png", 0),
    gfx.CreateSkinImage("badges/full-combo.png", 0),
    gfx.CreateSkinImage("badges/perfect.png", 0)
}
local iNoMedal = gfx.CreateSkinImage("badges/no-medal.png", 0)
-- Icons
---------
local icons = {
  gfx.CreateSkinImage("song_select/icons/0.png", 0),
  gfx.CreateSkinImage("song_select/icons/1.png", 0),
  gfx.CreateSkinImage("song_select/icons/2.png", 0),
  gfx.CreateSkinImage("song_select/icons/3.png", 0),
  gfx.CreateSkinImage("song_select/icons/4.png", 0),
  gfx.CreateSkinImage("song_select/icons/5.png", 0),
  gfx.CreateSkinImage("song_select/icons/6.png", 0)
}
-- Plates
local plates = {
  gfx.CreateSkinImage("song_select/plates/nov.png", 0),
  gfx.CreateSkinImage("song_select/plates/adv.png", 0),
  gfx.CreateSkinImage("song_select/plates/exh.png", 0),
  gfx.CreateSkinImage("song_select/plates/mxm.png", 0),
}
local iScrollBarMarker = gfx.CreateSkinImage("song_select/scrollbar_marker.png", 0)
local panel = gfx.CreateSkinImage("panel.png", 0)
local panel_port = gfx.CreateSkinImage("panel_port.png", 0)
local song_cursor = gfx.CreateSkinImage("song_select/song_cursor.png",0)

local clearColors = {
  {255, 25, 25}, -- Fail/Played
  {25, 255, 25}, -- Clear
  {255, 25, 255}, -- HC
  {255, 160, 235}, -- UC
  {255, 255, 25} -- PUC
}

game.LoadSkinSample("menu_click") 
game.LoadSkinSample("click-02")
game.LoadSkinSample("woosh")

local rowSize = 3

get_page_size = function()
local wheelSize = 15

    return math.floor(wheelSize/2)
end

-- Responsive UI variables
local aspectFloat = 1.0
local aspectRatio = "landscape"

adjustScreen = function(x,y)
  aspectFloat = x/y;
  if aspectFloat >= 1.0 then
    aspectRatio = "landscape"
  else
    aspectRatio = "portrait"
  end
end

--gfx.LoadSkinFont("russellsquare.ttf");
check_or_create_cache = function(song, loadJacket)
if aspectRatio == "landscape" then
    if not songCache[song.id] then songCache[song.id] = {} end

    if not songCache[song.id]["title"] then
        songCache[song.id]["title"] = gfx.CreateLabel(song.title, 35, 0)
    end
    if not songCache[song.id]["title_small"] then
        songCache[song.id]["title_small"] = gfx.CreateLabel(song.title, 25, 0)
    end
    if not songCache[song.id]["artist"] then
        songCache[song.id]["artist"] = gfx.CreateLabel(song.artist, 35, 0)
    end
    if not songCache[song.id]["artist_small"] then
        songCache[song.id]["artist_small"] = gfx.CreateLabel(song.artist, 25, 0)
    end
    if not songCache[song.id]["bpm"] then
        songCache[song.id]["bpm"] = gfx.CreateLabel(song.bpm, 30, 0)
    end
	
    if not songCache[song.id]["jacket"] and loadJacket then
        songCache[song.id]["jacket"] = gfx.CreateImage(song.difficulties[1].jacketPath, 0)
    end
end
    if aspectRatio == "portrait" then 
     if not songCache[song.id] then songCache[song.id] = {} end

     if not songCache[song.id]["title"] then
        songCache[song.id]["title"] = gfx.CreateLabel(song.title, 25, 0)
     end
     if not songCache[song.id]["title_small"] then
        songCache[song.id]["title_small"] = gfx.CreateLabel(song.title, 25, 0)
     end
     if not songCache[song.id]["artist"] then
        songCache[song.id]["artist"] = gfx.CreateLabel(song.artist, 25, 0)
     end
     if not songCache[song.id]["artist_small"] then
        songCache[song.id]["artist_small"] = gfx.CreateLabel(song.artist, 25, 0)
     end
     if not songCache[song.id]["bpm"] then
        songCache[song.id]["bpm"] = gfx.CreateLabel(song.bpm, 20, 0)
     end
	
        if not songCache[song.id]["jacket"] and loadJacket then
        songCache[song.id]["jacket"] = gfx.CreateImage(song.difficulties[1].jacketPath, 0)
        end
     end

end

local selectedCache_songid = nil
local selectedCache_diffid = nil
local selectedCache = nil
check_or_create_selected_cache = function(song, diffid)
  if selectedCache_songid ~= song.id or selectedCache_diffid ~= diffid then
    selectedCache = {}
    local diff = song.difficulties[selectedDiff]
    selectedCache["effector"] = gfx.CreateLabel(diff.effector,30,0)
    selectedCache["illustrator"] = gfx.CreateLabel(diff.illustrator,18,0)
  end
end

draw_scores = function(difficulty, x, y, w, h)
  -- draw the top score for this difficulty
  local xOffset = 5
  local height = h/3 - 10
  local ySpacing = h/3
  local yOffset = h/3
  gfx.BeginPath()
	if difficulty.scores[1] ~= nil then
		local highScore = difficulty.scores[1]
      scoreLabel = gfx.CreateLabel(string.format("%08d",highScore.score), 40, 0)
    if aspectRatio == "portrait" then 
        scoreLabel = gfx.CreateLabel(string.format("%08d",highScore.score), 30, 0)
    end
  
    for i,v in ipairs(grades) do
      if v.max > highScore.score then
        gfx.BeginPath()
        iw,ih = gfx.ImageSize(v.image)
        iar = iw / ih;
       -- gfx.ImageRect(x+200,y-60, iar * (h/2-10),h/2-10, v.image, 1, 0)
       -- gfx.ImageRect(x+xOffset,y+h/2 +5, iar * (h/2-10),h/2-10, v.image, 1, 0)
        break
      end
    end

    gfx.FontSize(40);
    gfx.TextAlign(gfx.TEXT_ALIGN_MIDDLE + gfx.TEXT_ALIGN_CENTER);
	gfx.DrawLabel(scoreLabel, x+(w/2) - 40,y-98,w)
	end
end

draw_grade = function(score, x, y, h)
  local drawn = false
  if score ~= nil then
    for i,v in ipairs(grades) do
      if v.max > score.score then
        drawn = true
        draw_image_height(x, y, h, v.image)
        break
      end
    end
  end

  if drawn == false then
    draw_image_height(x - 1, y, h, iNoScore)
  end
end

assign_RGBA = function(R, G, B, A)
  return R, G, B, A
end

draw_song = function(song, x, y, w, h, selected)
    local difficulty = song.difficulties[selectedDiff]
    local targetX = 322
    local targetY = 302
    local jacketWidth = 175

    if difficulty == nil then
      difficulty = song.difficulties[1]
    end

    local scale = 0
    local offX = 0
    local offY = 0
    offX, offY, scale = setup_transform_target(targetX, targetY, w, h)

    gfx.Save()
    gfx.Translate(x + offX, y + offY)
    gfx.Scale(scale, scale)

    if aspectRatio == "landscape" then 
    draw_image_width(0, 0, targetX, plates[math.min(difficulty.difficulty + 1, 4)])
    end
    if aspectRatio == "portrait" then 
     draw_image_width(0, 0, targetX , plates[math.min(difficulty.difficulty + 1, 4)])
     end

    local clearLampR = 249
    local clearLampG = 64
    local clearLampB = 185
    local clearLampA = 100

    if difficulty ~= nil then
      if difficulty.scores[1] ~= nil then
        clearLampR, clearLampG, clearLampB = table.unpack(clearColors[difficulty.topBadge])
        clearLampA = 200
      end
    end
    -- 36 55
    check_or_create_cache(song)
    gfx.BeginPath()
    gfx.RoundedRectVarying(35, 31, jacketWidth, jacketWidth, 4, 4, 4, 4)
    gfx.FillColor(10,10,10)
    gfx.StrokeColor(255,255,255,clearLampA)
    gfx.StrokeWidth(2)
    if selected then
        local fadeTimer = math.abs(math.floor(255 * math.cos(timer*8)))
        local fadeValue = math.max(fadeTimer,150)
        gfx.FillColor(10,10,10)
        gfx.StrokeColor(clearLampR,clearLampG,clearLampB,fadeValue)
        gfx.StrokeWidth(10)
    end
    gfx.Fill()
    gfx.Stroke()
    
    if not songCache[song.id][1] or songCache[song.id][1] == jacketFallback then
        songCache[song.id][1] = gfx.LoadImageJob(song.difficulties[1].jacketPath, jacketFallback, 0, 0)
    end
    if songCache[song.id][1] then
        gfx.BeginPath()
        if selected then
          gfx.ImageRect(35, 31, jacketWidth, jacketWidth, songCache[song.id][1], 1, 0)
        else
          gfx.ImageRect(35, 31, jacketWidth, jacketWidth, songCache[song.id][1], 0.4, 0)
        end
    end
 
    gfx.TextAlign(gfx.TEXT_ALIGN_BOTTOM + gfx.TEXT_ALIGN_LEFT)  
    gfx.DrawLabel(songCache[song.id]["title_small"], 45, 235, 250)

   -- Draw difficulty 
   local diffLabel = gfx.CreateLabel(difficulty.level, 45, 0)
   gfx.DrawLabel(diffLabel, 240, 205, 50)

    gfx.DrawLabel(songCache[song.id]["artist_small"], 45, 260, 250)
    gfx.FillColor(255, 255, 255)
    gfx.BeginPath()
    --Draw Badge and score
    if difficulty ~= nil then
      if difficulty.topBadge ~= 0 then
         gfx.ImageRect(232, 25, 50, 50, badges[difficulty.topBadge], 1, 0)
      else
        gfx.ImageRect(230, 25, 50, 50, iNoMedal, 1, 0)
      end
      gfx.FillColor(255,255,255)
    end
    draw_grade(difficulty.scores[1], 230, 75, 50)
    gfx.Restore()
end

draw_diff_icon = function(diff, x, y, w, h, selected)
    local shrinkX = w/4
    local shrinkY = h/4
    if selected then
      gfx.FontSize(h/2)
      shrinkX = w/6
      shrinkY = h/6
    else
      gfx.FontSize(math.floor(h / 3))
    end
    gfx.BeginPath()
    gfx.RoundedRectVarying(x+shrinkX,y+shrinkY,w-shrinkX*2,h-shrinkY*2,0,0,0,0)
    gfx.FillColor(15,15,15)
    gfx.StrokeColor(table.unpack(diffColors[diff.difficulty + 1]))
    gfx.StrokeWidth(2)
    gfx.Fill()
    gfx.Stroke()
    gfx.FillColor(255,255,255)
    gfx.TextAlign(gfx.TEXT_ALIGN_MIDDLE + gfx.TEXT_ALIGN_CENTER)
    gfx.FastText(tostring(diff.level), x+(w/2),y+(h/2))
end

draw_cursor = function(x,y,width)
	gfx.Save()
    gfx.BeginPath();
    gfx.Translate(x,y)
    local sCurW, sCurH = gfx.ImageSize(song_cursor)
    gfx.ImageRect(-119, 13, sCurW/4, sCurH/3, song_cursor, 1, 0)
    gfx.Restore()
end

draw_diffs = function(diffs, x, y, w, h)
    local diffWidth = w/3 
    local diffHeight = w/3
    local diffCount = #diffs
    gfx.Scissor(x,y,w,h)
    for i = math.max(selectedDiff - 2, 1), math.max(selectedDiff - 1,1) do
      local diff = diffs[i]
      local xpos = x + ((w/2 - diffWidth/2) + (selectedDiff - i + doffset)*(-0.8*diffWidth))
      if  i ~= selectedDiff then
        draw_diff_icon(diff, xpos - 55, y + 65, diffWidth, diffHeight, false)
      end
    end

    --after selected
  for i = math.min(selectedDiff + 2, diffCount), selectedDiff + 1,-1 do
      local diff = diffs[i]
      local xpos = x + ((w/2 - diffWidth/2) + (selectedDiff - i + doffset)*(-0.8*diffWidth))
      if  i ~= selectedDiff then
        draw_diff_icon(diff, xpos - 55, y + 65, diffWidth, diffHeight, false)
      end
    end
    local diff = diffs[selectedDiff]
    local xpos = x + ((w/2 - diffWidth/2) + (doffset)*(-0.8*diffWidth))
  draw_diff_icon(diff, xpos - 55, y + 65, diffWidth, diffHeight, true)
  gfx.BeginPath()
  gfx.FillColor(0,128,255)
  gfx.ResetScissor()
  draw_cursor(x + w/2, y +diffHeight/2, 20)
end


draw_selected = function(song, x, y, w, h)
    check_or_create_cache(song)
    check_or_create_selected_cache(song, selectedDiff)
    -- set up padding and margins
    local xPadding = math.floor(w/16)
    local yPadding =  math.floor(h/32)
    local xMargin = math.floor(w/16)
    local yMargin =  math.floor(h/32)
    local width = (w-(xMargin*4))
    local height = (h+(yMargin*85))
    local xpos = x+xMargin
    local ypos = y+yMargin
    if aspectRatio == "portrait" then
      xPadding = math.floor(w/64)
      yPadding =  math.floor(h/32)
      xMargin = math.floor(w/64)
      yMargin =  math.floor(h/32)
      width = (w-(xMargin*2))
      height = (h-(yMargin*2))
      xpos = x+xMargin
      ypos = y+yMargin
    end
    --Border
    local diff = song.difficulties[selectedDiff]
    if aspectRatio == "landscape" then 
        gfx.BeginPath()
        local panW, panH = gfx.ImageSize(panel)
        gfx.ImageRect(70,10, panW-49, panH-67, panel, 1, 0)
    end 
    if aspectRatio == "portrait" then 
        gfx.BeginPath()
        local panPW, panPH = gfx.ImageSize(panel_port)
        gfx.ImageRect(-5, -15, panPW - 100, panPH - 50, panel_port, 1, 0)
    end 
    -- jacket should take up 1/3 of height, always be square, and be centered
    local imageSize = math.floor(height/3)
    local imageXPos = ((width/2) - (imageSize/2)) + x+xMargin
    if aspectRatio == "portrait" then
      --Unless its portrait widesreen..
      imageSize = math.floor((height/3)*2)
      imageXPos = x+65
    end
    if not songCache[song.id][selectedDiff] or songCache[song.id][selectedDiff] ==  jacketFallback then
        songCache[song.id][selectedDiff] = gfx.LoadImageJob(diff.jacketPath, jacketFallback, 200,200)
    end

    if songCache[song.id][selectedDiff] then
        gfx.BeginPath()
        gfx.ImageRect(imageXPos - 30, y+yMargin+yPadding + 61, imageSize - 10, imageSize - 10, songCache[song.id][selectedDiff], 1, 0)
    end
    -- difficulty should take up 1/6 of height, full width, and be centered
    if aspectRatio == "portrait" then
      --difficulty wheel should be right below the jacketImage, and the same width as
      --the jacketImage
      draw_diffs(song.difficulties, 340,(ypos ),300,math.floor((height/5)))
    else
      -- difficulty should take up 1/6 of height, full width, and be centered
      draw_diffs(song.difficulties,(w/2) - (imageSize/1.5) + 5,(ypos+yPadding+imageSize),imageSize,math.floor(height/6))
    end
   --local song = songwheel.songs[i]
    -- Draw the folder type
  if string.find(song.path,"SDVX I BOOTH") ~= nil then
  folder_Type = 1
  elseif string.find(song.path,"SDVX II INFINITE INFECTION") ~= nil then
  folder_Type = 2
  elseif string.find(song.path,"SDVX III GRAVITY WARS") ~= nil then
  folder_Type = 3
  elseif string.find(song.path,"SDVX IV Complete") ~= nil then
  folder_Type = 4
  elseif string.find(song.path,"SDVX V Vivid Wave") ~= nil then
  folder_Type = 5
  elseif string.find(song.path,"nautica") ~= nil then
  folder_Type = 6
  else
  folder_Type = 0
  end

  local folderName 
  if folder_Type == 1 then
    folderName = "SDVX I BOOTH"
  elseif folder_Type == 2 then 
    folderName = "SDVX II INFINITE INFECTION"
  elseif folder_Type == 3 then 
    folderName = "SDVX III GRAVITY WARS"
   elseif folder_Type == 4 then 
    folderName = "SDVX IV COMPLETE"
   elseif folder_Type == 5 then 
    folderName = "SDVX V VIVID WAVE"
    elseif folder_Type == 6 then 
    folderName = "Nautica"
   else 
   folderName = "Custom"
   end 
  local iconimg = icons[folder_Type + 1]
  
  gfx.TextAlign(gfx.TEXT_ALIGN_LEFT + gfx.TEXT_ALIGN_BASELINE)
  gfx.FillColor(255, 255, 255, 255)
  gfx.FillColor(255, 255, 255)
    -- effector / bpm should take up 1/3 of height, full width
    if aspectRatio == "portrait" then
      --gfx.LoadSkinFont("Quantify.ttf");
      gfx.TextAlign(gfx.TEXT_ALIGN_TOP + gfx.TEXT_ALIGN_LEFT)
      gfx.DrawLabel(songCache[song.id]["title"], xpos+200, y+30, width-imageSize-20)
     
      gfx.DrawLabel(songCache[song.id]["artist"], xpos+200, y+65, width-imageSize-20)
      gfx.DrawLabel(songCache[song.id]["bpm"], xpos+80, y+255, width-imageSize-20)
      gfx.DrawLabel(selectedCache["effector"], xpos+320, y +95, width-300)
     -- gfx.FastText(string.format("Effector: %s", diff.effector), xpos+xPadding+imageSize+3, y+yMargin+yPadding + 115)
     gfx.BeginPath()
      gfx.ImageRect(435, (height/10)*6 + 50, 40, 40, iconimg, 1, 0)
       gfx.FontSize(25)
      gfx.FastText(folderName, xpos+300, y+125)
      gfx.FillColor(255, 255, 255)
    else
     -- gfx.LoadSkinFont("Quantify.ttf");
      gfx.FontSize(35)
      gfx.TextAlign(gfx.TEXT_ALIGN_TOP + gfx.TEXT_ALIGN_LEFT)
      gfx.DrawLabel(songCache[song.id]["title"], xpos+45, (height/10)*5.5 + 5, width-130)
      gfx.FontSize(35)
      gfx.DrawLabel(songCache[song.id]["artist"], xpos+45, (height/10)*5.5 + 60, width-130)
      gfx.FillColor(255,255,255)
      gfx.DrawLabel(songCache[song.id]["bpm"], xpos+150, (height/10)*8 + 55)
     -- gfx.FastText(diff.effector,xpos+220, (height/10)*8 + 90)
      gfx.DrawLabel(selectedCache["effector"], xpos+220, (height/10)*8 + 90, width-300)
      gfx.FillColor(255, 255, 255)
      gfx.BeginPath()
      gfx.ImageRect(455, (height/10)*6 +155, 75, 75, iconimg, 1, 0)
      gfx.FastText(folderName, xpos+185, (height/10)*8 + 125)
    end
    
    gfx.BeginPath()
    local difficulty = song.difficulties[selectedDiff]
    if difficulty == nil then
      difficulty = song.difficulties[1]
    end
    if aspectRatio == "landscape" then 
    if difficulty ~= nil then
      if difficulty.topBadge ~= 0 then
         gfx.ImageRect(width/2 - 8, (height/10)*7 + 70, 70, 70, badges[difficulty.topBadge], 1, 0)
         --gfx.ImageRect(xpos + 220, 600, 50, 50, badges[difficulty.topBadge], 1, 0)
      else
        gfx.ImageRect(width/2 - 8,(height/10)*7 + 70, 70, 70, iNoMedal, 1, 0)
      end
      gfx.FillColor(255,255,255)
    end
    gfx.BeginPath()
   draw_scores(diff, xpos+ 170,  (height/3)*2 + 160, width-imageSize-20, (height/3)-yPadding)
   draw_grade(difficulty.scores[1], width/2 - 120, (height/10)*7 + 70, 70)
    end 

    if aspectRatio == "portrait" then
     if difficulty ~= nil then
      if difficulty.topBadge ~= 0 then
         gfx.ImageRect(width/2 +78, (height/10)*7 + 20, 50, 50, badges[difficulty.topBadge], 1, 0)
         --gfx.ImageRect(xpos + 220, 600, 50, 50, badges[difficulty.topBadge], 1, 0)
      else
        gfx.ImageRect(width/2 + 78 ,(height/10)*7 + 20, 50, 50, iNoMedal, 1, 0)
      end
      gfx.FillColor(255,255,255)
    end
     draw_scores(diff, xpos+ 335, 280, 170, 30)
    draw_grade(difficulty.scores[1], width/2 + 5, (height/10)*7 + 20, 50)
    end
    gfx.ForceRender()
end

draw_scrollbar = function(x,y,w,h)
  gfx.BeginPath()
  gfx.Rect(x,y,w/2,h)
  gfx.FillColor(0, 0, 0)
  gfx.StrokeColor(0, 220, 255)
  gfx.StrokeWidth(1)
  gfx.Fill()
  gfx.Stroke()

  local scrolled = (selectedIndex - 1) / #songwheel.songs
  draw_image_centered_ext(x + w/4, y + scrolled  * h, w*2, w*2, iScrollBarMarker, 1.0, 0.0)
end

local pageIndex = 0

recalc_page = function(idx)
  local pageStart = math.max(1 + idx * rowSize, 1)
  local pageEnd = math.min((idx + 3) * rowSize, #songwheel.songs)

  return pageStart, pageEnd
end

draw_songwheel = function(x,y,w,h)
  local songWidth = math.floor(w/3) - 25
  local songHeight = math.floor(h/3)
  local pageStart, pageEnd

if aspectRatio == "portrait" then
  songWidth = math.floor(w/3)
  songHeight = math.floor(h/3)
end
  pageStart, pageEnd = recalc_page(pageIndex)

  newIndex = pageIndex
  repeat
    if selectedIndex < pageStart then
      newIndex = newIndex - 1
    end
    if selectedIndex > pageEnd then
      newIndex = newIndex + 1
    end
    pageStart, pageEnd = recalc_page(newIndex)
  until (selectedIndex >= pageStart and selectedIndex <= pageEnd)

  ioffset = ioffset + pageIndex - newIndex

  pageIndex = newIndex

  local offsetScissor = songHeight/2.6
  if aspectRatio == "portrait" then
    offsetScissor = songHeight/10
  end

  gfx.Scissor(x, y-offsetScissor, w, h + songHeight)
  for i = (pageStart - 3), (pageEnd + 3) do
    local song = songwheel.songs[i]
    local selected = (i == selectedIndex)
    local iOff = i - pageStart
    if song ~= nil then
      draw_song(song, x + songWidth * (iOff % rowSize), y + songHeight * (math.floor(iOff / rowSize) - ioffset), songWidth, songHeight, selected)
    end
  end
  gfx.ResetScissor()
  gfx.ForceRender()
  return songwheel.songs[selectedIndex]
end

draw_legend_pane = function(x,y,w,h,obj)
  local xpos = x+5
  local ypos = y
  local imageSize = h
  gfx.BeginPath()
  gfx.TextAlign(gfx.TEXT_ALIGN_MIDDLE + gfx.TEXT_ALIGN_LEFT)
  gfx.ImageRect(x, y, imageSize, imageSize, obj.image, 1, 0)
  xpos = xpos + imageSize + 5
  gfx.FontSize(16);
  gfx.DrawLabel(obj.labelSingleLine, xpos, y+(h/2), w-(10+imageSize))
  gfx.ForceRender()
end

draw_legend = function(x,y,w,h)
  gfx.TextAlign(gfx.TEXT_ALIGN_MIDDLE + gfx.TEXT_ALIGN_LEFT);
  gfx.BeginPath()
  gfx.FillColor(0,0,0,170)
  gfx.Rect(x,y,w,h)
  gfx.Fill()
  local xpos = 10;
  local legendWidth = math.floor((w-20)/#legendTable)
  for i,v in ipairs(legendTable) do
    local xOffset = draw_legend_pane(xpos+(legendWidth*(i-1)), y+5,legendWidth,h-10,legendTable[i])
  end
end

draw_search = function(x,y,w,h)
  soffset = soffset + (searchIndex) - (songwheel.searchInputActive and 0 or 1)
  if searchIndex ~= (songwheel.searchInputActive and 0 or 1) then
      game.PlaySample("woosh")
  end
  searchIndex = songwheel.searchInputActive and 0 or 1
  if aspectRatio == "landscape" then 
  gfx.BeginPath()
  local bgfade = 1 - (searchIndex + soffset)
  --if not songwheel.searchInputActive then bgfade = soffset end
  gfx.FillColor(0,0,0,math.floor(200 * bgfade))
  gfx.Rect(0,0,resx,resy)
  gfx.Fill()
  gfx.ForceRender()
  local xpos = x + (searchIndex + soffset)*w
  gfx.UpdateLabel(searchText ,string.format("Search: %s",songwheel.searchText), 50, 0)
  gfx.BeginPath()
  gfx.RoundedRect(xpos,y,w,h/3,h/2)
  gfx.FillColor(0,30,60)
  gfx.StrokeColor(0,220,255)
  gfx.StrokeWidth(1)
  gfx.Fill()
  gfx.Stroke()
  gfx.BeginPath();
  gfx.TextAlign(gfx.TEXT_ALIGN_LEFT + gfx.TEXT_ALIGN_MIDDLE);
  gfx.DrawLabel(searchText, xpos+30,y+(h/2) - 80, w-20)
  end 

  if aspectRatio == "portrait" then 
  gfx.BeginPath()
  local bgfade = 1 - (searchIndex + soffset)
  --if not songwheel.searchInputActive then bgfade = soffset end
  gfx.FillColor(0,0,0,math.floor(200 * bgfade))
  gfx.Rect(0,0,resx,resy)
  gfx.Fill()
  gfx.ForceRender()
  local xpos = x + (searchIndex + soffset)*w
  gfx.UpdateLabel(searchText ,string.format("Search: %s",songwheel.searchText), 50, 0)
  gfx.BeginPath()
  gfx.RoundedRect(xpos,y+1000,w,h/3,h/2)
  gfx.FillColor(0,30,60)
  gfx.StrokeColor(0,220,255)
  gfx.StrokeWidth(1)
  gfx.Fill()
  gfx.Stroke()
  gfx.BeginPath();
  gfx.TextAlign(gfx.TEXT_ALIGN_LEFT + gfx.TEXT_ALIGN_MIDDLE);
  gfx.DrawLabel(searchText, xpos-(w/2)-270,y+(h/2)*3.5, w-20)
  end 

end

draw_legend_port = function(x,y,w,h)
  local targetX = 1080
  local targetY = 441

  local scale = 0
  local offX = 0
  local offY = 0
  offX, offY, scale = setup_transform_target(targetX, targetY, w, h)

  gfx.Save()
  gfx.Translate(x + offX, h - targetY*scale)
  gfx.Scale(scale, scale)
  --draw_image_width(0, 0, targetX, iConsolePort)
  --draw_image_width(0, 0, targetX, iLegendPort)
  end


render = function(deltaTime)
    timer = (timer + deltaTime)
    timer = timer % 2
    resx,resy = game.GetResolution();
    adjustScreen(resx,resy);

    gfx.FillColor(255,255,255);
    if songwheel.songs[1] ~= nil then
      local song = nil
      local scrollX, scrollY, scrollH
      if aspectRatio == "portrait" then
        scrollX = resx * 14.5/15
        scrollY = resy / 3.45
        scrollH = resy/2
        song = draw_songwheel(resx * 0.25/15, scrollY, resx * 14/15, scrollH)
        draw_selected(song, 0, 0, resx, resy/4)
      else
        --scrollX = resx - ((resx / 2) - (resx/2.05))
        scrollX = resx - ((resx / 2) - (resx/2.15))
        scrollY = resy / 8
        scrollH = resy*6/8
        song = draw_songwheel((resx/2)-25, scrollY, resx/2.05, resy*6/8)
        draw_selected(song, 0, 0, resx/2, resy/4)
      end
      draw_scrollbar(scrollX, scrollY, 8, scrollH)
    end
    if aspectRatio == "portrait" then
      draw_legend_port(0, 0, resx, resy)
    else
      draw_legend(0, resy*(10/11), resx, resy/11)
    end

    --draw text search
    draw_search(0, 0, resx, resy/5)

    ioffset = ioffset * 0.9
    doffset = doffset * 0.9
    soffset = soffset * 0.8
    if songwheel.searchStatus then
      gfx.BeginPath()
      gfx.FillColor(255,255,255)
      gfx.FontSize(20);
      gfx.TextAlign(gfx.TEXT_ALIGN_LEFT + gfx.TEXT_ALIGN_TOP)
      gfx.Text(songwheel.searchStatus, 3, 3)
    end
    gfx.ResetTransform()
    gfx.ForceRender()
end

set_index = function(newIndex)
    if newIndex ~= selectedIndex then
        game.PlaySample("menu_click")
    end
    selectedIndex = newIndex
end;

set_diff = function(newDiff)
    if newDiff ~= selectedDiff then
        game.PlaySample("click-02")
    end
    doffset = doffset + selectedDiff - newDiff
    selectedDiff = newDiff
end;

-- force calculation
--------------------
totalForce = nil

local badgeRates = {
	0.5,  -- Played
	1.0,  -- Cleared
	1.02, -- Hard clear
	1.04, -- UC
	1.1   -- PUC
}

local gradeRates = {
	{["min"] = 9900000, ["rate"] = 1.05}, -- S
	{["min"] = 9800000, ["rate"] = 1.02}, -- AAA+
	{["min"] = 9700000, ["rate"] = 1},    -- AAA
	{["min"] = 9500000, ["rate"] = 0.97}, -- AA+
	{["min"] = 9300000, ["rate"] = 0.94}, -- AA
	{["min"] = 9000000, ["rate"] = 0.91}, -- A+
	{["min"] = 8700000, ["rate"] = 0.88}, -- A
	{["min"] = 7500000, ["rate"] = 0.85}, -- B
	{["min"] = 6500000, ["rate"] = 0.82}, -- C
	{["min"] =       0, ["rate"] = 0.8}   -- D
}

calculate_force = function(diff)
	if #diff.scores < 1 then
		return 0
	end
	local score = diff.scores[1]
	local badgeRate = badgeRates[diff.topBadge]
	local gradeRate
    for i, v in ipairs(gradeRates) do
      if score.score >= v.min then
        gradeRate = v.rate
		break
      end
    end
	return math.floor((diff.level * 2) * (score.score / 10000000) * gradeRate * badgeRate) / 100
end

songs_changed = function(withAll)
	if not withAll then return end

	local diffs = {}
	for i = 1, #songwheel.allSongs do
		local song = songwheel.allSongs[i]
		for j = 1, #song.difficulties do
			local diff = song.difficulties[j]
			diff.force = calculate_force(diff)
			table.insert(diffs, diff)
		end
	end
	table.sort(diffs, function (l, r)
		return l.force > r.force
	end)
	totalForce = 0
	for i = 1, 50 do
		if diffs[i] then
			totalForce = totalForce + diffs[i].force
		end
	end
end
