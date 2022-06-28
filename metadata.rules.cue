#Spec: {
  app: #NonEmptyString
  base: bool
  channels: [...#Channels]
}

#Channels: {
  name: #NonEmptyString
  build_status?: {
    ts: string
    success: bool
  }
  platforms: [...#Platforms]
  stable: bool
  tests: {
    enabled: bool
    type: =~"^(cli|web)$"
  }
}

#NonEmptyString: string & !=""
#Platforms: string & =~"^(linux/(amd64|arm64))$"
