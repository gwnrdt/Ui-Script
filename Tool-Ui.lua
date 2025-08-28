game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Keybind: RightShift",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=106019376492019&w=420&h=420"
getgenv().ToggleUI = "RightShift"

task.spawn(function()
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")
        OpenUI.Name = "OpenUI"
        OpenUI.Parent = game:GetService("CoreGui")
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0, 20, 0, 25)
        ImageButton.Size = UDim2.new(0, 50, 0, 50)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true
        ImageButton.Transparency = 1
        UICorner.CornerRadius = UDim.new(0,13)
        UICorner.Parent = ImageButton
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local SkUI = {}
SkUI.__index = SkUI

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in pairs(props) do
        obj[i] = v
    end
    return obj
end

local function Roundify(obj, rad)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, rad)
    corner.Parent = obj
end

function SkUI:CreateWindow(title)
    local ui = setmetatable({}, SkUI)

    local Screen = Create("ScreenGui", {
        Name = "SkUI_Library",
        ResetOnSpawn = false,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })

    local Holder = Create("Frame", {
         Name = "Holder",
         Size = UDim2.new(0, 550, 0, 380),
         Position = UDim2.new(0.5, -275, 0, -60),
         BackgroundColor3 = Color3.fromRGB(22, 22, 22),
         BorderSizePixel = 0,
         Visible = true,
         Parent = Screen
    })
    Holder.Active = true
    Holder.Draggable = true

    Roundify(Holder, 8)

    local Header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = Holder
    })

    local Title = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = title or "SkUI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = Header
    })

    local TabsBackground = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = Holder
    })

    local TabsScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X,
        Parent = TabsBackground
    })

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 6)
    TabsLayout.Parent = TabsScroll

    local TabsFolder = Create("Folder", { Parent = TabsScroll })

    local Pages = {}
    local TabButtons = {}
