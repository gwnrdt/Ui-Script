-- GUI Library - EKUVÉ STYLE (FIXED SCROLLING)
local GuiLibrary = {}
GuiLibrary.__index = GuiLibrary

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Player
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Get game name
local gameName = "ROBLOX"
local success, gameInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success and gameInfo then
    gameName = gameInfo.Name
    if #gameName > 18 then
        gameName = gameName:sub(1, 18) .. "..."
    end
end

-- Premium Status
local IsPremium = false
local PremiumThemeColor = Color3.fromRGB(0, 255, 255) -- Cyan for premium

-- Color Theme (Ekuvé Inspired - Sleek Dark Theme)
local Theme = {
    Background = Color3.fromRGB(18, 18, 18),
    Secondary = Color3.fromRGB(28, 28, 28),
    Accent = Color3.fromRGB(0, 170, 255), -- Professional blue
    AccentHover = Color3.fromRGB(0, 190, 255),
    Text = Color3.fromRGB(245, 245, 245),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(0, 200, 83),
    Danger = Color3.fromRGB(255, 59, 48),
    Premium = PremiumThemeColor,
    Warning = Color3.fromRGB(255, 149, 0),
    Disabled = Color3.fromRGB(100, 100, 100),
    Border = Color3.fromRGB(40, 40, 40)
}

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EkuveGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Check if mobile
local isMobile = UserInputService.TouchEnabled

-- Size and font adjustments (Compact and Professional)
local MOBILE_SETTINGS = {
    MainFrameSize = UDim2.new(0, 380, 0, 380),
    MainFramePosition = UDim2.new(0.5, 0, 0.5, 0),
    IconSize = UDim2.new(0, 40, 0, 40),
    FontSize = 8,
    TitleFontSize = 12,
    TabWidth = 90
}

local DESKTOP_SETTINGS = {
    MainFrameSize = UDim2.new(0, 460, 0, 560),
    MainFramePosition = UDim2.new(1, -470, 0, 20), -- Right side
    IconSize = UDim2.new(0, 45, 0, 45),
    FontSize = 13,
    TitleFontSize = 18,
    TabWidth = 100
}

local settings = isMobile and MOBILE_SETTINGS or DESKTOP_SETTINGS

-- Main Container (Sleek Dark Theme)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = settings.MainFrameSize
mainFrame.Position = settings.MainFramePosition
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

if isMobile then
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

-- Sharp Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = mainFrame

-- Thin Border
local border = Instance.new("UIStroke")
border.Name = "Border"
border.Color = Theme.Border
border.Thickness = 1
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
border.Parent = mainFrame

-- Title Bar (Minimalist Professional)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Theme.Secondary
titleBar.BackgroundTransparency = 0
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Title bar top corners only
local titleTopCorner = Instance.new("UICorner")
titleTopCorner.CornerRadius = UDim.new(0, 4)
titleTopCorner.Parent = titleBar

-- Title bar mask for bottom straight edge
local titleMask = Instance.new("Frame")
titleMask.Name = "TitleMask"
titleMask.Size = UDim2.new(1, 0, 1, 5)
titleMask.Position = UDim2.new(0, 0, 0, 0)
titleMask.BackgroundColor3 = Theme.Secondary
titleMask.BackgroundTransparency = 0
titleMask.BorderSizePixel = 0
titleMask.Parent = titleBar

-- Title with subtle gradient effect
local titleContainer = Instance.new("Frame")
titleContainer.Name = "TitleContainer"
titleContainer.Size = UDim2.new(0.7, 0, 1, 0)
titleContainer.Position = UDim2.new(0, 0, 0, 0)
titleContainer.BackgroundTransparency = 1
titleContainer.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -15, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SFY Hub Library"
title.TextColor3 = Theme.Accent
title.TextSize = settings.TitleFontSize
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.Parent = titleContainer

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, -15, 0, 12)
subtitle.Position = UDim2.new(0, 15, 1, -14)
subtitle.BackgroundTransparency = 1
subtitle.Text = "by Maya4pa2"
subtitle.TextColor3 = Theme.TextSecondary
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = titleContainer

-- Game Name Display (Minimal)
local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Name = "GameName"
gameNameLabel.Size = UDim2.new(0.25, -5, 0, 20)
gameNameLabel.Position = UDim2.new(0.5, 20, 0.5, -10)
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.Text = gameName
gameNameLabel.TextColor3 = Theme.Accent
gameNameLabel.TextSize = 15
gameNameLabel.Font = Enum.Font.Gotham
gameNameLabel.TextXAlignment = Enum.TextXAlignment.Right
gameNameLabel.Parent = titleBar

-- Premium Badge (Minimal)
local premiumBadge = Instance.new("Frame")
premiumBadge.Name = "PremiumBadge"
premiumBadge.Size = UDim2.new(0, 70, 0, 16)
premiumBadge.Position = UDim2.new(1, -80, 0.5, -8)
premiumBadge.BackgroundColor3 = Theme.Premium
premiumBadge.BackgroundTransparency = 0.2
premiumBadge.BorderSizePixel = 0
premiumBadge.Visible = false
premiumBadge.Parent = titleBar

local premiumCorner = Instance.new("UICorner")
premiumCorner.CornerRadius = UDim.new(0, 3)
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

-- Control Buttons Container
local controlButtons = Instance.new("Frame")
controlButtons.Name = "ControlButtons"
controlButtons.Size = UDim2.new(0, 50, 1, 0)
controlButtons.Position = UDim2.new(1, -55, 0, 0)
controlButtons.BackgroundTransparency = 1
controlButtons.Parent = titleBar

-- Minimize Button (Clean)
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 22, 0, 22)
minimizeButton.Position = UDim2.new(0, -5, 0.5, -11)
minimizeButton.BackgroundColor3 = Theme.Secondary
minimizeButton.BackgroundTransparency = 0
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Theme.TextSecondary
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.GothamSemibold
minimizeButton.Parent = controlButtons
 
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 3)
minimizeCorner.Parent = minimizeButton

local minimizeBorder = Instance.new("UIStroke")
minimizeBorder.Color = Theme.Border
minimizeBorder.Thickness = 1
minimizeBorder.Parent = minimizeButton

-- Close Button (Clean)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(1, -26, 0.5, -11)
closeButton.BackgroundColor3 = Theme.Secondary
closeButton.BackgroundTransparency = 0
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Theme.TextSecondary
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamSemibold
closeButton.Parent = controlButtons

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 3)
closeCorner.Parent = closeButton

local closeBorder = Instance.new("UIStroke")
closeBorder.Color = Theme.Border
closeBorder.Thickness = 1
closeBorder.Parent = closeButton
 
-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, 0, 1, -38)
contentArea.Position = UDim2.new(0, 0, 0, 38)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame
 
-- Tab Container (Left Side - Minimalist)
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, settings.TabWidth, 1, 0)
tabContainer.Position = UDim2.new(0, 0, 0, 0)
tabContainer.BackgroundColor3 = Theme.Background
tabContainer.BackgroundTransparency = 0
tabContainer.BorderSizePixel = 0
tabContainer.ScrollBarThickness = 2
tabContainer.ScrollBarImageColor3 = Theme.Accent
tabContainer.ScrollBarImageTransparency = 0.7
tabContainer.Parent = contentArea
 
local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 3)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer
 
local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 8)
tabPadding.PaddingBottom = UDim.new(0, 8)
tabPadding.PaddingLeft = UDim.new(0, 5)
tabPadding.PaddingRight = UDim.new(0, 5)
tabPadding.Parent = tabContainer

-- Vertical Separator
local separator = Instance.new("Frame")
separator.Name = "Separator"
separator.Size = UDim2.new(0, 1, 1, 0)
separator.Position = UDim2.new(0, settings.TabWidth, 0, 0)
separator.BackgroundColor3 = Theme.Border
separator.BackgroundTransparency = 0
separator.BorderSizePixel = 0
separator.Parent = contentArea

-- Tab Content Area - FIXED SCROLLING
local tabContent = Instance.new("ScrollingFrame")
tabContent.Name = "TabContent"
tabContent.Size = UDim2.new(1, -settings.TabWidth - 6, 1, 0)
tabContent.Position = UDim2.new(0, settings.TabWidth + 5, 0, 0)
tabContent.BackgroundTransparency = 1
tabContent.ScrollBarThickness = 4
tabContent.ScrollBarImageColor3 = Theme.Accent
tabContent.ScrollBarImageTransparency = 0.7
tabContent.VerticalScrollBarInset = Enum.ScrollBarInset.Always
tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContent.Parent = contentArea

-- Minimized Icon (Clean and Professional)
local minimizedIcon = Instance.new("TextButton")
minimizedIcon.Name = "MinimizedIcon"
minimizedIcon.Size = settings.IconSize
minimizedIcon.AnchorPoint = Vector2.new(1, 0) -- Align the right edge
minimizedIcon.Position = UDim2.new(1, -20, 0, 20) -- Right side, 20px offset
minimizedIcon.BackgroundColor3 = Theme.Background
minimizedIcon.BackgroundTransparency = 0
minimizedIcon.BorderSizePixel = 0
minimizedIcon.Text = ""
minimizedIcon.TextColor3 = Theme.Accent
minimizedIcon.TextSize = 12
minimizedIcon.TextScaled = false
minimizedIcon.Visible = false
minimizedIcon.Parent = screenGui


local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 4)
iconCorner.Parent = minimizedIcon

local iconBorder = Instance.new("UIStroke")
iconBorder.Color = Theme.Border
iconBorder.Thickness = 1
iconBorder.Parent = minimizedIcon

-- Create a container for the icon text
local iconTextContainer = Instance.new("Frame")
iconTextContainer.Name = "IconTextContainer"
iconTextContainer.Size = UDim2.new(1, 0, 1, 0)
iconTextContainer.BackgroundTransparency = 1
iconTextContainer.Parent = minimizedIcon

-- Main SFY text (larger and centered)
local iconMainText = Instance.new("TextLabel")
iconMainText.Name = "IconMainText"
iconMainText.Size = UDim2.new(1, 0, 0.7, 0)
iconMainText.Position = UDim2.new(0, 0, 0, 0)
iconMainText.BackgroundTransparency = 1
iconMainText.Text = "SFY"
iconMainText.TextColor3 = Theme.Accent
iconMainText.TextSize = isMobile and 16 or 18
iconMainText.Font = Enum.Font.GothamSemibold
iconMainText.TextScaled = false
iconMainText.Parent = iconTextContainer

-- MENU subtitle (smaller, below SFY)
local iconSubtitle = Instance.new("TextLabel")
iconSubtitle.Name = "IconSubtitle"
iconSubtitle.Size = UDim2.new(1, 0, 0.3, 0)
iconSubtitle.Position = UDim2.new(0, 0, 0.7, 0)
iconSubtitle.BackgroundTransparency = 1
iconSubtitle.Text = "MENU"
iconSubtitle.TextColor3 = Theme.TextSecondary
iconSubtitle.TextSize = isMobile and 8 or 9
iconSubtitle.Font = Enum.Font.Gotham
iconSubtitle.TextScaled = false
iconSubtitle.Parent = iconTextContainer

-- Optional: Add a subtle glow effect to the icon
local iconGlow = Instance.new("ImageLabel")
iconGlow.Name = "IconGlow"
iconGlow.Size = UDim2.new(1, 10, 1, 10)
iconGlow.Position = UDim2.new(0, -5, 0, -5)
iconGlow.BackgroundTransparency = 1
iconGlow.Image = "rbxassetid://8992230671" -- Default glow image
iconGlow.ImageColor3 = Theme.Accent
iconGlow.ImageTransparency = 0.8
iconGlow.ScaleType = Enum.ScaleType.Slice
iconGlow.SliceScale = 0.02
iconGlow.Visible = false
iconGlow.Parent = minimizedIcon

-- Variables
local isMinimized = false
local currentTab = nil
local tabs = {}
local buttons = {}
local isDestroyed = false
local premiumLockedElements = {}
local lastContentHeight = 0

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

