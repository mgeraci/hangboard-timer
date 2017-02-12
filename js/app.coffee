Card = require("./card.coffee")
C = require("./constants.coffee")
Dom = require("./dom.coffee")
Form = require("./form.coffee")
Sound = require("./sound.coffee")

FastClick = require("fastclick")

window.hangboardTimer = {
	# defaults for constants
	reps: C.defaults.reps
	times: {
		hang: C.defaults[C.states.hang]
		rest: C.defaults[C.states.rest]
		get_ready: C.defaults[C.states.get_ready]
		recover: C.defaults[C.states.recover]
	}

	# vars used on a per-exercise basis
	startTimestamp: null
	currentRep: null
	currentState: C.states.stopped

	playSound: true

	init: ->
		Dom.init()
		Form.init()
		FastClick.attach(document.body)

		if @playSound
			Sound.init()

		Dom.start.on("click tap", =>
			@start()

			# a sound trigger is required on the start button click, otherwise iOS
			# blocks it as "autoplay" sound
			if @playSound
				Sound.playBeep()
		)

		Dom.stop.on("click tap", =>
			@stop()
		)

	start: ->
		# fetch the values from the form
		formValues = Form.getValues()
		@times[C.states.hang] = formValues[C.states.hang]
		@times[C.states.rest] = formValues[C.states.rest]
		@times[C.states.recover] = formValues[C.states.recover]
		@reps = formValues.reps

		@startTimestamp = Date.now()
		@triggerNextState()
		@currentRep = 0
		Dom.stages.setup.removeClass(Dom.activeClass)
		Dom.stages.play.addClass(Dom.activeClass)

		@interval = setInterval(=>
			@update()
		, C.intervalTime)

	stop: ->
		@startTimestamp = null
		@currentRep = null
		@currentState = C.states.stopped
		@card.destroy()
		Dom.stages.play.removeClass(Dom.activeClass)
		Dom.stages.setup.addClass(Dom.activeClass)

		if @interval?
			clearInterval(@interval)

	update: ->
		now = Date.now()

		if @startTimestamp?
			elaspedTime = now - @startTimestamp
		else
			elaspedTime = 0

		stateDuration = @times[@currentState]

		if @currentRep? && @currentRep > 0
			rep = "rep #{@currentRep}/#{@reps}"

		@card.update({
			time: elaspedTime
			timeGoal: stateDuration
			status: @currentState
			rep: rep
		})

		if elaspedTime > stateDuration
			@triggerNextState(now)

	triggerNextState: (stateStartTime = Date.now()) ->
		nextState = @getNextState()

		@card?.destroy()

		# beep, unless it's just beginning
		if @playSound && nextState == C.states.stopped
			Sound.playEndBeep()
		else if @playSound && nextState == C.states.recover
			Sound.playEndBeep()
		else if @playSound && nextState != C.states.get_ready
			Sound.playBeep()

		# short circuit if we hit the end state
		if nextState == C.states.stopped
			@stop()
			return

		@card = new Card()
		@startTimestamp = stateStartTime
		@currentState = nextState

		# if we're starting a new rep, increment the current rep count
		if nextState == C.states.hang
			@currentRep++

	getNextState: ->
		if @currentState == C.states.stopped
			nextState = C.states.get_ready
		else if @currentState == C.states.get_ready
			nextState = C.states.hang
		else if @currentState == C.states.rest
			nextState = C.states.hang
		else if @currentState == C.states.hang
			if @currentRep < @reps
			  nextState = C.states.rest
			else
			  nextState = C.states.recover
		else
			nextState = C.states.stopped

		return nextState
}
