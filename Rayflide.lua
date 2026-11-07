--[[
	Rayflide Pro v2.1.0
	Key System مدمج ومرن
]]

local Rayflide = {
	Version = "2.1.0",
	Flags = {},
	Theme = {},
	Connections = {},
	Windows = {},
	Keys = {},              -- 🔑 قائمة المفاتيح (تقدر تضيف فيها)
	AccessGranted = false,  -- هل تحقق المستخدم؟
	Hwid = nil,
	Defaults = {
		WindowSize = UDim2.fromOffset(600, 560),
		MinWindowSize = Vector2.new(420, 380),
		MaxWindowSize = Vector2.new(1000, 750),
		Corner = 10,
		AnimationSpeed = 0.22,
	},
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

-- UTILS
local function ProtectGui(gui)
	if syn and syn.protect_gui then pcall(syn.protect_gui, gui)
	elseif protect_gui then pcall(protect_gui, gui) end
	if gethui then gui.Parent = gethui() else gui.Parent = CoreGui end
end

local function Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do if k ~= "Parent" then obj[k] = v end end
	if props and props.Parent then obj.Parent = props.Parent end
	return obj
end

local function Tween(obj, props, time, style, dir)
	local t = TweenService:Create(obj, TweenInfo.new(time or 0.22, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

local function Round(num, places)
	local mult = 10 ^ (places or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function AddCorner(obj, r)
	return Create("UICorner", { CornerRadius = UDim.new(0, r or 10), Parent = obj })
end

local function AddStroke(obj, color, thickness)
	return Create("UIStroke", { Color = color or Rayflide.Theme.Current.Stroke, Thickness = thickness or 1, Parent = obj })
end

local function AddPadding(obj, all)
	local p = typeof(all) == "table" and all or { all, all, all, all }
	return Create("UIPadding", {
		PaddingTop = UDim.new(0, p[1] or 0), PaddingRight = UDim.new(0, p[2] or 0),
		PaddingBottom = UDim.new(0, p[3] or 0), PaddingLeft = UDim.new(0, p[4] or 0),
		Parent = obj,
	})
end

local function Ripple(button, color)
	local ripple = Create("Frame", {
		BackgroundColor3 = color or Rayflide.Theme.Current.Accent,
		BackgroundTransparency = 0.5,
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Parent = button,
	})
	AddCorner(ripple, 999)
	local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.8
	Tween(ripple, {
		Size = UDim2.fromOffset(maxSize, maxSize),
		Position = UDim2.new(0.5, -maxSize/2, 0.5, -maxSize/2),
		BackgroundTransparency = 1,
	}, 0.5)
	task.delay(0.55, function() if ripple and ripple.Parent then ripple:Destroy() end end)
end

local function GetHwid()
	local hwid = "unknown"
	pcall(function()
		if gethwid then hwid = gethwid()
		elseif syn and syn.get_hwid then hwid = syn.get_hwid()
		else
			local s, r = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
			if s and r then hwid = r end
		end
	end)
	return tostring(hwid)
end

Rayflide.Hwid = GetHwid()

-- THEMES
local DefaultTheme = {
	Background = Color3.fromRGB(18, 18, 22), Topbar = Color3.fromRGB(26, 26, 32),
	ElementBackground = Color3.fromRGB(32, 32, 40), ElementBackgroundHover = Color3.fromRGB(42, 42, 52),
	TextColor = Color3.fromRGB(240, 240, 245), SubTextColor = Color3.fromRGB(160, 160, 175),
	Accent = Color3.fromRGB(99, 102, 241), AccentHover = Color3.fromRGB(129, 132, 255),
	Success = Color3.fromRGB(34, 197, 94), Warning = Color3.fromRGB(234, 179, 8), Error = Color3.fromRGB(239, 68, 68),
	Stroke = Color3.fromRGB(55, 55, 70), ToggleOn = Color3.fromRGB(99, 102, 241),
	ToggleOff = Color3.fromRGB(60, 60, 75), SliderFill = Color3.fromRGB(99, 102, 241), SliderGrab = Color3.fromRGB(255, 255, 255),
}

Rayflide.Theme.Default = DefaultTheme
Rayflide.Theme.Current = table.clone(DefaultTheme)
Rayflide.Theme.Dark = table.clone(DefaultTheme)

Rayflide.Theme.Light = {
	Background = Color3.fromRGB(245, 245, 250), Topbar = Color3.fromRGB(255, 255, 255),
	ElementBackground = Color3.fromRGB(255, 255, 255), ElementBackgroundHover = Color3.fromRGB(240, 240, 248),
	TextColor = Color3.fromRGB(20, 20, 30), SubTextColor = Color3.fromRGB(100, 100, 120),
	Accent = Color3.fromRGB(79, 70, 229), AccentHover = Color3.fromRGB(99, 90, 255),
	Success = Color3.fromRGB(22, 163, 74), Warning = Color3.fromRGB(202, 138, 4), Error = Color3.fromRGB(220, 38, 38),
	Stroke = Color3.fromRGB(220, 220, 230), ToggleOn = Color3.fromRGB(79, 70, 229),
	ToggleOff = Color3.fromRGB(200, 200, 215), SliderFill = Color3.fromRGB(79, 70, 229), SliderGrab = Color3.fromRGB(255, 255, 255),
}

Rayflide.Theme.Ocean = {
	Background = Color3.fromRGB(8, 20, 30), Topbar = Color3.fromRGB(12, 30, 45),
	ElementBackground = Color3.fromRGB(15, 35, 50), ElementBackgroundHover = Color3.fromRGB(20, 45, 65),
	TextColor = Color3.fromRGB(230, 245, 255), SubTextColor = Color3.fromRGB(140, 180, 200),
	Accent = Color3.fromRGB(14, 165, 233), AccentHover = Color3.fromRGB(56, 189, 248),
	Success = Color3.fromRGB(34, 197, 94), Warning = Color3.fromRGB(250, 204, 21), Error = Color3.fromRGB(248, 113, 113),
	Stroke = Color3.fromRGB(30, 60, 80), ToggleOn = Color3.fromRGB(14, 165, 233),
	ToggleOff = Color3.fromRGB(40, 70, 90), SliderFill = Color3.fromRGB(14, 165, 233), SliderGrab = Color3.fromRGB(255, 255, 255),
}

Rayflide.Theme.Crimson = {
	Background = Color3.fromRGB(22, 10, 12), Topbar = Color3.fromRGB(35, 15, 18),
	ElementBackground = Color3.fromRGB(40, 18, 22), ElementBackgroundHover = Color3.fromRGB(55, 25, 30),
	TextColor = Color3.fromRGB(255, 240, 242), SubTextColor = Color3.fromRGB(200, 150, 160),
	Accent = Color3.fromRGB(225, 29, 72), AccentHover = Color3.fromRGB(244, 63, 94),
	Success = Color3.fromRGB(34, 197, 94), Warning = Color3.fromRGB(250, 204, 21), Error = Color3.fromRGB(248, 113, 113),
	Stroke = Color3.fromRGB(70, 30, 40), ToggleOn = Color3.fromRGB(225, 29, 72),
	ToggleOff = Color3.fromRGB(60, 30, 35), SliderFill = Color3.fromRGB(225, 29, 72), SliderGrab = Color3.fromRGB(255, 255, 255),
}

Rayflide.Theme.Neon = {
	Background = Color3.fromRGB(10, 8, 20), Topbar = Color3.fromRGB(18, 12, 35),
	ElementBackground = Color3.fromRGB(22, 16, 42), ElementBackgroundHover = Color3.fromRGB(30, 22, 55),
	TextColor = Color3.fromRGB(240, 230, 255), SubTextColor = Color3.fromRGB(170, 140, 220),
	Accent = Color3.fromRGB(180, 60, 255), AccentHover = Color3.fromRGB(210, 100, 255),
	Success = Color3.fromRGB(80, 255, 160), Warning = Color3.fromRGB(255, 220, 50), Error = Color3.fromRGB(255, 60, 120),
	Stroke = Color3.fromRGB(50, 35, 80), ToggleOn = Color3.fromRGB(180, 60, 255),
	ToggleOff = Color3.fromRGB(45, 35, 70), SliderFill = Color3.fromRGB(180, 60, 255), SliderGrab = Color3.fromRGB(255, 100, 255),
}

Rayflide.Theme.Midnight = {
	Background = Color3.fromRGB(8, 10, 18), Topbar = Color3.fromRGB(14, 18, 30),
	ElementBackground = Color3.fromRGB(20, 26, 40), ElementBackgroundHover = Color3.fromRGB(28, 36, 55),
	TextColor = Color3.fromRGB(220, 230, 250), SubTextColor = Color3.fromRGB(120, 140, 180),
	Accent = Color3.fromRGB(80, 100, 240), AccentHover = Color3.fromRGB(120, 140, 255),
	Success = Color3.fromRGB(60, 200, 120), Warning = Color3.fromRGB(240, 180, 60), Error = Color3.fromRGB(240, 80, 80),
	Stroke = Color3.fromRGB(40, 50, 75), ToggleOn = Color3.fromRGB(80, 100, 240),
	ToggleOff = Color3.fromRGB(40, 50, 75), SliderFill = Color3.fromRGB(80, 100, 240), SliderGrab = Color3.fromRGB(180, 200, 255),
}

Rayflide.Theme.Sunset = {
	Background = Color3.fromRGB(30, 12, 8), Topbar = Color3.fromRGB(45, 20, 12),
	ElementBackground = Color3.fromRGB(55, 25, 15), ElementBackgroundHover = Color3.fromRGB(70, 35, 22),
	TextColor = Color3.fromRGB(255, 240, 225), SubTextColor = Color3.fromRGB(210, 160, 120),
	Accent = Color3.fromRGB(255, 120, 40), AccentHover = Color3.fromRGB(255, 150, 70),
	Success = Color3.fromRGB(100, 220, 100), Warning = Color3.fromRGB(255, 200, 50), Error = Color3.fromRGB(255, 80, 80),
	Stroke = Color3.fromRGB(85, 40, 25), ToggleOn = Color3.fromRGB(255, 120, 40),
	ToggleOff = Color3.fromRGB(80, 40, 25), SliderFill = Color3.fromRGB(255, 120, 40), SliderGrab = Color3.fromRGB(255, 200, 150),
}

Rayflide.Theme.Emerald = {
	Background = Color3.fromRGB(8, 25, 18), Topbar = Color3.fromRGB(12, 35, 25),
	ElementBackground = Color3.fromRGB(15, 45, 32), ElementBackgroundHover = Color3.fromRGB(22, 58, 42),
	TextColor = Color3.fromRGB(220, 255, 240), SubTextColor = Color3.fromRGB(130, 210, 170),
	Accent = Color3.fromRGB(16, 185, 129), AccentHover = Color3.fromRGB(52, 211, 153),
	Success = Color3.fromRGB(52, 211, 153), Warning = Color3.fromRGB(250, 204, 21), Error = Color3.fromRGB(248, 113, 113),
	Stroke = Color3.fromRGB(30, 70, 50), ToggleOn = Color3.fromRGB(16, 185, 129),
	ToggleOff = Color3.fromRGB(35, 65, 50), SliderFill = Color3.fromRGB(16, 185, 129), SliderGrab = Color3.fromRGB(200, 255, 230),
}

Rayflide.Theme.Purple = {
	Background = Color3.fromRGB(22, 12, 35), Topbar = Color3.fromRGB(32, 18, 50),
	ElementBackground = Color3.fromRGB(42, 24, 65), ElementBackgroundHover = Color3.fromRGB(55, 32, 85),
	TextColor = Color3.fromRGB(245, 235, 255), SubTextColor = Color3.fromRGB(190, 160, 220),
	Accent = Color3.fromRGB(168, 85, 247), AccentHover = Color3.fromRGB(192, 120, 255),
	Success = Color3.fromRGB(74, 222, 128), Warning = Color3.fromRGB(250, 204, 21), Error = Color3.fromRGB(248, 113, 113),
	Stroke = Color3.fromRGB(70, 40, 100), ToggleOn = Color3.fromRGB(168, 85, 247),
	ToggleOff = Color3.fromRGB(60, 40, 85), SliderFill = Color3.fromRGB(168, 85, 247), SliderGrab = Color3.fromRGB(220, 190, 255),
}

Rayflide.Theme.Gold = {
	Background = Color3.fromRGB(25, 20, 8), Topbar = Color3.fromRGB(40, 32, 12),
	ElementBackground = Color3.fromRGB(52, 42, 18), ElementBackgroundHover = Color3.fromRGB(68, 55, 25),
	TextColor = Color3.fromRGB(255, 248, 220), SubTextColor = Color3.fromRGB(220, 190, 120),
	Accent = Color3.fromRGB(234, 179, 8), AccentHover = Color3.fromRGB(250, 204, 21),
	Success = Color3.fromRGB(100, 220, 100), Warning = Color3.fromRGB(250, 204, 21), Error = Color3.fromRGB(255, 90, 90),
	Stroke = Color3.fromRGB(80, 65, 25), ToggleOn = Color3.fromRGB(234, 179, 8),
	ToggleOff = Color3.fromRGB(75, 60, 25), SliderFill = Color3.fromRGB(234, 179, 8), SliderGrab = Color3.fromRGB(255, 240, 180),
}

Rayflide.Theme.Gray = {
	Background = Color3.fromRGB(28, 28, 30), Topbar = Color3.fromRGB(40, 40, 44),
	ElementBackground = Color3.fromRGB(52, 52, 58), ElementBackgroundHover = Color3.fromRGB(68, 68, 76),
	TextColor = Color3.fromRGB(240, 240, 245), SubTextColor = Color3.fromRGB(170, 170, 180),
	Accent = Color3.fromRGB(180, 180, 200), AccentHover = Color3.fromRGB(210, 210, 230),
	Success = Color3.fromRGB(100, 220, 130), Warning = Color3.fromRGB(230, 200, 80), Error = Color3.fromRGB(230, 100, 100),
	Stroke = Color3.fromRGB(80, 80, 90), ToggleOn = Color3.fromRGB(180, 180, 200),
	ToggleOff = Color3.fromRGB(70, 70, 80), SliderFill = Color3.fromRGB(180, 180, 200), SliderGrab = Color3.fromRGB(255, 255, 255),
}

Rayflide.Theme.Rose = {
	Background = Color3.fromRGB(30, 15, 22), Topbar = Color3.fromRGB(45, 22, 32),
	ElementBackground = Color3.fromRGB(58, 30, 42), ElementBackgroundHover = Color3.fromRGB(75, 40, 55),
	TextColor = Color3.fromRGB(255, 235, 245), SubTextColor = Color3.fromRGB(220, 160, 185),
	Accent = Color3.fromRGB(244, 114, 182), AccentHover = Color3.fromRGB(251, 146, 204),
	Success = Color3.fromRGB(100, 220, 130), Warning = Color3.fromRGB(250, 204, 21), Error = Color3.fromRGB(248, 113, 113),
	Stroke = Color3.fromRGB(95, 50, 68), ToggleOn = Color3.fromRGB(244, 114, 182),
	ToggleOff = Color3.fromRGB(75, 45, 60), SliderFill = Color3.fromRGB(244, 114, 182), SliderGrab = Color3.fromRGB(255, 200, 230),
}

-- ============================================================
-- 🔑 KEY SYSTEM (الجزء الأساسي)
-- ============================================================

--[[
	كيف تستخدم:
	
	-- 1. أضف مفاتيح (تقدر تضيف بأي وقت):
	Rayflide:AddKey("ABC123", {
		Tier = "VIP",       -- اختياري
		Uses = 5,           -- كم مرة يقدر يستخدم
		Expiry = os.time() + 86400,  -- اختياري
		Hwid = "abc...",    -- اختياري (ربط بجهاز)
	})
	
	-- 2. أضف مفاتيح بكمية دفعة واحدة:
	Rayflide:AddKeys({"KEY1", "KEY2", "KEY3"})
	
	-- 3. امسح مفتاح:
	Rayflide:RemoveKey("ABC123")
	
	-- 4. افتح شاشة المفاتيح:
	Rayflide:SetupKeySystem({
		Title = "My Hub",
		Subtitle = "أدخل مفتاحك",
		OnSuccess = function()
			print("تم التحقق!")
		end,
	})
	
	-- 5. تحقق برمجياً (بدون UI):
	local ok, msg = Rayflide:ValidateKey("ABC123")
	
	-- 6. تحقق من الوصول:
	if Rayflide:HasAccess() then
		-- مسموح
	end
	
	-- 7. تفعيل الوضع الإجباري:
	Rayflide.RequireAccess = true  -- CreateWindow ترجع nil بدون مفتاح
]]

Rayflide.RequireAccess = false  -- افتراضي: ما يجبر
Rayflide.AccessGranted = false
Rayflide.Keys = {}

-- إضافة مفتاح واحد
function Rayflide:AddKey(key, options)
	if not key or key == "" then return false end
	options = options or {}
	Rayflide.Keys[key] = {
		Tier = options.Tier or "Default",
		Uses = options.Uses or math.huge,
		Used = 0,
		Expiry = options.Expiry or nil,
		Hwid = options.Hwid or nil,
	}
	return true
end

-- إضافة مجموعة مفاتيح
function Rayflide:AddKeys(list, options)
	for _, key in ipairs(list) do
		Rayflide:AddKey(key, options)
	end
	return #list
end

-- إزالة مفتاح
function Rayflide:RemoveKey(key)
	if Rayflide.Keys[key] then
		Rayflide.Keys[key] = nil
		return true
	end
	return false
end

-- التحقق من مفتاح
function Rayflide:ValidateKey(key)
	if not key or key == "" then
		return false, "المفتاح فارغ"
	end
	local info = Rayflide.Keys[key]
	if not info then
		return false, "مفتاح غير صالح"
	end
	if info.Expiry and os.time() > info.Expiry then
		return false, "المفتاح منتهي الصلاحية"
	end
	if info.Hwid and info.Hwid ~= "" and info.Hwid ~= Rayflide.Hwid then
		return false, "المفتاح مربوط بجهاز آخر"
	end
	if info.Used >= info.Uses then
		return false, "المفتاح استنفد عدد الاستخدامات"
	end
	info.Used = info.Used + 1
	Rayflide.AccessGranted = true
	Rayflide.CurrentKey = key
	Rayflide.CurrentTier = info.Tier
	-- حفظ المفتاح
	if writefile then
		pcall(function()
			if not isfolder("Rayflide") then makefolder("Rayflide") end
			writefile("Rayflide/key.txt", key)
		end)
	end
	return true, "تم التحقق بنجاح"
end

-- هل المستخدم عنده وصول؟
function Rayflide:HasAccess()
	return Rayflide.AccessGranted == true
end

-- تحميل مفتاح محفوظ
function Rayflide:LoadSavedKey()
	if isfile and isfile("Rayflide/key.txt") then
		local ok, content = pcall(readfile, "Rayflide/key.txt")
		if ok and content then
			return Rayflide:ValidateKey(content)
		end
	end
	return false
end

-- عرض شاشة المفاتيح
function Rayflide:SetupKeySystem(opts)
	opts = opts or {}
	local title = opts.Title or "Rayflide"
	local subtitle = opts.Subtitle or "أدخل مفتاحك للوصول"
	local onSuccess = opts.OnSuccess

	local ScreenGui = Create("ScreenGui", {
		Name = "RayflideKeySystem",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 200,
	})
	ProtectGui(ScreenGui)

	local Main = Create("Frame", {
		Name = "Main",
		BackgroundColor3 = Rayflide.Theme.Current.Background,
		Size = UDim2.fromOffset(440, 380),
		Position = UDim2.new(0.5, -220, 0.5, -190),
		Parent = ScreenGui,
	})
	AddCorner(Main, 14)
	AddStroke(Main, Rayflide.Theme.Current.Stroke, 1.2)

	Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 25),
		Size = UDim2.new(1, 0, 0, 40),
		Font = Enum.Font.GothamBold,
		Text = "🔑",
		TextColor3 = Rayflide.Theme.Current.Accent,
		TextSize = 32,
		Parent = Main,
	})

	Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 70),
		Size = UDim2.new(1, 0, 0, 28),
		Font = Enum.Font.GothamBold,
		Text = title,
		TextColor3 = Rayflide.Theme.Current.TextColor,
		TextSize = 20,
		Parent = Main,
	})

	Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 100),
		Size = UDim2.new(1, 0, 0, 20),
		Font = Enum.Font.Gotham,
		Text = subtitle,
		TextColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 13,
		Parent = Main,
	})

	-- HWID
	local hwidLabel = Create("TextLabel", {
		BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
		Position = UDim2.new(0, 30, 0, 130),
		Size = UDim2.new(1, -100, 0, 30),
		Font = Enum.Font.Code,
		Text = "HWID: " .. string.sub(Rayflide.Hwid, 1, 22) .. "...",
		TextColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Main,
	})
	AddCorner(hwidLabel, 6)
	AddPadding(hwidLabel, { 0, 0, 0, 10 })

	local copyBtn = Create("TextButton", {
		BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
		Position = UDim2.new(1, -95, 0, 130),
		Size = UDim2.fromOffset(65, 30),
		Font = Enum.Font.Gotham,
		Text = "📋 نسخ",
		TextColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 11,
		AutoButtonColor = false,
		Parent = Main,
	})
	AddCorner(copyBtn, 6)
	copyBtn.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(Rayflide.Hwid)
			copyBtn.Text = "✓ تم"
			copyBtn.TextColor3 = Rayflide.Theme.Current.Success
			task.wait(1.5)
			copyBtn.Text = "📋 نسخ"
			copyBtn.TextColor3 = Rayflide.Theme.Current.SubTextColor
		end
	end)

	-- Input
	local input = Create("TextBox", {
		BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
		Position = UDim2.new(0, 30, 0, 175),
		Size = UDim2.new(1, -60, 0, 44),
		Font = Enum.Font.Gotham,
		Text = "",
		PlaceholderText = "أدخل المفتاح هنا...",
		TextColor3 = Rayflide.Theme.Current.TextColor,
		PlaceholderColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 14,
		ClearTextOnFocus = false,
		Parent = Main,
	})
	AddCorner(input, 8)
	AddStroke(input, Rayflide.Theme.Current.Stroke, 1)

	local statusLabel = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 30, 0, 225),
		Size = UDim2.new(1, -60, 0, 20),
		Font = Enum.Font.Gotham,
		Text = "",
		TextColor3 = Rayflide.Theme.Current.Error,
		TextSize = 12,
		Parent = Main,
	})

	local submitBtn = Create("TextButton", {
		BackgroundColor3 = Rayflide.Theme.Current.Accent,
		Position = UDim2.new(0, 30, 0, 255),
		Size = UDim2.new(1, -60, 0, 44),
		Font = Enum.Font.GothamBold,
		Text = "🔓 التحقق من المفتاح",
		TextColor3 = Color3.new(1,1,1),
		TextSize = 14,
		AutoButtonColor = false,
		Parent = Main,
	})
	AddCorner(submitBtn, 8)

	submitBtn.MouseButton1Click:Connect(function()
		local success, msg = Rayflide:ValidateKey(input.Text)
		if success then
			statusLabel.TextColor3 = Rayflide.Theme.Current.Success
			statusLabel.Text = "✓ " .. msg
			task.wait(0.8)
			Tween(Main, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }, 0.3)
			task.wait(0.35)
			ScreenGui:Destroy()
			if onSuccess then task.spawn(onSuccess) end
		else
			statusLabel.TextColor3 = Rayflide.Theme.Current.Error
			statusLabel.Text = "✗ " .. msg
			Tween(input, { Position = UDim2.new(0, 35, 0, 175) }, 0.05)
			task.wait(0.05)
			Tween(input, { Position = UDim2.new(0, 25, 0, 175) }, 0.05)
		end
	end)

	input.FocusLost:Connect(function(enter)
		if enter then submitBtn:GetPropertyChangedSignal end
	end)

	return ScreenGui
