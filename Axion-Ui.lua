local AxionLibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local function GetGuiParent()
    local success, result = pcall(function()
        if gethui then
            return gethui()
        elseif syn and syn.protect_gui then
            return CoreGui
        end
        return CoreGui
    end)
    return success and result or CoreGui
end

local GuiParent = GetGuiParent()

local function CleanupAllBlur()
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") and effect.Name:find("Axion") then
            effect:Destroy()
        end
    end
end

local function createLoadingDots(parent, theme)
    local loadingDots = Instance.new("Frame")
    loadingDots.Name = "LoadingDots"
    loadingDots.BackgroundTransparency = 1
    loadingDots.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingDots.Position = UDim2.new(0.5, 0, 0.5, 0)
    loadingDots.Size = UDim2.new(0, 30, 0, 10)
    loadingDots.Parent = parent
    
    local dotSize = 4
    local dotSpacing = 10
    local dots = {}
    
    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Name = "Dot" .. i
        dot.BackgroundColor3 = theme.TextMuted or Color3.fromRGB(120, 120, 130)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, (i - 2) * dotSpacing, 0.5, 0)
        dot.Size = UDim2.new(0, dotSize, 0, dotSize)
        dot.Parent = loadingDots
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        
        table.insert(dots, dot)
    end
    
    local connection = RunService.RenderStepped:Connect(function()
        local t = os.clock() * 3
        for i, dot in ipairs(dots) do
            local offset = math.sin(t + i * 0.8) * 2
            dot.Position = UDim2.new(0.5, (i - 2) * dotSpacing, 0.5, offset)
            dot.BackgroundTransparency = 0.3 + math.abs(math.sin(t + i * 0.8)) * 0.4
        end
    end)
    
    loadingDots.Destroy = function()
        connection:Disconnect()
        loadingDots:Destroy()
    end
    
    return loadingDots
end

local function createSpinner(parent, size, color, speed)
    size = size or 24
    color = color or Color3.fromRGB(100, 100, 120)
    speed = speed or 120
    
    local spinner = Instance.new("Frame")
    spinner.Name = "Spinner"
    spinner.BackgroundTransparency = 1
    spinner.AnchorPoint = Vector2.new(0.5, 0.5)
    spinner.Size = UDim2.new(0, size, 0, size)
    spinner.Position = UDim2.new(0.5, 0, 0.5, 0)
    spinner.Parent = parent
    
    local numSegments = 8
    local segmentAngle = 360 / numSegments
    
    for i = 1, numSegments do
        local segment = Instance.new("Frame")
        segment.Name = "Segment" .. i
        segment.BackgroundColor3 = color
        segment.BorderSizePixel = 0
        segment.AnchorPoint = Vector2.new(0.5, 0)
        segment.Position = UDim2.new(0.5, 0, 0, 0)
        segment.Size = UDim2.new(0, 2, 0, size / 3)
        segment.Rotation = (i - 1) * segmentAngle
        segment.Parent = spinner
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = segment
    end
    
    local connection = RunService.RenderStepped:Connect(function(dt)
        spinner.Rotation = spinner.Rotation + dt * speed
    end)
    
    local fadeConnection = RunService.RenderStepped:Connect(function()
        local t = os.clock() * 2
        for i, segment in ipairs(spinner:GetChildren()) do
            if segment:IsA("Frame") then
                local segmentIndex = tonumber(segment.Name:match("%d+")) or 1
                local fadeOffset = (segmentIndex - 1) * 0.3
                local alpha = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(t * 2 + fadeOffset))
                segment.BackgroundTransparency = 1 - alpha
            end
        end
    end)
    
    spinner.Destroy = function()
        connection:Disconnect()
        fadeConnection:Disconnect()
        spinner:Destroy()
    end
    
    return spinner
end

local function createProgressBar(parent, width, height, theme)
    width = width or 200
    height = height or 6
    
    local container = Instance.new("Frame")
    container.Name = "ProgressBar"
    container.BackgroundColor3 = theme.Container or Color3.fromRGB(30, 30, 45)
    container.Size = UDim2.new(0, width, 0, height)
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = container
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.BackgroundColor3 = theme.Accent or Color3.fromRGB(100, 120, 255)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Parent = container
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = progressFill
    
    local shimmer = Instance.new("Frame")
    shimmer.Name = "Shimmer"
    shimmer.BackgroundColor3 = Color3.new(1, 1, 1)
    shimmer.BackgroundTransparency = 0.8
    shimmer.Size = UDim2.new(0, 30, 1, 0)
    shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
    shimmer.Visible = false
    shimmer.Parent = progressFill
    
    local shimmerGradient = Instance.new("UIGradient")
    shimmerGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    shimmerGradient.Rotation = 45
    shimmerGradient.Parent = shimmer
    
    local function setProgress(percentage)
        percentage = math.clamp(percentage, 0, 100)
        local targetWidth = (percentage / 100) * width
        
        TweenService:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetWidth, 1, 0)
        }):Play()
        
        if percentage > 0 and percentage < 100 then
            shimmer.Visible = true
            TweenService:Create(shimmer, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {
                Position = UDim2.new(1.2, 0, 0, 0)
            }):Play()
        else
            shimmer.Visible = false
        end
    end
    
    local function startIndeterminate()
        local pulseTween = TweenService:Create(progressFill, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Size = UDim2.new(0.6, 0, 1, 0),
            Position = UDim2.new(0.2, 0, 0, 0)
        })
        pulseTween:Play()
        
        shimmer.Visible = true
        local shimmerTween = TweenService:Create(shimmer, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Position = UDim2.new(1.2, 0, 0, 0)
        })
        shimmerTween:Play()
        
        return {
            Stop = function()
                pulseTween:Cancel()
                shimmerTween:Cancel()
                shimmer.Visible = false
            end
        }
    end
    
    return {
        Container = container,
        SetProgress = setProgress,
        StartIndeterminate = startIndeterminate
    }
end

local function createPulseEffect(parent, color, duration, size)
    color = color or Color3.new(1, 1, 1)
    duration = duration or 0.8
    size = size or 50
    
    local pulse = Instance.new("Frame")
    pulse.Name = "PulseEffect"
    pulse.BackgroundColor3 = color
    pulse.BackgroundTransparency = 0.7
    pulse.AnchorPoint = Vector2.new(0.5, 0.5)
    pulse.Size = UDim2.new(0, 0, 0, 0)
    pulse.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = pulse
    
    TweenService:Create(pulse, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, size * 3, 0, size * 3),
        BackgroundTransparency = 1
    }):Play()
    
    task.delay(duration, function()
        if pulse and pulse.Parent then
            pulse:Destroy()
        end
    end)
    
    return pulse
end

local Themes = {
    Default = {
        Background = Color3.fromRGB(20, 20, 30),
        BackgroundTransparency = 0.15,
        Container = Color3.fromRGB(30, 30, 45),
        ContainerTransparency = 0.25,
        Element = Color3.fromRGB(40, 40, 60),
        ElementTransparency = 0.3,
        ElementHover = Color3.fromRGB(50, 50, 75),
        Accent = Color3.fromRGB(100, 120, 255),
        AccentDark = Color3.fromRGB(70, 90, 200),
        AccentGlow = Color3.fromRGB(130, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 200),
        TextMuted = Color3.fromRGB(120, 120, 150),
        Border = Color3.fromRGB(80, 80, 120),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        GradientStart = Color3.fromRGB(60, 60, 100),
        GradientEnd = Color3.fromRGB(30, 30, 50),
        Font = Enum.Font.Gotham
    },
    Dark = {
        Background = Color3.fromRGB(10, 10, 15),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(18, 18, 25),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(25, 25, 35),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(130, 100, 255),
        AccentDark = Color3.fromRGB(100, 70, 200),
        AccentGlow = Color3.fromRGB(160, 130, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(160, 160, 180),
        TextMuted = Color3.fromRGB(100, 100, 130),
        Border = Color3.fromRGB(60, 60, 90),
        BorderTransparency = 0.6,
        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        GradientStart = Color3.fromRGB(40, 40, 70),
        GradientEnd = Color3.fromRGB(15, 15, 25),
        Font = Enum.Font.Gotham
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 250),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(250, 250, 255),
        ContainerTransparency = 0.15,
        Element = Color3.fromRGB(235, 235, 245),
        ElementTransparency = 0.2,
        ElementHover = Color3.fromRGB(225, 225, 240),
        Accent = Color3.fromRGB(80, 100, 220),
        AccentDark = Color3.fromRGB(60, 80, 180),
        AccentGlow = Color3.fromRGB(110, 130, 255),
        Text = Color3.fromRGB(30, 30, 50),
        TextDark = Color3.fromRGB(80, 80, 110),
        TextMuted = Color3.fromRGB(130, 130, 160),
        Border = Color3.fromRGB(200, 200, 220),
        BorderTransparency = 0.3,
        Success = Color3.fromRGB(60, 180, 100),
        Warning = Color3.fromRGB(230, 160, 40),
        Error = Color3.fromRGB(220, 60, 60),
        GradientStart = Color3.fromRGB(255, 255, 255),
        GradientEnd = Color3.fromRGB(230, 230, 245),
        Font = Enum.Font.Gotham
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 40),
        BackgroundTransparency = 0.15,
        Container = Color3.fromRGB(20, 35, 55),
        ContainerTransparency = 0.25,
        Element = Color3.fromRGB(25, 45, 70),
        ElementTransparency = 0.3,
        ElementHover = Color3.fromRGB(35, 55, 85),
        Accent = Color3.fromRGB(60, 180, 220),
        AccentDark = Color3.fromRGB(40, 150, 190),
        AccentGlow = Color3.fromRGB(90, 210, 250),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(170, 200, 220),
        TextMuted = Color3.fromRGB(120, 150, 180),
        Border = Color3.fromRGB(60, 100, 140),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(80, 220, 150),
        Warning = Color3.fromRGB(255, 190, 80),
        Error = Color3.fromRGB(255, 100, 100),
        GradientStart = Color3.fromRGB(40, 80, 120),
        GradientEnd = Color3.fromRGB(20, 40, 60),
        Font = Enum.Font.Gotham
    },
    Midnight = {
        Background = Color3.fromRGB(8, 8, 15),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(12, 12, 22),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(18, 18, 32),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(28, 28, 45),
        Accent = Color3.fromRGB(180, 80, 255),
        AccentDark = Color3.fromRGB(140, 50, 200),
        AccentGlow = Color3.fromRGB(210, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 170, 200),
        TextMuted = Color3.fromRGB(120, 110, 150),
        Border = Color3.fromRGB(80, 60, 120),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(100, 255, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 100),
        GradientStart = Color3.fromRGB(50, 30, 80),
        GradientEnd = Color3.fromRGB(15, 10, 25),
        Font = Enum.Font.Gotham
    },
    Emerald = {
        Background = Color3.fromRGB(15, 25, 20),
        BackgroundTransparency = 0.15,
        Container = Color3.fromRGB(20, 35, 28),
        ContainerTransparency = 0.25,
        Element = Color3.fromRGB(25, 45, 35),
        ElementTransparency = 0.3,
        ElementHover = Color3.fromRGB(35, 60, 48),
        Accent = Color3.fromRGB(50, 205, 130),
        AccentDark = Color3.fromRGB(35, 170, 100),
        AccentGlow = Color3.fromRGB(80, 235, 160),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 210, 195),
        TextMuted = Color3.fromRGB(130, 160, 145),
        Border = Color3.fromRGB(60, 120, 90),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(80, 255, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 100, 100),
        GradientStart = Color3.fromRGB(40, 100, 70),
        GradientEnd = Color3.fromRGB(20, 50, 35),
        Font = Enum.Font.Gotham
    },
    Crimson = {
        Background = Color3.fromRGB(30, 10, 15),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(45, 15, 20),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(60, 20, 25),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(80, 25, 35),
        Accent = Color3.fromRGB(220, 60, 80),
        AccentDark = Color3.fromRGB(180, 40, 60),
        AccentGlow = Color3.fromRGB(255, 100, 120),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(220, 180, 185),
        TextMuted = Color3.fromRGB(160, 120, 125),
        Border = Color3.fromRGB(100, 40, 50),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        GradientStart = Color3.fromRGB(70, 20, 30),
        GradientEnd = Color3.fromRGB(35, 10, 15),
        Font = Enum.Font.Gotham
    },
    Galaxy = {
        Background = Color3.fromRGB(10, 5, 25),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(15, 8, 35),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(25, 12, 50),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(35, 18, 70),
        Accent = Color3.fromRGB(150, 80, 255),
        AccentDark = Color3.fromRGB(120, 60, 220),
        AccentGlow = Color3.fromRGB(180, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 180, 230),
        TextMuted = Color3.fromRGB(140, 120, 170),
        Border = Color3.fromRGB(80, 40, 150),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(100, 255, 200),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 100, 150),
        GradientStart = Color3.fromRGB(40, 20, 80),
        GradientEnd = Color3.fromRGB(20, 10, 40),
        Font = Enum.Font.Gotham
    },
    Sunset = {
        Background = Color3.fromRGB(30, 20, 25),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(45, 30, 35),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(60, 40, 45),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(80, 55, 60),
        Accent = Color3.fromRGB(255, 140, 60),
        AccentDark = Color3.fromRGB(220, 110, 40),
        AccentGlow = Color3.fromRGB(255, 180, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(230, 200, 190),
        TextMuted = Color3.fromRGB(170, 140, 130),
        Border = Color3.fromRGB(120, 80, 70),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(100, 220, 150),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 100, 100),
        GradientStart = Color3.fromRGB(70, 45, 50),
        GradientEnd = Color3.fromRGB(35, 22, 25),
        Font = Enum.Font.Gotham
    },
    Cyberpunk = {
        Background = Color3.fromRGB(5, 10, 20),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(10, 20, 35),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(15, 30, 50),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(25, 45, 75),
        Accent = Color3.fromRGB(0, 255, 255),
        AccentDark = Color3.fromRGB(0, 200, 200),
        AccentGlow = Color3.fromRGB(100, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 230, 230),
        TextMuted = Color3.fromRGB(120, 170, 170),
        Border = Color3.fromRGB(0, 150, 150),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(0, 255, 150),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 0, 100),
        GradientStart = Color3.fromRGB(0, 80, 100),
        GradientEnd = Color3.fromRGB(0, 40, 50),
        Font = Enum.Font.Gotham
    }
}

