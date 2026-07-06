-- ============================================================
--  MaidDev UI Library  |  Premium Modern Script Hub UI
--  Self-contained, no HTTP requests required.
--  RightControl = toggle visibility
-- ============================================================

local MaidLib = {}
MaidLib.__index = MaidLib

local TweenService    = game:GetService("TweenService")
local UIS             = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")

-- ── Theme ────────────────────────────────────────────────────
local T = {
    Bg          = Color3.fromHex("09090F"),
    Surface     = Color3.fromHex("11111A"),
    SurfaceHov  = Color3.fromHex("18182A"),
    Card        = Color3.fromHex("141420"),
    Border      = Color3.fromHex("252535"),
    BorderHov   = Color3.fromHex("6D28D9"),
    Accent      = Color3.fromHex("7C3AED"),
    AccentB     = Color3.fromHex("5B21B6"),
    AccentGlow  = Color3.fromHex("9D5CF6"),
    Text        = Color3.fromHex("F0F0FF"),
    TextSub     = Color3.fromHex("8888AA"),
    TextDim     = Color3.fromHex("3D3D58"),
    Green       = Color3.fromHex("10B981"),
    Red         = Color3.fromHex("EF4444"),
    Yellow      = Color3.fromHex("F59E0B"),
    White       = Color3.new(1,1,1),
}

-- ── Fonts ────────────────────────────────────────────────────
local FB = Enum.Font.GothamBold
local FM = Enum.Font.GothamMedium
local FR = Enum.Font.Gotham

local Themes = {
    ["MaidDev Purple"] = {
        Accent = Color3.fromHex("7C3AED"),
        AccentB = Color3.fromHex("5B21B6"),
        AccentGlow = Color3.fromHex("9D5CF6"),
        BorderHov = Color3.fromHex("6D28D9"),
        Bg = Color3.fromHex("09090F"),
        Surface = Color3.fromHex("11111A"),
        Card = Color3.fromHex("141420"),
        Border = Color3.fromHex("252535")
    },
    ["Cyber Aqua"] = {
        Accent = Color3.fromHex("06B6D4"),
        AccentB = Color3.fromHex("0891B2"),
        AccentGlow = Color3.fromHex("22D3EE"),
        BorderHov = Color3.fromHex("06B6D4"),
        Bg = Color3.fromHex("070E12"),
        Surface = Color3.fromHex("0D171C"),
        Card = Color3.fromHex("101E24"),
        Border = Color3.fromHex("202F3A")
    },
    ["Crimson Red"] = {
        Accent = Color3.fromHex("EF4444"),
        AccentB = Color3.fromHex("B91C1C"),
        AccentGlow = Color3.fromHex("F87171"),
        BorderHov = Color3.fromHex("EF4444"),
        Bg = Color3.fromHex("0F0909"),
        Surface = Color3.fromHex("191010"),
        Card = Color3.fromHex("221414"),
        Border = Color3.fromHex("352020")
    },
    ["Gold Luxury"] = {
        Accent = Color3.fromHex("F59E0B"),
        AccentB = Color3.fromHex("B45309"),
        AccentGlow = Color3.fromHex("FBBF24"),
        BorderHov = Color3.fromHex("F59E0B"),
        Bg = Color3.fromHex("0F0C09"),
        Surface = Color3.fromHex("181410"),
        Card = Color3.fromHex("201B14"),
        Border = Color3.fromHex("302920")
    },
    ["Emerald Mint"] = {
        Accent = Color3.fromHex("10B981"),
        AccentB = Color3.fromHex("047857"),
        AccentGlow = Color3.fromHex("34D399"),
        BorderHov = Color3.fromHex("10B981"),
        Bg = Color3.fromHex("090F0C"),
        Surface = Color3.fromHex("101814"),
        Card = Color3.fromHex("14201B"),
        Border = Color3.fromHex("203029")
    }
}

local function registerAccent(lib, instance, prop, colorType)
    table.insert(lib.accentObjects, {instance = instance, prop = prop, colorType = colorType})
end