end

-- تحقق تلقائي عند تحميل المكتبة (إذا كان فيه مفتاح محفوظ)
task.defer(function()
	Rayflide:LoadSavedKey()
end)

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local NotificationHolder
local NotificationQueue = {}
local NotifBusy = false

local function EnsureNotificationHolder()
	if NotificationHolder and NotificationHolder.Parent then return NotificationHolder end
	NotificationHolder = Create("ScreenGui", {
		Name = "RayflideNotifications", ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999,
	})
	ProtectGui(NotificationHolder)
	local frame = Create("Frame", {
		Name = "Holder", BackgroundTransparency = 1,
		Size = UDim2.new(0, 340, 1, 0), Position = UDim2.new(1, -360, 0, 20),
		Parent = NotificationHolder,
	})
	Create("UIListLayout", {
		Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top, Parent = frame,
	})
	return NotificationHolder
end

local function ShowNotification(settings)
	local title = settings.Title or "Notification"
	local content = settings.Content or ""
	local duration = settings.Duration or 5
	local notifType = settings.Type or "info"
	local typeColors = {
		info = Rayflide.Theme.Current.Accent, success = Rayflide.Theme.Current.Success,
		warning = Rayflide.Theme.Current.Warning, error = Rayflide.Theme.Current.Error,
	}
	local holder = EnsureNotificationHolder().Holder
	local notif = Create("Frame", {
		Name = "Notification", BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
		Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, Parent = holder,
	})
	AddCorner(notif, 10)
	AddStroke(notif, Rayflide.Theme.Current.Stroke, 1)
	local accent = Create("Frame", {
		BackgroundColor3 = typeColors[notifType] or Rayflide.Theme.Current.Accent,
		Size = UDim2.new(0, 4, 1, 0), BorderSizePixel = 0, Parent = notif,
	})
	AddCorner(accent, 10)
	local titleLabel = Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 10),
		Size = UDim2.new(1, -50, 0, 20), Font = Enum.Font.GothamBold,
		Text = title, TextColor3 = Rayflide.Theme.Current.TextColor, TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left, Parent = notif,
	})
	local contentLabel = Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 32),
		Size = UDim2.new(1, -30, 0, 0), Font = Enum.Font.Gotham,
		Text = content, TextColor3 = Rayflide.Theme.Current.SubTextColor, TextSize = 13,
		TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top, Parent = notif,
	})
	local textSize = TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(280, 1000))
	local height = math.max(60, 45 + textSize.Y)
	contentLabel.Size = UDim2.new(1, -30, 0, textSize.Y + 5)
	notif.Size = UDim2.new(1, 0, 0, height)
	notif.BackgroundTransparency = 1
	titleLabel.TextTransparency = 1
	contentLabel.TextTransparency = 1
	notif.Position = UDim2.new(1, 340, 0, 0)
	Tween(notif, { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }, 0.3)
	Tween(titleLabel, { TextTransparency = 0 }, 0.3)
	Tween(contentLabel, { TextTransparency = 0 }, 0.3)
	task.delay(duration, function()
		if notif and notif.Parent then
			Tween(notif, { BackgroundTransparency = 1, Position = UDim2.new(1, 340, 0, 0) }, 0.3)
			Tween(titleLabel, { TextTransparency = 1 }, 0.3)
			Tween(contentLabel, { TextTransparency = 1 }, 0.3)
			task.wait(0.35)
			notif:Destroy()
		end
	end)