-- Auto-update tab content scroll size
tabContent:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
    if isDestroyed then return end
    -- Ensure scroll bar is visible when needed
    local canvasHeight = tabContent.CanvasSize.Y.Offset
    local windowHeight = tabContent.AbsoluteWindowSize.Y
    
    if canvasHeight > windowHeight then
        tabContent.ScrollBarThickness = 4
    else
        tabContent.ScrollBarThickness = 0
    end
end)

-- Button hover effects
local function setupCleanButton(button)
    button.MouseEnter:Connect(function()
        if not isMobile then
            TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isMobile then
            TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = Theme.Secondary,
                TextColor3 = Theme.TextSecondary
            }):Play()
        end
    end)
end

-- Setup control buttons
setupCleanButton(minimizeButton)
setupCleanButton(closeButton)

-- Library Functions
function GuiLibrary.new(title)
    local self = setmetatable({}, GuiLibrary)
    
    self.title = title or "SFY Library"
    self.tabs = {}
    self.currentTab = nil
    
    -- Don't update the minimized icon with the library title
    -- Keep it as "SFY"
    
    return self
end

-- Set Premium Status
function GuiLibrary:SetPremiumStatus(isPremium)
    IsPremium = isPremium
    
    if IsPremium then
        -- Change theme to premium colors
        Theme.Accent = Theme.Premium
        Theme.AccentHover = Color3.fromRGB(0, 255, 255)
        
        -- Show premium badge
        premiumBadge.Visible = true
        
        -- Update UI elements
        title.TextColor3 = Theme.Premium
        minimizedIcon.TextColor3 = Theme.Premium
        
        -- Update scroll bars
        tabContainer.ScrollBarImageColor3 = Theme.Premium
        tabContent.ScrollBarImageColor3 = Theme.Premium
        
        print("PREMIUM FEATURES UNLOCKED")
    else
        -- Reset to free theme
        Theme.Accent = Color3.fromRGB(0, 170, 255)
        Theme.AccentHover = Color3.fromRGB(0, 190, 255)
        
        -- Hide premium badge
        premiumBadge.Visible = false
        
        -- Reset UI elements
        title.TextColor3 = Theme.Accent
        minimizedIcon.TextColor3 = Theme.Accent
        
        -- Update scroll bars
        tabContainer.ScrollBarImageColor3 = Theme.Accent
        tabContent.ScrollBarImageColor3 = Theme.Accent
        
        print("FREE VERSION")
    end
end

-- Create Tab (Clean Style) - UPDATED FOR PROPER SCROLLING
function GuiLibrary:CreateTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName
    tabButton.Size = UDim2.new(1, 0, 0, 34)
    tabButton.BackgroundColor3 = Theme.Secondary
    tabButton.BackgroundTransparency = 0
    tabButton.BorderSizePixel = 0
    tabButton.Text = tabName
    tabButton.TextColor3 = Theme.TextSecondary
    tabButton.TextSize = 12
    tabButton.Font = Enum.Font.Gotham
    tabButton.LayoutOrder = #tabs
    tabButton.Parent = tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 3)
    tabCorner.Parent = tabButton
    
    local tabBorder = Instance.new("UIStroke")
    tabBorder.Name = "TabBorder"
    tabBorder.Color = Theme.Border
    tabBorder.Thickness = 1
    tabBorder.Parent = tabButton
    
    -- Create content container for this tab
    local tabContentContainer = Instance.new("Frame")
    tabContentContainer.Name = tabName .. "_Content"
    tabContentContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContentContainer.BackgroundTransparency = 1
    tabContentContainer.AutomaticSize = Enum.AutomaticSize.Y
    tabContentContainer.Visible = false
    tabContentContainer.Parent = tabContent
    
    -- Layout for tab content
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Name = "ContentLayout"
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = tabContentContainer
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Name = "ContentPadding"
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = tabContentContainer
    
    -- Auto-size the content container
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContentContainer.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    local tabData = {
        Button = tabButton,
        Container = tabContentContainer,
        Name = tabName
    }
    
    table.insert(tabs, tabData)
    
    -- Set as current tab if first tab
    if #tabs == 1 then
        currentTab = tabData
        tabButton.BackgroundColor3 = Theme.Accent
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBorder.Color = Theme.Accent
        tabContentContainer.Visible = true
    end
    
    -- Tab button click event
    tabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Button.BackgroundColor3 = Theme.Secondary
            currentTab.Button.TextColor3 = Theme.TextSecondary
            currentTab.Button.TabBorder.Color = Theme.Border
            currentTab.Container.Visible = false
        end
        
        currentTab = tabData
        tabButton.BackgroundColor3 = Theme.Accent
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBorder.Color = Theme.Accent
        tabContentContainer.Visible = true
        
        -- Update tab content scroll position
        tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContentContainer.AbsoluteSize.Y)
    end)
    
    -- Button hover effects
    setupCleanButton(tabButton)
    
    -- Return tab data with Frame property for compatibility
    tabData.Frame = tabContentContainer
    
    return tabData
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
-- Multi Dropdown Function (Voidware Style) with Premium Support - FIXED MOBILE COMPATIBILITY
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
 
    -- Options Frame as ScrollingFrame - IMPROVED FOR MOBILE
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0) -- Start closed
    optionsFrame.Position = UDim2.new(0, 0, 1, 3)
    optionsFrame.BackgroundColor3 = Theme.Secondary
    optionsFrame.BackgroundTransparency = 0.2
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ScrollBarThickness = isMobile and 8 or 4 -- Thicker on mobile
    optionsFrame.ScrollBarImageColor3 = Theme.Accent
    optionsFrame.ScrollBarImageTransparency = 0.5
    optionsFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    optionsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    optionsFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    optionsFrame.Visible = false
    optionsFrame.ClipsDescendants = true
    optionsFrame.ZIndex = 50
    optionsFrame.Parent = multiDropdown
 
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 4)
    optionsCorner.Parent = optionsFrame
 
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, isMobile and 6 or 3) -- More spacing on mobile
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame
 
    local optionsPadding = Instance.new("UIPadding")
    optionsPadding.PaddingTop = UDim.new(0, isMobile and 10 or 6)
    optionsPadding.PaddingBottom = UDim.new(0, isMobile and 10 or 6)
    optionsPadding.PaddingLeft = UDim.new(0, isMobile and 10 or 6)
    optionsPadding.PaddingRight = UDim.new(0, isMobile and 10 or 6)
    optionsPadding.Parent = optionsFrame
 
    local selectedOptions = {}
    local isOpen = false
 
    -- Handle default selections
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
 
    -- Create option buttons with better mobile support
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, -8, 0, isMobile and 32 or 22) -- Taller on mobile for better touch
        optionButton.BackgroundColor3 = Theme.Secondary
        optionButton.BackgroundTransparency = 0.4
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Theme.Text
        optionButton.TextSize = isMobile and 14 or 11 -- Larger text on mobile
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Font = Enum.Font.Gotham
        optionButton.LayoutOrder = i
        optionButton.ZIndex = 51
        optionButton.Parent = optionsFrame
 
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton
 
        local textPadding = Instance.new("UIPadding")
        textPadding.PaddingLeft = UDim.new(0, isMobile and 16 or 8) -- More padding on mobile
        textPadding.Parent = optionButton
 
        -- Set initial state
        if selectedOptions[option] then
            optionButton.BackgroundColor3 = Theme.Accent
            optionButton.BackgroundTransparency = 0.3
        else
            optionButton.BackgroundColor3 = Theme.Secondary
            optionButton.BackgroundTransparency = 0.4
        end
 
        -- Button interaction with improved mobile support
        local function handleOptionClick()
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
        end
 
        -- Improved mobile touch handling
        if isMobile then
            -- Use InputBegan for better touch detection
            local touchStartTime = 0
            local touchStartPos = nil
            
            optionButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    touchStartTime = tick()
                    touchStartPos = input.Position
                    
                    -- Visual feedback for touch
                    TweenService:Create(optionButton, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.2
                    }):Play()
                end
            end)
            
            optionButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local touchDuration = tick() - touchStartTime
                    
                    -- Reset visual feedback
                    TweenService:Create(optionButton, TweenInfo.new(0.1), {
                        BackgroundTransparency = selectedOptions[option] and 0.3 or 0.4
                    }):Play()
                    
                    -- Only register as click if it was a quick tap (not a scroll)
                    if touchDuration < 0.3 then
                        handleOptionClick()
                    end
                end
            end)
        else
            -- Desktop mouse handling
            optionButton.MouseButton1Click:Connect(handleOptionClick)
        end
    end
 
    -- Calculate optimal dropdown height based on content and screen size
    local function calculateOptimalHeight()
        local optionHeight = isMobile and 32 or 22
        local padding = isMobile and 20 or 12
        local maxVisibleOptions = isMobile and 4 or 6 -- Show fewer options on mobile
 
        local totalContentHeight = (#options * optionHeight) + ((#options - 1) * optionsLayout.Padding.Offset) + padding
        local maxHeight = optionHeight * maxVisibleOptions + padding
 
        return math.min(totalContentHeight, maxHeight)
    end
 
    -- Toggle dropdown with smooth animations
    local function toggleDropdown()
        if isPremium and not IsPremium then return end
 
        isOpen = not isOpen
 
        if isOpen then
            -- Open dropdown
            optionsFrame.Visible = true
            local targetHeight = calculateOptimalHeight()
 
            -- Animate arrow and dropdown
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
 
            -- Increase ZIndex to appear above other elements
            multiDropdown.ZIndex = 60
            optionsFrame.ZIndex = 61
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("GuiObject") then
                    child.ZIndex = 62
                end
            end
 
            -- Auto-scroll to show selected options
            spawn(function()
                wait(0.25) -- Wait for animation to complete
                if optionsFrame.CanvasSize.Y.Offset > optionsFrame.AbsoluteWindowSize.Y then
                    -- Find first selected option and scroll to it
                    for i, option in ipairs(options) do
                        if selectedOptions[option] then
                            local optionHeight = isMobile and 32 or 22
                            local targetPosition = (i - 1) * (optionHeight + optionsLayout.Padding.Offset)
                            optionsFrame.CanvasPosition = Vector2.new(0, math.max(0, targetPosition - 20))
                            break
                        end
                    end
                end
            end)
 
        else
            -- Close dropdown
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
 
            spawn(function()
                wait(0.2) -- Wait for close animation
                optionsFrame.Visible = false
 
                -- Reset ZIndex
                multiDropdown.ZIndex = 20
                optionsFrame.ZIndex = 50
            end)
        end
    end
 
    -- Main dropdown click with improved mobile support
    if isMobile then
        -- Mobile touch handling for main dropdown
        local dropdownTouchStartTime = 0
        local dropdownTouchStartPos = nil
        
        multiDropdown.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dropdownTouchStartTime = tick()
                dropdownTouchStartPos = input.Position
                
                -- Visual feedback
                TweenService:Create(multiDropdown, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.3
                }):Play()
            end
        end)
        
        multiDropdown.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                local touchDuration = tick() - dropdownTouchStartTime
                
                -- Reset visual feedback
                TweenService:Create(multiDropdown, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.4
                }):Play()
                
                -- Only register as click if it was a quick tap
                if touchDuration < 0.3 then
                    toggleDropdown()
                end
            end
        end)
    else
        -- Desktop mouse handling
        multiDropdown.MouseButton1Click:Connect(toggleDropdown)
    end
 
    -- Close dropdown when clicking outside (improved for mobile)
    local function closeDropdown(input)
        if isOpen then
            local inputType = input.UserInputType
            local isRelevantInput = inputType == Enum.UserInputType.MouseButton1 or 
                                   inputType == Enum.UserInputType.Touch
 
            if isRelevantInput then
                local mousePos = input.Position
                local dropdownAbsPos = multiDropdown.AbsolutePosition
                local dropdownSize = multiDropdown.AbsoluteSize
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
 
                    spawn(function()
                        wait(0.2)
                        optionsFrame.Visible = false
                        multiDropdown.ZIndex = 20
                        optionsFrame.ZIndex = 50
                    end)
                end
            end
        end
    end
 
    UserInputService.InputBegan:Connect(closeDropdown)
 
    -- Update canvas size when options change
    optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y + optionsPadding.PaddingTop.Offset + optionsPadding.PaddingBottom.Offset)
    end)
 
    -- Create dropdown object with methods
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
 
        -- Update visual state
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
 
    function multiDropdownObj:IsOpen()
        return isOpen
    end
 
    function multiDropdownObj:Close()
        if isOpen then
            isOpen = false
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
 
            spawn(function()
                wait(0.2)
                optionsFrame.Visible = false
                multiDropdown.ZIndex = 20
                optionsFrame.ZIndex = 50
            end)
        end
    end
 
    function multiDropdownObj:Open()
        if not isOpen then
            toggleDropdown()
        end
    end
 
    function multiDropdownObj:RefreshOptions(newOptions)
        if isPremium and not IsPremium then return end
 
        -- Clear existing options
        for _, child in pairs(optionsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
 
        -- Update options
        options = newOptions or options
 
        -- Recreate option buttons
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option_" .. option
            optionButton.Size = UDim2.new(1, -8, 0, isMobile and 32 or 22)
            optionButton.BackgroundColor3 = Theme.Secondary
            optionButton.BackgroundTransparency = 0.4
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = Theme.Text
            optionButton.TextSize = isMobile and 14 or 11
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.Font = Enum.Font.Gotham
            optionButton.LayoutOrder = i
            optionButton.ZIndex = 51
            optionButton.Parent = optionsFrame
 
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 4)
            optionCorner.Parent = optionButton
 
            local textPadding = Instance.new("UIPadding")
            textPadding.PaddingLeft = UDim.new(0, isMobile and 16 or 8)
            textPadding.Parent = optionButton
 
            -- Set state based on current selections
            if selectedOptions[option] then
                optionButton.BackgroundColor3 = Theme.Accent
                optionButton.BackgroundTransparency = 0.3
            end
 
            -- Improved mobile touch handling for new buttons
            if isMobile then
                local touchStartTime = 0
                local touchStartPos = nil
                
                optionButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        touchStartTime = tick()
                        touchStartPos = input.Position
                        
                        TweenService:Create(optionButton, TweenInfo.new(0.1), {
                            BackgroundTransparency = 0.2
                        }):Play()
                    end
                end)
                
                optionButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        local touchDuration = tick() - touchStartTime
                        
                        TweenService:Create(optionButton, TweenInfo.new(0.1), {
                            BackgroundTransparency = selectedOptions[option] and 0.3 or 0.4
                        }):Play()
                        
                        if touchDuration < 0.3 then
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
                        end
                    end
                end)
            else
                optionButton.MouseButton1Click:Connect(function()
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
        end
 
        -- Update display
        updateDisplayText()
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
    badge.Position = UDim2.new(0, 0, 0, 3)
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



-- Group Container Function (Voidware Style)
function GuiLibrary:CreateGroup(tab, groupName, groupHeight)
    local groupFrame = Instance.new("Frame")
    groupFrame.Name = "Group_" .. groupName
    groupFrame.Size = UDim2.new(1, 0, 0, groupHeight or 150)
    groupFrame.BackgroundTransparency = 1
    groupFrame.Parent = tab.Frame

    -- Main container with professional styling
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel = 0
    container.Parent = groupFrame

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container

    -- Subtle border for depth
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderColor3 = Color3.fromRGB(45, 45, 50)
    border.BorderSizePixel = 1
    border.Parent = container

    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 8)
    borderCorner.Parent = border

    -- Header with accent
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Parent = container

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header

    -- Header top corner mask to only round top corners
    local headerMask = Instance.new("Frame")
    headerMask.Name = "HeaderMask"
    headerMask.Size = UDim2.new(1, 0, 1, 8)
    headerMask.Position = UDim2.new(0, 0, 0, 0)
    headerMask.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    headerMask.BorderSizePixel = 0
    headerMask.Parent = header

    -- Group title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = groupName
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.Parent = header

    -- Accent line under header
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(1, 0, 0, 1)
    accentLine.Position = UDim2.new(0, 0, 1, 0)
    accentLine.BackgroundColor3 = Theme.Accent
    accentLine.BackgroundTransparency = 0.3
    accentLine.BorderSizePixel = 0
    accentLine.Parent = header

    -- Content area
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -16, 1, -44)
    content.Position = UDim2.new(0, 8, 0, 36)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Theme.Accent
    content.ScrollBarImageTransparency = 0.5
    content.Parent = container

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = content

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingLeft = UDim.new(0, 4)
    contentPadding.PaddingRight = UDim.new(0, 4)
    contentPadding.Parent = content

    -- Update content size
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Create group object with methods
    local groupObj = {}

    function groupObj:AddButton(buttonName, callback, isPremium)
        return GuiLibrary:CreateButton({Frame = content}, buttonName, callback, isPremium)
    end

    function groupObj:AddToggle(toggleName, defaultState, callback, isPremium)
        return GuiLibrary:CreateToggle({Frame = content}, toggleName, defaultState, callback, isPremium)
    end

    function groupObj:AddLabel(labelText)
        return GuiLibrary:CreateLabel({Frame = content}, labelText)
    end

    function groupObj:AddSeparator(separatorName)
        return GuiLibrary:CreateSeparator({Frame = content}, separatorName)
    end

    function groupObj:AddDropdown(dropdownName, options, defaultSelection, callback, isPremium)
        return GuiLibrary:CreateDropdown({Frame = content}, dropdownName, options, defaultSelection, callback, isPremium)
    end

    function groupObj:AddSlider(sliderName, minValue, maxValue, defaultValue, callback, isPremium)
        return GuiLibrary:CreateSlider({Frame = content}, sliderName, minValue, maxValue, defaultValue, callback, isPremium)
    end

    function groupObj:AddInput(inputName, placeholder, defaultValue, callback, isPremium)
        return GuiLibrary:CreateInput({Frame = content}, inputName, placeholder, defaultValue, callback, isPremium)
    end

    function groupObj:AddMultiDropdown(dropdownName, options, defaultSelections, callback, isPremium)
        return GuiLibrary:CreateMultiDropdown({Frame = content}, dropdownName, options, defaultSelections, callback, isPremium)
    end

    function groupObj:AddCombo(comboName, toggleCallback, action1Callback, action2Callback, isPremium)
        return GuiLibrary:CreateCombo({Frame = content}, comboName, toggleCallback, action1Callback, action2Callback, isPremium)
    end

    function groupObj:AddProgressBar(progressName, minValue, maxValue, defaultValue, callback)
        return GuiLibrary:CreateProgressBar({Frame = content}, progressName, minValue, maxValue, defaultValue, callback)
    end

    function groupObj:SetHeight(newHeight)
        groupFrame.Size = UDim2.new(1, 0, 0, newHeight)
    end

    function groupObj:GetHeight()
        return groupFrame.Size.Y.Offset
    end

    function groupObj:SetVisible(visible)
        groupFrame.Visible = visible
    end

    function groupObj:IsVisible()
        return groupFrame.Visible
    end

    function groupObj:SetTitle(newTitle)
        title.Text = newTitle
    end

    function groupObj:GetTitle()
        return title.Text
    end

    function groupObj:SetAccentColor(color)
        accentLine.BackgroundColor3 = color
    end

    function groupObj:Clear()
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                child:Destroy()
            end
        end
    end

    function groupObj:GetContentCount()
        local count = 0
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                count = count + 1
            end
        end
        return count
    end

    function groupObj:GetInstance()
        return groupFrame
    end

    function groupObj:Destroy()
        groupFrame:Destroy()
    end

    return groupObj
