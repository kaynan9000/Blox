-- [[ KA HUB | BLOX FRUITS V8 - FULL FARM & STATS ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- VARIÁVEIS DE CONTROLE
_G.AutoFarm = false
_G.AutoClick = true
_G.SelectWeapon = "Melee"
_G.AutoStats = false
_G.StatPoint = "Melee" -- Opções: Melee, Defense, Sword, Blox Fruit

local LP = game.Players.LocalPlayer
local World1 = (game.PlaceId == 2753915549)

-- [ SUA TABELA DE QUESTS INTEGRADA ]
function CheckQuest() 
    local MyLevel = LP.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"; LevelQuest = 1; NameQuest = "BanditQuest1"; NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42)
            CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"; LevelQuest = 1; NameQuest = "JungleQuest"; NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37)
            CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"; LevelQuest = 2; NameQuest = "JungleQuest"; NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37)
            CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"; LevelQuest = 1; NameQuest = "BuggyQuest1"; NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.54)
            CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        else
            -- Failsafe para níveis maiores no Sea 1
            Mon = "Galley Pirate"; LevelQuest = 1; NameQuest = "FountainQuest"; NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02)
            CFrameMon = CFrame.new(5551.02, 78.90, 3930.41)
        end
    end
end

-- [ JANELA PRINCIPAL ]
local Window = Rayfield:CreateWindow({
   Name = "KA HUB | Blox Fruits V8",
   LoadingTitle = "Iniciando Sistemas...",
   ConfigurationSaving = { Enabled = false }
})

-- ABA AUTO FARM
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "AUTO FARM LEVEL (Mundo 1)",
   CurrentValue = false,
   Callback = function(v) _G.AutoFarm = v end,
})

FarmTab:CreateDropdown({
   Name = "Arma Principal",
   Options = {"Melee", "Sword", "Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.SelectWeapon = v end,
})

-- ABA STATS (DISTRIBUIÇÃO AUTOMÁTICA)
local StatsTab = Window:CreateTab("Stats", 4483362458)

StatsTab:CreateToggle({
   Name = "Auto Distribuir Pontos",
   CurrentValue = false,
   Callback = function(v) _G.AutoStats = v end,
})

StatsTab:CreateDropdown({
   Name = "Focar em:",
   Options = {"Melee", "Defense", "Sword", "Blox Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.StatPoint = v end,
})

-- ABA VISUAL / FRUTAS
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateButton({
   Name = "Rastrear Frutas no Chão (ESP)",
   Callback = function()
       for _, v in pairs(workspace:GetChildren()) do
           if v:IsA("Tool") or (v:IsA("Model") and string.find(v.Name, "Fruit")) then
               local Billboard = Instance.new("BillboardGui", v)
               Billboard.Size = UDim2.new(0, 200, 0, 50)
               Billboard.AlwaysOnTop = true
               local Label = Instance.new("TextLabel", Billboard)
               Label.Text = "🍎 FRUTA: " .. v.Name
               Label.Size = UDim2.new(1, 0, 1, 0)
               Label.TextColor3 = Color3.new(1, 0, 0)
           end
       end
   end,
})

-- [ LOOP DO AUTO FARM ]
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                if not LP.PlayerGui.Main.Quest.Visible then
                    -- Vai pegar a missão
                    LP.Character.HumanoidRootPart.CFrame = CFrameQuest
                    task.wait(0.3)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                else
                    -- Vai matar os mobs
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                -- Ativa NoClip e posiciona em cima
                                for _, part in pairs(LP.Character:GetDescendants()) do
                                    if part:IsA("BasePart") then part.CanCollide = false end
                                end
                                LP.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                
                                -- Equipar Arma
                                for _, tool in pairs(LP.Backpack:GetChildren()) do
                                    if tool.ToolTip == _G.SelectWeapon then
                                        LP.Character.Humanoid:EquipTool(tool)
                                    end
                                end

                                -- Atacar
                                if _G.AutoClick then
                                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 0)
                                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, false, game, 0)
                                end
                            until not _G.AutoFarm or v.Humanoid.Health <= 0 or not LP.PlayerGui.Main.Quest.Visible
                        end
                    end
                    -- Se não houver mobs vivos, vai para o spawn deles esperar
                    if not workspace.Enemies:FindFirstChild(NameMon) then
                        LP.Character.HumanoidRootPart.CFrame = CFrameMon
                    end
                end
            end)
        end
    end
end)

-- [ LOOP DOS STATS ]
task.spawn(function()
    while task.wait(1) do
        if _G.AutoStats then
            local points = LP.Data.StatsPoints.Value
            if points > 0 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", _G.StatPoint, points)
            end
        end
    end
end)

Rayfield:Notify({Title = "KA HUB", Content = "Script de Blox Fruits Completo!", Duration = 5})
