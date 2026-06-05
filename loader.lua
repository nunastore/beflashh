--[[
    Script Name: Be Flash For Brainrot | Orion UI
    Author: Customized for User
    Library: Orion
]]

-- 1. MEMUAT LIBRARY UI (ORION)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 2. MEMBUAT JENDELA UTAMA (WINDOW)
local Window = OrionLib:MakeWindow({
    Name = "Be Flash For Brainrot | Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BeFlashConfig",
    IntroEnabled = true,
    IntroText = "Loading Script..."
})

-- 3. MEMBUAT TAB (KATEGORI)
local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "Player Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "Utilities",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 4. VARIABEL GLOBAL & LOGIKA FITUR

-- Logika Auto Farm
_G.AutoFarm = false
_G.FarmSpeed = 0.5 -- Kecepatan teleport (makin kecil makin cepat)

spawn(function()
    while wait(_G.FarmSpeed) do
        if _G.AutoFarm then
            pcall(function()
                local Player = game.Players.LocalPlayer
                local Character = Player.Character
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    -- LOGIKA FARMING:
                    -- Script ini akan mencari objek di Workspace yang biasanya jadi target.
                    -- Anda bisa mengubah nama "Coin", "Gem", atau "Orb" sesuai nama objek di dalam game.
                    
                    local Found = false
                    
                    -- Cari anak-anak di Workspace
                    for _, v in pairs(workspace:GetDescendants()) do
                        -- Filter objek (Bisa Coin, Gem, atau part yang memiliki TouchInterest)
                        if v.Name == "Coin" or v.Name == "Gem" or v.Name == "Orb" or (v:IsA("BasePart") and v:FindFirstChild("TouchInterest")) then
                            -- Cek jarak agar tidak teleport ke seluruh dunia
                            local distance = (HumanoidRootPart.Position - v.Position).Magnitude
                            
                            if distance < 5000 then -- Ambil radius 5000 studs
                                HumanoidRootPart.CFrame = v.CFrame
                                Found = true
                                wait(0.1) -- Delay sedikit agar server tidak crash
                                break 
                            end
                        end
                    end
                    
                    -- Jika tidak ada item, reset posisi atau diamkan
                    if not Found then
                        -- Opsional: Jalan ke posisi spawn jika tidak ada item
                    end
                end
            end)
        end
    end
end)

-- Logika Walk Speed
spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            if _G.WalkSpeed then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
            end
        end
    end)
end)

-- Logika Jump Power
spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            if _G.JumpPower then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = _G.JumpPower
            end
        end
    end)
end)


-- 5. MENAMBAHKAN ELEMEN KE UI (BUTTONS, TOGGLES, SLIDERS)

--- FITUR AUTO FARM ---
FarmTab:AddToggle({
    Name = "Auto Farm Items",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        OrionLib:MakeNotification({
            Name = "Status",
            Content = "Auto Farm: " .. tostring(Value),
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end    
})

FarmTab:AddSlider({
    Name = "Farm Speed",
    Min = 0.1,
    Max = 2,
    Default = 0.5,
    Color = Color3.fromRGB(255, 100, 100),
    Increment = 0.1,
    ValueName = "Detik",
    Callback = function(Value)
        _G.FarmSpeed = Value
    end    
})

--- FITUR PLAYER ---
PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(100, 255, 100),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        _G.WalkSpeed = Value
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(100, 100, 255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        _G.JumpPower = Value
    end    
})

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.InfJump = Value
        -- Logika Infinite Jump sederhana
        game:GetService("UserInputService").JumpRequest:connect(function()
            if _G.InfJump then
                game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
            end
        end)
    end    
})

--- FITUR MISC ---
MiscTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
})

MiscTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:BreakJoints()
    end
})

-- 6. INISIALISASI AKHIR
OrionLib:Init()