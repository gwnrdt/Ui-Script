-- GUI Library
local GuiLibrary = {}
GuiLibrary.__index = GuiLibrary

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- Player
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Premium Status
local IsPremium = false
local PremiumThemeColor = Color3.fromRGB(255, 215, 0) -- Gold color for premium

-- Color Theme (Voidware Inspired - Transparent/Dark)
local Theme = {
    Background = Color3.fromRGB(10, 10, 15),
    Secondary = Color3.fromRGB(20, 20, 30),
    Accent = Color3.fromRGB(0, 150, 255),
    AccentHover = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    Success = Color3.fromRGB(0, 200, 100),
    Danger = Color3.fromRGB(220, 80, 80),
    Premium = PremiumThemeColor,
    Disabled = Color3.fromRGB(80, 80, 80)
}

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidwareGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Check if mobile
local isMobile = UserInputService.TouchEnabled

-- Size and font adjustments
local MOBILE_SETTINGS = {
    MainFrameSize = UDim2.new(0, 320, 0, 400),
    MainFramePosition = UDim2.new(0.5, 0, 0.5, 0),
    IconSize = UDim2.new(0, 40, 0, 40),
    FontSize = 10,
    TitleFontSize = 14
}

local DESKTOP_SETTINGS = {
    MainFrameSize = UDim2.new(0, 400, 0, 500),
    MainFramePosition = UDim2.new(0, 10, 0, 10),
    IconSize = UDim2.new(0, 40, 0, 40),
    FontSize = 11,
    TitleFontSize = 15
}

local settings = isMobile and MOBILE_SETTINGS or DESKTOP_SETTINGS

-- Main Container (Transparent Background)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = settings.MainFrameSize
mainFrame.Position = settings.MainFramePosition
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BackgroundTransparency = 0.2  -- Semi-transparent
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

if isMobile then
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

-- Corner with smaller radius for Voidware style
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = mainFrame

-- Shadow with more subtle effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.9
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Title Bar (Voidware Style - Minimal)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Theme.Secondary
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Voidware"
title.TextColor3 = Theme.Text
title.TextSize = settings.TitleFontSize
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.Parent = titleBar

-- Premium Badge in Title
local premiumBadge = Instance.new("Frame")
premiumBadge.Name = "PremiumBadge"
premiumBadge.Size = UDim2.new(0, 70, 0, 16)
premiumBadge.Position = UDim2.new(0.5, -35, 0.5, -8)
premiumBadge.BackgroundColor3 = Theme.Premium
premiumBadge.BackgroundTransparency = 0.3
premiumBadge.BorderSizePixel = 0
premiumBadge.Visible = false
premiumBadge.Parent = titleBar

local premiumCorner = Instance.new("UICorner")
premiumCorner.CornerRadius = UDim.new(0, 8)
premiumCorner.Parent = premiumBadge

local premiumText = Instance.new("TextLabel")
premiumText.Name = "PremiumText"
premiumText.Size = UDim2.new(1, 0, 1, 0)
premiumText.BackgroundTransparency = 1
premiumText.Text = "PREMIUM"
premiumText.TextColor3 = Color3.fromRGB(255, 255, 255)
premiumText.TextSize = 9
premiumText.Font = Enum.Font.GothamBold
premiumText.Parent = premiumBadge

-- Close Button (Smaller, Minimal)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0.5, -12.5)
closeButton.BackgroundColor3 = Theme.Danger
closeButton.BackgroundTransparency = 0.2
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Theme.Text
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0.5, -12.5)
minimizeButton.BackgroundColor3 = Theme.Accent
minimizeButton.BackgroundTransparency = 0.2
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Theme.Text
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 4)
minimizeCorner.Parent = minimizeButton

-- Content Area (More Transparent)
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, 0, 1, -30)
contentArea.Position = UDim2.new(0, 0, 0, 30)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Tab Container (Left Side - Voidware Style)
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, 100, 1, 0)
tabContainer.Position = UDim2.new(0, 0, 0, 0)
tabContainer.BackgroundColor3 = Theme.Secondary
tabContainer.BackgroundTransparency = 0.3
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 3
tabContainer.ScrollBarImageColor3 = Theme.Accent
tabContainer.ScrollBarImageTransparency = 0.5
tabContainer.Parent = contentArea

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 3)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 8)
tabPadding.PaddingLeft = UDim.new(0, 5)
tabPadding.PaddingRight = UDim.new(0, 5)
tabPadding.Parent = tabContainer

-- Tab Content
local tabContent = Instance.new("ScrollingFrame")
tabContent.Name = "TabContent"
tabContent.Size = UDim2.new(1, -105, 1, 0)
tabContent.Position = UDim2.new(0, 105, 0, 0)
tabContent.BackgroundTransparency = 1
tabContent.ScrollBarThickness = 3
tabContent.ScrollBarImageColor3 = Theme.Accent
tabContent.ScrollBarImageTransparency = 0.5
tabContent.ClipsDescendants = true
tabContent.Parent = contentArea

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = tabContent

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 8)
contentPadding.PaddingLeft = UDim.new(0, 8)
contentPadding.PaddingRight = UDim.new(0, 8)
contentPadding.Parent = tabContent

-- Minimized Icon (Voidware Style)
local minimizedIcon = Instance.new("TextButton")
minimizedIcon.Name = "MinimizedIcon"
minimizedIcon.Size = settings.IconSize
minimizedIcon.Position = UDim2.new(0, 10, 0, 10)
minimizedIcon.BackgroundColor3 = Theme.Accent
minimizedIcon.BackgroundTransparency = 0.2
minimizedIcon.BorderSizePixel = 0
minimizedIcon.Text = "VW"
minimizedIcon.TextColor3 = Theme.Text
minimizedIcon.TextSize = 10
minimizedIcon.TextScaled = true
minimizedIcon.Visible = false
minimizedIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 6)
iconCorner.Parent = minimizedIcon

local iconShadow = Instance.new("ImageLabel")
iconShadow.Name = "Shadow"
iconShadow.Size = UDim2.new(1, 10, 1, 10)
iconShadow.Position = UDim2.new(0, -5, 0, -5)
iconShadow.BackgroundTransparency = 1
iconShadow.Image = "rbxassetid://1316045217"
iconShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
iconShadow.ImageTransparency = 0.9
iconShadow.ScaleType = Enum.ScaleType.Slice
iconShadow.SliceCenter = Rect.new(10, 10, 118, 118)
iconShadow.Parent = minimizedIcon

-- Variables
local isMinimized = false
local currentTab = nil
local tabs = {}
local buttons = {}
local isDestroyed = false
local premiumLockedElements = {}

-- Make frames draggable
local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    if isDestroyed then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function updateIconInput(input)
    if isDestroyed then return end
    local delta = input.Position - dragStart
    minimizedIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- Main frame dragging
titleBar.InputBegan:Connect(function(input)
    if isDestroyed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if isDestroyed then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Icon dragging
minimizedIcon.InputBegan:Connect(function(input)
    if isDestroyed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = minimizedIcon.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

minimizedIcon.InputChanged:Connect(function(input)
    if isDestroyed then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDestroyed then return end
    if input == dragInput and dragging then
        if isMinimized then
            updateIconInput(input)
        else
            updateInput(input)
        end
    end
end)

-- Toggle minimize
local function toggleMinimize()
    if isDestroyed then return end
    if isMinimized then
        -- Expand
        mainFrame.Visible = true
        minimizedIcon.Visible = false
        isMinimized = false
    else
        -- Minimize
        mainFrame.Visible = false
        minimizedIcon.Visible = true
        isMinimized = true
    end
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)
minimizedIcon.MouseButton1Click:Connect(toggleMinimize)

-- Close function
local function closeGUI()
    if isDestroyed then return end
    isDestroyed = true
    
    -- Destroy all GUI elements
    screenGui:Destroy()
    
    -- Disconnect any running connections
    for _, button in pairs(buttons) do
        if button.Connection then
            button.Connection:Disconnect()
        end
    end
end

closeButton.MouseButton1Click:Connect(closeGUI)

-- Update scrolling frames
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    if isDestroyed then return end
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 16)
end)

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    if isDestroyed then return end
    tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
end)

-- Library Functions
function GuiLibrary.new(name)
    local self = setmetatable({}, GuiLibrary)
    
    title.Text = name or "Voidware"
    minimizedIcon.Text = name and string.sub(name, 1, 2) or "VW"
    
    return self
end

-- Set Premium Status
function GuiLibrary:SetPremiumStatus(isPremium)
    IsPremium = isPremium
    
    -- Update UI based on premium status
    if IsPremium then
        -- Change theme to premium colors
        Theme.Accent = Theme.Premium
        Theme.AccentHover = Color3.fromRGB(255, 225, 100)
        
        -- Show premium badge
        premiumBadge.Visible = true
        
        -- Update existing UI elements
        minimizeButton.BackgroundColor3 = Theme.Premium
        title.TextColor3 = Theme.Premium
        
        -- Unlock all premium locked elements
        for elementId, elementData in pairs(premiumLockedElements) do
            if elementData.Overlay then
                elementData.Overlay:Destroy()
            end
            if elementData.Badge then
                elementData.Badge:Destroy()
            end
            -- Re-enable the element
            if elementData.Element:IsA("TextButton") or elementData.Element:IsA("TextBox") then
                elementData.Element.Active = true
                elementData.Element.TextColor3 = Theme.Text
                elementData.Element.BackgroundColor3 = Theme.Secondary
            end
        end
        
        -- Clear premium locked elements
        premiumLockedElements = {}
        
        print("🎉 Premium features unlocked!")
    else
        -- Reset to free theme
        Theme.Accent = Color3.fromRGB(0, 150, 255)
        Theme.AccentHover = Color3.fromRGB(0, 170, 255)
        
        -- Hide premium badge
        premiumBadge.Visible = false
        
        -- Reset UI elements
        minimizeButton.BackgroundColor3 = Theme.Accent
        title.TextColor3 = Theme.Text
        
        print("🔓 Free version - Some features are locked")
    end