function ui:Create(buttonWidth, tabname)
    local tab = {}

    buttonWidth = buttonWidth or 105

    local Button = Create("TextButton", {
        Size = UDim2.new(0, buttonWidth, 1, 0),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        Text = tabname,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        LayoutOrder = #TabsScroll:GetChildren() + 1,
        Parent = TabsScroll
    })
    Roundify(Button, 6)

    Button.MouseButton1Click:Connect(function()
        for _, child in ipairs(TabsScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end
        end
        Button.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    end)

    if not TabsScroll:FindFirstChild("UIListLayout") then
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = TabsScroll
    end

local Page = Create("Frame", {
    Size = UDim2.new(1, 0, 1, -70),
    Position = UDim2.new(0, 0, 0, 70),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0,
    Visible = false,
    Parent = Holder,
    ClipsDescendants = true
})

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = Page

local topMask = Create("Frame", {
    Size = UDim2.new(1, 0, 0.8, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Parent = Page
})
local function makeScroll(posX, widthScale)
    local scroll = Create("ScrollingFrame", {
        Size = UDim2.new(widthScale, -10, 0, 298),
        Position = posX,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        LayoutOrder = 1,
        Parent = Page
    })

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = scroll

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    return scroll
end

local LeftScroll = makeScroll(UDim2.new(0, 5, 0, 5), 0.5)
local RightScroll = makeScroll(UDim2.new(0.5, 5, 0, 5), 0.5)

    local function AddElement(side, obj)
            obj.Size = UDim2.new(1, 0, 0, 44)
            local parent = (side == "Left") and LeftScroll or RightScroll
            obj.Parent = parent
        end
function tab:AddToggle(side, text, default, callback)
    local Toggle = Create("TextButton", {
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 13,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Roundify(Toggle, 6)

    local label = Instance.new("TextLabel", Toggle)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local icon = Instance.new("Frame", Toggle)
    icon.AnchorPoint = Vector2.new(1, 0.5)
    icon.Position = UDim2.new(1, -20, 0.5, 0)
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.BackgroundColor3 = default and Color3.fromRGB(100, 149, 237) or Color3.fromRGB(80, 80, 80)
    icon.BorderSizePixel = 0
    icon.ZIndex = 2
    Roundify(icon, 300)

    local tick = Instance.new("TextLabel", icon)
    tick.Size = UDim2.new(1, 0, 1, 0)
    tick.BackgroundTransparency = 1
    tick.Text = "✔️"
    tick.Font = Enum.Font.GothamBold
    tick.TextSize = 14
    tick.TextColor3 = Color3.fromRGB(255, 255, 255)
    tick.TextTransparency = default and 0 or 1
    tick.ZIndex = 3

    local state = default or false

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        icon.BackgroundColor3 = state and Color3.fromRGB(100, 149, 237) or Color3.fromRGB(80, 80, 80)
        tick.TextTransparency = state and 0 or 1
        callback(state)
    end)

    AddElement(side, Toggle)
end
function tab:AddTextLabel(side, text)
    local parent = (side == "Left") and LeftScroll or RightScroll
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 15
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.AnchorPoint = Vector2.new(0.5, 0)
    Label.Position = UDim2.new(0.5, 0, 0, 0)
    Label.Parent = parent
end
function tab:AddNiceTextLabel(side, text)
    local parent = (side == "Left") and LeftScroll or RightScroll
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.AnchorPoint = Vector2.new(0, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Parent = parent
end
function tab:AddLeftTextLabel(side, text)
    local parent = (side == "Left") and LeftScroll or RightScroll
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.AnchorPoint = Vector2.new(0.5, 0)
    Label.Position = UDim2.new(0.5, 0, 0, 0)
    Label.Parent = parent
end
function tab:AddButton(side, text, callback)
    local parent = (side == "Left") and LeftScroll or RightScroll

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 25)
    Button.AnchorPoint = Vector2.new(0.5, 0)
    Button.Position = UDim2.new(0.5, 0, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 13
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.ClipsDescendants = true
    Button.Parent = parent

    Roundify(Button, 6)

    Button.MouseButton1Click:Connect(callback)
end        
function tab:AddLabel(side, text)
    local parent = (side == "Left") and LeftScroll or RightScroll
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 26)
    Label.AnchorPoint = Vector2.new(0.5, 0)
    Label.Position = UDim2.new(0.5, 0, 0, 0)
    Label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.ClipsDescendants = true
    Label.Parent = parent
    Roundify(Label, 6)
end

function tab:AddTextbox(side, text, placeholder, callback)
    local Box = Instance.new("Frame")
    Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Box.Size = UDim2.new(1, 0, 0, 38)
    Box.AnchorPoint = Vector2.new(0.5, 0)
    Box.Position = UDim2.new(0.5, 0, 0, 0)
    Box.ClipsDescendants = true

    local UICorner = Instance.new("UICorner", Box)
    UICorner.CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Box)
    Label.Size = UDim2.new(1, -10, 0, 15)
    Label.Position = UDim2.new(0, 10, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Input = Instance.new("TextBox", Box)
    Input.Size = UDim2.new(1, -20, 0, 18)
    Input.Position = UDim2.new(0, 10, 0, 18)
    Input.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Input.Text = ""
    Input.PlaceholderText = placeholder or ""
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 13
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.ClearTextOnFocus = false
    Input.TextXAlignment = Enum.TextXAlignment.Left

    local corner2 = Instance.new("UICorner", Input)
    corner2.CornerRadius = UDim.new(0, 4)

    Input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(Input.Text)
        end
    end)

    AddElement(side, Box)
end
function tab:AddSlider(side, text, min, max, default, callback)
    local parent = (side == "Left") and LeftScroll or RightScroll
    local value = default or min

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 60)
    Container.AnchorPoint = Vector2.new(0.5, 0)
    Container.Position = UDim2.new(0.5, 0, 0, 0)
    Container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Container.BorderSizePixel = 0
    Container.Parent = parent

    local UICorner = Instance.new("UICorner", Container)
    UICorner.CornerRadius = UDim.new(0, 6)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.5, -10, 0, 18)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.Gotham
    Title.TextSize = 13
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Parent = Container

    local ValueButton = Instance.new("TextButton")
    ValueButton.Size = UDim2.new(0, 50, 0, 18)
    ValueButton.Position = UDim2.new(1, -60, 0, 5)
    ValueButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ValueButton.Text = tostring(value)
    ValueButton.Font = Enum.Font.Gotham
    ValueButton.TextSize = 13
    ValueButton.TextColor3 = Color3.new(1, 1, 1)
    ValueButton.Parent = Container

    local ValueCorner = Instance.new("UICorner", ValueButton)
    ValueCorner.CornerRadius = UDim.new(0, 4)

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -20, 0, 10)
    Bar.Position = UDim2.new(0, 10, 0, 35)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bar.BorderSizePixel = 0
    Bar.Parent = Container

    local BarCorner = Instance.new("UICorner", Bar)
    BarCorner.CornerRadius = UDim.new(0, 5)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner", Fill)
    FillCorner.CornerRadius = UDim.new(0, 5)

    ValueButton.MouseButton1Click:Connect(function()
        local inputBox = Instance.new("TextBox")
        inputBox.Size = ValueButton.Size
        inputBox.Position = ValueButton.Position
        inputBox.Font = ValueButton.Font
        inputBox.TextSize = ValueButton.TextSize
        inputBox.TextColor3 = ValueButton.TextColor3
        inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        inputBox.Text = tostring(value)
        inputBox.ClearTextOnFocus = true
        inputBox.TextXAlignment = Enum.TextXAlignment.Center
        inputBox.Parent = Container
        inputBox:CaptureFocus()

        inputBox.FocusLost:Connect(function()
            local inputValue = tonumber(inputBox.Text)
            if inputValue then
                value = math.clamp(math.floor(inputValue + 0.5), min, max)
                ValueButton.Text = tostring(value)
                Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                callback(value)
            end
            inputBox:Destroy()
        end)
    end)
