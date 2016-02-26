$ = require("jquery")
Card = require("./card.coffee")

window.hangboardTimer = {
	# defaults for constants
	reps: 2
	times: {
		hang: 4000
		rest: 2000
	}

	states: {
		stopped: "stopped"
		hang: "hang"
		rest: "rest"
	}

	# how frequently the app should update
	intervalTime: 50

	# vars used on a per-exercise basis
	startTimestamp: null
	currentRep: null
	currentState: null

	init: ->
		@currentState = @states.stopped

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
		@currentState = @states.stopped
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
			if nextState == @states.stopped
				@stop()
				return

			@startTimestamp = now
			@currentState = nextState

			# if we're starting a new rep, increment the current rep count
			if nextState == @states.hang
				@currentRep++

	getNextState: ->
		console.log "getNextState", @currentRep, @reps
		if @currentState == @states.stopped
			return @states.rest
		if @currentState == @states.rest
			return @states.hang
		else if @currentState == @states.hang && @currentRep < @reps
			return @states.rest
		else
			return @states.stopped
}
