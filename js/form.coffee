$ = require("jquery")
C = require("./constants.coffee")
localstorage = require("./localstorage.coffee")

module.exports = {
	init: ->
		localstorage.init()

		@dom = {}

		for formKey in C.formKeys
			@dom[formKey] = $("input[name=#{formKey}]")

		@setInitialValues()
		@listen()

	setInitialValues: ->
		bundle = localstorage.get()

		for formKey in C.formKeys
			if bundle?[formKey]?
				defaultValue = bundle[formKey]
			else
				defaultValue = C.defaults[formKey]

			if formKey != "reps"
				defaultValue = defaultValue / 1000

			@dom[formKey].val(defaultValue)

	listen: ->
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

		localstorage.set(@getValues())

	getValues: ->
		res = {}

		for formKey in C.formKeys
			value = @dom[formKey].val()
			value = parseInt(value, 10)

			if formKey != "reps"
				value = value * 1000

			res[formKey] = value

		return res
}
