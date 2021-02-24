function MusicPlayer_play(song)
    MusicPlayer.setCurrentAudioclip(song)
    MusicPlayer.play()
end

function MusicPlayer_isPlaying()
    -- log('isPlaying: ' .. MusicPlayer.player_status)
    if (MusicPlayer.player_status ~= 'Play') then
        return false
    else
        return true
    end
end

function MusicPlayer_isStopped()
    -- log('isStopped: ' .. MusicPlayer.player_status)
    if (MusicPlayer.player_status ~= 'Pause') then
        return false
    else
        return true
    end
end