#Spec: {
	app:  #NonEmptyString
	base: bool
	channels: [...#Channels]
}

#Channels: {
	name: #NonEmptyString
	build_status?: {
		ts?:     #DateRFC3339OrEmptyString
		success: bool
	}
	platforms: [...#AcceptedPlatforms]
	stable: bool
	tests: {
		enabled: bool
		type:    =~"^(cli|web)$"
	}
}

#NonEmptyString:           string & !=""
#AcceptedPlatforms:        "linux/amd64" | "linux/arm64"
#DateRFC3339:              string & =~"^((?:([0-9]{4}-[0-9]{2}-[0-9]{2}) ([0-9]{2}:[0-9]{2}:[0-9]{2}(?:.[0-9]+)?))(Z|[+-][0-9]{2}:[0-9]{2})?)$"
#DateRFC3339OrEmptyString: "" | #DateRFC3339
