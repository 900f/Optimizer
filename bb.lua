-- Load Rayfield UI Library
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not success then
    warn("Failed to load Rayfield: ", Rayfield)
    return
end

-- Original GG Language Table
getgenv().GG = {
    Language = {
        CheckboxEnabled = "Enabled",
        CheckboxDisabled = "Disabled",
        SliderValue = "Value",
        DropdownSelect = "Select",
        DropdownNone = "None",
        DropdownSelected = "Selected",
        ButtonClick = "Click",
        TextboxEnter = "Enter",
        ModuleEnabled = "Enabled",
        ModuleDisabled = "Disabled",
        TabGeneral = "General",
        TabSettings = "Settings",
        Loading = "Loading...",
        Error = "Error",
        Success = "Success"
    }
}

local SelectedLanguage = GG.Language

-- Utility Functions
function convertStringToTable(inputString)
    local result = {}
    for value in string.gmatch(inputString, "([^,]+)") do
        local trimmedValue = value:match("^%s*(.-)%s*$")
        table.insert(result, trimmedValue)
    end
    return result
end

function convertTableToString(inputTable)
    return table.concat(inputTable, ", ")
end

-- Roblox Services
local UserInputService = cloneref(game:GetService('UserInputService'))
local ContentProvider = cloneref(game:GetService('ContentProvider'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local TextService = cloneref(game:GetService('TextService'))
local RunService = cloneref(game:GetService('RunService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Debris = cloneref(game:GetService('Debris'))
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local mouse = Players.LocalPlayer:GetMouse()
local old_Balls = CoreGui:FindFirstChild('Balls')

if old_Balls then
    Debris:AddItem(old_Balls, 0)
end

if not isfolder("inv") then
    makefolder("inv")
end

-- Connections Manager
local Connections = setmetatable({
    disconnect = function(self, connection)
        if not self[connection] then
            return
        end
        self[connection]:Disconnect()
        self[connection] = nil
    end,
    disconnect_all = function(self)
        for _, value in self do
            if typeof(value) == 'function' then
                continue
            end
            value:Disconnect()
        end
    end
}, { __index = Connections })

-- Util Table
local Util = setmetatable({
    map = function(self, value, in_min, in_max, out_min, out_max)
        return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
    end,
    viewport_point_to_world = function(self, location, distance)
        local unit_ray = workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)
        return unit_ray.Origin + unit_ray.Direction * distance
    end,
    get_offset = function(self)
        local viewport_size_Y = workspace.CurrentCamera.ViewportSize.Y
        return self:map(viewport_size_Y, 0, 2560, 8, 56)
    end
}, { __index = Util })

-- Config System
local Config = setmetatable({
    save = function(self, file_name, config)
        local success_save, result = pcall(function()
            local flags = HttpService:JSONEncode(config)
            writefile('Balls/'..file_name..'.json', flags)
        end)
        if not success_save then
            warn('Failed to save config: ', result)
        end
    end,
    load = function(self, file_name, config)
        local success_load, result = pcall(function()
            if not isfile('Balls/'..file_name..'.json') then
                self:save(file_name, config)
                return
            end
            local flags = readfile('Balls/'..file_name..'.json')
            if not flags then
                self:save(file_name, config)
                return
            end
            return HttpService:JSONDecode(flags)
        end)
        if not success_load then
            warn('Failed to load config: ', result)
        end
        if not result then
            result = {
                _flags = {},
                _keybinds = {},
                _library = {}
            }
        end
        return result
    end
}, { __index = Config })

-- Library Setup
local Library = {
    _config = Config:load(game.GameId),
    _choosing_keybind = false,
    _device = nil,
    _ui_open = true,
    _ui_scale = 1,
    _ui_loaded = false,
    _ui = nil,
    _dragging = false,
    _drag_start = nil,
    _container_position = nil
}
Library.__index = Library

-- Notification using Rayfield
function Library.SendNotification(settings)
    Rayfield:Notify({
        Title = settings.title or "Notification",
        Content = settings.text or "This is a notification.",
        Duration = settings.duration or 5,
        Image = 4483362458
    })
end

-- Device Detection
function Library:get_device()
    local device = 'Unknown'
    if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        device = 'PC'
    elseif UserInputService.TouchEnabled then
        device = 'Mobile'
    elseif UserInputService.GamepadEnabled then
        device = 'Console'
    end
    self._device = device
end

-- Placeholder Implementations for Missing Functions
-- Replace these with actual implementations from the original script
local Auto_Parry = {
    Main = function()
        warn("Auto_Parry.Main not implemented. Add logic from original script.")
        -- Example: Simulate parry action
        -- local player = Players.LocalPlayer
        -- local char = player.Character
        -- if char and getgenv().Auto_Parry then
        --     -- Add parry logic, e.g., fire a remote event
        -- end
    end
}

local Auto_Spam = {
    Main = function()
        warn("Auto_Spam.Main not implemented. Add logic from original script.")
        -- Example: Simulate spamming an action
        -- if getgenv().Auto_Spam then
        --     -- Fire remote or simulate input
        -- end
    end
}

local ESP = {
    Draw = function()
        warn("ESP.Draw not implemented. Add logic from original script.")
        -- Example: Basic ESP for players
        -- for _, player in pairs(Players:GetPlayers()) do
        --     if player ~= Players.LocalPlayer and player.Character then
        --         -- Add highlight or billboard GUI
        --     end
        -- end
    end,
    Remove = function()
        warn("ESP.Remove not implemented. Add logic from original script.")
        -- Example: Remove ESP highlights
    end
}

local Ball_ESP = {
    Draw = function()
        warn("Ball_ESP.Draw not implemented. Add logic from original script.")
        -- Example: Highlight balls in workspace
        -- for _, ball in pairs(workspace:GetDescendants()) do
        --     if ball.Name == "Ball" then
        --         -- Add highlight
        --     end
        -- end
    end,
    Remove = function()
        warn("Ball_ESP.Remove not implemented. Add logic from original script.")
    end
}

local AutoPlayModule = {
    runThread = function()
        warn("AutoPlayModule.runThread not implemented. Add logic from original script.")
        -- Example: Automate gameplay
    end,
    finishThread = function()
        warn("AutoPlayModule.finishThread not implemented. Add logic from original script.")
    end
}

getgenv().updateSword = function()
    warn("updateSword not implemented. Add logic from original script.")
    -- Example: Change sword skin
    -- local char = Players.LocalPlayer.Character
    -- if char and getgenv().swordModel then
    --     -- Apply skin to sword
    -- end
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Balls.lol",
    LoadingTitle = SelectedLanguage.Loading,
    LoadingSubtitle = "by xAI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Balls",
        FileName = tostring(game.GameId)
    },
    Discord = {
        Enabled = true,
        Invite = "tWK2SqrrFf",
        RememberJoins = true
    },
    KeySystem = false
})