end
-- Mark Element as Premium (FIXED VERSION)
function GuiLibrary:MarkAsPremium(guiElement, customMessage)
    if IsPremium then return end -- Don't mark if already premium
    
    local elementId = tostring(guiElement) .. "_" .. tick()
    local message = customMessage or "PREMIUM"
    
    -- Create overlay
    local overlay = Instance.new("Frame")
    overlay.Name = "PremiumOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Theme.Disabled
    overlay.BackgroundTransparency = 0.7
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 10
    overlay.Parent = guiElement
    
    local overlayCorner = Instance.new("UICorner")
    if guiElement:FindFirstChildOfClass("UICorner") then
        overlayCorner.CornerRadius = guiElement:FindFirstChildOfClass("UICorner").CornerRadius
    else
        overlayCorner.CornerRadius = UDim.new(0, 4)
    end
    overlayCorner.Parent = overlay
    
    -- Create premium badge
    local badge = Instance.new("Frame")
    badge.Name = "PremiumLockBadge"
    badge.Size = UDim2.new(0, 60, 0, 16)
    badge.Position = UDim2.new(0.5, -30, 0.5, -8)
    badge.BackgroundColor3 = Theme.Premium
    badge.BackgroundTransparency = 0.2
    badge.BorderSizePixel = 0
    badge.ZIndex = 11
    badge.Parent = overlay
    
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 8)
    badgeCorner.Parent = badge
    
    local badgeText = Instance.new("TextLabel")
    badgeText.Name = "BadgeText"
    badgeText.Size = UDim2.new(1, 0, 1, 0)
    badgeText.BackgroundTransparency = 1
    badgeText.Text = message
    badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    badgeText.TextSize = 9
    badgeText.Font = Enum.Font.GothamBold
    badgeText.ZIndex = 12
    badgeText.Parent = badge
    
    -- Disable the element (only for interactive elements)
    if guiElement:IsA("TextButton") or guiElement:IsA("TextBox") then
        guiElement.Active = false
        guiElement.TextColor3 = Theme.Disabled
        guiElement.BackgroundColor3 = Theme.Disabled
    elseif guiElement:IsA("Frame") then
        -- For frames, we only disable interaction by setting Active = false on child interactive elements
        -- We don't change TextColor3 since Frames don't have that property
        guiElement.Active = false
    end
    
    -- Store element data
    premiumLockedElements[elementId] = {
        Element = guiElement,
        Overlay = overlay,
        Badge = badge,
        OriginalProperties = {
            Active = guiElement.Active,
            BackgroundColor3 = guiElement.BackgroundColor3
        }
    }
    
    -- Only store TextColor3 for elements that have it
    if guiElement:IsA("TextButton") or guiElement:IsA("TextBox") then
        premiumLockedElements[elementId].OriginalProperties.TextColor3 = guiElement.TextColor3
    end
    
    -- Create unlock button functionality
    local unlockButton = Instance.new("TextButton")
    unlockButton.Name = "UnlockPremiumButton"
    unlockButton.Size = UDim2.new(1, 0, 1, 0)
    unlockButton.BackgroundTransparency = 1
    unlockButton.Text = ""
    unlockButton.ZIndex = 13
    unlockButton.Parent = overlay
    
    unlockButton.MouseButton1Click:Connect(function()
        self:ShowPremiumPrompt()
    end)
    
    return {
        Unlock = function()
            if overlay then overlay:Destroy() end
            if badge then badge:Destroy() end
            if unlockButton then unlockButton:Destroy() end
            
            -- Restore original properties
            local original = premiumLockedElements[elementId].OriginalProperties
            guiElement.Active = original.Active
            guiElement.BackgroundColor3 = original.BackgroundColor3
            
            -- Only restore TextColor3 for elements that have it
            if (guiElement:IsA("TextButton") or guiElement:IsA("TextBox")) and original.TextColor3 then
                guiElement.TextColor3 = original.TextColor3
            end
            
            premiumLockedElements[elementId] = nil
        end,
        
        UpdateMessage = function(newMessage)
            if badgeText then
                badgeText.Text = newMessage or message
            end
        end
    }
end

-- Show Premium Prompt
function GuiLibrary:ShowPremiumPrompt()
    local promptGui = Instance.new("ScreenGui")
    promptGui.Name = "PremiumPrompt"
    promptGui.ResetOnSpawn = false
    promptGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    promptGui.Parent = playerGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.BorderSizePixel = 0
    background.ZIndex = 100
    background.Parent = promptGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 101
    mainFrame.Parent = promptGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 15, 1, 15)
    shadow.Position = UDim2.new(0, -7.5, 0, -7.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.9
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = 100
    shadow.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🌟 PREMIUM FEATURE"
    title.TextColor3 = Theme.Premium
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 102
    title.Parent = mainFrame
    
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -40, 0, 60)
    message.Position = UDim2.new(0, 20, 0, 50)
    message.BackgroundTransparency = 1
    message.Text = "This feature is only available in the Premium version.\n\nUpgrade to unlock all features and support development!"
    message.TextColor3 = Theme.Text
    message.TextSize = 12
    message.Font = Enum.Font.Gotham
    message.TextWrapped = true
    message.ZIndex = 102
    message.Parent = mainFrame
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -40, 0, 40)
    buttonContainer.Position = UDim2.new(0, 20, 1, -60)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.ZIndex = 102
    buttonContainer.Parent = mainFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.4, 0, 1, 0)
    closeButton.Position = UDim2.new(0.6, 10, 0, 0)
    closeButton.BackgroundColor3 = Theme.Secondary
    closeButton.BackgroundTransparency = 0.3
    closeButton.BorderSizePixel = 0
    closeButton.Text = "CLOSE"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 12
    closeButton.Font = Enum.Font.GothamBold
    closeButton.ZIndex = 103
    closeButton.Parent = buttonContainer
    
    local getPremiumButton = Instance.new("TextButton")
    getPremiumButton.Size = UDim2.new(0.4, 0, 1, 0)
    getPremiumButton.Position = UDim2.new(0, 0, 0, 0)
    getPremiumButton.BackgroundColor3 = Theme.Premium
    getPremiumButton.BackgroundTransparency = 0.2
    getPremiumButton.BorderSizePixel = 0
    getPremiumButton.Text = "GET PREMIUM"
    getPremiumButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getPremiumButton.TextSize = 12
    getPremiumButton.Font = Enum.Font.GothamBold
    getPremiumButton.ZIndex = 103
    getPremiumButton.Parent = buttonContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    local premiumCorner = Instance.new("UICorner")
    premiumCorner.CornerRadius = UDim.new(0, 6)
    premiumCorner.Parent = getPremiumButton
    
    -- Button functions
    closeButton.MouseButton1Click:Connect(function()
        promptGui:Destroy()
    end)
    
    getPremiumButton.MouseButton1Click:Connect(function()
        -- Here you can add your premium purchase logic
        -- For example: open a website, show Discord link, etc.
        self:CopyToClipboard("https://discord.gg/your-premium-link")
        self:ShowNotification("Premium link copied to clipboard!", 3)
        promptGui:Destroy()
    end)
    
    -- Auto close after 10 seconds
    delay(10, function()
        if promptGui and promptGui.Parent then
            promptGui:Destroy()
        end
    end)
end

-- Copy to clipboard function
function GuiLibrary:CopyToClipboard(text)
    local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if clipBoard then
        clipBoard(text)
        return true
    else
        warn("Clipboard function not available")
        return false
    end
end

-- Notification function
function GuiLibrary:ShowNotification(message, duration)
    duration = duration or 3
    
    local notification = Instance.new("ScreenGui")
    notification.Name = "Notification"
    notification.ResetOnSpawn = false
    notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notification.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    frame.BackgroundColor3 = Theme.Background
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.9
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -10)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = frame
    
    -- Animate in
    frame.Position = UDim2.new(0.5, -150, 0, -60)
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0.1, 0)}):Play()
    
    -- Auto-remove
    delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- Create Tab (Voidware Style)
function GuiLibrary:CreateTab(tabName, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName
    tabButton.Size = UDim2.new(1, 0, 0, 32)
    tabButton.BackgroundColor3 = Theme.Secondary
    tabButton.BackgroundTransparency = 0.5
    tabButton.BorderSizePixel = 0
    tabButton.Text = tabName
    tabButton.TextColor3 = Theme.TextSecondary
    tabButton.TextSize = 12
    tabButton.Font = Enum.Font.Gotham
    tabButton.LayoutOrder = #tabs
    tabButton.Parent = tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tabButton
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tabName
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.Position = UDim2.new(0, 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = tabContent
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabFrame
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.Parent = tabFrame
    
    local tabData = {
        Button = tabButton,
        Frame = tabFrame,
        Name = tabName
    }
    
    table.insert(tabs, tabData)
    
    -- Set as current tab if first tab
    if #tabs == 1 then
        currentTab = tabData
        tabButton.BackgroundColor3 = Theme.Accent
        tabButton.BackgroundTransparency = 0.3
        tabButton.TextColor3 = Theme.Text
        tabFrame.Visible = true
    end
    
    -- Tab button click event
    tabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Button.BackgroundColor3 = Theme.Secondary
            currentTab.Button.BackgroundTransparency = 0.5
            currentTab.Button.TextColor3 = Theme.TextSecondary
            currentTab.Frame.Visible = false
        end
        
        currentTab = tabData
        tabButton.BackgroundColor3 = Theme.Accent
        tabButton.BackgroundTransparency = 0.3
        tabButton.TextColor3 = Theme.Text
        tabFrame.Visible = true
    end)
    
    return tabData
end

-- Create Button (Voidware Style) with Premium Support
function GuiLibrary:CreateButton(tab, buttonName, callback, isPremium)
    local button = Instance.new("TextButton")
    button.Name = buttonName
    button.Size = UDim2.new(1, 0, 0, 32)
    button.BackgroundColor3 = Theme.Secondary
    button.BackgroundTransparency = 0.4
    button.BorderSizePixel = 0
    button.Text = buttonName
    button.TextColor3 = Theme.Text
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Parent = tab.Frame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(button, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
    end
    
    -- Button effects
    button.MouseEnter:Connect(function()
        if not isMobile and (not isPremium or IsPremium) then
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isMobile and (not isPremium or IsPremium) then
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
        end
    end)
    
    button.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then
            return -- Don't execute for premium locked buttons
        end
        
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
        
        if callback then
            callback()
        end
    end)
    
    table.insert(buttons, button)
    
    local buttonObj = {
        Instance = button,
        PremiumLock = premiumLock
    }
    
    function buttonObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(button, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end
    
    return buttonObj
end

-- Create Toggle (Voidware Style) with Premium Support
function GuiLibrary:CreateToggle(tab, toggleName, defaultState, callback, isPremium)
    local toggle = Instance.new("TextButton")
    toggle.Name = toggleName
    toggle.Size = UDim2.new(1, 0, 0, 32)
    toggle.BackgroundColor3 = Theme.Secondary
    toggle.BackgroundTransparency = 0.4
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = tab.Frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = toggleName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = toggle
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle"
    toggleFrame.Size = UDim2.new(0, 40, 0, 20)
    toggleFrame.Position = UDim2.new(1, -45, 0.5, -10)
    toggleFrame.BackgroundColor3 = Theme.Secondary
    toggleFrame.BackgroundTransparency = 0.3
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = toggle
    
    local toggleCorner2 = Instance.new("UICorner")
    toggleCorner2.CornerRadius = UDim.new(0, 10)
    toggleCorner2.Parent = toggleFrame
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Name = "Dot"
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.Position = UDim2.new(0, 2, 0, 2)
    toggleDot.BackgroundColor3 = Theme.Text
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleFrame
    
    local toggleCorner3 = Instance.new("UICorner")
    toggleCorner3.CornerRadius = UDim.new(1, 0)
    toggleCorner3.Parent = toggleDot
    
    local state = defaultState or false
    
    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(toggle, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
    end
    
    local function updateToggle()
        if state then
            TweenService:Create(toggleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Success}):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.1), {Position = UDim2.new(0, 22, 0, 2)}):Play()
        else
            TweenService:Create(toggleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Secondary}):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.1), {Position = UDim2.new(0, 2, 0, 2)}):Play()
        end
        
        if callback then
            callback(state)
        end
    end
    
    updateToggle()
    
    toggle.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then
            return -- Don't execute for premium locked toggles
        end
        
        state = not state
        updateToggle()
    end)
    
    local toggleObj = {
        Instance = toggle,
        GetState = function() return state end,
        SetState = function(newState) 
            if isPremium and not IsPremium then return end
            state = newState
            updateToggle()
        end,
        PremiumLock = premiumLock
    }
    
    function toggleObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(toggle, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end
    
    return toggleObj
end

-- Create Label (Voidware Style)
function GuiLibrary:CreateLabel(tab, labelText)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 22)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Theme.TextSecondary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = tab.Frame
    
    return label
end

