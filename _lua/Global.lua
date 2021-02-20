function onLoad()
    log('mod loaded')

    readTextfileFromDropbox('dhhxbigv2yht6nl/_settings.txt')
    
    readFromGoogleSheet('1QJ_m8eYJLbDKLeSmEkdQZ8WJbEVuFAj6iVCIElMZy3E', 'songs')
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