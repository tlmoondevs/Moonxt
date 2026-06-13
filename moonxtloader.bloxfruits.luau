local Config = {
	Text = "Moon Hub Exploit Beyond Limits",
	TextColor = Color3.fromRGB(255, 255, 255),
	AccentColor = Color3.fromRGB(100, 150, 255),
	GlowColor = Color3.fromRGB(100, 150, 255),
	SpinnerImage = "rbxassetid://5997493433",
	SpinnerSpeed = 2.5,
	ProgressBarHeight = 12,
	ProgressBarWidth = 320,
	CornerRadius = UDim.new(0, 14),
	Font = Enum.Font.GothamBlack,
	TextSize = 32,
	PercentageTextSize = 18,
	FadeOutDuration = 0.6,
	MinimumLoadTime = 3,   -- seconds the loader will always stay visible
	SimulatedLoadTime = 4, -- fallback if real progress isn't available
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonHubLoading"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ========================
--  BACKGROUND & SCANLINES
-- ========================
local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
background.BackgroundTransparency = 0.4
background.BorderSizePixel = 0
background.Parent = screenGui

local scanlines = Instance.new("ImageLabel")
scanlines.Size = UDim2.fromScale(1, 1)
scanlines.BackgroundTransparency = 1
scanlines.Image = "rbxassetid://748758765"
scanlines.ImageTransparency = 0.85
scanlines.ScaleType = Enum.ScaleType.Tile
scanlines.TileSize = UDim2.fromOffset(4, 4)
scanlines.ZIndex = 1
scanlines.Parent = screenGui

-- ========================
--  CENTERED PANEL
-- ========================
local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.fromOffset(440, 230)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
panel.BackgroundTransparency = 0.15
panel.BorderSizePixel = 0
panel.ZIndex = 2
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = Config.CornerRadius
panelCorner.Parent = panel

local panelGlow = Instance.new("Frame")
panelGlow.AnchorPoint = Vector2.new(0.5, 0.5)
panelGlow.Position = UDim2.fromScale(0.5, 0.5)
panelGlow.Size = UDim2.fromOffset(450, 240)
panelGlow.BackgroundColor3 = Config.GlowColor
panelGlow.BackgroundTransparency = 0.9
panelGlow.BorderSizePixel = 0
panelGlow.ZIndex = 0
panelGlow.Parent = screenGui

local panelGlowCorner = Instance.new("UICorner")
panelGlowCorner.CornerRadius = Config.CornerRadius
panelGlowCorner.Parent = panelGlow

-- ========================
--  SPINNER (with glow)
-- ========================
local spinnerGlow = Instance.new("ImageLabel")
spinnerGlow.AnchorPoint = Vector2.new(0.5, 0)
spinnerGlow.Position = UDim2.fromScale(0.5, 0.15)
spinnerGlow.Size = UDim2.fromOffset(70, 70)
spinnerGlow.BackgroundTransparency = 1
spinnerGlow.Image = Config.SpinnerImage
spinnerGlow.ImageColor3 = Config.GlowColor
spinnerGlow.ImageTransparency = 0.7
spinnerGlow.ZIndex = 3
spinnerGlow.Parent = panel

local spinner = Instance.new("ImageLabel")
spinner.AnchorPoint = Vector2.new(0.5, 0)
spinner.Position = UDim2.fromScale(0.5, 0.17)
spinner.Size = UDim2.fromOffset(55, 55)
spinner.BackgroundTransparency = 1
spinner.Image = Config.SpinnerImage
spinner.ImageColor3 = Config.AccentColor
spinner.ZIndex = 4
spinner.Parent = panel

-- ========================
--  TITLE (with glow)
-- ========================
local titleGlow = Instance.new("TextLabel")
titleGlow.AnchorPoint = Vector2.new(0.5, 0.5)
titleGlow.Position = UDim2.fromScale(0.5, 0.5)
titleGlow.Size = UDim2.fromOffset(340, 50)
titleGlow.BackgroundTransparency = 1
titleGlow.Text = Config.Text
titleGlow.TextColor3 = Config.GlowColor
titleGlow.Font = Config.Font
titleGlow.TextSize = Config.TextSize
titleGlow.TextTransparency = 0.6
titleGlow.TextScaled = true
titleGlow.ZIndex = 3
titleGlow.Parent = panel

local title = Instance.new("TextLabel")
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Position = UDim2.fromScale(0.5, 0.51)
title.Size = UDim2.fromOffset(330, 45)
title.BackgroundTransparency = 1
title.Text = Config.Text
title.TextColor3 = Config.TextColor
title.Font = Config.Font
title.TextSize = Config.TextSize
title.TextScaled = true
title.ZIndex = 4
title.Parent = panel

-- ========================
--  PROGRESS BAR
-- ========================
local progressBg = Instance.new("Frame")
progressBg.AnchorPoint = Vector2.new(0.5, 0)
progressBg.Position = UDim2.fromScale(0.5, 0.72)
progressBg.Size = UDim2.fromOffset(Config.ProgressBarWidth, Config.ProgressBarHeight)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBg.BackgroundTransparency = 0.4
progressBg.BorderSizePixel = 0
progressBg.ZIndex = 4
progressBg.Parent = panel

local progressBgCorner = Instance.new("UICorner")
progressBgCorner.CornerRadius = UDim.new(0, Config.ProgressBarHeight/2)
progressBgCorner.Parent = progressBg

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.fromScale(0, 1)
progressFill.BackgroundColor3 = Config.AccentColor
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 5
progressFill.Parent = progressBg

local progressFillCorner = Instance.new("UICorner")
progressFillCorner.CornerRadius = UDim.new(0, Config.ProgressBarHeight/2)
progressFillCorner.Parent = progressFill

-- Gradient effect
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Config.GlowColor),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Config.AccentColor),
})
gradient.Rotation = 90
gradient.Parent = progressFill

