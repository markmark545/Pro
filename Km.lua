local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("TITLE", "DarkTheme")
 
 
 
local Tab = Window:NewTab("?")
local Section = Tab:NewSection("Walkspeed")
 
Section:NewButton("increse speed", "ButtonInfo", function(c)
    print("Clicked")
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)
------------------------
Section:NewToggle("increse speed",""  ,function(state)
    if state then
        print("Toggle On")
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        print("Toggle Off")
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
    end
end)
 
-----------------------
Section:NewSlider("change speed", "SliderInfo", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
---------------------
Section:NewTextBox("speed", "TextboxInfo", function(txt)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = txt
end)
---------------------------
Section:NewKeybind("ย่อ", "KeybindInfo", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)
