$ = require("jquery")

Card = class Card
	constructor: (timestamp, state) ->
		console.log 'card constructor'
		@id = timestamp

		@el = $(@template())
		$("body").append(@el)
		@time = @el.find(".card-time")
		@status = @el.find(".card-status")
		@rep = @el.find(".card-rep")

		if state?
			@update(state)

	update: (nextState) ->
		return if !nextState?

		if @state?.time != nextState.time && nextState.timeGoal
			time = @formatCountdown(nextState.time, nextState.timeGoal)
			@time.text(time)

		if @state?.status != nextState.status
			@status.text(nextState.status)

		if @state?.rep != nextState.rep
			@rep.text(nextState.rep)

		@state = nextState

	destroy: ->
		@el.remove()

	template: ->
		return """
			<div id="card" class="card">
				<span class="card-time"></span>
				<span class="card-status"></span>
				<span class="card-rep"></span>
			</div>
		"""

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

module.exports = Card
