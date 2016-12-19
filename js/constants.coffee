module.exports = {
	states: {
		get_ready: "get_ready"
		stopped: "stopped"
		hang: "hang"
		rest: "rest"
		recover: "recover"
	}

	phrases: {
		get_ready: "Get ready..."
		stopped: "Stopped"
		hang: "Hang"
		rest: "Rest"
		recover: "Recover"
	}

	defaults: {
		# in milliseconds
		hang: 10000
		rest: 5000
		get_ready: 5000

		# no unit
		reps: 6

		# in thousandths of a minute
		recover: 3 * 1000
	}

	# how frequently the app should update
	intervalTime: 50

	formKeys: ["hang", "rest", "reps", "recover"]

	localstorageKey: "formValues"
}
