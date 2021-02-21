function onLoad()
    log('mod loaded')

    settings = nil
    songs = nil

    songpack = nil

    --readTextfileFromDropbox('dhhxbigv2yht6nl/_settings.txt')
    --readFromGoogleSheet('1QJ_m8eYJLbDKLeSmEkdQZ8WJbEVuFAj6iVCIElMZy3E', 'songs')

end

function readTextfileFromDropbox(key)
    local url = 'https://www.dropbox.com/s/' .. key .. '?dl=1'             
    WebRequest.get(url, function(webReturn)
        log(webReturn.text)
    end)
end

function readFromGoogleSheet(key, sheet)
    local url = 'https://docs.google.com/spreadsheets/d/' .. key .. '/gviz/tq?tqx=out:csv&sheet=' .. sheet
    WebRequest.get(url, function(webReturn)
        log(webReturn.text)
    end)
end

-- Reads the main settings file
-- Waits for the reading to finish, then executes readSettings_Finished
function readSettings(url)
    broadcastToAll('Reading Settings, please wait...')

    -- Condition function for WAIT
    local settingsReady = function() 
            if (settings == nil) then
                return false
            else
                return true
            end
        end

    -- function to run upon timeout of WAIT
    local settingsTimeout = function()
            broadcastToAll('Reading Settings timed out!')
        end

    -- this is the function which will need to be waited for
    WebRequest.get(url, function(webReturn)
            local json = JSON.decode(webReturn.text)
            settings = json
        end)

    Wait.condition(readSettings_Finished, settingsReady, 5, settingsTimeout)
end

-- is being executed when readSettings is finished
function readSettings_Finished() 
    broadcastToAll('Settings read successfully')
    broadcastToAll('Welcome to ' .. settings.name)

    readSongs(settings.songList)
end


-- Reads the songlist from the settings into TTS
-- Waits for the reading to be finished, then executes readSongs_Finished
function readSongs(url)
    broadcastToAll('Reading Songs, please wait...')

    local songsReady = function()
            if (songs == nil) then
                return false
            else
               return true 
            end
        end

    local songsTimeout = function()
            broadcastToAll('Reading Songs timed out!')
        end

    WebRequest.get(url, function(webReturn)
            --log(webReturn.text)
            local json = JSON.decode(webReturn.text)
            songs = json
        end)

    Wait.condition(readSongs_Finished, songsReady, 5, songsTimeout)
end

-- Is being executed when readSongs is finished
function readSongs_Finished()
    broadcastToAll('Read ' .. #songs .. ' Songs successfully')
end


function playSong(song)
    MusicPlayer.setCurrentAudioclip(song)
    MusicPlayer.play()
end


-- DEBUG FUNCTIONS
function logSettings()
    log(settings)
end

function readSettingsDEBUG()
    -- readSettings('https://www.dropbox.com/s/dhhxbigv2yht6nl/_settings.json?dl=1')
    Songpack_loadFromURL('https://www.dropbox.com/s/65nibcmdmb1h9ck/_songpack.json?dl=1')
end

function PlayTrack1()
    playSong(songs[1])
end

function PlayTrack2()
    playSong(songs[2])
end

function PlayTrack3()
    playSong(songs[3])
end

function Memory_placeTile()
    Memory_spawnTiles(3, 2)
end