-- Create Separator (Voidware Style - Improved)
function GuiLibrary:CreateSeparator(tab, separatorName)
    local separator = Instance.new("Frame")
    separator.Name = "Separator_" .. (separatorName or "Separator")
    separator.Size = UDim2.new(1, 0, 0, 28)
    separator.BackgroundTransparency = 1
    separator.Parent = tab.Frame
    
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.Size = UDim2.new(1, -20, 0, 2) -- Thicker line
    line.Position = UDim2.new(0, 10, 0.5, 0)
    line.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Dark gray for contrast
    line.BorderSizePixel = 0
    line.Parent = separator
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 0, 0, 20) -- Auto-size width
    label.Position = UDim2.new(0, 10, 0.5, 0) -- Changed to left position
    label.AnchorPoint = Vector2.new(0, 0.5) -- Changed anchor to left
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background
    label.BackgroundTransparency = 0
    label.BorderSizePixel = 0
    label.Text = (separatorName or "Separator")-- Bold format with brackets
    label.TextColor3 = Color3.fromRGB(255, 255, 255) -- Bright white text
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold -- Bold font
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Black outline
    label.TextStrokeTransparency = 0.3 -- Slight outline for readability
    label.TextXAlignment = Enum.TextXAlignment.Left -- Left align text
    label.Parent = separator
    
    -- Auto-size the label to fit text
    local textSize = game:GetService("TextService"):GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(1000, 20))
    label.Size = UDim2.new(0, textSize.X + 20, 0, 20)
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 6)
    labelCorner.Parent = label
    
    return separator
