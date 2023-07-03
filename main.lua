local Task = {}
Task.__index = Task

local HttpService = game:GetService("HttpService")
local SHA2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Egor-Skriptunoff/pure_lua_SHA/master/sha2.lua"))()
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/main/bundle.lua"))().Init(game.CoreGui)

function Task.new(API_HOST, LinkvertiseID, LinkCount, Validator, TokenExpireTime)
    local nTask = {}

    nTask.API_HOST = API_HOST or "s1.wayauth.com"
    nTask.LinkvertiseID = LinkvertiseID or 12345
    nTask.LinkCount = LinkCount or 1
    nTask.Validator = Validator or "Hello!"
    nTask.TokenExpireTime = TokenExpireTime or 0

    return setmetatable(nTask, Task)
end

function Task:create()
    local URLBase = "http://%s/v2/create/%s/%s/%s" -- API_HOST, LinkvertiseID, Validator, LinkCount
    local URL = URLBase:format(self.API_HOST, self.LinkvertiseID, self.Validator, self.LinkCount)
    setclipboard(URL)
    self.task = HttpService:JSONDecode(game:HttpGet(URL))

    return self.task
end
-- /verify/:id/:token/:expirein
function Task:verify()
    local URLBase = "http://%s/v2/verify/%s/%s/%s"
    local URL = URLBase:format(self.API_HOST, self.task.id, self.Validator, self.TokenExpireTime)
    setclipboard(URL)
    return HttpService:JSONDecode(game:HttpGet(URL))
end

function Task:copyURL()
    local URLBase = "http://%s/v2/wait/%s"
    local URL = URLBase:format(self.API_HOST, self.task.id)
    return setclipboard(URL)
end

-- local Task = Task:create()
local nTask = Task.new("146.190.56.164", 12345, 2, "testvalidator", 0)
nTask:create()
local Verified = false

Iris:Connect(function()
    if not Verified then
        Iris.Window({"MikeCash"}) do
            if Iris.Button({"Verify"}).clicked then
                task.spawn(function()
                    local Response = nTask:verify()
                    -- if Response.success then
                    --     if SHA2.sha256("testvalidator") == Response.validator then
                    --         Verified = true
                    --     end
                    -- end
                end)
            end
            if Iris.Button({"Copy Website"}).clicked then
                nTask:copyURL()
            end
            Iris.End()
        end
    end
end)

repeat task.wait() until Verified

warn("Finished!")

-- return Task