$ = require("jquery")
C = require("./constants.coffee")
Dom = require("./dom.coffee")

Card = class Card
	# this must match $angle-count in css/stage_play.sass
	angleCount: 10

	constructor: ->
		@el = $(@template())
		Dom.stages.play.prepend(@el)
		@time = @el.find(".card-time")
		@status = @el.find(".card-status")
		@rep = @el.find(".card-rep")

		if state?
			@update(state)

	template: ->
		return """
			<div class="card">
				<span class="card-status"></span>
				<span class="card-time"></span>
				<span class="card-rep"></span>
			</div>
		"""

	update: (nextState) ->
		return if !nextState?

		if @state?.time != nextState.time && nextState.timeGoal
			time = @formatCountdown(nextState.time, nextState.timeGoal)
			@time.text(time)

		if @state?.status != nextState.status
			@el.addClass("card--#{nextState.status}")
			text = C.phrases[nextState.status]
			@status.text(text)

		if @state?.rep != nextState.rep
			@rep.text(nextState.rep)

		@state = nextState

	destroy: ->
		i = Math.floor(Math.random() * @angleCount)
		@el.addClass("card--is-leaving-#{i}")

		setTimeout(=>
			@el.remove()
		, 1000)

	formatCountdown: (current, goal) ->
		remaining = goal - current

		# keep in bounds
		if remaining < 0
			remaining = 0

		remaining = "#{remaining / 1000}"

		# make zero counts look good by adding more zeros at the end
		if remaining.indexOf(".") < 0
			remaining = "#{remaining}.000"

		remaining = remaining.split(".")

		# pad the zeros so that the number doesn't jump around as much
		while remaining[1].length < 3
			remaining[1] = "#{remaining[1]}0"

		return remaining.join(":")

module.exports = Card