end

local function ProcessQueue()
	if NotifBusy then return end
	NotifBusy = true
	while #NotificationQueue > 0 do
		local notif = table.remove(NotificationQueue, 1)
		ShowNotification(notif)
		task.wait(0.3)
	end
	NotifBusy = false
end

function Rayflide:Notify(settings)
	table.insert(NotificationQueue, settings or {})
	ProcessQueue()
end

-- ============================================================
-- COLOR PICKER
-- ============================================================
local function OpenColorPicker(parent, startColor, callback)
	local modal = Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
		Size = UDim2.fromOffset(260, 320), Position = UDim2.new(0.5, -130, 0.5, -160),
		Parent = parent, ZIndex = 50,
	})
	AddCorner(modal, 12)
	AddStroke(modal, Rayflide.Theme.Current.Stroke, 1)
	Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8),
		Size = UDim2.new(1, -50, 0, 24), Font = Enum.Font.GothamBold,
		Text = "Pick Color", TextColor3 = Rayflide.Theme.Current.TextColor,
		TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = modal,
	})
	local closeBtn = Create("TextButton", {
		BackgroundTransparency = 1, Position = UDim2.new(1, -32, 0, 8),
		Size = UDim2.fromOffset(24, 24), Text = "✕", Font = Enum.Font.GothamBold,
		TextColor3 = Rayflide.Theme.Current.SubTextColor, TextSize = 14, Parent = modal,
	})
	closeBtn.MouseButton1Click:Connect(function() modal:Destroy() end)
	local h, s, v = startColor:ToHSV()
	local preview
	local function updatePreview()
		local color = Color3.fromHSV(h, s, v)
		preview.BackgroundColor3 = color
		callback(color)
	end
	preview = Create("Frame", {
		BackgroundColor3 = startColor, Position = UDim2.new(0, 12, 0, 40),
		Size = UDim2.new(1, -24, 0, 60), Parent = modal,
	})
	AddCorner(preview, 8)
	local function makeHSVSlider(name, y, value, max, onChange)
		Create("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, y),
			Size = UDim2.new(0, 20, 0, 18), Font = Enum.Font.GothamMedium,
			Text = name, TextColor3 = Rayflide.Theme.Current.TextColor,
			TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = modal,
		})
		local valLabel = Create("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, y),
			Size = UDim2.new(0, 50, 0, 18), Font = Enum.Font.Gotham,
			Text = tostring(math.floor(value * max)),
			TextColor3 = Rayflide.Theme.Current.SubTextColor, TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right, Parent = modal,
		})
		local barBg = Create("Frame", {
			BackgroundColor3 = Rayflide.Theme.Current.ToggleOff,
			Position = UDim2.new(0, 12, 0, y + 22), Size = UDim2.new(1, -24, 0, 8), Parent = modal,
		})
		AddCorner(barBg, 999)
		local barFill = Create("Frame", {
			BackgroundColor3 = Rayflide.Theme.Current.Accent,
			Size = UDim2.new(value, 0, 1, 0), Parent = barBg,
		})
		AddCorner(barFill, 999)
		local grab = Create("Frame", {
			BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.fromOffset(14, 14),
			Position = UDim2.new(value, -7, 0.5, -7), Parent = barBg,
		})
		AddCorner(grab, 999)
		local sliding = false
		local function update(x)
			local rel = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
			barFill.Size = UDim2.new(rel, 0, 1, 0)
			grab.Position = UDim2.new(rel, -7, 0.5, -7)
			valLabel.Text = tostring(math.floor(rel * max))
			onChange(rel)
		end
		barBg.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				sliding = true
				update(input.Position.X)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				update(input.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				sliding = false
			end
		end)
	end
	makeHSVSlider("H", 112, h, 360, function(rel) h = rel; updatePreview() end)
	makeHSVSlider("S", 168, s, 100, function(rel) s = rel; updatePreview() end)
	makeHSVSlider("V", 224, v, 100, function(rel) v = rel; updatePreview() end)
	local doneBtn = Create("TextButton", {
		BackgroundColor3 = Rayflide.Theme.Current.Accent,
		Position = UDim2.new(0, 12, 1, -46), Size = UDim2.new(1, -24, 0, 34),
		Font = Enum.Font.GothamBold, Text = "Done",
		TextColor3 = Color3.new(1,1,1), TextSize = 13, AutoButtonColor = false, Parent = modal,
	})
	AddCorner(doneBtn, 8)
	doneBtn.MouseButton1Click:Connect(function() modal:Destroy() end)
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
function Rayflide:CreateWindow(settings)
	settings = settings or {}
	-- 🔒 تحقق من الوصول
	if Rayflide.RequireAccess and not Rayflide:HasAccess() then
		warn("[Rayflide] Access denied - Key required")
		return nil
	end
	local windowName = settings.Name or "Rayflide Window"
	local loadingTitle = settings.LoadingTitle or "Rayflide"
	local loadingSubtitle = settings.LoadingSubtitle or "Professional UI Library"
	local themeName = settings.Theme or "Default"
	local configSaving = settings.ConfigurationSaving or { Enabled = false }
	local defaultSize = settings.Size or Rayflide.Defaults.WindowSize
	local resizable = settings.Resizable ~= false
	if Rayflide.Theme[themeName] then
		Rayflide.Theme.Current = table.clone(Rayflide.Theme[themeName])
	end
	local ScreenGui = Create("ScreenGui", {
		Name = "Rayflide_" .. HttpService:GenerateGUID(false):sub(1, 8),
		ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100,
	})
	ProtectGui(ScreenGui)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local Main = Create("Frame", {
		Name = "Main", BackgroundColor3 = Rayflide.Theme.Current.Background,
		Size = defaultSize,
		Position = UDim2.new(0.5, -defaultSize.X.Offset/2, 0.5, -defaultSize.Y.Offset/2),
		ClipsDescendants = true, Parent = ScreenGui,
	})
	AddCorner(Main, 12)
	AddStroke(Main, Rayflide.Theme.Current.Stroke, 1.2)
	Create("ImageLabel", {
		Name = "Shadow", BackgroundTransparency = 1, Size = UDim2.new(1, 60, 1, 60),
		Position = UDim2.new(0, -30, 0, -30), Image = "rbxassetid://6014261993",
		ImageColor3 = Color3.new(0,0,0), ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
		ZIndex = 0, Parent = Main,
	})
	local topbarHeight = 42
	local Topbar = Create("Frame", {
		Name = "Topbar", BackgroundColor3 = Rayflide.Theme.Current.Topbar,
		Size = UDim2.new(1, 0, 0, topbarHeight), BorderSizePixel = 0, Parent = Main,
	})
	AddCorner(Topbar, 12)
	Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.Topbar,
		Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 1, -15),
		BorderSizePixel = 0, Parent = Topbar,
	})
	local Title = Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -120, 1, 0), Font = Enum.Font.GothamBold,
		Text = windowName, TextColor3 = Rayflide.Theme.Current.TextColor,
		TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = Topbar,
	})
	local CloseBtn = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(255, 95, 87), Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(1, -22, 0.5, -7), Text = "", AutoButtonColor = false, Parent = Topbar,
	})
	AddCorner(CloseBtn, 999)
	local MinBtn = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(255, 189, 46), Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(1, -42, 0.5, -7), Text = "", AutoButtonColor = false, Parent = Topbar,
	})
	AddCorner(MinBtn, 999)
	local MaxBtn = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(40, 200, 64), Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(1, -62, 0.5, -7), Text = "", AutoButtonColor = false, Parent = Topbar,
	})
	AddCorner(MaxBtn, 999)
	local TabContainer = Create("Frame", {
		Name = "TabContainer", BackgroundTransparency = 1,
		Size = UDim2.new(0, isMobile and 70 or 150, 1, -topbarHeight),
		Position = UDim2.new(0, 0, 0, topbarHeight), Parent = Main,
	})
	local TabList = Create("ScrollingFrame", {
		Name = "TabList", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 2,
		ScrollBarImageColor3 = Rayflide.Theme.Current.Accent, BorderSizePixel = 0, Parent = TabContainer,
	})
	Create("UIListLayout", {
		Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabList,
	})
	AddPadding(TabList, { 10, 0, 10, 0 })
	local Content = Create("Frame", {
		Name = "Content", BackgroundTransparency = 1,
		Size = UDim2.new(1, isMobile and -70 or -150, 1, -topbarHeight),
		Position = UDim2.new(0, isMobile and 70 or 150, 0, topbarHeight),
		ClipsDescendants = true, Parent = Main,
	})
	local Pages = Create("Folder", { Name = "Pages", Parent = Content })
	local dragging, dragStart, startPos
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	if resizable then
		local resizeHandle = Create("TextButton", {
			BackgroundTransparency = 1, Size = UDim2.fromOffset(20, 20),
			Position = UDim2.new(1, -20, 1, -20), Text = "◢",
			Font = Enum.Font.GothamBold, TextColor3 = Rayflide.Theme.Current.SubTextColor,
			TextSize = 14, Parent = Main,
		})
		local resizing = false
		local resizeStart, resizeStartSize
		resizeHandle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				resizing = true
				resizeStart = input.Position
				resizeStartSize = Main.Size
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - resizeStart
				local newW = math.clamp(resizeStartSize.X.Offset + delta.X, Rayflide.Defaults.MinWindowSize.X, Rayflide.Defaults.MaxWindowSize.X)
				local newH = math.clamp(resizeStartSize.Y.Offset + delta.Y, Rayflide.Defaults.MinWindowSize.Y, Rayflide.Defaults.MaxWindowSize.Y)
				Main.Size = UDim2.fromOffset(newW, newH)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				resizing = false
			end
		end)
	end
	local minimized = false
	local maximized = false
	local originalSize = defaultSize
	local originalPos = Main.Position
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Tween(Main, { Size = UDim2.new(0, defaultSize.X.Offset, 0, topbarHeight) }, 0.3)
		else
			Tween(Main, { Size = maximized and UDim2.fromScale(0.9, 0.9) or defaultSize }, 0.3)
		end
	end)
	MaxBtn.MouseButton1Click:Connect(function()
		maximized = not maximized
		if maximized then
			originalSize = Main.Size
			originalPos = Main.Position
			Main.Position = UDim2.new(0.5, 0, 0.5, 0)
			Main.AnchorPoint = Vector2.new(0.5, 0.5)
			Tween(Main, { Size = UDim2.fromScale(0.9, 0.9) }, 0.3)
		else
			Main.AnchorPoint = Vector2.new(0, 0)
			Tween(Main, { Size = originalSize, Position = originalPos }, 0.3)
		end
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }, 0.25)
		task.wait(0.3)
		ScreenGui:Destroy()
	end)
	local Window = { Tabs = {}, SelectedTab = nil, Main = Main, ScreenGui = ScreenGui }
	function Window:CreateTab(name, icon)
		name = name or "Tab"
		local tabButton = Create("TextButton", {
			Name = name, BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
			Size = UDim2.new(1, isMobile and -12 or -20, 0, isMobile and 48 or 40),
			Text = "", AutoButtonColor = false, Parent = TabList,
		})
		AddCorner(tabButton, 8)
		local tabIcon = Create("ImageLabel", {
			BackgroundTransparency = 1, Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, isMobile and 14 or 12, 0.5, -10),
			Image = typeof(icon) == "number" and ("rbxassetid://" .. icon) or (icon or ""),
			ImageColor3 = Rayflide.Theme.Current.SubTextColor, Parent = tabButton,
		})
		local tabLabel = Create("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.new(0, isMobile and 42 or 40, 0, 0),
			Size = UDim2.new(1, -50, 1, 0), Font = Enum.Font.GothamMedium,
			Text = name, TextColor3 = Rayflide.Theme.Current.SubTextColor,
			TextSize = isMobile and 13 or 14, TextXAlignment = Enum.TextXAlignment.Left,
			Visible = not isMobile, Parent = tabButton,
		})
		local page = Create("ScrollingFrame", {
			Name = name, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3,
			ScrollBarImageColor3 = Rayflide.Theme.Current.Accent, BorderSizePixel = 0,
			Visible = false, Parent = Pages,
		})
		local pageLayout = Create("UIListLayout", {
			Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page,
		})
		AddPadding(page, { 12, 12, 12, 12 })
		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 24)
		end)
		local Tab = { Name = name, Button = tabButton, Page = page, Elements = {} }
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
			tabLabel.TextColor3 = Color3.new(1,1,1)
			tabIcon.ImageColor3 = Color3.new(1,1,1)
			Window.SelectedTab = Tab
		end
		tabButton.MouseButton1Click:Connect(function()
			Select()
			Ripple(tabButton, Rayflide.Theme.Current.Accent)
		end)
		if #Window.Tabs == 0 then task.defer(Select) end
		table.insert(Window.Tabs, Tab)
		function Tab:CreateSection(sectionName)
			local section = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), Parent = page })
			local label = Create("TextLabel", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold,
				Text = sectionName or "Section", TextColor3 = Rayflide.Theme.Current.Accent,
				TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = section,
			})
			return { Set = function(_, text) label.Text = text end }
		end
		function Tab:CreateButton(opts)
			opts = opts or {}
			local height = opts.Height or 42
			local btnFrame = Create("TextButton", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, height), Text = "", AutoButtonColor = false, Parent = page,
			})
			AddCorner(btnFrame, 8)
			AddStroke(btnFrame, Rayflide.Theme.Current.Stroke, 1)
			local icon = Create("ImageLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0.5, -8),
				Size = UDim2.fromOffset(16, 16),
				Image = opts.Icon and (typeof(opts.Icon) == "number" and ("rbxassetid://"..opts.Icon) or opts.Icon) or "",
				ImageColor3 = Rayflide.Theme.Current.SubTextColor,
				Visible = opts.Icon ~= nil, Parent = btnFrame,
			})
			local btnLabel = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, opts.Icon and 36 or 14, 0, 0),
				Size = UDim2.new(1, opts.Icon and -48 or -28, 1, 0), Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Button", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = btnFrame,
			})
			btnFrame.MouseEnter:Connect(function()
				Tween(btnFrame, { BackgroundColor3 = Rayflide.Theme.Current.ElementBackgroundHover }, 0.15)
			end)
			btnFrame.MouseLeave:Connect(function()
				Tween(btnFrame, { BackgroundColor3 = Rayflide.Theme.Current.ElementBackground }, 0.15)
			end)
			btnFrame.MouseButton1Click:Connect(function()
				Ripple(btnFrame, Rayflide.Theme.Current.Accent)
				if opts.Callback then task.spawn(opts.Callback) end
			end)
			return { Set = function(_, text) btnLabel.Text = text end }
		end
		function Tab:CreateToggle(opts)
			opts = opts or {}
			local flag = opts.Flag
			local current = opts.CurrentValue or false
			if flag then Rayflide.Flags[flag] = current end
			local toggleFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 42), Parent = page,
			})
			AddCorner(toggleFrame, 8)
			AddStroke(toggleFrame, Rayflide.Theme.Current.Stroke, 1)
			local label = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -70, 1, 0), Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Toggle", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = toggleFrame,
			})
			local switchBg = Create("Frame", {
				BackgroundColor3 = current and Rayflide.Theme.Current.ToggleOn or Rayflide.Theme.Current.ToggleOff,
				Size = UDim2.new(0, 44, 0, 24), Position = UDim2.new(1, -56, 0.5, -12), Parent = toggleFrame,
			})
			AddCorner(switchBg, 999)
			local circle = Create("Frame", {
				BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 18, 0, 18),
				Position = current and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
				Parent = switchBg,
			})
			AddCorner(circle, 999)
			local function Set(value, skipCallback)
				current = value
				if flag then Rayflide.Flags[flag] = value end
				Tween(switchBg, { BackgroundColor3 = value and Rayflide.Theme.Current.ToggleOn or Rayflide.Theme.Current.ToggleOff }, 0.2)
				Tween(circle, { Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
				if not skipCallback and opts.Callback then task.spawn(opts.Callback, value) end
			end
			local clickBtn = Create("TextButton", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", Parent = toggleFrame,
			})
			clickBtn.MouseButton1Click:Connect(function() Set(not current) end)
			return { Set = Set, Get = function() return current end }
		end
		function Tab:CreateSlider(opts)
			opts = opts or {}
			local min = (opts.Range and opts.Range[1]) or 0
			local max = (opts.Range and opts.Range[2]) or 100
			local increment = opts.Increment or 1
			local current = opts.CurrentValue or min
			local flag = opts.Flag
			local suffix = opts.Suffix or ""
			if flag then Rayflide.Flags[flag] = current end
			local sliderFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 60), Parent = page,
			})
			AddCorner(sliderFrame, 8)
			AddStroke(sliderFrame, Rayflide.Theme.Current.Stroke, 1)
			local label = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 8),
				Size = UDim2.new(0.6, 0, 0, 18), Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Slider", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = sliderFrame,
			})
			local valuePill = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.Accent,
				Position = UDim2.new(1, -72, 0, 6), Size = UDim2.fromOffset(58, 22), Parent = sliderFrame,
			})
			AddCorner(valuePill, 999)
			local valueLabel = Create("TextLabel", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold,
				Text = tostring(current) .. suffix, TextColor3 = Color3.new(1,1,1),
				TextSize = 12, Parent = valuePill,
			})
			local trackBg = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ToggleOff,
				Size = UDim2.new(1, -28, 0, 6), Position = UDim2.new(0, 14, 0, 40), Parent = sliderFrame,
			})
			AddCorner(trackBg, 999)
			local fill = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.SliderFill,
				Size = UDim2.new((current - min) / (max - min), 0, 1, 0), Parent = trackBg,
			})
			AddCorner(fill, 999)
			local grab = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.SliderGrab,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new((current - min) / (max - min), -8, 0.5, -8), Parent = trackBg,
			})
			AddCorner(grab, 999)
			AddStroke(grab, Rayflide.Theme.Current.Accent, 2)
			local function Set(val, skipCallback)
				val = math.clamp(Round(val / increment) * increment, min, max)
				current = val
				if flag then Rayflide.Flags[flag] = val end
				local rel = (val - min) / (max - min)
				fill.Size = UDim2.new(rel, 0, 1, 0)
				grab.Position = UDim2.new(rel, -8, 0.5, -8)
				valueLabel.Text = tostring(val) .. suffix
				if not skipCallback and opts.Callback then task.spawn(opts.Callback, val) end
			end
			local sliding = false
			local function update(x)
				local rel = math.clamp((x - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
				Set(min + (max - min) * rel)
			end
			trackBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					update(input.Position.X)
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					update(input.Position.X)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = false
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
				Size = UDim2.new(1, 0, 0, 42), Parent = page,
			})
			AddCorner(inputFrame, 8)
			AddStroke(inputFrame, Rayflide.Theme.Current.Stroke, 1)
			local label = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(0.35, 0, 1, 0), Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Input", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = inputFrame,
			})
			local box = Create("TextBox", {
				BackgroundColor3 = Rayflide.Theme.Current.Background,
				Position = UDim2.new(0.38, 0, 0.5, -14), Size = UDim2.new(0.58, -8, 0, 28),
				Font = Enum.Font.Gotham, Text = current,
				PlaceholderText = opts.PlaceholderText or "Type here...",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				PlaceholderColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13, ClearTextOnFocus = false, Parent = inputFrame,
			})
			AddCorner(box, 6)
			AddStroke(box, Rayflide.Theme.Current.Stroke, 1)
			box.FocusLost:Connect(function()
				current = box.Text
				if flag then Rayflide.Flags[flag] = current end
				if opts.Callback then task.spawn(opts.Callback, current) end
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
			local multi = opts.MultipleOptions or false
			if flag then Rayflide.Flags[flag] = current end
			local dropFrame = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true, Parent = page,
			})
			AddCorner(dropFrame, 8)
			AddStroke(dropFrame, Rayflide.Theme.Current.Stroke, 1)
			local label = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(0.5, 0, 0, 42), Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Dropdown", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = dropFrame,
			})
			local selectedLabel = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, -30, 0, 42), Font = Enum.Font.Gotham,
				Text = typeof(current) == "table" and table.concat(current, ", ") or tostring(current),
				TextColor3 = Rayflide.Theme.Current.SubTextColor, TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Parent = dropFrame,
			})
			local arrow = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(1, -24, 0, 0),
				Size = UDim2.new(0, 20, 0, 42), Font = Enum.Font.GothamBold,
				Text = "▾", TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 14, Parent = dropFrame,
			})
			local open = false
			local function Toggle()
				open = not open
				local targetHeight = open and (42 + #options * 32 + 16) or 42
				Tween(dropFrame, { Size = UDim2.new(1, 0, 0, targetHeight) }, 0.25)
				arrow.Text = open and "▴" or "▾"
			end
			local clickArea = Create("TextButton", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), Text = "", Parent = dropFrame,
			})
			clickArea.MouseButton1Click:Connect(Toggle)
			local searchBox = Create("TextBox", {
				BackgroundColor3 = Rayflide.Theme.Current.Background,
				Position = UDim2.new(0, 8, 0, 46), Size = UDim2.new(1, -16, 0, 26),
				Font = Enum.Font.Gotham, Text = "", PlaceholderText = "Search...",
				TextColor3 = Rayflide.Theme.Current.TextColor,
				PlaceholderColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 12, ClearTextOnFocus = false, Parent = dropFrame,
			})
			AddCorner(searchBox, 6)
			local optionsHolder = Create("ScrollingFrame", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 80),
				Size = UDim2.new(1, -16, 0, 0), CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 2, BorderSizePixel = 0, Parent = dropFrame,
			})
			local optionButtons = {}
			local function refresh()
				local query = string.lower(searchBox.Text)
				for _, b in pairs(optionButtons) do
					b.Visible = string.find(string.lower(b.Text), query, 1, true) ~= nil
				end
				local count = 0
				for _, b in pairs(optionButtons) do if b.Visible then count = count + 1 end end
				optionsHolder.CanvasSize = UDim2.new(0, 0, 0, count * 32 + 4)
				if open then
					Tween(dropFrame, { Size = UDim2.new(1, 0, 0, 86 + math.max(#options, 3) * 32 + 40) }, 0.2)
				end
			end
			searchBox:GetPropertyChangedSignal("Text"):Connect(refresh)
			for i, opt in ipairs(options) do
				local optBtn = Create("TextButton", {
					BackgroundColor3 = Rayflide.Theme.Current.Background,
					Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, (i - 1) * 32),
					Text = opt, Font = Enum.Font.Gotham,
					TextColor3 = Rayflide.Theme.Current.TextColor, TextSize = 12,
					AutoButtonColor = false, Parent = optionsHolder,
				})
				AddCorner(optBtn, 6)
				optBtn.MouseEnter:Connect(function()
					Tween(optBtn, { BackgroundColor3 = Rayflide.Theme.Current.ElementBackgroundHover }, 0.1)
				end)
				optBtn.MouseLeave:Connect(function()
					Tween(optBtn, { BackgroundColor3 = Rayflide.Theme.Current.Background }, 0.1)
				end)
				optBtn.MouseButton1Click:Connect(function()
					if multi then
						current = current or {}
						local idx = table.find(current, opt)
						if idx then table.remove(current, idx) else table.insert(current, opt) end
						selectedLabel.Text = #current > 0 and table.concat(current, ", ") or "None"
					else
						current = opt
						selectedLabel.Text = opt
						Toggle()
					end
					if flag then Rayflide.Flags[flag] = current end
					if opts.Callback then task.spawn(opts.Callback, current) end
				end)
				table.insert(optionButtons, optBtn)
			end
			refresh()
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
			local labelFrame = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Parent = page })
			local text = Create("TextLabel", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.Gotham,
				Text = opts.Text or opts.Name or "Label", TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = labelFrame,
			})
			return { Set = function(_, t) text.Text = t end }
		end
		function Tab:CreateParagraph(opts)
			opts = opts or {}
			local para = Create("Frame", {
				BackgroundColor3 = Rayflide.Theme.Current.ElementBackground,
				Size = UDim2.new(1, 0, 0, 0), Parent = page,
			})
			AddCorner(para, 8)
			AddStroke(para, Rayflide.Theme.Current.Stroke, 1)
			local title = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8),
				Size = UDim2.new(1, -24, 0, 18), Font = Enum.Font.GothamBold,
				Text = opts.Title or "Paragraph", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = para,
			})
			local content = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 30),
				Size = UDim2.new(1, -24, 0, 0), Font = Enum.Font.Gotham,
				Text = opts.Content or "", TextColor3 = Rayflide.Theme.Current.SubTextColor,
				TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top, Parent = para,
			})
			local size = TextService:GetTextSize(opts.Content or "", 13, Enum.Font.Gotham, Vector2.new(page.AbsoluteSize.X - 48, 2000))
			content.Size = UDim2.new(1, -24, 0, size.Y + 4)
			para.Size = UDim2.new(1, 0, 0, 42 + size.Y)
			return {
				Set = function(_, t, c)
					if t then title.Text = t end
					if c then
						content.Text = c
						local s = TextService:GetTextSize(c, 13, Enum.Font.Gotham, Vector2.new(page.AbsoluteSize.X - 48, 2000))
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
				Size = UDim2.new(1, 0, 0, 42), Parent = page,
			})
			AddCorner(kbFrame, 8)
			AddStroke(kbFrame, Rayflide.Theme.Current.Stroke, 1)
			local label = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(0.6, 0, 1, 0), Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Keybind", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = kbFrame,
			})
			local keyBtn = Create("TextButton", {
				BackgroundColor3 = Rayflide.Theme.Current.Background,
				Position = UDim2.new(1, -94, 0.5, -12), Size = UDim2.new(0, 82, 0, 24),
				Font = Enum.Font.GothamBold, Text = current,
				TextColor3 = Rayflide.Theme.Current.TextColor, TextSize = 12,
				AutoButtonColor = false, Parent = kbFrame,
			})
			AddCorner(keyBtn, 6)
			AddStroke(keyBtn, Rayflide.Theme.Current.Stroke, 1)
			local listening = false
			keyBtn.MouseButton1Click:Connect(function()
				listening = true
				keyBtn.Text = "..."
				keyBtn.TextColor3 = Rayflide.Theme.Current.Accent
			end)
			UserInputService.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if listening then
					local key = input.KeyCode.Name
					if key ~= "Unknown" then
						current = key
						keyBtn.Text = key
						keyBtn.TextColor3 = Rayflide.Theme.Current.TextColor
						listening = false
						if flag then Rayflide.Flags[flag] = key end
						if opts.Callback then task.spawn(opts.Callback, key) end
					end
				elseif input.KeyCode.Name == current and opts.Callback then
					task.spawn(opts.Callback, current)
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
				Size = UDim2.new(1, 0, 0, 42), Parent = page,
			})
			AddCorner(cpFrame, 8)
			AddStroke(cpFrame, Rayflide.Theme.Current.Stroke, 1)
			local label = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -60, 1, 0), Font = Enum.Font.GothamMedium,
				Text = opts.Name or "Color", TextColor3 = Rayflide.Theme.Current.TextColor,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = cpFrame,
			})
			local preview = Create("Frame", {
				BackgroundColor3 = current, Position = UDim2.new(1, -48, 0.5, -12),
				Size = UDim2.new(0, 36, 0, 24), Parent = cpFrame,
			})
			AddCorner(preview, 6)
			AddStroke(preview, Rayflide.Theme.Current.Stroke, 1)
			local btn = Create("TextButton", {
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", Parent = cpFrame,
			})
			btn.MouseButton1Click:Connect(function()
				OpenColorPicker(Main, current, function(c)
					current = c
					preview.BackgroundColor3 = c
					if flag then Rayflide.Flags[flag] = c end
					if opts.Callback then task.spawn(opts.Callback, c) end
				end)
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
	if configSaving.Enabled then
		local folder = configSaving.FolderName or "Rayflide"
		local file = (configSaving.FileName or "config") .. ".json"
		function Window:SaveConfig()
			if writefile then
				local data = HttpService:JSONEncode(Rayflide.Flags)
				pcall(function()
					if not isfolder or isfolder(folder) then
						writefile(folder .. "/" .. file, data)
					end
				end)
			end
		end
		function Window:LoadConfig()
			if isfile and isfile(folder .. "/" .. file) then
				local success, data = pcall(function()
					return HttpService:JSONDecode(readfile(folder .. "/" .. file))
				end)
				if success and data then
					for flag, value in pairs(data) do Rayflide.Flags[flag] = value end
				end
			end
		end
		task.defer(function() Window:LoadConfig() end)
	end
	function Window:Destroy()
		ScreenGui:Destroy()
	end
	local Loading = Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.Background,
		Size = UDim2.new(1, 0, 1, 0), Parent = Main, ZIndex = 10,
	})
	AddCorner(Loading, 12)
	local loadTitle = Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.35, 0),
		Size = UDim2.new(1, 0, 0, 32), Font = Enum.Font.GothamBold,
		Text = loadingTitle, TextColor3 = Rayflide.Theme.Current.TextColor,
		TextSize = 24, Parent = Loading,
	})
	local loadSub = Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.35, 36),
		Size = UDim2.new(1, 0, 0, 20), Font = Enum.Font.Gotham,
		Text = loadingSubtitle, TextColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 14, Parent = Loading,
	})
	local progressBg = Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.ToggleOff,
		Position = UDim2.new(0.2, 0, 0.62, 0), Size = UDim2.new(0.6, 0, 0, 6), Parent = Loading,
	})
	AddCorner(progressBg, 999)
	local progressFill = Create("Frame", {
		BackgroundColor3 = Rayflide.Theme.Current.Accent,
		Size = UDim2.new(0, 0, 1, 0), Parent = progressBg,
	})
	AddCorner(progressFill, 999)
	local percentLabel = Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.62, 12),
		Size = UDim2.new(1, 0, 0, 18), Font = Enum.Font.Gotham,
		Text = "0%", TextColor3 = Rayflide.Theme.Current.SubTextColor,
		TextSize = 12, Parent = Loading,
	})
	task.spawn(function()
		local t = 0
		local duration = settings.LoadingDuration or 1.0
		while t < duration do
			t = t + task.wait()
			local p = math.clamp(t / duration, 0, 1)
			progressFill.Size = UDim2.new(p, 0, 1, 0)
			percentLabel.Text = tostring(math.floor(p * 100)) .. "%"
		end
		task.wait(0.15)
		Tween(Loading, { BackgroundTransparency = 1 }, 0.35)
		Tween(loadTitle, { TextTransparency = 1 }, 0.35)
		Tween(loadSub, { TextTransparency = 1 }, 0.35)
		Tween(progressBg, { BackgroundTransparency = 1 }, 0.35)
		Tween(progressFill, { BackgroundTransparency = 1 }, 0.35)
		Tween(percentLabel, { TextTransparency = 1 }, 0.35)
		task.wait(0.4)
		Loading:Destroy()
	end)
	table.insert(Rayflide.Windows, Window)
	return Window
end

function Rayflide:SetTheme(name)
	if Rayflide.Theme[name] then
		Rayflide.Theme.Current = table.clone(Rayflide.Theme[name])
	end
end

function Rayflide:GetThemes()
	local names = {}
	for k in pairs(Rayflide.Theme) do
		if k ~= "Current" then table.insert(names, k) end
	end
	return names
end

function Rayflide:Destroy()
	for _, w in pairs(Rayflide.Windows) do
		if w.ScreenGui then w.ScreenGui:Destroy() end
	end
	Rayflide.Windows = {}
end

return Rayflide
