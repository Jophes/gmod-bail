local LOADSTAT_LOADED = 1
local LOADSTAT_BLACKLISTED = 2
local LOADSTAT_TOCLIENT = 3
local LOADSTAT_ERROR = 4

local tableColor = Color(175,175,175)
local fileNameColor = Color(225,225,225)
local blacklistedColor = Color(255,45,20)
local sendtoClientColor = Color(255,141,10)
local loadedColor = Color(20,225,40)
local errorColor = Color(225, 65, 10)
local LOADSTAT_Cols = {{col=loadedColor,msg="LOADED       "},{col=blacklistedColor,msg="BLACKLISTED  "},{col=sendtoClientColor,msg="SENTTOCLIENT "},{col=errorColor,msg="ERROR         "}}

function loadingPrintTable(tableData,headerMessage)
    local longestFileName = 0
    for k,v in pairs(tableData) do
        if #(v.luaFileLocation) > longestFileName then longestFileName = #(v.luaFileLocation) end
    end
    local spacer = ""
    for i = 1,(longestFileName+16) do spacer = spacer.."-" end
    MsgC(tableColor,"╔"..spacer.."╗\n")
    if #(headerMessage) < (longestFileName+16) then for i = 1,((longestFileName+16) - #headerMessage) do headerMessage = headerMessage.." " end end
    MsgC(tableColor,"║",fileNameColor,headerMessage,tableColor,"║\n")
    MsgC(tableColor,"╠"..spacer.."╣\n")
    for k,v in pairs(tableData) do
        if CLIENT then if v.loadStatus == 3 then v.loadStatus = 1 end end
        if #(v.luaFileLocation) < longestFileName then for i = 1,(longestFileName - #v.luaFileLocation) do v.luaFileLocation = v.luaFileLocation.." " end end
        MsgC(tableColor,"║",fileNameColor,v.luaFileLocation,tableColor," - ",LOADSTAT_Cols[v.loadStatus].col,LOADSTAT_Cols[v.loadStatus].msg,tableColor,"║\n")
    end
    MsgC(tableColor,"╚"..spacer.."╝\n")
end

local function findLUAFiles(luaDir, folderBlackList, fileBlackList)
    local files, folders = file.Find(luaDir, "LUA")
    local currentDirectory = string.Replace(luaDir, "/*", "")
    local clientFiles, serverFiles = {}, {}
    for k, v in pairs(files) do
        local currentFileDir = (currentDirectory .. "/" .. v)
        local currentFileBlacklisted = false
        for i, j in pairs(fileBlackList) do
            if currentFileDir == j then currentFileBlacklisted = true; break; end
        end
        if not currentFileBlacklisted then
            if string.StartWith(v,"cl_") or string.StartWith(v,"sh_") or string.find(currentDirectory, "client") or string.find(currentDirectory, "shared") then
                table.insert(clientFiles,{luaFileLocation = currentFileDir, loadStatus = LOADSTAT_TOCLIENT})
            end
            if string.StartWith(v,"sv_") or string.StartWith(v,"sh_") or string.find(currentDirectory, "server") or string.find(currentDirectory, "shared") then
                table.insert(serverFiles,{luaFileLocation = currentFileDir, loadStatus = LOADSTAT_LOADED})
            end
        else
            table.insert(serverFiles, {luaFileLocation = currentFileDir, loadStatus = LOADSTAT_BLACKLISTED})
        end
    end
    
    for k,v in pairs(folders) do
        local currentFolderDir = (currentDirectory .. "/" .. v)
        local currentFolderBlacklisted = false
        for i,j in pairs(folderBlackList) do
            if currentFolderDir == j then currentFolderBlacklisted = true; break; end
        end
        if not currentFolderBlacklisted then
            local returnClientFiles, returnServerfiles = findLUAFiles(currentFolderDir.."/*", folderBlackList, fileBlackList)
            for i,j in pairs(returnClientFiles) do
                table.insert(clientFiles, j)
            end
            for i,j in pairs(returnServerfiles) do
                table.insert(serverFiles, j)
            end
        end
    end
    return clientFiles, serverFiles
end

local function loadLUAFiles(luaDir, folderBlackList, fileBlackList, loadMessage)
    local clFiles, svFiles = findLUAFiles(luaDir, folderBlackList, fileBlackList)
    if SERVER then
        for k,v in pairs(clFiles) do
            AddCSLuaFile(v.luaFileLocation)
        end
        for k,v in pairs(svFiles) do
            include(v.luaFileLocation)
        end
        local allFiles = svFiles
        for k,v in pairs(clFiles) do table.insert(allFiles, v) end
        loadingPrintTable(allFiles, loadMessage)
    elseif CLIENT then
        for k,v in pairs(clFiles) do
            include(v.luaFileLocation)
        end
        loadingPrintTable(clFiles, loadMessage)
    end
end

loadLUAFiles("bail/*", {}, {["1"]="bail/shared/config.lua"}, "Bail System") 