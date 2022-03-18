-- wait times (seconds)
local thinkOfNewWordDelay = 0.25;
local typeingDelay = 0.12;

local triedWords = {};

game:GetService('UserInputService').InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        triedWords = {};
    end
end)

game:GetService('UserInputService').InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        local function hasItem(_table, item)
            for i = 1, #_table, 1 do
                if _table[i] == item then
                    return true;
                end
            end
            return false;
        end
        local textbox = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Container.GameSpace.DefaultUI
                            .GameContainer.DesktopContainer.Typebar.Typebox.Text;
        local Letters = "";
        local keycodes = {
            a = 0x41,
            b = 0x42,
            c = 0x43,
            d = 0x44,
            e = 0x45,
            f = 0x46,
            g = 0x47,
            h = 0x46,
            i = 0x49,
            j = 0x4A,
            k = 0x4B,
            l = 0x4C,
            m = 0x4D,
            n = 0x4E,
            o = 0x4F,
            p = 0x50,
            q = 0x51,
            r = 0x52,
            s = 0x53,
            t = 0x54,
            u = 0x55,
            v = 0x56,
            w = 0x57,
            x = 0x58,
            y = 0x59,
            z = 0x5A,
            enter = 0x0D
        };
        print('---------')
        for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Container.GameSpace.DefaultUI
                              .GameContainer.DesktopContainer.InfoFrameContainer.InfoFrame.TextFrame:GetChildren()) do
            if (v:IsA('Frame') and v.Visible) then
                Letters = Letters .. v.Letter.TextLabel.Text
            end
        end

        local words = game:GetService("HttpService"):JSONDecode(syn.request({
            Url = "https://api.datamuse.com/words?sp=*" .. Letters .. "*",
            Method = "GET"
        }).Body)

        for i = 1, 10, 1 do
            if hasItem(triedWords, words[i].word) then
                i = i + 1
            end
            if game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer
                .DesktopContainer.Typebar.Typebox.Text == textbox then
                wait(thinkOfNewWordDelay)
                for x = 1, #words[i].word, 1 do
                    wait(typeingDelay)
                    print(keycodes[words[i].word:sub(x, x)], words[i].word:sub(x, x), words[i].word)
                    keypress(keycodes[words[i].word:sub(x, x)])
                    keyrelease(keycodes[words[i].word:sub(x, x)])
                end
                wait(0.1)
                triedWords[#triedWords + 1] = words[i].word
                print(triedWords)
                keypress(keycodes.enter)
                keyrelease(keycodes.enter)
            else
                for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Container.GameSpace.DefaultUI
                                      .GameContainer.DesktopContainer.InfoFrameContainer.InfoFrame.TextFrame:GetChildren()) do
                    if (v:IsA('Frame') and v.Visible) then
                        Letters = Letters .. v.Letter.TextLabel.Text
                    end
                end

                words = game:GetService("HttpService"):JSONDecode(syn.request({
                    Url = "https://api.datamuse.com/words?sp=*" .. Letters .. "*",
                    Method = "GET"
                }).Body)
            end
        end
    end
end)