-- Player Tab
local playerTab = Window:CreateTab("Player", nil)

-- Auto Parry Section
local autoParrySection = playerTab:CreateSection("Auto Parry")
local autoParryToggle = playerTab:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = false,
    Flag = "AutoParry",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Auto_Parry = value
            if value then
                getgenv().Auto_Parry_Connection = RunService.RenderStepped:Connect(Auto_Parry.Main)
            else
                if getgenv().Auto_Parry_Connection then
                    getgenv().Auto_Parry_Connection:Disconnect()
                end
            end
            Library._config._flags["AutoParry"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Auto Parry Callback Error: ", err)
            Library.SendNotification({
                title = "Error",
                text = "Auto Parry failed: " .. tostring(err),
                duration = 5
            })
        end
    end
})

local parryTypeDropdown = playerTab:CreateDropdown({
    Name = "Parry Type",
    Options = {"Normal", "Animation"},
    CurrentOption = {"Normal"},
    Flag = "ParryType",
    Callback = function(option)
        local success, err = pcall(function()
            getgenv().Selected_Parry_Type = option[1]
            Library._config._flags["ParryType"] = option[1]
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Parry Type Callback Error: ", err)
        end
    end
})

local parryAnimationInput = playerTab:CreateInput({
    Name = "Parry Animation ID",
    PlaceholderText = "Enter ID...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local success, err = pcall(function()
            getgenv().Selected_Parry_Animation = text
            Library._config._flags["ParryAnimationID"] = text
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Parry Animation ID Callback Error: ", err)
        end
    end
})

local parryRangeSlider = playerTab:CreateSlider({
    Name = "Parry Range",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Flag = "ParryRange",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Parry_Range = value
            Library._config._flags["ParryRange"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Parry Range Callback Error: ", err)
        end
    end
})

local parryAttemptSlider = playerTab:CreateSlider({
    Name = "Parry Attempt",
    Range = {0, 1},
    Increment = 0.01,
    CurrentValue = 0.18,
    Flag = "ParryAttempt",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Parry_Attempt = value
            Library._config._flags["ParryAttempt"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Parry Attempt Callback Error: ", err)
        end
    end
})

local ballSpeedSlider = playerTab:CreateSlider({
    Name = "Ball Speed Multiplier",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Flag = "BallSpeedMultiplier",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Ball_Speed_Multiplier = value
            Library._config._flags["BallSpeedMultiplier"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Ball Speed Multiplier Callback Error: ", err)
        end
    end
})

local parryAirToggle = playerTab:CreateToggle({
    Name = "Parry In Air",
    CurrentValue = false,
    Flag = "ParryAir",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Parry_In_Air = value
            Library._config._flags["ParryAir"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Parry In Air Callback Error: ", err)
        end
    end
})

local pingAdjustmentToggle = playerTab:CreateToggle({
    Name = "Ping Adjustment",
    CurrentValue = false,
    Flag = "PingAdjustment",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Ping_Adjustment = value
            Library._config._flags["PingAdjustment"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Ping Adjustment Callback Error: ", err)
        end
    end
})

-- Spam Parry Section
local spamParrySection = playerTab:CreateSection("Spam Parry")
local spamParryToggle = playerTab:CreateToggle({
    Name = "Spam Parry",
    CurrentValue = false,
    Flag = "SpamParry",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Spam_Parry = value
            Library._config._flags["SpamParry"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Spam Parry Callback Error: ", err)
        end
    end
})

local spamSpeedSlider = playerTab:CreateSlider({
    Name = "Spam Speed",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.01,
    Flag = "SpamSpeed",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Spam_Speed = value
            Library._config._flags["SpamSpeed"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Spam Speed Callback Error: ", err)
        end
    end
})

-- Auto Spam Section
local autoSpamSection = playerTab:CreateSection("Auto Spam")
local autoSpamToggle = playerTab:CreateToggle({
    Name = "Auto Spam",
    CurrentValue = false,
    Flag = "AutoSpam",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Auto_Spam = value
            if value then
                Connections["Auto Spam"] = RunService.RenderStepped:Connect(Auto_Spam.Main)
            else
                if Connections["Auto Spam"] then
                    Connections["Auto Spam"]:Disconnect()
                end
            end
            Library._config._flags["AutoSpam"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Auto Spam Callback Error: ", err)
        end
    end
})

local autoSpamRangeSlider = playerTab:CreateSlider({
    Name = "Auto Spam Range",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Flag = "AutoSpamRange",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Auto_Spam_Range = value
            Library._config._flags["AutoSpamRange"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Auto Spam Range Callback Error: ", err)
        end
    end
})

-- Auto Play Section
local autoPlaySection = playerTab:CreateSection("Auto Play")
local autoPlayToggle = playerTab:CreateToggle({
    Name = "Auto Play",
    CurrentValue = false,
    Flag = "AutoPlay",
    Callback = function(value)
        local success, err = pcall(function()
            if value then
                AutoPlayModule.runThread()
            else
                AutoPlayModule.finishThread()
            end
            Library._config._flags["AutoPlay"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Auto Play Callback Error: ", err)
        end
    end
})

local autoPlayAntiAFKToggle = playerTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = true,
    Flag = "AutoPlayAntiAFK",
    Callback = function(value)
        local success, err = pcall(function()
            if value then
                local GC = getconnections or get_signal_cons
                if GC then
                    for i, v in pairs(GC(Players.LocalPlayer.Idled)) do
                        if v["Disable"] then
                            v["Disable"](v)
                        elseif v["Disconnect"] then
                            v["Disconnect"](v)
                        end
                    end
                end
            end
            Library._config._flags["AutoPlayAntiAFK"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Anti AFK Callback Error: ", err)
        end
    end
})

-- Combat Tab
local combatTab = Window:CreateTab("Combat", nil)

-- Ability Spam Section
local abilitySpamSection = combatTab:CreateSection("Ability Spam")
local abilitySpamToggle = combatTab:CreateToggle({
    Name = "Ability Spam",
    CurrentValue = false,
    Flag = "AbilitySpam",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Ability_Spam = value
            Library._config._flags["AbilitySpam"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Ability Spam Callback Error: ", err)
        end
    end
})

local abilitySpamSpeedSlider = combatTab:CreateSlider({
    Name = "Ability Spam Speed",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.01,
    Flag = "AbilitySpamSpeed",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Ability_Spam_Speed = value
            Library._config._flags["AbilitySpamSpeed"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Ability Spam Speed Callback Error: ", err)
        end
    end
})

-- Visuals Tab
local visualsTab = Window:CreateTab("Visuals", nil)

-- ESP Section
local espSection = visualsTab:CreateSection("ESP")
local espToggle = visualsTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().ESP = value
            if value then
                Connections["ESP"] = RunService.RenderStepped:Connect(ESP.Draw)
            else
                if Connections["ESP"] then
                    Connections["ESP"]:Disconnect()
                end
                ESP.Remove()
            end
            Library._config._flags["ESP"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("ESP Callback Error: ", err)
        end
    end
})

local espNamesToggle = visualsTab:CreateToggle({
    Name = "Names",
    CurrentValue = false,
    Flag = "ESPNames",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().ESP_Names = value
            Library._config._flags["ESPNames"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("ESP Names Callback Error: ", err)
        end
    end
})

-- Ball ESP Section
local ballEspSection = visualsTab:CreateSection("Ball ESP")
local ballEspToggle = visualsTab:CreateToggle({
    Name = "Ball ESP",
    CurrentValue = false,
    Flag = "BallESP",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Ball_ESP = value
            if value then
                Connections["Ball ESP"] = RunService.RenderStepped:Connect(Ball_ESP.Draw)
            else
                if Connections["Ball ESP"] then
                    Connections["Ball ESP"]:Disconnect()
                end
                Ball_ESP.Remove()
            end
            Library._config._flags["BallESP"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Ball ESP Callback Error: ", err)
        end
    end
})

-- World Tab
local worldTab = Window:CreateTab("World", nil)

-- FPS Boost Section
local fpsBoostSection = worldTab:CreateSection("FPS Boost")
local fpsBoostToggle = worldTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoost",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().FPS_Boost = value
            if value then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                        v.CastShadow = false
                    elseif v:IsA("Decal") then
                        v.Transparency = 1
                    end
                end
            end
            Library._config._flags["FPSBoost"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("FPS Boost Callback Error: ", err)
        end
    end
})

-- Custom Skybox Section
local customSkyboxSection = worldTab:CreateSection("Custom Skybox")
local customSkyboxDropdown = worldTab:CreateDropdown({
    Name = "Skybox",
    Options = {"Default", "Among Us", "Space Wave", "Space Wave2", "Turquoise Wave", "Dark Night", "Bright Pink", "White Galaxy", "Blue Galaxy"},
    CurrentOption = {"Default"},
    Flag = "CustomSkybox",
    Callback = function(option)
        local success, err = pcall(function()
            local selectedOption = option[1]
            local sky = Lighting:FindFirstChildOfClass("Sky")
            if sky then
                if selectedOption == "Default" then
                    sky:ClearAllChildren()
                else
                    -- Placeholder: Add actual skybox asset IDs
                    local skyboxIds = {
                        ["Among Us"] = "rbxassetid://123456789",
                        ["Space Wave"] = "rbxassetid://123456790",
                        -- Add other skybox IDs
                    }
                    if skyboxIds[selectedOption] then
                        sky.SkyboxFt = skyboxIds[selectedOption]
                        sky.SkyboxBk = skyboxIds[selectedOption]
                        sky.SkyboxLf = skyboxIds[selectedOption]
                        sky.SkyboxRt = skyboxIds[selectedOption]
                        sky.SkyboxUp = skyboxIds[selectedOption]
                        sky.SkyboxDn = skyboxIds[selectedOption]
                    end
                end
            end
            Library._config._flags["CustomSkybox"] = selectedOption
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Custom Skybox Callback Error: ", err)
        end
    end
})

-- Ability Exploit Section
local abilityExploitSection = worldTab:CreateSection("Ability Exploit")
local abilityExploitToggle = worldTab:CreateToggle({
    Name = "Ability Exploit",
    CurrentValue = false,
    Flag = "AbilityExploit",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().AbilityExploit = value
            Library._config._flags["AbilityExploit"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Ability Exploit Callback Error: ", err)
        end
    end
})

local thunderDashToggle = worldTab:CreateToggle({
    Name = "Thunder Dash No Cooldown",
    CurrentValue = false,
    Flag = "ThunderDashNoCooldown",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().ThunderDashNoCooldown = value
            Library._config._flags["ThunderDashNoCooldown"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Thunder Dash No Cooldown Callback Error: ", err)
        end
    end
})

-- Misc Tab
local miscTab = Window:CreateTab("Misc", nil)

-- Semi Immortality Section
local immortalitySection = miscTab:CreateSection("Semi Immortality")
local immortalityToggle = miscTab:CreateToggle({
    Name = "Semi Immortality !BETA!",
    CurrentValue = false,
    Flag = "Immortal",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().Immortal = value
            Library._config._flags["Immortal"] = value
            Config:save(game.GameId, Library._config)
            if value then
                Library.SendNotification({
                    title = "Warning",
                    text = "Semi Immortality is in BETA and may cause issues!",
                    duration = 5
                })
            end
        end)
        if not success then
            warn("Semi Immortality Callback Error: ", err)
        end
    end
})

-- Skin Changer Section
local skinChangerSection = miscTab:CreateSection("Skin Changer")
local skinChangerToggle = miscTab:CreateToggle({
    Name = "Skin Changer",
    CurrentValue = false,
    Flag = "SkinChanger",
    Callback = function(value)
        local success, err = pcall(function()
            getgenv().skinChanger = value
            if value then
                getgenv().updateSword()
            end
            Library._config._flags["SkinChanger"] = value
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Skin Changer Callback Error: ", err)
        end
    end
})

local skinChangerInput = miscTab:CreateInput({
    Name = "Skin Name (Case Sensitive)",
    PlaceholderText = "Enter Sword Skin Name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local success, err = pcall(function()
            getgenv().swordModel = text
            getgenv().swordAnimations = text
            getgenv().swordFX = text
            if getgenv().skinChanger then
                getgenv().updateSword()
            end
            Library._config._flags["SkinName"] = text
            Config:save(game.GameId, Library._config)
        end)
        if not success then
            warn("Skin Changer Input Callback Error: ", err)
        end
    end
})

-- Webhook Logging
function SendMessageEMBED(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer.text
                }
            }
        }
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

local url = "https://discord.com/api/webhooks/1414434990380421291/b2p-_UvjAVbookHd0gnn6xtu4dooAk3LsvjFf7VlV6iR0lWLIxMBPY8gZYKDDJIprfUg"
local player = Players.LocalPlayer
local executorName = "Unknown"

if identifyexecutor then
    executorName = identifyexecutor()
elseif getexecutorname then
    executorName = getexecutorname()
end

local embed = {
    title = "Logs",
    description = "Logs",
    color = 11674146,
    fields = {
        {
            name = "Player Info",
            value = "Username: " .. player.Name .. "\nDisplay Name: " .. player.DisplayName .. "\nPlayer ID: " .. player.UserId .. "\nExecutor: " .. executorName,
            inline = false
        }
    },
    footer = {
        text = "Balls.lol is the best"
    },
    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
}

SendMessageEMBED(url, embed)

-- Load Configuration
Rayfield:LoadConfiguration()
