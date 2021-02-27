function onLoad()
    log('mod loaded')

    loadLangStrings()

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


function none()
    -- used to temporarily remove the click_function from buttons
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
    MusicPlayer_play(songs[1])
end

function PlayTrack2()
    MusicPlayer_play(songs[2])
end

function PlayTrack3()
    MusicPlayer_play(songs[3])
end

function Memory_placeTile()
    Memory_preparePlayingField(3, 3)
end