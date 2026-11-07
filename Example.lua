--[[
	Rayflide Example Script
	Works perfectly on Delta, Solara, Wave, Codex, and most modern executors.
]]

local Rayflide = loadstring(game:HttpGet("YOUR_HOSTED_LINK_HERE"))() 
-- أو استخدم require لو حاطط الملف محلي

-- Alternative local load (for testing in executor with file system):
-- local Rayflide = loadstring(readfile("Rayflide.lua"))()

local Window = Rayflide:CreateWindow({
	Name = "Rayflide Hub",
	LoadingTitle = "Rayflide",
	LoadingSubtitle = "Best UI for Delta & Mobile",
	Theme = "Default", -- Default | Dark | Light | Ocean | Crimson
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "RayflideConfigs",
		FileName = "MyHub"
	},
	KeySystem = false,
})

-- ==================== MAIN TAB ====================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Player")

MainTab:CreateButton({
	Name = "Kill All (Client)",
	Callback = function()
		Rayflide:Notify({
			Title = "Success",
			Content = "Executed successfully!",
			Duration = 3
		})
	end
})

local SpeedToggle = MainTab:CreateToggle({
	Name = "Speed Boost",
	CurrentValue = false,
	Flag = "SpeedBoost",
	Callback = function(Value)
		local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		if hum then
			hum.WalkSpeed = Value and 50 or 16
		end
	end
})

MainTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {16, 200},
	Increment = 1,
	Suffix = " studs",
	CurrentValue = 16,
	Flag = "WalkSpeed",
	Callback = function(Value)
		local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		if hum then
			hum.WalkSpeed = Value
		end
	end
})

MainTab:CreateSlider({
	Name = "JumpPower",
	Range = {50, 300},
	Increment = 5,
	CurrentValue = 50,
	Flag = "JumpPower",
	Callback = function(Value)
		local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
		if hum then
			hum.JumpPower = Value
		end
	end
})

-- ==================== COMBAT TAB ====================
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateSection("Combat Options")

CombatTab:CreateToggle({
	Name = "Kill Aura",
	CurrentValue = false,
	Flag = "KillAura",
	Callback = function(Value)
		print("Kill Aura:", Value)
	end
})

CombatTab:CreateDropdown({
	Name = "Target Mode",
	Options = {"Nearest", "Lowest HP", "Highest HP", "Random"},
	CurrentOption = "Nearest",
	Flag = "TargetMode",
	Callback = function(Option)
		print("Selected:", Option)
	end
})

CombatTab:CreateKeybind({
	Name = "Toggle Fly",
	CurrentKeybind = "F",
	Flag = "FlyKey",
	Callback = function(Key)
		print("Fly key set to:", Key)
	end
})

-- ==================== VISUALS ====================
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateSection("ESP & Visuals")

VisualsTab:CreateToggle({
	Name = "Player ESP",
	CurrentValue = false,
	Flag = "ESP",
	Callback = function(Value)
		print("ESP:", Value)
	end
})

VisualsTab:CreateColorPicker({
	Name = "ESP Color",
	Color = Color3.fromRGB(99, 102, 241),
	Flag = "ESPColor",
	Callback = function(Color)
		print("New color:", Color)
	end
})

VisualsTab:CreateParagraph({
	Title = "Information",
	Content = "Rayflide is fully optimized for mobile executors like Delta. All elements support touch input and scale correctly on small screens."
})

-- ==================== SETTINGS ====================
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("UI Settings")

SettingsTab:CreateDropdown({
	Name = "Theme",
	Options = {"Default", "Dark", "Light", "Ocean", "Crimson"},
	CurrentOption = "Default",
	Callback = function(Option)
		Rayflide:SetTheme(Option)
		Rayflide:Notify({
			Title = "Theme Changed",
			Content = "Switched to " .. Option,
			Duration = 2
		})
	end
})

SettingsTab:CreateButton({
	Name = "Save Configuration",
	Callback = function()
		if Window.SaveConfig then
			Window:SaveConfig()
			Rayflide:Notify({Title = "Saved", Content = "Configuration saved successfully!", Duration = 3})
		end
	end
})

SettingsTab:CreateButton({
	Name = "Destroy UI",
	Callback = function()
		Window:Destroy()
	end
})

-- Notification example
task.wait(1.5)
Rayflide:Notify({
	Title = "Rayflide Loaded",
	Content = "Welcome! Library is ready for Delta & all modern executors.",
	Duration = 4
})
