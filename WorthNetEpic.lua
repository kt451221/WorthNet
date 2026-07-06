-- WORTHNET REMOTE SPY - PROFESYONEL SÜRÜM
local player = game:GetService("Players").LocalPlayer
local spyGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
spyGui.Name = "WorthSpyPanel"

-- PANEL TASARIMI
local frame = Instance.new("Frame", spyGui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "WorthSpy | Event & Function"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- LOGLAMA FONKSİYONU (Gelişmiş)
local function addLog(type, name, args)
    local text = Instance.new("TextLabel", scroll)
    text.Size = UDim2.new(1, 0, 0, 30)
    text.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    text.BorderSizePixel = 0
    text.Font = Enum.Font.Code
    text.TextSize = 12
    text.TextColor3 = (type == "EVENT" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100))
    
    local argString = ""
    for i, v in pairs(args) do argString = argString .. tostring(v) .. (i < #args and ", " or "") end
    text.Text = "  [" .. type .. "] " .. name .. ": (" .. argString .. ")"
    text.TextXAlignment = Enum.TextXAlignment.Left
    
    -- UIListLayout boyutu güncelleme
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

-- HOOK İŞLEMİ (En Sağlam Yöntem: Namecall)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" then
        addLog("EVENT", self.Name, args)
    elseif method == "InvokeServer" then
        addLog("FUNC", self.Name, args)
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
