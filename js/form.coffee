$ = require("jquery")
C = require("./constants.coffee")

module.exports = {
	init: ->
		@hang = $("input[name=hang]")
		@rest = $("input[name=rest]")
		@reps = $("input[name=reps]")

		@hang.val(C.defaults[C.states.hang] / 1000)
		@rest.val(C.defaults[C.states.rest] / 1000)
		@reps.val(C.defaults.reps)

		$(".taptime-button").on("click tap", (e) =>
			button = $(e.currentTarget)
			field = button.closest(".taptime").find("input")

			if button.hasClass("taptime-button--increment")
				direction = "increment"
			else
				direction = "decrement"

			@changeValue(field, direction)
		)

	changeValue: (field, direction) ->
		value = field.val()

		if direction == "increment"
			value++
		else
			value--

		if value < 1
			value = 1

		field.val(value)

	getValues: ->
		res = {}
		res[C.states.hang] = parseInt(@hang.val(), 10) * 1000
		res[C.states.rest] = parseInt(@rest.val(), 10) * 1000
		res.reps = parseInt(@reps.val(), 10)

		return res
}
