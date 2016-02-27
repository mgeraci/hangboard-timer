$ = require("jquery")
Card = require("./card.coffee")
C = require("./constants.coffee")

window.hangboardTimer = {
	# defaults for constants
	reps: 2
	times: {
		hang: 4000
		rest: 2000
		get_ready: 5000
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
		console.log 'starting'
		@startTimestamp = Date.now()
		@card = new Card()
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
			console.log 'next state:', nextState

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
		console.log "getNextState", @currentRep, @reps
		if @currentState == C.states.stopped
			return C.states.get_ready
		if @currentState == C.states.get_ready
			return C.states.hang
		if @currentState == C.states.rest
			return C.states.hang
		else if @currentState == C.states.hang && @currentRep < @reps
			return C.states.rest
		else
			return C.states.stopped
}
