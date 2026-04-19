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

-- Static Footer Buttons
local ResetAvatarBtn = createBtn("RESET AVATAR", DarkBordeaux, MainFrame, function() applyOutfit(OriginalShirt, OriginalPants, true) end)
ResetAvatarBtn.Size = UDim2.new(1, -20, 0, 30) ResetAvatarBtn.Position = UDim2.new(0, 10, 1, -85)

local ResetSkinBtn = createBtn("RESET SKIN TONE", DarkBordeaux, MainFrame, function() applySkin(nil, true) end)
ResetSkinBtn.Size = UDim2.new(1, -20, 0, 30) ResetSkinBtn.Position = UDim2.new(0, 10, 1, -85) ResetSkinBtn.Visible = false

local ResetTimeBtn = createBtn("RESET TIME CYCLE", DarkBordeaux, MainFrame, function() applyLighting(nil) end)
ResetTimeBtn.Size = UDim2.new(1, -20, 0, 30) ResetTimeBtn.Position = UDim2.new(0, 10, 1, -85) ResetTimeBtn.Visible = false

local ResetAccBtn = createBtn("REMOVE ACCESSORIES", DarkBordeaux, MainFrame, function()
    CurrentAccArgs = nil
    if Player.Character then for _, v in pairs(Player.Character:GetChildren()) do if v.Name == "NidavellirCustomAcc" then v:Destroy() end end end
end)
ResetAccBtn.Size = UDim2.new(1, -20, 0, 30) ResetAccBtn.Position = UDim2.new(0, 10, 1, -85) ResetAccBtn.Visible = false

-- === ACCESSORIES TAB ===
createBtn("CAT EARS", BordeauxColor, AccP, function() CurrentAccArgs = {"1374148", "413143035", -0.65, 0.15} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("FLAME HORNS", BordeauxColor, AccP, function() CurrentAccArgs = {"215680403", "658646189", -1.3, 0, Vector3.new(1,1,1), {Color = Color3.fromRGB(52, 206, 236), Heat = 5}} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("RED FLAME HORNS", BordeauxColor, AccP, function() CurrentAccArgs = {"79855980527088", "120274046498591", -1.3, 0, Vector3.new(1.3, 1.3, 1.3), {Color = Color3.fromRGB(236, 139, 70), Heat = 9}} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("VOID CROWN", BordeauxColor, AccP, function() CurrentAccArgs = {"1125478", "1125479", -0.45, 0, Vector3.new(0.65, 0.65, 0.65)} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("GOLDEN CROWN", BordeauxColor, AccP, function() CurrentAccArgs = {"1078075", "1078071", -0.45, 0} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("PARTY HAT", BordeauxColor, AccP, function() CurrentAccArgs = {"1778999", "1778994", -1.1, 0} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("ORANGE CW HP", BordeauxColor, AccP, function() CurrentAccArgs = {"187943426", "285584518", -0.35, 0, Vector3.new(0.40, 0.40, 0.40)} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("WHITE CW HP", BordeauxColor, AccP, function() CurrentAccArgs = {"187943426", "189255923", -0.35, 0, Vector3.new(0.40, 0.40, 0.40)} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("VALKYRIE", BordeauxColor, AccP, function() CurrentAccArgs = {"1365696", "1365693", -0.85, 0} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("BLACKVALK", BordeauxColor, AccP, function() CurrentAccArgs = {"1365696", "124896442", -0.85, 0} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("EERIE", BordeauxColor, AccP, function() CurrentAccArgs = {"1158007", "1158415", -0.45, 0.18, Vector3.new(0.45, 0.45, 0.45)} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("GHOSDEERI", BordeauxColor, AccP, function() CurrentAccArgs = {"1474596", "178262783", -0.45, 0.05, Vector3.new(0.45, 0.45, 0.45), {Color = Color3.fromRGB(52, 206, 236), Heat = 5}} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("BLIZZARIA", BordeauxColor, AccP, function() CurrentAccArgs = {"1158007", "106676124", -0.45, 0.18, Vector3.new(0.45, 0.45, 0.45)} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("RED VOID STAR", BordeauxColor, AccP, function() CurrentAccArgs = {"1125478", "1191134671", -0.45, 0, Vector3.new(0.65, 0.65, 0.65)} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("BLING BLING", BordeauxColor, AccP, function() CurrentAccArgs = {"6552775", "6552788", -1.1, 0} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("SHADES", BordeauxColor, AccP, function() CurrentAccArgs = {"1577360", "1577349", -0.32, 0} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("IRON BUCKET", BordeauxColor, AccP, function() CurrentAccArgs = {"1286103", "128154319", -0.65, 0} applyAcc(Player.Character, CurrentAccArgs) end)
createBtn("SKY FEDORA", BordeauxColor, AccP, function() CurrentAccArgs = {"1285237", "493450535", -0.65, 0} applyAcc(Player.Character, CurrentAccArgs) end)

createBtn("CHICKEN SUIT", BordeauxColor, AccP, function()
    CurrentAccArgs = {"24101267", "24108148", -0.35, 0}
    applyAcc(Player.Character, CurrentAccArgs)
    local char = Player.Character
    if char then
        local acc = char:WaitForChild("NidavellirCustomAcc", 2)
        if acc then
            local s1 = Instance.new("Sound", acc) s1.SoundId = "rbxassetid://24111685" s1.Volume = 1
            local s2 = Instance.new("Sound", acc) s2.SoundId = "rbxassetid://24111782" s2.Volume = 1
            local s3 = Instance.new("Sound", acc) s3.SoundId = "rbxassetid://24111798" s3.Volume = 1
            task.spawn(function()
                while acc and acc.Parent do
                    local choice = math.random(1, 3)
                    if choice == 1 then s1:Play() elseif choice == 2 then s2:Play() else s3:Play() end
                    task.wait(math.random(3, 7))
                end
            end)
        end
    end
end)

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
