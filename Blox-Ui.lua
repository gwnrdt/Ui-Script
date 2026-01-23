local Library = {}
Library.__index = Library

---------------- Services ----------------
local CG = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

---------------- Theme Colors ----------------
local Themes = {
    ["Purple"] = {
        Primary = Color3.fromRGB(88, 101, 242),
        Secondary = Color3.fromRGB(120, 130, 255),
        Accent = Color3.fromRGB(100, 220, 120)
    },
    ["Blue"] = {
        Primary = Color3.fromRGB(0, 150, 255),
        Secondary = Color3.fromRGB(50, 180, 255),
        Accent = Color3.fromRGB(100, 220, 255)
    },
    ["Red"] = {
        Primary = Color3.fromRGB(255, 60, 80),
        Secondary = Color3.fromRGB(255, 100, 120),
        Accent = Color3.fromRGB(255, 80, 100)
    },
    ["Orange"] = {
        Primary = Color3.fromRGB(255, 140, 0),
        Secondary = Color3.fromRGB(255, 165, 50),
        Accent = Color3.fromRGB(255, 200, 100)
    },
    ["Pink"] = {
        Primary = Color3.fromRGB(255, 105, 180),
        Secondary = Color3.fromRGB(255, 140, 200),
        Accent = Color3.fromRGB(255, 180, 220)
    },
    ["Tokyo Night"] = {
        Primary = Color3.fromRGB(125, 207, 255),
        Secondary = Color3.fromRGB(150, 220, 255),
        Accent = Color3.fromRGB(158, 206, 106)
    },
    ["Dark"] = {
        Primary = Color3.fromRGB(60, 60, 60),
        Secondary = Color3.fromRGB(80, 80, 80),
        Accent = Color3.fromRGB(150, 150, 150)
    },
    ["Cyber Neon"] = {
        Primary = Color3.fromRGB(0, 255, 200),
        Secondary = Color3.fromRGB(0, 200, 255),
        Accent = Color3.fromRGB(255, 0, 200)
    },
    ["Emerald"] = {
        Primary = Color3.fromRGB(0, 200, 120),
        Secondary = Color3.fromRGB(0, 230, 150),
        Accent = Color3.fromRGB(180, 255, 200)
    },
    ["Galaxy"] = {
        Primary = Color3.fromRGB(75, 0, 130),
        Secondary = Color3.fromRGB(138, 43, 226),
        Accent = Color3.fromRGB(255, 20, 147)
    },
    ["Crimson"] = {
        Primary = Color3.fromRGB(220, 20, 60),
        Secondary = Color3.fromRGB(255, 99, 71),
        Accent = Color3.fromRGB(255, 160, 122)
    },
    ["Mint"] = {
        Primary = Color3.fromRGB(152, 255, 204),
        Secondary = Color3.fromRGB(128, 255, 212),
        Accent = Color3.fromRGB(64, 224, 208)
    },
    ["Vanta Black"] = {
        Primary = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(255, 40, 60)
    },
    ["Aurora"] = {
        Primary = Color3.fromRGB(0, 255, 150),
        Secondary = Color3.fromRGB(100, 200, 255),
        Accent = Color3.fromRGB(255, 100, 200)
    },
    ["Gold"] = {
        Primary = Color3.fromRGB(255, 215, 0),
        Secondary = Color3.fromRGB(255, 230, 80),
        Accent = Color3.fromRGB(255, 255, 150)
    },
    ["Lime"] = {
        Primary = Color3.fromRGB(50, 205, 50),
        Secondary = Color3.fromRGB(100, 255, 100),
        Accent = Color3.fromRGB(180, 255, 150)
    },
    ["Sky"] = {
        Primary = Color3.fromRGB(100, 200, 255),
        Secondary = Color3.fromRGB(130, 230, 255),
        Accent = Color3.fromRGB(180, 255, 255)
    },
    ["Ice"] = {
        Primary = Color3.fromRGB(180, 240, 255),
        Secondary = Color3.fromRGB(150, 220, 255),
        Accent = Color3.fromRGB(200, 255, 255)
    },
    ["Rose Gold"] = {
        Primary = Color3.fromRGB(255, 180, 180),
        Secondary = Color3.fromRGB(255, 200, 200),
        Accent = Color3.fromRGB(255, 220, 220)
    },
    ["Void"] = {
        Primary = Color3.fromRGB(20, 20, 40),
        Secondary = Color3.fromRGB(40, 40, 80),
        Accent = Color3.fromRGB(180, 0, 255)
    },
    ["Matrix"] = {
        Primary = Color3.fromRGB(0, 255, 70),
        Secondary = Color3.fromRGB(50, 255, 120),
        Accent = Color3.fromRGB(0, 200, 60)
    },
    ["Cyan Pulse"] = {
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(100, 255, 255),
        Accent = Color3.fromRGB(0, 180, 200)
    },
    ["Inferno"] = {
        Primary = Color3.fromRGB(255, 60, 0),
        Secondary = Color3.fromRGB(255, 100, 0),
        Accent = Color3.fromRGB(255, 160, 60)
    },
    ["Plasma"] = {
        Primary = Color3.fromRGB(255, 0, 200),
        Secondary = Color3.fromRGB(150, 0, 255),
        Accent = Color3.fromRGB(0, 150, 255)
    },
    ["Arctic"] = {
        Primary = Color3.fromRGB(180, 250, 255),
        Secondary = Color3.fromRGB(200, 255, 255),
        Accent = Color3.fromRGB(120, 220, 255)
    },
    ["Shadow"] = {
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(50, 50, 50),
        Accent = Color3.fromRGB(90, 90, 90)
    },
    ["Midnight"] = {
        Primary = Color3.fromRGB(25, 25, 112),
        Secondary = Color3.fromRGB(75, 0, 130),
        Accent = Color3.fromRGB(100, 149, 237)
    },
    ["Ocean"] = {
        Primary = Color3.fromRGB(0, 105, 148),
        Secondary = Color3.fromRGB(0, 168, 232),
        Accent = Color3.fromRGB(72, 209, 204)
    },
    ["Toxic"] = {
        Primary = Color3.fromRGB(173, 255, 47),
        Secondary = Color3.fromRGB(192, 255, 62),
        Accent = Color3.fromRGB(100, 255, 100)
    },
    ["Royal"] = {
        Primary = Color3.fromRGB(65, 105, 225),
        Secondary = Color3.fromRGB(100, 149, 237),
        Accent = Color3.fromRGB(176, 224, 230)
    },
    ["Flame"] = {
        Primary = Color3.fromRGB(255, 87, 34),
        Secondary = Color3.fromRGB(255, 138, 101),
        Accent = Color3.fromRGB(255, 204, 128)
    },
    ["Bliss"] = {
        Primary = Color3.fromRGB(186, 85, 211),
        Secondary = Color3.fromRGB(221, 160, 221),
        Accent = Color3.fromRGB(238, 130, 238)
    },
    ["Steel"] = {
        Primary = Color3.fromRGB(70, 80, 90),
        Secondary = Color3.fromRGB(100, 110, 120),
        Accent = Color3.fromRGB(160, 170, 180)
    },
    ["Eclipse"] = {
        Primary = Color3.fromRGB(30, 0, 50),
        Secondary = Color3.fromRGB(60, 0, 90),
        Accent = Color3.fromRGB(255, 100, 200)
    }
}


