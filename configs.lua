-- configs.lua – Configs tab content
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Hub and Config are global
local Hub = getgenv().WeaponryHub
local Config = Hub.Settings

-- Helper functions (copied from original)
local function Apply3D(obj)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Color = Color3.new(0,0,0); stroke.Transparency = 1; stroke.Thickness = 2
    obj.MouseEnter:Connect(function()
        TweenService:Create(obj, TweenInfo.new(0.2), {Position = obj.Position + UDim2.new(0,0,0,-1)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
    end)
    obj.MouseLeave:Connect(function()
        TweenService:Create(obj, TweenInfo.new(0.2), {Position = obj.Position + UDim2.new(0,0,0,1)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    end)
end

local function AddSection(tab, text)
    local L = Instance.new("TextLabel", tab)
    L.Size = UDim2.new(1, -10, 0, 30)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(255,255,255)
    L.Font = "GothamBold"
    L.TextSize = 16
    L.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddToggle(tab, text, ptr, folder)
    local B = Instance.new("TextButton", tab)
    B.Size = UDim2.new(1, -10, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(20,20,20)
    B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(0,6)

    local L = Instance.new("TextLabel", B)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 16, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.new(1,1,1)
    L.Font = "GothamBold"
    L.TextSize = 14
    L.TextXAlignment = "Left"

    local Indicator = Instance.new("Frame", B)
    Indicator.Size = UDim2.new(0, 40, 0, 20)
    Indicator.Position = UDim2.new(1, -50, 0.5, -10)
    Indicator.BackgroundColor3 = folder[ptr] and Color3.fromRGB(200,0,0) or Color3.fromRGB(45,45,50)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1,0)

    local Ball = Instance.new("Frame", Indicator)
    Ball.Size = UDim2.new(0, 16, 0, 16)
    Ball.Position = folder[ptr] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Ball.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Ball).CornerRadius = UDim.new(1,0)

    B.MouseButton1Click:Connect(function()
        folder[ptr] = not folder[ptr]
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = folder[ptr] and Color3.fromRGB(200,0,0) or Color3.fromRGB(45,45,50)}):Play()
        TweenService:Create(Ball, TweenInfo.new(0.2), {Position = folder[ptr] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
    end)
end

local function AddColorPicker(tab, text, ptr, folder)
    local B = Instance.new("TextButton", tab)
    B.Size = UDim2.new(1, -10, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(20,20,20)
    B.Text = ""
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0,6)

    local L = Instance.new("TextLabel", B)
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 16, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.new(1,1,1)
    L.Font = "GothamBold"
    L.TextSize = 14
    L.TextXAlignment = "Left"

    local ColorPreview = Instance.new("Frame", B)
    ColorPreview.Size = UDim2.new(0, 22, 0, 14)
    ColorPreview.Position = UDim2.new(1, -32, 0.5, -7)
    ColorPreview.BackgroundColor3 = folder[ptr]
    Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0,3)

    Apply3D(B)
    B.MouseButton1Click:Connect(function()
        local Colors = {
            Color3.fromRGB(0,255,150),
            Color3.fromRGB(255,70,70),
            Color3.fromRGB(0,200,255),
            Color3.fromRGB(255,255,0),
            Color3.fromRGB(255,255,255),
            Color3.fromRGB(180,100,255)
        }
        local idx = 1
        for i, v in ipairs(Colors) do if v == folder[ptr] then idx = i break end end
        folder[ptr] = Colors[(idx % #Colors) + 1]
        ColorPreview.BackgroundColor3 = folder[ptr]
    end)
end

local function AddSlider(tab, text, min, max, ptr, folder)
    local SFrame = Instance.new("Frame", tab)
    SFrame.Size = UDim2.new(1, -10, 0, 55)
    SFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0,6)

    local L = Instance.new("TextLabel", SFrame)
    L.Size = UDim2.new(1, -20, 0, 20)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.Text = text .. ": " .. tostring(folder[ptr])
    L.TextColor3 = Color3.new(1,1,1)
    L.BackgroundTransparency = 1
    L.Font = "GothamBold"
    L.TextSize = 14
    L.TextXAlignment = "Left"

    local SliderBack = Instance.new("Frame", SFrame)
    SliderBack.Size = UDim2.new(1, -32, 0, 6)
    SliderBack.Position = UDim2.new(0, 16, 0, 38)
    SliderBack.BackgroundColor3 = Color3.fromRGB(40,40,45)
    Instance.new("UICorner", SliderBack)

    local Fill = Instance.new("Frame", SliderBack)
    Fill.Size = UDim2.new(math.clamp(((folder[ptr] or min) - min) / (max - min), 0, 1), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(200,0,0)
    Instance.new("UICorner", Fill)

    local function UpdateSlider()
        local mPos = UserInputService:GetMouseLocation()
        local relativeX = mPos.X - SliderBack.AbsolutePosition.X
        local percent = math.clamp(relativeX / SliderBack.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percent)
        folder[ptr] = val
        L.Text = text .. ": " .. tostring(val)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
    end

    SFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = game:GetService("RunService").RenderStepped:Connect(function()
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    connection:Disconnect()
                else
                    UpdateSlider()
                end
            end)
        end
    end)
end

local function AddKeybindRow(parent, label, keyName)
    local Row = Instance.new("Frame", parent)
    Row.Size = UDim2.new(1, 0, 0, 40)
    Row.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Row.ZIndex = 5
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0,6)

    local L = Instance.new("TextLabel", Row)
    L.Size = UDim2.new(0.6, 0, 1, 0)
    L.Position = UDim2.new(0, 12, 0, 0)
    L.BackgroundTransparency = 1
    L.Font = "GothamBold"
    L.TextSize = 14
    L.TextColor3 = Color3.new(1,1,1)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Text = label

    local BindBtn = Instance.new("TextButton", Row)
    BindBtn.Size = UDim2.new(0, 130, 1, -8)
    BindBtn.Position = UDim2.new(1, -140, 0, 4)
    BindBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    BindBtn.TextColor3 = Color3.new(1,1,1)
    BindBtn.Font = "GothamBold"
    BindBtn.TextSize = 14
    BindBtn.Text = Config.Keybinds[keyName] or "None"
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0,4)
    Apply3D(BindBtn)
    Hub.State.KeybindButtons[keyName] = BindBtn

    BindBtn.MouseButton1Click:Connect(function()
        BindBtn.Text = "..."
        Hub.State.Binding = true
        local con
        con = UserInputService.InputBegan:Connect(function(i)
            local key = (i.KeyCode ~= Enum.KeyCode.Unknown and i.KeyCode.Name) or nil
            local inputType = i.UserInputType.Name
            local modifierKeys = {LeftShift=true, RightShift=true, LeftControl=true, RightControl=true, LeftAlt=true, RightAlt=true}
            local mod, main = nil, nil

            if key and modifierKeys[key] and not mod then
                mod = key
                BindBtn.Text = key .. " + ..."
                return
            end

            if not main then
                if key and not modifierKeys[key] then
                    main = key
                elseif inputType:find("MouseButton") then
                    main = inputType
                end
            end

            if mod or main then
                local final = (mod and main) and (mod .. " + " .. main) or (mod or main)
                -- conflict check (simplified)
                Config.Keybinds[keyName] = final
                BindBtn.Text = final

                -- Update displays if they exist
                if keyName == "TeleportClick" and Hub.State.TeleportKeybindDisplay then
                    Hub.State.TeleportKeybindDisplay.Text = final
                end
                if keyName == "AimbotLock" and Hub.State.AimbotKeybindDisplay then
                    Hub.State.AimbotKeybindDisplay.Text = final
                end
                if keyName == "SilentToggle" and Hub.State.SilentKeybindDisplay then
                    Hub.State.SilentKeybindDisplay.Text = final
                end

                Hub.State.Binding = false
                con:Disconnect()
            end
        end)
    end)
end

-- Now build the Configs tab UI
local tab = script.Parent  -- this is the Configs tab frame

-- PRESETS section (just a label, no functionality yet)
AddSection(tab, "PRESETS")

-- Saved Configs Scrolling List (placeholder)
local SavedList = Instance.new("ScrollingFrame", tab)
SavedList.Size = UDim2.new(1, -10, 0, 140)
SavedList.BackgroundColor3 = Color3.fromRGB(10,10,10)
SavedList.BorderSizePixel = 0
SavedList.ScrollBarThickness = 2
SavedList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SavedList.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UICorner", SavedList).CornerRadius = UDim.new(0,6)

local SavedLayout = Instance.new("UIListLayout", SavedList)
SavedLayout.Padding = UDim.new(0,4)
SavedLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Four buttons (UI only)
local function MakeConfigButton(parent, text)
    local B = Instance.new("TextButton", parent)
    B.Size = UDim2.new(1, -10, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(20,20,20)
    B.Text = text
    B.Font = "GothamBold"
    B.TextSize = 14
    B.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", B).CornerRadius = UDim.new(0,6)
    Apply3D(B)
    return B
end

local BtnContainer = Instance.new("Frame", tab)
BtnContainer.Size = UDim2.new(1, 0, 0, 200)
BtnContainer.BackgroundTransparency = 1

local BtnLayout = Instance.new("UIListLayout", BtnContainer)
BtnLayout.Padding = UDim.new(0,6)
BtnLayout.SortOrder = Enum.SortOrder.LayoutOrder

MakeConfigButton(BtnContainer, "Save Config")
MakeConfigButton(BtnContainer, "Load Config")
MakeConfigButton(BtnContainer, "Delete Config")
MakeConfigButton(BtnContainer, "Import Config")

-- Keybind Manager section
AddSection(tab, "Keybind Manager")

local KeybindsList = Instance.new("Frame", tab)
KeybindsList.Size = UDim2.new(1, -10, 0, 410)
KeybindsList.BackgroundTransparency = 1

local kbLayout = Instance.new("UIListLayout", KeybindsList)
kbLayout.Padding = UDim.new(0, 6)
kbLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Add all keybind rows
AddKeybindRow(KeybindsList, "Open GUI", "OpenGUI")
AddKeybindRow(KeybindsList, "Aimbot Lock", "AimbotLock")
AddKeybindRow(KeybindsList, "Silent Aim", "SilentToggle")
AddKeybindRow(KeybindsList, "Click Teleport", "TeleportClick")
AddKeybindRow(KeybindsList, "Teleport Activate", "TeleportActivate")
AddKeybindRow(KeybindsList, "Open Section", "OpenSection")  -- if you have that
AddKeybindRow(KeybindsList, "Open Troll Panel", "OpenTroll")
AddKeybindRow(KeybindsList, "Open Editor", "OpenEditor")
AddKeybindRow(KeybindsList, "Quick Apply Troll", "QuickApplyTroll")
AddKeybindRow(KeybindsList, "Hide All Visuals", "HideVisuals")
AddKeybindRow(KeybindsList, "Unload Script", "Unload")

print("Configs tab loaded")
