# Rayflide UI Library v1.0.0

**Professional Luau UI Library** — نفس شكل Rayfield بالظبط بس أفضل، أسرع، وأنظف، ومتوافق 100% مع **Delta** والمشغلات الموبايل.

---

## مميزات

- Pure Code (مفيش `GetObjects` ولا asset model → أصعب في الـ detection)
- API متوافق مع Rayfield (تقدر تنقل سكريبتاتك بسهولة)
- محسّن جداً للموبايل (Delta, Codex, Solara Mobile...)
- 5 Themes جاهزة + إمكانية ثيم مخصص
- Config Saving قوي
- Notifications حديثة
- كل العناصر الأساسية:
  - Button
  - Toggle
  - Slider
  - Dropdown (مع Multi)
  - Input / TextBox
  - Keybind
  - ColorPicker
  - Label
  - Paragraph
  - Section

---

## طريقة الاستخدام (Loadstring)

```lua
local Rayflide = loadstring(game:HttpGet("رابط_الملف_بتاعك"))()

local Window = Rayflide:CreateWindow({
    Name = "My Hub",
    LoadingTitle = "Rayflide",
    LoadingSubtitle = "by You",
    Theme = "Default", -- Default | Dark | Light | Ocean | Crimson
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyHub",
        FileName = "Config"
    }
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Hello from Rayflide!")
    end
})

Tab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        print(Value)
    end
})
```

---

## Themes المتاحة

| Theme    | Description          |
|----------|----------------------|
| Default  | Dark Indigo modern   |
| Dark     | Classic dark         |
| Light    | Clean light theme    |
| Ocean    | Blue / cyan vibe     |
| Crimson  | Red / dark red       |

```lua
Rayflide:SetTheme("Ocean")
```

---

## Notifications

```lua
Rayflide:Notify({
    Title = "Success",
    Content = "Everything worked perfectly!",
    Duration = 4
})
```

---

## ملاحظات مهمة لـ Delta

- المكتبة بتشتغل مباشرة على Delta بدون أي تعديل
- كل العناصر تدعم الـ Touch
- الأحجام متكيفة مع الشاشات الصغيرة
- مفيش اعتماد على `syn` أو أي function خاصة (بتشتغل على أي executor فيه `gethui` أو CoreGui)

---

## الملفات الموجودة في الـ Zip

```
Rayflide/
├── src/
│   └── Rayflide.lua          ← المكتبة الرئيسية
├── examples/
│   └── Example.lua           ← مثال كامل جاهز
├── docs/
│   └── (مستندات إضافية)
└── README.md
```

---

## Credits

- Design inspired by **Rayfield** (Sirius)
- Built from scratch with pure Luau
- Optimized for modern executors (2025-2026)

**Mode Good**

---

## License

MIT License — استخدمها براحتك في أي مشروع.