end
-- Collapsible Group Function (Voidware Style) - UPDATED WITH COMBO SUPPORT
function GuiLibrary:CreateCollapsibleGroup(tab, groupName, defaultExpanded, groupHeight)
    local isExpanded = defaultExpanded ~= false -- Default to expanded
    
    local groupFrame = Instance.new("Frame")
    groupFrame.Name = "CollapsibleGroup_" .. groupName
    groupFrame.Size = UDim2.new(1, 0, 0, isExpanded and (groupHeight or 150) or 36)
    groupFrame.BackgroundTransparency = 1
    groupFrame.Parent = tab.Frame

    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel = 0
    container.Parent = groupFrame

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container

    -- Border
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderColor3 = Color3.fromRGB(45, 45, 50)
    border.BorderSizePixel = 1
    border.Parent = container

    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 8)
    borderCorner.Parent = border

    -- Header with toggle functionality
    local header = Instance.new("TextButton")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Text = ""
    header.Parent = container

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header

    -- Header mask for rounded corners
    local headerMask = Instance.new("Frame")
    headerMask.Name = "HeaderMask"
    headerMask.Size = UDim2.new(1, 0, 1, isExpanded and 8 or 0)
    headerMask.Position = UDim2.new(0, 0, 0, 0)
    headerMask.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    headerMask.BorderSizePixel = 0
    headerMask.Parent = header

    -- Group title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = groupName
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.Parent = header

    -- Expand/collapse icon
    local expandIcon = Instance.new("TextLabel")
    expandIcon.Name = "ExpandIcon"
    expandIcon.Size = UDim2.new(0, 20, 0, 20)
    expandIcon.Position = UDim2.new(1, -25, 0.5, -10)
    expandIcon.BackgroundTransparency = 1
    expandIcon.Text = isExpanded and "▼" or "►"
    expandIcon.TextColor3 = Theme.Accent
    expandIcon.TextSize = 12
    expandIcon.Font = Enum.Font.GothamBold
    expandIcon.Parent = header

    -- Accent line
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(1, 0, 0, 1)
    accentLine.Position = UDim2.new(0, 0, 1, 0)
    accentLine.BackgroundColor3 = Theme.Accent
    accentLine.BackgroundTransparency = 0.3
    accentLine.BorderSizePixel = 0
    accentLine.Visible = isExpanded
    accentLine.Parent = header

    -- Content area
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -16, 1, -44)
    content.Position = UDim2.new(0, 8, 0, 36)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Theme.Accent
    content.ScrollBarImageTransparency = 0.5
    content.Visible = isExpanded
    content.Parent = container

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = content

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingLeft = UDim.new(0, 4)
    contentPadding.PaddingRight = UDim.new(0, 4)
    contentPadding.Parent = content

    -- Update content size
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Toggle function
    local function toggleExpanded()
        isExpanded = not isExpanded
        
        if isExpanded then
            -- Expand
            groupFrame.Size = UDim2.new(1, 0, 0, groupHeight or 150)
            expandIcon.Text = "▼"
            accentLine.Visible = true
            content.Visible = true
            headerMask.Size = UDim2.new(1, 0, 1, 8)
            
            TweenService:Create(groupFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, groupHeight or 150)
            }):Play()
        else
            -- Collapse
            expandIcon.Text = "►"
            accentLine.Visible = false
            content.Visible = false
            headerMask.Size = UDim2.new(1, 0, 1, 0)
            
            TweenService:Create(groupFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 36)
            }):Play()
        end
    end

    header.MouseButton1Click:Connect(toggleExpanded)

    -- Create collapsible group object with methods
    local collapsibleGroupObj = {}

    -- NEW: Add Combo method
    function collapsibleGroupObj:AddCombo(comboName, toggleCallback, action1Callback, action2Callback, isPremium)
        return GuiLibrary:CreateCombo({Frame = content}, comboName, toggleCallback, action1Callback, action2Callback, isPremium)
    end

    function collapsibleGroupObj:AddButton(buttonName, callback, isPremium)
        return GuiLibrary:CreateButton({Frame = content}, buttonName, callback, isPremium)
    end

    function collapsibleGroupObj:AddToggle(toggleName, defaultState, callback, isPremium)
        return GuiLibrary:CreateToggle({Frame = content}, toggleName, defaultState, callback, isPremium)
    end

    function collapsibleGroupObj:AddLabel(labelText)
        return GuiLibrary:CreateLabel({Frame = content}, labelText)
    end

    function collapsibleGroupObj:AddSeparator(separatorName)
        return GuiLibrary:CreateSeparator({Frame = content}, separatorName)
    end

    function collapsibleGroupObj:AddDropdown(dropdownName, options, defaultSelection, callback, isPremium)
        return GuiLibrary:CreateDropdown({Frame = content}, dropdownName, options, defaultSelection, callback, isPremium)
    end

    function collapsibleGroupObj:AddSlider(sliderName, minValue, maxValue, defaultValue, callback, isPremium)
        return GuiLibrary:CreateSlider({Frame = content}, sliderName, minValue, maxValue, defaultValue, callback, isPremium)
    end

    function collapsibleGroupObj:AddInput(inputName, placeholder, defaultValue, callback, isPremium)
        return GuiLibrary:CreateInput({Frame = content}, inputName, placeholder, defaultValue, callback, isPremium)
    end

    function collapsibleGroupObj:AddMultiDropdown(dropdownName, options, defaultSelections, callback, isPremium)
        return GuiLibrary:CreateMultiDropdown({Frame = content}, dropdownName, options, defaultSelections, callback, isPremium)
    end

    function collapsibleGroupObj:AddProgressBar(progressName, minValue, maxValue, defaultValue, callback)
        return GuiLibrary:CreateProgressBar({Frame = content}, progressName, minValue, maxValue, defaultValue, callback)
    end

    function collapsibleGroupObj:Expand()
        if not isExpanded then
            toggleExpanded()
        end
    end

    function collapsibleGroupObj:Collapse()
        if isExpanded then
            toggleExpanded()
        end
    end

    function collapsibleGroupObj:IsExpanded()
        return isExpanded
    end

    function collapsibleGroupObj:SetHeight(newHeight)
        if isExpanded then
            groupFrame.Size = UDim2.new(1, 0, 0, newHeight)
        end
        groupHeight = newHeight
    end

    function collapsibleGroupObj:SetTitle(newTitle)
        title.Text = newTitle
    end

    function collapsibleGroupObj:GetTitle()
        return title.Text
    end

    function collapsibleGroupObj:SetAccentColor(color)
        accentLine.BackgroundColor3 = color
        expandIcon.TextColor3 = color
    end

    function collapsibleGroupObj:Clear()
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                child:Destroy()
            end
        end
    end

    function collapsibleGroupObj:GetContentCount()
        local count = 0
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                count = count + 1
            end
        end
        return count
    end

    function collapsibleGroupObj:GetInstance()
        return groupFrame
    end

    function collapsibleGroupObj:Destroy()
        groupFrame:Destroy()
    end

    return collapsibleGroupObj
