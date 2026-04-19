local Player = game:GetService("Players").LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "NIDAVELLIR_GUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 480)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local BordeauxColor = Color3.fromRGB(128, 0, 32)
local DarkBordeaux = Color3.fromRGB(80, 0, 20)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Text = "NIDAVELLIR"
Title.TextColor3 = BordeauxColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

local Pages = Instance.new("Frame", MainFrame)
Pages.Size = UDim2.new(1, -20, 1, -190)
Pages.Position = UDim2.new(0, 10, 0, 100)
Pages.BackgroundTransparency = 1

local function createPage()
    local container = Instance.new("Frame", Pages)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Visible = false
    local f = Instance.new("ScrollingFrame", container)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 2
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 6)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 5)
    end)
    return container, f
end

local function createBtn(txt, col, parent, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -5, 0, 32)
    b.BackgroundColor3 = col
    b.Text = txt:upper()
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
    return b
end

local OutfitTab, OutfitP = createPage() OutfitTab.Visible = true
local SkinTab, SkinP = createPage()
local ToolTab, ToolP = createPage()
local AccTab, AccP = createPage()
local GunTab, GunP = createPage()

-- OUTFITS
for _, o in ipairs(_G.NidavellirData.Outfits) do
    createBtn(o[1], BordeauxColor, OutfitP, function() _G.NidavellirFunctions.applyOutfit(o[2], o[3], false) end)
end

-- SKINS
for _, s in ipairs(_G.NidavellirData.Skins) do
    createBtn(s[1], BordeauxColor, SkinP, function() _G.NidavellirFunctions.applySkin(s[2], false) end)
end

-- TOOLS
createBtn("INFINITE YIELD", BordeauxColor, ToolP, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
createBtn("NIGHTSHIFT", BordeauxColor, ToolP, function() _G.NidavellirFunctions.applyLighting(0) end)
createBtn("DAYSHIFT", BordeauxColor, ToolP, function() _G.NidavellirFunctions.applyLighting(12) end)
createBtn("FPS HIDDEN", BordeauxColor, ToolP, function() _G.StatsSpoofed = not _G.StatsSpoofed _G.NidavellirFunctions.applyStatsSpoof() end)

-- GUNS
for skinName, _ in pairs(_G.NidavellirData.WEAPON_SKINS) do
    local baseWepName = string.split(skinName, " ")[1]
    createBtn(skinName, BordeauxColor, GunP, function()
        _G.ActiveWeaponSkins[baseWepName] = skinName
    end)
end

-- Tab Switcher Logic
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 60)
TabBar.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 4)

local function setupTab(name, page)
    local b = createBtn(name, Color3.fromRGB(25, 25, 25), TabBar, function()
        OutfitTab.Visible = false SkinTab.Visible = false ToolTab.Visible = false AccTab.Visible = false GunTab.Visible = false
        page.Visible = true
    end)
    b.Size = UDim2.new(0.18, 0, 1, 0)
    b.TextSize = 7
end

setupTab("OUTFIT", OutfitTab)
setupTab("SKIN", SkinTab)
setupTab("TOOL", ToolTab)
setupTab("ACC", AccTab)
setupTab("GUN", GunTab)
