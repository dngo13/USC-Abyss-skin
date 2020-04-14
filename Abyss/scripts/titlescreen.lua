local mposx = 0;
local mposy = 0;
local hovered = nil;
local buttonWidth = 420
local buttonHeight = 60
local buttonBorder = 3;
local buttonSpacing = 80
local label = -1;

local resx, resy = game.GetResolution()

local portrait = resy > resx
local landscape = resx > resy

local desw = 720
local desh = 1280
if landscape == true then
    desw = 1920
    desh = 1080
end

local backgroundImage = gfx.CreateSkinImage("sdvx_title.png", 0)
local backgroundImage_port = gfx.CreateSkinImage("sdvx_portrait.png", 0)

local scale = math.min(resx / 800, resy /800)

mouse_clipped = function(x,y,w,h)
    return mposx > x and mposy > y and mposx < x+w and mposy < y+h;
end;

draw_button = function(name, x, y, hoverindex)
    local rx = x - (buttonWidth / 2);
    local ty = y - (buttonHeight / 2);
    gfx.BeginPath();
    gfx.FillColor(252, 200, 200);

    if mouse_clipped(rx, ty, buttonWidth, buttonHeight) then
       hovered = hoverindex;
       gfx.FillColor(70, 235, 235);
    end
    gfx.RoundedRect(rx - buttonBorder,
        ty - buttonBorder,
        buttonWidth + (buttonBorder * 2),
        buttonHeight + (buttonBorder * 2), 24);
    gfx.Fill();
    gfx.BeginPath();
    gfx.FillColor(0, 0, 0);

	if mouse_clipped(rx, ty, buttonWidth, buttonHeight) then
       hovered = hoverindex;
       gfx.FillColor(0, 0, 0);
    end

    gfx.RoundedRect(rx, ty, buttonWidth, buttonHeight, 24);
    gfx.Fill();
    gfx.BeginPath();
    gfx.FillColor(255, 255, 255);

	if mouse_clipped(rx,ty, buttonWidth, buttonHeight) then
       hovered = hoverindex;
       gfx.FillColor(255, 255, 255);
    end

    gfx.TextAlign(gfx.TEXT_ALIGN_CENTER + gfx.TEXT_ALIGN_MIDDLE);
    gfx.FontSize(30);
    gfx.Text(name, x, y)
end

render = function(deltaTime)
    resx,resy = game.GetResolution();
    mposx,mposy = game.GetMousePos();

	gfx.Save()

	gfx.BeginPath()
	gfx.FillColor(0, 0, 0)
	gfx.Rect(0, 0, resx, resy)
	gfx.Fill()

    local desw = 720
    local desh = 1280
    if landscape == true then
        desw = 1920
        desh = 1080
    end
    local scale = resy / desh

    local xshift = (resx - desw * scale) / 2 
    local yshift = (resy - desh * scale) / 2

    gfx.Translate(xshift, yshift)
    gfx.Scale(scale, scale)

	gfx.BeginPath()
	gfx.FillColor(255, 255, 255)
    if landscape == true then
	    gfx.ImageRect(0, 0, desw, desh, backgroundImage, 1, 0)
    else 
        gfx.ImageRect(0, 0, desw, desh, backgroundImage_port, 1, 0)
    end


	gfx.Fill()

	gfx.Restore()

    gfx.ResetTransform()
	
    gfx.BeginPath()
    buttonY = resy / 2 * 1.21; --1.31
    hovered = nil;
    gfx.LoadSkinFont("russellsquare.ttf");

    draw_button("Single Player", resx / 2, buttonY, Menu.Start);
    buttonY = buttonY + buttonSpacing;
    draw_button("Multiplayer", resx / 2, buttonY, Menu.Multiplayer);
    buttonY = buttonY + buttonSpacing;
    draw_button("Get Songs", resx / 2, buttonY, Menu.DLScreen);
	buttonY = buttonY + buttonSpacing;
    draw_button("Settings", resx / 2, buttonY, Menu.Settings);
    buttonY = buttonY + buttonSpacing;
    draw_button("EXIT", resx / 2, buttonY, Menu.Exit);
    gfx.BeginPath();
    gfx.FillColor(255,255,255);
    gfx.FontSize(120);
    if label == -1 then
        gfx.LoadSkinFont("russellsquare.ttf");
        label = gfx.CreateLabel("", 36, 0);
        label3 = gfx.CreateLabel("", 16, 0);
        label4 = gfx.CreateLabel("", 16, 0);
        gfx.LoadSkinFont("russellsquare.ttf");
    end
    gfx.TextAlign(gfx.TEXT_ALIGN_CENTER + gfx.TEXT_ALIGN_MIDDLE);
    gfx.DrawLabel(label, resx / 2, resy / 2 - 280, resx-40);
    gfx.DrawLabel(label3, resx / 2, resy / 2 - 125, resx-40);
    gfx.DrawLabel(label4, resx / 2, resy / 2 - 100, resx-40);

    updateUrl, updateVersion = game.UpdateAvailable()
    if updateUrl then
       gfx.BeginPath()
       gfx.TextAlign(gfx.TEXT_ALIGN_BOTTOM + gfx.TEXT_ALIGN_LEFT)
       gfx.FontSize(30)
       gfx.Text(string.format("Version %s is now available", updateVersion), 5, resy - buttonHeight - 10)
       draw_button("VIEW", buttonWidth / 2 + 5, resy - buttonHeight / 2 - 5, 4);
    end
end;

mouse_pressed = function(button)
    if hovered then
        hovered()
    end
    return 0
end
