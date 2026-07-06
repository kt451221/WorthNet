-- 1. PANELİ OLUŞTUR
local spyGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local frame = Instance.new("Frame", spyGui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.BackgroundTransparency = 1

-- 2. LOGLAMA FONKSİYONU
local function addLog(name, args)
    local text = Instance.new("TextLabel", scroll)
    text.Size = UDim2.new(1, -10, 0, 30)
    text.Text = "Remote: " .. name .. " | Args: " .. tostring(args[1] or "Yok")
    text.TextColor3 = Color3.new(1, 1, 1)
    text.BackgroundTransparency = 1
    
    -- Liste düzeni (Otomatik aşağı kaydırma için)
    local layout = scroll:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout", scroll)
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- 3. HOOK İŞLEMİ (İşte gerçek Spy burada!)
local oldFireServer
oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
    local args = {...}
    addLog(self.Name, args) -- Yakalanan veriyi panele gönder
    return oldFireServer(self, ...) -- Orijinal işlemi devam ettir (Kritik!)
end))

-- Kapatma özelliği
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Text = "X"
close.MouseButton1Click:Connect(function() spyGui:Destroy() end)
