#Spec: {
  app: #NonEmptyString
  base: bool
  channels:     [#Channels]
}

#Channels: {
  name: #NonEmptyString
  build_status: {
    ts: #NonEmptyString
    success: bool
  }
  platforms: [...#NonEmptyString]
  stable: bool
  tests: {
    enabled: bool
    type: =~"^(cli|web)$"
  }
}

#NonEmptyString: string & !=""
