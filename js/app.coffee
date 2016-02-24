$ = require("jquery")

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

		@dom = {}
		@dom.time = $("#time")
		@dom.state = $("#state")
		@dom.rep = $("#rep")
		@dom.state.text(@currentState)

		$("#start").click(=>
			@start()
		)

		$("#stop").click(=>
			@stop()
		)

	start: ->
		console.log 'starting'
		@startTimestamp = Date.now()
		@currentState = @getNextState()
		@dom.rep.text("get ready...")
		@currentRep = 0

		@interval = setInterval(=>
			@update()
		, @intervalTime)

	stop: ->
		@startTimestamp = null
		@currentRep = null
		@currentState = @states.stopped
		@dom.rep.text("")
		@dom.state.text(@states.stopped)

		if @interval?
			clearInterval(@interval)

	update: ->
		now = Date.now()
		elaspedTime = now - @startTimestamp
		stateDuration = @times[@currentState]
		formattedTime = @formatCountdown(elaspedTime, stateDuration)

		@dom.time.text(formattedTime)
		@dom.state.text(@currentState)

		if @currentRep? && @currentRep > 0
			@dom.rep.text("rep #{@currentRep}/#{@reps}")

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

	formatCountdown: (current, goal) ->
		remaining = goal - current

		# keep in bounds
		if remaining < 0
			remaining = 0

		remaining = "#{remaining / 1000}"

		# make zero counts look good by adding more zeros at the end
		if remaining.indexOf(".") < 0
			remaining = "#{remaining}.000"

		remaining = remaining.split(".").join(":")

		return remaining
}