end

function tab:RealLine(side)
    local parent = (side == "Left") and LeftScroll or RightScroll

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 9)
    Line.AnchorPoint = Vector2.new(0.5, 0)
    Line.Position = UDim2.new(0.5, 0, 0, 0)
    Line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Line.BackgroundTransparency = 0
    Line.BorderSizePixel = 0
    Line.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 3)
    Corner.Parent = Line
end

function tab:AddText(side, text)
    local parent = (side == "Left") and LeftScroll or RightScroll
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.AnchorPoint = Vector2.new(0.5, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Position = UDim2.new(0.5, 0, 0, 0)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.TextWrapped = true
    Label.Parent = parent
end

function tab:AddDropdown(side, text, list, callback)
    local parent = (side == "Left") and LeftScroll or RightScroll

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1,0,0,0)
    Container.BackgroundTransparency = 1
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.Parent = parent

    local Layout = Instance.new("UIListLayout", Container)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local Button = Instance.new("TextButton", Container)
    Button.Size = UDim2.new(1,0,0,35)
    Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Button.AutoButtonColor = false
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.Text = text .. " ▼"
    Button.TextXAlignment = Enum.TextXAlignment.Center

    local UICorner = Instance.new("UICorner", Button)
    UICorner.CornerRadius = UDim.new(0, 8)

    local DropdownFrame = Instance.new("Frame", Container)
    DropdownFrame.Size = UDim2.new(1,0,0,0)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    DropdownFrame.Visible = false
    DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    DropdownFrame.ZIndex = 10

    local SearchBox = Instance.new("TextBox", DropdownFrame)
    SearchBox.Size = UDim2.new(1, -8, 0, 28)
    SearchBox.Position = UDim2.new(0, 4, 0, 4)
    SearchBox.Text = "Search..."
    SearchBox.PlaceholderText = "Search..."
    SearchBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
    SearchBox.TextColor3 = Color3.fromRGB(255,255,255)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 13
    SearchBox.ClearTextOnFocus = false
    SearchBox.AutomaticSize = Enum.AutomaticSize.None
    SearchBox.BorderSizePixel = 0
    local SearchUICorner = Instance.new("UICorner", SearchBox)
    SearchUICorner.CornerRadius = UDim.new(0,6)

    local Scroll = Instance.new("ScrollingFrame", DropdownFrame)
    Scroll.Position = UDim2.new(0,0,0,36)
    Scroll.Size = UDim2.new(1,0,0,0)
    Scroll.AutomaticSize = Enum.AutomaticSize.Y
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarImageTransparency = 1
    Scroll.CanvasSize = UDim2.new(0,0,0,0)
    Scroll.HorizontalScrollBarInset = Enum.ScrollBarInset.None -- chỉ dọc

    local UIList = Instance.new("UIListLayout", Scroll)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0,2)

    local selectedItem = nil -- giữ 1 item

    local open = false
    Button.MouseButton1Click:Connect(function()
        open = not open
        DropdownFrame.Visible = open
        Button.Text = text .. (open and " ▲" or " ▼")
    end)

    local function updateScroll()
        local total = 0
        for _, child in pairs(Scroll:GetChildren()) do
            if child:IsA("TextButton") then
                total = total + child.Size.Y.Offset + UIList.Padding.Offset
            end
        end
        Scroll.CanvasSize = UDim2.new(0,0,0,total)
    end

    for _, item in ipairs(list) do
        local Opt = Instance.new("TextButton", Scroll)
        Opt.Size = UDim2.new(1,0,0,28)
        Opt.BackgroundColor3 = Color3.fromRGB(65,65,65)
        Opt.Text = item
        Opt.ZIndex = 40
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 13
        Opt.TextColor3 = Color3.fromRGB(255,255,255)
        Opt.TextXAlignment = Enum.TextXAlignment.Left
        local UIPadding = Instance.new("UIPadding", Opt)
        UIPadding.PaddingLeft = UDim.new(0,8)
        local UICornerOpt = Instance.new("UICorner", Opt)
        UICornerOpt.CornerRadius = UDim.new(0,6)

        Opt.MouseButton1Click:Connect(function()
            selectedItem = item
            for _, o in ipairs(Scroll:GetChildren()) do
                if o:IsA("TextButton") then
                    o.BackgroundColor3 = (o == Opt) and Color3.fromRGB(85,125,185) or Color3.fromRGB(65,65,65)
                end
            end
            callback(item)
            open = false
            DropdownFrame.Visible = open
            Button.Text = text .. " ▼"
        end)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        for _, Opt in ipairs(Scroll:GetChildren()) do
            if Opt:IsA("TextButton") then
                Opt.Visible = Opt.Text:lower():find(query) and true or false
            end
        end
        updateScroll()
    end)