end


--NewCombo
-- Create Combo Function (Professional Style) - Label, Toggle, Action Buttons with Keybind below
function GuiLibrary:CreateCombo(tab, comboName, toggleCallback, action1Callback, action2Callback, isPremium, defaultKeybind)
    local comboFrame = Instance.new("Frame")
    comboFrame.Name = "Combo_" .. comboName
    comboFrame.Size = UDim2.new(1, 0, 0, 72)
    comboFrame.BackgroundTransparency = 1
    comboFrame.Parent = tab.Frame

    -- Main container with professional dark theme
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    background.BackgroundTransparency = 0
    background.BorderSizePixel = 0
    background.Parent = comboFrame

    local backgroundCorner = Instance.new("UICorner")
    backgroundCorner.CornerRadius = UDim.new(0, 6)
    backgroundCorner.Parent = background

    -- Subtle border for depth
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderColor3 = Color3.fromRGB(45, 45, 50)
    border.BorderSizePixel = 1
    border.Parent = background

    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 6)
    borderCorner.Parent = border

    -- Top row container: Label - Toggle - Button1 - Button2
    local topRow = Instance.new("Frame")
    topRow.Name = "TopRow"
    topRow.Size = UDim2.new(1, -20, 0, 32)
    topRow.Position = UDim2.new(0, 10, 0, 8)
    topRow.BackgroundTransparency = 1
    topRow.Parent = comboFrame

    -- Professional label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.25, -6, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = comboName
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = topRow

    -- Toggle Button (ON/OFF) - maintains state
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0.2, -4, 0.7, 0)
    toggleButton.Position = UDim2.new(0.50, 4, 0.15, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    toggleButton.BackgroundTransparency = 0
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    toggleButton.TextSize = 10
    toggleButton.Font = Enum.Font.GothamMedium
    toggleButton.Parent = topRow

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleButton

    -- Action Button 1 (Press button - no toggle state)
    local action1Button = Instance.new("TextButton")
    action1Button.Name = "Action1"
    action1Button.Size = UDim2.new(0.15, -2, 0.7, 0)
    action1Button.Position = UDim2.new(0.70, 4, 0.15, 0)
    action1Button.BackgroundColor3 = Color3.fromRGB(40, 120, 80)
    action1Button.BackgroundTransparency = 0
    action1Button.BorderSizePixel = 0
    action1Button.Text = "RUN"
    action1Button.TextColor3 = Color3.fromRGB(230, 230, 230)
    action1Button.TextSize = 10
    action1Button.Font = Enum.Font.GothamMedium
    action1Button.Parent = topRow

    local action1Corner = Instance.new("UICorner")
    action1Corner.CornerRadius = UDim.new(0, 4)
    action1Corner.Parent = action1Button

    -- Action Button 2 (Press button - no toggle state)
    local action2Button = Instance.new("TextButton")
    action2Button.Name = "Action2"
    action2Button.Size = UDim2.new(0.15, -2, 0.7, 0)
    action2Button.Position = UDim2.new(0.85, 4, 0.15, 0)
    action2Button.BackgroundColor3 = Color3.fromRGB(120, 80, 80)
    action2Button.BackgroundTransparency = 0
    action2Button.BorderSizePixel = 0
    action2Button.Text = "RESET"
    action2Button.TextColor3 = Color3.fromRGB(230, 230, 230)
    action2Button.TextSize = 10
    action2Button.Font = Enum.Font.GothamMedium
    action2Button.Parent = topRow

    local action2Corner = Instance.new("UICorner")
    action2Corner.CornerRadius = UDim.new(0, 4)
    action2Corner.Parent = action2Button

    -- Keybind container (bottom line)
    local keybindContainer = Instance.new("Frame")
    keybindContainer.Name = "KeybindContainer"
    keybindContainer.Size = UDim2.new(1, -20, 0, 20)
    keybindContainer.Position = UDim2.new(0, 10, 0, 44)
    keybindContainer.BackgroundTransparency = 1
    keybindContainer.Parent = comboFrame

    -- Keybind label
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Name = "KeybindLabel"
    keybindLabel.Size = UDim2.new(0.3, 0, 1, 0)
    keybindLabel.Position = UDim2.new(0, 0, 0, 0)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Text = "Keybind:"
    keybindLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    keybindLabel.TextSize = 10
    keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    keybindLabel.Font = Enum.Font.Gotham
    keybindLabel.Parent = keybindContainer

    -- Keybind display button (shows current keybind and allows changing)
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Size = UDim2.new(0.3, 0, 0.7, 0)
    keybindButton.Position = UDim2.new(0.3, 4, 0.15, 0)
    keybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    keybindButton.BackgroundTransparency = 0
    keybindButton.BorderSizePixel = 0
    keybindButton.TextColor3 = Color3.fromRGB(230, 230, 230)
    keybindButton.TextSize = 10
    keybindButton.Font = Enum.Font.GothamMedium
    keybindButton.Parent = keybindContainer

    local keybindButtonCorner = Instance.new("UICorner")
    keybindButtonCorner.CornerRadius = UDim.new(0, 4)
    keybindButtonCorner.Parent = keybindButton

    -- Keybind status (shows if listening for input)
    local keybindStatus = Instance.new("TextLabel")
    keybindStatus.Name = "KeybindStatus"
    keybindStatus.Size = UDim2.new(0.4, 0, 1, 0)
    keybindStatus.Position = UDim2.new(0.6, 8, 0, 0)
    keybindStatus.BackgroundTransparency = 1
    keybindStatus.Text = "Click to change"
    keybindStatus.TextColor3 = Color3.fromRGB(120, 120, 120)
    keybindStatus.TextSize = 9
    keybindStatus.TextXAlignment = Enum.TextXAlignment.Right
    keybindStatus.Font = Enum.Font.Gotham
    keybindStatus.Parent = keybindContainer

    -- State variables
    local isToggled = false
    local currentKeybind = defaultKeybind or Enum.KeyCode.U
    local isListeningForInput = false
    local keybindConnection = nil
    local comboId = comboName:gsub("%s+", "_"):upper() -- Create unique ID for saving

    -- Function to get key name for display
    local function getKeyName(keyCode)
        local keyName = tostring(keyCode):gsub("Enum.KeyCode.", "")
        return keyName
    end

    -- Function to convert key string to Enum.KeyCode
   function stringToKeyCode(keyString)
    for _, key in pairs(Enum.KeyCode:GetEnumItems()) do
        if tostring(key) == "Enum.KeyCode." .. keyString then
            return key
        end
    end
    
    -- Manual mapping for keys that might not be in Enum
    local specialKeys = {
        ["INSERT"] = Enum.KeyCode.Insert,
        ["DELETE"] = Enum.KeyCode.Delete,
        ["HOME"] = Enum.KeyCode.Home,
        ["END"] = Enum.KeyCode.End,
        ["PAGEUP"] = Enum.KeyCode.PageUp,
        ["PAGEDOWN"] = Enum.KeyCode.PageDown,
        ["PRINT"] = Enum.KeyCode.Print,
        ["SCROLLLOCK"] = Enum.KeyCode.ScrollLock,
        ["PAUSE"] = Enum.KeyCode.Pause,
        ["CAPSLOCK"] = Enum.KeyCode.CapsLock,
        ["NUMlock"] = Enum.KeyCode.NumLock,
    }
    
    if specialKeys[keyString:upper()] then
        return specialKeys[keyString:upper()]
    end
    
    return Enum.KeyCode.U -- Fallback
end

    -- Update keybind display
    local function updateKeybindDisplay()
        keybindButton.Text = getKeyName(currentKeybind)
    end

    -- Update toggle appearance
    local function updateToggleAppearance()
        if isToggled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 120, 80)
            toggleButton.TextColor3 = Color3.fromRGB(240, 240, 240)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            toggleButton.TextColor3 = Color3.fromRGB(180, 180, 180)
            toggleButton.Text = "OFF"
        end
    end

    -- Save keybind to file
    local function saveKeybindToFile()
        local success, message = pcall(function()
            -- Create config directory if it doesn't exist
            if not isfolder("KeybindConfig") then
                makefolder("KeybindConfig")
            end
            
            -- Read existing config or create new one
            local config = {}
            if isfile("KeybindConfig/keybinds.json") then
                local existingData = readfile("KeybindConfig/keybinds.json")
                config = game:GetService("HttpService"):JSONDecode(existingData)
            end
            
            -- Update or add this combo's keybind
            config[comboId] = {
                keybind = tostring(currentKeybind):gsub("Enum.KeyCode.", ""),
                timestamp = os.time()
            }
            
            -- Save to file
            writefile("KeybindConfig/keybinds.json", game:GetService("HttpService"):JSONEncode(config))
            
            -- Show save confirmation
            keybindStatus.Text = "Saved!"
            keybindStatus.TextColor3 = Color3.fromRGB(80, 180, 80)
            
            delay(2, function()
                if keybindStatus then
                    keybindStatus.Text = "Click to change"
                    keybindStatus.TextColor3 = Color3.fromRGB(120, 120, 120)
                end
            end)
        end)
        
        if not success then
            warn("Failed to save keybind: " .. tostring(message))
            keybindStatus.Text = "Save failed!"
            keybindStatus.TextColor3 = Color3.fromRGB(220, 80, 80)
        end
    end

    -- Load keybind from file
    local function loadKeybindFromFile()
        local success, message = pcall(function()
            if isfile("KeybindConfig/keybinds.json") then
                local configData = readfile("KeybindConfig/keybinds.json")
                local config = game:GetService("HttpService"):JSONDecode(configData)
                
                if config[comboId] then
                    local savedKeybind = config[comboId].keybind
                    currentKeybind = stringToKeyCode(savedKeybind)
                    updateKeybindDisplay()
                    
                    keybindStatus.Text = "Loaded!"
                    keybindStatus.TextColor3 = Color3.fromRGB(80, 180, 80)
                    
                    delay(2, function()
                        if keybindStatus then
                            keybindStatus.Text = "Click to change"
                            keybindStatus.TextColor3 = Color3.fromRGB(120, 120, 120)
                        end
                    end)
                    
                    return true
                end
            end
            return false
        end)
        
        if not success then
            warn("Failed to load keybind: " .. tostring(message))
        end
        
        return false
    end

    -- Reset keybind to default
    local function resetKeybindToDefault()
        currentKeybind = defaultKeybind or Enum.KeyCode.F
        updateKeybindDisplay()
        saveKeybindToFile() -- Save the reset
        
        keybindStatus.Text = "Reset to default"
        keybindStatus.TextColor3 = Color3.fromRGB(255, 165, 0)
        
        delay(2, function()
            if keybindStatus then
                keybindStatus.Text = "Click to change"
                keybindStatus.TextColor3 = Color3.fromRGB(120, 120, 120)
            end
        end)
    end

    -- Start listening for keybind input
    local function startKeybindListening()
        if isPremium and not IsPremium then return end
        if isListeningForInput then return end

        isListeningForInput = true
        keybindButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
        keybindStatus.Text = "Press any key..."
        keybindStatus.TextColor3 = Color3.fromRGB(70, 130, 200)

        -- Disconnect previous connection if exists
        if keybindConnection then
            keybindConnection:Disconnect()
        end

        -- Listen for key input
        keybindConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end

            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKeybind = input.KeyCode
                updateKeybindDisplay()
                
                -- Save automatically when keybind is changed
                saveKeybindToFile()
                
                -- Stop listening
                isListeningForInput = false
                keybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                
                -- Disconnect the listener
                if keybindConnection then
                    keybindConnection:Disconnect()
                    keybindConnection = nil
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Ignore mouse clicks during keybind listening
                return
            end
        end)
    end

    -- Stop listening for keybind input
    local function stopKeybindListening()
        if keybindConnection then
            keybindConnection:Disconnect()
            keybindConnection = nil
        end
        isListeningForInput = false
        keybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        keybindStatus.Text = "Click to change"
        keybindStatus.TextColor3 = Color3.fromRGB(120, 120, 120)
    end

    -- Initialize: Try to load saved keybind, otherwise use default
    local function initializeKeybind()
        local loaded = loadKeybindFromFile()
        if not loaded then
            updateKeybindDisplay() -- Use default keybind
        end
    end

    -- Call initialization
    initializeKeybind()
    updateToggleAppearance()

    -- Professional button hover effects
    local function setupButtonEffects(button, defaultColor, hoverColor)
        button.MouseEnter:Connect(function()
            if not isMobile and (not isPremium or IsPremium) then
                TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
            end
        end)

        button.MouseLeave:Connect(function()
            if not isMobile and (not isPremium or IsPremium) then
                TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = defaultColor}):Play()
            end
        end)
    end

    -- Setup button effects
    setupButtonEffects(toggleButton, 
        isToggled and Color3.fromRGB(50, 120, 80) or Color3.fromRGB(60, 60, 65),
        Color3.fromRGB(80, 80, 90))

    setupButtonEffects(action1Button,
        Color3.fromRGB(40, 120, 80),
        Color3.fromRGB(60, 140, 100))

    setupButtonEffects(action2Button,
        Color3.fromRGB(120, 80, 80),
        Color3.fromRGB(140, 100, 100))

    setupButtonEffects(keybindButton,
        Color3.fromRGB(50, 50, 55),
        Color3.fromRGB(60, 60, 70))

    -- Keybind button functionality
    keybindButton.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end

        if isListeningForInput then
            stopKeybindListening()
        else
            startKeybindListening()
        end
    end)

    -- Right-click to reset keybind
    keybindButton.MouseButton2Click:Connect(function()
        if isPremium and not IsPremium then return end
        resetKeybindToDefault()
    end)

    -- Global keybind listener for Action1 functionality
    local globalKeybindConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKeybind then
            -- Simulate Action1 button click
            if action1Callback then
                -- Visual feedback
                TweenService:Create(action1Button, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
                delay(0.1, function()
                    if action1Button then
                        TweenService:Create(action1Button, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
                    end
                end)
                
                action1Callback()
            end
        end
    end)

    -- Toggle button functionality
    toggleButton.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end

        isToggled = not isToggled
        updateToggleAppearance()

        -- Update hover colors for new state
        setupButtonEffects(toggleButton, 
            isToggled and Color3.fromRGB(50, 120, 80) or Color3.fromRGB(60, 60, 65),
            Color3.fromRGB(80, 80, 90))

        if toggleCallback then
            toggleCallback(isToggled)
        end
    end)

    -- Action Button 1 functionality (press button - no state)
    action1Button.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end

        -- Press animation
        TweenService:Create(action1Button, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
        wait(0.1)
        TweenService:Create(action1Button, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()

        if action1Callback then
            action1Callback()
        end
    end)

    -- Action Button 2 functionality (press button - no state)
    action2Button.MouseButton1Click:Connect(function()
        if isPremium and not IsPremium then return end

        -- Press animation
        TweenService:Create(action2Button, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
        wait(0.1)
        TweenService:Create(action2Button, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()

        if action2Callback then
            action2Callback()
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
            Keybind = currentKeybind
        }
    end

    function comboObj:SetState(toggleState, keybind)
        if isPremium and not IsPremium then return end

        if toggleState ~= nil then
            isToggled = toggleState
            updateToggleAppearance()
        end

        if keybind ~= nil then
            currentKeybind = keybind
            updateKeybindDisplay()
            saveKeybindToFile() -- Auto-save when set programmatically
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

    function comboObj:SetKeybind(keybind)
        if isPremium and not IsPremium then return end
        currentKeybind = keybind
        updateKeybindDisplay()
        saveKeybindToFile() -- Auto-save
    end

    function comboObj:GetKeybind()
        return currentKeybind
    end

    function comboObj:SetLabel(newLabel)
        label.Text = newLabel or comboName
    end

    function comboObj:SaveKeybind()
        saveKeybindToFile()
    end

    function comboObj:LoadKeybind()
        return loadKeybindFromFile()
    end

    function comboObj:ResetKeybind()
        resetKeybindToDefault()
    end

    function comboObj:SetButtonColors(toggleColor, action1Color, action2Color, keybindColor)
        if toggleColor then
            toggleButton.BackgroundColor3 = toggleColor
        end
        if action1Color then
            action1Button.BackgroundColor3 = action1Color
        end
        if action2Color then
            action2Button.BackgroundColor3 = action2Color
        end
        if keybindColor then
            keybindButton.BackgroundColor3 = keybindColor
        end
    end

    -- Clean up connections when destroyed
    function comboObj:Destroy()
        if globalKeybindConnection then
            globalKeybindConnection:Disconnect()
        end
        if keybindConnection then
            keybindConnection:Disconnect()
        end
        comboFrame:Destroy()
    end

    return comboObj
end

-- Global Keybind Manager Functions
GuiLibrary.KeybindManager = {}

-- Save all keybinds (useful for manual saving)
function GuiLibrary.KeybindManager:SaveAllKeybinds(comboObjects)
    local success, message = pcall(function()
        if not isfolder("KeybindConfig") then
            makefolder("KeybindConfig")
        end
        
        local config = {}
        
        -- Collect all keybinds from combo objects
        for name, combo in pairs(comboObjects) do
            if combo and combo.GetKeybind then
                local keybind = combo:GetKeybind()
                config[name] = {
                    keybind = tostring(keybind):gsub("Enum.KeyCode.", ""),
                    timestamp = os.time()
                }
            end
        end
        
        writefile("KeybindConfig/keybinds.json", game:GetService("HttpService"):JSONEncode(config))
        return true
    end)
    
    return success, message
end

-- Load all keybinds (useful for batch loading)
function GuiLibrary.KeybindManager:LoadAllKeybinds(comboObjects)
    local success, message = pcall(function()
        if not isfile("KeybindConfig/keybinds.json") then
            return false, "No saved keybinds found"
        end
        
        local configData = readfile("KeybindConfig/keybinds.json")
        local config = game:GetService("HttpService"):JSONDecode(configData)
        
        local loadedCount = 0
        for name, combo in pairs(comboObjects) do
            if combo and combo.SetKeybind and config[name] then
                local keyCode = stringToKeyCode(config[name].keybind)
                combo:SetKeybind(keyCode)
                loadedCount = loadedCount + 1
            end
        end
        
        return true, "Loaded " .. loadedCount .. " keybinds"
    end)
    
    return success, message
end

-- Reset all keybinds to default
function GuiLibrary.KeybindManager:ResetAllKeybinds(comboObjects, defaultKeybinds)
    for name, combo in pairs(comboObjects) do
        if combo and combo.ResetKeybind then
            combo:ResetKeybind()
        end
    end
end

-- Get keybind configuration file path
function GuiLibrary.KeybindManager:GetConfigPath()
    return "KeybindConfig/keybinds.json"
end

-- Check if config file exists
function GuiLibrary.KeybindManager:ConfigExists()
    return isfile("KeybindConfig/keybinds.json")
end

-- Delete config file (reset all)
function GuiLibrary.KeybindManager:DeleteConfig()
    if isfile("KeybindConfig/keybinds.json") then
        delfile("KeybindConfig/keybinds.json")
        return true
    end
    return false
end
--NewCombo
-- Enhanced Update History with Emoji & Colors
function GuiLibrary:CreateEnhancedUpdateHistory(tab, historyData)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "EnhancedUpdateHistory"
    scrollFrame.Size = UDim2.new(1, 0, 0, 300)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Theme.Accent
    scrollFrame.ScrollBarImageTransparency = 0.5
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = tab.Frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 28)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = scrollFrame
    
    -- Emoji and color mappings for different types
    local typeConfig = {
        bug = {
            emoji = "🐛",
            color = Color3.fromRGB(220, 80, 80),  -- Red for bugs
            titleColor = Color3.fromRGB(220, 80, 80),
            bgColor = Color3.fromRGB(220, 80, 80, 0.1)
        },
        update = {
            emoji = "🔄",
            color = Color3.fromRGB(0, 150, 255),  -- Blue for updates
            titleColor = Color3.fromRGB(0, 150, 255),
            bgColor = Color3.fromRGB(0, 150, 255, 0.1)
        },
        improvement = {
            emoji = "⚡",
            color = Color3.fromRGB(255, 165, 0),  -- Orange for improvements
            titleColor = Color3.fromRGB(255, 165, 0),
            bgColor = Color3.fromRGB(255, 165, 0, 0.1)
        },
        feature = {
            emoji = "✨",
            color = Color3.fromRGB(0, 200, 100),  -- Green for features
            titleColor = Color3.fromRGB(0, 200, 100),
            bgColor = Color3.fromRGB(0, 200, 100, 0.1)
        },
        security = {
            emoji = "🔒",
            color = Color3.fromRGB(150, 100, 255), -- Purple for security
            titleColor = Color3.fromRGB(150, 100, 255),
            bgColor = Color3.fromRGB(150, 100, 255, 0.1)
        },
        default = {
            emoji = "📝",
            color = Theme.TextSecondary,
            titleColor = Theme.TextSecondary,
            bgColor = Theme.Secondary
        }
    }
    
    -- Helper function to get type config
    local function getTypeConfig(changeType)
        local typeLower = string.lower(changeType or "default")
        return typeConfig[typeLower] or typeConfig.default
    end
    
    -- Sort by date (newest first)
    local sortedUpdates = {}
    for _, update in ipairs(historyData.Updates) do
        table.insert(sortedUpdates, update)
    end
    
    table.sort(sortedUpdates, function(a, b)
        return a.Date > b.Date
    end)
    
    -- Create each update section
    for i, update in ipairs(sortedUpdates) do
        -- Date section container
        local dateSection = Instance.new("Frame")
        dateSection.Name = "DateSection_" .. update.Date
        dateSection.Size = UDim2.new(1, 0, 0, 0)
        dateSection.BackgroundTransparency = 1
        dateSection.AutomaticSize = Enum.AutomaticSize.Y
        dateSection.LayoutOrder = i
        dateSection.Parent = scrollFrame
        
        -- Date header with emoji indicator
        local dateContainer = Instance.new("Frame")
        dateContainer.Name = "DateContainer"
        dateContainer.Size = UDim2.new(1, 0, 0, 32)
        dateContainer.BackgroundTransparency = 1
        dateContainer.Parent = dateSection
        
        -- Date label with colored accent
        local dateLabel = Instance.new("TextLabel")
        dateLabel.Name = "DateLabel"
        dateLabel.Size = UDim2.new(1, -40, 1, 0)
        dateLabel.Position = UDim2.new(0, 40, 0, 0)
        dateLabel.BackgroundTransparency = 1
        dateLabel.Text = update.Date
        dateLabel.TextColor3 = Theme.Text
        dateLabel.TextSize = 14
        dateLabel.Font = Enum.Font.GothamBold
        dateLabel.TextXAlignment = Enum.TextXAlignment.Left
        dateLabel.Parent = dateContainer
        
        -- Calendar emoji
        local dateEmoji = Instance.new("TextLabel")
        dateEmoji.Name = "DateEmoji"
        dateEmoji.Size = UDim2.new(0, 30, 0, 30)
        dateEmoji.BackgroundTransparency = 1
        dateEmoji.Text = "📅"
        dateEmoji.TextColor3 = Theme.Accent
        dateEmoji.TextSize = 16
        dateEmoji.Font = Enum.Font.Gotham
        dateEmoji.Parent = dateContainer
        
        -- Changes list container
        local changesFrame = Instance.new("Frame")
        changesFrame.Name = "ChangesFrame"
        changesFrame.Size = UDim2.new(1, -15, 0, 0)
        changesFrame.Position = UDim2.new(0, 15, 0, 40)
        changesFrame.BackgroundTransparency = 1
        changesFrame.AutomaticSize = Enum.AutomaticSize.Y
        changesFrame.Parent = dateSection
        
        local changesLayout = Instance.new("UIListLayout")
        changesLayout.Padding = UDim.new(0, 16)
        changesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        changesLayout.Parent = changesFrame
        
        -- Add each change with emoji and color
        for _, change in ipairs(update.Changes) do
            local config = getTypeConfig(change.Type)
            
            local changeItem = Instance.new("Frame")
            changeItem.Name = "ChangeItem_" .. change.Title
            changeItem.Size = UDim2.new(1, 0, 0, 0)
            changeItem.BackgroundTransparency = 1
            changeItem.AutomaticSize = Enum.AutomaticSize.Y
            changeItem.LayoutOrder = _
            changeItem.Parent = changesFrame
            
            -- Emoji and title container
            local titleContainer = Instance.new("Frame")
            titleContainer.Name = "TitleContainer"
            titleContainer.Size = UDim2.new(1, 0, 0, 24)
            titleContainer.BackgroundTransparency = 1
            titleContainer.Parent = changeItem
            
            -- Type indicator (colored line)
            local typeIndicator = Instance.new("Frame")
            typeIndicator.Name = "TypeIndicator"
            typeIndicator.Size = UDim2.new(0, 3, 0, 20)
            typeIndicator.Position = UDim2.new(0, 0, 0, 2)
            typeIndicator.BackgroundColor3 = config.color
            typeIndicator.BackgroundTransparency = 0
            typeIndicator.BorderSizePixel = 0
            typeIndicator.Parent = titleContainer
            
            -- Emoji
            local typeEmoji = Instance.new("TextLabel")
            typeEmoji.Name = "TypeEmoji"
            typeEmoji.Size = UDim2.new(0, 24, 0, 24)
            typeEmoji.Position = UDim2.new(0, 10, 0, 0)
            typeEmoji.BackgroundTransparency = 1
            typeEmoji.Text = config.emoji
            typeEmoji.TextColor3 = config.color
            typeEmoji.TextSize = 14
            typeEmoji.Font = Enum.Font.Gotham
            typeEmoji.Parent = titleContainer
            
            -- Change title with color based on type
            local changeTitle = Instance.new("TextLabel")
            changeTitle.Name = "ChangeTitle"
            changeTitle.Size = UDim2.new(1, -40, 0, 24)
            changeTitle.Position = UDim2.new(0, 40, 0, 0)
            changeTitle.BackgroundTransparency = 1
            changeTitle.Text = change.Title
            changeTitle.TextColor3 = config.titleColor
            changeTitle.TextSize = 12
            changeTitle.Font = Enum.Font.GothamSemibold
            changeTitle.TextXAlignment = Enum.TextXAlignment.Left
            changeTitle.TextYAlignment = Enum.TextYAlignment.Center
            changeTitle.Parent = titleContainer
            
            -- Change description (optional)
            if change.Description and change.Description ~= "" then
                local changeDesc = Instance.new("TextLabel")
                changeDesc.Name = "ChangeDescription"
                changeDesc.Size = UDim2.new(1, -45, 0, 0)
                changeDesc.Position = UDim2.new(0, 45, 0, 24)
                changeDesc.BackgroundTransparency = 1
                changeDesc.Text = change.Description
                changeDesc.TextColor3 = Theme.TextSecondary
                changeDesc.TextSize = 11
                changeDesc.Font = Enum.Font.Gotham
                changeDesc.TextXAlignment = Enum.TextXAlignment.Left
                changeDesc.TextYAlignment = Enum.TextYAlignment.Top
                changeDesc.TextWrapped = true
                changeDesc.AutomaticSize = Enum.AutomaticSize.Y
                changeDesc.Parent = changeItem
                
                -- Auto-adjust height
                changeDesc:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    changeItem.Size = UDim2.new(1, 0, 0, changeDesc.TextBounds.Y + 30)
                end)
            else
                changeItem.Size = UDim2.new(1, 0, 0, 24)
            end
        end
        
        -- Add separator line between date sections (except last one)
        if i < #sortedUpdates then
            local separator = Instance.new("Frame")
            separator.Name = "Separator"
            separator.Size = UDim2.new(1, -20, 0, 1)
            separator.Position = UDim2.new(0, 20, 1, 0)
            separator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            separator.BackgroundTransparency = 0.5
            separator.BorderSizePixel = 0
            separator.Parent = dateSection
        end
    end
    
    -- Return object with methods
    local historyObj = {}
    
    function historyObj:AddUpdate(newUpdate)
        table.insert(historyData.Updates, newUpdate)
        
        -- Simple refresh: destroy and recreate (or implement smarter refresh)
        scrollFrame:ClearAllChildren()
        
        -- Re-create the layout
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 28)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scrollFrame
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = scrollFrame
        
        -- Re-sort and recreate
        table.sort(sortedUpdates, function(a, b)
            return a.Date > b.Date
        end)
        
        for i, update in ipairs(sortedUpdates) do
            local dateSection = Instance.new("Frame")
            dateSection.Name = "DateSection_" .. update.Date
            dateSection.Size = UDim2.new(1, 0, 0, 0)
            dateSection.BackgroundTransparency = 1
            dateSection.AutomaticSize = Enum.AutomaticSize.Y
            dateSection.LayoutOrder = i
            dateSection.Parent = scrollFrame
            
            -- ... (same creation code as above, but this is simplified)
            -- In a real implementation, you'd reuse the creation logic
        end
    end
    
    function historyObj:GetInstance()
        return scrollFrame
    end
    
    return historyObj