local Utility = {}

function Utility:Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utility:Tween(instance, properties, duration, easingStyle, easingDirection)
    if not instance then return end
    local tweenInfo = TweenInfo.new(
        duration or 0.25,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utility:Ripple(button, theme, config)
    if not config.RippleEnabled then return end
    
    local ripple = Utility:Create("Frame", {
        Name = "Ripple",
        Parent = button,
        BackgroundColor3 = theme.AccentGlow,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Position = UDim2.new(0, Mouse.X - button.AbsolutePosition.X, 0, Mouse.Y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = button.ZIndex + 1
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Utility:Tween(ripple, {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1
    }, config.RippleSpeed).Completed:Connect(function()
        ripple:Destroy()
    end)
end

function Utility:MakeDraggable(frame, handle, config)
    local dragging, dragInput, dragStart, startPos
    
    local function handleInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
    
    local function handleInputChanged(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end
    
    local function handleUserInputChanged(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(frame, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, config.AnimationSpeed * 0.5)
        end
    end
    
    handle.InputBegan:Connect(handleInput)
    handle.InputChanged:Connect(handleInputChanged)
    UserInputService.InputChanged:Connect(handleUserInputChanged)
end

local ConfigManager = {}

function ConfigManager:GetSaveFolder(folderName)
    local success, result = pcall(function()
        if isfolder and writefile and readfile then
            if not isfolder(folderName) then
                makefolder(folderName)
            end
            return true
        end
        return false
    end)
    return success and result
end

function ConfigManager:Save(folderName, fileName, data)
    pcall(function()
        if writefile then
            writefile(folderName .. "/" .. fileName .. ".json", HttpService:JSONEncode(data))
        end
    end)
end

function ConfigManager:Load(folderName, fileName)
    local success, result = pcall(function()
        if readfile and isfile then
            local path = folderName .. "/" .. fileName .. ".json"
            if isfile(path) then
                return HttpService:JSONDecode(readfile(path))
            end
        end
        return nil
    end)
    return success and result or nil
end

function AxionLibrary:CreateWindow(options)
    options = options or {}
    
    CleanupAllBlur()
    if GuiParent:FindFirstChild("AxionUI") then
        GuiParent:FindFirstChild("AxionUI"):Destroy()
    end
    
    local windowName = options.Name or "Axion"
    local windowSubtitle = options.Subtitle or "by Axom"
    local windowVersion = options.Version or "v2.0"
    local loadingTitle = options.LoadingTitle or "Axion Interface"
    local loadingSubtitle = options.LoadingSubtitle or "Loading..."
    local themeName = options.Theme or "Default"
    local configSaving = options.ConfigurationSaving or {}
    local configEnabled = configSaving.Enabled or false
    local configFolder = configSaving.FolderName or "AxionConfig"
    local configFile = configSaving.FileName or "config"
    local customFont = options.Font or nil
    
    local Config = {
        AnimationSpeed = options.AnimationSpeed or 0.25,
        RippleEnabled = options.RippleEnabled ~= false,
        RippleSpeed = options.RippleSpeed or 0.3,
        CornerRadius = options.CornerRadius or 12,
        ElementCornerRadius = options.ElementCornerRadius or 10,
        BlurEnabled = false
    }
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Theme = Themes[themeName] or Themes.Default,
        ThemeName = themeName,
        Config = Config,
        Minimized = false,
        Elements = {},
        ConfigData = {},
        Connections = {},
        ElementRefs = {},
        CustomFont = customFont,
        PlayerInfoVisible = true,
        ActiveDropdown = nil
    }
    
    if configEnabled then
        ConfigManager:GetSaveFolder(configFolder)
        local savedData = ConfigManager:Load(configFolder, configFile)
        if savedData then
            Window.ConfigData = savedData
            if savedData.Theme and Themes[savedData.Theme] then
                Window.Theme = Themes[savedData.Theme]
                Window.ThemeName = savedData.Theme
            end
            if savedData.Font then
                Window.CustomFont = savedData.Font
            end
        end
    end
    
    local theme = Window.Theme
    local currentFont = Window.CustomFont or theme.Font
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "AxionUI",
        Parent = GuiParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    
    local LoadingFrame = Utility:Create("Frame", {
        Name = "LoadingFrame",
        Parent = ScreenGui,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = theme.BackgroundTransparency,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 320, 0, 160),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius + 4) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1.5 }),
        Utility:Create("UIGradient", {
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
            Rotation = 135,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 0.3) })
        })
    })
    
    local LoadingTitle = Utility:Create("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 0, 30),
        Font = currentFont,
        Text = loadingTitle,
        TextColor3 = theme.Text,
        TextSize = 22,
        TextTransparency = 1
    })
    
    local LoadingSubtitle = Utility:Create("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 65),
        Size = UDim2.new(1, 0, 0, 20),
        Font = currentFont,
        Text = loadingSubtitle,
        TextColor3 = theme.TextDark,
        TextSize = 14,
        TextTransparency = 1
    })
    
    local LoadingBarBg = Utility:Create("Frame", {
        Parent = LoadingFrame,
        BackgroundColor3 = theme.Element,
        BackgroundTransparency = theme.ElementTransparency,
        Position = UDim2.new(0.1, 0, 0, 110),
        Size = UDim2.new(0.8, 0, 0, 8)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
    
    local LoadingBarFill = Utility:Create("Frame", {
        Parent = LoadingBarBg,
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new(0, 0, 1, 0)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
    
    Utility:Tween(LoadingTitle, {TextTransparency = 0}, Config.AnimationSpeed)
    task.wait(Config.AnimationSpeed * 0.5)
    Utility:Tween(LoadingSubtitle, {TextTransparency = 0}, Config.AnimationSpeed)
    Utility:Tween(LoadingBarFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
    
    task.wait(1.8)
    
    Utility:Tween(LoadingFrame, {BackgroundTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingTitle, {TextTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingSubtitle, {TextTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingBarBg, {BackgroundTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingBarFill, {BackgroundTransparency = 1}, Config.AnimationSpeed)
    for _, child in pairs(LoadingFrame:GetDescendants()) do
        if child:IsA("UIStroke") then
            Utility:Tween(child, {Transparency = 1}, Config.AnimationSpeed)
        end
    end
    task.wait(Config.AnimationSpeed + 0.1)
    LoadingFrame:Destroy()
    
    local MainContainer = Utility:Create("Frame", {
        Name = "MainContainer",
        Parent = ScreenGui,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = theme.BackgroundTransparency,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius + 6) }),
        Utility:Create("UIStroke", { Name = "MainStroke", Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1.5 }),
        Utility:Create("UIGradient", {
            Name = "MainGradient",
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
            Rotation = 135,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 0.3) })
        })
    })
    
    local Glow = Utility:Create("ImageLabel", {
        Name = "Glow",
        Parent = MainContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 50, 1, 50),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://5028857084",
        ImageColor3 = theme.Accent,
        ImageTransparency = 0.85,
        ZIndex = 0,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276)
    })
    
    Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 500)}, Config.AnimationSpeed * 1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.wait(Config.AnimationSpeed * 0.8)
    
    local Header = Utility:Create("Frame", {
        Name = "Header",
        Parent = MainContainer,
        BackgroundColor3 = theme.Container,
        BackgroundTransparency = theme.ContainerTransparency + 0.1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 0, 55)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
    })
    
    local TitleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(0.6, 0, 0, 22),
        Font = currentFont,
        Text = windowName,
        TextColor3 = theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local SubtitleLabel = Utility:Create("TextLabel", {
        Name = "Subtitle",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(0.6, 0, 0, 16),
        Font = currentFont,
        Text = windowSubtitle .. " | " .. windowVersion,
        TextColor3 = theme.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local ControlsContainer = Utility:Create("Frame", {
        Name = "Controls",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -95, 0, 0),
        Size = UDim2.new(0, 80, 1, 0)
    }, {
        Utility:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        })
    })
    
    local function CreateControlButton(name, text, hoverColor, callback)
        local btn = Utility:Create("TextButton", {
            Name = name,
            Parent = ControlsContainer,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = theme.ElementTransparency,
            Size = UDim2.new(0, 34, 0, 34),
            Font = currentFont,
            Text = text,
            TextColor3 = theme.TextDark,
            TextSize = 16,
            AutoButtonColor = false,
            LayoutOrder = name == "Minimize" and 1 or 2
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
            Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
        })
        
        btn.MouseEnter:Connect(function()
            Utility:Tween(btn, {BackgroundColor3 = hoverColor, BackgroundTransparency = 0, TextColor3 = theme.Text}, Config.AnimationSpeed * 0.5)
        end)
        btn.MouseLeave:Connect(function()
            Utility:Tween(btn, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency, TextColor3 = theme.TextDark}, Config.AnimationSpeed * 0.5)
        end)
        btn.MouseButton1Click:Connect(function()
            Utility:Ripple(btn, theme, Config)
            callback()
        end)
        
        return btn
    end
    
    CreateControlButton("Close", "X", theme.Error, function()
        for _, conn in pairs(Window.Connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        Utility:Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(Config.AnimationSpeed + 0.1)
        CleanupAllBlur()
        ScreenGui:Destroy()
    end)
    
    local PlayerInfoContainer = Utility:Create("Frame", {
        Name = "PlayerInfo",
        Parent = MainContainer,
        BackgroundColor3 = theme.Container,
        BackgroundTransparency = theme.ContainerTransparency,
        Position = UDim2.new(1, -185, 1, -55),
        Size = UDim2.new(0, 170, 0, 40),
        ZIndex = 10
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 }),
        Utility:Create("UIPadding", { PaddingLeft = UDim.new(0, 45), PaddingRight = UDim.new(0, 10) })
    })
    
    local AvatarImage = Utility:Create("ImageLabel", {
        Name = "Avatar",
        Parent = PlayerInfoContainer,
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(0, -35, 0.5, 0),
        Size = UDim2.new(0, 32, 0, 32),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ScaleType = Enum.ScaleType.Crop
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        Utility:Create("UIStroke", { Color = theme.AccentDark, Thickness = 2 })
    })
    
    local PlayerDisplayName = Utility:Create("TextLabel", {
        Name = "DisplayName",
        Parent = PlayerInfoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 5),
        Size = UDim2.new(1, 0, 0, 16),
        Font = currentFont,
        Text = Player.DisplayName,
        TextColor3 = theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    
    local PlayerUsername = Utility:Create("TextLabel", {
        Name = "Username",
        Parent = PlayerInfoContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 21),
        Size = UDim2.new(1, 0, 0, 14),
        Font = currentFont,
        Text = "@" .. Player.Name,
        TextColor3 = theme.TextMuted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    
    pcall(function()
        local userId = Player.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        if isReady then
            AvatarImage.Image = content
        end
    end)
    
    CreateControlButton("Minimize", "-", theme.Warning, function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 85)}, Config.AnimationSpeed)
            PlayerInfoContainer.Visible = false
        else
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 500)}, Config.AnimationSpeed)
            PlayerInfoContainer.Visible = true
        end
    end)
    
    local BottomDragHandle = Utility:Create("Frame", {
        Name = "BottomDragHandle",
        Parent = MainContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10),
        ZIndex = 5
    })
    
    Utility:MakeDraggable(MainContainer, Header, Config)
    Utility:MakeDraggable(MainContainer, BottomDragHandle, Config)
    
    local ContentArea = Utility:Create("Frame", {
        Name = "ContentArea",
        Parent = MainContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 80),
        Size = UDim2.new(1, -30, 1, -95)
    })
    
    local TabContainer = Utility:Create("Frame", {
        Name = "TabContainer",
        Parent = ContentArea,
        BackgroundColor3 = theme.Container,
        BackgroundTransparency = theme.ContainerTransparency,
        Size = UDim2.new(0, 150, 1, 0)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
    })
    
    local TabList = Utility:Create("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true
    }, {
        Utility:Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
    })
    
    local MainContent = Utility:Create("Frame", {
        Name = "MainContent",
        Parent = ContentArea,
        BackgroundColor3 = theme.Container,
        BackgroundTransparency = theme.ContainerTransparency,
        Position = UDim2.new(0, 160, 0, 0),
        Size = UDim2.new(1, -160, 1, 0),
        ClipsDescendants = true
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
    })
    
    local function SaveConfig()
        if not configEnabled then return end
        local data = { 
            Theme = Window.ThemeName, 
            Font = Window.CustomFont,
            Elements = {} 
        }
        for id, el in pairs(Window.Elements) do
            if el.Value ~= nil then data.Elements[id] = el.Value end
        end
        Window.ConfigData = data
        ConfigManager:Save(configFolder, configFile, data)
    end
    
    local function ApplyTheme(newThemeName, animate)
        local newTheme = Themes[newThemeName]
        if not newTheme then return end
        
        Window.Theme = newTheme
        Window.ThemeName = newThemeName
        theme = newTheme
        
        local dur = animate and Config.AnimationSpeed or 0
        
        Utility:Tween(MainContainer, {BackgroundColor3 = newTheme.Background, BackgroundTransparency = newTheme.BackgroundTransparency}, dur)
        local mainStroke = MainContainer:FindFirstChild("MainStroke")
        if mainStroke then Utility:Tween(mainStroke, {Color = newTheme.Border, Transparency = newTheme.BorderTransparency}, dur) end
        local mainGrad = MainContainer:FindFirstChild("MainGradient")
        if mainGrad then
            mainGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, newTheme.GradientStart), ColorSequenceKeypoint.new(1, newTheme.GradientEnd) })
        end
        Utility:Tween(Glow, {ImageColor3 = newTheme.Accent}, dur)
        
        Utility:Tween(Header, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency + 0.1}, dur)
        Utility:Tween(TitleLabel, {TextColor3 = newTheme.Text}, dur)
        Utility:Tween(SubtitleLabel, {TextColor3 = newTheme.TextMuted}, dur)
        
        Utility:Tween(TabContainer, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency}, dur)
        Utility:Tween(MainContent, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency}, dur)
        
        Utility:Tween(PlayerInfoContainer, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency}, dur)
        Utility:Tween(PlayerDisplayName, {TextColor3 = newTheme.Text}, dur)
        Utility:Tween(PlayerUsername, {TextColor3 = newTheme.TextMuted}, dur)
        Utility:Tween(AvatarImage, {BackgroundColor3 = newTheme.Accent}, dur)
        
        for _, tab in pairs(Window.Tabs) do
            local isCurrent = tab == Window.CurrentTab
            Utility:Tween(tab.Button, {
                BackgroundColor3 = isCurrent and newTheme.Accent or newTheme.Element,
                BackgroundTransparency = isCurrent and 0 or newTheme.ElementTransparency
            }, dur)
            Utility:Tween(tab.Label, {TextColor3 = isCurrent and newTheme.Text or newTheme.TextDark}, dur)
            if tab.IconLabel then
                Utility:Tween(tab.IconLabel, {TextColor3 = isCurrent and newTheme.Text or newTheme.TextDark}, dur)
            end
            if tab.IconImage then
                Utility:Tween(tab.IconImage, {ImageColor3 = isCurrent and newTheme.Text or newTheme.TextDark}, dur)
            end
            Utility:Tween(tab.Indicator, {BackgroundColor3 = newTheme.Accent}, dur)
            
            local btnStroke = tab.Button:FindFirstChildOfClass("UIStroke")
            if btnStroke then Utility:Tween(btnStroke, {Color = newTheme.Border, Transparency = newTheme.BorderTransparency + 0.3}, dur) end
        end
        
        for _, ref in pairs(Window.ElementRefs) do
            if ref.Type == "Toggle" then
                local isOn = ref.Element.Value
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Switch, {BackgroundColor3 = isOn and newTheme.Accent or newTheme.Element, BackgroundTransparency = isOn and 0 or newTheme.ElementTransparency - 0.1}, dur)
                Utility:Tween(ref.Circle, {BackgroundColor3 = newTheme.Text}, dur)
                local switchStroke = ref.Switch:FindFirstChild("SwitchStroke")
                if switchStroke then Utility:Tween(switchStroke, {Color = isOn and newTheme.Accent or newTheme.Border}, dur) end
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Slider" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.ValueLabel, {TextColor3 = newTheme.Accent}, dur)
                Utility:Tween(ref.BarBg, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency - 0.1}, dur)
                Utility:Tween(ref.Fill, {BackgroundColor3 = newTheme.Accent}, dur)
                Utility:Tween(ref.Knob, {BackgroundColor3 = newTheme.Text}, dur)
                local knobStroke = ref.Knob:FindFirstChildOfClass("UIStroke")
                if knobStroke then Utility:Tween(knobStroke, {Color = newTheme.Accent}, dur) end
                local fillGrad = ref.Fill:FindFirstChildOfClass("UIGradient")
                if fillGrad then
                    fillGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, newTheme.Accent), ColorSequenceKeypoint.new(1, newTheme.AccentGlow) })
                end
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Button" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                if ref.IconLabel then
                    Utility:Tween(ref.IconLabel, {TextColor3 = newTheme.Accent}, dur)
                end
                if ref.IconImage then
                    Utility:Tween(ref.IconImage, {ImageColor3 = newTheme.Accent}, dur)
                end
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Dropdown" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Selected, {TextColor3 = newTheme.TextDark}, dur)
                Utility:Tween(ref.Arrow, {TextColor3 = newTheme.TextDark}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                for _, opt in pairs(ref.ScrollContainer:GetChildren()) do
                    if opt:IsA("TextButton") then
                        local dropdownValue = ref.Element.Value
                        local isSelected = false
                        
                        if type(dropdownValue) == "table" then
                            isSelected = table.find(dropdownValue, opt.Name) ~= nil
                        else
                            isSelected = dropdownValue == opt.Name
                        end
                        
                        Utility:Tween(opt, {
                            BackgroundColor3 = isSelected and newTheme.Accent or newTheme.Container,
                            BackgroundTransparency = isSelected and 0 or newTheme.ContainerTransparency,
                            TextColor3 = isSelected and newTheme.Text or newTheme.TextDark
                        }, dur)
                    end
                end
                
            elseif ref.Type == "Input" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.BoxContainer, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency}, dur)
                Utility:Tween(ref.TextBox, {TextColor3 = newTheme.Text, PlaceholderColor3 = newTheme.TextMuted}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                local boxStroke = ref.BoxContainer:FindFirstChild("BoxStroke")
                if boxStroke then Utility:Tween(boxStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Keybind" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.KeyButton, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency, TextColor3 = newTheme.TextDark}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "ColorPicker" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.RGBLabel, {TextColor3 = newTheme.TextDark}, dur)
                local displayStroke = ref.Display:FindFirstChildOfClass("UIStroke")
                if displayStroke then Utility:Tween(displayStroke, {Color = newTheme.Border}, dur) end
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Label" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency + 0.1}, dur)
                Utility:Tween(ref.Text, {TextColor3 = newTheme.TextDark}, dur)
                
            elseif ref.Type == "Paragraph" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Title, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Content, {TextColor3 = newTheme.TextDark}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "PlayerSelector" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Selected, {TextColor3 = newTheme.TextDark}, dur)
                Utility:Tween(ref.Arrow, {TextColor3 = newTheme.TextDark}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
            end
        end
        
        TabList.ScrollBarImageColor3 = newTheme.Accent
        for _, tab in pairs(Window.Tabs) do
            tab.Content.ScrollBarImageColor3 = newTheme.Accent
        end
        
        SaveConfig()
    end
    
    Window.ApplyTheme = ApplyTheme
    
    function Window:Notify(notifyOptions)
        notifyOptions = notifyOptions or {}
        local title = notifyOptions.Title or "Notification"
        local content = notifyOptions.Content or ""
        local duration = notifyOptions.Duration or 5
        local notifyType = notifyOptions.Type or "Info"
        local showButtons = notifyOptions.Buttons ~= false
        
        local typeColors = {
            Info = theme.Accent,
            Success = theme.Success,
            Warning = theme.Warning,
            Error = theme.Error
        }
        local typeColor = typeColors[notifyType] or theme.Accent
        
        local NotifHolder = ScreenGui:FindFirstChild("NotificationHolder")
        if not NotifHolder then
            NotifHolder = Utility:Create("Frame", {
                Name = "NotificationHolder",
                Parent = ScreenGui,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, -20),
                Size = UDim2.new(0, 340, 1, -40),
                AnchorPoint = Vector2.new(1, 1)
            }, {
                Utility:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                    Padding = UDim.new(0, 12)
                })
            })
        end
        
        local NotifFrame = Utility:Create("Frame", {
            Name = "Notification",
            Parent = NotifHolder,
            BackgroundColor3 = theme.Background,
            BackgroundTransparency = theme.BackgroundTransparency - 0.05,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.new(1, 50, 0, 0),
            ClipsDescendants = true
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
            Utility:Create("UIStroke", { Color = typeColor, Transparency = 0.3, Thickness = 1.5 }),
            Utility:Create("UIGradient", {
                Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
                Rotation = 135,
                Transparency = NumberSequence.new(0.2)
            })
        })
        
        local AccentBar = Utility:Create("Frame", {
            Name = "AccentBar",
            Parent = NotifFrame,
            BackgroundColor3 = typeColor,
            Size = UDim2.new(0, 4, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, 4) })
        })
        
        local ContentContainer = Utility:Create("Frame", {
            Name = "ContentContainer",
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 16, 0, 0),
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        }, {
            Utility:Create("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingRight = UDim.new(0, 10) }),
            Utility:Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })
        })
        
        local HeaderFrame = Utility:Create("Frame", {
            Name = "Header",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24)
        })
        
        local TypeIcon = Utility:Create("TextLabel", {
            Name = "Icon",
            Parent = HeaderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 24, 0, 24),
            Font = currentFont,
            Text = notifyType == "Success" and "✓" or notifyType == "Warning" and "!" or notifyType == "Error" and "✗" or "i",
            TextColor3 = typeColor,
            TextSize = 16
        })
        
        local NotifTitle = Utility:Create("TextLabel", {
            Name = "Title",
            Parent = HeaderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(1, -70, 1, 0),
            Font = currentFont,
            Text = title,
            TextColor3 = theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        
        local CloseBtn = Utility:Create("TextButton", {
            Name = "Close",
            Parent = HeaderFrame,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = 0.5,
            Position = UDim2.new(1, -24, 0, 0),
            Size = UDim2.new(0, 24, 0, 24),
            Font = currentFont,
            Text = "X",
            TextColor3 = theme.TextDark,
            TextSize = 12,
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, 6) })
        })
        
        local NotifContent = Utility:Create("TextLabel", {
            Name = "Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = currentFont,
            Text = content,
            TextColor3 = theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        local ProgressContainer = Utility:Create("Frame", {
            Name = "ProgressContainer",
            Parent = ContentContainer,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 4)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        
        local ProgressFill = Utility:Create("Frame", {
            Name = "Fill",
            Parent = ProgressContainer,
            BackgroundColor3 = typeColor,
            Size = UDim2.new(1, 0, 1, 0)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        
        if showButtons then
            local ButtonsRow = Utility:Create("Frame", {
                Name = "Buttons",
                Parent = ContentContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)
            }, {
                Utility:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8)
                })
            })
            
            local OkButton = Utility:Create("TextButton", {
                Name = "OK",
                Parent = ButtonsRow,
                BackgroundColor3 = typeColor,
                Size = UDim2.new(0, 70, 0, 28),
                Font = currentFont,
                Text = "OK",
                TextColor3 = theme.Text,
                TextSize = 12,
                AutoButtonColor = false
            }, {
                Utility:Create("UICorner", { CornerRadius = UDim.new(0, 6) })
            })
            
            OkButton.MouseEnter:Connect(function()
                Utility:Tween(OkButton, {BackgroundColor3 = theme.AccentDark}, Config.AnimationSpeed * 0.5)
            end)
            OkButton.MouseLeave:Connect(function()
                Utility:Tween(OkButton, {BackgroundColor3 = typeColor}, Config.AnimationSpeed * 0.5)
            end)
        end
        
        Utility:Tween(NotifFrame, {Position = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Utility:Tween(ProgressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
        
        local function CloseNotification()
            Utility:Tween(NotifFrame, {Position = UDim2.new(1, 50, 0, 0)}, Config.AnimationSpeed)
            task.wait(Config.AnimationSpeed + 0.1)
            if NotifFrame then NotifFrame:Destroy() end
        end
        
        CloseBtn.MouseButton1Click:Connect(CloseNotification)
        if showButtons then
            local okBtn = ContentContainer:FindFirstChild("Buttons") and ContentContainer.Buttons:FindFirstChild("OK")
            if okBtn then okBtn.MouseButton1Click:Connect(CloseNotification) end
        end
        
        task.delay(duration, function()
            if NotifFrame and NotifFrame.Parent then
                CloseNotification()
            end
        end)
    end
    
    function Window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or "📁"
        local isImageIcon = tabOptions.IconIsImage or false
        local iconImage = tabOptions.IconImage or ""
        
        local Tab = { Name = tabName, Sections = {} }
        
        local TabButton = Utility:Create("TextButton", {
            Name = tabName,
            Parent = TabList,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = theme.ElementTransparency,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
            Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.3, Thickness = 1 })
        })
        
        local TabIcon
        if isImageIcon and iconImage ~= "" then
            TabIcon = Utility:Create("ImageLabel", {
                Name = "Icon",
                Parent = TabButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, 0),
                Size = UDim2.new(0, 20, 0, 20),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = iconImage,
                ImageColor3 = theme.TextDark
            })
            Tab.IconImage = TabIcon
        else
            TabIcon = Utility:Create("TextLabel", {
                Name = "Icon",
                Parent = TabButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(0, 25, 1, 0),
                Font = currentFont,
                Text = tabIcon,
                TextColor3 = theme.TextDark,
                TextSize = 16
            })
            Tab.IconLabel = TabIcon
        end
        
        local TabLabel = Utility:Create("TextLabel", {
            Name = "Label",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 38, 0, 0),
            Size = UDim2.new(1, -48, 1, 0),
            Font = currentFont,
            Text = tabName,
            TextColor3 = theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        
        local TabIndicator = Utility:Create("Frame", {
            Name = "Indicator",
            Parent = TabButton,
            BackgroundColor3 = theme.Accent,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -4, 0.2, 0),
            Size = UDim2.new(0, 3, 0.6, 0)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        
        local TabContent = Utility:Create("ScrollingFrame", {
            Name = tabName .. "Content",
            Parent = MainContent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 18, 0, 15),
            Size = UDim2.new(1, -36, 1, -30),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = theme.Accent,
            ScrollBarImageTransparency = 0.3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ClipsDescendants = true
        }, {
            Utility:Create("UIListLayout", { 
                SortOrder = Enum.SortOrder.LayoutOrder, 
                Padding = UDim.new(0, 10) 
            }),
            Utility:Create("UIPadding", {
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 6)
            })
        })
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Label = TabLabel
        Tab.Indicator = TabIndicator
        
        local function GetTabIndex(t)
            for i, tab in ipairs(Window.Tabs) do
                if tab == t then return i end
            end
            return 0
        end
        
        local function SelectTab()
            if Window.CurrentTab == Tab then return end
            
            local oldTab = Window.CurrentTab
            local oldIdx = oldTab and GetTabIndex(oldTab) or 0
            local newIdx = GetTabIndex(Tab)
            local goingDown = newIdx > oldIdx
            
            if oldTab then
                Utility:Tween(oldTab.Button, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed)
                Utility:Tween(oldTab.Label, {TextColor3 = theme.TextDark}, Config.AnimationSpeed)
                if oldTab.IconLabel then
                    Utility:Tween(oldTab.IconLabel, {TextColor3 = theme.TextDark}, Config.AnimationSpeed)
                end
                if oldTab.IconImage then
                    Utility:Tween(oldTab.IconImage, {ImageColor3 = theme.TextDark}, Config.AnimationSpeed)
                end
                Utility:Tween(oldTab.Indicator, {BackgroundTransparency = 1}, Config.AnimationSpeed)
                
                local slideOutY = goingDown and -60 or 60
                Utility:Tween(oldTab.Content, {Position = UDim2.new(0, 15, 0, slideOutY)}, Config.AnimationSpeed * 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                
                task.delay(Config.AnimationSpeed * 0.5, function()
                    if oldTab.Content then
                        oldTab.Content.Visible = false
                        oldTab.Content.Position = UDim2.new(0, 15, 0, 15)
                    end
                end)
            end
            
            Window.CurrentTab = Tab
            Utility:Tween(TabButton, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0}, Config.AnimationSpeed)
            Utility:Tween(TabLabel, {TextColor3 = theme.Text}, Config.AnimationSpeed)
            if Tab.IconLabel then
                Utility:Tween(Tab.IconLabel, {TextColor3 = theme.Text}, Config.AnimationSpeed)
            end
            if Tab.IconImage then
                Utility:Tween(Tab.IconImage, {ImageColor3 = theme.Text}, Config.AnimationSpeed)
            end
            Utility:Tween(TabIndicator, {BackgroundTransparency = 0}, Config.AnimationSpeed)
            
            local slideInY = goingDown and 60 or -60
            TabContent.Position = UDim2.new(0, 15, 0, slideInY)
            TabContent.Visible = true
            TabContent.CanvasPosition = Vector2.new(0, 0)
            
            Utility:Tween(TabContent, {Position = UDim2.new(0, 15, 0, 15)}, Config.AnimationSpeed * 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Utility:Tween(TabButton, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed * 0.5)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Utility:Tween(TabButton, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed * 0.5)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        if #Window.Tabs == 0 then
            Window.CurrentTab = Tab
            TabButton.BackgroundColor3 = theme.Accent
            TabButton.BackgroundTransparency = 0
            TabLabel.TextColor3 = theme.Text
            if Tab.IconLabel then
                Tab.IconLabel.TextColor3 = theme.Text
            end
            if Tab.IconImage then
                Tab.IconImage.ImageColor3 = theme.Text
            end
            TabIndicator.BackgroundTransparency = 0
            TabContent.Visible = true
        end
        
        table.insert(Window.Tabs, Tab)
        
        function Tab:CreateSection(sectionOptions)
            local sectionName = sectionOptions.Name or ""
            local sectionIcon = sectionOptions.Icon or nil
            local sectionIconIsImage = sectionOptions.IconIsImage or false
            local sectionIconImage = sectionOptions.IconImage or ""
            
            local Section = { Name = sectionName }
            
            local SectionFrame = Utility:Create("Frame", {
                Name = sectionName or "Section",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Utility:Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })
            })
            
            if sectionName then
                local SectionHeader = Utility:Create("Frame", {
                    Parent = SectionFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                
                local HeaderContent = Utility:Create("Frame", {
                    Parent = SectionHeader,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0, 0),
                    Size = UDim2.new(1, -10, 1, 0)
                })
                
                if sectionIcon then
                    if sectionIconIsImage and sectionIconImage ~= "" then
                        Utility:Create("ImageLabel", {
                            Parent = HeaderContent,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 0, 0.5, 0),
                            Size = UDim2.new(0, 16, 0, 16),
                            AnchorPoint = Vector2.new(0, 0.5),
                            Image = sectionIconImage,
                            ImageColor3 = theme.TextMuted
                        })
                        
                        Utility:Create("TextLabel", {
                            Parent = HeaderContent,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 22, 0, 0),
                            Size = UDim2.new(1, -22, 1, 0),
                            Font = currentFont,
                            Text = sectionName:upper(),
                            TextColor3 = theme.TextMuted,
                            TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Left
                        })
                    else
                        Utility:Create("TextLabel", {
                            Parent = HeaderContent,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 0, 0, 0),
                            Size = UDim2.new(0, 16, 1, 0),
                            Font = currentFont,
                            Text = sectionIcon,
                            TextColor3 = theme.TextMuted,
                            TextSize = 12
                        })
                        
                        Utility:Create("TextLabel", {
                            Parent = HeaderContent,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 22, 0, 0),
                            Size = UDim2.new(1, -22, 1, 0),
                            Font = currentFont,
                            Text = sectionName:upper(),
                            TextColor3 = theme.TextMuted,
                            TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Left
                        })
                    end
                else
                    Utility:Create("TextLabel", {
                        Parent = HeaderContent,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = currentFont,
                        Text = sectionName:upper(),
                        TextColor3 = theme.TextMuted,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                end
                
                Utility:Create("Frame", {
                    Name = "Line",
                    Parent = SectionHeader,
                    BackgroundColor3 = theme.Border,
                    BackgroundTransparency = theme.BorderTransparency,
                    Position = UDim2.new(0, 0, 1, -1),
                    Size = UDim2.new(1, 0, 0, 1)
                })
            end
            
            table.insert(Tab.Sections, Section)
            
            function Section:CreateButton(opts)
                opts = opts or {}
                local name = opts.Name or "Button"
                local callback = opts.Callback or function() end
                local buttonIcon = opts.Icon or nil
                local buttonIconIsImage = opts.IconIsImage or false
                local buttonIconImage = opts.IconImage or ""
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Button",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Icon
                if buttonIcon then
                    if buttonIconIsImage and buttonIconImage ~= "" then
                        Icon = Utility:Create("ImageLabel", {
                            Name = "Icon",
                            Parent = Frame,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(1, -40, 0.5, 0),
                            Size = UDim2.new(0, 24, 0, 24),
                            AnchorPoint = Vector2.new(0, 0.5),
                            Image = buttonIconImage,
                            ImageColor3 = theme.Accent
                        })
                        table.insert(Window.ElementRefs, { Type = "Button", Frame = Frame, Label = Label, IconImage = Icon })
                    else
                        Icon = Utility:Create("TextLabel", {
                            Name = "Icon",
                            Parent = Frame,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(1, -40, 0, 0),
                            Size = UDim2.new(0, 30, 1, 0),
                            Font = currentFont,
                            Text = buttonIcon,
                            TextColor3 = theme.Accent,
                            TextSize = 16
                        })
                        table.insert(Window.ElementRefs, { Type = "Button", Frame = Frame, Label = Label, IconLabel = Icon })
                    end
                else
                    Icon = Utility:Create("TextLabel", {
                        Name = "Icon",
                        Parent = Frame,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -40, 0, 0),
                        Size = UDim2.new(0, 30, 1, 0),
                        Font = currentFont,
                        Text = "→",
                        TextColor3 = theme.Accent,
                        TextSize = 16
                    })
                    table.insert(Window.ElementRefs, { Type = "Button", Frame = Frame, Label = Label, IconLabel = Icon })
                end
                
                local ClickArea = Utility:Create("TextButton", {
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                ClickArea.MouseEnter:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed * 0.5)
                    if Icon:IsA("TextLabel") then
                        Utility:Tween(Icon, {Position = UDim2.new(1, -35, 0, 0)}, Config.AnimationSpeed * 0.5)
                    end
                end)
                
                ClickArea.MouseLeave:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed * 0.5)
                    if Icon:IsA("TextLabel") then
                        Utility:Tween(Icon, {Position = UDim2.new(1, -40, 0, 0)}, Config.AnimationSpeed * 0.5)
                    end
                end)
                
                ClickArea.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                return { SetText = function(_, t) Label.Text = t end }
            end
            
            function Section:CreateToggle(opts)
                opts = opts or {}
                local name = opts.Name or "Toggle"
                local id = opts.Flag or name
                local default = opts.CurrentValue or false
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Toggle = { Value = default }
                Window.Elements[id] = Toggle
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Toggle",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -70, 1, 0),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Switch = Utility:Create("Frame", {
                    Name = "Switch",
                    Parent = Frame,
                    BackgroundColor3 = default and theme.Accent or theme.Element,
                    BackgroundTransparency = default and 0 or theme.ElementTransparency - 0.1,
                    Position = UDim2.new(1, -55, 0.5, 0),
                    Size = UDim2.new(0, 44, 0, 24),
                    AnchorPoint = Vector2.new(0, 0.5)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create("UIStroke", { Name = "SwitchStroke", Color = default and theme.Accent or theme.Border, Transparency = default and 0.3 or theme.BorderTransparency, Thickness = 1 })
                })
                
                local Circle = Utility:Create("Frame", {
                    Name = "Circle",
                    Parent = Switch,
                    BackgroundColor3 = theme.Text,
                    Position = default and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    AnchorPoint = Vector2.new(0, 0.5)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                
                local ClickArea = Utility:Create("TextButton", {
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                table.insert(Window.ElementRefs, { Type = "Toggle", Element = Toggle, Frame = Frame, Label = Label, Switch = Switch, Circle = Circle })
                
                local function Update(anim)
                    local dur = anim and Config.AnimationSpeed or 0
                    local t = Window.Theme
                    if Toggle.Value then
                        Utility:Tween(Switch, {BackgroundColor3 = t.Accent, BackgroundTransparency = 0}, dur)
                        Utility:Tween(Circle, {Position = UDim2.new(1, -22, 0.5, 0)}, dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Utility:Tween(Switch:FindFirstChild("SwitchStroke"), {Color = t.Accent, Transparency = 0.3}, dur)
                    else
                        Utility:Tween(Switch, {BackgroundColor3 = t.Element, BackgroundTransparency = t.ElementTransparency - 0.1}, dur)
                        Utility:Tween(Circle, {Position = UDim2.new(0, 4, 0.5, 0)}, dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Utility:Tween(Switch:FindFirstChild("SwitchStroke"), {Color = t.Border, Transparency = t.BorderTransparency}, dur)
                    end
                end
                
                ClickArea.MouseEnter:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed * 0.5)
                end)
                
                ClickArea.MouseLeave:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed * 0.5)
                end)
                
                ClickArea.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    Update(true)
                    SaveConfig()
                    callback(Toggle.Value)
                end)
                
                function Toggle:Set(v, skip)
                    Toggle.Value = v
                    Update(true)
                    SaveConfig()
                    if not skip then callback(v) end
                end
                
                if default then callback(default) end
                
                return Toggle
            end
            
            function Section:CreateSlider(opts)
                opts = opts or {}
                local name = opts.Name or "Slider"
                local id = opts.Flag or name
                local min = opts.Range and opts.Range[1] or 0
                local max = opts.Range and opts.Range[2] or 100
                local increment = opts.Increment or 1
                local default = opts.CurrentValue or min
                local suffix = opts.Suffix or ""
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Slider = { Value = default }
                Window.Elements[id] = Slider
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Slider",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 58)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 8),
                    Size = UDim2.new(0.6, 0, 0, 18),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ValueLabel = Utility:Create("TextLabel", {
                    Name = "Value",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.6, 0, 0, 8),
                    Size = UDim2.new(0.4, -15, 0, 18),
                    Font = currentFont,
                    Text = tostring(default) .. suffix,
                    TextColor3 = theme.Accent,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local BarBg = Utility:Create("Frame", {
                    Name = "BarBg",
                    Parent = Frame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency - 0.1,
                    Position = UDim2.new(0, 15, 0, 36),
                    Size = UDim2.new(1, -30, 0, 10)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                
                local fillPct = (default - min) / (max - min)
                
                local Fill = Utility:Create("Frame", {
                    Name = "Fill",
                    Parent = BarBg,
                    BackgroundColor3 = theme.Accent,
                    Size = UDim2.new(fillPct, 0, 1, 0)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create("UIGradient", {
                        Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.Accent), ColorSequenceKeypoint.new(1, theme.AccentGlow) }),
                        Rotation = 0
                    })
                })
                
                local Knob = Utility:Create("Frame", {
                    Name = "Knob",
                    Parent = BarBg,
                    BackgroundColor3 = theme.Text,
                    Position = UDim2.new(fillPct, 0, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 5
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create("UIStroke", { Color = theme.Accent, Thickness = 2 })
                })
                
                local Input = Utility:Create("TextButton", {
                    Parent = BarBg,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 20),
                    Position = UDim2.new(0, 0, 0, -10),
                    Text = "",
                    AutoButtonColor = false
                })
                
                table.insert(Window.ElementRefs, { Type = "Slider", Element = Slider, Frame = Frame, Label = Label, ValueLabel = ValueLabel, BarBg = BarBg, Fill = Fill, Knob = Knob })
                
                local dragging = false
                
                local function UpdateSlider(input, anim)
                    local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
                    local value = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    Slider.Value = value
                    local fillPos = (value - min) / (max - min)
                    local dur = anim and Config.AnimationSpeed * 0.5 or 0
                    
                    ValueLabel.Text = tostring(value) .. suffix
                    Utility:Tween(Fill, {Size = UDim2.new(fillPos, 0, 1, 0)}, dur)
                    Utility:Tween(Knob, {Position = UDim2.new(fillPos, 0, 0.5, 0)}, dur)
                    
                    SaveConfig()
                    callback(value)
                end
                
                Input.MouseButton1Down:Connect(function()
                    dragging = true
                    Utility:Tween(Knob, {Size = UDim2.new(0, 22, 0, 22)}, Config.AnimationSpeed * 0.3)
                end)
                
                local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                        dragging = false
                        Utility:Tween(Knob, {Size = UDim2.new(0, 18, 0, 18)}, Config.AnimationSpeed * 0.3)
                    end
                end)
                table.insert(Window.Connections, inputEndedConn)
                
                local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input, false)
                    end
                end)
                table.insert(Window.Connections, inputChangedConn)
                
                Input.MouseButton1Click:Connect(function()
                    UpdateSlider({Position = Vector3.new(Mouse.X, Mouse.Y, 0)}, true)
                end)
                
                function Slider:Set(v, skip)
                    v = math.clamp(v, min, max)
                    Slider.Value = v
                    local fillPos = (v - min) / (max - min)
                    ValueLabel.Text = tostring(v) .. suffix
                    Fill.Size = UDim2.new(fillPos, 0, 1, 0)
                    Knob.Position = UDim2.new(fillPos, 0, 0.5, 0)
                    SaveConfig()
                    if not skip then callback(v) end
                end
                
                callback(default)
                return Slider
            end
            
            function Section:CreateDropdown(args)
                args = args or {}
                local name = args.Name or "Dropdown"
                local id = args.Flag or name
                local options = args.Options or {"Option 1", "Option 2", "Option 3"}
                local default = args.CurrentOption or options[1] or "Select..."
                local multiSelect = args.MultiSelect or false
                local callback = args.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Dropdown = {
                    Value = multiSelect and (type(default) == "table" and default or {default}) or default,
                    Open = false,
                    Options = options
                }
                Window.Elements[id] = Dropdown
                
                local DropdownFrame = Utility:Create("Frame", {
                    Name = name .. "_Dropdown",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 42),
                    Visible = true
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = DropdownFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.028, 0, 0, 0),
                    Size = UDim2.new(0.482, 0, 1, 0),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextWrapped = true
                })
                
                local ImageButton = Utility:Create("TextButton", {
                    Name = "DropdownButton",
                    Parent = DropdownFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local selectionFrame = Utility:Create("Frame", {
                    Name = "selectionFrame",
                    Parent = DropdownFrame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.543, 0, 0.095, 0),
                    Size = UDim2.new(-0.033, 200, 0.809, 0),
                    ZIndex = 0
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) })
                })
                
                local SelectedText = Utility:Create("TextLabel", {
                    Name = "SelectedText",
                    Parent = selectionFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(-0.005, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = currentFont,
                    Text = multiSelect and (type(default) == "table" and #default > 0 and #default .. " selected" or "None") or default,
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    TextWrapped = true,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local function filterOptions(searchText)
                    local filtered = {}
                    for _, option in pairs(options) do
                        if string.find(string.lower(option), string.lower(searchText)) then
                            table.insert(filtered, option)
                        end
                    end
                    return filtered
                end
                
                local function closeCurrentDropdown()
                    if Window.ActiveDropdown then
                        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
                        local outroTween = TweenService:Create(Window.ActiveDropdown, tweenInfo, {Position = UDim2.new(-1.1, 0, -0.003, 0)})
                        outroTween:Play()
                        outroTween.Completed:Connect(function()
                            if Window.ActiveDropdown and Window.ActiveDropdown.Parent then
                                Window.ActiveDropdown:Destroy()
                            end
                            Window.ActiveDropdown = nil
                        end)
                    end
                end
                
                local function createDropdownMenu()
                    closeCurrentDropdown()
                    
                    local DropdownMenu = Utility:Create("Frame", {
                        Name = "DropdownMenu",
                        Parent = ScreenGui,
                        BackgroundColor3 = theme.Container,
                        BackgroundTransparency = theme.ContainerTransparency,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, Mouse.X, 0, Mouse.Y),
                        Size = UDim2.new(0, 200, 0, 0),
                        ZIndex = 1000,
                        ClipsDescendants = true
                    }, {
                        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                    })
                    
                    local SearchBoxContainer = Utility:Create("Frame", {
                        Name = "SearchBoxContainer",
                        Parent = DropdownMenu,
                        BackgroundColor3 = theme.Element,
                        BackgroundTransparency = theme.ElementTransparency - 0.1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 8, 0, 45),
                        Size = UDim2.new(0, 184, 0, 28),
                        ZIndex = 1001
                    }, {
                        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) }),
                        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                    })
                    
                    local SearchTextBox = Utility:Create("TextBox", {
                        Name = "SearchTextBox",
                        Parent = SearchBoxContainer,
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(0, 168, 1, 0),
                        Font = currentFont,
                        PlaceholderText = "Search...",
                        PlaceholderColor3 = theme.TextMuted,
                        Text = "",
                        TextColor3 = theme.Text,
                        TextSize = 12,
                        ClearTextOnFocus = false,
                        ZIndex = 1002
                    })
                    
                    local ScrollingFrame = Utility:Create("ScrollingFrame", {
                        Parent = DropdownMenu,
                        Active = true,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 78),
                        Size = UDim2.new(1, 0, 0, 180),
                        ScrollBarThickness = 4,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollingEnabled = true,
                        ZIndex = 1001
                    })
                    
                    local TitleText = Utility:Create("TextLabel", {
                        Name = "TitleText",
                        Parent = DropdownMenu,
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.042, 0, 0.058, 0),
                        Size = UDim2.new(0.9, 0, 0, 28),
                        Font = currentFont,
                        Text = name,
                        TextColor3 = theme.Text,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 1001
                    })
                    
                    local CloseButton = Utility:Create("ImageButton", {
                        Name = "CloseButton",
                        Parent = DropdownMenu,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.85, 0, 0.05, 0),
                        Size = UDim2.new(0, 25, 0, 25),
                        Image = "rbxassetid://3926305904",
                        ImageRectOffset = Vector2.new(284, 4),
                        ImageRectSize = Vector2.new(24, 24),
                        ZIndex = 1001
                    })
                    
                    Utility:Create("UIPadding", {
                        Parent = ScrollingFrame,
                        PaddingLeft = UDim.new(0, 8),
                        PaddingRight = UDim.new(0, 8)
                    })
                    
                    Utility:Create("UIListLayout", {
                        Parent = ScrollingFrame,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 5)
                    })
                    
                    local function createOptions(filteredOptions)
                        for _, child in pairs(ScrollingFrame:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        
                        local optionHeight = 0
                        for i, v in ipairs(filteredOptions) do
                            local OptionButton = Utility:Create("TextButton", {
                                Name = v,
                                Parent = ScrollingFrame,
                                BackgroundColor3 = theme.Element,
                                BackgroundTransparency = theme.ElementTransparency,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                Size = UDim2.new(1, 0, 0, 40),
                                Font = currentFont,
                                Text = v,
                                TextColor3 = theme.Text,
                                TextSize = 13,
                                AutoButtonColor = false,
                                ZIndex = 1002
                            }, {
                                Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) })
                            })
                            
                            optionHeight = optionHeight + 45
                            
                            local isSelected = false
                            if multiSelect then
                                isSelected = table.find(Dropdown.Value, v) ~= nil
                            else
                                isSelected = Dropdown.Value == v
                            end
                            
                            if isSelected then
                                OptionButton.BackgroundColor3 = theme.Accent
                                OptionButton.BackgroundTransparency = 0
                                OptionButton.TextColor3 = theme.Text
                            end
                            
                            OptionButton.MouseEnter:Connect(function()
                                Utility:Tween(OptionButton, {BackgroundColor3 = isSelected and theme.AccentDark or theme.ElementHover, BackgroundTransparency = isSelected and 0.1 or theme.ElementTransparency - 0.2}, Config.AnimationSpeed * 0.3)
                            end)
                            
                            OptionButton.MouseLeave:Connect(function()
                                Utility:Tween(OptionButton, {BackgroundColor3 = isSelected and theme.Accent :Lerp(theme.Element, 0.2) or theme.Element, BackgroundTransparency = isSelected and 0.1 or theme.ElementTransparency}, Config.AnimationSpeed * 0.3)
                            end)
                            
                            OptionButton.MouseButton1Click:Connect(function()
                                if multiSelect then
                                    local idx = table.find(Dropdown.Value, v)
                                    if idx then
                                        table.remove(Dropdown.Value, idx)
                                        OptionButton.BackgroundColor3 = theme.Element
                                        OptionButton.BackgroundTransparency = theme.ElementTransparency
                                        OptionButton.TextColor3 = theme.Text
                                    else
                                        table.insert(Dropdown.Value, v)
                                        OptionButton.BackgroundColor3 = theme.Accent
                                        OptionButton.BackgroundTransparency = 0
                                        OptionButton.TextColor3 = theme.Text
                                    end
                                    SelectedText.Text = #Dropdown.Value > 0 and #Dropdown.Value .. " selected" or "None"
                                else
                                    Dropdown.Value = v
                                    SelectedText.Text = v
                                    
                                    for _, opt in pairs(ScrollingFrame:GetChildren()) do
                                        if opt:IsA("TextButton") then
                                            local optIsSelected = opt.Name == v
                                            Utility:Tween(opt, {
                                                BackgroundColor3 = optIsSelected and theme.Accent or theme.Element,
                                                BackgroundTransparency = optIsSelected and 0 or theme.ElementTransparency
                                            }, Config.AnimationSpeed * 0.3)
                                        end
                                    end
                                end
                                
                                SaveConfig()
                                callback(Dropdown.Value)
                                
                                if not multiSelect then
                                    task.wait(Config.AnimationSpeed * 0.3)
                                    closeCurrentDropdown()
                                    if dropdownCloseConnection then
                                        dropdownCloseConnection:Disconnect()
                                    end
                                end
                            end)
                        end
                        
                        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, optionHeight)
                    end
                    
                    SearchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local searchText = SearchTextBox.Text
                        if searchText == "" then
                            createOptions(options)
                        else
                            local filtered = filterOptions(searchText)
                            createOptions(filtered)
                        end
                    end)
                    
                    local dropdownHeight = math.min(40 + (math.min(#options, 6) * 45) + 38, 280)
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local introTween = TweenService:Create(DropdownMenu, tweenInfo, {Size = UDim2.new(0, 200, 0, dropdownHeight)})
                    introTween:Play()
                    
                    Window.ActiveDropdown = DropdownMenu
                    
                    local dropdownCloseConnection
                    dropdownCloseConnection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local mouse = Player:GetMouse()
                            local framePos = DropdownMenu.AbsolutePosition
                            local frameSize = DropdownMenu.AbsoluteSize
                            local mousePos = Vector2.new(mouse.X, mouse.Y)
                            
                            if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
                                closeCurrentDropdown()
                                if dropdownCloseConnection then
                                    dropdownCloseConnection:Disconnect()
                                end
                            end
                        end
                    end)
                    
                    CloseButton.MouseButton1Click:Connect(function()
                        closeCurrentDropdown()
                        if dropdownCloseConnection then
                            dropdownCloseConnection:Disconnect()
                        end
                    end)
                    
                    createOptions(options)
                end
                
                ImageButton.MouseButton1Click:Connect(function()
                    createDropdownMenu()
                end)
                
                function Dropdown:Set(v, skip)
                    if multiSelect then
                        Dropdown.Value = type(v) == "table" and v or {v}
                        SelectedText.Text = #Dropdown.Value > 0 and #Dropdown.Value .. " selected" or "None"
                    else
                        Dropdown.Value = v
                        SelectedText.Text = v
                    end
                    SaveConfig()
                    if not skip then callback(Dropdown.Value) end
                end
                
                function Dropdown:Refresh(newOpts, keepVal)
                    options = newOpts
                    Dropdown.Options = newOpts
                    
                    if not keepVal then
                        Dropdown.Value = multiSelect and {} or (newOpts[1] or "")
                        SelectedText.Text = multiSelect and "None" or (newOpts[1] or "")
                    end
                end
                
                if default then callback(Dropdown.Value) end
                table.insert(Window.ElementRefs, { Type = "Dropdown", Element = Dropdown, Frame = DropdownFrame, Label = Label, Selected = SelectedText, ScrollContainer = ScreenGui })
                return Dropdown
            end
            
            function Section:CreatePlayerSelector(args)
                args = args or {}
                local name = args.Name or "Player Selector"
                local id = args.Flag or name
                local default = args.CurrentPlayer or Players.LocalPlayer
                local callback = args.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    local savedName = Window.ConfigData.Elements[id]
                    for _, player in pairs(Players:GetPlayers()) do
                        if player.Name == savedName or player.DisplayName == savedName then
                            default = player
                            break
                        end
                    end
                end
                
                local PlayerSelector = {
                    Value = default,
                    Open = false,
                    Options = {}
                }
                Window.Elements[id] = { Value = default.Name }
                
                local PlayerSelectorFrame = Utility:Create("Frame", {
                    Name = name .. "_PlayerSelector",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 63),
                    Visible = true
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = PlayerSelectorFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.028, 0, 0, 0),
                    Size = UDim2.new(0.218, 0, 0, 63),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ImageButton = Utility:Create("TextButton", {
                    Name = "PlayerSelectorButton",
                    Parent = PlayerSelectorFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local selectionFrame = Utility:Create("Frame", {
                    Name = "selectionFrame",
                    Parent = PlayerSelectorFrame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 0,
                    Position = UDim2.new(0.543, 0, 0.095, 0),
                    Size = UDim2.new(0, 185, 0, 51)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) })
                })
                
                local function getPlayersAndIcons()
                    local players = Players:GetPlayers()
                    local playerIcons = {}
                    for _, player in pairs(players) do
                        local userId = player.UserId
                        local thumbType = Enum.ThumbnailType.HeadShot
                        local thumbSize = Enum.ThumbnailSize.Size420x420
                        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
                        table.insert(playerIcons, {
                            Name = player.Name,
                            Icon = content
                        })
                    end
                    return playerIcons
                end
                
                local AvatarImage = Utility:Create("ImageLabel", {
                    Name = "Avatar",
                    Parent = selectionFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.032, 0, 0.058, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 45, 0, 45),
                    Image = "http://www.roblox.com/asset/?id=10885644041"
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                
                pcall(function()
                    local thumbType = Enum.ThumbnailType.HeadShot
                    local thumbSize = Enum.ThumbnailSize.Size420x420
                    local content, isReady = Players:GetUserThumbnailAsync(default.UserId, thumbType, thumbSize)
                    if isReady then
                        AvatarImage.Image = content
                    end
                end)
                
                local SelectedText = Utility:Create("TextLabel", {
                    Name = "SelectedText",
                    Parent = selectionFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.313, 0, 0.058, 0),
                    Size = UDim2.new(0, 126, 0, 45),
                    Font = currentFont,
                    Text = default.DisplayName,
                    TextColor3 = theme.TextDark,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local function closeCurrentDropdown()
                    if Window.ActiveDropdown then
                        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
                        local outroTween = TweenService:Create(Window.ActiveDropdown, tweenInfo, {Position = UDim2.new(-1.1, 0, -0.003, 0)})
                        outroTween:Play()
                        outroTween.Completed:Connect(function()
                            if Window.ActiveDropdown and Window.ActiveDropdown.Parent then
                                Window.ActiveDropdown:Destroy()
                            end
                            Window.ActiveDropdown = nil
                        end)
                    end
                end
                
                local function createPlayerDropdown()
                    closeCurrentDropdown()
                    
                    local playerIcons = getPlayersAndIcons()
                    local DropdownMenu = Utility:Create("Frame", {
                        Name = "PlayerDropdownMenu",
                        Parent = ScreenGui,
                        BackgroundColor3 = theme.Container,
                        BackgroundTransparency = theme.ContainerTransparency,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, Mouse.X, 0, Mouse.Y),
                        Size = UDim2.new(0, 250, 0, 0),
                        ZIndex = 1000,
                        ClipsDescendants = true
                    }, {
                        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                    })
                    
                    local ScrollingFrame = Utility:Create("ScrollingFrame", {
                        Parent = DropdownMenu,
                        Active = true,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 40),
                        Size = UDim2.new(1, 0, 0, 200),
                        ScrollBarThickness = 4,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollingEnabled = true,
                        ZIndex = 1001
                    })
                    
                    local TitleText = Utility:Create("TextLabel", {
                        Name = "TitleText",
                        Parent = DropdownMenu,
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.042, 0, 0.058, 0),
                        Size = UDim2.new(0.9, 0, 0, 28),
                        Font = currentFont,
                        Text = name,
                        TextColor3 = theme.Text,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 1001
                    })
                    
                    local CloseButton = Utility:Create("ImageButton", {
                        Name = "CloseButton",
                        Parent = DropdownMenu,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.85, 0, 0.05, 0),
                        Size = UDim2.new(0, 25, 0, 25),
                        Image = "rbxassetid://3926305904",
                        ImageRectOffset = Vector2.new(284, 4),
                        ImageRectSize = Vector2.new(24, 24),
                        ZIndex = 1001
                    })
                    
                    Utility:Create("UIPadding", {
                        Parent = ScrollingFrame,
                        PaddingLeft = UDim.new(0, 8),
                        PaddingRight = UDim.new(0, 8)
                    })
                    
                    Utility:Create("UIListLayout", {
                        Parent = ScrollingFrame,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 8)
                    })
                    
                    local dropdownHeight = math.min(40 + (math.min(#playerIcons, 5) * 52), 300)
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local introTween = TweenService:Create(DropdownMenu, tweenInfo, {Size = UDim2.new(0, 250, 0, dropdownHeight)})
                    introTween:Play()
                    
                    Window.ActiveDropdown = DropdownMenu
                    
                    local dropdownCloseConnection
                    dropdownCloseConnection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local mouse = Player:GetMouse()
                            local framePos = DropdownMenu.AbsolutePosition
                            local frameSize = DropdownMenu.AbsoluteSize
                            local mousePos = Vector2.new(mouse.X, mouse.Y)
                            
                            if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
                                closeCurrentDropdown()
                                if dropdownCloseConnection then
                                    dropdownCloseConnection:Disconnect()
                                end
                            end
                        end
                    end)
                    
                    CloseButton.MouseButton1Click:Connect(function()
                        closeCurrentDropdown()
                        if dropdownCloseConnection then
                            dropdownCloseConnection:Disconnect()
                        end
                    end)
                    
                    for i, v in pairs(playerIcons) do
                        local Name = v.Name
                        local Icon = v.Icon
                        
                        local PlayerFrame = Utility:Create("Frame", {
                            Name = "PlayerFrame",
                            Parent = ScrollingFrame,
                            BackgroundColor3 = theme.Element,
                            BackgroundTransparency = theme.ElementTransparency,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, 50),
                            ZIndex = 1002
                        }, {
                            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) })
                        })
                        
                        local PlayerImage = Utility:Create("ImageLabel", {
                            Name = "PlayerImage",
                            Parent = PlayerFrame,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Position = UDim2.new(0.15, 0, 0.5, 0),
                            Size = UDim2.new(0, 40, 0, 40),
                            Image = Icon,
                            ZIndex = 1003
                        }, {
                            Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                        })
                        
                        local PlayerNameLabel = Utility:Create("TextLabel", {
                            Name = "PlayerNameLabel",
                            Parent = PlayerFrame,
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Position = UDim2.new(0.35, 0, 0.5, 0),
                            Size = UDim2.new(0.6, 0, 0, 40),
                            Font = currentFont,
                            Text = Name,
                            TextColor3 = theme.Text,
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 1003
                        })
                        
                        local SelectionBox = Utility:Create("TextButton", {
                            Name = "SelectionBox",
                            Parent = PlayerFrame,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 1, 0),
                            Text = "",
                            AutoButtonColor = false,
                            ZIndex = 1004
                        })
                        
                        SelectionBox.MouseButton1Click:Connect(function()
                            SelectedText.Text = Name
                            AvatarImage.Image = Icon
                            
                            local selectedPlayer = Players:FindFirstChild(Name)
                            if selectedPlayer then
                                PlayerSelector.Value = selectedPlayer
                                Window.Elements[id].Value = Name
                                SaveConfig()
                                callback(selectedPlayer)
                            end
                            
                            task.wait(Config.AnimationSpeed * 0.3)
                            closeCurrentDropdown()
                            if dropdownCloseConnection then
                                dropdownCloseConnection:Disconnect()
                            end
                        end)
                    end
                    
                    local totalHeight = (#playerIcons * 58)
                    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                end
                
                ImageButton.MouseButton1Click:Connect(function()
                    createPlayerDropdown()
                end)
                
                function PlayerSelector:Set(player, skip)
                    PlayerSelector.Value = player
                    SelectedText.Text = player.DisplayName
                    
                    pcall(function()
                        local thumbType = Enum.ThumbnailType.HeadShot
                        local thumbSize = Enum.ThumbnailSize.Size420x420
                        local content, isReady = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
                        if isReady then
                            AvatarImage.Image = content
                        end
                    end)
                    
                    Window.Elements[id].Value = player.Name
                    SaveConfig()
                    if not skip then callback(player) end
                end
                
                callback(default)
                return PlayerSelector
            end
            
            function Section:CreateColorPicker(args)
                args = args or {}
                local name = args.Name or "Color Picker"
                local id = args.Flag or name
                local default = args.Color or Color3.new(1, 1, 1)
                local callback = args.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    local saved = Window.ConfigData.Elements[id]
                    if type(saved) == "table" then
                        default = Color3.fromRGB(saved[1], saved[2], saved[3])
                    end
                end
                
                local ColorPicker = { 
                    Value = default, 
                    Open = false 
                }
                Window.Elements[id] = { 
                    Value = {
                        math.floor(default.R * 255), 
                        math.floor(default.G * 255), 
                        math.floor(default.B * 255)
                    } 
                }
                
                local dH, dS, dV = default:ToHSV()
                local DefaultRGB = Color3.fromRGB(
                    math.floor(default.R * 255),
                    math.floor(default.G * 255),
                    math.floor(default.B * 255)
                )
                
                local function Color3ToRGB(color)
                    return Color3.new(
                        math.floor(color.R * 255),
                        math.floor(color.G * 255),
                        math.floor(color.B * 255)
                    )
                end
                
                local function DPRound(decimal, points)
                    local pow = math.pow(10, points)
                    local newDP = decimal * pow
                    newDP = math.floor(newDP)
                    return newDP / pow
                end
                
                local function setHueAndSaturation(color3, Sat, Value)
                    local hue, sat, val = color3:ToHSV()
                    return Color3.fromHSV(hue, Sat, Value)
                end
                
                local Dropdown = Utility:Create("Frame", {
                    Name = name .. "ColorPicker",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 42),
                    Visible = true
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.028, 0, 0, 0),
                    Size = UDim2.new(0.482, 0, 1, 0),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ImageButton = Utility:Create("TextButton", {
                    Name = "ColorPickerButton",
                    Parent = Dropdown,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local selectionFrame = Utility:Create("Frame", {
                    Name = "selectionFrame",
                    Parent = Dropdown,
                    BackgroundColor3 = default,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(.5, .5),
                    Position = UDim2.new(0.943, 0, 0.5, 0),
                    Size = UDim2.new(0.08, 0, 0.81, 0),
                    ZIndex = 0
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) })
                })
                
                local function closeCurrentDropdown()
                    if Window.ActiveDropdown then
                        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
                        local outroTween = TweenService:Create(Window.ActiveDropdown, tweenInfo, {Position = UDim2.new(-1.1, 0, -0.003, 0)})
                        outroTween:Play()
                        outroTween.Completed:Connect(function()
                            if Window.ActiveDropdown and Window.ActiveDropdown.Parent then
                                Window.ActiveDropdown:Destroy()
                            end
                            Window.ActiveDropdown = nil
                        end)
                    end
                end
                
                local function createColorPicker()
                    closeCurrentDropdown()
                    
                    local ColorPickerMenu = Utility:Create("Frame", {
                        Name = "ColorPickerMenu",
                        Parent = ScreenGui,
                        BackgroundColor3 = theme.Container,
                        BackgroundTransparency = theme.ContainerTransparency,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, Mouse.X, 0, Mouse.Y),
                        Size = UDim2.new(0, 250, 0, 0),
                        ZIndex = 1000,
                        ClipsDescendants = true
                    }, {
                        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                    })
                    
                    local TitleText = Utility:Create("TextLabel", {
                        Name = "TitleText",
                        Parent = ColorPickerMenu,
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.042, 0, 0.058, 0),
                        Size = UDim2.new(0.9, 0, 0, 28),
                        Font = currentFont,
                        Text = name,
                        TextColor3 = theme.Text,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 1001
                    })
                    
                    local Frame = Utility:Create("Frame", {
                        Parent = ColorPickerMenu,
                        BackgroundColor3 = theme.Element,
                        BackgroundTransparency = theme.ElementTransparency,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.042, 0, 0.2, 0),
                        Size = UDim2.new(0.915, 0, 0.7, 0),
                        ZIndex = 1001
                    }, {
                        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) })
                    })
                    
                    local Frame_2 = Utility:Create("Frame", {
                        Parent = Frame,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.838, 0, 0.044, 0),
                        Size = UDim2.new(0.110, 0, 0.681, 0),
                        ZIndex = 1002
                    })
                    
                    local ValueButton = Utility:Create("TextButton", {
                        Name = "ValueButton",
                        Parent = Frame_2,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 1, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 1003
                    })
                    
                    local UIGradient = Utility:Create("UIGradient", {
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
                            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
                        },
                        Rotation = 90,
                        Parent = Frame_2
                    })
                    
                    local ImageLabel = Utility:Create("ImageLabel", {
                        Parent = Frame,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.059, 0, 0.044, 0),
                        Size = UDim2.new(0.709, 0, 0.681, 0),
                        Image = "http://www.roblox.com/asset/?id=13037988771",
                        ZIndex = 1002
                    })
                    
                    local HSIButton = Utility:Create("TextButton", {
                        Name = "HSIButton",
                        Parent = ImageLabel,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 1, 0),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 1003
                    })
                    
                    local RGB_Box = Utility:Create("TextLabel", {
                        Name = "RGB_Box",
                        Parent = Frame,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.221, 0, 0.761, 0),
                        Size = UDim2.new(0.548, 0, 0.070, 0),
                        Font = currentFont,
                        Text = string.format("%d, %d, %d", 
                            math.floor(DefaultRGB.R * 255),
                            math.floor(DefaultRGB.G * 255), 
                            math.floor(DefaultRGB.B * 255)
                        ),
                        TextColor3 = theme.Text,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 1002
                    })
                    
                    local RandomLabel1 = Utility:Create("TextLabel", {
                        Name = "RandomLabel1",
                        Parent = Frame,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.059, 0, 0.761, 0),
                        Size = UDim2.new(0.161, 0, 0.061, 0),
                        Font = currentFont,
                        Text = "RGB:",
                        TextColor3 = theme.Text,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 1002
                    })
                    
                    local RandomLabel2 = Utility:Create("TextLabel", {
                        Name = "RandomLabel2",
                        Parent = Frame,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.059, 0, 0.840, 0),
                        Size = UDim2.new(0.161, 0, 0.061, 0),
                        Font = currentFont,
                        Text = "HSV:",
                        TextColor3 = theme.Text,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 1002
                    })
                    
                    local HSV_Box = Utility:Create("TextLabel", {
                        Name = "HSV_Box",
                        Parent = Frame,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.221, 0, 0.840, 0),
                        Size = UDim2.new(0.548, 0, 0.070, 0),
                        Font = currentFont,
                        Text = string.format("%.3f, %.3f, %.3f", DPRound(dH,3), DPRound(dS,3), DPRound(dV,3)),
                        TextColor3 = theme.Text,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 1002
                    })
                    
                    local CloseButton = Utility:Create("ImageButton", {
                        Name = "CloseButton",
                        Parent = ColorPickerMenu,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.85, 0, 0.05, 0),
                        Size = UDim2.new(0, 25, 0, 25),
                        Image = "rbxassetid://3926305904",
                        ImageRectOffset = Vector2.new(284, 4),
                        ImageRectSize = Vector2.new(24, 24),
                        ZIndex = 1001
                    })
                    
                    local Continue = Utility:Create("ImageButton", {
                        Name = "Continue",
                        Parent = Frame,
                        BackgroundTransparency = 1,
                        LayoutOrder = 10,
                        Position = UDim2.new(0.801, 0, 0.757, 0),
                        Size = UDim2.new(0, 32, 0, 32),
                        ZIndex = 1002,
                        Image = "rbxassetid://3926307971",
                        ImageRectOffset = Vector2.new(764, 244),
                        ImageRectSize = Vector2.new(36, 36)
                    })
                    
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local introTween = TweenService:Create(ColorPickerMenu, tweenInfo, {Size = UDim2.new(0, 250, 0, 220)})
                    introTween:Play()
                    
                    Window.ActiveDropdown = ColorPickerMenu
                    
                    local dropdownCloseConnection
                    dropdownCloseConnection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local mouse = Player:GetMouse()
                            local framePos = ColorPickerMenu.AbsolutePosition
                            local frameSize = ColorPickerMenu.AbsoluteSize
                            local mousePos = Vector2.new(mouse.X, mouse.Y)
                            
                            if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
                                closeCurrentDropdown()
                                if dropdownCloseConnection then
                                    dropdownCloseConnection:Disconnect()
                                end
                            end
                        end
                    end)
                    
                    CloseButton.MouseButton1Click:Connect(function()
                        closeCurrentDropdown()
                        if dropdownCloseConnection then
                            dropdownCloseConnection:Disconnect()
                        end
                    end)
                    
                    local pickingColor = false
                    local pickingValue = false
                    local currentHue = dH
                    local currentSaturation = dS
                    local currentValue = dV
                    
                    HSIButton.MouseButton1Down:Connect(function() 
                        pickingColor = true
                    end)
                    
                    HSIButton.MouseButton1Up:Connect(function() 
                        pickingColor = false
                    end)
                    
                    ValueButton.MouseButton1Down:Connect(function() 
                        pickingValue = true
                    end)
                    
                    ValueButton.MouseButton1Up:Connect(function() 
                        pickingValue = false
                    end)
                    
                    local renderConnection
                    renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
                        if pickingColor or pickingValue then
                            local mouse = Player:GetMouse()
                            local mouseX = mouse.X
                            local mouseY = mouse.Y
                            
                            if pickingColor then
                                local popX = math.clamp(mouseX - ImageLabel.AbsolutePosition.X, 0, ImageLabel.AbsoluteSize.X)
                                local popY = math.clamp(mouseY - ImageLabel.AbsolutePosition.Y, 0, ImageLabel.AbsoluteSize.Y)
                                
                                currentHue = 1 - popX / ImageLabel.AbsoluteSize.X
                                currentSaturation = 1 - (popY / ImageLabel.AbsoluteSize.Y)
                            end
                            
                            if pickingValue then
                                local valY = math.clamp(mouseY - ValueButton.AbsolutePosition.Y, 0, ValueButton.AbsoluteSize.Y)
                                currentValue = 1 - (valY / ValueButton.AbsoluteSize.Y)
                            end
                            
                            local finalColorHSV = Color3.fromHSV(currentHue, currentSaturation, currentValue)
                            local finalColorRGB = Color3.fromRGB(
                                math.floor((finalColorHSV.R * 255) + 0.5),
                                math.floor((finalColorHSV.G * 255) + 0.5),
                                math.floor((finalColorHSV.B * 255) + 0.5)
                            )
                            
                            selectionFrame.BackgroundColor3 = finalColorRGB
                            UIGradient.Color = ColorSequence.new{
                                ColorSequenceKeypoint.new(0.00, Color3.fromHSV(currentHue, currentSaturation, 1)),
                                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
                            }
                            
                            RGB_Box.Text = string.format("%d, %d, %d", 
                                finalColorRGB.R * 255, 
                                finalColorRGB.G * 255, 
                                finalColorRGB.B * 255
                            )
                            HSV_Box.Text = string.format("%.3f, %.3f, %.3f", 
                                currentHue, 
                                currentSaturation, 
                                currentValue
                            )
                            
                            ColorPicker.Value = finalColorRGB
                            Window.Elements[id].Value = {
                                math.floor(finalColorRGB.R * 255),
                                math.floor(finalColorRGB.G * 255),
                                math.floor(finalColorRGB.B * 255)
                            }
                            
                            SaveConfig()
                            callback(finalColorRGB)
                        end
                    end)
                    
                    table.insert(Window.Connections, renderConnection)
                    
                    Continue.MouseButton1Click:Connect(function() 
                        closeCurrentDropdown()
                        if dropdownCloseConnection then
                            dropdownCloseConnection:Disconnect()
                        end
                        if renderConnection then
                            renderConnection:Disconnect()
                        end
                    end)
                end
                
                ImageButton.MouseButton1Click:Connect(function()
                    createColorPicker()
                end)
                
                function ColorPicker:Set(color, skip)
                    local h, s, v = color:ToHSV()
                    local finalColorRGB = Color3.fromRGB(
                        math.floor(color.R * 255),
                        math.floor(color.G * 255),
                        math.floor(color.B * 255)
                    )
                    
                    selectionFrame.BackgroundColor3 = color
                    ColorPicker.Value = color
                    Window.Elements[id].Value = {
                        math.floor(color.R * 255),
                        math.floor(color.G * 255),
                        math.floor(color.B * 255)
                    }
                    
                    SaveConfig()
                    if not skip then callback(color) end
                end
                
                callback(default)
                return ColorPicker
            end
            
            function Section:CreateInput(opts)
                opts = opts or {}
                local name = opts.Name or "Input"
                local id = opts.Flag or name
                local placeholder = opts.PlaceholderText or "Enter text..."
                local default = opts.CurrentValue or ""
                local removeOnLost = opts.RemoveTextAfterFocusLost or false
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Input = { Value = default }
                Window.Elements[id] = Input
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Input",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.35, 0, 1, 0),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local BoxContainer = Utility:Create("Frame", {
                    Name = "BoxContainer",
                    Parent = Frame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency,
                    Position = UDim2.new(0.35, 5, 0.15, 0),
                    Size = UDim2.new(0.65, -20, 0.7, 0)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) }),
                    Utility:Create("UIStroke", { Name = "BoxStroke", Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                })
                
                local TextBox = Utility:Create("TextBox", {
                    Name = "TextBox",
                    Parent = BoxContainer,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = currentFont,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = theme.TextMuted,
                    Text = default,
                    TextColor3 = theme.Text,
                    TextSize = 13,
                    ClearTextOnFocus = false,
                    ClipsDescendants = true
                })
                
                table.insert(Window.ElementRefs, { Type = "Input", Element = Input, Frame = Frame, Label = Label, BoxContainer = BoxContainer, TextBox = TextBox })
                
                TextBox.Focused:Connect(function()
                    Utility:Tween(BoxContainer:FindFirstChild("BoxStroke"), {Color = theme.Accent, Transparency = 0}, Config.AnimationSpeed)
                    Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed)
                end)
                
                TextBox.FocusLost:Connect(function(enter)
                    Utility:Tween(BoxContainer:FindFirstChild("BoxStroke"), {Color = theme.Border, Transparency = theme.BorderTransparency}, Config.AnimationSpeed)
                    Utility:Tween(Frame, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed)
                    
                    Input.Value = TextBox.Text
                    SaveConfig()
                    
                    if enter or not removeOnLost then
                        callback(TextBox.Text)
                    end
                    
                    if removeOnLost then
                        TextBox.Text = ""
                        Input.Value = ""
                    end
                end)
                
                function Input:Set(t, skip)
                    TextBox.Text = t
                    Input.Value = t
                    SaveConfig()
                    if not skip then callback(t) end
                end
                
                return Input
            end
            
            function Section:CreateKeybind(opts)
                opts = opts or {}
                local name = opts.Name or "Keybind"
                local id = opts.Flag or name
                local default = opts.CurrentKeybind or "None"
                local holdMode = opts.HoldToInteract or false
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Keybind = {
                    Value = default ~= "None" and Enum.KeyCode[default] or nil,
                    Listening = false
                }
                Window.Elements[id] = { Value = default }
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Keybind",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Font = currentFont,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local KeyButton = Utility:Create("TextButton", {
                    Name = "KeyButton",
                    Parent = Frame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency,
                    Position = UDim2.new(1, -100, 0.15, 0),
                    Size = UDim2.new(0, 85, 0.7, 0),
                    Font = currentFont,
                    Text = default,
                    TextColor3 = theme.TextDark,
                    TextSize = 12,
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) }),
                    Utility:Create("UIStroke", { Name = "ButtonStroke", Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                })
                
                table.insert(Window.ElementRefs, { Type = "Keybind", Element = Keybind, Frame = Frame, Label = Label, KeyButton = KeyButton })
                
                KeyButton.MouseEnter:Connect(function()
                    if not Keybind.Listening then
                        Utility:Tween(KeyButton, {BackgroundTransparency = theme.ContainerTransparency - 0.15}, Config.AnimationSpeed * 0.5)
                    end
                end)
                
                KeyButton.MouseLeave:Connect(function()
                    if not Keybind.Listening then
                        Utility:Tween(KeyButton, {BackgroundTransparency = theme.ContainerTransparency}, Config.AnimationSpeed * 0.5)
                    end
                end)
                
                KeyButton.MouseButton1Click:Connect(function()
                    Keybind.Listening = true
                    KeyButton.Text = "..."
                    Utility:Tween(KeyButton, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0}, Config.AnimationSpeed)
                    Utility:Tween(KeyButton:FindFirstChild("ButtonStroke"), {Color = theme.Accent, Transparency = 0.3}, Config.AnimationSpeed)
                end)
                
                local inputConn = UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    
                    if Keybind.Listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            local keyName = input.KeyCode.Name
                            
                            if input.KeyCode == Enum.KeyCode.Escape then
                                Keybind.Value = nil
                                keyName = "None"
                            else
                                Keybind.Value = input.KeyCode
                            end
                            
                            Keybind.Listening = false
                            KeyButton.Text = keyName
                            Window.Elements[id].Value = keyName
                            
                            Utility:Tween(KeyButton, {BackgroundColor3 = theme.Container, BackgroundTransparency = theme.ContainerTransparency}, Config.AnimationSpeed)
                            Utility:Tween(KeyButton:FindFirstChild("ButtonStroke"), {Color = theme.Border, Transparency = theme.BorderTransparency}, Config.AnimationSpeed)
                            
                            SaveConfig()
                        end
                    elseif Keybind.Value and input.KeyCode == Keybind.Value then
                        if holdMode then
                            callback(true)
                        else
                            callback()
                        end
                    end
                end)
                table.insert(Window.Connections, inputConn)
                
                if holdMode then
                    local inputEndConn = UserInputService.InputEnded:Connect(function(input, gpe)
                        if gpe then return end
                        if Keybind.Value and input.KeyCode == Keybind.Value then
                            callback(false)
                        end
                    end)
                    table.insert(Window.Connections, inputEndConn)
                end
                
                function Keybind:Set(key, skip)
                    if type(key) == "string" then
                        if key == "None" then
                            Keybind.Value = nil
                        else
                            Keybind.Value = Enum.KeyCode[key]
                        end
                        KeyButton.Text = key
                        Window.Elements[id].Value = key
                    else
                        Keybind.Value = key
                        KeyButton.Text = key and key.Name or "None"
                        Window.Elements[id].Value = key and key.Name or "None"
                    end
                    SaveConfig()
                end
                
                return Keybind
            end
            
            function Section:CreateLabel(text)
                local Frame = Utility:Create("Frame", {
                    Name = "Label",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency + 0.1,
                    Size = UDim2.new(1, 0, 0, 32)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) })
                })
                
                local Text = Utility:Create("TextLabel", {
                    Name = "Text",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    Font = currentFont,
                    Text = text or "Label",
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                table.insert(Window.ElementRefs, { Type = "Label", Frame = Frame, Text = Text })
                
                return {
                    Set = function(_, t)
                        Text.Text = t
                        Text.TextTransparency = 0.5
                        Utility:Tween(Text, {TextTransparency = 0}, Config.AnimationSpeed)
                    end
                }
            end
            
            function Section:CreateParagraph(opts)
                opts = opts or {}
                local title = opts.Title or "Paragraph"
                local content = opts.Content or "Content"
                
                local Frame = Utility:Create("Frame", {
                    Name = "Paragraph",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 }),
                    Utility:Create("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) })
                })
                
                local Title = Utility:Create("TextLabel", {
                    Name = "Title",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = currentFont,
                    Text = title,
                    TextColor3 = theme.Text,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Content = Utility:Create("TextLabel", {
                    Name = "Content",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Font = currentFont,
                    Text = content,
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    RichText = true
                })
                
                table.insert(Window.ElementRefs, { Type = "Paragraph", Frame = Frame, Title = Title, Content = Content })
                
                return {
                    Set = function(_, newTitle, newContent)
                        if newTitle then Title.Text = newTitle end
                        if newContent then Content.Text = newContent end
                        Frame.BackgroundTransparency = theme.ElementTransparency + 0.2
                        Utility:Tween(Frame, {BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed)
                    end
                }
            end
            
            function Section:CreateDivider()
                return Utility:Create("Frame", {
                    Name = "Divider",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Border,
                    BackgroundTransparency = theme.BorderTransparency,
                    Size = UDim2.new(1, 0, 0, 1)
                })
            end
            
            return Section
        end
        
        return Tab
    end
    
    function Window:Dialog(opts)
        opts = opts or {}
        local title = opts.Title or "Dialog"
        local content = opts.Content or ""
        local buttons = opts.Buttons or {}
        
        local DialogBg = Utility:Create("Frame", {
            Name = "DialogBackground",
            Parent = ScreenGui,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 100
        })
        
        local DialogFrame = Utility:Create("Frame", {
            Name = "Dialog",
            Parent = DialogBg,
            BackgroundColor3 = theme.Background,
            BackgroundTransparency = theme.BackgroundTransparency,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 101,
            ClipsDescendants = true
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius + 4) }),
            Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1.5 }),
            Utility:Create("UIGradient", {
                Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
                Rotation = 135,
                Transparency = NumberSequence.new(0.2)
            })
        })
        
        local DialogTitle = Utility:Create("TextLabel", {
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 0, 20),
            Size = UDim2.new(1, -50, 0, 25),
            Font = currentFont,
            Text = title,
            TextColor3 = theme.Text,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 102
        })
        
        local DialogContent = Utility:Create("TextLabel", {
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 0, 50),
            Size = UDim2.new(1, -50, 0, 60),
            Font = currentFont,
            Text = content,
            TextColor3 = theme.TextDark,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            ZIndex = 102
        })
        
        local ButtonContainer = Utility:Create("Frame", {
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 1, -60),
            Size = UDim2.new(1, -50, 0, 38),
            ZIndex = 102
        }, {
            Utility:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 12)
            })
        })
        
        Utility:Tween(DialogBg, {BackgroundTransparency = 0.5}, Config.AnimationSpeed)
        Utility:Tween(DialogFrame, {Size = UDim2.new(0, 380, 0, 180)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        local function CloseDialog()
            Utility:Tween(DialogBg, {BackgroundTransparency = 1}, Config.AnimationSpeed)
            Utility:Tween(DialogFrame, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(Config.AnimationSpeed + 0.1)
            DialogBg:Destroy()
        end
        
        for _, btnInfo in pairs(buttons) do
            local btnText = btnInfo.Title or "Button"
            local btnCallback = btnInfo.Callback or function() end
            local isPrimary = btnInfo.Primary or false
            
            local DialogBtn = Utility:Create("TextButton", {
                Parent = ButtonContainer,
                BackgroundColor3 = isPrimary and theme.Accent or theme.Element,
                BackgroundTransparency = isPrimary and 0 or theme.ElementTransparency,
                Size = UDim2.new(0, 90, 0, 36),
                Font = currentFont,
                Text = btnText,
                TextColor3 = isPrimary and theme.Text or theme.TextDark,
                TextSize = 13,
                AutoButtonColor = false,
                ZIndex = 103
            }, {
                Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                Utility:Create("UIStroke", { Color = isPrimary and theme.Accent or theme.Border, Transparency = isPrimary and 0.3 or theme.BorderTransparency, Thickness = 1 })
            })
            
            DialogBtn.MouseEnter:Connect(function()
                Utility:Tween(DialogBtn, {BackgroundTransparency = 0, BackgroundColor3 = isPrimary and theme.AccentDark or theme.Accent, TextColor3 = theme.Text}, Config.AnimationSpeed * 0.5)
            end)
            
            DialogBtn.MouseLeave:Connect(function()
                Utility:Tween(DialogBtn, {
                    BackgroundColor3 = isPrimary and theme.Accent or theme.Element,
                    BackgroundTransparency = isPrimary and 0 or theme.ElementTransparency,
                    TextColor3 = isPrimary and theme.Text or theme.TextDark
                }, Config.AnimationSpeed * 0.5)
            end)
            
            DialogBtn.MouseButton1Click:Connect(function()
                btnCallback()
                CloseDialog()
            end)
        end
        
        DialogBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mPos = UserInputService:GetMouseLocation()
                local fPos = DialogFrame.AbsolutePosition
                local fSize = DialogFrame.AbsoluteSize
                if mPos.X < fPos.X or mPos.X > fPos.X + fSize.X or mPos.Y < fPos.Y or mPos.Y > fPos.Y + fSize.Y then
                    CloseDialog()
                end
            end
        end)
    end
    
    function Window:Destroy()
        for _, conn in pairs(Window.Connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        Utility:Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(Config.AnimationSpeed + 0.1)
        CleanupAllBlur()
        ScreenGui:Destroy()
    end
    
    function Window:Toggle(visible)
        if visible == nil then visible = not MainContainer.Visible end
        
        if visible then
            MainContainer.Visible = true
            MainContainer.Size = UDim2.new(0, 0, 0, 0)
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 500)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(Config.AnimationSpeed + 0.1)
            MainContainer.Visible = false
        end
    end
    
    function Window:GetTheme() return Window.ThemeName end
    function Window:SetTheme(name) ApplyTheme(name, true) end
    function Window:GetThemes()
        local list = {}
        for n, _ in pairs(Themes) do table.insert(list, n) end
        return list
    end
    
    function Window:SetFont(fontName)
        if typeof(fontName) == "EnumItem" and fontName.EnumType == Enum.Font then
            Window.CustomFont = fontName
            SaveConfig()
            for _, ref in pairs(Window.ElementRefs) do
                if ref.Label then
                    ref.Label.Font = fontName
                end
                if ref.Text then
                    ref.Text.Font = fontName
                end
                if ref.Title then
                    ref.Title.Font = fontName
                end
                if ref.Content then
                    ref.Content.Font = fontName
                end
            end
            TitleLabel.Font = fontName
            SubtitleLabel.Font = fontName
            PlayerDisplayName.Font = fontName
            PlayerUsername.Font = fontName
            for _, tab in pairs(Window.Tabs) do
                tab.Label.Font = fontName
                if tab.IconLabel then
                    tab.IconLabel.Font = fontName
                end
            end
        end
    end
    
    Window.CreateLoadingDots = function(parent) return createLoadingDots(parent, Window.Theme) end
    Window.CreateSpinner = function(parent, size, color, speed) return createSpinner(parent, size, color, speed) end
    Window.CreateProgressBar = function(parent, width, height) return createProgressBar(parent, width, height, Window.Theme) end
    Window.CreatePulseEffect = createPulseEffect
    
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    local toggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then Window:Toggle() end
    end)
    table.insert(Window.Connections, toggleConn)
    
    return Window
end

function AxionLibrary:GetThemes()
    local list = {}
    for n, _ in pairs(Themes) do table.insert(list, n) end
    return list
end

function AxionLibrary:AddTheme(name, data)
    Themes[name] = data
end

function AxionLibrary:IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

return AxionLibrary