local CurrentTheme = Themes["Orange"]
local activeTweens = {}

---------------- Utils ----------------
local function r(o, rad)
    local c = Instance.new("UICorner", o)
    c.CornerRadius = UDim.new(0, rad or 10)
    return c
end

local function addStroke(o, color, thickness)
    local stroke = Instance.new("UIStroke", o)
    stroke.Color = color or CurrentTheme.Primary
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.3
    return stroke
end

local function tweenProp(obj, prop, value, duration, style)
    -- Cancel existing tween on same object/property to prevent lag
    local key = tostring(obj) .. prop
    if activeTweens[key] then
        activeTweens[key]:Cancel()
    end
    
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.15, style or Enum.EasingStyle.Quad), {[prop] = value})
    activeTweens[key] = tween
    tween:Play()
    
    tween.Completed:Connect(function()
        activeTweens[key] = nil
    end)
    
    return tween
end

local function isRobloxAssetId(icon)
    return type(icon) == "string" and (icon:match("^rbxassetid://") or icon:match("^%d+$"))
end

---------------- Drag System ----------------
local function addDrag(handle, target)
    handle.Active, target.Active = true, true
    local dragging, dragStart, startPos = false, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

---------------- Window Creation ----------------
function Library:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    
    local windowName = config.Name or "Modern UI"
    local themeName = config.Theme or "Purple"
    CurrentTheme = Themes[themeName] or Themes["Purple"]
    
    ---------------- Root GUI ----------------
    pcall(function()
        if CG:FindFirstChild("ModernUI") then
            CG.ModernUI:Destroy()
        end
    end)

    local gui = Instance.new("ScreenGui", CG)
    gui.Name = "ModernUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    ---------------- Toggle Button ----------------
    local toggle = Instance.new("TextButton", gui)
    toggle.Size = UDim2.fromOffset(50, 50)
    toggle.Position = UDim2.new(0, 25, 0.5, -25)
    toggle.BackgroundColor3 = CurrentTheme.Primary
    toggle.BackgroundTransparency = 0.1
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.ZIndex = 10
    r(toggle, 14)
    addStroke(toggle, CurrentTheme.Secondary, 2)

    local toggleIcon = Instance.new("ImageLabel", toggle)
    toggleIcon.Size = UDim2.fromScale(0.5, 0.5)
    toggleIcon.Position = UDim2.fromScale(0.25, 0.25)
    toggleIcon.BackgroundTransparency = 1
    toggleIcon.Image = "rbxassetid://3926305904"
    toggleIcon.ImageColor3 = Color3.new(1, 1, 1)
    toggleIcon.ImageRectOffset = Vector2.new(644, 204)
    toggleIcon.ImageRectSize = Vector2.new(36, 36)

    addDrag(toggle, toggle)

    toggle.MouseEnter:Connect(function()
        tweenProp(toggle, "Size", UDim2.fromOffset(55, 55), 0.12, Enum.EasingStyle.Quad)
        tweenProp(toggleIcon, "Rotation", 180, 0.2)
    end)

    toggle.MouseLeave:Connect(function()
        tweenProp(toggle, "Size", UDim2.fromOffset(50, 50), 0.12, Enum.EasingStyle.Quad)
        tweenProp(toggleIcon, "Rotation", 0, 0.2)
    end)

    ---------------- Main Window ----------------
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(550, 380)
    main.Position = UDim2.new(0.5, -275, 0.5, -190)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.ZIndex = 5
    r(main, 14)
    addStroke(main, Color3.fromRGB(30, 30, 30), 1)

    ---------------- Title Bar ----------------
    local titleBar = Instance.new("Frame", main)
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    titleBar.BackgroundTransparency = 0
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 6
    titleBar.ClipsDescendants = true
    addDrag(titleBar, main)
    r(titleBar, 14)

    local titleCover = Instance.new("Frame", titleBar)
    titleCover.Size = UDim2.new(1, 0, 0, 14)
    titleCover.Position = UDim2.new(0, 0, 1, -14)
    titleCover.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    titleCover.BackgroundTransparency = 0
    titleCover.BorderSizePixel = 0
    titleCover.ZIndex = 6

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.fromOffset(18, 0)
    title.BackgroundTransparency = 1
    title.Text = windowName
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = CurrentTheme.Primary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 7

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.fromOffset(34, 34)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -17)
    closeBtn.Text = ""
    closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 8
    closeBtn.AutoButtonColor = false
    r(closeBtn, 8)

    local closeIcon = Instance.new("TextLabel", closeBtn)
    closeIcon.Size = UDim2.fromScale(1, 1)
    closeIcon.BackgroundTransparency = 1
    closeIcon.Text = "×"
    closeIcon.Font = Enum.Font.GothamBold
    closeIcon.TextSize = 22
    closeIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeIcon.ZIndex = 9

    closeBtn.MouseEnter:Connect(function()
        tweenProp(closeBtn, "BackgroundColor3", Color3.fromRGB(255, 60, 60), 0.12)
        tweenProp(closeIcon, "TextColor3", Color3.new(1, 1, 1), 0.12)
    end)

    closeBtn.MouseLeave:Connect(function()
        tweenProp(closeBtn, "BackgroundColor3", Color3.fromRGB(20, 20, 20), 0.12)
        tweenProp(closeIcon, "TextColor3", Color3.fromRGB(255, 100, 100), 0.12)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        tweenProp(main, "Size", UDim2.fromOffset(0, 0), 0.15)
        task.wait(0.15)
        main.Visible = false
        main.Size = UDim2.fromOffset(550, 380)
    end)

    toggle.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
        if main.Visible then
            main.Size = UDim2.fromOffset(0, 0)
            tweenProp(main, "Size", UDim2.fromOffset(550, 380), 0.2, Enum.EasingStyle.Back)
        end
    end)

    ---------------- Status Bar ----------------
    local statusBar = Instance.new("Frame", main)
    statusBar.Size = UDim2.new(1, 0, 0, 30)
    statusBar.Position = UDim2.fromOffset(0, 50)
    statusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statusBar.BackgroundTransparency = 0
    statusBar.BorderSizePixel = 0
    statusBar.ZIndex = 6

    local statusIcon = Instance.new("Frame", statusBar)
    statusIcon.Size = UDim2.fromOffset(7, 7)
    statusIcon.Position = UDim2.fromOffset(18, 11)
    statusIcon.BackgroundColor3 = CurrentTheme.Accent
    statusIcon.BorderSizePixel = 0
    statusIcon.ZIndex = 7
    r(statusIcon, 4)

    spawn(function()
        while wait(1.5) do
            tweenProp(statusIcon, "Size", UDim2.fromOffset(9, 9), 0.3)
            tweenProp(statusIcon, "BackgroundTransparency", 0.5, 0.3)
            wait(0.3)
            tweenProp(statusIcon, "Size", UDim2.fromOffset(7, 7), 0.3)
            tweenProp(statusIcon, "BackgroundTransparency", 0, 0.3)
        end
    end)

    local status = Instance.new("TextLabel", statusBar)
    status.Size = UDim2.new(1, -35, 1, 0)
    status.Position = UDim2.fromOffset(32, 0)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextColor3 = Color3.fromRGB(150, 160, 180)
    status.Text = "Script Lynx Hub"
    status.ZIndex = 7

    ---------------- Side Navigation ----------------
    local sideNav = Instance.new("ScrollingFrame", main)
    sideNav.Size = UDim2.new(0, 120, 1, -80)
    sideNav.Position = UDim2.fromOffset(0, 80)
    sideNav.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sideNav.BackgroundTransparency = 0
    sideNav.BorderSizePixel = 0
    sideNav.ZIndex = 6
    sideNav.ClipsDescendants = true
    sideNav.ScrollBarThickness = 3
    sideNav.ScrollBarImageColor3 = Color3.fromRGB(60, 65, 80)
    sideNav.ScrollBarImageTransparency = 0.4
    sideNav.CanvasSize = UDim2.new(0, 0, 0, 0)

    local navCover = Instance.new("Frame", sideNav)
    navCover.Size = UDim2.new(1, 0, 0, 14)
    navCover.Position = UDim2.new(0, 0, 1, -14)
    navCover.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    navCover.BackgroundTransparency = 0
    navCover.BorderSizePixel = 0
    navCover.ZIndex = 6

    local navLayout = Instance.new("UIListLayout", sideNav)
    navLayout.Padding = UDim.new(0, 5)
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sideNav.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 24)
    end)

    local navPad = Instance.new("UIPadding", sideNav)
    navPad.PaddingTop = UDim.new(0, 12)
    navPad.PaddingLeft = UDim.new(0, 8)
    navPad.PaddingRight = UDim.new(0, 8)

    ---------------- Content Container ----------------
    local contentContainer = Instance.new("Frame", main)
    contentContainer.Size = UDim2.new(1, -120, 1, -80)
    contentContainer.Position = UDim2.fromOffset(120, 80)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ZIndex = 6

    ---------------- Tab Creation ----------------
    function Window:CreateTab(tabName, icon)
        local Tab = {}
        icon = icon or "📄"
        
        local tabButton = Instance.new("TextButton", sideNav)
        tabButton.Size = UDim2.new(1, 0, 0, 38)
        tabButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        tabButton.BackgroundTransparency = 0.3
        tabButton.BorderSizePixel = 0
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.ZIndex = 7
        r(tabButton, 8)

        local indicator = Instance.new("Frame", tabButton)
        indicator.Size = UDim2.new(0, 3, 0, 18)
        indicator.Position = UDim2.fromOffset(0, 10)
        indicator.BackgroundColor3 = CurrentTheme.Primary
        indicator.BorderSizePixel = 0
        indicator.Visible = false
        indicator.ZIndex = 8
        r(indicator, 2)

        -- Create icon element (either ImageLabel for asset IDs or TextLabel for emojis)
        local iconLabel
        if isRobloxAssetId(icon) then
            iconLabel = Instance.new("ImageLabel", tabButton)
            iconLabel.Size = UDim2.fromOffset(18, 18)
            iconLabel.Position = UDim2.fromOffset(12, 10)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Image = icon:match("^rbxassetid://") and icon or ("rbxassetid://" .. icon)
            iconLabel.ImageColor3 = Color3.fromRGB(140, 150, 170)
            iconLabel.ZIndex = 8
        else
            iconLabel = Instance.new("TextLabel", tabButton)
            iconLabel.Size = UDim2.fromOffset(18, 18)
            iconLabel.Position = UDim2.fromOffset(12, 10)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Text = icon
            iconLabel.Font = Enum.Font.GothamBold
            iconLabel.TextSize = 14
            iconLabel.TextColor3 = Color3.fromRGB(140, 150, 170)
            iconLabel.ZIndex = 8
        end

        local nameLabel = Instance.new("TextLabel", tabButton)
        nameLabel.Size = UDim2.new(1, -38, 1, 0)
        nameLabel.Position = UDim2.fromOffset(38, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = tabName
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextSize = 12
        nameLabel.TextColor3 = Color3.fromRGB(140, 150, 170)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 8

        local contentFrame = Instance.new("ScrollingFrame", contentContainer)
        contentFrame.Size = UDim2.new(1, -24, 1, -16)
        contentFrame.Position = UDim2.fromOffset(12, 8)
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.ScrollBarThickness = 3
        contentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 65, 80)
        contentFrame.ScrollBarImageTransparency = 0.4
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.Visible = false
        contentFrame.ZIndex = 7

        local contentLayout = Instance.new("UIListLayout", contentFrame)
        contentLayout.Padding = UDim.new(0, 12)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 12)
        end)

        Tab.Active = false
        Tab.Button = tabButton
        Tab.Content = contentFrame
        Tab.Indicator = indicator
        Tab.Icon = iconLabel
        Tab.Name = nameLabel

        tabButton.MouseEnter:Connect(function()
            if not Tab.Active then
                tweenProp(tabButton, "BackgroundTransparency", 0.1, 0.1)
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if not Tab.Active then
                tweenProp(tabButton, "BackgroundTransparency", 0.3, 0.1)
            end
        end)

        tabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                if tab.Active then
                    tab.Active = false
                    tab.Indicator.Visible = false
                    tab.Content.Visible = false
                    tab.Button.BackgroundTransparency = 0.3
                    tab.Button.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                    
                    -- Handle both ImageLabel and TextLabel
                    if tab.Icon:IsA("ImageLabel") then
                        tab.Icon.ImageColor3 = Color3.fromRGB(140, 150, 170)
                    else
                        tab.Icon.TextColor3 = Color3.fromRGB(140, 150, 170)
                    end
                    tab.Name.TextColor3 = Color3.fromRGB(140, 150, 170)
                end
            end

            Tab.Active = true
            Tab.Indicator.Visible = true
            Tab.Content.Visible = true
            tabButton.BackgroundTransparency = 0
            tabButton.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
            
            -- Handle both ImageLabel and TextLabel
            if iconLabel:IsA("ImageLabel") then
                iconLabel.ImageColor3 = Color3.new(1, 1, 1)
            else
                iconLabel.TextColor3 = Color3.new(1, 1, 1)
            end
            nameLabel.TextColor3 = Color3.new(1, 1, 1)
        end)

        ---------------- Tab Elements ----------------
        function Tab:CreateSection(sectionName)
            local Section = {}
            
            local section = Instance.new("Frame", contentFrame)
            section.Size = UDim2.new(1, 0, 0, 0)
            section.BackgroundTransparency = 1
            section.AutomaticSize = Enum.AutomaticSize.Y
            section.ZIndex = 8
            section.ClipsDescendants = false

            local layout = Instance.new("UIListLayout", section)
            layout.Padding = UDim.new(0, 8)
            layout.SortOrder = Enum.SortOrder.LayoutOrder

            local contentHolder = Instance.new("Frame", section)
            contentHolder.Size = UDim2.new(1, 0, 0, 0)
            contentHolder.BackgroundTransparency = 1
            contentHolder.AutomaticSize = Enum.AutomaticSize.Y
            contentHolder.ZIndex = 8
            contentHolder.LayoutOrder = 1
            contentHolder.Visible = true

            local contentLayout = Instance.new("UIListLayout", contentHolder)
            contentLayout.Padding = UDim.new(0, 8)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

            if sectionName then
                local headerBtn = Instance.new("TextButton", section)
                headerBtn.Size = UDim2.new(1, 0, 0, 28)
                headerBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                headerBtn.BackgroundTransparency = 0.3
                headerBtn.BorderSizePixel = 0
                headerBtn.Text = ""
                headerBtn.AutoButtonColor = false
                headerBtn.ZIndex = 9
                headerBtn.LayoutOrder = 0
                r(headerBtn, 8)

                local arrow = Instance.new("TextLabel", headerBtn)
                arrow.Size = UDim2.fromOffset(16, 16)
                arrow.Position = UDim2.fromOffset(8, 6)
                arrow.BackgroundTransparency = 1
                arrow.Text = "▼"
                arrow.Font = Enum.Font.GothamBold
                arrow.TextSize = 10
                arrow.TextColor3 = CurrentTheme.Primary
                arrow.ZIndex = 10

                local titleLabel = Instance.new("TextLabel", headerBtn)
                titleLabel.Size = UDim2.new(1, -30, 1, 0)
                titleLabel.Position = UDim2.fromOffset(30, 0)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = sectionName
                titleLabel.Font = Enum.Font.GothamBold
                titleLabel.TextSize = 13
                titleLabel.TextColor3 = Color3.fromRGB(200, 210, 230)
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.ZIndex = 10

                local expanded = true

                headerBtn.MouseEnter:Connect(function()
                    tweenProp(headerBtn, "BackgroundTransparency", 0.1, 0.1)
                end)

                headerBtn.MouseLeave:Connect(function()
                    tweenProp(headerBtn, "BackgroundTransparency", 0.3, 0.1)
                end)

                headerBtn.MouseButton1Click:Connect(function()
                    expanded = not expanded
                    contentHolder.Visible = expanded

                    if expanded then
                        arrow.Rotation = 0
                        titleLabel.TextColor3 = Color3.fromRGB(200, 210, 230)
                    else
                        arrow.Rotation = -90
                        titleLabel.TextColor3 = Color3.fromRGB(120, 130, 150)
                    end
                end)
            end
            
            function Section:CreateButton(btnText, callback)
                local btn = Instance.new("TextButton", contentHolder)
                btn.Size = UDim2.new(1, 0, 0, 34)
                btn.BackgroundColor3 = CurrentTheme.Primary
                btn.BackgroundTransparency = 0.1
                btn.Text = btnText
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 12
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.AutoButtonColor = false
                btn.BorderSizePixel = 0
                btn.ZIndex = 9
                r(btn, 8)

                btn.MouseEnter:Connect(function()
                    tweenProp(btn, "BackgroundTransparency", 0, 0.1)
                end)

                btn.MouseLeave:Connect(function()
                    tweenProp(btn, "BackgroundTransparency", 0.1, 0.1)
                end)

                if callback then
                    btn.MouseButton1Click:Connect(callback)
                end
                
                return btn
            end
            
            function Section:CreateToggle(toggleText, default, callback)
                local container = Instance.new("TextButton", contentHolder)
                container.Size = UDim2.new(1, 0, 0, 34)
                container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                container.BackgroundTransparency = 0.3
                container.BorderSizePixel = 0
                container.Text = ""
                container.AutoButtonColor = false
                container.ZIndex = 9
                r(container, 8)

                local label = Instance.new("TextLabel", container)
                label.Size = UDim2.new(1, -50, 1, 0)
                label.Position = UDim2.fromOffset(12, 0)
                label.BackgroundTransparency = 1
                label.Text = toggleText
                label.Font = Enum.Font.GothamSemibold
                label.TextSize = 12
                label.TextColor3 = Color3.fromRGB(200, 210, 230)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 10

                local toggleBtn = Instance.new("Frame", container)
                toggleBtn.Size = UDim2.fromOffset(40, 20)
                toggleBtn.Position = UDim2.new(1, -48, 0.5, -10)
                toggleBtn.BackgroundColor3 = default and CurrentTheme.Primary or Color3.fromRGB(50, 55, 70)
                toggleBtn.BorderSizePixel = 0
                toggleBtn.ZIndex = 10
                r(toggleBtn, 10)

                local knob = Instance.new("Frame", toggleBtn)
                knob.Size = UDim2.fromOffset(16, 16)
                knob.Position = default and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
                knob.BackgroundColor3 = Color3.new(1, 1, 1)
                knob.BorderSizePixel = 0
                knob.ZIndex = 11
                r(knob, 8)

                local toggled = default or false

                container.MouseEnter:Connect(function()
                    tweenProp(container, "BackgroundTransparency", 0.1, 0.1)
                end)

                container.MouseLeave:Connect(function()
                    tweenProp(container, "BackgroundTransparency", 0.3, 0.1)
                end)

                container.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        tweenProp(toggleBtn, "BackgroundColor3", CurrentTheme.Primary, 0.15)
                        tweenProp(knob, "Position", UDim2.fromOffset(22, 2), 0.15)
                    else
                        tweenProp(toggleBtn, "BackgroundColor3", Color3.fromRGB(50, 55, 70), 0.15)
                        tweenProp(knob, "Position", UDim2.fromOffset(2, 2), 0.15)
                    end

                    if callback then
                        callback(toggled)
                    end
                end)
                
                return container
            end
            
            function Section:CreateSlider(sliderText, min, max, default, callback)
                local container = Instance.new("Frame", contentHolder)
                container.Size = UDim2.new(1, 0, 0, 50)
                container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                container.BackgroundTransparency = 0.3
                container.BorderSizePixel = 0
                container.ZIndex = 9
                r(container, 8)

                local label = Instance.new("TextLabel", container)
                label.Size = UDim2.new(1, -24, 0, 20)
                label.Position = UDim2.fromOffset(12, 8)
                label.BackgroundTransparency = 1
                label.Text = sliderText
                label.Font = Enum.Font.GothamSemibold
                label.TextSize = 12
                label.TextColor3 = Color3.fromRGB(200, 210, 230)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 10

                local valueLabel = Instance.new("TextLabel", container)
                valueLabel.Size = UDim2.fromOffset(40, 20)
                valueLabel.Position = UDim2.new(1, -52, 0, 8)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(default)
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextSize = 11
                valueLabel.TextColor3 = CurrentTheme.Primary
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.ZIndex = 10

                local sliderBg = Instance.new("Frame", container)
                sliderBg.Size = UDim2.new(1, -24, 0, 4)
                sliderBg.Position = UDim2.fromOffset(12, 36)
                sliderBg.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
                sliderBg.BorderSizePixel = 0
                sliderBg.ZIndex = 10
                r(sliderBg, 2)

                local sliderFill = Instance.new("Frame", sliderBg)
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = CurrentTheme.Primary
                sliderFill.BorderSizePixel = 0
                sliderFill.ZIndex = 11
                r(sliderFill, 2)

                local sliderKnob = Instance.new("Frame", sliderBg)
                sliderKnob.Size = UDim2.fromOffset(12, 12)
                sliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
                sliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
                sliderKnob.BorderSizePixel = 0
                sliderKnob.ZIndex = 12
                r(sliderKnob, 6)

                local dragging = false

                container.MouseEnter:Connect(function()
                    tweenProp(container, "BackgroundTransparency", 0.1, 0.1)
                end)

                container.MouseLeave:Connect(function()
                    if not dragging then
                        tweenProp(container, "BackgroundTransparency", 0.3, 0.1)
                    end
                end)

                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)

                sliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        tweenProp(container, "BackgroundTransparency", 0.3, 0.1)
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * relativeX)

                        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                        sliderKnob.Position = UDim2.new(relativeX, -6, 0.5, -6)
                        valueLabel.Text = tostring(value)

                        if callback then
                            callback(value)
                        end
                    end
                end)
                
                return container
            end
            
            function Section:CreateDropdown(dropText, options, default, callback)
                local container = Instance.new("Frame", contentHolder)
                container.Size = UDim2.new(1, 0, 0, 34)
                container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                container.BackgroundTransparency = 0.3
                container.BorderSizePixel = 0
                container.ZIndex = 9
                container.ClipsDescendants = false
                r(container, 8)

                local label = Instance.new("TextLabel", container)
                label.Size = UDim2.new(0.35, 0, 1, 0)
                label.Position = UDim2.fromOffset(12, 0)
                label.BackgroundTransparency = 1
                label.Text = dropText
                label.Font = Enum.Font.GothamSemibold
                label.TextSize = 12
                label.TextColor3 = Color3.fromRGB(200, 210, 230)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 10

                local dropBtn = Instance.new("TextButton", container)
                dropBtn.Size = UDim2.new(0.65, -18, 1, -6)
                dropBtn.Position = UDim2.new(0.35, 6, 0, 3)
                dropBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                dropBtn.BorderSizePixel = 0
                dropBtn.Text = ""
                dropBtn.AutoButtonColor = false
                dropBtn.ZIndex = 10
                r(dropBtn, 7)

                local dropStroke = addStroke(dropBtn, Color3.fromRGB(35, 35, 35), 1)

                local btnText = Instance.new("TextLabel", dropBtn)
                btnText.Size = UDim2.new(1, -36, 1, 0)
                btnText.Position = UDim2.fromOffset(10, 0)
                btnText.BackgroundTransparency = 1
                btnText.Text = default or options[1] or "Select..."
                btnText.Font = Enum.Font.GothamMedium
                btnText.TextSize = 11
                btnText.TextColor3 = Color3.fromRGB(200, 210, 230)
                btnText.TextXAlignment = Enum.TextXAlignment.Left
                btnText.TextTruncate = Enum.TextTruncate.AtEnd
                btnText.ZIndex = 11

                local arrow = Instance.new("TextLabel", dropBtn)
                arrow.Size = UDim2.fromOffset(20, 20)
                arrow.Position = UDim2.new(1, -22, 0.5, -10)
                arrow.BackgroundTransparency = 1
                arrow.Text = "▼"
                arrow.Font = Enum.Font.GothamBold
                arrow.TextSize = 9
                arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
                arrow.ZIndex = 11

                local dropListContainer = Instance.new("Frame", gui)
                dropListContainer.BackgroundTransparency = 1
                dropListContainer.Visible = false
                dropListContainer.ZIndex = 150
                dropListContainer.Size = UDim2.new(0, 200, 0, 200)

                local shadow = Instance.new("Frame", dropListContainer)
                shadow.Size = UDim2.new(1, 10, 1, 10)
                shadow.Position = UDim2.fromOffset(-5, -5)
                shadow.BackgroundColor3 = Color3.new(0, 0, 0)
                shadow.BackgroundTransparency = 0.5
                shadow.BorderSizePixel = 0
                shadow.ZIndex = 150
                r(shadow, 8)

                local dropList = Instance.new("ScrollingFrame", dropListContainer)
                dropList.Size = UDim2.new(1, 0, 1, 0)
                dropList.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
                dropList.BackgroundTransparency = 0.1
                dropList.BorderSizePixel = 0
                dropList.ZIndex = 151
                dropList.ScrollBarThickness = 3
                dropList.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
                dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
                dropList.ScrollingDirection = Enum.ScrollingDirection.Y
                r(dropList, 7)

                local dropListStroke = addStroke(dropList, Color3.fromRGB(40, 40, 40), 1)
                dropListStroke.Transparency = 0

                local listLayout = Instance.new("UIListLayout", dropList)
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Padding = UDim.new(0, 2)

                local listPadding = Instance.new("UIPadding", dropList)
                listPadding.PaddingTop = UDim.new(0, 4)
                listPadding.PaddingBottom = UDim.new(0, 4)

                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
                end)

                local selectedOption = default or options[1]

                for i, option in ipairs(options) do
                    local optBtn = Instance.new("TextButton", dropList)
                    optBtn.Size = UDim2.new(1, -8, 0, 30)
                    optBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    optBtn.BackgroundTransparency = 0.3
                    optBtn.BorderSizePixel = 0
                    optBtn.Text = ""
                    optBtn.AutoButtonColor = false
                    optBtn.ZIndex = 152

                    local optText = Instance.new("TextLabel", optBtn)
                    optText.Size = UDim2.new(1, -32, 1, 0)
                    optText.Position = UDim2.fromOffset(10, 0)
                    optText.BackgroundTransparency = 1
                    optText.Text = option
                    optText.Font = Enum.Font.Gotham
                    optText.TextSize = 11
                    optText.TextColor3 = Color3.fromRGB(180, 190, 210)
                    optText.TextXAlignment = Enum.TextXAlignment.Left
                    optText.ZIndex = 153

                    local checkmark = Instance.new("TextLabel", optBtn)
                    checkmark.Size = UDim2.fromOffset(18, 18)
                    checkmark.Position = UDim2.new(1, -24, 0.5, -9)
                    checkmark.BackgroundTransparency = 1
                    checkmark.Text = "✓"
                    checkmark.Font = Enum.Font.GothamBold
                    checkmark.TextSize = 13
                    checkmark.TextColor3 = Color3.fromRGB(200, 200, 200)
                    checkmark.Visible = (option == selectedOption)
                    checkmark.ZIndex = 153

                    if option == selectedOption then
                        optBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                        optBtn.BackgroundTransparency = 0
                        optText.TextColor3 = Color3.fromRGB(240, 245, 255)
                    end

                    optBtn.MouseEnter:Connect(function()
                        if option ~= selectedOption then
                            optBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            optBtn.BackgroundTransparency = 0
                            optText.TextColor3 = Color3.fromRGB(240, 245, 255)
                        end
                    end)

                    optBtn.MouseLeave:Connect(function()
                        if option ~= selectedOption then
                            optBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                            optBtn.BackgroundTransparency = 0.3
                            optText.TextColor3 = Color3.fromRGB(180, 190, 210)
                        end
                    end)

                    optBtn.MouseButton1Click:Connect(function()
                        selectedOption = option
                        btnText.Text = option

                        for _, child in pairs(dropList:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                                child.BackgroundTransparency = 0.3
                                local childText = child:FindFirstChildOfClass("TextLabel")
                                if childText then
                                    childText.TextColor3 = Color3.fromRGB(180, 190, 210)
                                end
                                for _, subChild in pairs(child:GetChildren()) do
                                    if subChild:IsA("TextLabel") and subChild.Text == "✓" then
                                        subChild.Visible = false
                                    end
                                end
                            end
                        end

                        optBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                        optBtn.BackgroundTransparency = 0
                        optText.TextColor3 = Color3.fromRGB(240, 245, 255)
                        checkmark.Visible = true

                        dropListContainer.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
                        shadow.BackgroundTransparency = 1
                        arrow.Rotation = 0
                        dropListContainer.Visible = false

                        if callback then
                            callback(option)
                        end
                    end)
                end

                local function updateDropdownPosition()
                    local btnPos = dropBtn.AbsolutePosition
                    local btnSize = dropBtn.AbsoluteSize
                    local maxHeight = 140
                    local contentHeight = math.min(#options * 32 + 8, maxHeight)

                    dropListContainer.Position = UDim2.fromOffset(btnPos.X, btnPos.Y + btnSize.Y + 6)
                    if not dropListContainer.Visible then
                        dropListContainer.Size = UDim2.new(0, btnSize.X, 0, 0)
                    end
                end

                spawn(function()
                    while wait(0.5) do
                        if dropListContainer.Visible then
                            updateDropdownPosition()
                        end
                    end
                end)

                container.MouseEnter:Connect(function()
                    tweenProp(container, "BackgroundTransparency", 0.1, 0.1)
                end)

                container.MouseLeave:Connect(function()
                    tweenProp(container, "BackgroundTransparency", 0.3, 0.1)
                end)

                dropBtn.MouseEnter:Connect(function()
                    tweenProp(dropBtn, "BackgroundColor3", Color3.fromRGB(20, 20, 20), 0.1)
                end)

                dropBtn.MouseLeave:Connect(function()
                    tweenProp(dropBtn, "BackgroundColor3", Color3.fromRGB(15, 15, 15), 0.1)
                end)

                dropBtn.MouseButton1Click:Connect(function()
                    if dropListContainer.Visible then
                        dropListContainer.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
                        shadow.BackgroundTransparency = 1
                        arrow.Rotation = 0
                        dropListContainer.Visible = false
                    else
                        updateDropdownPosition()
                        dropListContainer.Visible = true
                        shadow.BackgroundTransparency = 0.5
                        local maxHeight = 140
                        local contentHeight = math.min(#options * 32 + 8, maxHeight)
                        dropListContainer.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, contentHeight)
                        arrow.Rotation = 180
                        dropList.CanvasPosition = Vector2.new(0, 0)
                    end
                end)
                
                return container
            end
            
            function Section:CreateTextBox(placeholder, callback)
                local box = Instance.new("TextBox", contentHolder)
                box.Size = UDim2.new(1, 0, 0, 34)
                box.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                box.BackgroundTransparency = 0.3
                box.Text = ""
                box.PlaceholderText = placeholder
                box.PlaceholderColor3 = Color3.fromRGB(100, 110, 130)
                box.TextColor3 = Color3.fromRGB(220, 225, 240)
                box.Font = Enum.Font.Gotham
                box.TextSize = 12
                box.BorderSizePixel = 0
                box.ClearTextOnFocus = false
                box.TextStrokeTransparency = 1
                box.TextTransparency = 0
                box.ZIndex = 9
                r(box, 8)

                local padding = Instance.new("UIPadding", box)
                padding.PaddingLeft = UDim.new(0, 12)

                local stroke = addStroke(box, Color3.fromRGB(40, 45, 60), 1)
                stroke.Transparency = 0

                box.Focused:Connect(function()
                    tweenProp(box, "BackgroundTransparency", 0.1, 0.1)
                    tweenProp(box, "BackgroundColor3", Color3.fromRGB(20, 20, 20), 0.1)
                end)

                box.FocusLost:Connect(function()
                    tweenProp(box, "BackgroundTransparency", 0.3, 0.1)
                    tweenProp(box, "BackgroundColor3", Color3.fromRGB(18, 18, 18), 0.1)
                    if callback then
                        callback(box.Text)
                    end
                end)
                
                return box
            end
            
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-activate first tab
        if #Window.Tabs == 1 then
            task.spawn(function()
                task.wait(0.1)
                tabButton.MouseButton1Click:Fire()
            end)
        end
        
        return Tab
    end
    
    return Window
end

return Library