end
function tab:AddMultiDropdown(side, text, list, callback)
    local parent = (side == "Left") and LeftScroll or RightScroll

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.Parent = parent

    local Layout = Instance.new("UIListLayout", Container)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local Button = Instance.new("TextButton", Container)
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Button.AutoButtonColor = false
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text .. " ▼"
    Button.TextXAlignment = Enum.TextXAlignment.Center

    local UICorner = Instance.new("UICorner", Button)
    UICorner.CornerRadius = UDim.new(0, 8)

    local DropdownFrame = Instance.new("Frame", Container)
    DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropdownFrame.Visible = false
    DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    DropdownFrame.ClipsDescendants = true

    local SearchBox = Instance.new("TextBox", DropdownFrame)
    SearchBox.Size = UDim2.new(1, -10, 0, 28)
    SearchBox.Position = UDim2.new(0, 5, 0, 5)
    SearchBox.Text = "Search..."
    SearchBox.PlaceholderText = "Search..."
    SearchBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 13
    local UICornerSearch = Instance.new("UICorner", SearchBox)
    UICornerSearch.CornerRadius = UDim.new(0, 6)

    local Scroll = Instance.new("ScrollingFrame", DropdownFrame)
    Scroll.Size = UDim2.new(1, 0, 0, 150)
    Scroll.Position = UDim2.new(0, 0, 0, 38)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 6
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.ClipsDescendants = true
    Scroll.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    Scroll.ScrollBarImageTransparency = 1

    local UIList = Instance.new("UIListLayout", Scroll)
    UIList.Padding = UDim.new(0, 2)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    local selectedItems = {}
    local optionButtons = {}

    for _, item in ipairs(list) do
        local Opt = Instance.new("TextButton", Scroll)
        Opt.Size = UDim2.new(1, 0, 0, 28)
        Opt.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        Opt.Text = item
        Opt.Font = Enum.Font.Gotham
        Opt.TextSize = 13
        Opt.TextColor3 = Color3.fromRGB(255, 255, 255)
        Opt.TextXAlignment = Enum.TextXAlignment.Left
        local UIPadding = Instance.new("UIPadding", Opt)
        UIPadding.PaddingLeft = UDim.new(0, 8)
        local UICornerOpt = Instance.new("UICorner", Opt)
        UICornerOpt.CornerRadius = UDim.new(0, 6)

        Opt.MouseButton1Click:Connect(function()
            if selectedItems[item] then
                selectedItems[item] = nil
                Opt.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            else
                selectedItems[item] = true
                Opt.BackgroundColor3 = Color3.fromRGB(85, 125, 185)
            end
            local names = {}
            for name, _ in pairs(selectedItems) do
                table.insert(names, name)
            end
            callback(names)
        end)

        table.insert(optionButtons, Opt)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        local count = 0
        for _, btn in ipairs(optionButtons) do
            if btn.Text:lower():find(query) then
                btn.Visible = true
                count = count + 1
            else
                btn.Visible = false
            end
        end
        Scroll.Size = UDim2.new(1, 0, 0, math.min(count * 30, 150))
    end)

    local open = false
    Button.MouseButton1Click:Connect(function()
        open = not open
        DropdownFrame.Visible = open
        Button.Text = text .. (open and " ▲" or " ▼")
    end)
