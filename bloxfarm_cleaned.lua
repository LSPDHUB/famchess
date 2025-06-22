-- ✅ CONFIG
local CONFIG = {
    highChestOnly = true,
    autoChalice = true,
    autoBoss = true,
    targetItems = {
        "Dark Coat",
        "Dark Dagger",
        "Valkyrie Helm"
    },
    stopKey = Enum.KeyCode.Z,
}

-- 🔧 Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

-- 📦 Kiểm tra vật phẩm
local function hasItem(itemName)
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v.Name == itemName then
            return true
        end
    end
    return false
end

-- 🎯 Kiểm tra đủ vật phẩm mục tiêu
local function checkTargetItems()
    for _, item in pairs(CONFIG.targetItems) do
        if not hasItem(item) then
            return false
        end
    end
    return true
end

-- ⚔️ Auto Boss
local function spawnBoss()
    if CONFIG.autoBoss then
        local place = game.PlaceId
        if place == 7449423635 then -- Sea 2
            if hasItem("Dark Beard Key") then
                print("🔑 Tìm thấy Dark Beard Key! Đang triệu hồi Râu Đen...")
                -- TP đến Dark Arena
                -- Giả lập chạm bàn summon
                -- Farm Râu Đen
            end
        elseif place == 13822889 then -- Sea 3
            if hasItem("God Chalice") then
                print("⚔️ Đặt God Chalice để gọi Rip_Indra...")
                -- TP tới Castle bàn
                -- Đặt lên, farm boss
            end
        end
    end
end

-- 💰 Auto Farm Rương
local function autoFarmChest()
    task.spawn(function()
        while task.wait(1) do
            if not AllowRunService then break end

            if checkTargetItems() then
                print("🎯 Đã đủ đồ: Dark Coat / Dagger / Helm!")
                AllowRunService = false
                break
            end

            local chestNames = CONFIG.highChestOnly and {"Chest4", "Chest3", "Chest2"} or {"Chest4", "Chest3", "Chest2", "Chest1", "Chest"}
            for _, name in ipairs(chestNames) do
                local chest = workspace:FindFirstChild(name)
                if chest and LocalPlayer.Character then
                    pcall(function()
                        LocalPlayer.Character:PivotTo(chest:GetPivot())
                        firesignal(chest.Touched, LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                    end)
                    break
                end
            end
        end
    end)
end

-- 🛑 Dừng bằng phím Z
AllowRunService = true
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == CONFIG.stopKey then
        AllowRunService = false
        print("🛑 Script đã bị dừng bằng tay")
        StarterGui:SetCore("SendNotification", {
            Title = "Đã Dừng Script",
            Text = "Bấm Z để dừng thủ công",
            Duration = 5
        })
    end
end)

-- ⏳ Chờ Orin Hub load xong
repeat task.wait() until game:IsLoaded() and LocalPlayer:FindFirstChild("PlayerGui")
task.wait(5)

-- 🚀 Bắt đầu
spawnBoss()
autoFarmChest()
