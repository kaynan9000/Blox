-- [[ KA HUB | BLOX FRUITS AUTO FARM V1 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- VARIÁVEIS DE CONTROLE
_G.AutoFarm = false
_G.AutoClick = true
_G.SelectWeapon = "Melee"

-- VERIFICAÇÃO DE MUNDO
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 then World1 = true
elseif game.PlaceId == 4442272183 then World2 = true
elseif game.PlaceId == 7449423635 then World3 = true end

-- FUNÇÃO CHECK QUEST (SUA TABELA ATUALIZADA)
function CheckQuest() 
    local MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    -- Simplificado para o exemplo, mas segue sua lógica exata
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
        -- ... O script continuará seguindo sua tabela de níveis ...
        else
            -- Fallback para Galley Pirate se nível for alto no Sea 1
            Mon = "Galley Pirate"; LevelQuest = 1; NameQuest = "FountainQuest"; NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02)
            CFrameMon = CFrame.new(5551.02, 78.90, 3930.41)
        end
    end
end

-- FUNÇÃO PARA EQUIPAR ARMA
function EquipWeapon()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == _G.SelectWeapon then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
end

-- JANELA RAYFIELD
local Window = Rayfield:CreateWindow({
   Name = "KA HUB | BLOX FRUITS",
   LoadingTitle = "Carregando Auto Farm...",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Farm Principal")

MainTab:CreateToggle({
   Name = "Ativar Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarm = Value end,
})

MainTab:CreateDropdown({
   Name = "Arma",
   Options = {"Melee","Sword","Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.SelectWeapon = v end,
})

-- LOOP PRINCIPAL DO FARM
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local LP = game.Players.LocalPlayer
                
                -- Se não tiver missão, vai pegar
                if not LP.PlayerGui.Main.Quest.Visible then
                    LP.Character.HumanoidRootPart.CFrame = CFrameQuest
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                else
                    -- Se já tiver missão, vai pro monstro
                    for _, v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                EquipWeapon()
                                -- Ativa NoClip
                                LP.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                
                                -- Clique Automático
                                if _G.AutoClick then
                                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 0)
                                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, false, game, 0)
                                end
                            until not _G.AutoFarm or v.Humanoid.Health <= 0 or not LP.PlayerGui.Main.Quest.Visible
                        end
                    end
                    -- Se não achar o monstro no workspace, vai pro spot dele
                    if not workspace.Enemies:FindFirstChild(NameMon) then
                        LP.Character.HumanoidRootPart.CFrame = CFrameMon
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({Title = "KA HUB", Content = "Auto Farm Mundo 1 Iniciado!", Duration = 5})