end

function tab:AddHideLine(side)
    local parent = (side == "Left") and LeftScroll or RightScroll

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 9)
    Line.AnchorPoint = Vector2.new(0.5, 0)
    Line.Position = UDim2.new(0.5, 0, 0, 0)
    Line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Line.BackgroundTransparency = 1
    Line.BorderSizePixel = 0
    Line.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 3)
    Corner.Parent = Line
end

function tab:AddParagraph(side, title, desc)
    local parent = (side == "Left") and LeftScroll or RightScroll
    
    local Frame = Instance.new("Frame")
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, 0, 0, 0)
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.Parent = parent

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Frame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Frame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextWrapped = true
    TitleLabel.Size = UDim2.new(1, 0, 0, 0)
    TitleLabel.AutomaticSize = Enum.AutomaticSize.Y
    TitleLabel.Parent = Frame
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 12
    DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescLabel.TextWrapped = true
    DescLabel.Size = UDim2.new(1, 0, 0, 0)
    DescLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescLabel.Parent = Frame
end
function tab:Line(side)
    local parent = (side == "Left") and LeftScroll or RightScroll

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 2)
    Line.AnchorPoint = Vector2.new(0.5, 0)
    Line.Position = UDim2.new(0.5, 0, 0, 0)
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BackgroundTransparency = 0.4
    Line.BorderSizePixel = 0
    Line.Parent = parent
end 
        Button.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do
                p.Visible = false
            end
            Page.Visible = true
        end)

        Page.Visible = #Pages == 0
        table.insert(Pages, Page)
        return tab
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if input.KeyCode == Enum.KeyCode.RightShift and not gp then
            Holder.Visible = not Holder.Visible
        end
    end)

    return ui
end

return setmetatable({}, SkUI)
