C = require("./constants.coffee")

module.exports = {
	init: ->
		@storage = false

		try
			d = new Date
			window.localStorage.setItem(d, d)
			result = window.localStorage.getItem(d) == d
			window.localStorage.removeItem(d)
			@storage = window.localStorage
		catch

	set: (bundle) ->
		return if !@storage

		@storage.setItem(
			C.localstorageKey,
			JSON.stringify(bundle)
		)

	get: ->
		return false if !@storage

		bundle = @storage.getItem(C.localstorageKey)
		bundle = JSON.parse(bundle)
		return bundle
}
