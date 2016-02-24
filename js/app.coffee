$ = require("jquery")

window.hangboardTimer = {
	# defaults for constants
	hangTime: 10000
	restTime: 5000
	reps: 6

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
		@dom.state.text(@currentState)

		$("#start").click(=>
			@start()
		)

	start: ->
		console.log 'starting'
		@startTimestamp = Date.now()
		@currentState = @getNextState()

		@interval = setInterval(=>
			@update()
		, @intervalTime)

	stop: ->
		@startTimestamp = null
		@currentRep = null
		@currentState = @getNextState()

		if @interval?
			clearInterval(@interval)

	update: ->
		now = Date.now()
		elaspedTime = now - @startTimestamp
		formattedTime = @formatCountdown(elaspedTime, @restTime)

		@dom.time.text(formattedTime)
		@dom.state.text(@currentState)

		if elaspedTime > @restTime
			console.log 'at end'
			@stop()

	getNextState: ->
		if @currentState == @states.stopped
			return @states.rest
		if @currentState == @states.rest
			return @states.hang
		else if @currentState == @states.hang && @currentRep < @reps
			return @states.rest
		else
			return @states.stop

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
