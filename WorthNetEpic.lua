-- WORTHNET PROFESSIONAL SPY v2.0
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "WorthNetSpy"

-- ANA PANEL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 450)
frame.Position = UDim2.new(0.5, -160, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true -- Sürükleme aktif
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- BAŞLIK VE X BUTONU
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "  WorthNet Remote List"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton", title)
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- LİSTE ALANI
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

-- FİLTRELİ LİSTELEME (Sadece ReplicatedStorage)
local function addRemote(v)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -5, 0, 30)
    btn.Text = "  " .. v.Name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    btn.MouseButton1Click:Connect(function()
        print("Kopyalandı: " .. v:GetFullName())
        setclipboard(v:GetFullName()) -- Yolu kopyalar
    end)
    
    scroll.CanvasSize = UDim2.new(0,0,0, scroll.UIListLayout.AbsoluteContentSize.Y)
end

-- TARAMA
for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        addRemote(v)
    end
end
