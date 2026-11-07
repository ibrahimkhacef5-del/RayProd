--[[
	Rayflide Pro By Ibrahim
	
	For Delta and ......
	
	If want any help 
	
	my Instagram :https://Instagram.com/uzcawe
]]

local Rayflide = {
	Version = "1.0.0",
	Flags = {},
	Theme = {},
	Connections = {},
	Windows = {},
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility
local function ProtectGui(gui)
	if syn and syn.protect_gui then
		pcall(syn.protect_gui, gui)
	elseif protect_gui then
		pcall(protect_gui, gui)
	end
	if gethui then
		gui.Parent = gethui()
	else
		gui.Parent = CoreGui
	end
end

local function Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	if props and props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

local function Tween(obj, props, time, style, dir)
	local t = TweenService:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function Round(num, places)
	local mult = 10 ^ (places or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Default Theme (Dark modern)
local DefaultTheme = {
	Background = Color3.fromRGB(18, 18, 22),
	Topbar = Color3.fromRGB(28, 28, 34),
	ElementBackground = Color3.fromRGB(32, 32, 40),
	ElementBackgroundHover = Color3.fromRGB(42, 42, 52),
	TextColor = Color3.fromRGB(240, 240, 245),
	SubTextColor = Color3.fromRGB(160, 160, 175),
	Accent = Color3.fromRGB(99, 102, 241), -- Indigo
	AccentHover = Color3.fromRGB(129, 132, 255),
	Success = Color3.fromRGB(34, 197, 94),
	Warning = Color3.fromRGB(234, 179, 8),
	Error = Color3.fromRGB(239, 68, 68),
	Stroke = Color3.fromRGB(55, 55, 70),
	Shadow = Color3.fromRGB(0, 0, 0),
	ToggleOn = Color3.fromRGB(99, 102, 241),
	ToggleOff = Color3.fromRGB(60, 60, 75),
}

Rayflide.Theme.Default = DefaultTheme
Rayflide.Theme.Current = table.clone(DefaultTheme)

-- Themes
Rayflide.Theme.Dark = DefaultTheme
Rayflide.Theme.Light = {
	Background = Color3.fromRGB(245, 245, 250),
	Topbar = Color3.fromRGB(255, 255, 255),
	ElementBackground = Color3.fromRGB(255, 255, 255),
	ElementBackgroundHover = Color3.fromRGB(240, 240, 248),
	TextColor = Color3.fromRGB(20, 20, 30),
	SubTextColor = Color3.fromRGB(100, 100, 120),
	Accent = Color3.fromRGB(79, 70, 229),
	AccentHover = Color3.fromRGB(99, 90, 255),
	Success = Color3.fromRGB(22, 163, 74),
	Warning = Color3.fromRGB(202, 138, 4),
	Error = Color3.fromRGB(220, 38, 38),
	Stroke = Color3.fromRGB(220, 220, 230),
	Shadow = Color3.fromRGB(0, 0, 0),
	ToggleOn = Color3.fromRGB(79, 70, 229),
	ToggleOff = Color3.fromRGB(200, 200, 215),
}

Rayflide.Theme.Ocean = {
	Background = Color3.fromRGB(8, 20, 30),
	Topbar = Color3.fromRGB(12, 30, 45),
	ElementBackground = Color3.fromRGB(15, 35, 50),
	ElementBackgroundHover = Color3.fromRGB(20, 45, 65),
	TextColor = Color3.fromRGB(230, 245, 255),
	SubTextColor = Color3.fromRGB(140, 180, 200),
	Accent = Color3.fromRGB(14, 165, 233),
	AccentHover = Color3.fromRGB(56, 189, 248),
	Success = Color3.fromRGB(34, 197, 94),
	Warning = Color3.fromRGB(250, 204, 21),
	Error = Color3.fromRGB(248, 113, 113),
	Stroke = Color3.fromRGB(30, 60, 80),
	Shadow = Color3.fromRGB(0, 0, 0),
	ToggleOn = Color3.fromRGB(14, 165, 233),
	ToggleOff = Color3.fromRGB(40, 70, 90),
}

Rayflide.Theme.Crimson = {
	Background = Color3.fromRGB(22, 10, 12),
	Topbar = Color3.fromRGB(35, 15, 18),
	ElementBackground = Color3.fromRGB(40, 18, 22),
	ElementBackgroundHover = Color3.fromRGB(55, 25, 30),
	TextColor = Color3.fromRGB(255, 240, 242),
	SubTextColor = Color3.fromRGB(200, 150, 160),
	Accent = Color3.fromRGB(225, 29, 72),
	AccentHover = Color3.fromRGB(244, 63, 94),
	Success = Color3.fromRGB(34, 197, 94),
	Warning = Color3.fromRGB(250, 204, 21),
	Error = Color3.fromRGB(248, 113, 113),
	Stroke = Color3.fromRGB(70, 30, 40),
	Shadow = Color3.fromRGB(0, 0, 0),
	ToggleOn = Color3.fromRGB(225, 29, 72),
	ToggleOff = Color3.fromRGB(60, 30, 35),
}

-- Notification System
local NotificationHolder
local function EnsureNotificationHolder()
	if NotificationHolder and NotificationHolder.Parent then return NotificationHolder end
	NotificationHolder = Create("ScreenGui", {
		Name = "RayflideNotifications",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 999,
	})
	ProtectGui(NotificationHolder)

	local frame = Create("Frame", {
		Name = "Holder",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 320, 1, 0),
		Position = UDim2.new(1, -340, 0, 20),
		Parent = NotificationHolder,
	})
	Create("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = frame,
	})
	return NotificationHolder