-- ========================
--  PERCENTAGE LABEL
-- ========================
local percentageLabel = Instance.new("TextLabel")
percentageLabel.AnchorPoint = Vector2.new(0.5, 0)
percentageLabel.Position = UDim2.fromScale(0.5, 0.8)
percentageLabel.Size = UDim2.fromOffset(100, 24)
percentageLabel.BackgroundTransparency = 1
percentageLabel.Text = "0%"
percentageLabel.TextColor3 = Config.TextColor
percentageLabel.Font = Enum.Font.GothamBold
percentageLabel.TextSize = Config.PercentageTextSize
percentageLabel.TextTransparency = 0.2
percentageLabel.ZIndex = 4
percentageLabel.Parent = panel

-- ========================
--  PULSING ANIMATIONS
-- ========================
TweenService:Create(spinnerGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	ImageTransparency = 0.3
}):Play()

TweenService:Create(titleGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	TextTransparency = 0.3
}):Play()

-- Spinner rotation
local spinnerStart = tick()
RunService.RenderStepped:Connect(function()
	local angle = ((tick() - spinnerStart) * 360 * Config.SpinnerSpeed) % 360
	spinner.Rotation = angle
	spinnerGlow.Rotation = angle
end)

-- ========================
--  LOADING LOGIC (WITH MINIMUM DISPLAY TIME)
-- ========================
local scriptStarted = tick()
local loadingDone = false

local function updateDisplay(fraction)
	fraction = math.clamp(fraction, 0, 1)
	progressFill.Size = UDim2.fromScale(fraction, 1)
	percentageLabel.Text = string.format("%d%%", math.floor(fraction * 100))
end

local function finish()
	if loadingDone then return end
	loadingDone = true
	updateDisplay(1)

	local fadeObjects = {background, scanlines, panelGlow, panel, spinnerGlow, spinner, titleGlow, title, progressBg, progressFill, percentageLabel}
	local tweenInfo = TweenInfo.new(Config.FadeOutDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweens = {}
	for _, obj in ipairs(fadeObjects) do
		local goals = {}
		if obj:IsA("TextLabel") then
			goals.TextTransparency = 1
		elseif obj:IsA("ImageLabel") then
			goals.ImageTransparency = 1
			goals.BackgroundTransparency = 1
		elseif obj:IsA("Frame") then
			goals.BackgroundTransparency = 1
		end
		local t = TweenService:Create(obj, tweenInfo, goals)
		t:Play()
		table.insert(tweens, t)
	end
	tweens[1].Completed:Wait()
	screenGui:Destroy()

	-- Run the target script
	repeat task.wait() until game:IsLoaded()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tlmoondevs/Moonxt/refs/heads/main/bloxfruits.luau"))()
	end)
end

-- Combined progress: respects both real queue and minimum time
local useRealProgress = pcall(function() return ContentProvider.RequestQueueSize end)
local initialQueue = 0
if useRealProgress then
	initialQueue = ContentProvider.RequestQueueSize
end

RunService.Heartbeat:Connect(function()
	if loadingDone then return end

	local elapsed = tick() - scriptStarted
	local minFraction = math.clamp(elapsed / Config.MinimumLoadTime, 0, 1) -- progress from minimum time

	local realFraction = 0
	if useRealProgress and initialQueue > 0 then
		local current = ContentProvider.RequestQueueSize
		realFraction = 1 - (current / initialQueue)
	elseif not useRealProgress then
		realFraction = math.clamp(elapsed / Config.SimulatedLoadTime, 0, 0.99)
	end

	-- Show the slower of the two (minimum time always fills at least)
	local displayFraction = math.max(minFraction, realFraction)
	updateDisplay(displayFraction)

	-- Finish only when the game is loaded AND the minimum display time has passed
	if game:IsLoaded() and elapsed >= Config.MinimumLoadTime then
		finish()
	end
end)

-- Safety timeout (30 seconds)
task.delay(30, function()
	if not loadingDone then
		warn("MoonHub Loader: 30‑second timeout – forcing finish")
		finish()
	end
end)