end
-- Create Dropdown (Voidware Style) with Premium Support
function GuiLibrary:CreateDropdown(tab, dropdownName, options, defaultSelection, callback, isPremium)
    local dropdown = Instance.new("TextButton")
    dropdown.Name = "Dropdown_" .. dropdownName
    dropdown.Size = UDim2.new(1, 0, 0, 32)
    dropdown.BackgroundColor3 = Theme.Secondary
    dropdown.BackgroundTransparency = 0.4
    dropdown.BorderSizePixel = 0
    dropdown.Text = ""
    dropdown.ZIndex = 5
    dropdown.Parent = tab.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = dropdown

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = dropdownName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.ZIndex = 6
    label.Parent = dropdown

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.25, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = defaultSelection or "Select..."
    valueLabel.TextColor3 = Theme.TextSecondary
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.ZIndex = 6
    valueLabel.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -20, 0.5, -8)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.TextSecondary
    arrow.TextSize = 10
    arrow.Font = Enum.Font.Gotham
    arrow.ZIndex = 6
    arrow.Parent = dropdown

    -- Options Frame
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Name = "Options"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 3)
    optionsFrame.BackgroundColor3 = Theme.Secondary
    optionsFrame.BackgroundTransparency = 0.2
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ScrollBarThickness = 3
    optionsFrame.ScrollBarImageColor3 = Theme.Accent
    optionsFrame.ScrollBarImageTransparency = 0.5
    optionsFrame.Visible = false
    optionsFrame.ClipsDescendants = true
    optionsFrame.ZIndex = 20
    optionsFrame.Parent = dropdown

    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 4)
    optionsCorner.Parent = optionsFrame

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame

    local optionsPadding = Instance.new("UIPadding")
    optionsPadding.PaddingTop = UDim.new(0, 4)
    optionsPadding.PaddingBottom = UDim.new(0, 4)
    optionsPadding.PaddingLeft = UDim.new(0, 4)
    optionsPadding.PaddingRight = UDim.new(0, 4)
    optionsPadding.Parent = optionsFrame

    local isOpen = false
    local selectedOption = defaultSelection

    if defaultSelection and not table.find(options, defaultSelection) then
        selectedOption = nil
        valueLabel.Text = "Select..."
    end

    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(dropdown, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
    end

    -- Create options
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Size = UDim2.new(1, 0, 0, 22)
        optionButton.BackgroundColor3 = Theme.Secondary
        optionButton.BackgroundTransparency = 0.4
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Theme.TextSecondary
        optionButton.TextSize = 11
        optionButton.Font = Enum.Font.Gotham
        optionButton.LayoutOrder = i
        optionButton.ZIndex = 21
        optionButton.Parent = optionsFrame

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 3)
        optionCorner.Parent = optionButton

        if option == selectedOption then
            optionButton.BackgroundColor3 = Theme.Accent
            optionButton.BackgroundTransparency = 0.3
            optionButton.TextColor3 = Theme.Text
        end

        optionButton.MouseButton1Click:Connect(function()
            if isPremium and not IsPremium then return end
            
            selectedOption = option
            valueLabel.Text = option
            
            for _, btn in pairs(optionsFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    if btn.Name == option then
                        btn.BackgroundColor3 = Theme.Accent
                        btn.BackgroundTransparency = 0.3
                        btn.TextColor3 = Theme.Text
                    else
                        btn.BackgroundColor3 = Theme.Secondary
                        btn.BackgroundTransparency = 0.4
                        btn.TextColor3 = Theme.TextSecondary
                    end
                end
            end
            
            isOpen = false
            optionsFrame.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            
            if callback then
                callback(option)
            end
        end)
    end

    -- Update canvas size
    optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y + 8)
    end)

    -- Toggle dropdown
    dropdown.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end
        
        isOpen = not isOpen
        
        if isOpen then
            optionsFrame.Visible = true
            local height = math.min(#options * 24 + 8, 150)
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, height)}):Play()
            
            dropdown.ZIndex = 25
            optionsFrame.ZIndex = 26
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("GuiObject") then
                    child.ZIndex = 27
                end
            end
        else
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            optionsFrame.Visible = false
            
            dropdown.ZIndex = 5
            optionsFrame.ZIndex = 20
        end
    end)

    -- Close dropdown
    local function closeDropdown(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local dropdownAbsPos = dropdown.AbsolutePosition
            local dropdownSize = dropdown.AbsoluteSize
            local optionsAbsPos = optionsFrame.AbsolutePosition
            local optionsSize = optionsFrame.AbsoluteSize
            
            local isInsideDropdown = (mousePos.X >= dropdownAbsPos.X and mousePos.X <= dropdownAbsPos.X + dropdownSize.X and
                                    mousePos.Y >= dropdownAbsPos.Y and mousePos.Y <= dropdownAbsPos.Y + dropdownSize.Y)
            
            local isInsideOptions = (mousePos.X >= optionsAbsPos.X and mousePos.X <= optionsAbsPos.X + optionsSize.X and
                                   mousePos.Y >= optionsAbsPos.Y and mousePos.Y <= optionsAbsPos.Y + optionsSize.Y)
            
            if not isInsideDropdown and not isInsideOptions then
                isOpen = false
                TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                wait(0.2)
                optionsFrame.Visible = false
                
                dropdown.ZIndex = 5
                optionsFrame.ZIndex = 20
            end
        end
    end

    UserInputService.InputBegan:Connect(closeDropdown)

    -- Create dropdown object with methods
    local dropdownObj = {
        Instance = dropdown,
        PremiumLock = premiumLock
    }

    function dropdownObj:GetSelection()
        return selectedOption
    end

    function dropdownObj:SetSelection(selection)
        if isPremium and not IsPremium then return end
        
        if selection and table.find(options, selection) then
            selectedOption = selection
            valueLabel.Text = selection
            
            for _, btn in pairs(optionsFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    if btn.Name == selection then
                        btn.BackgroundColor3 = Theme.Accent
                        btn.BackgroundTransparency = 0.3
                        btn.TextColor3 = Theme.Text
                    else
                        btn.BackgroundColor3 = Theme.Secondary
                        btn.BackgroundTransparency = 0.4
                        btn.TextColor3 = Theme.TextSecondary
                    end
                end
            end
            
            if callback then
                callback(selection)
            end
        else
            selectedOption = nil
            valueLabel.Text = "Select..."
            
            for _, btn in pairs(optionsFrame:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Theme.Secondary
                    btn.BackgroundTransparency = 0.4
                    btn.TextColor3 = Theme.TextSecondary
                end
            end
        end
    end

    function dropdownObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(dropdown, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end

    return dropdownObj
end
-- Create Slider (Voidware Style) with Premium Support
function GuiLibrary:CreateSlider(tab, sliderName, minValue, maxValue, defaultValue, callback, isPremium)
    local slider = Instance.new("Frame")
    slider.Name = sliderName
    slider.Size = UDim2.new(1, 0, 0, 55)
    slider.BackgroundTransparency = 1
    slider.Parent = tab.Frame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = sliderName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = slider

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 60, 0, 18)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue or minValue)
    valueLabel.TextColor3 = Theme.TextSecondary
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = slider

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, 0, 0, 6)
    sliderTrack.Position = UDim2.new(0, 0, 0, 30)
    sliderTrack.BackgroundColor3 = Theme.Secondary
    sliderTrack.BackgroundTransparency = 0.4
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = slider

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = sliderTrack

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BackgroundTransparency = 0.3
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill

    local sliderThumb = Instance.new("TextButton")
    sliderThumb.Name = "Thumb"
    sliderThumb.Size = UDim2.new(0, 16, 0, 16)
    sliderThumb.Position = UDim2.new(0, -8, 0.5, -8)
    sliderThumb.BackgroundColor3 = Theme.Text
    sliderThumb.BorderSizePixel = 0
    sliderThumb.Text = ""
    sliderThumb.Parent = sliderTrack

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = sliderThumb

    local currentValue = defaultValue or minValue
    local isDragging = false

    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(slider, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
        
        -- Also disable the thumb button specifically
        sliderThumb.Active = false
        sliderTrack.Active = false
    end

    local function updateSlider(value, triggerCallback)
        if isPremium and not IsPremium then 
            -- Keep the visual state but don't execute callback
            currentValue = math.clamp(value, minValue, maxValue)
            local percentage = (currentValue - minValue) / (maxValue - minValue)
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderThumb.Position = UDim2.new(percentage, -8, 0.5, -8)
            valueLabel.Text = tostring(math.floor(currentValue))
            return 
        end
        
        currentValue = math.clamp(value, minValue, maxValue)
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderThumb.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(math.floor(currentValue))
        
        if triggerCallback and callback then
            callback(currentValue)
        end
    end

    updateSlider(currentValue, false)

    local function onInputChanged(input)
        if isDragging and (not isPremium or IsPremium) then
            local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
            local value = minValue + (relativeX * (maxValue - minValue))
            updateSlider(value, true)
        end
    end

    sliderThumb.InputBegan:Connect(function(input)
        if isPremium and not IsPremium then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
        end
    end)

    sliderThumb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    sliderTrack.InputBegan:Connect(function(input)
        if isPremium and not IsPremium then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
            local value = minValue + (relativeX * (maxValue - minValue))
            updateSlider(value, true)
        end
    end)

    sliderTrack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            onInputChanged(input)
        end
    end)

    local sliderObj = {
        Instance = slider,
        PremiumLock = premiumLock
    }

    function sliderObj:GetValue()
        return currentValue
    end

    function sliderObj:SetValue(value)
        if isPremium and not IsPremium then 
            -- Allow visual update but no callback
            updateSlider(value, false)
            return 
        end
        updateSlider(value, true)
    end

    function sliderObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(slider, "PREMIUM")
                -- Disable interaction
                sliderThumb.Active = false
                sliderTrack.Active = false
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
            -- Re-enable interaction
            sliderThumb.Active = true
            sliderTrack.Active = true
        end
    end

    return sliderObj
end


-- Input Text Field (Voidware Style) with Premium Support
function GuiLibrary:CreateInput(tab, inputName, placeholder, defaultValue, callback, isPremium)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "Input_" .. inputName
    inputFrame.Size = UDim2.new(1, 0, 0, 32)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = tab.Frame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = inputName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = inputFrame

    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(0.6, 0, 1, 0)
    textBox.Position = UDim2.new(0.4, 0, 0, 0)
    textBox.BackgroundColor3 = Theme.Secondary
    textBox.BackgroundTransparency = 0.4
    textBox.BorderSizePixel = 0
    textBox.Text = defaultValue or ""
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.TextColor3 = Theme.Text
    textBox.PlaceholderColor3 = Theme.TextSecondary
    textBox.TextSize = 11
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputFrame

    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 4)
    textBoxCorner.Parent = textBox

    local textBoxPadding = Instance.new("UIPadding")
    textBoxPadding.PaddingLeft = UDim.new(0, 8)
    textBoxPadding.PaddingRight = UDim.new(0, 8)
    textBoxPadding.Parent = textBox

    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(inputFrame, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
    end

    -- TextBox effects
    textBox.Focused:Connect(function()
        if isPremium and not IsPremium then return end
        TweenService:Create(textBox, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if isPremium and not IsPremium then return end
        TweenService:Create(textBox, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
        
        if callback then
            callback(textBox.Text, enterPressed)
        end
    end)

    -- Create input object with methods
    local inputObj = {
        Instance = inputFrame,
        PremiumLock = premiumLock
    }

    function inputObj:GetValue()
        return textBox.Text
    end

    function inputObj:SetValue(value)
        if isPremium and not IsPremium then return end
        textBox.Text = value or ""
    end

    function inputObj:SetPlaceholder(text)
        textBox.PlaceholderText = text or ""
    end

    function inputObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(inputFrame, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end

    return inputObj
end


-- Multi Dropdown Function (Voidware Style) with Premium Support
function GuiLibrary:CreateMultiDropdown(tab, dropdownName, options, defaultSelections, callback, isPremium)
    local uniqueName = "MultiDropdown_" .. dropdownName .. "_" .. tostring(tick()):gsub("%.", "")
    
    local multiDropdown = Instance.new("TextButton")
    multiDropdown.Name = uniqueName
    multiDropdown.Size = UDim2.new(1, 0, 0, 32)
    multiDropdown.BackgroundColor3 = Theme.Secondary
    multiDropdown.BackgroundTransparency = 0.4
    multiDropdown.BorderSizePixel = 0
    multiDropdown.Text = ""
    multiDropdown.ZIndex = 20
    multiDropdown.Parent = tab.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = multiDropdown

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = dropdownName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.ZIndex = 21
    label.Parent = multiDropdown

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.25, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = "Select..."
    valueLabel.TextColor3 = Theme.TextSecondary
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.ZIndex = 21
    valueLabel.Parent = multiDropdown

    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -20, 0.5, -8)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.TextSecondary
    arrow.TextSize = 10
    arrow.Font = Enum.Font.Gotham
    arrow.ZIndex = 21
    arrow.Parent = multiDropdown

    -- Options Frame as ScrollingFrame
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 3)
    optionsFrame.BackgroundColor3 = Theme.Secondary
    optionsFrame.BackgroundTransparency = 0.2
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ScrollBarThickness = 3
    optionsFrame.ScrollBarImageColor3 = Theme.Accent
    optionsFrame.ScrollBarImageTransparency = 0.5
    optionsFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    optionsFrame.Visible = false
    optionsFrame.ClipsDescendants = true
    optionsFrame.ZIndex = 50
    optionsFrame.Parent = multiDropdown

    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 4)
    optionsCorner.Parent = optionsFrame

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 3)
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame

    local optionsPadding = Instance.new("UIPadding")
    optionsPadding.PaddingTop = UDim.new(0, 6)
    optionsPadding.PaddingBottom = UDim.new(0, 6)
    optionsPadding.PaddingLeft = UDim.new(0, 6)
    optionsPadding.PaddingRight = UDim.new(0, 6)
    optionsPadding.Parent = optionsFrame

    local selectedOptions = {}
    local isOpen = false

    if defaultSelections then
        if typeof(defaultSelections) == "table" then
            if #defaultSelections > 0 then
                for _, option in ipairs(defaultSelections) do
                    if table.find(options, option) then
                        selectedOptions[option] = true
                    end
                end
            else
                for option, isSelected in pairs(defaultSelections) do
                    if table.find(options, option) and isSelected then
                        selectedOptions[option] = true
                    end
                end
            end
        end
    end

    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(multiDropdown, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
    end

    local function updateDisplayText()
        local selectedCount = 0
        
        for option, isSelected in pairs(selectedOptions) do
            if isSelected then
                selectedCount = selectedCount + 1
            end
        end
        
        if selectedCount == 0 then
            valueLabel.Text = "Select..."
        else
            valueLabel.Text = selectedCount .. " selected"
        end
    end

    updateDisplayText()

    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, -8, 0, 22)
        optionButton.BackgroundColor3 = Theme.Secondary
        optionButton.BackgroundTransparency = 0.4
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Theme.Text
        optionButton.TextSize = 11
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Font = Enum.Font.Gotham
        optionButton.LayoutOrder = i
        optionButton.ZIndex = 51
        optionButton.Parent = optionsFrame

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 3)
        optionCorner.Parent = optionButton

        local textPadding = Instance.new("UIPadding")
        textPadding.PaddingLeft = UDim.new(0, 8)
        textPadding.Parent = optionButton

        if selectedOptions[option] then
            optionButton.BackgroundColor3 = Theme.Accent
            optionButton.BackgroundTransparency = 0.3
        else
            optionButton.BackgroundColor3 = Theme.Secondary
            optionButton.BackgroundTransparency = 0.4
        end

        optionButton.MouseButton1Click:Connect(function()
            if isPremium and not IsPremium then return end
            
            selectedOptions[option] = not selectedOptions[option]
            
            if selectedOptions[option] then
                optionButton.BackgroundColor3 = Theme.Accent
                optionButton.BackgroundTransparency = 0.3
            else
                optionButton.BackgroundColor3 = Theme.Secondary
                optionButton.BackgroundTransparency = 0.4
            end
            
            updateDisplayText()
            
            if callback then
                local selectionsArray = {}
                for opt, isSelected in pairs(selectedOptions) do
                    if isSelected then
                        table.insert(selectionsArray, opt)
                    end
                end
                callback(selectionsArray, selectedOptions)
            end
        end)
    end

    multiDropdown.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end
        
        isOpen = not isOpen
        
        if isOpen then
            optionsFrame.Visible = true
            local maxHeight = 120
            local contentHeight = optionsLayout.AbsoluteContentSize.Y + 12
            local targetHeight = math.min(contentHeight, maxHeight)
            
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            
            multiDropdown.ZIndex = 60
            optionsFrame.ZIndex = 61
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("GuiObject") then
                    child.ZIndex = 62
                end
            end
        else
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            
            wait(0.2)
            optionsFrame.Visible = false
            
            multiDropdown.ZIndex = 20
            optionsFrame.ZIndex = 50
        end
    end)

    local multiDropdownObj = {
        Instance = multiDropdown,
        PremiumLock = premiumLock
    }

    function multiDropdownObj:GetSelections()
        local selections = {}
        for option, selected in pairs(selectedOptions) do
            if selected then
                table.insert(selections, option)
            end
        end
        return selections
    end

    function multiDropdownObj:GetSelectionsTable()
        return selectedOptions
    end

    function multiDropdownObj:SetSelections(selections)
        if isPremium and not IsPremium then return end
        
        selectedOptions = {}
        
        if selections then
            if typeof(selections) == "table" then
                if #selections > 0 then
                    for _, option in ipairs(selections) do
                        if table.find(options, option) then
                            selectedOptions[option] = true
                        end
                    end
                else
                    for option, isSelected in pairs(selections) do
                        if table.find(options, option) and isSelected then
                            selectedOptions[option] = true
                        end
                    end
                end
            end
        end
        
        for _, optionButton in pairs(optionsFrame:GetChildren()) do
            if optionButton:IsA("TextButton") and optionButton.Name:find("Option_") then
                local option = optionButton.Name:sub(8)
                if selectedOptions[option] then
                    optionButton.BackgroundColor3 = Theme.Accent
                    optionButton.BackgroundTransparency = 0.3
                else
                    optionButton.BackgroundColor3 = Theme.Secondary
                    optionButton.BackgroundTransparency = 0.4
                end
            end
        end
        
        updateDisplayText()
        
        if callback then
            local selectionsArray = self:GetSelections()
            callback(selectionsArray, selectedOptions)
        end
    end

    function multiDropdownObj:ClearSelections()
        if isPremium and not IsPremium then return end
        
        for option in pairs(selectedOptions) do
            selectedOptions[option] = false
        end
        
        for _, optionButton in pairs(optionsFrame:GetChildren()) do
            if optionButton:IsA("TextButton") and optionButton.Name:find("Option_") then
                optionButton.BackgroundColor3 = Theme.Secondary
                optionButton.BackgroundTransparency = 0.4
            end
        end
        
        updateDisplayText()
        
        if callback then
            callback({}, {})
        end
    end

    function multiDropdownObj:SelectAll()
        if isPremium and not IsPremium then return end
        
        local allSelections = {}
        for _, option in ipairs(options) do
            selectedOptions[option] = true
            allSelections[option] = true
        end
        
        for _, optionButton in pairs(optionsFrame:GetChildren()) do
            if optionButton:IsA("TextButton") and optionButton.Name:find("Option_") then
                optionButton.BackgroundColor3 = Theme.Accent
                optionButton.BackgroundTransparency = 0.3
            end
        end
        
        updateDisplayText()
        
        if callback then
            local selectionsArray = self:GetSelections()
            callback(selectionsArray, selectedOptions)
        end
    end

    function multiDropdownObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(multiDropdown, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end

    return multiDropdownObj
end

-- Color Picker Function (Voidware Style) with Premium Support
function GuiLibrary:CreateColorPicker(tab, pickerName, defaultColor, callback, isPremium)
    local defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
    
    local colorPicker = Instance.new("TextButton")
    colorPicker.Name = "ColorPicker_" .. pickerName
    colorPicker.Size = UDim2.new(1, 0, 0, 32)
    colorPicker.BackgroundColor3 = Theme.Secondary
    colorPicker.BackgroundTransparency = 0.4
    colorPicker.BorderSizePixel = 0
    colorPicker.Text = ""
    colorPicker.Parent = tab.Frame

    local colorPickerCorner = Instance.new("UICorner")
    colorPickerCorner.CornerRadius = UDim.new(0, 4)
    colorPickerCorner.Parent = colorPicker

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = pickerName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = colorPicker

    local colorPreview = Instance.new("Frame")
    colorPreview.Name = "ColorPreview"
    colorPreview.Size = UDim2.new(0, 22, 0, 22)
    colorPreview.Position = UDim2.new(1, -30, 0.5, -11)
    colorPreview.BackgroundColor3 = defaultColor
    colorPreview.BorderSizePixel = 0
    colorPreview.Parent = colorPicker

    local colorPreviewCorner = Instance.new("UICorner")
    colorPreviewCorner.CornerRadius = UDim.new(0, 4)
    colorPreviewCorner.Parent = colorPreview

    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(colorPicker, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
    end

    local isOpen = false
    local currentColor = defaultColor

    colorPicker.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end
        isOpen = not isOpen
        -- Add your color picker window logic here
    end)

    -- Create color picker object with methods
    local colorPickerObj = {
        Instance = colorPicker,
        PremiumLock = premiumLock
    }

    function colorPickerObj:GetColor()
        return currentColor
    end

    function colorPickerObj:SetColor(color)
        if isPremium and not IsPremium then return end
        currentColor = color
        colorPreview.BackgroundColor3 = color
        if callback then
            callback(color)
        end
    end

    function colorPickerObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(colorPicker, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end

    return colorPickerObj
end

-- Number Input Field Function (Voidware Style) with Premium Support
function GuiLibrary:CreateNumberInput(tab, inputName, placeholder, defaultValue, minValue, maxValue, callback, isPremium)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "NumberInput_" .. inputName
    inputFrame.Size = UDim2.new(1, 0, 0, 32)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = tab.Frame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = inputName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = inputFrame

    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.new(0.6, 0, 1, 0)
    inputContainer.Position = UDim2.new(0.4, 0, 0, 0)
    inputContainer.BackgroundTransparency = 1
    inputContainer.Parent = inputFrame

    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(0.7, 0, 1, 0)
    textBox.Position = UDim2.new(0, 0, 0, 0)
    textBox.BackgroundColor3 = Theme.Secondary
    textBox.BackgroundTransparency = 0.4
    textBox.BorderSizePixel = 0
    textBox.Text = tostring(defaultValue or "")
    textBox.PlaceholderText = placeholder or "Enter number..."
    textBox.TextColor3 = Theme.Text
    textBox.PlaceholderColor3 = Theme.TextSecondary
    textBox.TextSize = 11
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputContainer

    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 4)
    textBoxCorner.Parent = textBox

    local textBoxPadding = Instance.new("UIPadding")
    textBoxPadding.PaddingLeft = UDim.new(0, 8)
    textBoxPadding.PaddingRight = UDim.new(0, 8)
    textBoxPadding.Parent = textBox

    -- Stepper buttons
    local stepperFrame = Instance.new("Frame")
    stepperFrame.Name = "Stepper"
    stepperFrame.Size = UDim2.new(0.3, 0, 1, 0)
    stepperFrame.Position = UDim2.new(0.7, 4, 0, 0)
    stepperFrame.BackgroundTransparency = 1
    stepperFrame.Parent = inputContainer

    local increaseButton = Instance.new("TextButton")
    increaseButton.Name = "Increase"
    increaseButton.Size = UDim2.new(0.5, -2, 1, 0)
    increaseButton.Position = UDim2.new(0.5, 2, 0, 0)
    increaseButton.BackgroundColor3 = Theme.Accent
    increaseButton.BackgroundTransparency = 0.3
    increaseButton.BorderSizePixel = 0
    increaseButton.Text = "+"
    increaseButton.TextColor3 = Theme.Text
    increaseButton.TextSize = 12
    increaseButton.Font = Enum.Font.GothamBold
    increaseButton.Parent = stepperFrame

    local decreaseButton = Instance.new("TextButton")
    decreaseButton.Name = "Decrease"
    decreaseButton.Size = UDim2.new(0.5, -2, 1, 0)
    decreaseButton.Position = UDim2.new(0, 0, 0, 0)
    decreaseButton.BackgroundColor3 = Theme.Accent
    decreaseButton.BackgroundTransparency = 0.3
    decreaseButton.BorderSizePixel = 0
    decreaseButton.Text = "-"
    decreaseButton.TextColor3 = Theme.Text
    decreaseButton.TextSize = 12
    decreaseButton.Font = Enum.Font.GothamBold
    decreaseButton.Parent = stepperFrame

    local stepperCorner = Instance.new("UICorner")
    stepperCorner.CornerRadius = UDim.new(0, 4)
    stepperCorner.Parent = increaseButton

    local stepperCorner2 = Instance.new("UICorner")
    stepperCorner2.CornerRadius = UDim.new(0, 4)
    stepperCorner2.Parent = decreaseButton

    local min = minValue or -math.huge
    local max = maxValue or math.huge
    local currentValue = tonumber(defaultValue) or 0

    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(inputFrame, "PREMIUM")
        callback = function() end -- Disable callback for non-premium users
    end

    local function validateNumber(value)
        local num = tonumber(value)
        if num then
            return math.clamp(num, min, max)
        end
        return currentValue
    end

    local function updateValue(newValue, triggerCallback)
        if isPremium and not IsPremium then return end
        
        local validatedValue = validateNumber(newValue)
        currentValue = validatedValue
        textBox.Text = tostring(validatedValue)
        
        if triggerCallback and callback then
            callback(validatedValue)
        end
    end

    local function stepValue(amount)
        if isPremium and not IsPremium then return end
        local newValue = currentValue + amount
        updateValue(newValue, true)
    end

    textBox.Focused:Connect(function()
        if isPremium and not IsPremium then return end
        TweenService:Create(textBox, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if isPremium and not IsPremium then return end
        TweenService:Create(textBox, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
        updateValue(textBox.Text, true)
    end)

    increaseButton.MouseButton1Click:Connect(function()
        stepValue(1)
    end)

    decreaseButton.MouseButton1Click:Connect(function()
        stepValue(-1)
    end)

    updateValue(defaultValue or 0, false)

    local numberInputObj = {
        Instance = inputFrame,
        PremiumLock = premiumLock
    }

    function numberInputObj:GetValue()
        return currentValue
    end

    function numberInputObj:SetValue(value)
        updateValue(value, false)
    end

    function numberInputObj:SetRange(newMin, newMax)
        min = newMin or min
        max = newMax or max
        updateValue(currentValue, false)
    end

    function numberInputObj:SetPlaceholder(text)
        textBox.PlaceholderText = text or ""
    end

    function numberInputObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(inputFrame, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end

    return numberInputObj
end


-- Player List Function (Voidware Style)
function GuiLibrary:CreatePlayerList(tab, listName, callback)
    local Players = game:GetService("Players")
    local playerEntries = {}
    local playerListFrame = nil
    
    local function createPlayerListFrame()
        if playerListFrame then
            playerListFrame:Destroy()
        end
        
        playerListFrame = Instance.new("Frame")
        playerListFrame.Name = "PlayerList_" .. listName
        playerListFrame.Size = UDim2.new(1, 0, 0, 0)
        playerListFrame.BackgroundTransparency = 1
        playerListFrame.Parent = tab.Frame
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = playerListFrame
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            playerListFrame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
        end)
        
        return playerListFrame
    end
    
    local function teleportToPlayer(targetPlayer)
        local character = Players.LocalPlayer.Character
        local targetCharacter = targetPlayer.Character
        
        if character and character:FindFirstChild("HumanoidRootPart") and 
           targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetCharacter.HumanoidRootPart
            local offset = Vector3.new(0, 3, 0)
            
            character.HumanoidRootPart.CFrame = targetHRP.CFrame + offset
            print("✅ Teleported to " .. targetPlayer.Name)
            
            if callback then
                callback(targetPlayer)
            end
        else
            warn("❌ Cannot teleport - player or target character not found")
        end
    end
    
    local function createPlayerEntry(player, isLocalPlayer)
        local playerFrame = Instance.new("Frame")
        playerFrame.Name = "PlayerEntry_" .. player.UserId
        playerFrame.Size = UDim2.new(1, 0, 0, 35)
        playerFrame.BackgroundColor3 = isLocalPlayer and Theme.Accent or Theme.Secondary
        playerFrame.BackgroundTransparency = isLocalPlayer and 0.3 or 0.4
        playerFrame.BorderSizePixel = 0
        playerFrame.LayoutOrder = isLocalPlayer and 0 or player.UserId
        playerFrame.Parent = playerListFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = playerFrame
        
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Name = "PlayerInfo"
        infoLabel.Size = UDim2.new(0.6, -8, 1, 0)
        infoLabel.Position = UDim2.new(0, 8, 0, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Theme.Text
        infoLabel.TextSize = 11
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.Parent = playerFrame
        
        local playerText = player.Name
        if player.DisplayName ~= player.Name then
            playerText = playerText .. "\n[@" .. player.DisplayName .. "]"
        end
        if isLocalPlayer then
            playerText = "👑 " .. playerText .. " (You)"
        end
        infoLabel.Text = playerText
        
        if not isLocalPlayer then
            local tpButton = Instance.new("TextButton")
            tpButton.Name = "TPButton"
            tpButton.Size = UDim2.new(0.35, -8, 0, 25)
            tpButton.Position = UDim2.new(0.65, 4, 0.5, -12.5)
            tpButton.BackgroundColor3 = Theme.Accent
            tpButton.BackgroundTransparency = 0.3
            tpButton.BorderSizePixel = 0
            tpButton.Text = "📡 TP"
            tpButton.TextColor3 = Theme.Text
            tpButton.TextSize = 10
            tpButton.Font = Enum.Font.GothamBold
            tpButton.Parent = playerFrame
            
            local tpCorner = Instance.new("UICorner")
            tpCorner.CornerRadius = UDim.new(0, 4)
            tpCorner.Parent = tpButton
            
            tpButton.MouseEnter:Connect(function()
                if not isMobile then
                    TweenService:Create(tpButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
                end
            end)
            
            tpButton.MouseLeave:Connect(function()
                if not isMobile then
                    TweenService:Create(tpButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
                end
            end)
            
            tpButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)
        end
        
        return playerFrame
    end
    
    local function refreshPlayerList()
        local container = createPlayerListFrame()
        local players = Players:GetPlayers()
        
        table.sort(players, function(a, b)
            return a.Name:lower() < b.Name:lower()
        end)
        
        for _, player in ipairs(players) do
            local isLocalPlayer = (player == Players.LocalPlayer)
            local playerEntry = createPlayerEntry(player, isLocalPlayer)
            playerEntries[player.UserId] = playerEntry
        end
        
        print("🔄 Player list updated: " .. (#players - 1) .. " other players")
    end
    
    local function setupAutoRefresh()
        Players.PlayerAdded:Connect(function(player)
            task.wait(1)
            refreshPlayerList()
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            refreshPlayerList()
        end)
    end
    
    refreshPlayerList()
    setupAutoRefresh()
    
    local playerListObj = {}
    
    function playerListObj:Refresh()
        refreshPlayerList()
    end
    
    function playerListObj:GetPlayerCount()
        return #Players:GetPlayers()
    end
    
    function playerListObj:GetOtherPlayerCount()
        return #Players:GetPlayers() - 1
    end
    
    function playerListObj:TeleportToPlayer(player)
        if typeof(player) == "Instance" and player:IsA("Player") then
            teleportToPlayer(player)
        else
            warn("❌ Invalid player provided")
        end
    end
    
    function playerListObj:GetPlayers()
        return Players:GetPlayers()
    end
    
    function playerListObj:GetInstance()
        return playerListFrame
    end
    
    function playerListObj:Destroy()
        if playerListFrame then
            playerListFrame:Destroy()
            playerListFrame = nil
        end
        playerEntries = {}
    end
    
    return playerListObj
end

-- Progress Bar Function (Voidware Style)
function GuiLibrary:CreateProgressBar(tab, progressName, minValue, maxValue, defaultValue, callback)
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar_" .. progressName
    progressBar.Size = UDim2.new(1, 0, 0, 50)
    progressBar.BackgroundTransparency = 1
    progressBar.Parent = tab.Frame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = progressName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = progressBar
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 60, 0, 18)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue or minValue) .. "/" .. tostring(maxValue)
    valueLabel.TextColor3 = Theme.TextSecondary
    valueLabel.TextSize = 10
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = progressBar
    
    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "Track"
    progressTrack.Size = UDim2.new(1, 0, 0, 16)
    progressTrack.Position = UDim2.new(0, 0, 0, 25)
    progressTrack.BackgroundColor3 = Theme.Secondary
    progressTrack.BackgroundTransparency = 0.4
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = progressBar
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 8)
    trackCorner.Parent = progressTrack
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Theme.Accent
    progressFill.BackgroundTransparency = 0.3
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = progressFill
    
    local percentageLabel = Instance.new("TextLabel")
    percentageLabel.Name = "Percentage"
    percentageLabel.Size = UDim2.new(1, 0, 1, 0)
    percentageLabel.BackgroundTransparency = 1
    percentageLabel.Text = "0%"
    percentageLabel.TextColor3 = Theme.Text
    percentageLabel.TextSize = 10
    percentageLabel.Font = Enum.Font.GothamBold
    percentageLabel.Parent = progressTrack
    
    local currentValue = defaultValue or minValue
    local min = minValue or 0
    local max = maxValue or 100
    
    local function updateProgress(value, triggerCallback)
        currentValue = math.clamp(value, min, max)
        local percentage = (currentValue - min) / (max - min)
        local fillWidth = percentage * progressTrack.AbsoluteSize.X
        
        progressFill.Size = UDim2.new(percentage, 0, 1, 0)
        valueLabel.Text = tostring(math.floor(currentValue)) .. "/" .. tostring(max)
        percentageLabel.Text = string.format("%d%%", math.floor(percentage * 100))
        
        if percentage > 0.5 then
            percentageLabel.TextColor3 = Color3.new(1, 1, 1)
        else
            percentageLabel.TextColor3 = Theme.Text
        end
        
        if triggerCallback and callback then
            callback(currentValue, percentage)
        end
    end
    
    updateProgress(currentValue, false)
    
    local progressBarObj = {}
    
    function progressBarObj:GetValue()
        return currentValue
    end
    
    function progressBarObj:SetValue(value)
        updateProgress(value, true)
    end
    
    function progressBarObj:SetRange(newMin, newMax)
        min = newMin or min
        max = newMax or max
        updateProgress(currentValue, false)
    end
    
    function progressBarObj:Increment(amount)
        amount = amount or 1
        updateProgress(currentValue + amount, true)
    end
    
    function progressBarObj:Decrement(amount)
        amount = amount or 1
        updateProgress(currentValue - amount, true)
    end
    
    function progressBarObj:GetPercentage()
        return (currentValue - min) / (max - min)
    end
    
    function progressBarObj:SetColor(color)
        progressFill.BackgroundColor3 = color or Theme.Accent
    end
    
    function progressBarObj:Reset()
        updateProgress(min, true)
    end
    
    function progressBarObj:SetToMax()
        updateProgress(max, true)
    end
    
    function progressBarObj:IsComplete()
        return currentValue >= max
    end
    
    function progressBarObj:GetInstance()
        return progressBar
    end
    
    return progressBarObj
end

-- Temporary Progress Bar Function (Voidware Style)
function GuiLibrary:CreateTemporaryProgressBar(progressName, duration, callback)
    local temporaryProgress = {}
    temporaryProgress.Destroyed = false
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TemporaryProgress_" .. progressName
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 70)
    mainFrame.Position = UDim2.new(0.5, -140, 0.1, 0)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.9
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 20)
    title.Position = UDim2.new(0, 8, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = progressName
    title.TextColor3 = Theme.Text
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, -16, 0, 16)
    progressTrack.Position = UDim2.new(0, 8, 0, 32)
    progressTrack.BackgroundColor3 = Theme.Secondary
    progressTrack.BackgroundTransparency = 0.4
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = mainFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 8)
    trackCorner.Parent = progressTrack
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Theme.Accent
    progressFill.BackgroundTransparency = 0.3
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = progressFill
    
    local percentageLabel = Instance.new("TextLabel")
    percentageLabel.Size = UDim2.new(1, 0, 1, 0)
    percentageLabel.BackgroundTransparency = 1
    percentageLabel.Text = "0%"
    percentageLabel.TextColor3 = Theme.Text
    percentageLabel.TextSize = 10
    percentageLabel.Font = Enum.Font.GothamBold
    percentageLabel.Parent = progressTrack
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, -16, 0, 12)
    timeLabel.Position = UDim2.new(0, 8, 0, 50)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Time remaining: " .. duration .. "s"
    timeLabel.TextColor3 = Theme.TextSecondary
    timeLabel.TextSize = 9
    timeLabel.TextXAlignment = Enum.TextXAlignment.Right
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.Parent = mainFrame
    
    local startTime = tick()
    local endTime = startTime + duration
    
    local function animateProgress()
        while tick() < endTime and not temporaryProgress.Destroyed do
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            local remaining = duration - elapsed
            
            progressFill.Size = UDim2.new(progress, 0, 1, 0)
            percentageLabel.Text = string.format("%d%%", math.floor(progress * 100))
            timeLabel.Text = string.format("Time remaining: %.1fs", remaining)
            
            if progress > 0.5 then
                percentageLabel.TextColor3 = Color3.new(1, 1, 1)
            else
                percentageLabel.TextColor3 = Theme.Text
            end
            
            if callback then
                callback(progress, remaining)
            end
            
            wait(0.1)
        end
        
        if not temporaryProgress.Destroyed then
            progressFill.Size = UDim2.new(1, 0, 1, 0)
            percentageLabel.Text = "100%"
            timeLabel.Text = "Completed!"
            
            if callback then
                callback(1, 0)
            end
            
            wait(2)
            temporaryProgress:Destroy()
        end
    end
    
    spawn(animateProgress)
    
    function temporaryProgress:Destroy()
        if not self.Destroyed then
            self.Destroyed = true
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
            end
        end
    end
    
    function temporaryProgress:GetRemainingTime()
        return math.max(0, endTime - tick())
    end
    
    function temporaryProgress:GetProgress()
        local elapsed = tick() - startTime
        return math.min(1, elapsed / duration)
    end
    
    function temporaryProgress:IsComplete()
        return tick() >= endTime
    end
    
    function temporaryProgress:GetInstance()
        return screenGui
    end
    
    return temporaryProgress
