$ = require("jquery")
C = require("./constants.coffee")

module.exports = {
	init: ->
		@hang = $("input[name=hang]")
		@rest = $("input[name=rest]")
		@reps = $("input[name=reps]")

		@hang.val(C.defaults.hangTime / 1000)
		@rest.val(C.defaults.restTime / 1000)
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

		if value < 0
			value = 0

		field.val(value)
}
