--[[--
Widget for displaying progress bar.

Configurable attributes:

 * width
 * height
 * margin_v  -- vertical margin for solid infill
 * margin_h  -- horizontal margin for solid infill
 * radius
 * bordersize
 * bordercolor
 * bgcolor
 * rectcolor  -- infill color
 * ticks (list)  -- default to nil, use this if you want to insert markers
 * tick_width
 * last  -- maximum tick, used with ticks

Example:

    local foo_bar = ProgressWidget:new{
        width = 400,
        height = 10,
        percentage = 50/100,
    }
    UIManager:show(foo_bar)

]]

local Widget = require("ui/widget/widget")
local Geom = require("ui/geometry")
local Blitbuffer = require("ffi/blitbuffer")

local ProgressWidget = Widget:new{
    width = nil,
    height = nil,
    margin_h = 3,
    margin_v = 1,
    radius = 2,
    bordersize = 1,
    bordercolor = Blitbuffer.COLOR_BLACK,
    bgcolor = Blitbuffer.COLOR_WHITE,
    rectcolor = Blitbuffer.gray(0.7),
    percentage = nil,
    ticks = nil,
    tick_width = 3,
    last = nil,
}

function ProgressWidget:getSize()
    return { w = self.width, h = self.height }
end

function ProgressWidget:paintTo(bb, x, y)
    local my_size = self:getSize()
    self.dimen = Geom:new{
        x = x, y = y,
        w = my_size.w,
        h = my_size.h
    }
    -- fill background
    bb:paintRoundedRect(x, y, my_size.w, my_size.h, self.bgcolor, self.radius)
    -- paint border
    bb:paintBorder(x, y,
                   my_size.w, my_size.h,
                   self.bordersize, self.bordercolor, self.radius)
    -- paint percentage infill
    bb:paintRect(x+self.margin_h, math.ceil(y+self.margin_v+self.bordersize),
                 math.ceil((my_size.w-2*self.margin_h)*self.percentage),
                 my_size.h-2*(self.margin_v+self.bordersize), self.rectcolor)
    if self.ticks and self.last then
        for i=1, #self.ticks do
            bb:paintRect(
                x + (my_size.w-2*self.margin_h)*(self.ticks[i]/self.last),
                y + self.margin_v + self.bordersize,
                self.tick_width,
                my_size.h-2*(self.margin_v+self.bordersize),
                self.bordercolor)
        end
    end
end

function ProgressWidget:setPercentage(percentage)
    self.percentage = percentage
end

return ProgressWidget