end



-- new added

-- Predefined badge types for quick use
GuiLibrary.BadgeTypes = {
    NEW = {Text = "NEW", Color = Color3.fromRGB(255, 50, 50)},
    UPDATED = {Text = "UPD", Color = Color3.fromRGB(0, 150, 255)},
    BETA = {Text = "BETA", Color = Color3.fromRGB(255, 165, 0)},
    RISK = {Text = "RISK", Color = Color3.fromRGB(255, 0, 0)},
    WARNING = {Text = "WARN", Color = Color3.fromRGB(255, 165, 0)},
    IMPROVED = {Text = "IMPROVED", Color = Color3.fromRGB(150, 0, 255)},
    V2 = {Text = "V2", Color = Color3.fromRGB(0, 200, 100)},
    V3 = {Text = "V3", Color = Color3.fromRGB(0, 150, 255)},
    HOT = {Text = "HOT", Color = Color3.fromRGB(255, 0, 0)},
    POPULAR = {Text = "POPULAR", Color = Color3.fromRGB(255, 105, 180)}
}

-- Mark GUI Elements as New
function GuiLibrary:MarkAsNew(guiElement, badgeText, badgeColor)
    -- Support for predefined badge types
    local badgeType = nil
    if type(badgeText) == "table" and badgeText.Text and badgeText.Color then
        badgeType = badgeText
        badgeText = badgeType.Text
        badgeColor = badgeType.Color
    elseif GuiLibrary.BadgeTypes[badgeText] then
        badgeType = GuiLibrary.BadgeTypes[badgeText]
        badgeText = badgeType.Text
        badgeColor = badgeType.Color
    end
    
    badgeText = badgeText or "NEW"
    badgeColor = badgeColor or Color3.fromRGB(255, 50, 50) -- Red color for "NEW"
    
    -- Create badge container
    local badge = Instance.new("Frame")
    badge.Name = "NewBadge"
    badge.Size = UDim2.new(0, 25, 0, 12)
    badge.Position = UDim2.new(1, -30, 0, 3)
    badge.BackgroundColor3 = badgeColor
    badge.BorderSizePixel = 0
    badge.ZIndex = 10
    badge.Parent = guiElement
    
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 3)
    badgeCorner.Parent = badge
    
    local badgeLabel = Instance.new("TextLabel")
    badgeLabel.Name = "BadgeText"
    badgeLabel.Size = UDim2.new(1, 0, 1, 0)
    badgeLabel.BackgroundTransparency = 1
    badgeLabel.Text = badgeText
    badgeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    badgeLabel.TextSize = 8
    badgeLabel.Font = Enum.Font.GothamBold
    badgeLabel.ZIndex = 11
    badgeLabel.Parent = badge
    
    -- Add subtle animation
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local time = tick()
        local alpha = math.sin(time * 5) * 0.2 + 0.8
        badge.BackgroundTransparency = 1 - alpha
    end)
    
    -- Function to remove badge
    local function removeBadge()
        if connection then
            connection:Disconnect()
        end
        badge:Destroy()
    end
    
    -- Auto-remove after 24 hours (optional)
    delay(12000, removeBadge)
    
    return {
        Remove = removeBadge,
        UpdateText = function(newText)
            badgeLabel.Text = newText or badgeText
        end,
        UpdateColor = function(newColor)
            badge.BackgroundColor3 = newColor or badgeColor
        end,
        UpdateType = function(badgeTypeName)
            local badgeType = GuiLibrary.BadgeTypes[badgeTypeName]
            if badgeType then
                badgeLabel.Text = badgeType.Text
                badge.BackgroundColor3 = badgeType.Color
            end
        end,
        GetInstance = function()
            return badge
        end
    }