end

-- Even simpler version with just emoji badges
function GuiLibrary:CreateBadgedUpdateHistory(tab, historyData)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "BadgedUpdateHistory"
    scrollFrame.Size = UDim2.new(1, 0, 0, 300)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Theme.Accent
    scrollFrame.ScrollBarImageTransparency = 0.5
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = tab.Frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 20)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.Parent = scrollFrame
    
    -- Type configurations with emoji and colors
    local typeStyles = {
        bug = { emoji = "🐞", color = Color3.fromRGB(220, 80, 80) },
        fix = { emoji = "⚙️", color = Color3.fromRGB(220, 80, 80) },
        update = { emoji = "🆕", color = Color3.fromRGB(0, 150, 255) },
        improvement = { emoji = "⚡", color = Color3.fromRGB(255, 165, 0) },
        feature = { emoji = "✨", color = Color3.fromRGB(0, 200, 100) },
        security = { emoji = "🔒", color = Color3.fromRGB(150, 100, 255) },
        default = { emoji = "📝", color = Theme.TextSecondary }
    }
    
    -- Sort by date (newest first)
    local sortedUpdates = {}
    for _, update in ipairs(historyData.Updates) do
        table.insert(sortedUpdates, update)
    end
    
    table.sort(sortedUpdates, function(a, b)
        return a.Date > b.Date
    end)
    
    -- Create each update
    for i, update in ipairs(sortedUpdates) do
        -- Main container for this date
        local dateContainer = Instance.new("Frame")
        dateContainer.Name = "Date_" .. update.Date
        dateContainer.Size = UDim2.new(1, 0, 0, 0)
        dateContainer.BackgroundTransparency = 1
        dateContainer.AutomaticSize = Enum.AutomaticSize.Y
        dateContainer.LayoutOrder = i
        dateContainer.Parent = scrollFrame
        
        -- Date header
        local dateHeader = Instance.new("Frame")
        dateHeader.Name = "DateHeader"
        dateHeader.Size = UDim2.new(1, 0, 0, 28)
        dateHeader.BackgroundTransparency = 1
        dateHeader.Parent = dateContainer
        
        -- Date text
        local dateText = Instance.new("TextLabel")
        dateText.Name = "DateText"
        dateText.Size = UDim2.new(1, 0, 1, 0)
        dateText.BackgroundTransparency = 1
        dateText.Text = "📅 " .. update.Date
        dateText.TextColor3 = Theme.Text
        dateText.TextSize = 13
        dateText.Font = Enum.Font.GothamBold
        dateText.TextXAlignment = Enum.TextXAlignment.Left
        dateText.Parent = dateHeader
        
        -- Changes list
        local changesContainer = Instance.new("Frame")
        changesContainer.Name = "Changes"
        changesContainer.Size = UDim2.new(1, -10, 0, 0)
        changesContainer.Position = UDim2.new(0, 10, 0, 30)
        changesContainer.BackgroundTransparency = 1
        changesContainer.AutomaticSize = Enum.AutomaticSize.Y
        changesContainer.Parent = dateContainer
        
        local changesLayout = Instance.new("UIListLayout")
        changesLayout.Padding = UDim.new(0, 12)
        changesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        changesLayout.Parent = changesContainer
        
        for _, change in ipairs(update.Changes) do
            local style = typeStyles[change.Type:lower()] or typeStyles.default
            
            local changeItem = Instance.new("Frame")
            changeItem.Name = "Change"
            changeItem.Size = UDim2.new(1, 0, 0, 0)
            changeItem.BackgroundTransparency = 1
            changeItem.AutomaticSize = Enum.AutomaticSize.Y
            changeItem.LayoutOrder = _
            changeItem.Parent = changesContainer
            
            -- Emoji badge
            local emojiBadge = Instance.new("Frame")
            emojiBadge.Name = "EmojiBadge"
            emojiBadge.Size = UDim2.new(0, 26, 0, 26)
            emojiBadge.BackgroundColor3 = style.color
            emojiBadge.BackgroundTransparency = 0.15
            emojiBadge.BorderSizePixel = 0
            emojiBadge.Parent = changeItem
            
            local badgeCorner = Instance.new("UICorner")
            badgeCorner.CornerRadius = UDim.new(0, 6)
            badgeCorner.Parent = emojiBadge
            
            local emojiText = Instance.new("TextLabel")
            emojiText.Name = "Emoji"
            emojiText.Size = UDim2.new(1, 0, 1, 0)
            emojiText.BackgroundTransparency = 1
            emojiText.Text = style.emoji
            emojiText.TextColor3 = Color3.fromRGB(255, 255, 255)
            emojiText.TextSize = 12
            emojiText.Font = Enum.Font.Gotham
            emojiText.Parent = emojiBadge
            
            -- Change content
            local contentFrame = Instance.new("Frame")
            contentFrame.Name = "Content"
            contentFrame.Size = UDim2.new(1, -35, 0, 0)
            contentFrame.Position = UDim2.new(0, 35, 0, 0)
            contentFrame.BackgroundTransparency = 1
            contentFrame.AutomaticSize = Enum.AutomaticSize.Y
            contentFrame.Parent = changeItem
            
            -- Title
            local titleText = Instance.new("TextLabel")
            titleText.Name = "Title"
            titleText.Size = UDim2.new(1, 0, 0, 20)
            titleText.BackgroundTransparency = 1
            titleText.Text = change.Title
            titleText.TextColor3 = style.color
            titleText.TextSize = 12
            titleText.Font = Enum.Font.GothamSemibold
            titleText.TextXAlignment = Enum.TextXAlignment.Left
            titleText.Parent = contentFrame
            
            -- Description
            if change.Description and change.Description ~= "" then
                local descText = Instance.new("TextLabel")
                descText.Name = "Description"
                descText.Size = UDim2.new(1, 0, 0, 0)
                descText.Position = UDim2.new(0, 0, 0, 20)
                descText.BackgroundTransparency = 1
                descText.Text = change.Description
                descText.TextColor3 = Theme.TextSecondary
                descText.TextSize = 11
                descText.Font = Enum.Font.Gotham
                descText.TextXAlignment = Enum.TextXAlignment.Left
                descText.TextYAlignment = Enum.TextYAlignment.Top
                descText.TextWrapped = true
                descText.AutomaticSize = Enum.AutomaticSize.Y
                descText.Parent = contentFrame
                
                -- Auto-size
                descText:GetPropertyChangedSignal("TextBounds"):Connect(function()
                    contentFrame.Size = UDim2.new(1, -35, 0, descText.TextBounds.Y + 25)
                    changeItem.Size = UDim2.new(1, 0, 0, math.max(26, descText.TextBounds.Y + 25))
                end)
            else
                changeItem.Size = UDim2.new(1, 0, 0, 26)
            end
        end
    end
    
    -- Return object
    local historyObj = {}
    
    function historyObj:AddUpdate(newUpdate)
        table.insert(historyData.Updates, newUpdate)
        -- Could implement refresh here
    end
    
    function historyObj:GetInstance()
        return scrollFrame
    end
    
    return historyObj
