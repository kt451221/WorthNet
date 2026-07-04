-- WORTHNET HACK SYSTEM - PRO UI V2.0
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Sol Menü (Tablar)
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 120, 1, 0)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 10)

-- Orta Ekran (Oyunlar / Hileler)
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -130, 1, -10)
ContentFrame.Position = UDim2.new(0, 125, 0, 5)
ContentFrame.BackgroundTransparency = 1

local TitleLabel = Instance.new("TextLabel", ContentFrame)
TitleLabel.Text = "WorthNet | Game Selection"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1

-- Sayfa ve Oyun Yönetimi
local CurrentPage = 1
local PageData = {
    ["Page1"] = {"BrookHaven", "MM2", "Blox Fruits", "BedWars", "Da Hood", "Adopt Me", "Tower of Hell", "Pet Sim 99", "Doors", "Arsenal"},
    ["Page2"] = {"Diğer Oyun 1", "Oyun 2"} -- Burayı 10'a kadar doldurabilirsin
}

local function loadGames(pageName)
    ContentFrame:ClearAllChildren()
    TitleLabel.Parent = ContentFrame
    
    local Grid = Instance.new("UIGridLayout", ContentFrame)
    Grid.CellSize = UDim2.new(0, 100, 0, 40)
    Grid.Padding = UDim2.new(0, 10, 0, 10)
    
    for _, gameName in pairs(PageData[pageName]) do
        local btn = Instance.new("TextButton", ContentFrame)
        btn.Text = gameName
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", btn)
        
        btn.MouseButton1Click:Connect(function()
            -- OYUN HİLE MENÜSÜ AÇILIŞI
            TitleLabel.Text = gameName .. " | WorthNet"
            ContentFrame:ClearAllChildren()
            
            -- Örnek Hileler
            local fly = Instance.new("TextButton", ContentFrame)
            fly.Text = "Fly (Aç/Kapa)"
            fly.BackgroundColor3 = Color3.fromRGB(0, 80, 30)
            -- Fly fonksiyonu buraya...
        end)
    end
end

-- Tab Butonları Oluşturma
for i = 1, 5 do
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(0.9, 0, 0, 30)
    tabBtn.Position = UDim2.new(0.05, 0, 0, 10 + (i-1)*40)
    tabBtn.Text = "Page " .. i
    tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", tabBtn)
    
    tabBtn.MouseButton1Click:Connect(function()
        loadGames("Page" .. i)
    end)
end

loadGames("Page1") -- Başlangıç sayfası
