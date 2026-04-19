_G.NidavellirFunctions = {}

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Global State Variables
_G.OutfitToken = 0
_G.SkinToken = 0
_G.LightingLoop = nil
_G.CurrentShirt = ""
_G.CurrentPants = ""
_G.CurrentSkinColor = nil
_G.IsResetState = true
_G.CurrentAccArgs = nil
_G.LevelHidden = false
_G.UIHidden = false
_G.StatsSpoofed = false
_G.ActiveWeaponSkins = {}

local OriginalShirt = ""
local OriginalPants = ""
local OriginalBodyColors = nil
local OriginalClockTime = Lighting.ClockTime

-- Initialization logic
task.spawn(function()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local s = char:FindFirstChildOfClass("Shirt") or char:WaitForChild("Shirt", 1.5)
    local p = char:FindFirstChildOfClass("Pants") or char:WaitForChild("Pants", 1.5)
    local bc = char:FindFirstChildOfClass("BodyColors") or char:WaitForChild("BodyColors", 1.5)
    if s and OriginalShirt == "" then OriginalShirt = s.ShirtTemplate end
    if p and OriginalPants == "" then OriginalPants = p.PantsTemplate end
    if bc and not OriginalBodyColors then OriginalBodyColors = bc:Clone() end
end)

_G.NidavellirFunctions.applyLighting = function(targetTime)
    if _G.LightingLoop then _G.LightingLoop:Disconnect() end
    if targetTime == nil then
        Lighting.ClockTime = OriginalClockTime
        return
    end
    _G.LightingLoop = RunService.RenderStepped:Connect(function()
        Lighting.ClockTime = targetTime
    end)
end

_G.NidavellirFunctions.applyLevelHide = function()
    pcall(function()
        local core = Player.PlayerGui:FindFirstChild("CoreGUI")
        if core and core:FindFirstChild("LevelFrame") then
            core.LevelFrame.Visible = not _G.LevelHidden
        end
    end)
end

_G.NidavellirFunctions.applyUIHide = function()
    local targetVisibility = not _G.UIHidden
    pcall(function()
        local CG = game:GetService("CoreGui")
        local TopBar = CG:FindFirstChild("TopBarApp")
        if TopBar then
            TopBar.TopBarApp.UnibarLeftFrame.UnibarMenu.Visible = targetVisibility
            TopBar.TopBarApp.MenuIconHolder.TriggerPoint.Visible = targetVisibility
        end
        local ClientFrame = Player.PlayerGui:FindFirstChild("CoreGUI") and Player.PlayerGui.CoreGUI:FindFirstChild("ClientFrame")
        if ClientFrame then
            ClientFrame.Region.Visible = targetVisibility
            ClientFrame.RegionNote.Visible = targetVisibility
            ClientFrame.Parent.ServerInfo.Visible = targetVisibility
        end
    end)
end

_G.NidavellirFunctions.applyStatsSpoof = function()
    if _G.StatsSpoofConnection then _G.StatsSpoofConnection:Disconnect() end
    if _G.StatsSpoofed then
        _G.StatsSpoofConnection = RunService.RenderStepped:Connect(function()
            pcall(function()
                local ClientFrame = Player.PlayerGui.CoreGUI.ClientFrame
                for _, original in ipairs(ClientFrame:GetDescendants()) do
                    if original:IsA("TextLabel") and not original:GetAttribute("NidavellirFake") then
                        local text = original.Text:lower()
                        if text:find("fps") then
                            original.TextTransparency = 1 
                            local shadow = original.Parent:FindFirstChild(original.Name .. "_Shadow")
                            if not shadow then
                                shadow = original:Clone()
                                shadow.Name = original.Name .. "_Shadow"
                                shadow:SetAttribute("NidavellirFake", true)
                                shadow.Parent = original.Parent
                            end
                            shadow.Visible = true
                            shadow.TextTransparency = 0
                            shadow.RichText = true
                            shadow.Text = "FPS: <b>999</b>"
                        end
                    end
                end
            end)
        end)
    else
        pcall(function()
            local ClientFrame = Player.PlayerGui.CoreGUI.ClientFrame
            for _, v in ipairs(ClientFrame:GetDescendants()) do
                if v:IsA("TextLabel") and v:GetAttribute("NidavellirFake") then v:Destroy() elseif v:IsA("TextLabel") then v.TextTransparency = 0 end
            end
        end)
    end
end

