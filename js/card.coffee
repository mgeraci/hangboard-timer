$ = require("npm-zepto")
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
			@time.html(time)

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
		time = goal - current

		# keep in bounds
		if time < 0
			time = 0

		time = "#{time / 1000}"

		# make counts that divide evenly look good by adding more zeros at the end
		if time.indexOf(".") < 0
			time = "#{time}.000"

		time = time.split(".")

		# if we're over a single digit time, don't show the milliseconds
		if time[0] > 9
			return time[0]

		# pad the zeros so that the number doesn't jump around as much
		while time[1].length < 3
			time[1] = "#{time[1]}0"

		return time.join("<span class='colon'>:</span>")

module.exports = Card