end

function Rayflide:Notify(settings)
	settings = settings or {}
	local title = settings.Title or "Notification"
	local content = settings.Content or ""
	local duration = settings.Duration or 5
	local image = settings.Image

	local holder = EnsureNotificationHolder().Holder

	local notif = Create("Frame", {
		Name = "Notification",
		BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		Parent = holder,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = notif })
	Create("UIStroke", {
		Color = Rayflide.Theme.Current.Stroke,
		Thickness = 1,
		Parent = notif,
	})

	local accent = Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.Accent,
		Size = UDim2.new(0, 4, 1, 0),
		BorderSizePixel = 0,
		Parent = notif,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = accent })

	local titleLabel = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 10),
		Size = UDim2.new(1, -50, 0, 20),
		Font = Enum.Font.GothamBold,
		Text = title,
		TextColor3 = Rayflide.Theme.Current.TextColor,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = notif,
	})

	local contentLabel = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 32),
		Size = UDim2.new(1, -30, 0, 0),
		Font = Enum.Font.Gotham,
		Text = content,
		TextColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 13,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = notif,
	})

	-- Auto size
	local textSize = game:GetService("TextService"):GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(270, 1000))
	local height = math.max(60, 45 + textSize.Y)
	contentLabel.Size = UDim2.new(1, -30, 0, textSize.Y + 5)

	notif.Size = UDim2.new(1, 0, 0, height)

	-- Animate in
	notif.BackgroundTransparency = 1
	titleLabel.TextTransparency = 1
	contentLabel.TextTransparency = 1
	Tween(notif, { BackgroundTransparency = 0 }, 0.3)
	Tween(titleLabel, { TextTransparency = 0 }, 0.3)
	Tween(contentLabel, { TextTransparency = 0 }, 0.3)

	task.delay(duration, function()
		if notif and notif.Parent then
			Tween(notif, { BackgroundTransparency = 1 }, 0.25)
			Tween(titleLabel, { TextTransparency = 1 }, 0.25)
			Tween(contentLabel, { TextTransparency = 1 }, 0.25)
			task.wait(0.3)
			notif:Destroy()
		end
	end)

	return notif
end