-- ── Helpers ──────────────────────────────────────────────────
local function tw(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function new(cls, props, parent)
    local i = Instance.new(cls)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function corner(r, p)  return new("UICorner", {CornerRadius=UDim.new(0,r)}, p) end
local function stroke(c, th, p)
    return new("UIStroke", {Color=c, Thickness=th or 1, ApplyStrokeMode=Enum.ApplyStrokeMode.Border}, p)
end
local function pad(t,b,l,r,p)
    return new("UIPadding",{PaddingTop=UDim.new(0,t),PaddingBottom=UDim.new(0,b),PaddingLeft=UDim.new(0,l),PaddingRight=UDim.new(0,r)},p)
end
local function gradient(cs, rot, p)
    return new("UIGradient", {Color=cs, Rotation=rot or 90}, p)
end
local function listLayout(pad_, p)
    return new("UIListLayout", {Padding=UDim.new(0,pad_ or 0), SortOrder=Enum.SortOrder.LayoutOrder}, p)
end

local function makeDraggable(handle, frame)
    local drag, ds, sp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; sp = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
end

local function addSquishEffect(button, scaleTarget)
    scaleTarget = scaleTarget or button
    local scale = scaleTarget:FindFirstChildOfClass("UIScale")
    if not scale then
        scale = new("UIScale", {Scale = 1}, scaleTarget)
    end
    button.MouseButton1Down:Connect(function()
        tw(scale, {Scale = 0.95}, 0.05)
    end)
    button.MouseButton1Up:Connect(function()
        tw(scale, {Scale = 1.0}, 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    button.MouseLeave:Connect(function()
        tw(scale, {Scale = 1.0}, 0.15)
    end)
end

-- ── Constructor ──────────────────────────────────────────────
function MaidLib.new(title, subtitle)
    local self = setmetatable({}, MaidLib)
    self.tabs       = {}
    self.activetab  = nil
    self.visible    = true
    self.accentObjects = {}

    -- Root GUI
    local sg = new("ScreenGui", {
        Name = "MaidDevUI", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = game:GetService("Players").LocalPlayer.PlayerGui end

    -- ── Main Frame (CanvasGroup for smooth group transparency tweens) ──
    local main = new("CanvasGroup", {
        Name = "Main",
        Size = UDim2.new(0, 760, 0, 500),
        Position = UDim2.new(0.5,-380, 0.5,-250),
        BackgroundColor3 = T.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, sg)
    corner(16, main)
    registerAccent(self, main, "BackgroundColor3", "Bg")
    local mainStroke = stroke(T.Border, 1, main)
    registerAccent(self, mainStroke, "Color", "Border")

    -- Drop shadow (fake via ImageLabel)
    local shadow = new("ImageLabel", {
        Size = UDim2.new(1,60,1,60),
        Position = UDim2.new(0,-30,0,-30),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = T.Accent,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23,23,277,277),
        ZIndex = 0,
    }, main)
    registerAccent(self, shadow, "ImageColor3", "Accent")

    -- Clip inner content
    local clip = new("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 1,
    }, main)
    corner(16, clip)

    -- ── Sidebar (left panel) ─────────────────────────────────
    local sidebar = new("Frame", {
        Size = UDim2.new(0, 210, 1, 0),
        BackgroundColor3 = T.Surface,
        BorderSizePixel = 0,
    }, clip)
    registerAccent(self, sidebar, "BackgroundColor3", "Surface")

    -- Right border line
    local sidebarBorder = new("Frame", {
        Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=T.Border, BorderSizePixel=0,
    }, sidebar)
    registerAccent(self, sidebarBorder, "BackgroundColor3", "Border")

    -- ── Logo area ────────────────────────────────────────────
    local logoFrame = new("Frame", {
        Size=UDim2.new(1,0,0,75), BackgroundTransparency=1,
    }, sidebar)

    -- Icon box
    local iconBox = new("Frame", {
        Size=UDim2.new(0,40,0,40),
        Position=UDim2.new(0,16,0.5,-20),
        BackgroundColor3=T.Accent, BorderSizePixel=0,
    }, logoFrame)
    corner(12, iconBox)
    registerAccent(self, iconBox, "BackgroundColor3", "Accent")
    
    gradient(ColorSequence.new({
        ColorSequenceKeypoint.new(0,T.AccentGlow),
        ColorSequenceKeypoint.new(1,T.AccentB),
    }), 135, iconBox)
    new("TextLabel",{
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="⛏", TextSize=20, Font=FB,
        TextColor3=T.White,
    }, iconBox)

    -- Title
    new("TextLabel",{
        Size=UDim2.new(1,-70,0,18), Position=UDim2.new(0,64,0,20),
        BackgroundTransparency=1,
        Text=title or "MaidDev",
        TextSize=14, Font=FB,
        TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, logoFrame)

    -- Subtitle
    new("TextLabel",{
        Size=UDim2.new(1,-70,0,13), Position=UDim2.new(0,64,0,40),
        BackgroundTransparency=1,
        Text=subtitle or "Script Hub",
        TextSize=11, Font=FR,
        TextColor3=T.TextSub,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, logoFrame)

    -- Divider
    local logoDivider = new("Frame",{
        Size=UDim2.new(1,-24,0,1), Position=UDim2.new(0,12,0,74),
        BackgroundColor3=T.Border, BorderSizePixel=0,
    }, sidebar)
    registerAccent(self, logoDivider, "BackgroundColor3", "Border")

    -- ── Tab buttons list (height adjusted for the stats box) ──
    local tabScroll = new("ScrollingFrame",{
        Size=UDim2.new(1,0,1,-195), Position=UDim2.new(0,0,0,80),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
    }, sidebar)
    local tabLayout = listLayout(3, tabScroll)
    pad(6,8,8,8, tabScroll)

    -- ── Session Stats Panel ──────────────────────────────────
    local statsCard = new("Frame", {
        Size = UDim2.new(1, -24, 0, 95),
        Position = UDim2.new(0, 12, 1, -110),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
    }, sidebar)
    corner(10, statsCard)
    registerAccent(self, statsCard, "BackgroundColor3", "Card")
    local statsStroke = stroke(T.Border, 1, statsCard)
    registerAccent(self, statsStroke, "Color", "Border")
    
    local statsTitle = new("TextLabel", {
        Size = UDim2.new(1, -16, 0, 14),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundTransparency = 1,
        Text = "SESSION STATS",
        TextSize = 9, Font = FB,
        TextColor3 = T.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, statsCard)
    registerAccent(self, statsTitle, "TextColor3", "Accent")
    
    -- Status
    new("TextLabel", {
        Size = UDim2.new(0.4, 0, 0, 14), Position = UDim2.new(0, 8, 0, 24),
        BackgroundTransparency = 1, Text = "Status:", TextSize = 11, Font = FM,
        TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    }, statsCard)
    local statusLabel = new("TextLabel", {
        Size = UDim2.new(0.6, -16, 0, 14), Position = UDim2.new(0.4, 8, 0, 24),
        BackgroundTransparency = 1, Text = "Idle", TextSize = 11, Font = FB,
        TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Right,
    }, statsCard)
    self.statusLabel = statusLabel
    
    -- Runtime
    new("TextLabel", {
        Size = UDim2.new(0.4, 0, 0, 14), Position = UDim2.new(0, 8, 0, 40),
        BackgroundTransparency = 1, Text = "Runtime:", TextSize = 11, Font = FM,
        TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    }, statsCard)
    local runtimeLabel = new("TextLabel", {
        Size = UDim2.new(0.6, -16, 0, 14), Position = UDim2.new(0.4, 8, 0, 40),
        BackgroundTransparency = 1, Text = "00:00:00", TextSize = 11, Font = FR,
        TextColor3 = T.Text, TextXAlignment = Enum.TextXAlignment.Right,
    }, statsCard)
    self.runtimeLabel = runtimeLabel
    
    -- Crystals Mined
    new("TextLabel", {
        Size = UDim2.new(0.4, 0, 0, 14), Position = UDim2.new(0, 8, 0, 56),
        BackgroundTransparency = 1, Text = "Mined:", TextSize = 11, Font = FM,
        TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    }, statsCard)
    local minedLabel = new("TextLabel", {
        Size = UDim2.new(0.6, -16, 0, 14), Position = UDim2.new(0.4, 8, 0, 56),
        BackgroundTransparency = 1, Text = "0", TextSize = 11, Font = FB,
        TextColor3 = T.Text, TextXAlignment = Enum.TextXAlignment.Right,
    }, statsCard)
    self.minedLabel = minedLabel
    
    -- Auto-Sells
    new("TextLabel", {
        Size = UDim2.new(0.4, 0, 0, 14), Position = UDim2.new(0, 8, 0, 72),
        BackgroundTransparency = 1, Text = "Sold Times:", TextSize = 11, Font = FM,
        TextColor3 = T.TextSub, TextXAlignment = Enum.TextXAlignment.Left,
    }, statsCard)
    local soldLabel = new("TextLabel", {
        Size = UDim2.new(0.6, -16, 0, 14), Position = UDim2.new(0.4, 8, 0, 72),
        BackgroundTransparency = 1, Text = "0", TextSize = 11, Font = FB,
        TextColor3 = T.Text, TextXAlignment = Enum.TextXAlignment.Right,
    }, statsCard)
    self.soldLabel = soldLabel

    -- Start runtime counter
    local startTime = os.time()
    task.spawn(function()
        while sg.Parent do
            task.wait(1)
            local elapsed = os.time() - startTime
            local h = math.floor(elapsed / 3600)
            local m = math.floor((elapsed % 3600) / 60)
            local s = elapsed % 60
            pcall(function() runtimeLabel.Text = string.format("%02d:%02d:%02d", h, m, s) end)
        end
    end)

    -- ── Topbar ───────────────────────────────────────────────
    local topbar = new("Frame",{
        Size=UDim2.new(1,-210,0,48),
        Position=UDim2.new(0,210,0,0),
        BackgroundColor3=T.Bg, BorderSizePixel=0,
    }, clip)
    registerAccent(self, topbar, "BackgroundColor3", "Bg")

    -- Accent line at very top
    local topAccent = new("Frame",{
        Size=UDim2.new(1,0,0,2), BackgroundColor3=T.Accent, BorderSizePixel=0,
    }, topbar)
    registerAccent(self, topAccent, "BackgroundColor3", "Accent")
    
    local topAccentGrad = gradient(ColorSequence.new({
        ColorSequenceKeypoint.new(0,T.AccentGlow),
        ColorSequenceKeypoint.new(0.5,T.Accent),
        ColorSequenceKeypoint.new(1,Color3.fromHex("4338CA")),
    }), 0, topAccent)
    
    -- Animate top accent line (smooth rotation)
    task.spawn(function()
        local rot = 0
        while sg.Parent do
            RunService.Heartbeat:Wait()
            rot = (rot + 1) % 360
            pcall(function() topAccentGrad.Rotation = rot end)
        end
    end)

    -- Topbar path text
    new("TextLabel",{
        Size=UDim2.new(1,-100,1,-2), Position=UDim2.new(0,16,0,2),
        BackgroundTransparency=1,
        Text="Mine a Mountain  /  MaidDev Hub",
        TextSize=12, Font=FM,
        TextColor3=T.TextSub,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, topbar)

    -- Minimize button
    local minBtn = new("TextButton",{
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-70,0.5,-14),
        BackgroundColor3=T.Card, BorderSizePixel=0,
        Text="−", TextSize=18, Font=FB,
        TextColor3=T.TextSub, AutoButtonColor=false,
    }, topbar)
    corner(8, minBtn)
    addSquishEffect(minBtn)
    minBtn.MouseEnter:Connect(function() tw(minBtn,{BackgroundColor3=T.Yellow,TextColor3=T.White}) end)
    minBtn.MouseLeave:Connect(function() tw(minBtn,{BackgroundColor3=T.Card,TextColor3=T.TextSub}) end)

    local minimized = false
    minBtn.Activated:Connect(function()
        minimized = not minimized
        if minimized then
            tw(main, {Size=UDim2.new(0,760,0,48)}, 0.3, Enum.EasingStyle.Quart)
            tw(topbar, {Position=UDim2.new(0,0,0,0), Size=UDim2.new(1,0,0,48)}, 0.3, Enum.EasingStyle.Quart)
            tw(sidebar, {Size=UDim2.new(0,0,1,0)}, 0.3, Enum.EasingStyle.Quart)
            task.spawn(function()
                task.wait(0.3)
                if minimized then sidebar.Visible = false end
            end)
        else
            sidebar.Visible = true
            tw(main, {Size=UDim2.new(0,760,0,500)}, 0.3, Enum.EasingStyle.Quart)
            tw(topbar, {Position=UDim2.new(0,210,0,0), Size=UDim2.new(1,-210,0,48)}, 0.3, Enum.EasingStyle.Quart)
            tw(sidebar, {Size=UDim2.new(0,210,1,0)}, 0.3, Enum.EasingStyle.Quart)
        end
    end)

    -- Close button
    local closeBtn = new("TextButton",{
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-36,0.5,-14),
        BackgroundColor3=T.Card, BorderSizePixel=0,
        Text="✕", TextSize=12, Font=FB,
        TextColor3=T.TextSub, AutoButtonColor=false,
    }, topbar)
    corner(8, closeBtn)
    addSquishEffect(closeBtn)
    closeBtn.MouseEnter:Connect(function() tw(closeBtn,{BackgroundColor3=T.Red,TextColor3=T.White}) end)
    closeBtn.MouseLeave:Connect(function() tw(closeBtn,{BackgroundColor3=T.Card,TextColor3=T.TextSub}) end)
    closeBtn.Activated:Connect(function()
        tw(main, {
            Position = UDim2.new(0.5,-380, 0.5,-220),
            GroupTransparency = 1
        }, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.26)
        sg:Destroy()
    end)

    makeDraggable(topbar, main)

    -- ── Content area ─────────────────────────────────────────
    local content = new("Frame",{
        Size=UDim2.new(1,-210,1,-48),
        Position=UDim2.new(0,210,0,48),
        BackgroundTransparency=1, BorderSizePixel=0,
    }, clip)

    -- Keybind: RightControl toggles window (smooth fade-in/fade-out)
    local fadeTween
    UIS.InputBegan:Connect(function(i, proc)
        if proc then return end
        if i.KeyCode == Enum.KeyCode.RightControl then
            self.visible = not self.visible
            if fadeTween then fadeTween:Cancel() end
            if self.visible then
                main.Visible = true
                fadeTween = tw(main, {GroupTransparency = 0}, 0.25)
            else
                fadeTween = tw(main, {GroupTransparency = 1}, 0.25)
                task.spawn(function()
                    task.wait(0.26)
                    if not self.visible then main.Visible = false end
                end)
            end
        end
    end)

    -- ── Entrance animation (Smooth sliding fade-in) ─────────────────
    main.GroupTransparency = 1
    main.Position = UDim2.new(0.5,-380,0.5,-220)
    tw(main,{
        Position=UDim2.new(0.5,-380,0.5,-250),
        GroupTransparency = 0,
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Store refs
    self.sg        = sg
    self.main      = main
    self.tabScroll = tabScroll
    self.content   = content

    return self
end

-- ── AddTab ───────────────────────────────────────────────────
function MaidLib:AddTab(name, icon)
    local idx = #self.tabs + 1

    -- Sidebar button
    local btn = new("TextButton",{
        Size=UDim2.new(1,0,0,42),
        BackgroundColor3=T.Surface,
        BorderSizePixel=0,
        Text="", AutoButtonColor=false,
        LayoutOrder=idx,
    }, self.tabScroll)
    corner(10, btn)
    addSquishEffect(btn)

    -- Active indicator
    local bar = new("Frame",{
        Size=UDim2.new(0,3,0,22),
        Position=UDim2.new(0,0,0.5,-11),
        BackgroundColor3=T.Accent,
        BackgroundTransparency=1, BorderSizePixel=0,
    }, btn)
    corner(3,bar)
    registerAccent(self, bar, "BackgroundColor3", "Accent")

    local IconMap = {
        ["⛏"] = "rbxassetid://10723345869",
        ["💎"] = "rbxassetid://10747373180",
        ["👁"] = "rbxassetid://10734950532",
        ["🛡"] = "rbxassetid://10734950179",
    }
    local iconId = IconMap[icon]
    
    local ico
    if iconId then
        ico = new("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 14, 0.5, -9),
            BackgroundTransparency = 1,
            Image = iconId,
            ImageColor3 = T.TextSub,
        }, btn)
    else
        ico = new("TextLabel",{
            Size=UDim2.new(0,26,1,0),
            Position=UDim2.new(0,12,0,0),
            BackgroundTransparency=1,
            Text=icon or "◆", TextSize=15, Font=FB,
            TextColor3=T.TextSub,
        }, btn)
    end

    -- Name
    local lbl = new("TextLabel",{
        Size=UDim2.new(1,-48,1,0),
        Position=UDim2.new(0,42,0,0),
        BackgroundTransparency=1,
        Text=name, TextSize=13, Font=FM,
        TextColor3=T.TextSub,
        TextXAlignment=Enum.TextXAlignment.Left,
        Active=false, Selectable=false,
    }, btn)

    -- Content page (scroll)
    local page = new("ScrollingFrame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false,
    }, self.content)
    listLayout(8, page)
    pad(16,20,16,16,page)

    local tabData = {
        name=name, btn=btn, bar=bar, ico=ico, lbl=lbl,
        page=page, n=0,
    }
    table.insert(self.tabs, tabData)

    btn.MouseEnter:Connect(function()
        if self.activetab ~= idx then
            tw(btn, {BackgroundColor3=T.SurfaceHov})
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.activetab ~= idx then
            tw(btn, {BackgroundColor3=T.Surface})
        end
    end)
    btn.Activated:Connect(function()
        self:SelectTab(idx)
    end)

    if idx == 1 then self:SelectTab(1) end
    return tabData
end

function MaidLib:SelectTab(idx)
    self.activetab = idx
    for i, t in ipairs(self.tabs) do
        local active = i == idx
        t.page.Visible = active
        tw(t.btn,  {BackgroundColor3 = active and Color3.fromHex("1C1C32") or T.Surface})
        tw(t.lbl,  {TextColor3 = active and T.Text or T.TextSub})
        tw(t.bar,  {BackgroundTransparency = active and 0 or 1})
        
        -- Color state changes
        if t.ico:IsA("ImageLabel") then
            tw(t.ico, {ImageColor3 = active and T.Accent or T.TextSub})
        else
            tw(t.ico, {TextColor3 = active and T.Accent or T.TextSub})
        end
    end
end

-- ── Section header ───────────────────────────────────────────
function MaidLib:AddSection(tab, text)
    tab.n += 1
    local f = new("Frame",{
        Size=UDim2.new(1,0,0,26),
        BackgroundTransparency=1, LayoutOrder=tab.n,
    }, tab.page)

    new("TextLabel",{
        Size=UDim2.new(1,-4,0,14),
        Position=UDim2.new(0,2,0,6),
        BackgroundTransparency=1,
        Text=string.upper(text),
        TextSize=10, Font=FB,
        TextColor3=T.Accent,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, f)

    new("Frame",{
        Size=UDim2.new(1,0,0,1),
        Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=T.Border, BorderSizePixel=0,
    }, f)
end

-- ── Toggle ───────────────────────────────────────────────────
function MaidLib:AddToggle(tab, opts)
    tab.n += 1
    local state = opts.state or false

    local row = new("Frame",{
        Size=UDim2.new(1,0,0, opts.desc and 52 or 44),
        BackgroundColor3=T.Card, BorderSizePixel=0, LayoutOrder=tab.n,
    }, tab.page)
    corner(10, row)
    registerAccent(self, row, "BackgroundColor3", "Card")
    local st = stroke(T.Border, 1, row)
    registerAccent(self, st, "Color", "Border")

    -- Hover highlights on the row body
    row.MouseEnter:Connect(function()
        tw(row, {BackgroundColor3=T.SurfaceHov}); tw(st, {Color=T.BorderHov})
    end)
    row.MouseLeave:Connect(function()
        tw(row, {BackgroundColor3=T.Card});       tw(st, {Color=T.Border})
    end)

    -- Label
    new("TextLabel",{
        Size=UDim2.new(1,-72,0,18),
        Position=UDim2.new(0,14,0, opts.desc and 8 or 13),
        BackgroundTransparency=1,
        Text=opts.text or "Toggle",
        TextSize=13, Font=FM,
        TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, row)

    if opts.desc then
        new("TextLabel",{
            Size=UDim2.new(1,-72,0,13),
            Position=UDim2.new(0,14,0,28),
            BackgroundTransparency=1,
            Text=opts.desc,
            TextSize=11, Font=FR,
            TextColor3=T.TextSub,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, row)
    end

    -- Track
    local track = new("Frame",{
        Size=UDim2.new(0,44,0,24),
        Position=UDim2.new(1,-58,0.5,-12),
        BackgroundColor3=T.Border, BorderSizePixel=0,
    }, row)
    corner(12, track)

    -- Thumb
    local thumb = new("Frame",{
        Size=UDim2.new(0,18,0,18),
        Position=UDim2.new(0,3,0.5,-9),
        BackgroundColor3=T.TextSub, BorderSizePixel=0,
    }, track)
    corner(9, thumb)

    -- Clickable toggle button covering only the track (padded for easy interaction)
    local toggleBtn = new("TextButton",{
        Size=UDim2.new(0,64,0,44),
        Position=UDim2.new(1,-68,0.5,-22),
        BackgroundTransparency=1, Text="",
    }, row)
    addSquishEffect(toggleBtn, track)

    local function setVisual(on, animate)
        local f = animate and tw or function(o,p) for k,v in pairs(p) do o[k]=v end end
        if on then
            f(track, {BackgroundColor3=T.Accent})
            f(thumb,  {Position=UDim2.new(0,23,0.5,-9), BackgroundColor3=T.White})
        else
            f(track, {BackgroundColor3=T.Border})
            f(thumb,  {Position=UDim2.new(0,3,0.5,-9), BackgroundColor3=T.TextSub})
        end
    end
    setVisual(state, false)

    toggleBtn.Activated:Connect(function()
        state = not state
        setVisual(state, true)
        if opts.callback then pcall(opts.callback, state) end
    end)

    -- Store refresh routine for theme shifts
    if not self.toggles then self.toggles = {} end
    table.insert(self.toggles, function()
        setVisual(state, false)
    end)

    local obj = {}
    function obj:Set(v) state=v; setVisual(v,true) end
    function obj:Get() return state end
    return obj
end

-- ── Button ───────────────────────────────────────────────────
function MaidLib:AddButton(tab, opts)
    tab.n += 1

    local btn = new("TextButton",{
        Size=UDim2.new(1,0,0,44),
        BackgroundColor3=T.Card, BorderSizePixel=0,
        Text="", AutoButtonColor=false, LayoutOrder=tab.n,
    }, tab.page)
    corner(10, btn)
    registerAccent(self, btn, "BackgroundColor3", "Card")
    local st = stroke(T.Border, 1, btn)
    registerAccent(self, st, "Color", "Border")
    addSquishEffect(btn)

    new("TextLabel",{
        Size=UDim2.new(1,-48,1,0),
        Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=opts.text or "Button",
        TextSize=13, Font=FM,
        TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,
        Active=false, Selectable=false,
    }, btn)

    -- Arrow badge
    local arrow = new("Frame",{
        Size=UDim2.new(0,28,0,28),
        Position=UDim2.new(1,-40,0.5,-14),
        BackgroundColor3=T.Surface, BorderSizePixel=0,
        Active=false, Selectable=false,
    }, btn)
    corner(8, arrow)
    registerAccent(self, arrow, "BackgroundColor3", "Surface")
    new("TextLabel",{
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="›", TextSize=16, Font=FB, TextColor3=T.TextSub,
        Active=false, Selectable=false,
    }, arrow)

    btn.MouseEnter:Connect(function()
        tw(btn,   {BackgroundColor3=T.SurfaceHov})
        tw(st,    {Color=T.BorderHov})
        tw(arrow, {BackgroundColor3=T.Accent})
        tw(arrow:FindFirstChildOfClass("TextLabel"), {TextColor3=T.White})
    end)
    btn.MouseLeave:Connect(function()
        tw(btn,   {BackgroundColor3=T.Card})
        tw(st,    {Color=T.Border})
        tw(arrow, {BackgroundColor3=T.Surface})
        tw(arrow:FindFirstChildOfClass("TextLabel"), {TextColor3=T.TextSub})
    end)
    btn.Activated:Connect(function()
        print("[MaidLib] Button clicked: " .. tostring(opts.text))
        if opts.callback then
            local ok, err = pcall(opts.callback)
            if not ok then
                warn("[MaidLib] Button callback error: " .. tostring(err))
            end
        end
    end)
end

-- ── TextBox ──────────────────────────────────────────────────
function MaidLib:AddBox(tab, opts)
    tab.n += 1

    local row = new("Frame",{
        Size=UDim2.new(1,0,0,56),
        BackgroundColor3=T.Card, BorderSizePixel=0, LayoutOrder=tab.n,
    }, tab.page)
    corner(10, row)
    registerAccent(self, row, "BackgroundColor3", "Card")
    local st = stroke(T.Border, 1, row)
    registerAccent(self, st, "Color", "Border")

    new("TextLabel",{
        Size=UDim2.new(1,-20,0,16),
        Position=UDim2.new(0,14,0,8),
        BackgroundTransparency=1,
        Text=opts.text or "Input",
        TextSize=11, Font=FM,
        TextColor3=T.TextSub,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, row)

    local inputBg = new("Frame",{
        Size=UDim2.new(1,-28,0,22),
        Position=UDim2.new(0,14,0,28),
        BackgroundColor3=T.Bg, BorderSizePixel=0,
    }, row)
    corner(6, inputBg)
    registerAccent(self, inputBg, "BackgroundColor3", "Bg")
    local inputStroke = stroke(T.Border, 1, inputBg)
    registerAccent(self, inputStroke, "Color", "Border")

    local box = new("TextBox",{
        Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0),
        BackgroundTransparency=1,
        Text=opts.value or "",
        PlaceholderText=opts.placeholder or "Enter value...",
        TextSize=12, Font=FM,
        TextColor3=T.Text,
        PlaceholderColor3=T.TextDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        ClearTextOnFocus=false,
    }, inputBg)

    box.Focused:Connect(function()
        tw(st, {Color=T.Accent}); tw(row, {BackgroundColor3=T.SurfaceHov})
    end)
    box.FocusLost:Connect(function(enter)
        tw(st, {Color=T.Border}); tw(row, {BackgroundColor3=T.Card})
        if enter and opts.callback then pcall(opts.callback, box.Text) end
    end)
end

-- ── Label / Info ─────────────────────────────────────────────
function MaidLib:AddLabel(tab, opts)
    tab.n += 1
    local row = new("Frame",{
        Size=UDim2.new(1,0,0,36),
        BackgroundColor3=T.Card, BorderSizePixel=0, LayoutOrder=tab.n,
    }, tab.page)
    corner(10, row)
    registerAccent(self, row, "BackgroundColor3", "Card")
    local labelStroke = stroke(T.Border, 1, row)
    registerAccent(self, labelStroke, "Color", "Border")

    new("TextLabel",{
        Size=UDim2.new(1,-28,1,0), Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=opts.text or "",
        TextSize=12, Font=FM,
        TextColor3=T.TextSub,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextWrapped=true,
    }, row)
end

-- ── Slider ───────────────────────────────────────────────────
function MaidLib:AddSlider(tab, opts)
    tab.n += 1
    local min   = opts.min   or 0
    local max   = opts.max   or 100
    local step  = opts.step  or 1
    local val   = math.clamp(opts.value or min, min, max)

    local row = new("Frame",{
        Size=UDim2.new(1,0,0,60),
        BackgroundColor3=T.Card, BorderSizePixel=0, LayoutOrder=tab.n,
    }, tab.page)
    corner(10, row)
    registerAccent(self, row, "BackgroundColor3", "Card")
    local st = stroke(T.Border, 1, row)
    registerAccent(self, st, "Color", "Border")

    -- Label + value display
    local lbl = new("TextLabel",{
        Size=UDim2.new(1,-20,0,18),
        Position=UDim2.new(0,14,0,8),
        BackgroundTransparency=1,
        Text=opts.text or "Slider",
        TextSize=13, Font=FM,
        TextColor3=T.Text,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, row)

    local valLbl = new("TextLabel",{
        Size=UDim2.new(0,60,0,18),
        Position=UDim2.new(1,-74,0,8),
        BackgroundTransparency=1,
        Text=tostring(val)..(opts.suffix or ""),
        TextSize=12, Font=FB,
        TextColor3=T.Accent,
        TextXAlignment=Enum.TextXAlignment.Right,
    }, row)
    registerAccent(self, valLbl, "TextColor3", "Accent")

    -- Track background
    local track = new("Frame",{
        Size=UDim2.new(1,-28,0,6),
        Position=UDim2.new(0,14,0,38),
        BackgroundColor3=T.Border, BorderSizePixel=0,
    }, row)
    registerAccent(self, track, "BackgroundColor3", "Border")
    corner(3, track)

    -- Filled portion
    local fill = new("Frame",{
        Size=UDim2.new((val-min)/(max-min),0,1,0),
        BackgroundColor3=T.Accent, BorderSizePixel=0,
    }, track)
    corner(3, fill)
    registerAccent(self, fill, "BackgroundColor3", "Accent")
    
    local fillGrad = gradient(ColorSequence.new({
        ColorSequenceKeypoint.new(0,T.AccentGlow),
        ColorSequenceKeypoint.new(1,T.Accent),
    }), 0, fill)
    
    -- Update gradient colors too on theme shifts (can just do registerAccent on the gradient if it was registered, but flat/tweened BackgroundColor3 handles it)

    -- Thumb
    local thumb = new("Frame",{
        Size=UDim2.new(0,16,0,16),
        Position=UDim2.new((val-min)/(max-min),-8,0.5,-8),
        BackgroundColor3=T.White, BorderSizePixel=0,
        ZIndex=5,
    }, track)
    corner(8, thumb)
    local thumbStroke = stroke(T.Accent, 2, thumb)
    registerAccent(self, thumbStroke, "Color", "Accent")

    local function updateVal(newVal)
        newVal = math.clamp(math.round(newVal/step)*step, min, max)
        val = newVal
        local pct = (val-min)/(max-min)
        fill.Size = UDim2.new(pct,0,1,0)
        thumb.Position = UDim2.new(pct,-8,0.5,-8)
        valLbl.Text = tostring(val)..(opts.suffix or "")
        if opts.callback then pcall(opts.callback, val) end
    end

    -- Draggable
    local dragging = false
    local inputArea = new("TextButton",{
        Size=UDim2.new(1,0,0,24),
        Position=UDim2.new(0,14,0,30),
        BackgroundTransparency=1, Text="",
    }, row)

    local function calcVal(inputX)
        local trackAbsX = track.AbsolutePosition.X
        local trackAbsW = track.AbsoluteSize.X
        local pct = math.clamp((inputX - trackAbsX) / trackAbsW, 0, 1)
        return min + pct*(max-min)
    end

    inputArea.MouseButton1Down:Connect(function(x,_)
        dragging = true
        updateVal(calcVal(x))
        tw(st, {Color=T.Accent})
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            updateVal(calcVal(i.Position.X))
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            tw(st, {Color=T.Border})
        end
    end)

    row.MouseEnter:Connect(function() tw(row,{BackgroundColor3=T.SurfaceHov}); tw(st,{Color=T.BorderHov}) end)
    row.MouseLeave:Connect(function()
        if not dragging then tw(row,{BackgroundColor3=T.Card}); tw(st,{Color=T.Border}) end
    end)

    local obj = {}
    function obj:Set(v) updateVal(v) end
    function obj:Get() return val end
    return obj
end

function MaidLib:SetTheme(themeName)
    local theme = Themes[themeName]
    if not theme then return end
    
    T.Accent = theme.Accent
    T.AccentB = theme.AccentB
    T.AccentGlow = theme.AccentGlow
    T.BorderHov = theme.BorderHov
    T.Bg = theme.Bg
    T.Surface = theme.Surface
    T.Card = theme.Card
    T.Border = theme.Border
    
    for _, item in ipairs(self.accentObjects) do
        if item.instance and item.instance.Parent then
            local targetColor = theme[item.colorType] or T[item.colorType]
            tw(item.instance, {[item.prop] = targetColor}, 0.3)
        end
    end
    
    for i, t in ipairs(self.tabs) do
        local active = i == self.activetab
        tw(t.btn, {BackgroundColor3 = active and T.Card or T.Surface}, 0.3)
        tw(t.lbl, {TextColor3 = active and T.Text or T.TextSub}, 0.3)
        if t.ico:IsA("ImageLabel") then
            tw(t.ico, {ImageColor3 = active and T.Accent or T.TextSub}, 0.3)
        else
            tw(t.ico, {TextColor3 = active and T.Accent or T.TextSub}, 0.3)
        end
        if t.page then
            t.page.ScrollBarImageColor3 = T.Accent
        end
    end
    
    if self.toggles then
        for _, toggleRefresh in ipairs(self.toggles) do
            pcall(toggleRefresh)
        end
    end
end

function MaidLib:SetStatus(statusText, color)
    if self.statusLabel then
        self.statusLabel.Text = statusText
        if color then self.statusLabel.TextColor3 = color end
    end
end

function MaidLib:UpdateStat(statName, value)
    if statName == "Crystals" or statName == "Mined" then
        if self.minedLabel then self.minedLabel.Text = tostring(value) end
    elseif statName == "Sold" then
        if self.soldLabel then self.soldLabel.Text = tostring(value) end
    end
end

return MaidLib
