local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "WorthNet"

-- Ana Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar (Kapatma Tuşu Dahil)
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -30, 1, 0)
TitleLabel.Text = "WorthNet | Game Selection"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Oyun Listesi (Page 1)
local GameList = Instance.new("ScrollingFrame", MainFrame)
GameList.Size = UDim2.new(1, -10, 1, -40)
GameList.Position = UDim2.new(0, 5, 0, 35)
GameList.BackgroundTransparency = 1
GameList.CanvasSize = UDim2.new(0, 0, 0, 400)

local UIGrid = Instance.new("UIGridLayout", GameList)
UIGrid.CellSize = UDim2.new(0, 150, 0, 50)
UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)

-- Oyun Butonu Oluşturucu
local function createGameBtn(gameName)
    local btn = Instance.new("TextButton", GameList)
    btn.Text = gameName
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        -- Burası oyun seçilince açılacak olan menü
        TitleLabel.Text = gameName .. " WorthNet"
        GameList.Visible = false
        -- Burada hilelerin olduğu sayfayı (Page2+) oluşturacağız
        print(gameName .. " menüsüne geçildi.")
    end)
end

local games = {"BrookHaven", "MM2", "Blox Fruits", "BedWars", "Da Hood"}
for _, name in pairs(games) do createGameBtn(name) end
