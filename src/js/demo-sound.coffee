
$ = require('jquery')
SoundController = require './../../../../CommonLibrary/web/src/SoundController.coffee'


s = new SoundController
  src: ['media/test.ogg', 'media/test.mp3']
  autoplay: false
  preload: true

$ ->
  $('.load').bind 'click', (e)->
    s = new SoundController
      src: 'media/test.mp3'
      autoplay: false
      preload: true
    @

  # Play
  $('.play').bind 'click', (e)->
    e.preventDefault()
    s.play()
    return

  # Pause
  $('.pause').bind 'click', (e)->
    e.preventDefault()
    s.pause()
    return

  # Time Update Event
  s.addListener 'timeupdate', (e, c, d)->
    $('.elapsed').text(c)
    $('.duration').text(d)
    $('.seek').val e.currentTarget.currentTime / e.currentTarget.duration
    return

  # Scrubber Change Handler
  $('.seek').bind 'change mouseup', (e)->
    s.currentTime e.currentTarget.value
    $('.seek').attr('max', e.currentTarget.duration)
    return

  # Volume Change Event
  s.addListener 'volumechange', (e)->
    $('.volume').val e.currentTarget.volume
    $('.volume-label').text e.currentTarget.volume
    return

  # Volume Change Handler
  $('.volume').bind 'change', (e)->
    s.setVolume e.currentTarget.value
    return

  # Fade In Volume
  $('.fadeIn').bind 'click', (e)->
    e.preventDefault()
    s.fadeIn()
    return

  # Fade Out Volume with duration and steps
  $('.fadeOut').bind 'click', (e)->
    e.preventDefault()
    s.fadeOut(10000, 50)
    return

  # Mute
  $('.mute').bind 'click', (e)->
    e.preventDefault()
    s.mute()
    return

  return
