-- 1. PANEL VE GÜVENLİ KURULUM
local player = game:GetService("Players").LocalPlayer
local spyGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
spyGui.Name = "RemoteSpyPanel"

local frame = Instance.new("Frame", spyGui)
frame.Size = UDim2.new(0, 350, 0, 450)
frame.Position = UDim2.new(0.5, -175, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true -- Sürükleme aktif

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Remote Spy v1.0 (Event & Function)"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6

-- Liste düzeni (Yazıların üst üste binmemesi için ŞART)
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)

-- 2. LOGLAMA FONKSİYONU
local function addLog(type, name, args)
    local text = Instance.new("TextLabel", scroll)
    text.Size = UDim2.new(1, -5, 0, 25)
    text.Text = "[" .. type .. "] " .. name .. " | Args: " .. (#args > 0 and tostring(args[1]) or "None")
    text.TextColor3 = (type == "EVENT" and Color3.new(0.6, 1, 0.6) or Color3.new(1, 0.6, 0.6))
    text.BackgroundTransparency = 0.3
    text.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    text.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Canvas boyutunu güncelle
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- 3. HOOK İŞLEMLERİ
-- RemoteEvent (FireServer) Hook
local oldFire
oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
    local args = {...}
    addLog("EVENT", self.Name, args)
    return oldFire(self, ...)
end))

-- RemoteFunction (InvokeServer) Hook
local oldInvoke
oldInvoke = hookfunction(Instance.new("RemoteFunction").InvokeServer, newcclosure(function(self, ...)
    local args = {...}
    addLog("FUNC", self.Name, args)
    return oldInvoke(self, ...)
end))

-- 4. KAPATMA
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.MouseButton1Click:Connect(function() spyGui:Destroy() end)