end

-- Mark Information Items as New (for Information page)
function GuiLibrary:MarkInformationAsNew(infoItem, badgeText, badgeColor)
    -- Support for predefined badge types
    local badgeType = nil
    if type(badgeText) == "table" and badgeText.Text and badgeText.Color then
        badgeType = badgeText
        badgeText = badgeType.Text
        badgeColor = badgeType.Color
    elseif GuiLibrary.BadgeTypes[badgeText] then
        badgeType = GuiLibrary.BadgeTypes[badgeText]
        badgeText = badgeType.Text
        badgeColor = badgeType.Color
    end
    
    badgeText = badgeText or "NEW"
    badgeColor = badgeColor or Color3.fromRGB(255, 50, 50)
    
    local badge = Instance.new("Frame")
    badge.Name = "InfoBadge"
    badge.Size = UDim2.new(0, 20, 0, 10)
    badge.Position = UDim2.new(0, 5, 0, 5)
    badge.BackgroundColor3 = badgeColor
    badge.BorderSizePixel = 0
    badge.ZIndex = 10
    badge.Parent = infoItem
    
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 2)
    badgeCorner.Parent = badge
    
    local badgeLabel = Instance.new("TextLabel")
    badgeLabel.Name = "BadgeText"
    badgeLabel.Size = UDim2.new(1, 0, 1, 0)
    badgeLabel.BackgroundTransparency = 1
    badgeLabel.Text = badgeText
    badgeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    badgeLabel.TextSize = 6
    badgeLabel.Font = Enum.Font.GothamBold
    badgeLabel.ZIndex = 11
    badgeLabel.Parent = badge
    
    return {
        Remove = function()
            badge:Destroy()
        end,
        UpdateType = function(badgeTypeName)
            local badgeType = GuiLibrary.BadgeTypes[badgeTypeName]
            if badgeType then
                badgeLabel.Text = badgeType.Text
                badge.BackgroundColor3 = badgeType.Color
            end
        end
    }
end