-- Main CreateWindow
function Rayflide:CreateWindow(settings)
	settings = settings or {}
	local windowName = settings.Name or "Rayflide Window"
	local loadingTitle = settings.LoadingTitle or "Rayflide"
	local loadingSubtitle = settings.LoadingSubtitle or "Professional UI Library"
	local themeName = settings.Theme or "Default"
	local configSaving = settings.ConfigurationSaving or { Enabled = false }
	local keySystem = settings.KeySystem or false
	local keySettings = settings.KeySettings or {}

	if Rayflide.Theme[themeName] then
		Rayflide.Theme.Current = table.clone(Rayflide.Theme[themeName])
	end

	-- ScreenGui
	local ScreenGui = Create("ScreenGui", {
		Name = "Rayflide_" .. HttpService:GenerateGUID(false):sub(1, 8),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100,
	})
	ProtectGui(ScreenGui)

	-- Main Frame
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local mainSize = isMobile and UDim2.new(0, 340, 0, 420) or UDim2.new(0, 520, 0, 480)

	local Main = Create("Frame", {
		Name = "Main",
		BackgroundColor3 = Rayflide.Theme.Current.Background,
		Size = mainSize,
		Position = UDim2.new(0.5, -mainSize.X.Offset/2, 0.5, -mainSize.Y.Offset/2),
		ClipsDescendants = true,
		Parent = ScreenGui,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })
	Create("UIStroke", {
		Color = Rayflide.Theme.Current.Stroke,
		Thickness = 1.2,
		Parent = Main,
	})

	-- Shadow
	local Shadow = Create("ImageLabel", {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 40, 1, 40),
		Position = UDim2.new(0, -20, 0, -20),
		Image = "rbxassetid://6014261993",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		ZIndex = 0,
		Parent = Main,
	})

	-- Topbar
	local Topbar = Create("Frame", {
		Name = "Topbar",
		BackgroundColor3 = Rayflide.Theme.Current.Topbar,
		Size = UDim2.new(1, 0, 0, 42),
		BorderSizePixel = 0,
		Parent = Main,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Topbar })
	-- Fix bottom corners of topbar
	Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.Topbar,
		Size = UDim2.new(1, 0, 0, 15),
		Position = UDim2.new(0, 0, 1, -15),
		BorderSizePixel = 0,
		Parent = Topbar,
	})

	local Title = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -120, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = windowName,
		TextColor3 = Rayflide.Theme.Current.TextColor,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Topbar,
	})

	-- Window Controls
	local function MakeControl(text, color, pos)
		local btn = Create("TextButton", {
			BackgroundColor3 = color,
			Size = UDim2.new(0, 14, 0, 14),
			Position = pos,
			Text = "",
			AutoButtonColor = false,
			Parent = Topbar,
		})
		Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
		return btn
	end

	local CloseBtn = MakeControl("", Color3.fromRGB(255, 95, 87), UDim2.new(1, -22, 0.5, -7))
	local MinBtn = MakeControl("", Color3.fromRGB(255, 189, 46), UDim2.new(1, -42, 0.5, -7))
	local MaxBtn = MakeControl("", Color3.fromRGB(40, 200, 64), UDim2.new(1, -62, 0.5, -7))

	-- Tab Container
	local TabContainer = Create("Frame", {
		Name = "TabContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, isMobile and 70 or 140, 1, -42),
		Position = UDim2.new(0, 0, 0, 42),
		Parent = Main,
	})

	local TabList = Create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Rayflide.Theme.Current.Accent,
		BorderSizePixel = 0,
		Parent = TabContainer,
	})
	Create("UIListLayout", {
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = TabList,
	})
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		Parent = TabList,
	})

	-- Content Area
	local Content = Create("Frame", {
		Name = "Content",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, isMobile and -70 or -140, 1, -42),
		Position = UDim2.new(0, isMobile and 70 or 140, 0, 42),
		ClipsDescendants = true,
		Parent = Main,
	})

	local Pages = Create("Folder", { Name = "Pages", Parent = Content })

	-- Dragging
	local dragging, dragStart, startPos
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- Minimize / Close
	local minimized = false
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Tween(Main, { Size = UDim2.new(0, mainSize.X.Offset, 0, 42) }, 0.3)
		else
			Tween(Main, { Size = mainSize }, 0.3)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, 0.25)
		task.wait(0.3)
		ScreenGui:Destroy()
	end)

	-- Window Object
	local Window = {
		Tabs = {},
		SelectedTab = nil,
		Main = Main,
		ScreenGui = ScreenGui,
	}

	function Window:CreateTab(name, icon)
		name = name or "Tab"
		local tabButton = Create("TextButton", {
			Name = name,
			BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
			Size = UDim2.new(1, isMobile and -12 or -20, 0, isMobile and 48 or 40),
			Text = "",
			AutoButtonColor = false,
			Parent = TabList,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = tabButton })

		local tabIcon = Create("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, isMobile and 14 or 12, 0.5, -10),
			Image = typeof(icon) == "number" and ("rbxassetid://" .. icon) or (icon or ""),
			ImageColor3 = Rayflide.Theme.Current.SubTextColor,
			Parent = tabButton,
		})

		local tabLabel = Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, isMobile and 42 or 40, 0, 0),
			Size = UDim2.new(1, -50, 1, 0),
			Font = Enum.Font.GothamMedium,
			Text = name,
			TextColor3 = Rayflide.Theme.Current.SubTextColor,
			TextSize = isMobile and 13 or 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = not isMobile,
			Parent = tabButton,
		})

		-- Page
		local page = Create("ScrollingFrame", {
			Name = name,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Rayflide.Theme.Current.Accent,
			BorderSizePixel = 0,
			Visible = false,
			Parent = Pages,
		})
		local pageLayout = Create("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = page,
		})
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			Parent = page,
		})

		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 24)
		end)

		local Tab = {
			Name = name,
			Button = tabButton,
			Page = page,
			Elements = {},
		}

		local function Select()
			for _, t in pairs(Window.Tabs) do
				t.Page.Visible = false
				Tween(t.Button, { BackgroundColor3 = Rayflide.Theme.Current.ElementBackground }, 0.2)
				if t.Button:FindFirstChild("TextLabel") then
					t.Button.TextLabel.TextColor3 = Rayflide.Theme.Current.SubTextColor
				end
				if t.Button:FindFirstChild("ImageLabel") then
					t.Button.ImageLabel.ImageColor3 = Rayflide.Theme.Current.SubTextColor
				end
			end
			page.Visible = true
			Tween(tabButton, { BackgroundColor3 = Rayflide.Theme.Current.Accent }, 0.2)
			tabLabel.TextColor3 = Color3.new(1, 1, 1)
			tabIcon.ImageColor3 = Color3.new(1, 1, 1)
			Window.SelectedTab = Tab
		end

		tabButton.MouseButton1Click:Connect(Select)

		-- First tab auto select
		if #Window.Tabs == 0 then
			task.defer(Select)
		end

		table.insert(Window.Tabs, Tab)

		-- Update canvas
		TabList.CanvasSize = UDim2.new(0, 0, 0, TabList.UIListLayout.AbsoluteContentSize.Y + 20)

		-- Element creators
		function Tab:CreateSection(sectionName)
			local section = Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 28),
				Parent = page,
			})
			local label = Create("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.GothamBold,
				Text = sectionName or "Section",
				TextColor3 = Rayflide.Theme.Current.Accent,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = section,
			})
			return {
				Set = function(_, text)
					label.Text = text
				end
			}
		end

		function Tab:CreateButton(opts)
			opts = opts or {}
			local btnFrame = Create("TextButton", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 40),
				Text = "",
				AutoButtonColor = false,
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btnFrame })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = btnFrame })

			local btnLabel = Create("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -20, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Button",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btnFrame,
			})

			btnFrame.MouseEnter:Connect(function()
				Tween(btnFrame, { BackgroundColor3 = Rayflide.Theme.Current.ElementBackgroundHover }, 0.15)
			end)
			btnFrame.MouseLeave:Connect(function()
				Tween(btnFrame, { BackgroundColor3 = Rayflide.Theme.Current.ElementBackground }, 0.15)
			end)
			btnFrame.MouseButton1Click:Connect(function()
				if opts.Callback then
					task.spawn(opts.Callback)
				end
			end)

			return {
				Set = function(_, text) btnLabel.Text = text end,
			}
		end

		function Tab:CreateToggle(opts)
			opts = opts or {}
			local flag = opts.Flag
			local current = opts.CurrentValue or false
			if flag then Rayflide.Flags[flag] = current end

			local toggleFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 42),
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = toggleFrame })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = toggleFrame })

			local label = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -70, 1, 0),
				Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Toggle",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = toggleFrame,
			})

			local switchBg = Create("Frame", {
				BackgroundColor3 = current and Rayflide.Theme.Current.ToggleOn or Rayflide.Theme.Current.ToggleOff,
				Size = UDim2.new(0, 42, 0, 24),
				Position = UDim2.new(1, -54, 0.5, -12),
				Parent = toggleFrame,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = switchBg })

			local circle = Create("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.new(0, 18, 0, 18),
				Position = current and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				Parent = switchBg,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = circle })

			local function Set(value)
				current = value
				if flag then Rayflide.Flags[flag] = value end
				Tween(switchBg, { BackgroundColor3 = value and Rayflide.Theme.Current.ToggleOn or Rayflide.Theme.Current.ToggleOff }, 0.2)
				Tween(circle, { Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
				if opts.Callback then
					task.spawn(opts.Callback, value)
				end
			end

			local clickBtn = Create("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				Parent = toggleFrame,
			})
			clickBtn.MouseButton1Click:Connect(function()
				Set(not current)
			end)

			return {
				Set = Set,
				Get = function() return current end,
			}
		end

		function Tab:CreateSlider(opts)
			opts = opts or {}
			local min, max = (opts.Range and opts.Range[1]) or 0, (opts.Range and opts.Range[2]) or 100
			local increment = opts.Increment or 1
			local current = opts.CurrentValue or min
			local flag = opts.Flag
			if flag then Rayflide.Flags[flag] = current end

			local sliderFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 58),
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = sliderFrame })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = sliderFrame })

			local label = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 6),
				Size = UDim2.new(0.6, 0, 0, 18),
				Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Slider",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = sliderFrame,
			})

			local valueLabel = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.6, 0, 0, 6),
				Size = UDim2.new(0.4, -12, 0, 18),
				Font = Enum.Font.Gotham,
				Text = tostring(current) .. (opts.Suffix or ""),
				TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = sliderFrame,
			})

			local barBg = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ToggleOff,
				Size = UDim2.new(1, -24, 0, 6),
				Position = UDim2.new(0, 12, 0, 36),
				Parent = sliderFrame,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barBg })

			local barFill = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.Accent,
				Size = UDim2.new((current - min) / (max - min), 0, 1, 0),
				Parent = barBg,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barFill })

			local function Set(val)
				val = math.clamp(Round(val / increment) * increment, min, max)
				current = val
				if flag then Rayflide.Flags[flag] = val end
				barFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
				valueLabel.Text = tostring(val) .. (opts.Suffix or "")
				if opts.Callback then
					task.spawn(opts.Callback, val)
				end
			end

			local sliding = false
			barBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
					Set(min + (max - min) * rel)
				end
			end)

			return { Set = Set, Get = function() return current end }
		end

		function Tab:CreateInput(opts)
			opts = opts or {}
			local flag = opts.Flag
			local current = opts.CurrentValue or ""
			if flag then Rayflide.Flags[flag] = current end

			local inputFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 42),
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = inputFrame })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = inputFrame })

			local label = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(0.35, 0, 1, 0),
				Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Input",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = inputFrame,
			})

			local box = Create("TextBox", {
				BackgroundColor3 = Rayflide.Theme.Current.Background,
				Position = UDim2.new(0.38, 0, 0.5, -14),
				Size = UDim2.new(0.58, -8, 0, 28),
				Font = Enum.Font.Gotham,
				Text = current,
				PlaceholderText = opts.PlaceholderText or "Type here...",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				PlaceholderColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13,
				ClearTextOnFocus = false,
				Parent = inputFrame,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = box })

			box.FocusLost:Connect(function(enter)
				current = box.Text
				if flag then Rayflide.Flags[flag] = current end
				if opts.Callback then
					task.spawn(opts.Callback, current)
				end
			end)

			return {
				Set = function(_, text)
					box.Text = text
					current = text
					if flag then Rayflide.Flags[flag] = text end
				end,
				Get = function() return current end,
			}
		end

		function Tab:CreateDropdown(opts)
			opts = opts or {}
			local options = opts.Options or { "Option 1", "Option 2" }
			local current = opts.CurrentOption or options[1]
			local flag = opts.Flag
			if flag then Rayflide.Flags[flag] = current end
			local multi = opts.MultipleOptions or false

			local dropFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 42),
				ClipsDescendants = true,
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = dropFrame })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = dropFrame })

			local label = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(0.5, 0, 0, 42),
				Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Dropdown",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = dropFrame,
			})

			local selectedLabel = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, -30, 0, 42),
				Font = Enum.Font.Gotham,
				Text = typeof(current) == "table" and table.concat(current, ", ") or tostring(current),
				TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = dropFrame,
			})

			local arrow = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -24, 0, 0),
				Size = UDim2.new(0, 20, 0, 42),
				Font = Enum.Font.GothamBold,
				Text = "▾",
				TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 14,
				Parent = dropFrame,
			})

			local open = false
			local optionButtons = {}

			local function Toggle()
				open = not open
				local targetHeight = open and (42 + #options * 32 + 8) or 42
				Tween(dropFrame, { Size = UDim2.new(1, 0, 0, targetHeight) }, 0.25)
				arrow.Text = open and "▴" or "▾"
			end

			local clickArea = Create("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 42),
				Text = "",
				Parent = dropFrame,
			})
			clickArea.MouseButton1Click:Connect(Toggle)

			for i, opt in ipairs(options) do
				local optBtn = Create("TextButton", {
					BackgroundColor3 = Rayflide.Theme.Current.Background,
					Size = UDim2.new(1, -16, 0, 28),
					Position = UDim2.new(0, 8, 0, 42 + (i - 1) * 32),
					Text = opt,
					Font = Enum.Font.Gotham,
					TextColor3 = Rayflide.Theme.Current.TextColor,
					TextSize = 13,
					AutoButtonColor = false,
					Parent = dropFrame,
				})
				Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = optBtn })
				optBtn.MouseButton1Click:Connect(function()
					if multi then
						-- simple multi support
						current = current or {}
						local idx = table.find(current, opt)
						if idx then
							table.remove(current, idx)
						else
							table.insert(current, opt)
						end
						selectedLabel.Text = #current > 0 and table.concat(current, ", ") or "None"
					else
						current = opt
						selectedLabel.Text = opt
						Toggle()
					end
					if flag then Rayflide.Flags[flag] = current end
					if opts.Callback then
						task.spawn(opts.Callback, current)
					end
				end)
				table.insert(optionButtons, optBtn)
			end

			return {
				Set = function(_, val)
					current = val
					selectedLabel.Text = typeof(val) == "table" and table.concat(val, ", ") or tostring(val)
					if flag then Rayflide.Flags[flag] = val end
				end,
				Get = function() return current end,
			}
		end

		function Tab:CreateLabel(opts)
			opts = opts or {}
			local labelFrame = Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 24),
				Parent = page,
			})
			local text = Create("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.Gotham,
				Text = opts.Text or opts.Name or "Label",
				TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Parent = labelFrame,
			})
			return {
				Set = function(_, t) text.Text = t end,
			}
		end

		function Tab:CreateParagraph(opts)
			opts = opts or {}
			local para = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 0),
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = para })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = para })

			local title = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 8),
				Size = UDim2.new(1, -24, 0, 18),
				Font = Enum.Font.GothamBold,
				Text = opts.Title or "Paragraph",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = para,
			})

			local content = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 30),
				Size = UDim2.new(1, -24, 0, 0),
				Font = Enum.Font.Gotham,
				Text = opts.Content or "",
				TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = para,
			})

			local size = game:GetService("TextService"):GetTextSize(opts.Content or "", 13, Enum.Font.Gotham, Vector2.new(page.AbsoluteSize.X - 48, 2000))
			content.Size = UDim2.new(1, -24, 0, size.Y + 4)
			para.Size = UDim2.new(1, 0, 0, 42 + size.Y)

			return {
				Set = function(_, t, c)
					if t then title.Text = t end
					if c then
						content.Text = c
						local s = game:GetService("TextService"):GetTextSize(c, 13, Enum.Font.Gotham, Vector2.new(page.AbsoluteSize.X - 48, 2000))
						content.Size = UDim2.new(1, -24, 0, s.Y + 4)
						para.Size = UDim2.new(1, 0, 0, 42 + s.Y)
					end
				end
			}
		end

		function Tab:CreateKeybind(opts)
			opts = opts or {}
			local current = opts.CurrentKeybind or "E"
			local flag = opts.Flag
			if flag then Rayflide.Flags[flag] = current end

			local kbFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 42),
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = kbFrame })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = kbFrame })

			local label = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(0.6, 0, 1, 0),
				Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Keybind",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = kbFrame,
			})

			local keyBtn = Create("TextButton", {
				BackgroundColor3 = Rayflide.Theme.Current.Background,
				Position = UDim2.new(1, -90, 0.5, -12),
				Size = UDim2.new(0, 78, 0, 24),
				Font = Enum.Font.GothamBold,
				Text = current,
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 12,
				AutoButtonColor = false,
				Parent = kbFrame,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyBtn })

			local listening = false
			keyBtn.MouseButton1Click:Connect(function()
				listening = true
				keyBtn.Text = "..."
			end)

			UserInputService.InputBegan:Connect(function(input, gpe)
				if listening and not gpe then
					local key = input.KeyCode.Name
					if key ~= "Unknown" then
						current = key
						keyBtn.Text = key
						listening = false
						if flag then Rayflide.Flags[flag] = key end
						if opts.Callback then
							task.spawn(opts.Callback, key)
						end
					end
				elseif not gpe and input.KeyCode.Name == current and opts.Callback then
					-- hold / press logic can be extended
				end
			end)

			return {
				Set = function(_, k)
					current = k
					keyBtn.Text = k
					if flag then Rayflide.Flags[flag] = k end
				end,
				Get = function() return current end,
			}
		end

		function Tab:CreateColorPicker(opts)
			opts = opts or {}
			local current = opts.Color or Color3.fromRGB(99, 102, 241)
			local flag = opts.Flag
			if flag then Rayflide.Flags[flag] = current end

			local cpFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 42),
				Parent = page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = cpFrame })
			Create("UIStroke", { Color = Rayflide.Theme.Current.Stroke, Thickness = 1, Parent = cpFrame })

			local label = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -60, 1, 0),
				Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Color",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = cpFrame,
			})

			local preview = Create("Frame", {
				BackgroundColor3 = current,
				Position = UDim2.new(1, -42, 0.5, -12),
				Size = UDim2.new(0, 30, 0, 24),
				Parent = cpFrame,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = preview })

			-- Simple cycle for demo (can be expanded to full picker)
			local colors = {
				Color3.fromRGB(99, 102, 241),
				Color3.fromRGB(239, 68, 68),
				Color3.fromRGB(34, 197, 94),
				Color3.fromRGB(234, 179, 8),
				Color3.fromRGB(14, 165, 233),
				Color3.fromRGB(168, 85, 247),
			}
			local idx = 1
			local btn = Create("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				Parent = cpFrame,
			})
			btn.MouseButton1Click:Connect(function()
				idx = idx % #colors + 1
				current = colors[idx]
				preview.BackgroundColor3 = current
				if flag then Rayflide.Flags[flag] = current end
				if opts.Callback then
					task.spawn(opts.Callback, current)
				end
			end)

			return {
				Set = function(_, c)
					current = c
					preview.BackgroundColor3 = c
					if flag then Rayflide.Flags[flag] = c end
				end,
				Get = function() return current end,
			}
		end

		return Tab
	end

	-- Config system (basic)
	if configSaving.Enabled then
		local folder = configSaving.FolderName or "Rayflide"
		local file = (configSaving.FileName or "config") .. ".json"

		function Window:SaveConfig()
			if writefile then
				local data = HttpService:JSONEncode(Rayflide.Flags)
				pcall(writefile, folder .. "/" .. file, data)
			end
		end

		function Window:LoadConfig()
			if isfile and isfile(folder .. "/" .. file) then
				local success, data = pcall(function()
					return HttpService:JSONDecode(readfile(folder .. "/" .. file))
				end)
				if success and data then
					for flag, value in pairs(data) do
						Rayflide.Flags[flag] = value
					end
				end
			end
		end

		-- Auto load
		task.defer(function()
			Window:LoadConfig()
		end)
	end

	function Window:Destroy()
		ScreenGui:Destroy()
	end

	table.insert(Rayflide.Windows, Window)

	-- Loading screen simulation
	local Loading = Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.Background,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = Main,
		ZIndex = 10,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Loading })

	local loadTitle = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0.4, 0),
		Size = UDim2.new(1, 0, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = loadingTitle,
		TextColor3 = Rayflide.Theme.Current.TextColor,
		TextSize = 22,
		Parent = Loading,
	})
	local loadSub = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0.4, 32),
		Size = UDim2.new(1, 0, 0, 20),
		Font = Enum.Font.Gotham,
		Text = loadingSubtitle,
		TextColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 14,
		Parent = Loading,
	})

	task.spawn(function()
		task.wait(0.8)
		Tween(Loading, { BackgroundTransparency = 1 }, 0.4)
		Tween(loadTitle, { TextTransparency = 1 }, 0.4)
		Tween(loadSub, { TextTransparency = 1 }, 0.4)
		task.wait(0.45)
		Loading:Destroy()
	end)

	return Window
end

-- Global helpers
function Rayflide:SetTheme(name)
	if Rayflide.Theme[name] then
		Rayflide.Theme.Current = table.clone(Rayflide.Theme[name])
		-- Note: full live theme switch would require recoloring all elements
		-- For production you can extend this
	end
end

function Rayflide:Destroy()
	for _, w in pairs(Rayflide.Windows) do
		if w.ScreenGui then
			w.ScreenGui:Destroy()
		end
	end
	Rayflide.Windows = {}
end

return Rayflide
