-- --------
--
-- Xyen's GFX utility library for USC skins
--
-- Has some useful functions for common things to do in USC skins
--
-- -------
-- ----
-- Extended image drawing functions
-- ----
local images = {}
function draw_image_width(x, y, width, image)
    return draw_image_width_ext(x, y, width, image, 1, 0)
end
function draw_image_width_ext(x, y, width, image, alpha, angle)
    local tw, th = gfx.ImageSize(image)
    local rat = th/tw
    tw = width
    th = tw * rat
    gfx.BeginPath()
    gfx.ImageRect(x, y, tw, th, image, alpha, angle)
    return th
end
function draw_image_height(x, y, height, image)
    return draw_image_height_ext(x, y, height, image, 1, 0)
end
function draw_image_height_ext(x, y, height, image, alpha, angle)
    local tw, th = gfx.ImageSize(image)
    local rat = tw/th
    th = height
    tw = th * rat
    gfx.BeginPath()
    gfx.ImageRect(x, y, tw, th, image, alpha, angle)
    return tw
end
function draw_image_centered(x, y, image, alpha, angle)
    local tw, th = gfx.ImageSize(image)

    offX = (- tw * math.cos(angle) - th * math.sin(-angle)) / 2
    offY = (- th * math.cos(angle) + tw * math.sin(-angle)) / 2

    gfx.BeginPath()
    gfx.ImageRect(x + offX, y + offY, tw, th, image, alpha, angle)
end
function draw_image_centered_ext(x, y, width, height, image, alpha, angle)
    local tw, th = gfx.ImageSize(image)
    local rat = 0

    if width ~= 0 and height ~= 0 then
        tw = width
        th = height
    elseif width ~= 0 then
        rat = th/tw
        tw = width
        th = tw * rat
    elseif height ~= 0 then
        rat = tw/th
        th = height
        tw = th * rat
    end

    offX = (- tw * math.cos(angle) - th * math.sin(-angle)) / 2
    offY = (- th * math.cos(angle) + tw * math.sin(-angle)) / 2

    gfx.BeginPath()
    gfx.ImageRect(x + offX, y + offY, tw, th, image, alpha, angle)
end

-- ----
-- Misc. Text drawing functions
-- ----
function setup_font(font, size, align)
    gfx.LoadSkinFont(font)
    gfx.FontSize(size)
    gfx.TextAlign(align)
end

function draw_text_width(x, y, width, fontsize, text)
    gfx.Save()
    gfx.TextAlign(gfx.TEXT_ALIGN_CENTER)
    gfx.FontSize(fontsize)
    x1, y1, x2, y2 = gfx.TextBounds(0, 0, text)
    local textScale = math.min(width / x2, 1)
    gfx.Translate(x, y)
    gfx.Scale(textScale, 1)
    gfx.Text(text, 0, 0)
    gfx.Restore()
end

-- ----
-- Misc. Functions
-- ----
setup_transform_target = function(targetX, targetY, w, h)
  local scaleX = w / targetX
  local scaleY = h / targetY

  local scale = scaleX
  local offX = 0
  local offY = 0
  if scaleX > scaleY then
    scale = scaleY
    offX = (w - scale * targetX) / 2
  else
    offY = (h - scale * targetY) / 2
  end

  return offX, offY, scale
end

return {
   
    draw_image_width,
    draw_image_width_ext,
    draw_image_height,
    draw_image_height_ext,
    draw_image_centered,
    draw_image_centered_ext,

    setup_font,
    draw_text_width,

    setup_transform_target
}