-- Welcome New
-- Welcome Function (Professional Style)
function GuiLibrary:CreateWelcomeScreen(scriptDetails)
    -- Default values with professional styling
    local config = {
        ScriptName = scriptDetails.ScriptName or "Voidware Script",
        Version = scriptDetails.Version or "v2.1.0",
        Developer = scriptDetails.Developer or "Voidware Team",
        Website = scriptDetails.Website or "https://voidware.xyz",
        Discord = scriptDetails.Discord or "https://discord.gg/voidware",
        SpecialThanks = scriptDetails.SpecialThanks or {"Community", "Testers", "Contributors"},
        Logo = scriptDetails.Logo or nil, -- Can be ImageLabel or Text
        ThemeColor = scriptDetails.ThemeColor or Theme.Accent
    }
    
    -- Create welcome screen
    local welcomeScreen = Instance.new("ScreenGui")
    welcomeScreen.Name = "WelcomeScreen"
    welcomeScreen.ResetOnSpawn = false
    welcomeScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    welcomeScreen.Parent = playerGui
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "WelcomeFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Parent = welcomeScreen
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 15, 1, 15)
    shadow.Position = UDim2.new(0, -7.5, 0, -7.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.9
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame
    
    -- Header with accent
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = config.ThemeColor
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Logo/Title area
    local logoContainer = Instance.new("Frame")
    logoContainer.Name = "LogoContainer"
    logoContainer.Size = UDim2.new(1, -40, 1, -20)
    logoContainer.Position = UDim2.new(0, 20, 0, 10)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = header
    
    if config.Logo then
        -- If logo is provided as image
        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2.new(0, 50, 0, 50)
        logo.Position = UDim2.new(0, 0, 0.5, -25)
        logo.BackgroundTransparency = 1
        logo.Image = config.Logo
        logo.ScaleType = Enum.ScaleType.Fit
        logo.Parent = logoContainer
        
        local titleFrame = Instance.new("Frame")
        titleFrame.Name = "TitleFrame"
        titleFrame.Size = UDim2.new(1, -60, 1, 0)
        titleFrame.Position = UDim2.new(0, 60, 0, 0)
        titleFrame.BackgroundTransparency = 1
        titleFrame.Parent = logoContainer
        
        local scriptName = Instance.new("TextLabel")
        scriptName.Name = "ScriptName"
        scriptName.Size = UDim2.new(1, 0, 0, 30)
        scriptName.Position = UDim2.new(0, 0, 0, 10)
        scriptName.BackgroundTransparency = 1
        scriptName.Text = config.ScriptName
        scriptName.TextColor3 = Theme.Text
        scriptName.TextSize = 24
        scriptName.Font = Enum.Font.GothamBold
        scriptName.TextXAlignment = Enum.TextXAlignment.Left
        scriptName.Parent = titleFrame
        
        local version = Instance.new("TextLabel")
        version.Name = "Version"
        version.Size = UDim2.new(1, 0, 0, 20)
        version.Position = UDim2.new(0, 0, 0, 40)
        version.BackgroundTransparency = 1
        version.Text = config.Version
        version.TextColor3 = Theme.TextSecondary
        version.TextSize = 14
        version.Font = Enum.Font.Gotham
        version.TextXAlignment = Enum.TextXAlignment.Left
        version.Parent = titleFrame
    else
        -- Text-only logo
        local scriptName = Instance.new("TextLabel")
        scriptName.Name = "ScriptName"
        scriptName.Size = UDim2.new(1, 0, 0, 40)
        scriptName.Position = UDim2.new(0, 0, 0, 10)
        scriptName.BackgroundTransparency = 1
        scriptName.Text = config.ScriptName
        scriptName.TextColor3 = Theme.Text
        scriptName.TextSize = 28
        scriptName.Font = Enum.Font.GothamBold
        scriptName.Parent = logoContainer
        
        local version = Instance.new("TextLabel")
        version.Name = "Version"
        version.Size = UDim2.new(1, 0, 0, 20)
        version.Position = UDim2.new(0, 0, 0, 50)
        version.BackgroundTransparency = 1
        version.Text = config.Version
        version.TextColor3 = Theme.TextSecondary
        version.TextSize = 16
        version.Font = Enum.Font.Gotham
        version.Parent = logoContainer
    end
    
    -- Content area
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -40, 1, -120)
    content.Position = UDim2.new(0, 20, 0, 100)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = config.ThemeColor
    content.ScrollBarImageTransparency = 0.5
    content.Parent = mainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 5)
    contentPadding.PaddingRight = UDim.new(0, 5)
    contentPadding.Parent = content
    
    -- Developer Section
    local devSection = self:CreateInfoSection(content, "👑 DEVELOPER", config.Developer)
    
    -- Website Section
    local websiteFrame = Instance.new("Frame")
    websiteFrame.Name = "WebsiteSection"
    websiteFrame.Size = UDim2.new(1, 0, 0, 60)
    websiteFrame.BackgroundTransparency = 1
    websiteFrame.LayoutOrder = 2
    websiteFrame.Parent = content
    
    local websiteTitle = Instance.new("TextLabel")
    websiteTitle.Name = "Title"
    websiteTitle.Size = UDim2.new(1, 0, 0, 20)
    websiteTitle.BackgroundTransparency = 1
    websiteTitle.Text = "🌐 WEBSITE"
    websiteTitle.TextColor3 = Theme.Text
    websiteTitle.TextSize = 12
    websiteTitle.Font = Enum.Font.GothamBold
    websiteTitle.TextXAlignment = Enum.TextXAlignment.Left
    websiteTitle.Parent = websiteFrame
    
    local websiteButton = Instance.new("TextButton")
    websiteButton.Name = "WebsiteButton"
    websiteButton.Size = UDim2.new(1, 0, 0, 35)
    websiteButton.Position = UDim2.new(0, 0, 0, 25)
    websiteButton.BackgroundColor3 = Theme.Secondary
    websiteButton.BackgroundTransparency = 0.3
    websiteButton.BorderSizePixel = 0
    websiteButton.Text = config.Website
    websiteButton.TextColor3 = config.ThemeColor
    websiteButton.TextSize = 11
    websiteButton.Font = Enum.Font.Gotham
    websiteButton.Parent = websiteFrame
    
    local websiteCorner = Instance.new("UICorner")
    websiteCorner.CornerRadius = UDim.new(0, 6)
    websiteCorner.Parent = websiteButton
    
    -- Discord Section
    local discordFrame = Instance.new("Frame")
    discordFrame.Name = "DiscordSection"
    discordFrame.Size = UDim2.new(1, 0, 0, 60)
    discordFrame.BackgroundTransparency = 1
    discordFrame.LayoutOrder = 3
    discordFrame.Parent = content
    
    local discordTitle = Instance.new("TextLabel")
    discordTitle.Name = "Title"
    discordTitle.Size = UDim2.new(1, 0, 0, 20)
    discordTitle.BackgroundTransparency = 1
    discordTitle.Text = "💬 DISCORD"
    discordTitle.TextColor3 = Theme.Text
    discordTitle.TextSize = 12
    discordTitle.Font = Enum.Font.GothamBold
    discordTitle.TextXAlignment = Enum.TextXAlignment.Left
    discordTitle.Parent = discordFrame
    
    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Size = UDim2.new(1, 0, 0, 35)
    discordButton.Position = UDim2.new(0, 0, 0, 25)
    discordButton.BackgroundColor3 = Theme.Secondary
    discordButton.BackgroundTransparency = 0.3
    discordButton.BorderSizePixel = 0
    discordButton.Text = config.Discord
    discordButton.TextColor3 = Color3.fromRGB(88, 101, 242) -- Discord blue
    discordButton.TextSize = 11
    discordButton.Font = Enum.Font.Gotham
    discordButton.Parent = discordFrame
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordButton
    
    -- Special Thanks Section
    local thanksFrame = Instance.new("Frame")
    thanksFrame.Name = "ThanksSection"
    thanksFrame.Size = UDim2.new(1, 0, 0, 0) -- Auto-size
    thanksFrame.BackgroundTransparency = 1
    thanksFrame.LayoutOrder = 4
    thanksFrame.Parent = content
    
    local thanksTitle = Instance.new("TextLabel")
    thanksTitle.Name = "Title"
    thanksTitle.Size = UDim2.new(1, 0, 0, 20)
    thanksTitle.BackgroundTransparency = 1
    thanksTitle.Text = "🎉 SPECIAL THANKS TO"
    thanksTitle.TextColor3 = Theme.Text
    thanksTitle.TextSize = 12
    thanksTitle.Font = Enum.Font.GothamBold
    thanksTitle.TextXAlignment = Enum.TextXAlignment.Left
    thanksTitle.Parent = thanksFrame
    
    local thanksList = Instance.new("Frame")
    thanksList.Name = "ThanksList"
    thanksList.Size = UDim2.new(1, 0, 0, 0) -- Auto-size
    thanksList.Position = UDim2.new(0, 0, 0, 25)
    thanksList.BackgroundTransparency = 1
    thanksList.Parent = thanksFrame
    
    local thanksLayout = Instance.new("UIListLayout")
    thanksLayout.Padding = UDim.new(0, 5)
    thanksLayout.SortOrder = Enum.SortOrder.LayoutOrder
    thanksLayout.Parent = thanksList
    
    -- Add special thanks items
    for i, person in ipairs(config.SpecialThanks) do
        local thanksItem = Instance.new("TextLabel")
        thanksItem.Name = "ThanksItem"
        thanksItem.Size = UDim2.new(1, 0, 0, 20)
        thanksItem.BackgroundTransparency = 1
        thanksItem.Text = "• " .. person
        thanksItem.TextColor3 = Theme.TextSecondary
        thanksItem.TextSize = 11
        thanksItem.Font = Enum.Font.Gotham
        thanksItem.TextXAlignment = Enum.TextXAlignment.Left
        thanksItem.LayoutOrder = i
        thanksItem.Parent = thanksList
    end
    
    -- Update thanks list size
    thanksLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        thanksList.Size = UDim2.new(1, 0, 0, thanksLayout.AbsoluteContentSize.Y)
        thanksFrame.Size = UDim2.new(1, 0, 0, thanksLayout.AbsoluteContentSize.Y + 25)
    end)
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 120, 0, 35)
    closeButton.Position = UDim2.new(0.5, -60, 1, -50)
    closeButton.BackgroundColor3 = config.ThemeColor
    closeButton.BackgroundTransparency = 0.2
    closeButton.BorderSizePixel = 0
    closeButton.Text = "GET STARTED"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 12
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Update content size
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Button interactions
    websiteButton.MouseButton1Click:Connect(function()
        self:CopyToClipboard(config.Website)
        self:ShowNotification("Website link copied to clipboard!", 3)
    end)
    
    discordButton.MouseButton1Click:Connect(function()
        self:CopyToClipboard(config.Discord)
        self:ShowNotification("Discord link copied to clipboard!", 3)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        welcomeScreen:Destroy()
    end)
    
    -- Button hover effects
    local function setupButtonEffects(button)
        button.MouseEnter:Connect(function()
            if not isMobile then
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not isMobile then
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
            end
        end)
    end
    
    setupButtonEffects(websiteButton)
    setupButtonEffects(discordButton)
    setupButtonEffects(closeButton)
    
    -- Auto-close after 30 seconds
    delay(30, function()
        if welcomeScreen and welcomeScreen.Parent then
            welcomeScreen:Destroy()
        end
    end)
    
    return welcomeScreen
end

-- Helper function to create info sections
function GuiLibrary:CreateInfoSection(parent, title, contentText)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, 0, 0, 60)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 0, 35)
    contentFrame.Position = UDim2.new(0, 0, 0, 25)
    contentFrame.BackgroundColor3 = Theme.Secondary
    contentFrame.BackgroundTransparency = 0.3
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = section
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = contentFrame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Text"
    contentLabel.Size = UDim2.new(1, -20, 1, 0)
    contentLabel.Position = UDim2.new(0, 10, 0, 0)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = contentText
    contentLabel.TextColor3 = Theme.TextSecondary
    contentLabel.TextSize = 11
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Center
    contentLabel.Parent = contentFrame
    
    return section
end

-- Copy to clipboard function
function GuiLibrary:CopyToClipboard(text)
    local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if clipBoard then
        clipBoard(text)
        return true
    else
        warn("Clipboard function not available")
        return false
    end
end

-- Notification function
function GuiLibrary:ShowNotification(message, duration)
    duration = duration or 3
    
    local notification = Instance.new("ScreenGui")
    notification.Name = "Notification"
    notification.ResetOnSpawn = false
    notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notification.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    frame.BackgroundColor3 = Theme.Background
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.9
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -10)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = frame
    
    -- Animate in
    frame.Position = UDim2.new(0.5, -150, 0, -60)
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0.1, 0)}):Play()
    
    -- Auto-remove
    delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
        wait(0.3)
        notification:Destroy()
    end)
end


