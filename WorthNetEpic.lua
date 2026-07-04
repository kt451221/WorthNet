-- WORTHNET V5.0 - MASTER UI ARCHITECTURE
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local UI = Instance.new("ScreenGui", CoreGui)
UI.Name = "WorthNet"

local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 700, 0, 450); Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 100, 0) -- Neon Turuncu

-- Üst Bar ve Kapatma Tuşu
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 30); TopBar.BackgroundTransparency = 1
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0); CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function() UI:Destroy() end)

-- Sol Menü (Page 1-5)
local LeftMenu = Instance.new("Frame", Main)
LeftMenu.Size = UDim2.new(0, 150, 1, -30); LeftMenu.Position = UDim2.new(0, 0, 0, 30)
LeftMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

-- Orta İçerik (Dinamik)
local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -150, 1, -30); ContentArea.Position = UDim2.new(0, 150, 0, 30)
ContentArea.BackgroundTransparency = 1

local Pages = {} -- Tüm sayfaları burada tutacağız

local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1
    page.Visible = false; page.Name = name
    Pages[name] = page
    return page
end

-- Sayfa ve Oyun Ekleme Mantığı
for i = 1, 5 do
    local btn = Instance.new("TextButton", LeftMenu)
    btn.Size = UDim2.new(0.9, 0, 0, 40); btn.Position = UDim2.new(0.05, 0, 0, 10 + (i-1)*50)
    btn.Text = "Page " .. i; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    
    local page = createPage("Page" .. i)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

-- Örnek Oyun Ekleme (Page 1 İçine)
local function addGame(pageName, gameName)
    local btn = Instance.new("TextButton", Pages[pageName])
    btn.Size = UDim2.new(0, 150, 0, 50); btn.Text = gameName
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.MouseButton1Click:Connect(function()
        -- Burası oyun hile menüsünü tetikleyecek (Overlay)
        print(gameName .. " menüsüne girildi.")
    end)
end

addGame("Page1", "MM2")
addGame("Page1", "Blox Fruits")
