$ = require("jquery")
Card = require("./card.coffee")
C = require("./constants.coffee")

window.hangboardTimer = {
	# defaults for constants
	reps: 2
	times: {
		hang: 2000
		rest: 1000
		get_ready: 2000
	}

	# how frequently the app should update
	intervalTime: 50

	# vars used on a per-exercise basis
	startTimestamp: null
	currentRep: null
	currentState: null

	init: ->
		@currentState = C.states.stopped

		$("#start").click(=>
			@start()
		)

		$("#stop").click(=>
			@stop()
		)

	start: ->
		@startTimestamp = Date.now()
		@currentState = @getNextState()
		@currentRep = 0

		@interval = setInterval(=>
			@update()
		, @intervalTime)

	stop: ->
		@startTimestamp = null
		@currentRep = null
		@currentState = C.states.stopped
		@card.destroy()

		if @interval?
			clearInterval(@interval)

	update: ->
		now = Date.now()
		elaspedTime = now - @startTimestamp
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
			nextState = @getNextState()

			# short circuit if we hit the end state
			if nextState == C.states.stopped
				@stop()
				return

			@startTimestamp = now
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
		else if @currentState == C.states.hang && @currentRep < @reps
			nextState = C.states.rest
		else
			nextState = C.states.stopped

		console.log "getNextState, current state: #{@currentState}", @currentRep, @reps
		console.log "next state: #{nextState}"

		@card?.destroy()

		if nextState != C.states.stopped
			@card = new Card()

		return nextState
}