_G.NidavellirFunctions.applyAcc = function(char, args)
    if not char or not args then return end
    
    -- Remove old accessories first
    for _, v in ipairs(char:GetChildren()) do 
        if v.Name == "NidavellirCustomAcc" then v:Destroy() end 
    end
    
    local handle = Instance.new("Part")
    handle.Name = "NidavellirCustomAcc"
    handle.Size = Vector3.new(1, 1, 1)
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = char
    
    local mesh = Instance.new("SpecialMesh", handle)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = args[1]:find("rbxassetid") and args[1] or "rbxassetid://" .. args[1]
    mesh.TextureId = args[2]:find("rbxassetid") and args[2] or "rbxassetid://" .. args[2]
    mesh.Scale = args[5] or Vector3.new(1,1,1)
    
    local head = char:WaitForChild("Head", 2)
    if head then
        local weld = Instance.new("Weld", handle)
        weld.Part0 = handle
        weld.Part1 = head
        weld.C0 = CFrame.new(0, args[3] or 0, args[4] or 0)
    end

    -- Check if there is extra data for Fire/Particles (args[6])
    if args[6] then
        local fire = Instance.new("Fire", handle)
        if args[6].Color then fire.Color = args[6].Color end
        if args[6].Heat then fire.Heat = args[6].Heat end
    end
end

_G.NidavellirFunctions.applyOutfit = function(sID, pID, resetMode, targetChar)
    _G.OutfitToken = _G.OutfitToken + 1
    local myToken = _G.OutfitToken
    _G.IsResetState = resetMode
    _G.CurrentShirt = (resetMode or sID:find("rbxassetid")) and sID or "rbxthumb://type=Asset&id="..sID.."&w=420&h=420"
    _G.CurrentPants = (resetMode or pID:find("rbxassetid")) and pID or "rbxthumb://type=Asset&id="..pID.."&w=420&h=420"
    
    local function enforce(char)
        task.spawn(function()
            local start = tick()
            while tick() - start < 4 do
                if _G.OutfitToken ~= myToken or not char or not char.Parent then break end
                local s = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
                local p = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
                s.ShirtTemplate = _G.CurrentShirt
                p.PantsTemplate = _G.CurrentPants
                task.wait(0.1)
            end
        end)
    end
    enforce(targetChar or Player.Character)
end

_G.NidavellirFunctions.applySkin = function(color, resetMode, targetChar)
    _G.SkinToken = _G.SkinToken + 1
    local myToken = _G.SkinToken
    _G.CurrentSkinColor = color
    local char = targetChar or Player.Character
    if char then
        task.spawn(function()
            local start = tick()
            while tick() - start < 4 do
                if _G.SkinToken ~= myToken or not char or not char.Parent then break end
                local bc = char:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors", char)
                if not resetMode then
                    bc.HeadColor3 = color bc.LeftArmColor3 = color bc.RightArmColor3 = color
                    bc.LeftLegColor3 = color bc.RightLegColor3 = color bc.TorsoColor3 = color
                end
                task.wait(0.1)
            end
        end)
    end
end

-- Weapon Skin Loop
RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if char then
        for baseWepName, activeSkinName in pairs(_G.ActiveWeaponSkins) do
            local equippedWep = char:FindFirstChild(baseWepName)
            if equippedWep and equippedWep:GetAttribute("CustomSkinApplied") ~= activeSkinName then
                local skinData = _G.NidavellirData.WEAPON_SKINS[activeSkinName]
                if skinData then
                    for _, part in ipairs(equippedWep:GetDescendants()) do
                        if part:IsA("MeshPart") then
                            local sa = part:FindFirstChild("Custom_SurfaceAppearance") or Instance.new("SurfaceAppearance", part)
                            sa.Name = "Custom_SurfaceAppearance"
                            sa.ColorMap = skinData.ColorMap
                            sa.MetalnessMap = skinData.MetalnessMap
                            sa.NormalMap = skinData.NormalMap
                            sa.RoughnessMap = skinData.RoughnessMap
                        end
                    end
                    equippedWep:SetAttribute("CustomSkinApplied", activeSkinName)
                end
            end
        end
    end
end)

Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if _G.CurrentShirt ~= "" then _G.NidavellirFunctions.applyOutfit(_G.CurrentShirt, _G.CurrentPants, _G.IsResetState, char) end
    if _G.CurrentSkinColor then _G.NidavellirFunctions.applySkin(_G.CurrentSkinColor, false, char) end
end)
