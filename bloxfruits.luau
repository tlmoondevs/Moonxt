local players = game:GetService("Players")
local player = players.LocalPlayer
local user = player.Name
local display = player.DisplayName

local info = {
    ['Username'] = user,
    ['Nickname'] = display,
    ['lvl'] = player:WaitForChild("Data"):WaitForChild("Level").Value,
    ['beli'] = player:WaitForChild("Data"):WaitForChild("Beli").Value,
    ['race'] = player:WaitForChild("Data"):WaitForChild("Race").Value,
    ['statsref'] = player:WaitForChild("Data"):WaitForChild("StatRefunds").Value,
    ['exp'] = player:WaitForChild("Data"):WaitForChild("Exp").Value,
    ['frags'] = player:WaitForChild("Data"):WaitForChild("Fragments").Value,
    ['DefenseStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Defense"):WaitForChild("Level").Value,
    ['MeleStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Melee"):WaitForChild('Level').Value,
    ['GunStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild('Gun'):WaitForChild('Level').Value,
    ['SwordStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild('Sword'):WaitForChild('Level').Value,
    ['FruitStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Demon Fruit"):WaitForChild('Level').Value
}

print(info) -- dont change

local eFolder = game.Workspace:WaitForChild("Enemies")

local admins={
    [1] = 'zioles' or 'rip_zioles',
    [2] = 'Uzoth',
    [3] = 'EnyuZee',
    owners = {
     [1] = 'rip_indra' or 'indra',
     [2] = 'mygame43'
    }
}

local indraIslandCFrame = "-26738.748, 7.49961281, 406.11734, 0.245676473, -4.41590089e-08, 0.969351888, 5.56688136e-08, 1, 3.14462589e-08, -0.969351888, 4.62370622e-08, 0.245676473"
