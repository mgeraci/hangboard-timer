module.exports = {
	states: {
		get_ready: "get_ready"
		stopped: "stopped"
		hang: "hang"
		rest: "rest"
	}

	phrases: {
		get_ready: "Get ready..."
		stopped: "Stopped"
		hang: "Hang"
		rest: "Rest"
	}

	defaults: {
		hang: 2000
		rest: 1000
		get_ready: 5000
		reps: 2
	}

	# how frequently the app should update
	intervalTime: 50
}
