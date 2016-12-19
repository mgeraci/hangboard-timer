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
		hang: 10000
		rest: 5000
		get_ready: 5000
		reps: 6
		recover: 3 * 60 * 1000 # 3 minutes
	}

	# how frequently the app should update
	intervalTime: 50

	formKeys: ["hang", "rest", "reps", "recover"]

	localstorageKey: "formValues"
}
