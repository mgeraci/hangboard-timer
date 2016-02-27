$ = require("jquery")

module.exports = {
	activeClass: "stage--active"

	init: ->
		@start = $("#start")
		@stop = $("#stop")
		@stages = {
			all: $(".stage")
			setup: $(".stage-setup")
			play: $(".stage-play")
		}
}