-- Create Script Info Section
function GuiLibrary:CreateScriptInfo(tab, scriptData)
    if not tab or not scriptData then
        warn("CreateScriptInfo: Invalid parameters")
        return
    end
    
    local config = {
        Name = scriptData.Name or "Script",
        Version = scriptData.Version or "v1.0.0",
        Developer = scriptData.Developer or "Unknown",
        Description = scriptData.Description or "No description provided",
        Discord = scriptData.Discord or "No Discord link",
        Features = scriptData.Features or {"No features listed"},
        News = scriptData.News or {"No news available"}
    }
    
    -- Main Info Section
    self:CreateSeparator(tab, "📋 SCRIPT INFORMATION")
    
    -- Script Name and Version
    self:CreateLabel(tab, "🎮 " .. config.Name)
    self:CreateLabel(tab, "📱 Version: " .. config.Version)
    self:CreateLabel(tab, "👨‍💻 Developer: " .. config.Developer)
    
    -- Description
    self:CreateSeparator(tab, "📝 DESCRIPTION")
    self:CreateLabel(tab, config.Description)
    
    -- Discord Link
    self:CreateSeparator(tab, "💬 DISCORD")
    self:CreateButton(tab, "Join Discord: " .. config.Discord, function()
    self:CopyToClipboard(config.Discord)
    end)
    
    -- Features Section
    self:CreateSeparator(tab, "✨ FEATURES")
    for i, feature in ipairs(config.Features) do
        self:CreateLabel(tab, "✅ " .. feature)
    end
    
    -- News/Updates Section
    self:CreateSeparator(tab, "📰 LATEST NEWS")
    for i, news in ipairs(config.News) do
        self:CreateLabel(tab, "📢 " .. news)
    end
    
    -- Status
    self:CreateSeparator(tab, "🔧 STATUS")
    self:CreateLabel(tab, "🟢 Script Status: ACTIVE")
    self:CreateLabel(tab, "🎯 Premium Features: " .. (IsPremium and "ENABLED 🟢" or "LOCKED 🔒"))
    
    return {
        UpdateNews = function(newNews)
            config.News = newNews or config.News
        end,
        
        UpdateVersion = function(newVersion)
            config.Version = newVersion or config.Version
        end,
        
        GetInfo = function()
            return config
        end
    }
end

-- Copy to clipboard function
function GuiLibrary:CopyToClipboard(text)
    local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if clipBoard then
        clipBoard(text)
        print("✅ Copied to clipboard: " .. text)
        return true
    else
        warn("❌ Clipboard function not available")
        return false
    end
end



-- Close function
local function closeGUI()
    if isDestroyed then return end
    isDestroyed = true
    
    -- Destroy all GUI elements
    screenGui:Destroy()
    
    -- Disconnect any running connections (if they exist)
    for _, button in pairs(buttons) do
        -- Check if button has connections stored in a different way
        -- This prevents the "Connection is not a valid member" error
        if button and typeof(button) == "Instance" then
            -- Button is an Instance, no need to disconnect anything
            -- The connections will be automatically cleaned up when the GUI is destroyed
        end
    end
    
    -- Also clear any other connections
    if AutoChop and AutoChop.Connection then
        AutoChop.Connection:Disconnect()
    end
    
    -- Clear the buttons table
    buttons = {}
end



--new combo
-- Create Combo Function (Voidware Style) - Combination of Label, Toggle, and Action Buttons
function GuiLibrary:CreateCombo(tab, comboName, toggleCallback, runCallback, pinCallback, resetCallback, isPremium)
    local comboFrame = Instance.new("Frame")
    comboFrame.Name = "Combo_" .. comboName
    comboFrame.Size = UDim2.new(1, 0, 0, 32)
    comboFrame.BackgroundTransparency = 1
    comboFrame.Parent = tab.Frame

    -- Background for the entire combo
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Theme.Secondary
    background.BackgroundTransparency = 0.4
    background.BorderSizePixel = 0
    background.Parent = comboFrame

    local backgroundCorner = Instance.new("UICorner")
    backgroundCorner.CornerRadius = UDim.new(0, 4)
    backgroundCorner.Parent = background

    -- Label on the left side
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.4, -5, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = comboName
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = comboFrame

    -- Toggle button in the middle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0.2, 0, 0.7, 0)
    toggleButton.Position = UDim2.new(0.4, 5, 0.15, 0)
    toggleButton.BackgroundColor3 = Theme.Secondary
    toggleButton.BackgroundTransparency = 0.3
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Theme.TextSecondary
    toggleButton.TextSize = 10
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = comboFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton

    -- Action buttons container on the right
    local actionsContainer = Instance.new("Frame")
    actionsContainer.Name = "Actions"
    actionsContainer.Size = UDim2.new(0.4, -8, 1, 0)
    actionsContainer.Position = UDim2.new(0.6, 8, 0, 0)
    actionsContainer.BackgroundTransparency = 1
    actionsContainer.Parent = comboFrame

    -- Run Button (R)
    local runButton = Instance.new("TextButton")
    runButton.Name = "Run"
    runButton.Size = UDim2.new(0.3, -2, 0.7, 0)
    runButton.Position = UDim2.new(0, 0, 0.15, 0)
    runButton.BackgroundColor3 = Theme.Success
    runButton.BackgroundTransparency = 0.3
    runButton.BorderSizePixel = 0
    runButton.Text = "R"
    runButton.TextColor3 = Theme.Text
    runButton.TextSize = 10
    runButton.Font = Enum.Font.GothamBold
    runButton.Parent = actionsContainer

    local runCorner = Instance.new("UICorner")
    runCorner.CornerRadius = UDim.new(0, 3)
    runCorner.Parent = runButton

    -- Pin Button (P)
    local pinButton = Instance.new("TextButton")
    pinButton.Name = "Pin"
    pinButton.Size = UDim2.new(0.3, -2, 0.7, 0)
    pinButton.Position = UDim2.new(0.35, 2, 0.15, 0)
    pinButton.BackgroundColor3 = Theme.Accent
    pinButton.BackgroundTransparency = 0.3
    pinButton.BorderSizePixel = 0
    pinButton.Text = "P"
    pinButton.TextColor3 = Theme.Text
    pinButton.TextSize = 10
    pinButton.Font = Enum.Font.GothamBold
    pinButton.Parent = actionsContainer

    local pinCorner = Instance.new("UICorner")
    pinCorner.CornerRadius = UDim.new(0, 3)
    pinCorner.Parent = pinButton

    -- Reset Button (R) - Different color
    local resetButton = Instance.new("TextButton")
    resetButton.Name = "Reset"
    resetButton.Size = UDim2.new(0.3, -2, 0.7, 0)
    resetButton.Position = UDim2.new(0.7, 2, 0.15, 0)
    resetButton.BackgroundColor3 = Theme.Danger
    resetButton.BackgroundTransparency = 0.3
    resetButton.BorderSizePixel = 0
    resetButton.Text = "R"
    resetButton.TextColor3 = Theme.Text
    resetButton.TextSize = 10
    resetButton.Font = Enum.Font.GothamBold
    resetButton.Parent = actionsContainer

    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 3)
    resetCorner.Parent = resetButton

    -- State variables
    local isToggled = false
    local isPinned = false
    local isRunning = false

    -- Mark as premium if required
    local premiumLock
    if isPremium and not IsPremium then
        premiumLock = self:MarkAsPremium(comboFrame, "PREMIUM")
        toggleCallback = function() end
        runCallback = function() end
        pinCallback = function() end
        resetCallback = function() end
    end

    -- Update toggle appearance
    local function updateToggleAppearance()
        if isToggled then
            toggleButton.BackgroundColor3 = Theme.Success
            toggleButton.TextColor3 = Color3.new(1, 1, 1)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Theme.Secondary
            toggleButton.TextColor3 = Theme.TextSecondary
            toggleButton.Text = "OFF"
        end
    end

    -- Update pin appearance
    local function updatePinAppearance()
        if isPinned then
            pinButton.BackgroundColor3 = Theme.Premium
            pinButton.TextColor3 = Color3.new(1, 1, 1)
        else
            pinButton.BackgroundColor3 = Theme.Accent
            pinButton.TextColor3 = Theme.Text
        end
    end

    -- Update run appearance
    local function updateRunAppearance()
        if isRunning then
            runButton.BackgroundColor3 = Theme.Danger
            runButton.TextColor3 = Color3.new(1, 1, 1)
        else
            runButton.BackgroundColor3 = Theme.Success
            runButton.TextColor3 = Theme.Text
        end
    end

    -- Initialize appearances
    updateToggleAppearance()
    updatePinAppearance()
    updateRunAppearance()

    -- Button hover effects
    local function setupButtonEffects(button)
        button.MouseEnter:Connect(function()
            if not isMobile and (not isPremium or IsPremium) then
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not isMobile and (not isPremium or IsPremium) then
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
            end
        end)
    end

    setupButtonEffects(toggleButton)
    setupButtonEffects(runButton)
    setupButtonEffects(pinButton)
    setupButtonEffects(resetButton)

    -- Toggle button functionality
    toggleButton.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end
        
        isToggled = not isToggled
        updateToggleAppearance()
        
        TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
        
        if toggleCallback then
            toggleCallback(isToggled)
        end
    end)

    -- Run button functionality
    runButton.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end
        
        isRunning = not isRunning
        updateRunAppearance()
        
        TweenService:Create(runButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(runButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
        
        if runCallback then
            runCallback(isRunning)
        end
    end)

    -- Pin button functionality
    pinButton.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end
        
        isPinned = not isPinned
        updatePinAppearance()
        
        TweenService:Create(pinButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(pinButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
        
        if pinCallback then
            pinCallback(isPinned)
        end
    end)

    -- Reset button functionality
    resetButton.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end
        
        TweenService:Create(resetButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(resetButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
        
        -- Reset all states
        isToggled = false
        isRunning = false
        isPinned = false
        
        updateToggleAppearance()
        updateRunAppearance()
        updatePinAppearance()
        
        if resetCallback then
            resetCallback()
        end
    end)

    -- Create combo object with methods
    local comboObj = {
        Instance = comboFrame,
        PremiumLock = premiumLock
    }

    function comboObj:GetState()
        return {
            Toggled = isToggled,
            Running = isRunning,
            Pinned = isPinned
        }
    end

    function comboObj:SetState(toggleState, runState, pinState)
        if isPremium and not IsPremium then return end
        
        if toggleState ~= nil then
            isToggled = toggleState
            updateToggleAppearance()
        end
        
        if runState ~= nil then
            isRunning = runState
            updateRunAppearance()
        end
        
        if pinState ~= nil then
            isPinned = pinState
            updatePinAppearance()
        end
    end

    function comboObj:SetToggle(state)
        if isPremium and not IsPremium then return end
        isToggled = state
        updateToggleAppearance()
        if toggleCallback then
            toggleCallback(isToggled)
        end
    end

    function comboObj:SetRun(state)
        if isPremium and not IsPremium then return end
        isRunning = state
        updateRunAppearance()
        if runCallback then
            runCallback(isRunning)
        end
    end

    function comboObj:SetPin(state)
        if isPremium and not IsPremium then return end
        isPinned = state
        updatePinAppearance()
        if pinCallback then
            pinCallback(isPinned)
        end
    end

    function comboObj:Reset()
        if isPremium and not IsPremium then return end
        isToggled = false
        isRunning = false
        isPinned = false
        updateToggleAppearance()
        updateRunAppearance()
        updatePinAppearance()
        if resetCallback then
            resetCallback()
        end
    end

    function comboObj:SetLabel(newLabel)
        label.Text = newLabel or comboName
    end

    function comboObj:SetPremium(isPremiumFeature)
        if isPremiumFeature and not IsPremium then
            if not self.PremiumLock then
                self.PremiumLock = GuiLibrary:MarkAsPremium(comboFrame, "PREMIUM")
            end
        elseif self.PremiumLock then
            self.PremiumLock.Unlock()
            self.PremiumLock = nil
        end
    end

    function comboObj:SetButtonColors(toggleColor, runColor, pinColor, resetColor)
        if toggleColor then
            toggleButton.BackgroundColor3 = toggleColor
        end
        if runColor then
            runButton.BackgroundColor3 = runColor
        end
        if pinColor then
            pinButton.BackgroundColor3 = pinColor
        end
        if resetColor then
            resetButton.BackgroundColor3 = resetColor
        end
    end

    return comboObj
end

-- Export the library
return GuiLibrary