end

-- Add this function to your existing GuiLibrary
function GuiLibrary:UpdateHistoryBuilder(tab)
    local builder = {}
    local updates = {}
    
    function builder:Add(Date, Type, Title, Description)
        table.insert(updates, {
            Date = Date,
            Type = Type,
            Title = Title,
            Description = Description
        })
        return self
    end
    
    function builder:Build()
        -- Group by date
        local grouped = {}
        for _, update in ipairs(updates) do
            if not grouped[update.Date] then
                grouped[update.Date] = {}
            end
            table.insert(grouped[update.Date], {
                Type = update.Type,
                Title = update.Title,
                Description = update.Description
            })
        end
        
        -- Convert to final format
        local historyData = {Updates = {}}
        for date, changes in pairs(grouped) do
            table.insert(historyData.Updates, {
                Date = date,
                Changes = changes
            })
        end
        
        -- Sort
        table.sort(historyData.Updates, function(a, b)
            return a.Date > b.Date
        end)
        
        return GuiLibrary:CreateBadgedUpdateHistory(tab, historyData)
    end
    
    return builder
end


-- Welcome Panel Function (Gamer Style) - TAB VERSION - FIXED LAYOUT
function GuiLibrary:CreateWelcomePanelTab(tab, scriptInfo)
    -- Configuration with default values
    local config = {
        ScriptName = scriptInfo.ScriptName or "VOIDWARE SCRIPT",
        Version = scriptInfo.Version or "V2.1.0",
        Developer = scriptInfo.Developer or "Voidware Team",
        Discord = scriptInfo.Discord or "discord.gg/voidware",
        Description = scriptInfo.Description or "Advanced gaming utility with premium features",
        Features = scriptInfo.Features or {
            "Player ESP & Highlighting",
            "Auto-Farming Systems", 
            "Teleport & Navigation",
            "Premium Exclusive Features",
            "Regular Updates & Support"
        },
        ThemeColor = scriptInfo.ThemeColor or Theme.Accent,
        ShowCloseButton = scriptInfo.ShowCloseButton ~= false
    }
    
    -- Main container with proper layout
    local welcomeContainer = Instance.new("Frame")
    welcomeContainer.Name = "WelcomePanel"
    welcomeContainer.Size = UDim2.new(1, 0, 0, 0)
    welcomeContainer.BackgroundTransparency = 1
    welcomeContainer.AutomaticSize = Enum.AutomaticSize.Y
    welcomeContainer.Parent = tab.Frame
    
    -- Use UIListLayout for proper spacing
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 15)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Parent = welcomeContainer
    
    -- Header with gaming style
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 90)
    header.BackgroundColor3 = Theme.Secondary
    header.BackgroundTransparency = 0.7
    header.BorderSizePixel = 0
    header.LayoutOrder = 1
    header.Parent = welcomeContainer
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    -- Accent border
    local accentBorder = Instance.new("Frame")
    accentBorder.Name = "AccentBorder"
    accentBorder.Size = UDim2.new(1, 0, 0, 3)
    accentBorder.Position = UDim2.new(0, 0, 1, 0)
    accentBorder.BackgroundColor3 = config.ThemeColor
    accentBorder.BackgroundTransparency = 0.3
    accentBorder.BorderSizePixel = 0
    accentBorder.Parent = header
    
    -- Script title with gaming font
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 0, 40)
    title.Position = UDim2.new(0, 15, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = config.ScriptName
    title.TextColor3 = config.ThemeColor
    title.TextSize = 22
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = header
    
    -- Version badge (gaming style)
    local versionBadge = Instance.new("Frame")
    versionBadge.Name = "VersionBadge"
    versionBadge.Size = UDim2.new(0, 70, 0, 25)
    versionBadge.Position = UDim2.new(1, -85, 0, 10)
    versionBadge.BackgroundColor3 = config.ThemeColor
    versionBadge.BackgroundTransparency = 0.2
    versionBadge.BorderSizePixel = 0
    versionBadge.Parent = header
    
    local versionCorner = Instance.new("UICorner")
    versionCorner.CornerRadius = UDim.new(0, 6)
    versionCorner.Parent = versionBadge
    
    local versionText = Instance.new("TextLabel")
    versionText.Name = "VersionText"
    versionText.Size = UDim2.new(1, 0, 1, 0)
    versionText.BackgroundTransparency = 1
    versionText.Text = config.Version
    versionText.TextColor3 = Color3.fromRGB(255, 255, 255)
    versionText.TextSize = 12
    versionText.Font = Enum.Font.GothamBold
    versionText.Parent = versionBadge
    
    -- Developer info
    local developerLabel = Instance.new("TextLabel")
    developerLabel.Name = "DeveloperLabel"
    developerLabel.Size = UDim2.new(1, -30, 0, 20)
    developerLabel.Position = UDim2.new(0, 15, 0, 55)
    developerLabel.BackgroundTransparency = 1
    developerLabel.Text = "👑 DEVELOPED BY: " .. config.Developer
    developerLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    developerLabel.TextSize = 12
    developerLabel.Font = Enum.Font.GothamBold
    developerLabel.TextXAlignment = Enum.TextXAlignment.Left
    developerLabel.Parent = header
    
    -- Welcome message section
    local welcomeSection = Instance.new("Frame")
    welcomeSection.Name = "WelcomeSection"
    welcomeSection.Size = UDim2.new(1, 0, 0, 0)
    welcomeSection.BackgroundTransparency = 1
    welcomeSection.AutomaticSize = Enum.AutomaticSize.Y
    welcomeSection.LayoutOrder = 2
    welcomeSection.Parent = welcomeContainer
    
    local welcomeTitle = Instance.new("TextLabel")
    welcomeTitle.Name = "WelcomeTitle"
    welcomeTitle.Size = UDim2.new(1, 0, 0, 25)
    welcomeTitle.BackgroundTransparency = 1
    welcomeTitle.Text = "🎮 WELCOME TO " .. string.upper(config.ScriptName:gsub(" SCRIPT", "")) .. " 🎮"
    welcomeTitle.TextColor3 = config.ThemeColor
    welcomeTitle.TextSize = 16
    welcomeTitle.Font = Enum.Font.GothamBold
    welcomeTitle.Parent = welcomeSection
    
    local welcomeMessage = Instance.new("TextLabel")
    welcomeMessage.Name = "WelcomeMessage"
    welcomeMessage.Size = UDim2.new(1, 0, 0, 0)
    welcomeMessage.Position = UDim2.new(0, 0, 0, 30)
    welcomeMessage.BackgroundTransparency = 1
    welcomeMessage.Text = config.Description
    welcomeMessage.TextColor3 = Color3.fromRGB(220, 220, 220)
    welcomeMessage.TextSize = 13
    welcomeMessage.Font = Enum.Font.Gotham
    welcomeMessage.TextWrapped = true
    welcomeMessage.AutomaticSize = Enum.AutomaticSize.Y
    welcomeMessage.Parent = welcomeSection
    
    -- Auto-size welcome section
    welcomeMessage:GetPropertyChangedSignal("TextBounds"):Connect(function()
        welcomeSection.Size = UDim2.new(1, 0, 0, welcomeMessage.TextBounds.Y + 35)
    end)
    
    -- Features section - SIMPLIFIED VERSION WITHOUT SCROLLING FRAME
    local featuresSection = Instance.new("Frame")
    featuresSection.Name = "FeaturesSection"
    featuresSection.Size = UDim2.new(1, 0, 0, 0)
    featuresSection.BackgroundTransparency = 1
    featuresSection.AutomaticSize = Enum.AutomaticSize.Y
    featuresSection.LayoutOrder = 3
    featuresSection.Parent = welcomeContainer
    
    local featuresTitle = Instance.new("TextLabel")
    featuresTitle.Name = "FeaturesTitle"
    featuresTitle.Size = UDim2.new(1, 0, 0, 25)
    featuresTitle.BackgroundTransparency = 1
    featuresTitle.Text = "✨ FEATURE HIGHLIGHTS ✨"
    featuresTitle.TextColor3 = config.ThemeColor
    featuresTitle.TextSize = 16
    featuresTitle.Font = Enum.Font.GothamBold
    featuresTitle.Parent = featuresSection
    
    local featuresList = Instance.new("Frame")
    featuresList.Name = "FeaturesList"
    featuresList.Size = UDim2.new(1, 0, 0, 0)
    featuresList.Position = UDim2.new(0, 0, 0, 30)
    featuresList.BackgroundTransparency = 1
    featuresList.AutomaticSize = Enum.AutomaticSize.Y
    featuresList.Parent = featuresSection
    
    local featuresLayout = Instance.new("UIListLayout")
    featuresLayout.Padding = UDim.new(0, 8)
    featuresLayout.SortOrder = Enum.SortOrder.LayoutOrder
    featuresLayout.Parent = featuresList
    
    -- Add features with gaming-style icons
    for i, feature in ipairs(config.Features) do
        local featureItem = Instance.new("Frame")
        featureItem.Name = "Feature_" .. i
        featureItem.Size = UDim2.new(1, 0, 0, 35)
        featureItem.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        featureItem.BackgroundTransparency = 0.6
        featureItem.BorderSizePixel = 0
        featureItem.LayoutOrder = i
        featureItem.Parent = featuresList
        
        local featureCorner = Instance.new("UICorner")
        featureCorner.CornerRadius = UDim.new(0, 6)
        featureCorner.Parent = featureItem
        
        -- Gaming icon
        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 30, 0, 30)
        icon.Position = UDim2.new(0, 8, 0.5, -15)
        icon.BackgroundTransparency = 1
        icon.Text = "✓"
        icon.TextColor3 = Color3.fromRGB(0, 255, 100)
        icon.TextSize = 18
        icon.Font = Enum.Font.GothamBold
        icon.Parent = featureItem
        
        -- Feature text
        local featureText = Instance.new("TextLabel")
        featureText.Name = "FeatureText"
        featureText.Size = UDim2.new(1, -45, 1, 0)
        featureText.Position = UDim2.new(0, 40, 0, 0)
        featureText.BackgroundTransparency = 1
        featureText.Text = feature
        featureText.TextColor3 = Color3.fromRGB(240, 240, 240)
        featureText.TextSize = 12
        featureText.Font = Enum.Font.Gotham
        featureText.TextXAlignment = Enum.TextXAlignment.Left
        featureText.TextYAlignment = Enum.TextYAlignment.Center
        featureText.Parent = featureItem
        
        -- Hover effect
        featureItem.MouseEnter:Connect(function()
            if not isMobile then
                TweenService:Create(featureItem, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.4,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                }):Play()
                TweenService:Create(icon, TweenInfo.new(0.2), {
                    TextColor3 = config.ThemeColor
                }):Play()
            end
        end)
        
        featureItem.MouseLeave:Connect(function()
            if not isMobile then
                TweenService:Create(featureItem, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.6,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                }):Play()
                TweenService:Create(icon, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(0, 255, 100)
                }):Play()
            end
        end)
    end
    
    -- Auto-size features section
    featuresLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        featuresList.Size = UDim2.new(1, 0, 0, featuresLayout.AbsoluteContentSize.Y)
        featuresSection.Size = UDim2.new(1, 0, 0, featuresLayout.AbsoluteContentSize.Y + 35)
    end)
    
    -- Discord section - SIMPLIFIED
    local discordSection = Instance.new("Frame")
    discordSection.Name = "DiscordSection"
    discordSection.Size = UDim2.new(1, 0, 0, 70)
    discordSection.BackgroundTransparency = 1
    discordSection.LayoutOrder = 4
    discordSection.Parent = welcomeContainer
    
    local discordTitle = Instance.new("TextLabel")
    discordTitle.Name = "DiscordTitle"
    discordTitle.Size = UDim2.new(1, 0, 0, 25)
    discordTitle.BackgroundTransparency = 1
    discordTitle.Text = "💬 JOIN OUR COMMUNITY 💬"
    discordTitle.TextColor3 = Color3.fromRGB(88, 101, 242) -- Discord blue
    discordTitle.TextSize = 14
    discordTitle.Font = Enum.Font.GothamBold
    discordTitle.Parent = discordSection
    
    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Size = UDim2.new(1, 0, 0, 40)
    discordButton.Position = UDim2.new(0, 0, 0, 30)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.BackgroundTransparency = 0.2
    discordButton.BorderSizePixel = 0
    discordButton.Text = "Discord: " .. config.Discord
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 13
    discordButton.Font = Enum.Font.Gotham
    discordButton.Parent = discordSection
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordButton
    
    -- Discord icon
    local discordIcon = Instance.new("TextLabel")
    discordIcon.Name = "DiscordIcon"
    discordIcon.Size = UDim2.new(0, 30, 0, 30)
    discordIcon.Position = UDim2.new(0, 10, 0.5, -15)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Text = "💬"
    discordIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordIcon.TextSize = 16
    discordIcon.Font = Enum.Font.Gotham
    discordIcon.Parent = discordButton
    
    -- Support/Help section - SIMPLIFIED
    local supportSection = Instance.new("Frame")
    supportSection.Name = "SupportSection"
    supportSection.Size = UDim2.new(1, 0, 0, 70)
    supportSection.BackgroundTransparency = 1
    supportSection.LayoutOrder = 5
    supportSection.Parent = welcomeContainer
    
    local supportTitle = Instance.new("TextLabel")
    supportTitle.Name = "SupportTitle"
    supportTitle.Size = UDim2.new(1, 0, 0, 25)
    supportTitle.BackgroundTransparency = 1
    supportTitle.Text = "🛠️ GET SUPPORT & HELP 🛠️"
    supportTitle.TextColor3 = Color3.fromRGB(255, 165, 0)
    supportTitle.TextSize = 14
    supportTitle.Font = Enum.Font.GothamBold
    supportTitle.Parent = supportSection
    
    local helpButton = Instance.new("TextButton")
    helpButton.Name = "HelpButton"
    helpButton.Size = UDim2.new(1, 0, 0, 40)
    helpButton.Position = UDim2.new(0, 0, 0, 30)
    helpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    helpButton.BackgroundTransparency = 0.3
    helpButton.BorderSizePixel = 0
    helpButton.Text = "Need help? Click for support options"
    helpButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    helpButton.TextSize = 12
    helpButton.Font = Enum.Font.Gotham
    helpButton.Parent = supportSection
    
    local helpCorner = Instance.new("UICorner")
    helpCorner.CornerRadius = UDim.new(0, 6)
    helpCorner.Parent = helpButton
    
    -- Help icon
    local helpIcon = Instance.new("TextLabel")
    helpIcon.Name = "HelpIcon"
    helpIcon.Size = UDim2.new(0, 30, 0, 30)
    helpIcon.Position = UDim2.new(0, 10, 0.5, -15)
    helpIcon.BackgroundTransparency = 1
    helpIcon.Text = "❓"
    helpIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    helpIcon.TextSize = 16
    helpIcon.Font = Enum.Font.Gotham
    helpIcon.Parent = helpButton
    
    -- Button hover effects
    local function setupTabButton(button, defaultColor, hoverColor)
        button.MouseEnter:Connect(function()
            if not isMobile then
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = hoverColor,
                    BackgroundTransparency = 0.1
                }):Play()
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not isMobile then
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = defaultColor,
                    BackgroundTransparency = 0.2
                }):Play()
            end
        end)
    end
    
    -- Setup button effects
    setupTabButton(discordButton, 
        Color3.fromRGB(88, 101, 242), 
        Color3.fromRGB(108, 121, 262))
    
    setupTabButton(helpButton,
        Color3.fromRGB(60, 60, 70),
        Color3.fromRGB(80, 80, 90))
    
    -- Button functionality
    discordButton.MouseButton1Click:Connect(function()
        self:CopyToClipboard(config.Discord)
        self:ShowNotification("📋 Discord link copied to clipboard!", 3)
        
        -- Visual feedback
        discordButton.Text = "✓ COPIED TO CLIPBOARD!"
        delay(2, function()
            if discordButton then
                discordButton.Text = "Discord: " .. config.Discord
            end
        end)
    end)
    
    helpButton.MouseButton1Click:Connect(function()
        self:ShowNotification("📞 Support options:\n1. Join our Discord for help\n2. Check documentation\n3. Report bugs in #support", 5)
        
        -- Show help options in a simple way
        local options = {
            "Join Discord for support",
            "Check FAQ in documentation",
            "Report bugs/issues",
            "Request features"
        }
        
        -- Create simple help popup
        local helpPopup = Instance.new("ScreenGui")
        helpPopup.Name = "HelpPopup"
        helpPopup.Parent = playerGui
        
        local helpFrame = Instance.new("Frame")
        helpFrame.Size = UDim2.new(0, 300, 0, 200)
        helpFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
        helpFrame.BackgroundColor3 = Theme.Background
        helpFrame.BackgroundTransparency = 0.1
        helpFrame.BorderSizePixel = 0
        helpFrame.Parent = helpPopup
        
        local helpCorner = Instance.new("UICorner")
        helpCorner.CornerRadius = UDim.new(0, 8)
        helpCorner.Parent = helpFrame
        
        local helpTitle = Instance.new("TextLabel")
        helpTitle.Size = UDim2.new(1, -20, 0, 40)
        helpTitle.Position = UDim2.new(0, 10, 0, 10)
        helpTitle.BackgroundTransparency = 1
        helpTitle.Text = "🛠️ SUPPORT OPTIONS"
        helpTitle.TextColor3 = Color3.fromRGB(255, 165, 0)
        helpTitle.TextSize = 16
        helpTitle.Font = Enum.Font.GothamBold
        helpTitle.Parent = helpFrame
        
        for i, option in ipairs(options) do
            local optionLabel = Instance.new("TextLabel")
            optionLabel.Size = UDim2.new(1, -40, 0, 25)
            optionLabel.Position = UDim2.new(0, 20, 0, 50 + (i * 25))
            optionLabel.BackgroundTransparency = 1
            optionLabel.Text = i .. ". " .. option
            optionLabel.TextColor3 = Theme.Text
            optionLabel.TextSize = 12
            optionLabel.Font = Enum.Font.Gotham
            optionLabel.TextXAlignment = Enum.TextXAlignment.Left
            optionLabel.Parent = helpFrame
        end
        
        local closeHelp = Instance.new("TextButton")
        closeHelp.Size = UDim2.new(0, 120, 0, 30)
        closeHelp.Position = UDim2.new(0.5, -60, 1, -40)
        closeHelp.BackgroundColor3 = Theme.Accent
        closeHelp.BackgroundTransparency = 0.2
        closeHelp.Text = "CLOSE"
        closeHelp.TextColor3 = Theme.Text
        closeHelp.TextSize = 12
        closeHelp.Font = Enum.Font.GothamBold
        closeHelp.Parent = helpFrame
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 6)
        closeCorner.Parent = closeHelp
        
        closeHelp.MouseButton1Click:Connect(function()
            helpPopup:Destroy()
        end)
        
        setupTabButton(closeHelp, Theme.Accent, Color3.fromRGB(
            math.min(Theme.Accent.R * 255 + 30, 255),
            math.min(Theme.Accent.G * 255 + 30, 255),
            math.min(Theme.Accent.B * 255 + 30, 255)
        ))
        
        -- Auto-close after 10 seconds
        delay(10, function()
            if helpPopup and helpPopup.Parent then
                helpPopup:Destroy()
            end
        end)
    end)
    
    -- Return panel object with controls
    local panelObj = {}
    
    function panelObj:UpdateConfig(newConfig)
        for key, value in pairs(newConfig) do
            config[key] = value
        end
        
        -- Update UI elements
        if title then title.Text = config.ScriptName end
        if versionText then versionText.Text = config.Version end
        if developerLabel then developerLabel.Text = "👑 DEVELOPED BY: " .. config.Developer end
        if welcomeMessage then welcomeMessage.Text = config.Description end
        if discordButton then discordButton.Text = "Discord: " .. config.Discord end
        
        -- Update colors
        if accentBorder then accentBorder.BackgroundColor3 = config.ThemeColor end
        if title then title.TextColor3 = config.ThemeColor end
        if versionBadge then versionBadge.BackgroundColor3 = config.ThemeColor end
        if welcomeTitle then welcomeTitle.TextColor3 = config.ThemeColor end
        if featuresTitle then featuresTitle.TextColor3 = config.ThemeColor end
        
        -- Update features list
        if featuresList then
            featuresList:ClearAllChildren()
            
            local featuresLayout = Instance.new("UIListLayout")
            featuresLayout.Padding = UDim.new(0, 8)
            featuresLayout.SortOrder = Enum.SortOrder.LayoutOrder
            featuresLayout.Parent = featuresList
            
            for i, feature in ipairs(config.Features) do
                local featureItem = Instance.new("Frame")
                featureItem.Name = "Feature_" .. i
                featureItem.Size = UDim2.new(1, 0, 0, 35)
                featureItem.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                featureItem.BackgroundTransparency = 0.6
                featureItem.BorderSizePixel = 0
                featureItem.LayoutOrder = i
                featureItem.Parent = featuresList
                
                local featureCorner = Instance.new("UICorner")
                featureCorner.CornerRadius = UDim.new(0, 6)
                featureCorner.Parent = featureItem
                
                local icon = Instance.new("TextLabel")
                icon.Name = "Icon"
                icon.Size = UDim2.new(0, 30, 0, 30)
                icon.Position = UDim2.new(0, 8, 0.5, -15)
                icon.BackgroundTransparency = 1
                icon.Text = "✓"
                icon.TextColor3 = Color3.fromRGB(0, 255, 100)
                icon.TextSize = 18
                icon.Font = Enum.Font.GothamBold
                icon.Parent = featureItem
                
                local featureText = Instance.new("TextLabel")
                featureText.Name = "FeatureText"
                featureText.Size = UDim2.new(1, -45, 1, 0)
                featureText.Position = UDim2.new(0, 40, 0, 0)
                featureText.BackgroundTransparency = 1
                featureText.Text = feature
                featureText.TextColor3 = Color3.fromRGB(240, 240, 240)
                featureText.TextSize = 12
                featureText.Font = Enum.Font.Gotham
                featureText.TextXAlignment = Enum.TextXAlignment.Left
                featureText.TextYAlignment = Enum.TextYAlignment.Center
                featureText.Parent = featureItem
            end
        end
    end
    
    function panelObj:GetConfig()
        return config
    end
    
    function panelObj:GetInstance()
        return welcomeContainer
    end
    
    function panelObj:Destroy()
        if welcomeContainer then
            welcomeContainer:Destroy()
        end
    end
    
    return panelObj
end

-- Export the library
return GuiLibrary
