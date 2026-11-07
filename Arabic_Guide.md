# دليل Rayflide بالعربي

## إزاي تستخدم المكتبة بسرعة

### 1. تحميل المكتبة
حط الكود ده في أول السكريبت بتاعك:

```lua
local Rayflide = loadstring(game:HttpGet("الرابط_بتاع_Rayflide.lua"))()
```

### 2. عمل نافذة

```lua
local Window = Rayflide:CreateWindow({
    Name = "اسم الها ب بتاعك",
    LoadingTitle = "Rayflide",
    LoadingSubtitle = "أفضل مكتبة للـ Delta",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyConfigs",
        FileName = "Save"
    }
})
```

### 3. عمل تاب

```lua
local Tab = Window:CreateTab("الرئيسية", 4483362458)
```

### 4. إضافة عناصر

**زرار:**
```lua
Tab:CreateButton({
    Name = "اضغط هنا",
    Callback = function()
        print("اتضغط!")
    end
})
```

**توجل:**
```lua
Tab:CreateToggle({
    Name = "سرعة",
    CurrentValue = false,
    Flag = "Speed",
    Callback = function(Value)
        -- Value = true أو false
    end
})
```

**سلايدر:**
```lua
Tab:CreateSlider({
    Name = "السرعة",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
```

**دروب داون:**
```lua
Tab:CreateDropdown({
    Name = "اختار",
    Options = {"خيار 1", "خيار 2", "خيار 3"},
    CurrentOption = "خيار 1",
    Flag = "MyDropdown",
    Callback = function(Option)
        print(Option)
    end
})
```

### 5. إشعارات

```lua
Rayflide:Notify({
    Title = "تم بنجاح",
    Content = "كل حاجة تمام!",
    Duration = 3
})
```

---

## نصائح لـ Delta

- المكتبة بتشتغل مباشرة من غير أي تعديل.
- لو عايز تخفي الـ UI استخدم زرار الـ Minimize (الأصفر).
- الـ Config بيتحفظ أوتوماتيك لو فعلت ConfigurationSaving.

---

بالتوفيق يا وحش!
